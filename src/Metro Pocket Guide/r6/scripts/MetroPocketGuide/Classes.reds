public class MetroNode {
  let uniqueIndex: Int32;
  let stationId: Int32;
  let line: ModNCartLine;

  public static func Create(index: Int32, id: Int32, line: ModNCartLine) -> ref<MetroNode> {
    let instance: ref<MetroNode> = new MetroNode();
    instance.uniqueIndex = index;
    instance.stationId = id;
    instance.line = line;
    return instance;
  }

  public final func Key() -> Uint64 {
    return Cast<Uint64>(this.Index());
  }

  public final func Index() -> Int32 {
    return this.uniqueIndex;
  }

  public final func StationId() -> Int32 {
    return this.stationId;
  }

  public final func Line() -> ModNCartLine {
    return this.line;
  }

  public final func Str() -> String {
    return s"\(MetroDataHelper.LineStr(this.line))\(this.stationId)";
  }
}

public class MetroGraphNode {
  let neighbours: array<Int32>;

  public static func Create(neighbours: array<Int32>) -> ref<MetroGraphNode> {
    let instance: ref<MetroGraphNode> = new MetroGraphNode();
    instance.neighbours = neighbours;
    return instance;
  }

  public func GetNeighbours() -> array<Int32> {
    return this.neighbours;
  }
}

public class MetroNodesQueue {
  let internal: array<Int32>;

  public final func Add(item: Int32) -> Void {
    ArrayPush(this.internal, item);
  }

  public final func PopLeft() -> Int32 {
    if this.IsEmpty() {
      return 0;
    };

    let first: Int32 = this.internal[0];
    ArrayErase(this.internal, 0);
    return first;
  }

  public final func IsNotEmpty() -> Bool {
    return ArraySize(this.internal) > 0;
  }

  public final func IsEmpty() -> Bool {
    return !this.IsNotEmpty();
  }
}

public abstract class RoutePoint {
  let index: Int32;
  let type: RoutePointType;
  let status: RoutePointStatus;
  let station: ENcartStations;
  let stationId: Int32;

  public final func SetIndex(index: Int32) -> Void {
    this.index = index;
  }

  public final func UpdateStatus(status: RoutePointStatus) -> Void {
    this.status = status;
  }

  public final func GetStatus() -> RoutePointStatus {
    return this.status;
  }

  public final func IsStationPoint() -> Bool {
    return Equals(this.type, RoutePointType.STATION);
  }

  public final func IsLineSwitch() -> Bool {
    return Equals(this.type, RoutePointType.LINE_SWITCH);
  }

  public final func AsStationPoint() -> ref<StationPoint> {
    if Equals(this.type, RoutePointType.STATION) {
      return this as StationPoint;
    };

    return null;
  }

  public final func AsLineSwitch() -> ref<LineSwitch> {
    if Equals(this.type, RoutePointType.LINE_SWITCH) {
      return this as LineSwitch;
    };

    return null;
  }
}

public class StationPoint extends RoutePoint {
  let line: ModNCartLine;
  let startingPoint: Bool;
  let destinationPoint: Bool;
  let stationTitle: String;
  let district: ENcartDistricts;
  let districtTitle: String;

  public static func Create(stationId: Int32, line: ModNCartLine, start: Bool, destination: Bool) -> ref<StationPoint> {
    let station: ENcartStations = MetroDataHelper.GetStationNameById(stationId);
    let stationTitle: String = MetroDataHelper.GetStationTitle(station);
    let district: ENcartDistricts = MetroDataHelper.GetStationDistrict(station);
    let districtTitle: String = MetroDataHelper.GetDistrictTitle(district);
    let instance: ref<StationPoint> = new StationPoint();

    instance.type = RoutePointType.STATION;
    instance.stationId = stationId;
    instance.line = line;
    instance.startingPoint = start;
    instance.destinationPoint = destination;
    instance.station = station;
    instance.stationTitle = stationTitle;
    instance.district = district;
    instance.districtTitle = districtTitle;

    return instance;
  }

  public final func Str() -> String {
    return s"\(this.index): [\(MetroDataHelper.LineStr(this.line)): \(GetLocalizedText(this.stationTitle))] - \(this.station) (\(this.stationId))";
  };
}

public class LineSwitch extends RoutePoint {
  let from: ModNCartLine;
  let to: ModNCartLine;
  let stationTitle: String;

  public static func Create(stationId: Int32, from: ModNCartLine, to: ModNCartLine) -> ref<LineSwitch> {
    let station: ENcartStations = MetroDataHelper.GetStationNameById(stationId);
    let stationTitle: String = MetroDataHelper.GetStationTitle(station);
    let instance: ref<LineSwitch> = new LineSwitch();
    instance.type = RoutePointType.LINE_SWITCH;
    instance.stationId = stationId;
    instance.station = station;
    instance.stationTitle = stationTitle;
    instance.from = from;
    instance.to = to;
    return instance;
  }

