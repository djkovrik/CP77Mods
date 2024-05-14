module HudPainter
import Codeware.UI.*

class HudPainterController extends gameuiSettingsMenuGameController {
  private let m_activePresetName: inkWidgetRef;
  private let m_buttonHintsSlot: inkWidgetRef;
  private let m_colorPickerSlot: inkWidgetRef;
  private let m_presetManagerButtons: inkWidgetRef;
  private let m_colorsListContainer: inkWidgetRef;
  private let m_presetsListContainer: inkWidgetRef;

  private let m_storage: wref<HudPainterStorage>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_buttonHintsController: wref<ButtonHints>;
  private let m_buttonActivate: wref<SimpleButton>;
  private let m_buttonSave: wref<SimpleButton>;

  private let m_colorItems: array<ref<HudPainterColorItem>>;
  private let m_presetItems: array<ref<HudPainterPresetItem>>;

  protected cb func OnInitialize() {
    this.m_storage = HudPainterStorage.Get();
    
    this.m_buttonHintsController = this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_buttonHintsSlot), 
      r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", 
      n"Root"
    ).GetController() as ButtonHints;

    this.AddInitialButtonHints();
    this.SpawnColorsListContent();
    this.SpawnColorPicker();
    this.CreatePresetManagerButtons();
    this.RefereshActivePresetTitle();
    this.SpawnPresetsListContent();
  }

  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    super.OnSetMenuEventDispatcher(menuEventDispatcher);
    this.m_menuEventDispatcher = menuEventDispatcher;
    this.m_menuEventDispatcher.RegisterToEvent(n"OnBack", this, n"OnBack");
  }

  protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    this.m_menuEventDispatcher.SpawnEvent(n"OnCloseHudPainterScreen");
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
  }

  private final func AddInitialButtonHints() -> Void {
    this.m_buttonHintsController.ClearButtonHints();
    this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
  }

  private final func SpawnColorsListContent() -> Void {
    this.m_colorItems = this.m_storage.GetActivePresetData();
    this.Log(s"Active preset loaded: \(ArraySize(this.m_colorItems)) colors");

    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_colorsListContainer) as inkCompoundWidget;
    let component: ref<HudPainterColorItemComponent>;
    for colorItem in this.m_colorItems {
      component = new HudPainterColorItemComponent();
      component.Reparent(container);
      component.SetData(colorItem);
    };
  }

  private final func SpawnPresetsListContent() -> Void {
    this.m_presetItems = this.m_storage.GetAvailablePresetsList();
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_presetsListContainer) as inkCompoundWidget;
    this.Log(s"Presets list loaded: \(ArraySize(this.m_presetItems)) items, container available: \(IsDefined(container))");
    let component: ref<HudPainterPresetItemComponent>;
    for presetItem in this.m_presetItems {
      component = new HudPainterPresetItemComponent();
      component.Reparent(container);
      component.SetData(presetItem);
    };
  }

  private final func SpawnColorPicker() -> Void {
    this.SpawnFromLocal(inkWidgetRef.Get(this.m_colorPickerSlot), n"ColorPicker");
  }

  private final func CreatePresetManagerButtons() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_presetManagerButtons) as inkCompoundWidget;

    let buttonActivate: ref<SimpleButton> = SimpleButton.Create();
    buttonActivate.SetName(n"buttonActivate");
    buttonActivate.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Activate-Preset"));
    buttonActivate.ToggleAnimations(true);
    buttonActivate.ToggleSounds(true);
    buttonActivate.GetRootWidget();
    buttonActivate.Reparent(container);
    this.m_buttonActivate = buttonActivate;

    let buttonSave: ref<SimpleButton> = SimpleButton.Create();
    buttonSave.SetName(n"buttonSave");
    buttonSave.SetText(GetLocalizedTextByKey(n"Mod-HudPainter-Save-Preset"));
    buttonSave.ToggleAnimations(true);
    buttonSave.ToggleSounds(true);
    buttonSave.GetRootWidget();
    buttonSave.Reparent(container);
    this.m_buttonSave = buttonSave;
  }

  private final func RefereshActivePresetTitle() {
    let activePresetName: ref<inkText> = inkWidgetRef.Get(this.m_activePresetName) as inkText;
    let presetPrefix: String = GetLocalizedTextByKey(n"Mod-HudPainter-Presets-Active");
    let presetName: String = this.m_storage.GetActivePresetName();
    activePresetName.SetText(s"\(presetPrefix): \(presetName)");
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Screen", str);
    };
  }
}
