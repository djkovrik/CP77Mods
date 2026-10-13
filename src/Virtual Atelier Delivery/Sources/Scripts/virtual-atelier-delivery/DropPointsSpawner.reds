module AtelierDelivery

public class AtelierDropPointsSpawner extends ScriptableSystem {
  private let entitySystem: wref<DynamicEntitySystem>;
  private let delaySystem: wref<DelaySystem>;
  private let config: ref<VirtualAtelierDeliveryConfig>;
  private let handled: Bool;
  private let sessionReady: Bool;
  private let recoveryCallbackId: DelayID;
  private let recoveryGeneration: Uint32;
  private let recoveryEnabled: Bool;
  private let recoveryAttemptsLeft: Int32;
  private let readinessRetriesLeft: Int32;
  private let recoveryPending: Bool;
  private let retiredEntityIDs: array<EntityID>;
  private let spawnConfig: ref<AtelierDropPointsSpawnerConfig>;
  private let initialCallbackId: DelayID;
  private let dropPointsCallbackId: DelayID;
  private let nightCityUnlocked: Bool = false;
  private let dogtownUnlocked: Bool = false;
  private let typeTag: CName = n"VirtualAtelierDropPoint";
  private let streamingTag: CName = n"VirtualAtelierDropPointStreamedV1";

  private let spawnedMappins: ref<inkHashMap>;

  public static func Get(gi: GameInstance) -> ref<AtelierDropPointsSpawner> {
    let system: ref<AtelierDropPointsSpawner> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.AtelierDropPointsSpawner") as AtelierDropPointsSpawner;
    return system;
  }

  public func OnAttach() -> Void {
    this.entitySystem = GameInstance.GetDynamicEntitySystem();
    this.delaySystem = GameInstance.GetDelaySystem(this.GetGameInstance());
    this.handled = false;
    this.sessionReady = false;
    this.recoveryCallbackId = GetInvalidDelayID();
    this.initialCallbackId = GetInvalidDelayID();
    this.dropPointsCallbackId = GetInvalidDelayID();
    this.recoveryEnabled = false;
    ArrayClear(this.retiredEntityIDs);
    this.config = new VirtualAtelierDeliveryConfig();

    // Also retry after long loads, once all session data has been restored.
    GameInstance.GetCallbackSystem().RegisterCallback(n"Session/Ready", this, n"OnSessionReady")
      .SetLifetime(CallbackLifetime.Session);

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

  private cb func OnSessionReady(event: ref<GameSessionEvent>) -> Void {
    this.sessionReady = true;
    this.HandleSpawning();
  }

  public func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.Log("OnRestored");
    this.HandleSpawning();
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.Log("OnPlayerAttach");
    this.HandleSpawning();
  }

  public func OnDetach() -> Void {
    this.sessionReady = false;
    this.StopRecovery();
    if IsDefined(this.delaySystem) {
      this.delaySystem.CancelCallback(this.initialCallbackId);
      this.delaySystem.CancelCallback(this.dropPointsCallbackId);
    };
    this.initialCallbackId = GetInvalidDelayID();
    this.dropPointsCallbackId = GetInvalidDelayID();
  }

  public final func IsNightCityUnlocked() -> Bool {
    return this.nightCityUnlocked;
  }

  public final func IsDogtownUnlocked() -> Bool {
    return this.dogtownUnlocked;
  }

  public final func IsCustomDropPoint(id: EntityID) -> Bool {
    if !this.EnsureInitialized() {
      return false;
    };

    return this.entitySystem.IsTagged(id, this.typeTag);
  }

  public final func IsCustomDropPoint(targetId: NewMappinID) -> Bool {
    if !this.EnsureInitialized() {
      return false;
    };

    return this.spawnedMappins.KeyExist(targetId.value);
  }

  public final func SaveSpawnedMappinId(entityId: EntityID, mappinId: NewMappinID) -> Void {
    if !this.EnsureInitialized() {
      return;
    };

    let invalidID: NewMappinID;
    if Equals(mappinId, invalidID) || this.IsRetiredDropPoint(entityId) {
      return;
    };
    let point: ref<AtelierDropPointInstance> = this.spawnConfig.GetPointByUniqueTag(this.GetDropPointTagByEntityId(entityId));
    if !IsDefined(point) {
      return;
    };
    if this.spawnedMappins.KeyExist(mappinId.value) {
      this.spawnedMappins.Set(mappinId.value, point);
    } else {
      this.spawnedMappins.Insert(mappinId.value, point);
    };
  }

