module MetroPocketGuide.UI

public class TrackedRouteStationItemController extends TrackedRouteBaseItemController {
  private let data: ref<StationPoint>;

  protected cb func OnInitialize() -> Bool {
    MetroLog("TrackedRouteStationItemController::OnInitialize");
  }

  protected cb func OnUninitialize() -> Bool {
    MetroLog("TrackedRouteStationItemController::OnUninitialize");
  }

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as StationPoint;
    if IsDefined(this.data) {
      this.RefreshView();
    };
  }

  private final func RefreshView() -> Void {
    MetroLog("TrackedRouteStationItemController::RefreshView");
  }
}
