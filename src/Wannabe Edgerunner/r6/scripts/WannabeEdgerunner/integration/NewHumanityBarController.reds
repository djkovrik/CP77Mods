module Edgerunning.Controller
import Edgerunning.System.EdgerunningSystem

public class NewHumanityBarController extends inkGameController {

  private let player: wref<PlayerPuppet>;
  private let system: wref<EdgerunningSystem>;
  private let humanityCurrent: Int32;
  private let humanityTotal: Int32;

  private let icon: ref<inkImage>;
  private let labelContainer: ref<inkWidget>;
  private let labelText: ref<inkText>;
  private let barsContainer: ref<inkHorizontalPanel>;
  private let background: ref<inkWidget>;
  private let bars: array<wref<inkWidget>>;
  private let barGaps: array<Int32>;
  private let tooltipData: ref<RipperdocBarTooltipTooltipData>;
  private let barIntroAnimDef: ref<inkAnimDef>;
  private let iconIntroAnimDef: ref<inkAnimDef>;
  private let labelIntroAnimDef: ref<inkAnimDef>;

  private let barCount: Int32 = 50;
  private let barMarginNormal: Float = 9.0;
  private let barMarginBig: Float = 21.0;
  private let barWidth: Float = 9.0;
  private let barIntroAnimDuration: Float = 0.01;
  private let iconLabelIntroAnimDuration: Float = 0.75;
  private let barDisplayed: Bool = false;

  protected cb func OnInitialize() {
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.system = EdgerunningSystem.GetInstance(this.player.GetGame());
    this.humanityCurrent = this.system.GetHumanityCurrent();
    this.humanityTotal = this.system.GetHumanityTotal();

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.icon = root.GetWidgetByPathName(n"icon") as inkImage;
    this.labelContainer = root.GetWidgetByPathName(n"label");
    this.labelText = root.GetWidgetByPathName(n"label/text") as inkText;
    this.barsContainer = root.GetWidgetByPathName(n"barsContainer") as inkHorizontalPanel;
    this.background = root.GetWidgetByPathName(n"background") as inkWidget;

    this.Log(s"current \(this.humanityCurrent), total \(this.humanityTotal), bars \(this.GetBarCount())");

    this.InitCoreThings();
    this.SpawnBars();
  }

  protected cb func OnCyberwareMenuBarAppeared(evt: ref<CyberwareMenuBarAppeared>) -> Bool {
    if !this.barDisplayed {
      this.barDisplayed = true;
      this.ShowBars();
      this.ShowIconAndLabel();
    };
  }

  protected cb func OnCustomBarHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let barHoverOverEvent: ref<CustomBarHoverOverEvent> = new CustomBarHoverOverEvent();
    barHoverOverEvent.humanityCurrent = this.humanityCurrent;
    barHoverOverEvent.humanityTotal = this.humanityTotal;
    barHoverOverEvent.humanityAdditionalDesc = this.system.GetAdditionalPenaltiesDescription();
    this.QueueEvent(barHoverOverEvent);
  }

  protected cb func OnCustomBarHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let barHoverOutEvent: ref<CustomBarHoverOutEvent> = new CustomBarHoverOutEvent();
    this.QueueEvent(barHoverOutEvent);
  }

  private final func InitCoreThings() -> Void {
    this.tooltipData = new RipperdocBarTooltipTooltipData();

    ArrayPush(this.barGaps, 10);
    ArrayPush(this.barGaps, 20);
    ArrayPush(this.barGaps, 30);
    ArrayPush(this.barGaps, 40);

    this.SetupBarIntroAnimation();
    this.SetupIconAndLabelIntroAnimation();

    this.barsContainer.SetVisible(false);
    this.background.SetVisible(false);
    this.icon.SetOpacity(0.0);
    this.labelContainer.SetOpacity(0.0);
    this.labelText.SetText(s"\(this.humanityCurrent)");

    this.icon.RegisterToCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.icon.RegisterToCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
    this.labelContainer.RegisterToCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.labelContainer.RegisterToCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
  }

  protected cb func OnUninitialize() -> Bool {
    this.icon.UnregisterFromCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.icon.UnregisterFromCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
    this.labelContainer.UnregisterFromCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.labelContainer.UnregisterFromCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
  }

  private final func SpawnBars() -> Void {
    let i: Int32 = 1;
    let widget: ref<inkWidget>;
    while i <= this.GetBarCount() {
      widget = this.SpawnFromExternal(
        this.barsContainer, 
        r"base\\gameplay\\gui\\fullscreen\\wannabe_edgerunner_bars.inkwidget", 
        n"Bar:Edgerunning.Controller.NewHumanityBarItemController"
      );

      let rightMargin: Float;
      if ArrayContains(this.barGaps, i) {
        rightMargin = this.barMarginBig + this.barWidth;
      } else {
        rightMargin = this.barMarginNormal + this.barWidth;
      };

      widget.SetScale(new Vector2(0.0, 1.0));
      widget.SetMargin(0.0, 0.0, rightMargin, 0.0);
      ArrayPush(this.bars, widget);

      i += 1;
    };
  }

  private final func ShowBars() -> Void {
    let i: Int32 = 0;
    let widget: ref<inkWidget>;

    this.barsContainer.SetVisible(true);
    this.background.SetVisible(true);

    while i < ArraySize(this.bars) {
      widget = this.bars[i];
      let options: inkAnimOptions;
      options.executionDelay = Cast<Float>(i) * this.barIntroAnimDuration;
      widget.PlayAnimationWithOptions(this.barIntroAnimDef, options);
      i += 1;
    };
  }

  private final func ShowIconAndLabel() -> Void {
    let options: inkAnimOptions;
    options.executionDelay = Cast<Float>(ArraySize(this.bars)) * this.barIntroAnimDuration;
    this.icon.PlayAnimationWithOptions(this.iconIntroAnimDef, options);
    this.labelContainer.PlayAnimationWithOptions(this.labelIntroAnimDef, options);
  }

  private final func SetupBarIntroAnimation() -> Void {
    this.barIntroAnimDef = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetStartScale(new Vector2(0.0, 1.0));
    scaleInterpolator.SetEndScale(new Vector2(1.0, 1.0));
    scaleInterpolator.SetDuration(this.barIntroAnimDuration);
    this.barIntroAnimDef.AddInterpolator(scaleInterpolator);
  }

  private final func SetupIconAndLabelIntroAnimation() -> Void {
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartDelay(0.5);
    transparencyInterpolator.SetEndTransparency(1.0);
    transparencyInterpolator.SetDuration(this.iconLabelIntroAnimDuration);

    this.iconIntroAnimDef = new inkAnimDef();
    this.iconIntroAnimDef.AddInterpolator(transparencyInterpolator);

    this.labelIntroAnimDef = new inkAnimDef();
    this.labelIntroAnimDef.AddInterpolator(transparencyInterpolator);
  }

  private final func GetBarCount() -> Int32 {
    return this.humanityCurrent * this.barCount / this.humanityTotal;
  }

  private final func Log(str: String) -> Void {
    LogChannel(n"DEBUG", s"NewHumanityBarController: \(str)");
  }
}
