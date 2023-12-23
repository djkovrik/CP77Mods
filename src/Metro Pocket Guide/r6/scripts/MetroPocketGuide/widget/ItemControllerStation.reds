module MetroPocketGuide.UI

public class TrackedRouteStationItemController extends TrackedRouteBaseItemController {
  private let data: ref<StationPoint>;
  private let line: wref<inkImage>;
  private let stationStatus: wref<inkImage>;
  private let title: wref<inkText>;

  protected cb func OnInitialize() -> Bool {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.line = root.GetWidgetByPathName(n"container/lineImage") as inkImage;
    this.stationStatus = root.GetWidgetByPathName(n"container/stationStatus") as inkImage;
    this.title = root.GetWidgetByPathName(n"container/stationName") as inkText;
  }

  protected cb func OnUninitialize() -> Bool {}

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as StationPoint;
    if IsDefined(this.data) {
      this.RefreshView();
    };
  }

  private final func RefreshView() -> Void {
    // Icon
    this.line.SetTexturePart(this.GetLinePartName(this.data.line));
    // Icon color
    this.line.SetTintColor(this.GetLineHDRColor(this.data.line));
    this.stationStatus.SetTintColor(this.GetLineHDRColor(this.data.line));
    // Station title
    this.title.SetText(this.data.stationTitle);
    // Station status
    if Equals(this.data.status, RoutePointStatus.VISITED) {
      this.stationStatus.SetTexturePart(n"station-filled");
    } else {
      this.stationStatus.SetTexturePart(n"station");
    };
  }
}
