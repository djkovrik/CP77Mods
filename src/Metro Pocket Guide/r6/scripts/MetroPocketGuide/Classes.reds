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
  let type: RoutePointType;
}

public class StationPoint extends RoutePoint {
  let id: Int32;
  let line: ModNCartLine;
  let startingPoint: Bool;
  let destinationPoint: Bool;
  let station: ENcartStations;
  let stationTitle: String;
  let district: ENcartDistricts;
  let districtTitle: String;

  public static func Create(id: Int32, line: ModNCartLine, start: Bool, destination: Bool) -> ref<StationPoint> {
    let station: ENcartStations = MetroDataHelper.GetStationNameById(id);
    let stationTitle: String = MetroDataHelper.GetStationTitle(station);
    let district: ENcartDistricts = MetroDataHelper.GetStationDistrict(station);
    let districtTitle: String = MetroDataHelper.GetDistrictTitle(district);
    let instance: ref<StationPoint> = new StationPoint();

    instance.type = RoutePointType.STATION;
    instance.id = id;
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
    return s"[\(MetroDataHelper.LineStr(this.line)): \(GetLocalizedText(this.stationTitle))]";
  };
}

public class LineSwitch extends RoutePoint {
  let from: ModNCartLine;
  let to: ModNCartLine;

  public static func Create(from: ModNCartLine, to: ModNCartLine) -> ref<LineSwitch> {
    let instance: ref<LineSwitch> = new LineSwitch();
    instance.type = RoutePointType.LINE_SWITCH;
    instance.from = from;
    instance.to = to;
    return instance;
  }

  public final func Str() -> String {
    return s"[ Switch line: \(MetroDataHelper.LineStr(this.from)) -> \(MetroDataHelper.LineStr(this.to)) ]";
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

enum RoutePointType {
  NONE = 0,
  STATION = 1,
  LINE_SWITCH = 2,
}

enum ModNCartLine {
  NONE = 0,
  A_RED = 1,
  B_YELLOW = 2,
  C_CYAN = 3,
  D_GREEN = 4,
  E_ORANGE = 5,
}