  public final func Str() -> String {
    return s"\(this.index): [ Switch line at \(GetLocalizedText(this.stationTitle)) ] \(this.station) (\(this.stationId)): \(MetroDataHelper.LineStr(this.from)) -> \(MetroDataHelper.LineStr(this.to))]";
  };
}

public class PocketMetroRouteSelectionEnabledEvent extends Event {
  public static func Create() -> ref<PocketMetroRouteSelectionEnabledEvent> {
    let instance: ref<PocketMetroRouteSelectionEnabledEvent> = new PocketMetroRouteSelectionEnabledEvent();
    return instance;
  }
}

public class PocketMetroRouteSelectionDisabledEvent extends Event {
  public static func Create() -> ref<PocketMetroRouteSelectionDisabledEvent> {
    let instance: ref<PocketMetroRouteSelectionDisabledEvent> = new PocketMetroRouteSelectionDisabledEvent();
    return instance;
  }
}

public class PocketMetroPlayerMarkerVisibilityEvent extends Event {
  public let show: Bool;

  public static func Create(show: Bool) -> ref<PocketMetroPlayerMarkerVisibilityEvent> {
    let instance: ref<PocketMetroPlayerMarkerVisibilityEvent> = new PocketMetroPlayerMarkerVisibilityEvent();
    instance.show = show;
    return instance;
  }
}

public class PocketMetroResetPreviousDestinationEvent extends Event {
  public let destination: ENcartStations;

  public static func Create(destination: ENcartStations) -> ref<PocketMetroResetPreviousDestinationEvent> {
    let instance: ref<PocketMetroResetPreviousDestinationEvent> = new PocketMetroResetPreviousDestinationEvent();
    instance.destination = destination;
    return instance;
  }
}

public class PocketMetroStationActivatedEvent extends Event {
  public let line: ModNCartLine;
  public let station: ENcartStations;

  public static func Create(line: ModNCartLine, station: ENcartStations) -> ref<PocketMetroStationActivatedEvent> {
    let instance: ref<PocketMetroStationActivatedEvent> = new PocketMetroStationActivatedEvent();
    instance.line = line;
    instance.station = station;
    return instance;
  }
}

public class PocketMetroStationVisitedEvent extends Event {
  public let line: ModNCartLine;
  public let station: ENcartStations;

  public static func Create(line: ModNCartLine, station: ENcartStations) -> ref<PocketMetroStationVisitedEvent> {
    let instance: ref<PocketMetroStationVisitedEvent> = new PocketMetroStationVisitedEvent();
    instance.line = line;
    instance.station = station;
    return instance;
  }
}

public class LineDirectionData {
  let path: CName;
  let line: ModNCartLine;
  let stations: array<Int32>;
  let moveForward: Bool;

  public static func Create(path: CName, line: ModNCartLine, stations: array<Int32>, forward: Bool) -> ref<LineDirectionData> {
    let instance: ref<LineDirectionData> = new LineDirectionData();
    instance.path = path;
    instance.line = line;
    instance.stations = stations;
    instance.moveForward = forward;
    return instance;
  }
}

public class RouteSegment {
  let activeStationId: Int32;
  let nextStationId: Int32;
  let line: ModNCartLine;

  public static func Create(activeStationId: Int32, nextStationId: Int32, line: ModNCartLine) -> ref<RouteSegment> {
    let instance: ref<RouteSegment> = new RouteSegment();
    instance.activeStationId = activeStationId;
    instance.nextStationId = nextStationId;
    instance.line = line;
    return instance;
  }

  public final func Str() -> String {
    return s"[\(this.line): \(this.activeStationId) -> \(this.nextStationId)]";
  }
}

public class ShowPocketGuideWidgetEvent extends Event {}
public class HidePocketGuideWidgetEvent extends Event {}
public class ShowPocketGuideInputHintsEvent extends Event {}
public class HidePocketGuideInputHintsEvent extends Event {}
public class ClearPocketGuideInputHintsOnExitEvent extends Event {}
public class InjectPocketGuideToHudEvent extends Event {}
public class RemovePocketGuideFromHudEvent extends Event {}

enum RoutePointType {
  NONE = 0,
  STATION = 1,
  LINE_SWITCH = 2,
  MISSED_STATION = 3,
}

enum RoutePointStatus {
  NOT_VISITED = 0,
  ACTIVE = 1,
  VISITED = 2,
}

enum ModNCartLine {
  NONE = 0,
  A_RED = 1,
  B_YELLOW = 2,
  C_CYAN = 3,
  D_GREEN = 4,
  E_ORANGE = 5,
}

enum MpgControlMode {
  NAVIGATE = 0,
  CANCEL = 1,
  CONFIRM = 2,
  STOP = 3,
}