module HudPainter

public class CustomColorPickerSliderController extends inkLogicController {
  private let presetValue: Int32;
  private let currentValue: Int32;
  private let color: SliderColorType;

  private let hoverGeneralHighlight: wref<inkWidget>;
  private let indentMarker: wref<inkWidget>;
  private let modifiedFlag: wref<inkWidget>;
  private let labelsContainer: wref<inkWidget>;
  private let sliderContainer: wref<inkWidget>;
  private let sliderNameLabel: wref<inkText>;
  private let sliderValueLabel: wref<inkText>;
  private let buttonLeft: wref<inkWidget>;
  private let buttonRight: wref<inkWidget>;
  private let optionSwitchHint: wref<inkWidget>;

  private let sliderController: wref<inkSliderController>;
  private let hoveredChildren: array<wref<inkWidget>>;

  private let hoverInAnim: ref<inkAnimProxy>;
  private let hoverOutAnim: ref<inkAnimProxy>;

  private let minValue: Int32 = 0;
  private let maxValue: Int32 = 400;
  private let step: Int32 = 1;

  protected cb func OnInitialize() {
    this.InitializeWidgets();
    this.RegisterCallbacks();
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterCallbacks();
  }

  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.hoverGeneralHighlight = root.GetWidgetByPathName(n"bk");
    this.indentMarker = root.GetWidgetByPathName(n"layout/labels/indentLine");
    this.modifiedFlag = root.GetWidgetByPathName(n"modifiedFlag");
    this.labelsContainer = root.GetWidgetByPathName(n"layout/labels");
    this.sliderContainer = root.GetWidgetByPathName(n"layout/container");
    this.sliderNameLabel = root.GetWidgetByPathName(n"layout/labels/label") as inkText;
    this.sliderValueLabel = root.GetWidgetByPathName(n"layout/container/slidingArea/knob/txtValue") as inkText;
    this.buttonLeft = root.GetWidgetByPathName(n"layout/container/btnLeft");
    this.buttonRight = root.GetWidgetByPathName(n"layout/container/btnRight");
    this.optionSwitchHint = root.GetWidgetByPathName(n"layout/container/inputHintsContainer");

    this.sliderController = this.sliderContainer.GetControllerByType(n"inkSliderController") as inkSliderController;

    this.labelsContainer.SetSize(300.0, 80.0);
    this.sliderContainer.SetSize(1200.0, 80.0);
    this.modifiedFlag.SetMargin(1520.0, 0.0, 0.0, 0.0);
    this.sliderValueLabel.SetText("0");

