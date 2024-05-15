module HudPainter
import Codeware.UI.*

public class CustomColorPickerController extends inkGameController {
  private let m_colorCustom: inkWidgetRef;
  private let m_colorDefault: inkWidgetRef;
  private let m_colorNameLabel: inkWidgetRef;
  private let m_slidersContainer: inkWidgetRef;
  private let m_slidersHint: inkWidgetRef;
  private let m_resetButtonSlot: inkWidgetRef;

  private let player: wref<GameObject>;
  private let data: ref<HudPainterColorItem>;

  private let sliderR: wref<CustomColorPickerSliderController>;
  private let sliderG: wref<CustomColorPickerSliderController>;
  private let sliderB: wref<CustomColorPickerSliderController>;
  private let buttonResetColor: wref<SimpleButton>;

  private let sliderValueR: Int32;
  private let sliderValueG: Int32;
  private let sliderValueB: Int32;

  protected cb func OnInitialize() {
    this.player = this.GetPlayerControlledObject();
    this.CreateButton();
    this.SpawnSliders();

    this.buttonResetColor.RegisterToCallback(n"OnBtnClick", this, n"OnResetClick");
  }

  protected cb func OnUninitialize() -> Bool {
    this.buttonResetColor.UnregisterFromCallback(n"OnBtnClick", this, n"OnResetClick");
  }

  protected cb func OnHudPainterSoundEmitted(evt: ref<HudPainterSoundEmitted>) -> Bool {
    GameObject.PlaySoundEvent(this.player, evt.name);
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
    this.buttonResetColor.SetDisabled(false);
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

	protected cb func OnResetClick(widget: wref<inkWidget>) -> Bool {
    this.data.customColor = this.data.presetColor;
    this.RefreshColorPreviews();
    this.RefreshSliders();
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
    this.QueueEvent(HudPainterColorChanged.Create(this.data.name, this.data.type, this.data.customColor));
	}

  private final func CreateButton() -> Void {
    let button: ref<SimpleButton> = SimpleButton.Create();
    button.SetName(n"buttonReset");
    button.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Reset-Color"));
    button.ToggleAnimations(true);
    button.ToggleSounds(true);
    button.SetDisabled(true);
    button.Reparent(inkWidgetRef.Get(this.m_resetButtonSlot) as inkCompoundWidget);
    this.buttonResetColor = button;
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
