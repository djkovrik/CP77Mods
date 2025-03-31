module AtelierDelivery

public class AtelierDropPointsSpawner extends ScriptableSystem {
  private let entitySystem: wref<DynamicEntitySystem>;
  private let handled: Bool;
  private let spawnConfig: ref<AtelierDropPointsSpawnerConfig>;
  private let typeTag: CName = n"VirtualAtelierDropPoint";

  private let spawnedMappins: ref<inkHashMap>;

  public static func Get(gi: GameInstance) -> ref<AtelierDropPointsSpawner> {
    let system: ref<AtelierDropPointsSpawner> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.AtelierDropPointsSpawner") as AtelierDropPointsSpawner;
    return system;
  }

  private func OnAttach() -> Void {
    this.entitySystem = GameInstance.GetDynamicEntitySystem();
    this.handled = false;

    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };

    this.spawnedMappins = new inkHashMap();

    this.spawnConfig = new AtelierDropPointsSpawnerConfig();
    this.spawnConfig.Init();
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    if !this.handled {
      this.HandleSpawning();
    };
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if !this.handled {
      this.HandleSpawning();
    };
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
    return this.spawnConfig.GetAllSpawnPoints();
  }

  private final func HandleSpawning() -> Void {
    this.handled = true;

    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };

    let supportedTags: array<CName> = this.spawnConfig.GetIterationTags();
    this.Log(s"HandleSpawning, supported tags: \(ArraySize(supportedTags))");

    for entityTag in supportedTags {
      this.Log(s"> Check tag \(entityTag):");
      if !this.entitySystem.IsPopulated(entityTag) {
        this.Log(s"-> Call for spawn entities");
        this.SpawnInstancesByTag(entityTag);
      } else {
        this.Log(s"-> Entities already spawned");
      };
    };
  }

  private final func SpawnInstancesByTag(entityTag: CName) -> Void {
    let instances: array<ref<AtelierDropPointInstance>> = this.spawnConfig.GetSpawnPointsByTag(entityTag);
    let deviceSpec: ref<DynamicEntitySpec>;

    for instance in instances {
      deviceSpec = new DynamicEntitySpec();
      deviceSpec.templatePath = r"base\\gameplay\\devices\\drop_points\\drop_point_va.ent";
      deviceSpec.appearanceName = n"default";
      deviceSpec.position = instance.position;
      deviceSpec.orientation = instance.orientation;
      // TODO
      // deviceSpec.persistState = true;
      // deviceSpec.persistSpawn = true;
      deviceSpec.alwaysSpawned = true;
      deviceSpec.tags = [ instance.uniqueTag, instance.indexTag, instance.iterationTag, this.typeTag ];
      this.Log(s"--> spawning entity with tags [ \(instance.uniqueTag), \(instance.iterationTag), \(this.typeTag) ] at position \(instance.position)");
      this.entitySystem.CreateEntity(deviceSpec);
    };
  }

  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliverySpawner", str);
    };
  }
}
