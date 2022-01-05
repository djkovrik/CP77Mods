// Check if quest related to vehicle
@addMethod(WorldMapMenuGameController)
public func IsRelatedToVehicleQuest(mappin: wref<IMappin>) -> Bool {
  let mappinQuest: ref<JournalQuest>;
  mappinQuest = questLogGameController.GetTopQuestEntry(this.m_journalManager, this.GetMappinJournalEntry(mappin));

  return NotEquals(mappinQuest, null) && Equals(mappinQuest.GetType(), gameJournalQuestType.VehicleQuest);
}

@replaceMethod(WorldMapMenuGameController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  let isVehicleQuest: Bool = this.IsRelatedToVehicleQuest(mappin);
  let isTracked: Bool = mappin.IsPlayerTracked();
  let widgetResource: ResRef = r"base\\gameplay\\gui\\fullscreen\\world_map\\mappins\\default_mappin.inkwidget";
  if isVehicleQuest && !isTracked {
    return MappinUIProfile.None();
  };
  if IsDefined(customData) {
    if customData.IsA(n"gameuiWorldMapPlayerInitData") {
      widgetResource = r"base\\gameplay\\gui\\fullscreen\\world_map\\mappins\\player_mappin.inkwidget";
    };
  };
  return MappinUIProfile.Create(widgetResource, t"MappinUISpawnProfile.Always", t"MapMappinUIProfile.Default");
}
