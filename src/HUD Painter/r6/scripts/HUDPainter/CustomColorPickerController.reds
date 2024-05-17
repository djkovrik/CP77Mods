module HudPainter
import Codeware.UI.*

public class CustomColorPickerController extends inkGameController {
  private let m_colorCustom: inkWidgetRef;
  private let m_colorDefault: inkWidgetRef;
  private let m_colorNameLabel: inkWidgetRef;
  private let m_slidersContainer: inkWidgetRef;
  private let m_slidersHint: inkWidgetRef;
  private let m_buttonsSlot: inkWidgetRef;

  private let data: ref<HudPainterColorItem>;
  private let popupToken: ref<inkGameNotificationToken>;

  private let sliderR: wref<CustomColorPickerSliderController>;
  private let sliderG: wref<CustomColorPickerSliderController>;
  private let sliderB: wref<CustomColorPickerSliderController>;
  private let buttonResetColor: wref<SimpleButton>;
  private let buttonFromHex: wref<SimpleButton>;

  private let sliderValueR: Int32;
  private let sliderValueG: Int32;
  private let sliderValueB: Int32;

  protected cb func OnInitialize() {
    this.CreateButtons();
    this.SpawnSliders();

    this.buttonResetColor.RegisterToCallback(n"OnBtnClick", this, n"OnResetClick");
    this.buttonFromHex.RegisterToCallback(n"OnBtnClick", this, n"OnFromHexClick");
  }

  protected cb func OnUninitialize() -> Bool {
    this.buttonResetColor.UnregisterFromCallback(n"OnBtnClick", this, n"OnResetClick");
    this.buttonFromHex.UnregisterFromCallback(n"OnBtnClick", this, n"OnFromHexClick");
  }

  protected cb func OnHudPainterSliderUpdated(evt: ref<HudPainterSliderUpdated>) -> Bool {
    switch evt.color {
      case SliderColorType.Red:
        this.sliderValueR = evt.value;
        break;
      case SliderColorType.Green:
        this.sliderValueG = evt.value;
        break;
       case SliderColorType.Blue:
        this.sliderValueB = evt.value;
        break;
    };

    let newCustomColor: HDRColor = new HDRColor(
      Cast<Float>(this.sliderValueR) / 255.0,
      Cast<Float>(this.sliderValueG) / 255.0,
      Cast<Float>(this.sliderValueB) / 255.0,
      1.0
    );

    this.data.customColor = newCustomColor;
    this.RefreshColorPreviews();
    this.QueueEvent(HudPainterColorChanged.Create(this.data.name, this.data.type, newCustomColor));
  }

  protected cb func OnHudPainterColorSelected(evt: ref<HudPainterColorSelected>) -> Bool {
    this.data = evt.data;
    this.RefreshColorName();
    this.RefreshColorPreviews();
    this.RefreshSliders();
  }

  private final func RefreshColorName() -> Void {
    let colorNameWidget: ref<inkText> = inkWidgetRef.Get(this.m_colorNameLabel) as inkText;
    colorNameWidget.SetText(this.data.name);
    if Equals(this.data.type, HudPainterColorType.Johnny) {
      colorNameWidget.SetFontStyle(n"Semi-Bold");
      colorNameWidget.BindProperty(n"tintColor", n"MainColors.Green");
    } else {
      colorNameWidget.SetFontStyle(n"Regular");
      colorNameWidget.BindProperty(n"tintColor", n"MainColors.Red");
    };
  }

  private final func RefreshColorPreviews() -> Void {
    inkWidgetRef.SetTintColor(this.m_colorDefault, this.data.defaultColor);
    inkWidgetRef.SetTintColor(this.m_colorCustom, this.data.customColor);
  }

  private final func RefreshSliders() -> Void {
    this.sliderR.Setup(
      Cast<Int32>(this.data.presetColor.Red * 255.0), 
      Cast<Int32>(this.data.customColor.Red * 255.0), 
      SliderColorType.Red
    );

    this.sliderG.Setup(
      Cast<Int32>(this.data.presetColor.Green * 255.0), 
      Cast<Int32>(this.data.customColor.Green * 255.0), 
      SliderColorType.Green
    );

    this.sliderB.Setup(
      Cast<Int32>(this.data.presetColor.Blue * 255.0), 
      Cast<Int32>(this.data.customColor.Blue * 255.0), 
      SliderColorType.Blue
    );
  }

