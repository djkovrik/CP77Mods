module AtelierDelivery

/**
  Creating new drop point instance:
  - add new entry to AtelierDeliveryDropPoint enum (Classes.reds)
  - add new entry to enum->locKey mapper in GetDeliveryPointLocKey (Utils.reds)
  - add new entry to Init below

  inkatlas texturePart name should match uniqueTag
**/
public class AtelierDropPointsSpawnerConfig {
  private let spawnPoints: ref<inkHashMap>;
  private let iterationTagsPrologue: array<CName>;
  private let iterationTagsNightCity: array<CName>;
  private let iterationTagsDogtown: array<CName>;

  public final func Init() -> Void {
    this.spawnPoints = new inkHashMap();
  }

  public final func BuildPrologueList() -> Void {
    // PROLOGUE ITERATION: 
    let iterationTagPrologue: CName = n"NightCity_Prologue1";
    let iterationSpawnsPrologue: array<ref<AtelierDropPointInstance>>;
    ArrayPush(this.iterationTagsPrologue, iterationTagPrologue);

    // Watson, Little China
    ArrayPush(
      iterationSpawnsPrologue,
      AtelierDropPointInstance.Create(
        "LocKey#10963",
        t"Districts.Watson",
        t"Districts.LittleChina",
        AtelierDeliveryDropPoint.LittleChina,
        n"LittleChina",
        n"droppoint19",
        iterationTagPrologue,
        this.CreatePosition(-1450.845215, 1221.096802, 23.061127, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.928518, 0.371288),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints2.inkatlas"
      )
    );

    let iterationListPrologue: ref<AtelierDropPointsList> = AtelierDropPointsList.Create(iterationSpawnsPrologue);
    this.spawnPoints.Insert(this.Key(iterationTagPrologue), iterationListPrologue);
    this.Log(s"Stored \(ArraySize(iterationListPrologue.points)) points for key \(this.Key(iterationTagPrologue))");
  }

  // When any new version adds more drop points then new iteration tag must be used
  public final func BuildNightCityList() -> Void {
    // ITERATION #1:
    let iterationTag1: CName = n"NightCity_Iteration1";
    let iterationSpawns1: array<ref<AtelierDropPointInstance>>;
    ArrayPush(this.iterationTagsNightCity, iterationTag1);

    // Watson, Little China
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44450",
        t"Districts.Watson",
        t"Districts.LittleChina",
        AtelierDeliveryDropPoint.MegabuildingH10,
        n"MegabuildingH10",
        n"droppoint1",
        iterationTag1,
        this.CreatePosition(-1443.939209, 1339.663208, 119.082382, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.728089, -0.663599),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Watson, Kabuki
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44430",
        t"Districts.Watson",
        t"Districts.Kabuki",
        AtelierDeliveryDropPoint.KabukiMarket,
        n"KabukiMarket",
        n"droppoint2",
        iterationTag1,
        this.CreatePosition(-1242.697614, 2021.161367, 11.915947, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.469456, 0.844077),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Watson, Northside
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44415",
        t"Districts.Watson",
        t"Districts.Northside",
        AtelierDeliveryDropPoint.MartinSt,
        n"MartinSt",
        n"droppoint3",
        iterationTag1,
        this.CreatePosition(-1475.607837, 2192.650830, 18.200005, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.490099, 0.892979),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Watson, Arasaka Waterfront
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95277",
        t"Districts.Watson",
        t"Districts.ArasakaWaterfront",
        AtelierDeliveryDropPoint.EisenhowerSt,
        n"EisenhowerSt",
        n"droppoint4",
        iterationTag1,
        this.CreatePosition(-1767.295410, 1869.108765, 18.257347, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.258819, 0.965926),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Westbrook, Charter Hill
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#21266",
        t"Districts.Westbrook",
        t"Districts.CharterHill",
        AtelierDeliveryDropPoint.CharterHill,
        n"CharterHill",
        n"droppoint5",
        iterationTag1,
        this.CreatePosition(-124.690515, 156.954523, 14.669594, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.891798, -0.452434),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
 
    // Westbrook, Japantown
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#21233",
        t"Districts.Westbrook",
        t"Districts.JapanTown",
        AtelierDeliveryDropPoint.CherryBlossomMarket,
        n"CherryBlossomMarket",
        n"droppoint6",
        iterationTag1,
        this.CreatePosition(-693.016819, 912.408923, 12.0, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.078458, 0.996917),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Westbrook, North Oak
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44579",
        t"Districts.Westbrook",
        t"Districts.NorthOaks",
        AtelierDeliveryDropPoint.NorthOakSign,
        n"NorthOakSign",
        n"droppoint7",
        iterationTag1,
        this.CreatePosition(294.980853, 817.504370, 146.618530, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.998797, 0.049033),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // City Center, Corpo Plaza
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95266",
        t"Districts.CityCenter",
        t"Districts.CorpoPlaza",
        AtelierDeliveryDropPoint.SarastiAndRepublic,
        n"SarastiAndRepublic",
        n"droppoint8",
        iterationTag1,
        this.CreatePosition(-1487.291138, 449.454785, 7.739998, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.999962, -0.008727),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // City Center, Downtown
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44500",
        t"Districts.CityCenter",
        t"Districts.Downtown",
        AtelierDeliveryDropPoint.CorporationSt,
        n"CorporationSt",
        n"droppoint9",
        iterationTag1,
        this.CreatePosition(-2394.930420, -59.059253, 9.682861, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.686005, 0.665941),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Heywood, The Glen
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44519",
        t"Districts.Heywood",
        t"Districts.Glen",
        AtelierDeliveryDropPoint.MegabuildingH3,
        n"MegabuildingH3",
        n"droppoint10",
        iterationTag1,
        this.CreatePosition(-1196.130127, -930.899170, 12.044189, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.078459, 0.996917),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Heywood, Vista del Rey
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95271",
        t"Districts.Heywood",
        t"Districts.VistaDelRey",
        AtelierDeliveryDropPoint.CongressMlk,
        n"CongressMlk",
        n"droppoint11",
        iterationTag1,
        this.CreatePosition(-1074.648804, -399.022583, 8.066277, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.455593, 0.890188),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Heywood, Wellsprings
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44501",
        t"Districts.Heywood",
        t"Districts.Wellsprings",
        AtelierDeliveryDropPoint.CanneryPlaza,
        n"CanneryPlaza",
        n"droppoint12",
        iterationTag1,
        this.CreatePosition(-2390.791504, -573.703809, 7.000175, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.009234, 0.999957),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Santo Domingo, Arroyo
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95265",
        t"Districts.SantoDomingo",
        t"Districts.Arroyo",
        AtelierDeliveryDropPoint.WollesenSt,
        n"WollesenSt",
        n"droppoint13",
        iterationTag1,
        this.CreatePosition(-1074.211060, -1424.782959, 30.799721, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.898061, 0.439872),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Santo Domingo, Rancho Coronado
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95272",
        t"Districts.SantoDomingo",
        t"Districts.RanchoCoronado",
        AtelierDeliveryDropPoint.MegabuildingH7,
        n"MegabuildingH7",
        n"droppoint14",
        iterationTag1,
        this.CreatePosition(152.273178, -1177.103882, 31.511642, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.956156, -0.292857),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Pacifica, Coastview
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95276",
        t"Districts.Pacifica",
        t"Districts.Coastview",
        AtelierDeliveryDropPoint.PacificaStadium,
        n"PacificaStadium",
        n"droppoint15",
        iterationTag1,
        this.CreatePosition(-1563.313354, -1956.801025, 72.923096, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.549048, 0.835791),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Pacifica, West Wind Estate
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#10958",
        t"Districts.Pacifica",
        t"Districts.WestWindEstate",
        AtelierDeliveryDropPoint.WestWindEstate,
        n"WestWindEstate",
        n"droppoint16",
        iterationTag1,
        this.CreatePosition(-2605.829834, -2477.411621, 17.262611, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.206258, 0.978498),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    // Badlands, Red Peaks
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#37971",
        t"Districts.Badlands",
        t"Districts.RedPeaks",
        AtelierDeliveryDropPoint.SunsetMotel,
        n"SunsetMotel",
        n"droppoint17",
        iterationTag1,
        this.CreatePosition(1607.783374, -799.309924, 49.814171, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.199249, 0.979949),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    let iterationList1: ref<AtelierDropPointsList> = AtelierDropPointsList.Create(iterationSpawns1);
    this.spawnPoints.Insert(this.Key(iterationTag1), iterationList1);
    this.Log(s"Stored \(ArraySize(iterationList1.points)) points for key \(this.Key(iterationTag1))");
  }