  public final func ForgetSpawnedMappinId(mappinId: NewMappinID) -> Void {
    if IsDefined(this.spawnedMappins) {
      this.spawnedMappins.Remove(mappinId.value);
    };
  }

  public final func IsRetiredDropPoint(entityId: EntityID) -> Bool {
    return ArrayContains(this.retiredEntityIDs, entityId);
  }

  public final func GetUniqueTagByEntityId(entityId: EntityID) -> CName {
    return this.GetDropPointTagByEntityId(entityId);
  }

  private final func GetDropPointTagByEntityId(entityId: EntityID) -> CName {
    if !this.EnsureInitialized() {
      if this.IsDebugEnabled() {
        this.Log(s"Pickup terminal lookup FAILED for entity \(entityId): spawner is not initialized");
      };
      return n"";
    };

    let tags: array<CName> = this.entitySystem.GetTags(entityId);
    if Equals(ArraySize(tags), 0) {
      if this.IsDebugEnabled() {
        this.Log(s"Pickup terminal lookup FAILED for entity \(entityId): entity has no dynamic tags");
      };
      return n"";
    };

    for tag in tags {
      if NotEquals(AtelierDeliveryUtils.GetDropPointByTag(tag), AtelierDeliveryDropPoint.None) {
        if this.IsDebugEnabled() {
          this.Log(s"Pickup terminal lookup succeeded for entity \(entityId): uniqueTag=\(tag), totalTags=\(ArraySize(tags))");
        };
        return tag;
      };
    };

    if this.IsDebugEnabled() {
      this.Log(s"Pickup terminal lookup FAILED for entity \(entityId): none of its \(ArraySize(tags)) tags maps to a delivery point");
    };
    return n"";
  }

  public final func FindInstanceByMappinId(mappinId: NewMappinID) -> ref<AtelierDropPointInstance> {
    if !this.EnsureInitialized() {
      return null;
    };

    return this.spawnedMappins.Get(mappinId.value) as AtelierDropPointInstance;
  }

  public final func GetAvailableDropPoints() -> array<ref<AtelierDropPointInstance>> {
    let result: array<ref<AtelierDropPointInstance>>;
    let chunk: array<ref<AtelierDropPointInstance>>;
    if !this.EnsureInitialized() {
      return result;
    };

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

  public final func FindAvailableDropPoint(target: AtelierDeliveryDropPoint) -> ref<AtelierDropPointInstance> {
    if Equals(target, AtelierDeliveryDropPoint.None) {
      return null;
    };

    let dropPoints: array<ref<AtelierDropPointInstance>> = this.GetAvailableDropPoints();
    for dropPoint in dropPoints {
      if IsDefined(dropPoint) && Equals(dropPoint.type, target) {
        return dropPoint;
      };
    };

    return null;
  }

  private final func CheckForQuestFacts() -> Void {
    if this.IsDebugEnabled() {
      this.Log(s"CheckForQuestFacts");
    };
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let watsonFact: Int32 = questsSystem.GetFact(n"watson_prolog_lock");
    let unlockFact: Int32 = questsSystem.GetFact(n"unlock_car_hud_dpad");
    let dogtownFact: Int32 = questsSystem.GetFact(n"q302_done");
    this.nightCityUnlocked = NotEquals(watsonFact, 1) && NotEquals(unlockFact, 0);
    this.dogtownUnlocked = Equals(dogtownFact, 1); 
  }

  public final func CheckAndHandleSpawning() -> Void {
    this.HandleSpawning();
  }

  public final func HandleSpawning() -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() || !this.EnsureInitialized() {
      return;
    };

    // Each external event starts a bounded recovery pass, not a polling loop.
    this.StopRecovery();
    this.recoveryEnabled = true;
    this.recoveryAttemptsLeft = 3;
    this.readinessRetriesLeft = 6;
    if this.handled {
      this.ScheduleInitialNotification();
    };
    this.ScheduleRecovery(5.0);
  }

