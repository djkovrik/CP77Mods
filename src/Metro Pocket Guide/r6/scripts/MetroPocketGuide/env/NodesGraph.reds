module MetroPocketGuide.Graph
import MetroPocketGuide.Navigator.* 
// FIXME

public class MetroNodesGraph extends ScriptableEnv {
  private let graph: ref<inkHashMap>;
  private let stations: ref<inkHashMap>;
  private let n: Int32 = 43;

  private cb func OnLoad() {
    this.graph = new inkHashMap();
    this.stations = new inkHashMap();

    this.PopulateGraph();
    MetroLog("MetroNodesGraph created");
  }

  public static final func FindRoute(from: ENcartStations, to: ENcartStations) -> array<ref<RoutePoint>> {
    let env: ref<MetroNodesGraph> = ScriptableEnv.Get(n"MetroPocketGuide.Graph.MetroNodesGraph") as MetroNodesGraph;
    let path: array<Int32> = env.FindShortestPath(from, to);
    let prettyPath: array<ref<MetroNode>> = env.PrettifyPath(path);
    let route: array<ref<RoutePoint>> = env.BuildRouteDetails(prettyPath);
    env.PrintRoute(route, from, to);
    return route;
  }

  public final func BuildRouteDetails(path: array<ref<MetroNode>>) -> array<ref<RoutePoint>> {
    let tempRoute: array<ref<RoutePoint>>;
    let route: array<ref<RoutePoint>>;
    if Equals(ArraySize(path), 0) { return tempRoute; };
    let previousLine: ModNCartLine = ModNCartLine.NONE;
    let currentLine: ModNCartLine = ModNCartLine.NONE;
    let count: Int32 = ArraySize(path);
    let i: Int32 = 0;
    let node: ref<MetroNode>;
    let point: ref<RoutePoint>;
    while i < count {
      node = path[i];
      previousLine = currentLine;
      currentLine = node.Line();
      if NotEquals(previousLine, ModNCartLine.NONE) && NotEquals(previousLine, currentLine) {
        ArrayPush(tempRoute, LineSwitch.Create(previousLine, currentLine));
      };
      ArrayPush(tempRoute, StationPoint.Create(node.StationId(), node.Line(), Equals(i, 0), Equals(i, count - 1)));
      i += 1;
    };

    count = ArraySize(tempRoute);
    i = 0;
    while i < count {
      point = tempRoute[i];
      point.SetIndex(i);
      ArrayPush(route, point);
      i += 1;
    };

    return route;
  }

  public final func PrettifyPath(path: array<Int32>) -> array<ref<MetroNode>> {
    let result: array<ref<MetroNode>>;
    let node: ref<MetroNode>;
    for point in path {
      node = this.GetNode(point);
      if IsDefined(node) { ArrayPush(result, node); };
    };

    return result;
  }

  public final func FindShortestPath(from: ENcartStations, to: ENcartStations) -> array<Int32> {
    let startingStationId: Int32 = MetroDataHelper.GetStationIdByName(from);
    let startingStationLines: array<ModNCartLine> = MetroDataHelper.GetStationLinesById(startingStationId);
    let destinationStationId: Int32 = MetroDataHelper.GetStationIdByName(to);
    let destinationStationLines: array<ModNCartLine> = MetroDataHelper.GetStationLinesById(destinationStationId);
    let allPaths: array<array<Int32>>;

    if Equals(ArraySize(destinationStationLines), 0) { return []; };

    // Iterate through all possible start + end combos
    let start: ref<MetroNode>;
    let end: ref<MetroNode>;
    for startLineToCheck in startingStationLines {
      start = this.FindNode(startingStationId, startLineToCheck);
      for destLineToCheck in destinationStationLines {
        end = this.FindNode(destinationStationId, destLineToCheck);
        let from: Int32 = start.Index();
        let to: Int32 = end.Index();
        let rawPath: array<Int32> = this.BFS(from, to);
        ArrayPush(allPaths, rawPath);
      };
    };

    let minLength: Int32 = 100;
    let minIndex: Int32 = -1;
    let size: Int32 = ArraySize(allPaths);
    let i: Int32 = 0;
    while i < size {
      let arrayRecord: array<Int32> = allPaths[i];
      let arraySize: Int32 = ArraySize(arrayRecord);
      if arraySize < minLength {
        minLength = arraySize;
        minIndex = i;
      };
      i += 1;
    };

    if NotEquals(minIndex, -1) {
      return allPaths[minIndex];
    };

    return [];
  }

