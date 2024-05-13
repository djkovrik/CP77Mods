module HudPainter

class HudPainterController extends gameuiSettingsMenuGameController {
  private let m_buttonHintsSlot: inkWidgetRef;
  private let m_colorPickerSlot: inkWidgetRef;
  private let m_colorsListContainer: inkWidgetRef;

  private let m_storage: wref<HudPainterStorage>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_activePresetItems: array<ref<HudPainterColorItem>>;

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
    this.m_activePresetItems = this.m_storage.GetActivePresetData();
    this.Log(s"Active preset loaded: \(ArraySize(this.m_activePresetItems)) colors");

    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_colorsListContainer) as inkCompoundWidget;
    let component: ref<HudPainterColorItemComponent>;
    for colorItem in this.m_activePresetItems {
      component = new HudPainterColorItemComponent();
      component.Reparent(container);
      component.SetData(colorItem);
    };
  }

  private final func SpawnColorPicker() -> Void {
    this.SpawnFromLocal(inkWidgetRef.Get(this.m_colorPickerSlot), n"ColorPicker");
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"Screen", str);
    };
  }
}
