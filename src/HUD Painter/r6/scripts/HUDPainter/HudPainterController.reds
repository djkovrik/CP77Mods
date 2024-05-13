module HudPainter

class HudPainterController extends gameuiSettingsMenuGameController {
  private let m_buttonHintsSlot: inkWidgetRef;
  private let m_colorPickerSlot: inkWidgetRef;
  private let m_colorsListSlot: inkWidgetRef;

  private let m_storage: wref<HudPainterStorage>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_buttonHintsController: wref<ButtonHints>;
  private let m_colorsListContainer: wref<inkVerticalPanel>;

  private let m_activePresetItems: array<ref<HudPainterColorItem>>;

  protected cb func OnInitialize() {
    this.m_storage = HudPainterStorage.Get();
    
    this.m_buttonHintsController = this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_buttonHintsSlot), 
      r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", 
      n"Root"
    ).GetController() as ButtonHints;

    this.AddInitialButtonHints();
    this.SpawnColorsListContainer();
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

  private final func SpawnColorsListContainer() -> Void {
    let slot: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_colorsListSlot) as inkCompoundWidget;

    let scrollWrapper: ref<inkCanvas> = new inkCanvas();
    scrollWrapper.SetName(n"scrollWrapper");
    scrollWrapper.SetHAlign(inkEHorizontalAlign.Fill);
    scrollWrapper.SetVAlign(inkEVerticalAlign.Top);
    scrollWrapper.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    scrollWrapper.SetSize(940.0, 1100.0);
    scrollWrapper.SetInteractive(true);

    let scrollArea: ref<inkScrollArea> = new inkScrollArea();
    scrollArea.SetName(n"scrollArea");
    scrollArea.SetAnchor(inkEAnchor.Fill);
    scrollArea.SetMargin(new inkMargin(48.0, 0.0, 0.0, 0.0));
    scrollArea.fitToContentDirection = inkFitToContentDirection.Vertical;
    scrollArea.useInternalMask = true;
    scrollArea.Reparent(scrollWrapper, -1);

    let sliderArea: ref<inkCanvas> = new inkCanvas();
    sliderArea.SetName(n"sliderArea");
    sliderArea.SetAnchor(inkEAnchor.LeftFillVerticaly);
    sliderArea.SetSize(new Vector2(15.0, 0.0));
    sliderArea.SetMargin(new inkMargin(0.0, 8.0, 0.0, 8.0));
    sliderArea.SetInteractive(true);
    sliderArea.Reparent(scrollWrapper, -1);

    let sliderFill: ref<inkRectangle> = new inkRectangle();
    sliderFill.SetName(n"sliderFill");
    sliderFill.SetAnchor(inkEAnchor.Fill);
    sliderFill.SetOpacity(0.05);
    sliderFill.Reparent(sliderArea, -1);

    let sliderHandle: ref<inkRectangle> = new inkRectangle();
    sliderHandle.SetName(n"sliderHandle");
    sliderHandle.SetAnchor(inkEAnchor.TopFillHorizontaly);
    sliderHandle.SetSize(new Vector2(15.0, 40.0));
    sliderHandle.SetInteractive(true);
    sliderHandle.Reparent(sliderArea, -1);

    let sliderController: ref<inkSliderController> = new inkSliderController();
    sliderController.slidingAreaRef = inkWidgetRef.Create(sliderArea);
    sliderController.handleRef = inkWidgetRef.Create(sliderHandle);
    sliderController.direction = inkESliderDirection.Vertical;
    sliderController.autoSizeHandle = true;
    sliderController.percentHandleSize = 0.4;
    sliderController.minHandleSize = 40.0;
    sliderController.Setup(0.0, 1.0, 0.0, 0.0);

    let scrollController: ref<inkScrollController> = new inkScrollController();
    scrollController.ScrollArea = inkScrollAreaRef.Create(scrollArea);
    scrollController.VerticalScrollBarRef = inkWidgetRef.Create(sliderArea);
    scrollController.autoHideVertical = true;

    let container: ref<inkVerticalPanel> = new inkVerticalPanel();
    container.SetName(n"colorItems");

    scrollWrapper.Reparent(slot);
    container.Reparent(scrollArea);

    sliderFill.BindProperty(n"tintColor", n"MainColors.Red");
    sliderHandle.BindProperty(n"tintColor", n"MainColors.Red");

    sliderArea.AttachController(sliderController);
    scrollWrapper.AttachController(scrollController);
    
    this.m_colorsListContainer = container;
  }

  private final func SpawnColorsListContent() -> Void {
    this.m_activePresetItems = this.m_storage.GetActivePresetData();
    this.Log(s"Active preset loaded: \(ArraySize(this.m_activePresetItems)) colors, container available: \(IsDefined(this.m_colorsListContainer))");

    let component: ref<HudPainterColorItemComponent>;
    for colorItem in this.m_activePresetItems {
      component = new HudPainterColorItemComponent();
      component.Reparent(this.m_colorsListContainer);
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
