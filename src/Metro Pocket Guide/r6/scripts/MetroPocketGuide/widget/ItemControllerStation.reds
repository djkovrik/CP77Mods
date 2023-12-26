module MetroPocketGuide.UI
import MetroPocketGuide.Utils.MPGUtils

public class TrackedRouteStationItemController extends TrackedRouteBaseItemController {
  private let data: ref<StationPoint>;
  private let line: wref<inkImage>;
  private let stationStatus: wref<inkImage>;
  private let title: wref<inkText>;
  
  protected let outlinedAnimDef: ref<inkAnimDef>;
  protected let outlinedAnimProxy: ref<inkAnimProxy>;

  protected let filledAnimDef: ref<inkAnimDef>;
  protected let filledAnimProxy: ref<inkAnimProxy>;

  private let blinkAnimDuration: Float = 0.5;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();

    this.InitializeRefs();
    this.InitializeStationAnimDefs();
  }

  private final func InitializeRefs() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.line = root.GetWidgetByPathName(n"container/lineImage") as inkImage;
    this.stationStatus = root.GetWidgetByPathName(n"container/stationStatus") as inkImage;
    this.title = root.GetWidgetByPathName(n"container/stationName") as inkText;
  }

  private final func InitializeStationAnimDefs() -> Void {
    this.outlinedAnimDef = new inkAnimDef();
    let hideInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, 0.1, this.blinkAnimDuration, 0.0);
    this.outlinedAnimDef.AddInterpolator(hideInterpolator);

    this.filledAnimDef = new inkAnimDef();
    let showInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(0.1, 1.0, this.blinkAnimDuration, 0.0);
    this.filledAnimDef.AddInterpolator(showInterpolator);
  }

  protected cb func OnUninitialize() -> Bool {
    super.OnUninitialize();
    this.outlinedAnimProxy.Stop();
    this.outlinedAnimProxy = null;
    this.outlinedAnimDef = null;
    this.filledAnimProxy.Stop();
    this.filledAnimProxy = null;
    this.filledAnimDef = null;
  }

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as StationPoint;
    if IsDefined(this.data) {
      this.InitializeWidget();
    };
  }

  private final func InitializeWidget() -> Void {
    // Icon
    this.line.SetTexturePart(MPGUtils.GetLinePartName(this.data.line));
    // Icon color
    this.line.SetTintColor(MPGUtils.GetLineHDRColor(this.data.line));
    this.stationStatus.SetTintColor(MPGUtils.GetLineHDRColor(this.data.line));
    // Station title
    this.title.SetText(this.data.stationTitle);
    // Station status
    this.stationStatus.SetTexturePart(n"station");
    // Status
    this.UpdateStatusView();
  }

  private final func UpdateStatusView() -> Void {
    if Equals(this.data.status, RoutePointStatus.VISITED) {
      this.stationStatus.SetTexturePart(n"station-filled");
      this.Dim();
    } else if Equals(this.data.status, RoutePointStatus.ACTIVE) {
      this.stationStatus.SetTexturePart(n"station-filled");
    };
  }

  protected cb func OnPocketMetroStationActivatedEvent(evt: ref<PocketMetroStationActivatedEvent>) -> Bool {
    if Equals(this.data.line, evt.line) && Equals(this.data.station, evt.station) {
      this.AnimateActivatedIcon();
    };
  }

  protected cb func OnPocketMetroStationVisitedEvent(evt: ref<PocketMetroStationVisitedEvent>) -> Bool {
    if Equals(this.data.line, evt.line) && Equals(this.data.station, evt.station) {
      this.AnimateVisitedTransparency();
    };
  }

  private final func AnimateActivatedIcon() -> Void {
    this.outlinedAnimProxy.Stop();
    this.outlinedAnimProxy = this.stationStatus.PlayAnimation(this.outlinedAnimDef);
    this.outlinedAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutlinedAnimFinished");
  }

  protected cb func OnOutlinedAnimFinished(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnOutlinedAnimFinished");
    this.stationStatus.SetTexturePart(n"station-filled");
    this.filledAnimProxy.Stop();
    this.filledAnimProxy = this.stationStatus.PlayAnimation(this.filledAnimDef);
    this.filledAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFilledAnimFinished");
  }

  protected cb func OnFilledAnimFinished(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnFilledAnimFinished");
    this.AnimateActivatedBlink();
  }
}
