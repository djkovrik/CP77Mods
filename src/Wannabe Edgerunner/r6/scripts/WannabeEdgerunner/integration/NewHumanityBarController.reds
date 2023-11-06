module Edgerunning.Controller
import Edgerunning.System.EdgerunningSystem

public class NewHumanityBarController extends inkGameController {

  private let player: wref<PlayerPuppet>;
  private let system: wref<EdgerunningSystem>;
  private let humanityCurrent: Int32;
  private let humanityTotal: Int32;
  private let psychosisThreshold: Int32;

  private let icon: ref<inkImage>;
  private let totalHumanityContainer: ref<inkWidget>;
  private let totalHumanityText: ref<inkText>;
  private let thresholdContainer: ref<inkWidget>;
  private let thresholdText: ref<inkText>;
  private let barsContainer: ref<inkHorizontalPanel>;
  private let background: ref<inkWidget>;
  private let indicator: ref<inkImage>;
  private let bars: array<wref<inkWidget>>;
  private let barGaps: array<Int32>;
  private let tooltipData: ref<RipperdocBarTooltipTooltipData>;
  private let barIntroAnimDef: ref<inkAnimDef>;
  private let iconIntroAnimDef: ref<inkAnimDef>;
  private let indicatorIntroAnimDef: ref<inkAnimDef>;
  private let humanityLabelIntroAnimDef: ref<inkAnimDef>;
  private let thresholdLabelIntroAnimDef: ref<inkAnimDef>;

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
    this.psychosisThreshold = this.system.GetPsychosisThreshold();

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.icon = root.GetWidgetByPathName(n"icon") as inkImage;
    this.totalHumanityContainer = root.GetWidgetByPathName(n"labelTotal");
    this.totalHumanityText = root.GetWidgetByPathName(n"labelTotal/text") as inkText;
    this.thresholdContainer = root.GetWidgetByPathName(n"labelThreshold");
    this.thresholdText = root.GetWidgetByPathName(n"labelThreshold/text") as inkText;
    this.barsContainer = root.GetWidgetByPathName(n"barsContainer") as inkHorizontalPanel;
    this.background = root.GetWidgetByPathName(n"background") as inkWidget;
    this.indicator = root.GetWidgetByPathName(n"indicator") as inkImage;

    this.Log(s"current \(this.humanityCurrent), total \(this.humanityTotal), bars \(this.GetBarCount())");

    this.InitCoreThings();
    this.SpawnBars();
  }

  private final func InitCoreThings() -> Void {
    this.tooltipData = new RipperdocBarTooltipTooltipData();

    ArrayPush(this.barGaps, 10);
    ArrayPush(this.barGaps, 20);
    ArrayPush(this.barGaps, 30);
    ArrayPush(this.barGaps, 40);

    this.SetupBarIntroAnimation();
    this.SetupIconAndLabelIntroAnimation();

    // Setup initial indicator position with translation - move with margin then
    this.indicator.SetTranslation(new Vector2(-56.0, 0.0));
    this.thresholdContainer.SetTranslation(new Vector2(-112.0, -40.0));

    // Set label values
    this.thresholdText.SetText(s"\(this.psychosisThreshold)");
    this.totalHumanityText.SetText(s"\(this.humanityCurrent)");

    // Register to callbacks
    this.icon.RegisterToCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.icon.RegisterToCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
    this.totalHumanityContainer.RegisterToCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.totalHumanityContainer.RegisterToCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
    this.indicator.RegisterToCallback(n"OnHoverOver", this, n"OnDangerSpanHoverOver");
    this.indicator.RegisterToCallback(n"OnHoverOut", this, n"OnDangerSpanHoverOut");
    this.thresholdContainer.RegisterToCallback(n"OnHoverOver", this, n"OnDangerSpanHoverOver");
    this.thresholdContainer.RegisterToCallback(n"OnHoverOut", this, n"OnDangerSpanHoverOut");
  }

  protected cb func OnUninitialize() -> Bool {
    this.icon.UnregisterFromCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.icon.UnregisterFromCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
    this.totalHumanityContainer.UnregisterFromCallback(n"OnHoverOver", this, n"OnCustomBarHoverOver");
    this.totalHumanityContainer.UnregisterFromCallback(n"OnHoverOut", this, n"OnCustomBarHoverOut");
    this.indicator.UnregisterFromCallback(n"OnHoverOver", this, n"OnDangerSpanHoverOver");
    this.indicator.UnregisterFromCallback(n"OnHoverOut", this, n"OnDangerSpanHoverOut");
    this.thresholdContainer.UnregisterFromCallback(n"OnHoverOver", this, n"OnDangerSpanHoverOver");
    this.thresholdContainer.UnregisterFromCallback(n"OnHoverOut", this, n"OnDangerSpanHoverOut");
  }

  private final func SpawnBars() -> Void {
    let i: Int32 = 1;
    let widget: ref<inkWidget>;
    while i <= this.GetBarCount() {
      widget = this.SpawnFromExternal(
        this.barsContainer, 
        r"base\\gameplay\\gui\\fullscreen\\wannabe_edgerunner_bars.inkwidget", 
        n"Bar:Edgerunning.Controller.NewHumanityBarItemController" // controller might not be needed
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

  protected cb func OnDangerSpanHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.indicator.UnbindProperty(n"tintColor");
    this.indicator.BindProperty(n"tintColor", n"MainColors.ActiveGreen");
  }

  protected cb func OnDangerSpanHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.indicator.UnbindProperty(n"tintColor");
    this.indicator.BindProperty(n"tintColor", n"MainColors.Green");
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
    let barsIntroDuration: Float = Cast<Float>(ArraySize(this.bars)) * this.barIntroAnimDuration;
    let options: inkAnimOptions;
    options.executionDelay = barsIntroDuration;
    this.icon.PlayAnimationWithOptions(this.iconIntroAnimDef, options);
    this.totalHumanityContainer.PlayAnimationWithOptions(this.humanityLabelIntroAnimDef, options);
    this.ShowThresholdIndicator(barsIntroDuration + 0.5);
  }

  private final func ShowThresholdIndicator(delay: Float) -> Void {
    let options: inkAnimOptions;
    options.executionDelay = delay;
    this.indicator.PlayAnimationWithOptions(this.indicatorIntroAnimDef, options);
    this.thresholdContainer.PlayAnimationWithOptions(this.thresholdLabelIntroAnimDef, options);
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

    this.humanityLabelIntroAnimDef = new inkAnimDef();
    this.humanityLabelIntroAnimDef.AddInterpolator(transparencyInterpolator);

    this.indicatorIntroAnimDef = new inkAnimDef();
    this.indicatorIntroAnimDef.AddInterpolator(transparencyInterpolator);

    this.thresholdLabelIntroAnimDef = new inkAnimDef();
    this.thresholdLabelIntroAnimDef.AddInterpolator(transparencyInterpolator);
  }

  private final func GetBarCount() -> Int32 {
    return this.humanityCurrent * this.barCount / this.humanityTotal;
  }

  private final func Log(str: String) -> Void {
    LogChannel(n"DEBUG", s"NewHumanityBarController: \(str)");
  }
}
