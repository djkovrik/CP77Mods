module MetroPocketGuide.Navigator
import MetroPocketGuide.Graph.MetroNodesGraph

public class PocketMetroNavigator extends ScriptableEnv {

  public let departure: ENcartStations;
  public let destination: ENcartStations;
  public let route: array<ref<RoutePoint>>;

  private cb func OnLoad() {
    MetroLog("PocketMetroNavigator initialized");
  }

  public static final func Get() -> ref<PocketMetroNavigator> {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return env;
  }

  public static final func IsSelectedAsRoute(target: ENcartStations) -> Bool {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    let departure: ENcartStations = env.GetDeparture();
    let destination: ENcartStations = env.GetDestination();
    return NotEquals(target, ENcartStations.NONE) && (Equals(target, departure) || Equals(target, destination));
  }

  // Non-static helpers

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

  public final func OnCanceled() -> Void {
    ArrayClear(this.route);
    this.departure = ENcartStations.NONE;
    this.destination = ENcartStations.NONE;
  }
}
