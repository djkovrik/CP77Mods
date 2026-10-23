module MetroPocketGuide.Navigator
import MetroPocketGuide.Graph.MetroNodesGraph
import MetroPocketGuide.Config.MetroPocketGuideConfig

public class PocketMetroNavigator extends ScriptableSystem {
  private let player: wref<PlayerPuppet>;
  private let uiSystem: wref<UISystem>;

  private let route: array<ref<RoutePoint>>;

  private let departure: ENcartStations;
  private let destination: ENcartStations;

  private let departureLine: ModNCartLine;
  private let destinationLine: ModNCartLine;
  private let previousLine: ModNCartLine;
  private let currentLine: ModNCartLine;

  private let prevActiveStation: ENcartStations;
  private let prevNextStation: ENcartStations;
  private let activeStation: ENcartStations;
  private let nextStation: ENcartStations;

  private let isMetroRideActive: Bool = false;

  // Static helpers
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


  // Init
  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return ;
    };

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.player = player;
      this.uiSystem = GameInstance.GetUISystem(player.GetGame());
    };

    this.Reset();
 
    MetroLog("PocketMetroNavigator initialized");
  }


  // Called immediately after entering metro
  public final func OnMetroLineChanged(id: Int32) -> Void {
    let line: ModNCartLine = MetroDataHelper.LineName(id);
    if Equals(line, ModNCartLine.NONE) { return ; };
    if Equals(this.currentLine, ModNCartLine.NONE) {
      this.currentLine = this.departureLine;
    };

    this.previousLine = this.currentLine;
    this.currentLine = line;
    TrackLog(s">> Line changed from \(this.previousLine) to \(this.currentLine)");
    this.HandleLineChange();
  }

  // Called when departured from current station to station with id
  public final func OnMetroStationChangedNext(id: Int32) -> Void {
    let station: ENcartStations = MetroDataHelper.GetStationNameById(id);
    if Equals(station, ENcartStations.NONE) { return ; };

    this.prevNextStation = this.nextStation;
    this.nextStation = station;
    TrackLog(s">> Next station changed from \(GetLocalizedText(MetroDataHelper.GetStationTitle(this.prevNextStation))) [\(this.prevNextStation)] to \(GetLocalizedText(MetroDataHelper.GetStationTitle(this.nextStation))) [\(this.nextStation)]");
    this.HandleStationUpdateNext();
  }

  // Called right before arrival to station with id
  public final func OnMetroStationChangedActive(id: Int32) -> Void {
    let station: ENcartStations = MetroDataHelper.GetStationNameById(id);
    if Equals(station, ENcartStations.NONE) { return ; };

    this.prevActiveStation = this.activeStation;
    this.activeStation = station;
    TrackLog(s">> Active station changed from \(GetLocalizedText(MetroDataHelper.GetStationTitle(this.prevActiveStation))) [\(this.prevActiveStation)] to \(GetLocalizedText(MetroDataHelper.GetStationTitle(this.activeStation))) [\(this.activeStation)]");
    this.HandleStationUpdateActive();
  }


  // React to line switch
  private final func HandleLineChange() -> Void {
    if Equals(ArraySize(this.route), 0) { return ; };

    TrackLog(s"HandleLineChange: previous line \(this.previousLine), current line \(this.currentLine)");
  }

  // React to next station update
  private final func HandleStationUpdateNext() -> Void {
    if Equals(ArraySize(this.route), 0) { return ; };
    this.uiSystem.QueueEvent(PocketMetroStationVisitedEvent.Create(this.currentLine, this.activeStation));    
  }

  // React to active station update
  private final func HandleStationUpdateActive() -> Void {
    if Equals(ArraySize(this.route), 0) { return ; };
    this.uiSystem.QueueEvent(PocketMetroStationActivatedEvent.Create(this.currentLine, this.activeStation));
  }

  // Metro enter/exit
  public final func OnMetroEnter() -> Void {
    MetroLog("Metro ride started");
    this.InvalidateNavigatorControlsVisibility();
    this.isMetroRideActive = true;
  }

  public final func OnMetroExit() -> Void {
    MetroLog("Metro ride stopped");
    this.RemoveNavigatorHints();
    this.isMetroRideActive = false;
    this.CheckForRouteEnd();
  }

  public final func CheckIfShouldDisplayControls() -> Void {
    if this.isMetroRideActive {
      MetroLog("Refresh controls visibility");
      this.InvalidateNavigatorControlsVisibility();
    };
  }

  private final func InvalidateNavigatorControlsVisibility() -> Void {
    let config: ref<MetroPocketGuideConfig> = new MetroPocketGuideConfig();
    if config.visibleByDefault {
      this.uiSystem.QueueEvent(new ShowPocketGuideWidgetEvent());
      this.uiSystem.QueueEvent(new HidePocketGuideInputHintsEvent());
    } else {
      this.uiSystem.QueueEvent(new HidePocketGuideWidgetEvent());
      this.uiSystem.QueueEvent(new ShowPocketGuideInputHintsEvent());
    };
  }

  private final func RemoveNavigatorHints() -> Void {
    this.uiSystem.QueueEvent(new ClearPocketGuideInputHintsOnExitEvent());
  }

  // Route data

  public final func BuildRoute() -> Bool {
    if Equals(this.departure, ENcartStations.NONE) || Equals(this.destination, ENcartStations.NONE) {
      return false;
    };

    this.route = MetroNodesGraph.FindRoute(this.departure, this.destination);
    let routeAvailable: Bool = ArraySize(this.route) > 0;
    if routeAvailable {
      this.PopulateWithInitialValues();
    } else {
      this.Reset();
    };
    return routeAvailable;
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

  public final func SetRoute(route: array<ref<RoutePoint>>) -> Void {
    this.route = route;
  }

  public final func GetActiveRouteSegment() -> ref<RouteSegment> {
    let point: ref<RoutePoint>;
    let activeStationPointIndex: Int32 = -1;
    let nextStationPointIndex: Int32 = -1;
    let count: Int32 = ArraySize(this.route);
    let i: Int32 = 0;
    let shouldContinue: Bool = true;
    while i < count && shouldContinue {
      point = this.route[i];
      if Equals(point.station, this.activeStation) {
        shouldContinue = false;
        activeStationPointIndex = i;
      }
      i += 1;
    };

    nextStationPointIndex = activeStationPointIndex + 1;

    if Equals(activeStationPointIndex, -1) || nextStationPointIndex > (count - 1) {
      return null;
    };

    let activeStationPoint: ref<RoutePoint> = this.route[activeStationPointIndex];
    let nextStationPoint: ref<RoutePoint> = this.route[nextStationPointIndex];
    let lineSwitch: ref<LineSwitch> = nextStationPoint.AsLineSwitch();
    let stationPoint: ref<StationPoint> = nextStationPoint.AsStationPoint();
    let segmentLine: ModNCartLine = ModNCartLine.NONE;
    if IsDefined(lineSwitch) {
      segmentLine = lineSwitch.from;
    } else if IsDefined(stationPoint) {
      segmentLine = stationPoint.line;
    };

    let segment: ref<RouteSegment> = RouteSegment.Create(activeStationPoint.stationId, nextStationPoint.stationId, segmentLine);
    MetroLog(s"Active route segment found: \(segment.Str())");
    return segment;
  }

  public final func CheckForRouteEnd() -> Void {
    if Equals(this.destination, this.activeStation) {
      TrackLog("+ Destination point reached");
      this.Reset();
    };
  }

  // Utils
  public final func PopulateWithInitialValues() -> Void {
    this.departureLine = this.route[0].AsStationPoint().line;
    this.destinationLine = this.route[ArraySize(this.route) - 1].AsStationPoint().line;
    this.previousLine = this.departureLine;
    this.currentLine = this.departureLine;
    
    this.prevActiveStation = this.departure;
    this.prevNextStation = this.departure;
    this.activeStation = this.departure;
    this.nextStation = this.departure;
  }

  public final func Reset() -> Void {
    ArrayClear(this.route);
    this.departure = ENcartStations.NONE;
    this.destination = ENcartStations.NONE;

    this.departureLine = ModNCartLine.NONE;
    this.destinationLine = ModNCartLine.NONE;
    this.previousLine = ModNCartLine.NONE;
    this.currentLine = ModNCartLine.NONE;

    this.prevActiveStation = ENcartStations.NONE;
    this.prevNextStation = ENcartStations.NONE;
    this.activeStation = ENcartStations.NONE;
    this.nextStation = ENcartStations.NONE;

    this.isMetroRideActive = false;

    this.uiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(this.GetDeparture()));
    this.uiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(this.GetDestination()));
    this.uiSystem.QueueEvent(new HidePocketGuideWidgetEvent());
    this.uiSystem.QueueEvent(new RemovePocketGuideFromHudEvent());
  }
}