  private final func BFS(from: Int32, to: Int32) -> array<Int32> {
    let dest: array<Int32> = this.Solve(from);
    let path: array<Int32> = this.ReconstructPath(from, to, dest);
    return path;
  }


  private final func Solve(index: Int32) -> array<Int32> {
    let queue: ref<MetroNodesQueue> = new MetroNodesQueue();
    queue.Add(index);

    let visited: array<Bool>;
    let dest: array<Int32>;

    let i: Int32 = 0;
    while i < this.n {
      ArrayPush(visited, false);
      i += 1;
    };

    visited[index] = true;
    
    i = 0;
    while i < this.n {
      ArrayPush(dest, -1);
      i += 1;
    };

    while queue.IsNotEmpty() {
      let curr = queue.PopLeft();
      let node = this.graph.Get(Cast<Uint64>(curr)) as MetroGraphNode;
      let neighbours: array<Int32> = node.GetNeighbours();
      for next in neighbours {
        if !visited[next] {
          queue.Add(next);
          visited[next] = true;
          dest[next] = curr;
        };
      };
    };

    return dest;
  }

  private final func ReconstructPath(s: Int32, e: Int32, dest: array<Int32>) -> array<Int32> {
    let path: array<Int32>;
    let at = e;
    while at != -1 {
      ArrayPush(path, at);
      at = dest[at];
    };

    let reversed: array<Int32> = this.ReverseArray(path);
    if Equals(reversed[0], s) {
      return reversed;
    };

    return [];
  }

  private final func ReverseArray(source: array<Int32>) -> array<Int32> {
    let result: array<Int32>;
    let i: Int32 = ArraySize(source) - 1;
    while i >= 0 {
      ArrayPush(result, source[i]);
      i -= 1;
    };

    return result;
  }

