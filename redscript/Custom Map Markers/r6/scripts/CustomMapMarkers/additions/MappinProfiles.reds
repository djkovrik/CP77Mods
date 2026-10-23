@wrapMethod(WorldMappinsContainerController)
public func CreateMappinUIProfile(mappin: wref<IMappin>, mappinVariant: gamedataMappinVariant, customData: ref<MappinControllerCustomData>) -> MappinUIProfile {
  if Equals(mappinVariant, gamedataMappinVariant.CPO_PingGoHereVariant) {
    return MappinUIProfile.Create(r"base\\gameplay\\gui\\widgets\\mappins\\gameplay\\gameplay_mappin.inkwidget", t"MappinUISpawnProfile.ShortRange", t"WorldMappinUIProfile.CustomMapMarkers");
  };
  
  return wrappedMethod(mappin, mappinVariant, customData);
}
