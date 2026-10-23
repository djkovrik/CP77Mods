module MetroPocketGuide.UI

public class TrackedRouteDataView extends ScriptableDataView {

  public func UpdateView() {
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftEntry: ref<RoutePoint> = left as RoutePoint;
    let rightEntry: ref<RoutePoint> = right as RoutePoint;

    return leftEntry.index < rightEntry.index;
  }
}