  private final func PopulateGraph() -> Void {
    // Line A
    let A1 = MetroNode.Create(1, 1, ModNCartLine.A_RED); this.SaveNode(A1);
    let A2 = MetroNode.Create(2, 2, ModNCartLine.A_RED); this.SaveNode(A2);
    let A3 = MetroNode.Create(3, 3, ModNCartLine.A_RED); this.SaveNode(A3);
    let A7 = MetroNode.Create(4, 7, ModNCartLine.A_RED); this.SaveNode(A7);
    let A9 = MetroNode.Create(5, 9, ModNCartLine.A_RED); this.SaveNode(A9);
    let A10 = MetroNode.Create(6, 10, ModNCartLine.A_RED); this.SaveNode(A10);
    let A14 = MetroNode.Create(7, 14, ModNCartLine.A_RED); this.SaveNode(A14);
    let A8 = MetroNode.Create(8, 8, ModNCartLine.A_RED); this.SaveNode(A8);
    let A15 = MetroNode.Create(9, 15, ModNCartLine.A_RED); this.SaveNode(A15);
    // Line B
    let B15 = MetroNode.Create(10, 15, ModNCartLine.B_YELLOW); this.SaveNode(B15);
    let B17 = MetroNode.Create(11, 17, ModNCartLine.B_YELLOW); this.SaveNode(B17);
    let B5 = MetroNode.Create(12, 5, ModNCartLine.B_YELLOW); this.SaveNode(B5);
    let B16 = MetroNode.Create(13, 16, ModNCartLine.B_YELLOW); this.SaveNode(B16);
    let B7 = MetroNode.Create(14, 7, ModNCartLine.B_YELLOW); this.SaveNode(B7);
    let B12 = MetroNode.Create(15, 12, ModNCartLine.B_YELLOW); this.SaveNode(B12);
    let B18 = MetroNode.Create(16, 18, ModNCartLine.B_YELLOW); this.SaveNode(B18);
    let B19 = MetroNode.Create(17, 19, ModNCartLine.B_YELLOW); this.SaveNode(B19);
    // Line C
    let C10 = MetroNode.Create(18, 10, ModNCartLine.C_CYAN); this.SaveNode(C10);
    let C14 = MetroNode.Create(19, 14, ModNCartLine.C_CYAN); this.SaveNode(C14);
    let C8 = MetroNode.Create(20, 8, ModNCartLine.C_CYAN); this.SaveNode(C8);
    let C19 = MetroNode.Create(21, 19, ModNCartLine.C_CYAN); this.SaveNode(C19);
    // Line D
    let D14 = MetroNode.Create(22, 14, ModNCartLine.D_GREEN); this.SaveNode(D14);
    let D6 = MetroNode.Create(23, 6, ModNCartLine.D_GREEN); this.SaveNode(D6);
    let D5 = MetroNode.Create(24, 5, ModNCartLine.D_GREEN); this.SaveNode(D5);
    let D4 = MetroNode.Create(25, 4, ModNCartLine.D_GREEN); this.SaveNode(D4);
    let D9 = MetroNode.Create(26, 9, ModNCartLine.D_GREEN); this.SaveNode(D9);
    let D10 = MetroNode.Create(27, 10, ModNCartLine.D_GREEN); this.SaveNode(D10);
    let D13 = MetroNode.Create(28, 13, ModNCartLine.D_GREEN); this.SaveNode(D13);
    let D11 = MetroNode.Create(29, 11, ModNCartLine.D_GREEN); this.SaveNode(D11);
    let D12 = MetroNode.Create(30, 12, ModNCartLine.D_GREEN); this.SaveNode(D12);
    let D18 = MetroNode.Create(31, 18, ModNCartLine.D_GREEN); this.SaveNode(D18);
    // Line E
    let E1 = MetroNode.Create(32, 1, ModNCartLine.E_ORANGE); this.SaveNode(E1);
    let E2 = MetroNode.Create(33, 2, ModNCartLine.E_ORANGE); this.SaveNode(E2);
    let E16 = MetroNode.Create(34, 16, ModNCartLine.E_ORANGE); this.SaveNode(E16);
    let E7 = MetroNode.Create(35, 7, ModNCartLine.E_ORANGE); this.SaveNode(E7);
    let E11 = MetroNode.Create(36, 11, ModNCartLine.E_ORANGE); this.SaveNode(E11);
    let E13 = MetroNode.Create(37, 13, ModNCartLine.E_ORANGE); this.SaveNode(E13);
    let E14 = MetroNode.Create(38, 14, ModNCartLine.E_ORANGE); this.SaveNode(E14);
    let E6 = MetroNode.Create(39, 6, ModNCartLine.E_ORANGE); this.SaveNode(E6);
    let E5 = MetroNode.Create(40, 5, ModNCartLine.E_ORANGE); this.SaveNode(E5);
    let E4 = MetroNode.Create(41, 4, ModNCartLine.E_ORANGE); this.SaveNode(E4);
    let E17 = MetroNode.Create(42, 17, ModNCartLine.E_ORANGE); this.SaveNode(E17);
    
    // -- Build graph, reference: https://i.imgur.com/31FWf9N.png
    this.graph.Insert(A1.Key(), MetroGraphNode.Create([ A2.Index(), E1.Index() ])); // A1
    this.graph.Insert(A2.Key(), MetroGraphNode.Create([ A1.Index(), A3.Index(), E2.Index() ])); // A2
    this.graph.Insert(A3.Key(), MetroGraphNode.Create([ A2.Index(), A7.Index() ])); // A3
    this.graph.Insert(A7.Key(), MetroGraphNode.Create([ A3.Index(), A9.Index(), B7.Index(), E7.Index() ])); // A7
    this.graph.Insert(A9.Key(), MetroGraphNode.Create([ A7.Index(), A10.Index(), D9.Index() ])); // A9
    this.graph.Insert(A10.Key(), MetroGraphNode.Create([ A9.Index(), A14.Index(), C10.Index(), D10.Index() ])); // A10
    this.graph.Insert(A14.Key(), MetroGraphNode.Create([ A10.Index(), A8.Index(), C14.Index(), D14.Index(), E14.Index() ])); // A14
    this.graph.Insert(A8.Key(), MetroGraphNode.Create([ A14.Index(), A15.Index(), C8.Index() ])); // A8
    this.graph.Insert(A15.Key(), MetroGraphNode.Create([ A8.Index(), B15.Index() ])); // A15

    this.graph.Insert(B15.Key(), MetroGraphNode.Create([ A15.Index(), B17.Index() ])); // B15
    this.graph.Insert(B17.Key(), MetroGraphNode.Create([ B15.Index(), B5.Index(), E17.Index() ])); // B17
    this.graph.Insert(B5.Key(), MetroGraphNode.Create([ B16.Index(), B17.Index(), D5.Index(), E5.Index() ])); // B5
    this.graph.Insert(B16.Key(), MetroGraphNode.Create([ B7.Index(), B5.Index(), E16.Index() ])); // B16
    this.graph.Insert(B7.Key(), MetroGraphNode.Create([ B12.Index(), B16.Index(), A7.Index(), E7.Index() ])); // B7
    this.graph.Insert(B12.Key(), MetroGraphNode.Create([ B7.Index(), B18.Index(), D12.Index() ])); // B12
    this.graph.Insert(B18.Key(), MetroGraphNode.Create([ B12.Index(), B19.Index(), D18.Index() ])); // B18
    this.graph.Insert(B19.Key(), MetroGraphNode.Create([ B18.Index(), C19.Index() ])); // B19

    this.graph.Insert(C10.Key(), MetroGraphNode.Create([ C14.Index(), A10.Index(), D10.Index() ])); // C10
    this.graph.Insert(C14.Key(), MetroGraphNode.Create([ C10.Index(), C8.Index(), A14.Index(), D14.Index(), E14.Index() ])); // C14
    this.graph.Insert(C8.Key(), MetroGraphNode.Create([ C19.Index(), C14.Index(), A8.Index() ])); // C8
    this.graph.Insert(C19.Key(), MetroGraphNode.Create([ C8.Index(), B19.Index() ])); // C19

    this.graph.Insert(D14.Key(), MetroGraphNode.Create([ D6.Index(), D13.Index(), A14.Index(), C14.Index(), E14.Index() ])); // D14
    this.graph.Insert(D6.Key(), MetroGraphNode.Create([ D5.Index(), E6.Index() ])); // D6
    this.graph.Insert(D5.Key(), MetroGraphNode.Create([ D4.Index(), B5.Index(), E5.Index() ])); // D5
    this.graph.Insert(D4.Key(), MetroGraphNode.Create([ D9.Index(), E4.Index() ])) ;// D4
    this.graph.Insert(D9.Key(), MetroGraphNode.Create([ D10.Index(), A9.Index() ])); // D9
    this.graph.Insert(D10.Key(), MetroGraphNode.Create([ D14.Index(), A10.Index(), C10.Index() ])); // D10
    this.graph.Insert(D13.Key(), MetroGraphNode.Create([ D11.Index(), E13.Index() ])); // D13
    this.graph.Insert(D11.Key(), MetroGraphNode.Create([ D12.Index(), E11.Index() ])); // D11
    this.graph.Insert(D12.Key(), MetroGraphNode.Create([ D18.Index(), B12.Index() ])); // D12
    this.graph.Insert(D18.Key(), MetroGraphNode.Create([ D14.Index(), B18.Index() ])); // D18

    this.graph.Insert(E1.Key(), MetroGraphNode.Create([ E2.Index(), A1.Index() ])); // E1
    this.graph.Insert(E2.Key(), MetroGraphNode.Create([ E16.Index(), E1.Index(), A2.Index() ])); // E2
    this.graph.Insert(E16.Key(), MetroGraphNode.Create([ E7.Index(), E2.Index(), B16.Index() ])); // E16
    this.graph.Insert(E7.Key(), MetroGraphNode.Create([ E11.Index(), E16.Index(), A7.Index(), B7.Index() ])); // E7
    this.graph.Insert(E11.Key(), MetroGraphNode.Create([ E13.Index(), E7.Index(), D11.Index() ])); // E11
    this.graph.Insert(E13.Key(), MetroGraphNode.Create([ E14.Index(), E11.Index(), D13.Index() ])); // E13
    this.graph.Insert(E14.Key(), MetroGraphNode.Create([ E6.Index(), E13.Index(), A14.Index(), C14.Index(), D14.Index() ])); // E14
    this.graph.Insert(E6.Key(), MetroGraphNode.Create([ E5.Index(), E14.Index(), D6.Index() ])); // E6
    this.graph.Insert(E5.Key(), MetroGraphNode.Create([ E4.Index(), E6.Index(), B5.Index(), D5.Index() ])); // E5
    this.graph.Insert(E4.Key(), MetroGraphNode.Create([ E17.Index(), E5.Index(), D4.Index() ])); // E4
    this.graph.Insert(E17.Key(), MetroGraphNode.Create([ E4.Index(), B17.Index() ])); // E17
  }

