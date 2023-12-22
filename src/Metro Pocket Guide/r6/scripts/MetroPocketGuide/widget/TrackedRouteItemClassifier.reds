module MetroPocketGuide.UI

class TrackedRouteItemClassifier extends inkVirtualItemTemplateClassifier {
  public func ClassifyItem(data: Variant) -> Uint32 {
    let point: ref<RoutePoint> = FromVariant<ref<IScriptable>>(data) as RoutePoint;
    if !IsDefined(point) {
      return 2u;
    };

    if Equals(point.type, RoutePointType.STATION) {
      return 0u;
    };

    if Equals(point.type, RoutePointType.LINE_SWITCH) {
      return 1u;
    };
  
    return 2u;
  }
}
