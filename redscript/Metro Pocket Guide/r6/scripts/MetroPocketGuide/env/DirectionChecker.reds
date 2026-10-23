module MetroPocketGuide.Graph
import MetroPocketGuide.Navigator.* 

public class MetroDirectionChecker extends ScriptableEnv {
  let lineFacts: ref<inkHashMap>;

  private cb func OnLoad() {
    this.lineFacts = new inkHashMap();
    this.PopulateData();
  }

  public static final func GetRecommendedHighlight(activeLines: array<CName>) -> ref<LineDirectionData> {
    let env: ref<MetroDirectionChecker> = ScriptableEnv.Get(n"MetroPocketGuide.Graph.MetroDirectionChecker") as MetroDirectionChecker;
    return env.FindDirectionData(activeLines);
  }

  public final func FindDirectionData(activeLines: array<CName>) -> ref<LineDirectionData> {
    let navigator: ref<PocketMetroNavigator> = PocketMetroNavigator.GetInstance(GetGameInstance());
    let segment: ref<RouteSegment> = navigator.GetActiveRouteSegment();
    let directionData: ref<LineDirectionData>;
    let activeIndex: Int32;
    let nextIndex: Int32;
    let isMovingForward: Bool;
    for activeLine in activeLines {
      directionData = this.GetData(activeLine);
      if Equals(directionData.line, segment.line) && ArrayContains(directionData.stations, segment.activeStationId) && ArrayContains(directionData.stations, segment.nextStationId) {
        activeIndex = this.IndexOf(directionData.stations, segment.activeStationId);
        nextIndex = this.IndexOf(directionData.stations, segment.nextStationId);
        isMovingForward = nextIndex > activeIndex;
        if Equals(directionData.moveForward, isMovingForward) || Equals(directionData.line, ModNCartLine.D_GREEN) {
          MetroLog(s"Found direction data for \(activeLine)");
          return directionData;
        };
      };
    }

    return null;
  }

  public final func PopulateData() -> Void {
    let lineA: array<Int32> = [ 1, 2, 3, 7, 9, 10, 14, 8, 15 ];
    let lineB: array<Int32> = [ 19, 18, 12, 7, 16, 5, 17, 15 ];
    let lineC: array<Int32> = [ 10, 14, 8, 19 ];
    let lineD: array<Int32> = [ 6, 5, 4, 9, 10, 14, 13, 11, 12, 18 ];
    let lineE: array<Int32> = [ 1, 2, 16, 7, 11, 13, 14, 6, 5, 4, 17 ];

    this.PutData(n"ue_metro_show_line_a1", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineA1", ModNCartLine.A_RED, lineA, false));
    this.PutData(n"ue_metro_show_line_a2", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineA2", ModNCartLine.A_RED, lineA, true));
    this.PutData(n"ue_metro_show_line_b1", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineB1", ModNCartLine.B_YELLOW, lineB, false));
    this.PutData(n"ue_metro_show_line_b2", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineB2", ModNCartLine.B_YELLOW, lineB, true));
    this.PutData(n"ue_metro_show_line_c1", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineC1", ModNCartLine.C_CYAN, lineC, false));
    this.PutData(n"ue_metro_show_line_c2", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineC2", ModNCartLine.C_CYAN, lineC, true));
    this.PutData(n"ue_metro_show_line_d1", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineD", ModNCartLine.D_GREEN, lineD, false));
    this.PutData(n"ue_metro_show_line_d2", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineD", ModNCartLine.D_GREEN, lineD, true));
    this.PutData(n"ue_metro_show_line_e1", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineE1", ModNCartLine.E_ORANGE, lineE, false));
    this.PutData(n"ue_metro_show_line_e2", LineDirectionData.Create(n"ButtonHolder/ButtonFlex/ButtonPane/ButtonLineE2", ModNCartLine.E_ORANGE, lineE, true));
  }

  private final func PutData(key: CName, data: ref<LineDirectionData>) -> Void {
    let hash: Uint64 = NameToHash(key);
    this.lineFacts.Insert(hash, data);
  }

  private final func GetData(key: CName) -> ref<LineDirectionData> {
    let hash: Uint64 = NameToHash(key);
    let item: ref<LineDirectionData>;
    if this.lineFacts.KeyExist(hash) {
      item = this.lineFacts.Get(hash) as LineDirectionData;
      if IsDefined(item) {
        return item;
      };
    };

    return null;
  }

  private final func IndexOf(src: array<Int32>, element: Int32) -> Int32 {
    let count:Int32 = ArraySize(src);
    let i: Int32 = 0;
    while i < count {
      if Equals(src[i], element) {
        return i;
      };
      i += 1;
    };
    return -1;
  }
}
