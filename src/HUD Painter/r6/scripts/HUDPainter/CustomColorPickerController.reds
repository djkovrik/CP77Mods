module HudPainter
import Codeware.UI.*

public class CustomColorPickerController extends inkGameController {
  private let m_colorCustom: inkWidgetRef;
  private let m_colorDefault: inkWidgetRef;
  private let m_colorNameLabel: inkWidgetRef;
  private let m_slidersContainer: inkWidgetRef;
  private let m_slidersHint: inkWidgetRef;
  private let m_buttonsSlot: inkWidgetRef;
  private let m_copyPasteButtonsSlot: inkWidgetRef;
  private let m_copiedColorLabel: inkTextRef;

  private let data: ref<HudPainterColorItem>;
  private let popupToken: ref<inkGameNotificationToken>;

  private let sliderR: wref<CustomColorPickerSliderController>;
  private let sliderG: wref<CustomColorPickerSliderController>;
  private let sliderB: wref<CustomColorPickerSliderController>;

  private let buttonResetColor: wref<SimpleButton>;
  private let buttonFromHex: wref<SimpleButton>;

  private let buttonCopyColor: wref<SimpleButton>;
  private let buttonCancelCopy: wref<SimpleButton>;
  private let buttonPasteColor: wref<SimpleButton>;

  private let sliderValueR: Int32;
  private let sliderValueG: Int32;
  private let sliderValueB: Int32;

  private let copiedColor: ref<HudPainterColorItem>;

  protected cb func OnInitialize() {
    this.CreateButtons();
    this.UpdateButtonsState();
    this.SpawnSliders();

    this.buttonResetColor.RegisterToCallback(n"OnBtnClick", this, n"OnResetClick");
    this.buttonFromHex.RegisterToCallback(n"OnBtnClick", this, n"OnFromHexClick");
    this.buttonCopyColor.RegisterToCallback(n"OnBtnClick", this, n"OnColorCopyClick");
    this.buttonCancelCopy.RegisterToCallback(n"OnBtnClick", this, n"OnCancelCopyClick");
    this.buttonPasteColor.RegisterToCallback(n"OnBtnClick", this, n"OnColorPasteClick");
  }

