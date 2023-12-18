import MetroPocketGuide.Navigator.PocketMetroNavigator
import Codeware.Localization.*

@addMethod(BaseWorldMapMappinController)
public final func GetMetroStationName() -> ENcartStations {
  let mappin: ref<FastTravelMappin> = this.GetMappin() as FastTravelMappin;
  let stationName: String = "";
  if IsDefined(mappin) {
    stationName = mappin.GetPointData().GetPointDisplayName();
  } else {
    stationName = "";
  };

  return MetroDataHelper.GetStationNameByLocKey(stationName);
}

@addMethod(WorldMapMenuGameController)
private final func BuildShortRouteString() -> String {
  let str: String = "";
  str += this.GetLocalizedTextCustom("PMG-From");
  str += " ";
  str += GetLocalizedText(MetroDataHelper.GetStationTitle(PocketMetroNavigator.GetDeparture()));
  str += "\n";
  str += this.GetLocalizedTextCustom("PMG-To");
  str += " ";
  str += GetLocalizedText(MetroDataHelper.GetStationTitle(PocketMetroNavigator.GetDestination()));
  return str;
}

@addMethod(WorldMapMenuGameController)
private final func GetLocalizedTextCustom(key: String) -> String {
  if !IsDefined(this.mpgTranslator) {
    this.mpgTranslator = LocalizationSystem.GetInstance(GetGameInstance());
  };
  return this.mpgTranslator.GetText(key);
}
