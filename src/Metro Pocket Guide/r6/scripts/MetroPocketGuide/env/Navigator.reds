module MetroPocketGuide.Navigator
import MetroPocketGuide.Graph.MetroNodesGraph

public class PocketMetroNavigator extends ScriptableEnv {

  public let departure: ENcartStations;
  public let destination: ENcartStations;
  public let route: array<ref<RoutePoint>>;

  private cb func OnLoad() {
    MetroLog("PocketMetroNavigator initialized");
  }

  public static final func BuildRoute() -> Bool {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return env.CalculateRoute();
  }

  public static final func GetRoute() -> array<ref<RoutePoint>>  {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return env.Route();
  }

  public static final func HasActiveRoute() -> Bool {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return env.IsRouteActive();
  }

  public static final func SaveDeparture(departure: ENcartStations) -> Void {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    env.SetDeparture(departure);
  }

  public static final func SaveDestination(destination: ENcartStations) -> Void {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    env.SetDestination(destination);
  }

  public static final func GetDeparture() -> ENcartStations {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return env.Departure();
  }

  public static final func GetDestination() -> ENcartStations {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    return env.Destination();
  }

  public static final func OnCanceled() -> Void {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    env.Clear();
  }

  public static final func IsSelectedAsRoute(target: ENcartStations) -> Bool {
    let env: ref<PocketMetroNavigator> = ScriptableEnv.Get(n"MetroPocketGuide.Navigator.PocketMetroNavigator") as PocketMetroNavigator;
    let departure: ENcartStations = env.Departure();
    let destination: ENcartStations = env.Destination();
    return NotEquals(target, ENcartStations.NONE) && (Equals(target, departure) || Equals(target, destination));
  }

  // Non-static helpers

  public final func CalculateRoute() -> Bool {
    if Equals(this.departure, ENcartStations.NONE) || Equals(this.destination, ENcartStations.NONE) {
      return false;
    };

    this.route = MetroNodesGraph.FindRoute(this.departure, this.destination);
    return ArraySize(this.route) > 0;
  }

  public final func Route() -> array<ref<RoutePoint>> {
    return this.route;
  }

  public final func IsRouteActive() -> Bool {
    return NotEquals(this.departure, ENcartStations.NONE) && NotEquals(this.destination, ENcartStations.NONE) && ArraySize(this.route) > 0;
  }


  public final func SetDeparture(station: ENcartStations) -> Void {
    this.departure = station;
  }

  public final func SetDestination(station: ENcartStations) -> Void {
    this.destination = station;
  }

  public final func SetRoute(route: array<ref<RoutePoint>>) -> Void {
    this.route = route;
  }

  public final func Departure() -> ENcartStations {
    return this.departure;
  }

  public final func Destination() -> ENcartStations {
    return this.destination;
  }

  public final func Clear() -> Void {
    ArrayClear(this.route);
    this.departure = ENcartStations.NONE;
    this.destination = ENcartStations.NONE;
  }
}
