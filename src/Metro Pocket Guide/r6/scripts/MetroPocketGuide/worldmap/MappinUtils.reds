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