  protected cb func OnUninitialize() -> Bool {
    this.buttonResetColor.UnregisterFromCallback(n"OnBtnClick", this, n"OnResetClick");
    this.buttonFromHex.UnregisterFromCallback(n"OnBtnClick", this, n"OnFromHexClick");
    this.buttonCopyColor.UnregisterFromCallback(n"OnBtnClick", this, n"OnColorCopyClick");
    this.buttonCancelCopy.UnregisterFromCallback(n"OnBtnClick", this, n"OnCancelCopyClick");
    this.buttonPasteColor.UnregisterFromCallback(n"OnBtnClick", this, n"OnColorPasteClick");
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

  protected cb func OnHudPainterSliderReleased(evt: ref<HudPainterSliderReleased>) -> Bool {
    this.QueueEvent(HudPainterColorPreviewAvailable.Create(this.data));
  }

  protected cb func OnHudPainterColorSelected(evt: ref<HudPainterColorSelected>) -> Bool {
    this.data = evt.data;
    this.RefreshColorName();
    this.RefreshColorPreviews();
    this.RefreshSliders();
    this.QueueEvent(HudPainterColorPreviewAvailable.Create(this.data));
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
    this.QueueEvent(HudPainterColorPreviewAvailable.Create(this.data));
	}

	protected cb func OnFromHexClick(widget: wref<inkWidget>) -> Bool {
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.popupToken = GenericMessageNotification.ShowInput(this, GetLocalizedTextByKey(n"Mod-HudPainter-From-Hex-Title"), GetLocalizedTextByKey(n"Mod-HudPainter-From-Hex-Hint"), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnHexInputPopupClosed");
	}

  protected cb func OnColorCopyClick(widget: wref<inkWidget>) -> Bool {
    this.copiedColor = this.data;
    this.UpdateCopiedColorLabelState();
    this.UpdateButtonsState();
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
  }

  protected cb func OnCancelCopyClick(widget: wref<inkWidget>) -> Bool {
    this.copiedColor = null;
    this.UpdateCopiedColorLabelState();
    this.UpdateButtonsState();
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
  }

  protected cb func OnColorPasteClick(widget: wref<inkWidget>) -> Bool {
    if IsDefined(this.copiedColor) {
      this.RefreshSliders(
        Cast<Int32>(this.copiedColor.customColor.Red * 255.0),
        Cast<Int32>(this.copiedColor.customColor.Green * 255.0),
        Cast<Int32>(this.copiedColor.customColor.Blue * 255.0)
      );
    };
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.QueueEvent(HudPainterColorPreviewAvailable.Create(this.data));
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
    let resetHexSlot: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_buttonsSlot) as inkCompoundWidget;
    let copyPasteSlot: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_copyPasteButtonsSlot) as inkCompoundWidget;

    let buttonReset: ref<SimpleButton> = SimpleButton.Create();
    buttonReset.SetName(n"buttonReset");
    buttonReset.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Reset-Color"));
    buttonReset.ToggleAnimations(true);
    buttonReset.ToggleSounds(true);
    buttonReset.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonReset.Reparent(resetHexSlot);
    this.buttonResetColor = buttonReset;

    let buttonFromHex: ref<SimpleButton> = SimpleButton.Create();
    buttonFromHex.SetName(n"buttonFromHex");
    buttonFromHex.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-From-Hex"));
    buttonFromHex.ToggleAnimations(true);
    buttonFromHex.ToggleSounds(true);
    buttonFromHex.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonFromHex.Reparent(resetHexSlot);
    this.buttonFromHex = buttonFromHex;

    let buttonCopyColor: ref<SimpleButton> = SimpleButton.Create();
    buttonCopyColor.SetName(n"buttonCopyColor");
    buttonCopyColor.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Copy-Color"));
    buttonCopyColor.ToggleAnimations(true);
    buttonCopyColor.ToggleSounds(true);
    buttonCopyColor.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonCopyColor.Reparent(copyPasteSlot);
    this.buttonCopyColor = buttonCopyColor;

    let buttonCancelCopy: ref<SimpleButton> = SimpleButton.Create();
    buttonCancelCopy.SetName(n"buttonCancelCopy");
    buttonCancelCopy.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Cancel-Copy"));
    buttonCancelCopy.ToggleAnimations(true);
    buttonCancelCopy.ToggleSounds(true);
    buttonCancelCopy.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonCancelCopy.Reparent(copyPasteSlot);
    this.buttonCancelCopy = buttonCancelCopy;

    let buttonPasteColor: ref<SimpleButton> = SimpleButton.Create();
    buttonPasteColor.SetName(n"buttonPasteColor");
    buttonPasteColor.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Paste-Color"));
    buttonPasteColor.ToggleAnimations(true);
    buttonPasteColor.ToggleSounds(true);
    buttonPasteColor.GetRootWidget().SetSizeRule(inkESizeRule.Stretch);
    buttonPasteColor.Reparent(copyPasteSlot);
    this.buttonPasteColor = buttonPasteColor;
  }

  private final func UpdateCopiedColorLabelState() -> Void {
    let copiedPrefix: String;
    let copiedName: String;
    let text: String;

    if IsDefined(this.copiedColor) {
      copiedPrefix = GetLocalizedTextByKey(n"Mod-HudPainter-Copied-Color");
      copiedName = this.copiedColor.name;
      text = s"\(copiedPrefix): \(copiedName)";
    } else {
      text = "";
    };

    inkTextRef.SetText(this.m_copiedColorLabel, text);
  }

  private final func UpdateButtonsState() -> Void {
    let copied: Bool = IsDefined(this.copiedColor);
    this.buttonCopyColor.GetRootWidget().SetVisible(!copied);
    this.buttonCancelCopy.GetRootWidget().SetVisible(copied);
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