  private final func RefreshSliders(valueR: Int32, valueG: Int32, valueB: Int32) -> Void {
    this.sliderR.Setup(
      Cast<Int32>(this.data.presetColor.Red * 255.0), 
      valueR, 
      SliderColorType.Red
    );

    this.sliderG.Setup(
      Cast<Int32>(this.data.presetColor.Green * 255.0), 
      valueG, 
      SliderColorType.Green
    );

    this.sliderB.Setup(
      Cast<Int32>(this.data.presetColor.Blue * 255.0), 
      valueB, 
      SliderColorType.Blue
    );
  }

	protected cb func OnResetClick(widget: wref<inkWidget>) -> Bool {
    this.data.customColor = this.data.presetColor;
    this.RefreshColorPreviews();
    this.RefreshSliders();
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.QueueEvent(HudPainterColorChanged.Create(this.data.name, this.data.type, this.data.customColor));
	}

	protected cb func OnFromHexClick(widget: wref<inkWidget>) -> Bool {
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.popupToken = GenericMessageNotification.ShowInput(this, GetLocalizedTextByKey(n"Mod-HudPainter-From-Hex-Title"), GetLocalizedTextByKey(n"Mod-HudPainter-From-Hex-Hint"), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnHexInputPopupClosed");
	}

  protected cb func OnHexInputPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    let isInputValid: Bool = NotEquals(resultData.input, "") && ColorUtils.IsHexValid(resultData.input);

    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) && isInputValid {
      this.PlaySound(n"Item", n"OnBuy");
      let decodedColor: ref<HudPainterCustomColor> = ColorUtils.DecodeHex(resultData.input);
      this.RefreshSliders(decodedColor.colorR, decodedColor.colorG, decodedColor.colorB);
    };

    this.popupToken = null;
  }

  private final func CreateButtons() -> Void {
    let buttonReset: ref<SimpleButton> = SimpleButton.Create();
    buttonReset.SetName(n"buttonReset");
    buttonReset.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Reset-Color"));
    buttonReset.ToggleAnimations(true);
    buttonReset.ToggleSounds(true);
    buttonReset.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonReset.Reparent(inkWidgetRef.Get(this.m_buttonsSlot) as inkCompoundWidget);
    this.buttonResetColor = buttonReset;

    let buttonFromHex: ref<SimpleButton> = SimpleButton.Create();
    buttonFromHex.SetName(n"buttonFromHex");
    buttonFromHex.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-From-Hex"));
    buttonFromHex.ToggleAnimations(true);
    buttonFromHex.ToggleSounds(true);
    buttonFromHex.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonFromHex.Reparent(inkWidgetRef.Get(this.m_buttonsSlot) as inkCompoundWidget);
    this.buttonFromHex = buttonFromHex;
  }

  private final func SpawnSliders() -> Void {
    this.Log(s"SpawnSliders: \(inkWidgetRef.IsValid(this.m_slidersContainer))");

    this.sliderR = this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_slidersContainer), 
      r"base\\gameplay\\gui\\fullscreen\\settings\\settings_main.inkwidget", 
      n"settingsSelectorInt:HudPainter.CustomColorPickerSliderController"
    ).GetController() as CustomColorPickerSliderController;
    
    this.sliderG = this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_slidersContainer), 
      r"base\\gameplay\\gui\\fullscreen\\settings\\settings_main.inkwidget", 
      n"settingsSelectorInt:HudPainter.CustomColorPickerSliderController"
    ).GetController() as CustomColorPickerSliderController;

    this.sliderB = this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_slidersContainer), 
      r"base\\gameplay\\gui\\fullscreen\\settings\\settings_main.inkwidget", 
      n"settingsSelectorInt:HudPainter.CustomColorPickerSliderController"
    ).GetController() as CustomColorPickerSliderController;
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"ColorPicker", str);
    };
  }
}
