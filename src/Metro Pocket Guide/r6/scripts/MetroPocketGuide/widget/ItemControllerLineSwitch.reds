module MetroPocketGuide.UI

public class TrackedRouteLineSwitchItemController extends TrackedRouteBaseItemController {
  private let data: ref<LineSwitch>;
  private let from: wref<inkImage>;
  private let to: wref<inkImage>;
  private let title: wref<inkText>;

  protected cb func OnInitialize() -> Bool {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.from = root.GetWidgetByPathName(n"container/lineFrom") as inkImage;
    this.to = root.GetWidgetByPathName(n"container/lineTo") as inkImage;
    this.title = root.GetWidgetByPathName(n"container/label") as inkText;
  }

  protected cb func OnUninitialize() -> Bool {}

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as LineSwitch;
    if IsDefined(this.data) {
      this.RefreshView();
    };
  }

  private final func RefreshView() -> Void {
    // Icons
    this.from.SetTexturePart(this.GetLinePartName(this.data.from));
    this.to.SetTexturePart(this.GetLinePartName(this.data.to));
    // Icons colors
    this.from.SetTintColor(this.GetLineHDRColor(this.data.from));
    this.to.SetTintColor(this.GetLineHDRColor(this.data.to));
    // Station title
    this.title.SetText(this.data.stationTitle);
  }
}
