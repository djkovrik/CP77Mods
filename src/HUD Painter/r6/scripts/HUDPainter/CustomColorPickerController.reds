module HudPainter

public class CustomColorPickerController extends inkGameController {
  private let m_colorCustom: inkWidgetRef;
  private let m_colorDefault: inkWidgetRef;
  private let m_colorNameLabel: inkWidgetRef;
  private let m_slidersContainer: inkWidgetRef;
  private let m_slidersHint: inkWidgetRef;

  private let player: wref<GameObject>;
  private let data: ref<HudPainterColorItem>;

  private let sliderR: wref<CustomColorPickerSliderController>;
  private let sliderG: wref<CustomColorPickerSliderController>;
  private let sliderB: wref<CustomColorPickerSliderController>;

  private let sliderValueR: Int32;
  private let sliderValueG: Int32;
  private let sliderValueB: Int32;

  protected cb func OnInitialize() {
    this.player = this.GetPlayerControlledObject();
    this.SpawnSliders();
  }

  protected cb func OnUninitialize() -> Bool {
    this.Log("OnUninitialize");
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
      255.0
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
  }

  private final func RefreshColorPreviews() -> Void {
    inkWidgetRef.SetTintColor(this.m_colorDefault, this.data.defaultColor);
    inkWidgetRef.SetTintColor(this.m_colorCustom, this.data.customColor);
  }

  private final func RefreshSliders() -> Void {
    this.sliderR.Setup(Cast<Int32>(this.data.customColor.Red * 255.0), SliderColorType.Red);
    this.sliderG.Setup(Cast<Int32>(this.data.customColor.Green * 255.0), SliderColorType.Green);
    this.sliderB.Setup(Cast<Int32>(this.data.customColor.Blue * 255.0), SliderColorType.Blue);
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
