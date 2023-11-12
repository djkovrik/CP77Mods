/**
  public func Init() -> Void
  public func GetRandomTeleportData(current: gamedataDistrict) -> ref<TeleportData>
  public func GetRandomTeleportDataPrologue() -> ref<TeleportData>
*/
public class TeleportDestinationHelper {

  private let districts: array<ref<TeleportData>>;
  private let districtsPrologue: array<ref<TeleportData>>;

  public func Init() -> Void {
    this.PopulateDistrictsData();
  }

  public func GetRandomTeleportData(current: gamedataDistrict) -> ref<TeleportData> {
    let districts: array<ref<TeleportData>> = this.districts;
    let targetDistricts: array<ref<TeleportData>>;
    for item in districts {
      if NotEquals(item.district, current) {
        ArrayPush(targetDistricts, item);
      };
    };
    if Equals(ArraySize(targetDistricts), 0) {
      return null;
    };

    let index: Int32 = RandRange(0, ArraySize(targetDistricts));
    return targetDistricts[index];
  }

  public func GetRandomTeleportDataPrologue() -> ref<TeleportData> {
    let index: Int32 = RandRange(0, ArraySize(this.districtsPrologue));
    return this.districtsPrologue[index];
  }

  private func PopulateDistrictsData() -> Void {
    // Downtown
    let downtown: ref<TeleportData> = new TeleportData();
    downtown.district = gamedataDistrict.Downtown;
    downtown.maleVictim = t"Character.LightCrowd_downtown_ma";
    downtown.femaleVictim = t"Character.LightCrowd_downtown_wa";
    downtown.coords = [
      new Vector4(-2032.205078, 669.650024, 10.342606, 1.0),
      new Vector4(-2022.895386, 498.522583, 9.949997, 1.0)
    ];
    ArrayPush(this.districts, downtown);
    // Glen
    let glen: ref<TeleportData> = new TeleportData();
    glen.district = gamedataDistrict.Glen;
    glen.maleVictim = t"Character.LightCrowd_glen_ma";
    glen.femaleVictim = t"Character.LightCrowd_glen_wa";
    glen.coords = [
      new Vector4(-1609.206543, -1210.161621, 24.747269, 1.0),
      new Vector4(-1603.516479, -1317.780518, 38.519920, 1.0)
    ];
    ArrayPush(this.districts, glen);
    // Kabuki
    let kabuki: ref<TeleportData> = new TeleportData();
    kabuki.district = gamedataDistrict.Kabuki;
    kabuki.maleVictim = t"Character.LightCrowd_kabuki_ma";
    kabuki.femaleVictim = t"Character.LightCrowd_kabuki_wa";
    kabuki.coords = [
      new Vector4(-1017.837891, 1544.031250, 0.529869, 1.0),
      new Vector4(-831.619507, 1911.959595, 35.659103, 1.0),
      new Vector4(-1191.495117, 1252.922729, 17.390549, 1.0)
    ];
    ArrayPush(this.districts, kabuki);
    ArrayPush(this.districtsPrologue, kabuki);
    // Wellsprings
    let wellsprings: ref<TeleportData> = new TeleportData();
    wellsprings.district = gamedataDistrict.Wellsprings;
    wellsprings.maleVictim = t"Character.LightCrowd_wellsprings_ma";
    wellsprings.femaleVictim = t"Character.LightCrowd_wellsprings_wa";
    wellsprings.coords = [
      new Vector4(-2354.901855, -1165.460815, 1.493042, 1.0),
      new Vector4(-2490.846680, -1060.975952, 0.175583, 1.0)
    ];
    ArrayPush(this.districts, wellsprings);
    // Coast View
    let coast: ref<TeleportData> = new TeleportData();
    coast.district = gamedataDistrict.Coastview;
    coast.maleVictim = t"Character.LightCrowd_coastview_ma";
    coast.femaleVictim = t"Character.LightCrowd_coastview_wa";
    coast.coords = [
      new Vector4(-1968.451904, -1663.577637, 3.290024, 1.0),
      new Vector4(-2185.085693, -1941.897461, 6.915680, 1.0),
      new Vector4(-2235.793701, -2214.437988, 11.647858, 1.0),
      new Vector4(-2067.569580, -1767.490967, 2.241234, 1.0)
    ];
    ArrayPush(this.districts, coast);
    // Westwind Estate
    let westWind: ref<TeleportData> = new TeleportData();
    westWind.district = gamedataDistrict.WestWindEstate;
    westWind.maleVictim = t"Character.LightCrowd_west_wind_estate_ma";
    westWind.femaleVictim = t"Character.LightCrowd_west_wind_estate_wa";
    westWind.coords = [
      new Vector4(-2740.440430, -2410.323975, 7.528984, 1.0),
      new Vector4(-2854.782959, -2388.929688, 5.057793, 1.0)
    ];
    ArrayPush(this.districts, westWind);
    // Arroyo
    let arroyo: ref<TeleportData> = new TeleportData();
    arroyo.district = gamedataDistrict.Arroyo;
    arroyo.maleVictim = t"Character.LightCrowd_arroyo_ma";
    arroyo.femaleVictim = t"Character.LightCrowd_arroyo_wa";
    arroyo.coords = [
      new Vector4(127.458481, -720.647705, 7.349251, 1.0),
      new Vector4(-625.327515, -1315.032349, 7.558945, 1.0),
      new Vector4(-816.726685, -1352.448242, 7.709442, 1.0)
    ];
    ArrayPush(this.districts, arroyo);
    // Little China
    let littleChina: ref<TeleportData> = new TeleportData();
    littleChina.district = gamedataDistrict.LittleChina;
    littleChina.maleVictim = t"Character.LightCrowd_littlechina_ma";
    littleChina.femaleVictim = t"Character.LightCrowd_littlechina_wa";
    littleChina.coords = [
      new Vector4(-1739.493774, 1214.428101, 18.234169, 1.0)
    ];
    ArrayPush(this.districts, littleChina);
    ArrayPush(this.districtsPrologue, littleChina);
  }
}

public class TeleportData {
  public let district: gamedataDistrict;
  public let coords: array<Vector4>;
  public let maleVictim: TweakDBID;
  public let femaleVictim: TweakDBID;

  public static func GetRandomCoordinates(data: ref<TeleportData>) -> Vector4 {
    let index: Int32 = RandRange(0, ArraySize(data.coords));
    return data.coords[index];
  }
}