  private final func SaveNode(node: ref<MetroNode>) -> Void {
    let key: Uint64 = node.Key();
    this.stations.Insert(key, node);
  }

  private final func GetNode(uniqueIndex: Int32) -> ref<MetroNode> {
    let key: Uint64 = Cast<Uint64>(uniqueIndex);
    let station: ref<MetroNode> = this.stations.Get(key) as MetroNode;
    return station;
  }

  private final func FindNode(stationId: Int32, line: ModNCartLine) -> ref<MetroNode> {
    let values: array<wref<IScriptable>>;
    let node: ref<MetroNode>;
    this.stations.GetValues(values);

    for value in values {
      node = value as MetroNode;
      if IsDefined(node) {
        if Equals(node.StationId(), stationId) && Equals(node.Line(), line) {
          return node;
        };
      };
    };

    return null;
  }

  private final func PrintRoute(route: array<ref<RoutePoint>>, from: ENcartStations, to: ENcartStations) -> Void {
    MetroLog(s"Route from \(GetLocalizedText(MetroDataHelper.GetStationTitle(from))) to \(GetLocalizedText(MetroDataHelper.GetStationTitle(to))): ");
    for r in route {
      if Equals(r.type, RoutePointType.STATION) {
        let point = r as StationPoint;
        MetroLog(point.Str());
      };
      if Equals(r.type, RoutePointType.LINE_SWITCH) {
        let point = r as LineSwitch;
        MetroLog(point.Str());
      };
    };
  }

  // FIXME
  public static final func DoTestRoute() -> Void {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    let route: array<ref<RoutePoint>>;
    let station1 = StationPoint.Create(1, ModNCartLine.A_RED, true, false);
    let station2 = StationPoint.Create(2, ModNCartLine.A_RED, false, false);
    let lineSwitch = LineSwitch.Create(ModNCartLine.A_RED, ModNCartLine.B_YELLOW);
    let station3 = StationPoint.Create(3, ModNCartLine.B_YELLOW, false, true);
    let error = MissedStationInfo.Create();
    station1.index = 1;
    station2.index = 2;
    lineSwitch.index = 3;
    station3.index = 4;
    error.index = 5;

    ArrayPush(route, station1);
    ArrayPush(route, station2);
    ArrayPush(route, lineSwitch);
    ArrayPush(route, station3);
    ArrayPush(route, error);
    env.route = route;
    MetroLog(s"Test route created: \(ArraySize(env.route))");
  }
}
