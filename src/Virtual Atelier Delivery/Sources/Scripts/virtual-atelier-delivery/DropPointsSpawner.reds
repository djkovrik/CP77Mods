module AtelierDelivery

public class AtelierDropPointsSpawner extends ScriptableSystem {
  private let entitySystem: wref<DynamicEntitySystem>;
  private let delaySystem: wref<DelaySystem>;
  private let handled: Bool;
  private let spawnConfig: ref<AtelierDropPointsSpawnerConfig>;
  private let initialCallbackId: DelayID;
  private let dropPointsCallbackId: DelayID;
  private let nightCityUnlocked: Bool = false;
  private let dogtownUnlocked: Bool = false;
  private let typeTag: CName = n"VirtualAtelierDropPoint";

  private let spawnedMappins: ref<inkHashMap>;

  public static func Get(gi: GameInstance) -> ref<AtelierDropPointsSpawner> {
    let system: ref<AtelierDropPointsSpawner> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.AtelierDropPointsSpawner") as AtelierDropPointsSpawner;
    return system;
  }

  private func OnAttach() -> Void {
    this.entitySystem = GameInstance.GetDynamicEntitySystem();
    this.delaySystem = GameInstance.GetDelaySystem(this.GetGameInstance());
    this.handled = false;

    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };

    this.spawnedMappins = new inkHashMap();

