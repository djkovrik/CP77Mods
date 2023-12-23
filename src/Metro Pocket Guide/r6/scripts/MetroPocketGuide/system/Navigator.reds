module MetroPocketGuide.Navigator
import MetroPocketGuide.Graph.MetroNodesGraph

public class PocketMetroNavigator extends ScriptableSystem {
  public let departure: ENcartStations;
  public let destination: ENcartStations;
  public let route: array<ref<RoutePoint>>;

  public let currentStationIndex: Int32;
  public let currentLine: ModNCartLine;

  public static func GetInstance(gi: GameInstance) -> ref<PocketMetroNavigator> {
    let system: ref<PocketMetroNavigator> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return system;
  }

  public static final func IsSelectedAsRoute(target: ENcartStations) -> Bool {
    let system: ref<PocketMetroNavigator> = PocketMetroNavigator.GetInstance(GetGameInstance());
    let departure: ENcartStations = system.GetDeparture();
    let destination: ENcartStations = system.GetDestination();
    return NotEquals(target, ENcartStations.NONE) && (Equals(target, departure) || Equals(target, destination));
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return ;
    };

    this.Reset();
    MetroLog("PocketMetroNavigator initialized");
  }

  public final func BuildRoute() -> Bool {
    if Equals(this.departure, ENcartStations.NONE) || Equals(this.destination, ENcartStations.NONE) {
      return false;
    };

    this.route = MetroNodesGraph.FindRoute(this.departure, this.destination);
    return ArraySize(this.route) > 0;
  }

  public final func HasActiveRoute() -> Bool {
    return NotEquals(this.departure, ENcartStations.NONE) && NotEquals(this.destination, ENcartStations.NONE) && ArraySize(this.route) > 0;
  }

  public final func SaveDeparture(station: ENcartStations) -> Void {
    this.departure = station;
  }

  public final func SaveDestination(station: ENcartStations) -> Void {
    this.destination = station;
  }

  public final func GetDeparture() -> ENcartStations {
    return this.departure;
  }

  public final func GetDestination() -> ENcartStations {
    return this.destination;
  }

  public final func GetRoute() -> array<ref<RoutePoint>> {
    return this.route;
  }

  public final func Reset() -> Void {
    ArrayClear(this.route);
    this.departure = ENcartStations.NONE;
    this.destination = ENcartStations.NONE;
    this.currentStationIndex = -1;
    this.currentLine = ModNCartLine.NONE;
  }
}