  // When any new version adds more drop points then new iteration tag must be used
  public final func BuildDogtownList() -> Void {
    // ITERATION #1:
    let iterationTag1: CName = n"Dogtown_Iteration1";
    let iterationSpawns1: array<ref<AtelierDropPointInstance>>;
    ArrayPush(this.iterationTagsDogtown, iterationTag1);

    // Pacifica, Dogtown
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#93789",
        t"Districts.Pacifica",
        t"Districts.Dogtown",
        AtelierDeliveryDropPoint.LongshoreStacks,
        n"LongshoreStacks",
        n"droppoint18",
        iterationTag1,
        this.CreatePosition(-2427.495068, -2709.809326, 23.894119, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.693709, 0.720255),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );

    let iterationList1: ref<AtelierDropPointsList> = AtelierDropPointsList.Create(iterationSpawns1);
    this.spawnPoints.Insert(this.Key(iterationTag1), iterationList1);
    this.Log(s"Stored \(ArraySize(iterationList1.points)) points for key \(this.Key(iterationTag1))");
  }

  public final func GetSpawnPointsByTag(tag: CName) -> array<ref<AtelierDropPointInstance>> {
    let key: Uint64 = this.Key(tag);
    let pointsList: ref<AtelierDropPointsList>;
    let emptyArray: array<ref<AtelierDropPointInstance>>;
    if this.spawnPoints.KeyExist(key) {
      pointsList = this.spawnPoints.Get(key) as AtelierDropPointsList;
      return pointsList.points;
    };

    return emptyArray;
  }

  public final func GetIterationTagsPrologue() -> array<CName> {
    return this.iterationTagsPrologue;
  }

  public final func GetIterationTagsNightCity() -> array<CName> {
    return this.iterationTagsNightCity;
  }

  public final func GetIterationTagsDogtown() -> array<CName> {
    return this.iterationTagsDogtown;
  }

  private final func CreatePosition(x: Float, y: Float, z: Float, w: Float) -> Vector4 {
    let instance: Vector4 = Vector4(x, y, z, w);
    return instance;
  }

  private final func CreateOrientation(i: Float, j: Float, k: Float, r: Float) -> Quaternion {
    let instance: Quaternion;
    instance.i = i;
    instance.j = j;
    instance.k = k;
    instance.r = r;
    return instance;
  }

  private final func Key(tag: CName) -> Uint64 {
    return NameToHash(tag);
  }

  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliverySpawnerConfig", str);
    };
  }
}