  private final func ScheduleRecovery(delay: Float) -> Void {
    this.delaySystem.CancelCallback(this.recoveryCallbackId);
    this.recoveryCallbackId = GetInvalidDelayID();
    this.recoveryGeneration += 1u;
    let callback: ref<DropPointsSpawnerCallbackRecovery> = DropPointsSpawnerCallbackRecovery.Create(this, this.recoveryGeneration);
    this.recoveryCallbackId = this.delaySystem.DelayCallback(callback, delay, false);
  }

  private final func StopRecovery() -> Void {
    this.recoveryEnabled = false;
    this.recoveryGeneration += 1u;
    if IsDefined(this.delaySystem) {
      this.delaySystem.CancelCallback(this.recoveryCallbackId);
    };
    this.recoveryCallbackId = GetInvalidDelayID();
  }

  public final func HandleRecovery(generation: Uint32) -> Void {
    if !this.recoveryEnabled || NotEquals(generation, this.recoveryGeneration) {
      return;
    };
    this.recoveryCallbackId = GetInvalidDelayID();
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      this.StopRecovery();
      return;
    };
    if !this.EnsureInitialized() {
      this.StopRecovery();
      return;
    };

    // A registered entity can still be restoring/streaming. Never create replacements
    // based only on GetEntity() returning null during loading.
    if !this.sessionReady || !this.entitySystem.IsReady() || !IsDefined(GetPlayer(this.GetGameInstance())) {
      this.Log("Recovery: waiting for DynamicEntitySystem/player readiness");
      this.readinessRetriesLeft -= 1;
      if this.readinessRetriesLeft > 0 {
        this.ScheduleRecovery(5.0);
      } else {
        this.Log("Recovery: readiness timeout, waiting for the next lifecycle event");
        this.StopRecovery();
      };
      return;
    };

    this.recoveryAttemptsLeft -= 1;
    this.recoveryPending = false;
    this.CheckForQuestFacts();
    if !this.handled {
      this.handled = true;
      this.ScheduleInitialNotification();
    };
    if this.IsDebugEnabled() {
      this.Log(s"Recovery audit: restored=\(this.entitySystem.IsRestored())");
    };
    // Remove the legacy Northside placement before checking individual points.
    this.FixAlreadySpawnedEntities();

