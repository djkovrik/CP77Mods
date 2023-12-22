module MetroPocketGuide.UI

public class TrackedRouteLineSwitchItemController extends TrackedRouteBaseItemController {
  private let data: ref<LineSwitch>;

  protected cb func OnInitialize() -> Bool {
    MetroLog("TrackedRouteLineSwitchItemController::OnInitialize");
  }

  protected cb func OnUninitialize() -> Bool {
    MetroLog("TrackedRouteLineSwitchItemController::OnUninitialize");
  }

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as LineSwitch;
    if IsDefined(this.data) {
      this.RefreshView();
    };
  }

  private final func RefreshView() -> Void {
    MetroLog("TrackedRouteLineSwitchItemController::RefreshView");
  }
}
