@wrapMethod(WorldMappinsContainerController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  let widgetResource: ResRef = r"base\\gameplay\\gui\\widgets\\mappins\\quest\\default_mappin.inkwidget";
  if Equals(mappinVariant, gamedataMappinVariant.CPO_PingGoHereVariant) {
    return MappinUIProfile.Create(widgetResource, t"MappinUISpawnProfile.Always", t"WorldMappinUIProfile.CustomMapMarkers");
  };
  
  return wrappedMethod(mappin, mappinVariant, customData);
}

@wrapMethod(MinimapContainerController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  if Equals(mappinVariant, gamedataMappinVariant.CPO_PingGoHereVariant) {
    return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\minimap\\minimap_quest_mappin.inkwidget", t"MappinUISpawnProfile.Always", t"MinimapMappinUIProfile.CustomMapMarkers");
  };
  
  return wrappedMethod(mappin, mappinVariant, customData);
}