    let tags: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    for tag in tags {
      this.ReconcileInstancesByTag(tag);
    };
    if this.nightCityUnlocked {
      tags = this.spawnConfig.GetIterationTagsNightCity();
      for tag in tags {
        this.ReconcileInstancesByTag(tag);
      };
    };
    // Register unlocked destinations even outside their district. Population
    // streaming controls the physical terminal; its map marker exists remotely.
    if this.dogtownUnlocked {
      tags = this.spawnConfig.GetIterationTagsDogtown();
      for tag in tags {
        this.ReconcileInstancesByTag(tag);
      };
    };
    if this.recoveryPending && this.recoveryAttemptsLeft > 0 {
      this.ScheduleRecovery(5.0);
    } else {
      if this.IsDebugEnabled() {
        this.Log(s"Recovery pass finished: unresolved=\(this.recoveryPending), waiting for the next lifecycle event");
      };
      this.StopRecovery();
    };
  }

  private final func ReconcileInstancesByTag(tag: CName) -> Void {
    let instances: array<ref<AtelierDropPointInstance>> = this.spawnConfig.GetSpawnPointsByTag(tag);
    for instance in instances {
      this.ReconcileDropPoint(instance);
    };
  }

  private final func ReconcileDropPoint(instance: ref<AtelierDropPointInstance>) -> Void {
    let ids: array<EntityID> = this.entitySystem.GetTaggedIDs(instance.indexTag);
    // Older registrations can still be recognized by their location tag.
    if Equals(ArraySize(ids), 0) {
      ids = this.entitySystem.GetTaggedIDs(instance.uniqueTag);
    };
    if this.IsDebugEnabled() {
      this.Log(s"Recovery point \(instance.uniqueTag): registrations=\(ArraySize(ids))");
    };
    if Equals(ArraySize(ids), 0) {
      if this.IsDebugEnabled() {
        this.Log(s"Recovery point \(instance.uniqueTag): registration missing, creating");
      };
      this.SpawnDropPointEntity(instance);
      this.recoveryPending = true;
      return;
    };

    for id in ids {
      if !this.entitySystem.IsTagged(id, this.typeTag) {
        if this.IsDebugEnabled() {
          this.Log(s"Recovery point \(instance.uniqueTag): foreign tag collision, leaving entity untouched");
        };
      } else if this.IsRetiredDropPoint(id) {
        // DeleteEntity finishes asynchronously. Wait for its registration to go
        // away before creating a replacement at the same position.
        this.recoveryPending = true;
      } else if !this.entitySystem.IsTagged(id, this.streamingTag) {
        // One-time migration of old alwaysSpawned/transient-ID registrations.
        this.DeleteDropPointEntity(id);
        this.recoveryPending = true;
      } else {
        // A managed streamed entity is valid even while its object is absent.
        // Never enable or recreate it merely because the player is far away.
        this.RegisterDropPointMappin(id, instance);
      };
    };
  }

  public final func ScheduleInitialNotification() -> Void {
    if this.IsDebugEnabled() {
      this.Log(s"ScheduleInitialNotification...");
    };
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
    
    if this.IsDebugEnabled() {
      this.Log(s"HandleInitialNotification, welcomeDisplayed = \(welcomeDisplayed)");
    };

    if !welcomeDisplayed && this.IsPhoneAvailable() {
      messenger = DeliveryMessengerSystem.Get(this.GetGameInstance());
      messenger.PushWelcomeNotificationItem();
      questsSystem.SetFact(factName, 1);
    };

    this.ScheduleNewDropPointsNotification();
  }

  public final func ScheduleNewDropPointsNotification() -> Void {
    if this.IsDebugEnabled() {
      this.Log(s"ScheduleNewDropPointsNotification...");
    };
    this.delaySystem.CancelCallback(this.dropPointsCallbackId);
    let callback: ref<DropPointsSpawnerCallbackNewDropPoint> = DropPointsSpawnerCallbackNewDropPoint.Create(this);
    this.dropPointsCallbackId = this.delaySystem.DelayCallback(callback, 7.0, true);
  }

  public final func HandleNewDropPointsNotification() -> Void {
    if this.IsDebugEnabled() {
      this.Log(s"HandleNewDropPointsNotification");
    };
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let playerInDogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInDogTown();
    let messenger: ref<DeliveryMessengerSystem>;

    // LongshoreStacks
    let longshoreStacksFactName: CName = n"vad_longshore_sacks_displayed";
    let longshoreStacksFact: Int32 = questsSystem.GetFact(longshoreStacksFactName);
    let longshoreStacksDisplayed: Bool = Equals(longshoreStacksFact, 1);
    if this.IsDebugEnabled() {
      this.Log(s" - LongshoreStacks displayed: \(longshoreStacksDisplayed)");
    };
    if playerInDogtown && !longshoreStacksDisplayed && this.IsPhoneAvailable() {
      messenger = DeliveryMessengerSystem.Get(this.GetGameInstance());
      messenger.PushNewDropPointNotificationItem(AtelierDeliveryDropPoint.LongshoreStacks, t"Districts.Dogtown");
      questsSystem.SetFact(longshoreStacksFactName, 1);
    };
  }

  public final func DespawnAll() -> Void {
    this.StopRecovery();
    if !this.EnsureInitialized() {
      return;
    };
    this.delaySystem.CancelCallback(this.initialCallbackId);
    this.delaySystem.CancelCallback(this.dropPointsCallbackId);
    this.initialCallbackId = GetInvalidDelayID();
    this.dropPointsCallbackId = GetInvalidDelayID();
    let ids: array<EntityID> = this.entitySystem.GetTaggedIDs(this.typeTag);
    for id in ids {
      this.DeleteDropPointEntity(id);
    };
  }

  private final func FixAlreadySpawnedEntities() -> Void {
    this.Log("FixAlreadySpawnedEntities");
    // Fix #1: Northside
    let ids: array<EntityID> = this.entitySystem.GetTaggedIDs(n"droppoint3");
    for id in ids {
      this.DeleteDropPointEntity(id);
    };
  }

  private final func DeleteDropPointEntity(id: EntityID) -> Void {
    if !this.entitySystem.IsTagged(id, this.typeTag) || this.IsRetiredDropPoint(id) {
      return;
    };
    if this.entitySystem.DeleteEntity(id) {
      ArrayPush(this.retiredEntityIDs, id);
      let request: ref<UnregisterDropPointMappinRequest> = new UnregisterDropPointMappinRequest();
      request.ownerID = id;
      request.removeFromSystem = true;
      let dropPointSystem: ref<DropPointSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"DropPointSystem") as DropPointSystem;
      dropPointSystem.QueueRequest(request);
    };
  }

  private final func RegisterDropPointMappin(id: EntityID, instance: ref<AtelierDropPointInstance>) -> Void {
    let request: ref<RegisterDropPointMappinRequest> = new RegisterDropPointMappinRequest();
    request.ownerID = id;
    request.position = instance.position;
    let dropPointSystem: ref<DropPointSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"DropPointSystem") as DropPointSystem;
    dropPointSystem.QueueRequest(request);
  }

  private final func SpawnDropPointEntity(instance: ref<AtelierDropPointInstance>) -> Void {
    let deviceSpec: ref<DynamicEntitySpec> = new DynamicEntitySpec();
    deviceSpec.templatePath = r"djkovrik\\gameplay\\devices\\drop_points\\drop_point_va.ent";
    deviceSpec.appearanceName = n"default";
    deviceSpec.position = instance.position;
    deviceSpec.orientation = instance.orientation;
    deviceSpec.persistSpawn = true;
    // Stable owner IDs are required by persistent DropPointSystem mappins.
    deviceSpec.persistState = true;
    deviceSpec.alwaysSpawned = false;
    deviceSpec.tags = [ instance.uniqueTag, instance.indexTag, instance.iterationTag, this.typeTag, this.streamingTag ];
    if this.IsDebugEnabled() {
      this.Log(s"--> spawning entity with tags [ \(instance.uniqueTag), \(instance.indexTag) \(instance.iterationTag), \(this.typeTag) ] at position \(instance.position)");
    };
    let id: EntityID = this.entitySystem.CreateEntity(deviceSpec);
    if this.entitySystem.IsManaged(id) {
      this.RegisterDropPointMappin(id, instance);
    };
    if this.IsDebugEnabled() {
      this.Log(s"Recovery point \(instance.uniqueTag): CreateEntity returned \(id), managed=\(this.entitySystem.IsManaged(id))");
    };
  }

  private final func EnsureInitialized() -> Bool {
    if !IsDefined(this.entitySystem) {
      this.entitySystem = GameInstance.GetDynamicEntitySystem();
    };

    if !IsDefined(this.delaySystem) {
      this.delaySystem = GameInstance.GetDelaySystem(this.GetGameInstance());
    };

    if !IsDefined(this.spawnedMappins) {
      this.spawnedMappins = new inkHashMap();
    };

    if !IsDefined(this.spawnConfig) {
      this.spawnConfig = new AtelierDropPointsSpawnerConfig();
      this.spawnConfig.Init();
      this.spawnConfig.BuildPrologueList();
      this.spawnConfig.BuildNightCityList();
      this.spawnConfig.BuildDogtownList();
    };

    return IsDefined(this.entitySystem) && IsDefined(this.delaySystem) && IsDefined(this.spawnedMappins) && IsDefined(this.spawnConfig);
  }

  private final func IsPhoneAvailable() -> Bool {
    let phoneSystem: wref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"PhoneSystem") as PhoneSystem;
    if IsDefined(phoneSystem) {
      return phoneSystem.IsPhoneEnabled();
    };
    return false;
  }

  public final func IsDebugEnabled() -> Bool {
    return IsDefined(this.config) && this.config.debug;
  }

  private final func Log(str: String) -> Void {
    if this.IsDebugEnabled() {
      ModLog(n"DeliverySpawner", str);
    };
  }
}
