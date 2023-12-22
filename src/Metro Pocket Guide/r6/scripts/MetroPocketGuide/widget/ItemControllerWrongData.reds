module MetroPocketGuide.UI

public class TrackedRouteWrongDataItemController extends TrackedRouteBaseItemController {
  private let data: ref<MissedStationInfo>;

  protected cb func OnInitialize() -> Bool {
    MetroLog("TrackedRouteWrongDataItemController::OnInitialize");
  }

  protected cb func OnUninitialize() -> Bool {
    MetroLog("TrackedRouteWrongDataItemController::OnUninitialize");
  }

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as MissedStationInfo;
    if IsDefined(this.data) {
      this.RefreshView();
    };
  }

  private final func RefreshView() -> Void {
    MetroLog("TrackedRouteWrongDataItemController::RefreshView");
  }
}