    this.optionSwitchHint.SetVisible(false);
    this.hoverGeneralHighlight.SetVisible(false);
    this.indentMarker.SetVisible(false);
    this.sliderNameLabel.SetText(" ");
  }

  public final func Setup(presetValue: Int32, currentValue: Int32, sliderColor: SliderColorType) -> Void {
    this.presetValue = presetValue;
    this.currentValue = currentValue;
    this.color = sliderColor;
    this.sliderController.Setup(Cast<Float>(this.minValue), Cast<Float>(this.maxValue), Cast<Float>(currentValue), Cast<Float>(this.step));
    this.sliderNameLabel.SetText(this.GetSliderName(sliderColor));
    this.sliderValueLabel.SetText(IntToString(currentValue));
  }

  private final func RegisterCallbacks() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");

    this.buttonLeft.RegisterToCallback(n"OnRelease", this, n"OnLeft");
    this.buttonRight.RegisterToCallback(n"OnRelease", this, n"OnRight");
    this.RegisterToCallback(n"OnRelease", this, n"OnShortcutPress");

    this.sliderController.RegisterToCallback(n"OnSliderValueChanged", this, n"OnSliderValueChanged");
    this.sliderController.RegisterToCallback(n"OnSliderHandleReleased", this, n"OnHandleReleased");
  }

  private final func UnregisterCallbacks() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");

    this.buttonLeft.UnregisterFromCallback(n"OnRelease", this, n"OnLeft");
    this.buttonRight.UnregisterFromCallback(n"OnRelease", this, n"OnRight");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnShortcutPress");

    this.sliderController.UnregisterFromCallback(n"OnSliderValueChanged", this, n"OnSliderValueChanged");
    this.sliderController.UnregisterFromCallback(n"OnSliderHandleReleased", this, n"OnHandleReleased");
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    if ArraySize(this.hoveredChildren) <= 0 {
      if this.hoverInAnim.IsPlaying() {
        this.hoverInAnim.Stop();
      };
      if this.hoverOutAnim.IsPlaying() {
        this.hoverOutAnim.Stop();
      };
      this.hoverInAnim = this.PlayLibraryAnimation(n"hover_over_anim");
      this.sliderNameLabel.SetState(n"Hover");
      this.optionSwitchHint.SetVisible(true);
      this.hoverGeneralHighlight.SetVisible(true);
    };
    ArrayPush(this.hoveredChildren, e.GetCurrentTarget());
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    ArrayRemove(this.hoveredChildren, e.GetCurrentTarget());
    if ArraySize(this.hoveredChildren) <= 0 {
      if this.hoverInAnim.IsPlaying() {
        this.hoverInAnim.Stop();
      };
      if this.hoverOutAnim.IsPlaying() {
        this.hoverOutAnim.Stop();
      };
      this.hoverOutAnim = this.PlayLibraryAnimation(n"hover_out_anim");
      this.sliderNameLabel.SetState(n"Default");
      this.optionSwitchHint.SetVisible(false);
      this.hoverGeneralHighlight.SetVisible(false);
    };
  }

  protected cb func OnElementHovered(e: ref<inkPointerEvent>) -> Bool {
    this.CallCustomCallback(n"OnSettingHovered");
  }

  protected cb func OnLeft(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") {
      this.AcceptValue(false);
      this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_value_down"));
    };
  }

  protected cb func OnRight(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") {
      this.AcceptValue(true);
      this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_value_up"));
    };
  }

  protected cb func OnShortcutRepeat(e: ref<inkPointerEvent>) -> Bool {
    if !e.IsHandled() {
      if e.IsAction(n"option_switch_prev_settings") {
        this.ChangeValue(false);
        e.Handle();
      } else {
        if e.IsAction(n"option_switch_next_settings") {
          this.ChangeValue(true);
          e.Handle();
        };
      };
    };
  }

  protected cb func OnShortcutPress(e: ref<inkPointerEvent>) -> Bool {
    if !e.IsHandled() {
      if e.IsAction(n"option_switch_prev_settings") {
        this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_value_down"));
        this.AcceptValue(false);
        e.Handle();
      } else {
        if e.IsAction(n"option_switch_next_settings") {
          this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_value_up"));
          this.AcceptValue(true);
          e.Handle();
        };
      };
    };
  }

  protected cb func OnSliderValueChanged(sliderController: wref<inkSliderController>, progress: Float, value: Float) -> Bool {
    this.currentValue = Cast<Int32>(ClampF(value, this.sliderController.GetMinValue(), this.sliderController.GetMaxValue()));
    this.Refresh();
    this.QueueEvent(HudPainterSliderUpdated.Create(this.color, this.currentValue));
  }

  protected cb func OnHandleReleased() -> Bool {
    this.Log("OnHandleReleased"); // Sent save color event?
  }

  private func AcceptValue(forward: Bool) -> Void {
    this.ChangeValue(forward);
  }

  private func ChangeValue(forward: Bool) -> Void {
    let step: Int32 = forward ? this.step : -this.step;
    this.currentValue = Clamp(this.currentValue + step, this.minValue, this.maxValue);
    this.Refresh();
  }

  public final func Refresh() -> Void {
    this.sliderValueLabel.SetText(IntToString(this.currentValue));
    this.sliderController.ChangeValue(Cast<Float>(this.currentValue));
    this.modifiedFlag.SetVisible(NotEquals(this.presetValue, this.currentValue));
  }

  private final func GetSliderName(type: SliderColorType) -> String {
    switch type {
      case SliderColorType.Red: return GetLocalizedTextByKey(n"Mod-HudPainter-Red");
      case SliderColorType.Green: return GetLocalizedTextByKey(n"Mod-HudPainter-Green");
      case SliderColorType.Blue: return GetLocalizedTextByKey(n"Mod-HudPainter-Blue");
    };

    return "Unknown";
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Slider", str);
    };
  }
}
