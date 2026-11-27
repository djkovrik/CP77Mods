module AtelierDelivery

class AtelierDropPointMappinRecovery {

  public static func BuildPositions() -> array<Vector4> {
    let positions: array<Vector4>;
    let config: ref<AtelierDropPointsSpawnerConfig> = new AtelierDropPointsSpawnerConfig();

    config.Init();
    config.BuildPrologueList();
    config.BuildNightCityList();
    config.BuildDogtownList();

    let tags: array<CName> = config.GetIterationTagsPrologue();
    for tag in tags {
      AtelierDropPointMappinRecovery.AppendPositions(positions, config.GetSpawnPointsByTag(tag));
    };

    tags = config.GetIterationTagsNightCity();
    for tag in tags {
      AtelierDropPointMappinRecovery.AppendPositions(positions, config.GetSpawnPointsByTag(tag));
    };

    tags = config.GetIterationTagsDogtown();
    for tag in tags {
      AtelierDropPointMappinRecovery.AppendPositions(positions, config.GetSpawnPointsByTag(tag));
    };

    // keep the old Northside position separate
    ArrayPush(positions, Vector4(-1475.607837, 2192.650830, 18.200005, 1.0));
    return positions;
  }

  private static func AppendPositions(out positions: array<Vector4>, points: array<ref<AtelierDropPointInstance>>) -> Void {
    for point in points {
      ArrayPush(positions, point.position);
    };
  }

  public static func MatchesPosition(position: Vector4, positions: array<Vector4>) -> Bool {
    let index: Int32 = 0;
    let dx: Float;
    let dy: Float;
    let dz: Float;

    while index < ArraySize(positions) {
      dx = position.X - positions[index].X;
      dy = position.Y - positions[index].Y;
      dz = position.Z - positions[index].Z;
      if dx * dx + dy * dy + dz * dz <= 0.0001 {
        return true;
      };
      index += 1;
    };
    return false;
  }
}

@addField(DropPointSystem)
private persistent let vadLegacyMappinsCleaned: Bool;

@addMethod(DropPointSystem)
private final func VADPruneSavedDropPoints() -> Void {
  if this.vadLegacyMappinsCleaned {
    return;
  };

  let entitySystem: ref<DynamicEntitySystem> = GameInstance.GetDynamicEntitySystem();
  if !IsDefined(entitySystem) || !entitySystem.IsReady() {
    return;
  };

  let positions: array<Vector4> = AtelierDropPointMappinRecovery.BuildPositions();
  let before: Int32 = ArraySize(this.m_mappins);
  let readIndex: Int32 = 0;
  let writeIndex: Int32 = 0;
  let remove: Bool;
  let owner: EntityID;
  let data: ref<DropPointMappinRegistrationData>;
  let invalidID: NewMappinID;

  while readIndex < before {
    data = this.m_mappins[readIndex];
    remove = false;
    if IsDefined(data) {
      owner = data.GetOwnerID();
      remove = EntityID.IsDynamic(owner)
        && Equals(data.GetMappinID(), invalidID)
        && AtelierDropPointMappinRecovery.MatchesPosition(data.GetPosition(), positions)
        && !entitySystem.IsManaged(owner);
    };

    if !remove {
      if writeIndex != readIndex {
        this.m_mappins[writeIndex] = data;
      };
      writeIndex += 1;
    };

    readIndex += 1;
  };
  if writeIndex < before {
    ArrayResize(this.m_mappins, writeIndex);
  };

  this.vadLegacyMappinsCleaned = true;
}