    this.spawnConfig = new AtelierDropPointsSpawnerConfig();
    this.spawnConfig.Init();
    this.spawnConfig.BuildPrologueList();
    this.spawnConfig.BuildNightCityList();
    this.spawnConfig.BuildDogtownList();
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.Log("OnRestored");
    if !this.handled {
      this.HandleSpawning();
    };
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.Log("OnPlayerAttach");
    if !this.handled {
      this.HandleSpawning();
    };
  }

  public final func IsNightCityUnlocked() -> Bool {
    return this.nightCityUnlocked;
  }

  public final func IsDogtownUnlocked() -> Bool {
    return this.dogtownUnlocked;
  }

  public final func IsCustomDropPoint(id: EntityID) -> Bool {
    return this.entitySystem.IsTagged(id, this.typeTag);
  }

  public final func IsCustomDropPoint(targetId: NewMappinID) -> Bool {
    let values: array<wref<IScriptable>>;
    this.spawnedMappins.GetValues(values);
    let entry: ref<MappinIdWrapper>;
    for value in values {
      entry = value as MappinIdWrapper;
      let id: NewMappinID = entry.id;
      if Equals(id, targetId) {
        return true;
      };
    };

    return false;
  }

  public final func SaveSpawnedMappinId(entityId: EntityID, mappinId: NewMappinID) -> Void {
    let tags: array<CName> = this.entitySystem.GetTags(entityId);
    let uniqueTag: CName = tags[0];
    let key: Uint64 = NameToHash(uniqueTag);
    if !this.spawnedMappins.KeyExist(key) {
      this.spawnedMappins.Insert(key, MappinIdWrapper.Create(mappinId, uniqueTag));
      this.Log(s"Saved mappinId \(mappinId.value) with key \(key)");
    };
  }

  public final func GetUniqueTagByEntityId(entityId: EntityID) -> CName {
    let tags: array<CName> = this.entitySystem.GetTags(entityId);
    if Equals(ArraySize(tags), 0) {
      return n"";
    };

    return tags[0];
  }

  public final func FindInstanceByMappinId(mappinId: NewMappinID) -> ref<AtelierDropPointInstance> {
    let values: array<wref<IScriptable>>;
    this.spawnedMappins.GetValues(values);
    let entry: ref<MappinIdWrapper>;
    let target: ref<MappinIdWrapper>;
    for value in values {
      entry = value as MappinIdWrapper;
      if Equals(entry.id, mappinId) {
        target = entry;
      };
    };

    if !IsDefined(target) {
      return null;
    };

    let dropPoints: array<ref<AtelierDropPointInstance>> = this.GetAvailableDropPoints();
    for dropPoint in dropPoints {
      if Equals(target.tag, dropPoint.uniqueTag) {
        return dropPoint;
      };
    };

    return null;
  }

  public final func GetAvailableDropPoints() -> array<ref<AtelierDropPointInstance>> {
    let result: array<ref<AtelierDropPointInstance>>;
    let chunk: array<ref<AtelierDropPointInstance>>;

    let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    for entityTag in supportedTags {
      chunk = this.spawnConfig.GetSpawnPointsByTag(entityTag);
      for item in chunk {
        ArrayPush(result, item);
      };
    };

    if this.IsNightCityUnlocked() {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
      for entityTag in supportedTags {
        chunk = this.spawnConfig.GetSpawnPointsByTag(entityTag);
        for item in chunk {
          ArrayPush(result, item);
        };
      };
    };

    if this.IsDogtownUnlocked() {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsDogtown();
      for entityTag in supportedTags {
        chunk = this.spawnConfig.GetSpawnPointsByTag(entityTag);
        for item in chunk {
          ArrayPush(result, item);
        };
      };
    };

    return result;
  }

  private final func CheckForQuestFacts() -> Void {
    this.Log(s"CheckForQuestFacts");
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let watsonFact: Int32 = questsSystem.GetFact(n"watson_prolog_lock");
    let unlockFact: Int32 = questsSystem.GetFact(n"unlock_car_hud_dpad");
    let dogtownFact: Int32 = questsSystem.GetFact(n"q302_done");
    this.nightCityUnlocked = NotEquals(watsonFact, 1) && NotEquals(unlockFact, 0);
    this.dogtownUnlocked = Equals(dogtownFact, 1); 
  }

  public final func CheckAndHandleSpawning() -> Void {
    this.Log(s"CheckAndHandleSpawning");
    if this.HasPendingEntities() {
      this.HandleSpawning();
    };
  }

  public final func HandleSpawning() -> Void {
    this.Log(s"HandleSpawning");

    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };

    this.CheckForQuestFacts();
    this.ScheduleInitialNotification();
    this.handled = true;

    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };

    let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    this.Log(s"! Prologue, supported tags: \(ArraySize(supportedTags))");

    for entityTag in supportedTags {
      this.Log(s"> Check tag \(entityTag):");
      if !this.entitySystem.IsPopulated(entityTag) {
        this.Log(s"-> Call for spawn entities");
        this.SpawnInstancesByTag(entityTag);
      } else {
        this.Log(s"-> Entities already spawned");
      };
    };

    if this.nightCityUnlocked {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
      this.Log(s"! Night City, supported tags: \(ArraySize(supportedTags))");

      for entityTag in supportedTags {
        this.Log(s"> Check tag \(entityTag):");
        if !this.entitySystem.IsPopulated(entityTag) {
          this.Log(s"-> Call for spawn entities");
          this.SpawnInstancesByTag(entityTag);
        } else {
          this.Log(s"-> Entities already spawned");
        };
      };
    } else {
      this.Log("Night City locked, skip spawning");
    };

    let playerInDogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInDogTown();

    if this.dogtownUnlocked && playerInDogtown {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsDogtown();
      this.Log(s"! Dogtown, supported tags: \(ArraySize(supportedTags))");

      for entityTag in supportedTags {
        this.Log(s"> Check tag \(entityTag):");
        if !this.entitySystem.IsPopulated(entityTag) {
          this.Log(s"-> Call for spawn entities");
          this.SpawnInstancesByTag(entityTag);
        } else {
          this.Log(s"-> Entities already spawned");
        };
      };
    } else {
      this.Log("Player not in Dogtown, skip spawning");
    };
  }

  public final func ScheduleInitialNotification() -> Void {
    this.Log(s"ScheduleInitialNotification...");
    this.delaySystem.CancelCallback(this.initialCallbackId);
    let callback: ref<DropPointsSpawnerCallbackInitial> = DropPointsSpawnerCallbackInitial.Create(this);
    this.initialCallbackId = this.delaySystem.DelayCallback(callback, 7.0, true);
  }

  public final func HandleInitialNotification() -> Void {
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let messenger: ref<DeliveryMessengerSystem>;
    let factName: CName = n"vad_welcome_displayed";
    let welcomeFact: Int32 = questsSystem.GetFact(factName);
    let welcomeDisplayed: Bool = Equals(welcomeFact, 1);
    
    this.Log(s"HandleInitialNotification, welcomeDisplayed = \(welcomeDisplayed)");

    if !welcomeDisplayed && this.IsPhoneAvailable() {
      messenger = DeliveryMessengerSystem.Get(this.GetGameInstance());
      messenger.PushWelcomeNotificationItem();
      questsSystem.SetFact(factName, 1);
    };

    this.ScheduleNewDropPointsNotification();
  }

  public final func ScheduleNewDropPointsNotification() -> Void {
    this.Log(s"ScheduleNewDropPointsNotification...");
    this.delaySystem.CancelCallback(this.dropPointsCallbackId);
    let callback: ref<DropPointsSpawnerCallbackNewDropPoint> = DropPointsSpawnerCallbackNewDropPoint.Create(this);
    this.dropPointsCallbackId = this.delaySystem.DelayCallback(callback, 7.0, true);
  }

  public final func HandleNewDropPointsNotification() -> Void {
    this.Log(s"HandleNewDropPointsNotification");
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let playerInDogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInDogTown();
    let messenger: ref<DeliveryMessengerSystem>;

    // LongshoreStacks
    let longshoreStacksFactName: CName = n"vad_longshore_sacks_displayed";
    let longshoreStacksFact: Int32 = questsSystem.GetFact(longshoreStacksFactName);
    let longshoreStacksDisplayed: Bool = Equals(longshoreStacksFact, 1);
    this.Log(s" - LongshoreStacks displayed: \(longshoreStacksDisplayed)");
    if playerInDogtown && !longshoreStacksDisplayed && this.IsPhoneAvailable() {
      messenger = DeliveryMessengerSystem.Get(this.GetGameInstance());
      messenger.PushNewDropPointNotificationItem(AtelierDeliveryDropPoint.LongshoreStacks, t"Districts.Dogtown");
      questsSystem.SetFact(longshoreStacksFactName, 1);
    };
  }

  public final func DespawnAll() -> Void {
    let supportedTagsPrologue: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    let supportedTagsNightCity: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
    let supportedTagsDogtown: array<CName> = this.spawnConfig.GetIterationTagsDogtown();

    for tag in supportedTagsPrologue {
      this.entitySystem.DeleteTagged(tag);
    };

    for tag in supportedTagsNightCity {
      this.entitySystem.DeleteTagged(tag);
    };

    for tag in supportedTagsDogtown {
      this.entitySystem.DeleteTagged(tag);
    };
  }

  private final func SpawnInstancesByTag(entityTag: CName) -> Void {
    let instances: array<ref<AtelierDropPointInstance>> = this.spawnConfig.GetSpawnPointsByTag(entityTag);
    let deviceSpec: ref<DynamicEntitySpec>;

    for instance in instances {
      deviceSpec = new DynamicEntitySpec();
      deviceSpec.templatePath = r"djkovrik\\gameplay\\devices\\drop_points\\drop_point_va.ent";
      deviceSpec.appearanceName = n"default";
      deviceSpec.position = instance.position;
      deviceSpec.orientation = instance.orientation;
      deviceSpec.persistSpawn = true;
      deviceSpec.alwaysSpawned = true;
      deviceSpec.tags = [ instance.uniqueTag, instance.indexTag, instance.iterationTag, this.typeTag ];
      this.Log(s"--> spawning entity with tags [ \(instance.uniqueTag), \(instance.iterationTag), \(this.typeTag) ] at position \(instance.position)");
      this.entitySystem.CreateEntity(deviceSpec);
    };
  }

  private final func HasPendingEntities() -> Bool {
    let prologueUpdateRequired: Bool = false;
    let nightCityUpdateRequired: Bool = false;
    let dogtownUpdateRequired: Bool = false;
    let supportedTagsPrologue: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    let supportedTagsNightCity: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
    let supportedTagsDogtown: array<CName> = this.spawnConfig.GetIterationTagsDogtown();

    for tag in supportedTagsPrologue {
      if !this.entitySystem.IsPopulated(tag) {
        prologueUpdateRequired = true;
      };
    };

    for tag in supportedTagsNightCity {
      if !this.entitySystem.IsPopulated(tag) {
        nightCityUpdateRequired = true;
      };
    };

    for tag in supportedTagsDogtown {
      if !this.entitySystem.IsPopulated(tag) {
        dogtownUpdateRequired = true;
      };
    };

    return prologueUpdateRequired || nightCityUpdateRequired || dogtownUpdateRequired;
  }

  private final func IsPhoneAvailable() -> Bool {
    let phoneSystem: wref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"PhoneSystem") as PhoneSystem;
    if IsDefined(phoneSystem) {
      return phoneSystem.IsPhoneEnabled();
    };
    return false;
  }

  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliverySpawner", str);
    };
  }
}
