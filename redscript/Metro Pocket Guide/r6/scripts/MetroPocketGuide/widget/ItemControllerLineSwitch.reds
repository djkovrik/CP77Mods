module MetroPocketGuide.UI
import MetroPocketGuide.Utils.MPGUtils

public class TrackedRouteLineSwitchItemController extends TrackedRouteBaseItemController {
  private let data: ref<LineSwitch>;
  private let from: wref<inkImage>;
  private let to: wref<inkImage>;
  private let title: wref<inkText>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.InitializeRefs();
  }

  private final func InitializeRefs() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.from = root.GetWidgetByPathName(n"container/lineFrom") as inkImage;
    this.to = root.GetWidgetByPathName(n"container/lineTo") as inkImage;
    this.title = root.GetWidgetByPathName(n"container/label") as inkText;
  }

  protected cb func OnUninitialize() -> Bool {
    super.OnUninitialize();
  }

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as LineSwitch;
    if IsDefined(this.data) {
      this.InitializeWidget();
    };
  }

  private final func InitializeWidget() -> Void {
    // Icons
    this.from.SetTexturePart(MPGUtils.GetLinePartName(this.data.from));
    this.to.SetTexturePart(MPGUtils.GetLinePartName(this.data.to));
    // Icons colors
    this.from.SetTintColor(MPGUtils.GetLineHDRColor(this.data.from));
    this.to.SetTintColor(MPGUtils.GetLineHDRColor(this.data.to));
    // Station title
    this.title.SetText(this.data.stationTitle);
    // Status
    this.UpdateStatusView();
  }

  private final func UpdateStatusView() -> Void {
    if Equals(this.data.status, RoutePointStatus.VISITED) {
      this.Dim();
    };
  }

  protected cb func OnPocketMetroStationActivatedEvent(evt: ref<PocketMetroStationActivatedEvent>) -> Bool {
     if Equals(this.data.from, evt.line) && Equals(this.data.station, evt.station) {
      this.AnimateActivatedBlink();
    };
  }

  protected cb func OnPocketMetroStationVisitedEvent(evt: ref<PocketMetroStationVisitedEvent>) -> Bool {
    if Equals(this.data.to, evt.line) && Equals(this.data.station, evt.station) {
      this.AnimateVisitedTransparency();
    };
  }
}
