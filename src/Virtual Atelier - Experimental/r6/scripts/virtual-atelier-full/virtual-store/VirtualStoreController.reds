module VirtualAtelier.UI
import VirtualAtelier.Config.VirtualAtelierConfig
import VirtualAtelier.Core.AtelierActions
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.AtelierDebug
import VirtualAtelier.Helpers.*
import VirtualAtelier.Systems.*
import Codeware.UI.*

public class VirtualStoreController extends gameuiMenuGameController {
  private let player: wref<PlayerPuppet>;
  private let previewManager: wref<VirtualAtelierPreviewManager>;
  private let cartManager: wref<VirtualAtelierCartManager>;
  private let storesManager: wref<VirtualAtelierStoresManager>;
  private let questsSystem: wref<QuestsSystem>;
  private let uiSystem: wref<UISystem>;
  private let uiScriptableSystem: wref<UIScriptableSystem>;
  private let vendorDataManager: ref<VendorDataManager>;
  private let inventoryManager: ref<InventoryDataManagerV2>;
  private let config: ref<VirtualAtelierConfig>;

  // inkwidget refs
  private let buttonHintsController: wref<ButtonHints>;
  private let tooltipsManager: wref<gameuiTooltipsManager>;
  private let scrollController: wref<inkScrollController>;
  private let filtersContainer: wref<inkWidget>;
  private let filterManager: ref<ItemCategoryFliterManager>;
  private let vendorName: wref<inkText>;
  private let vendorSortingButton: ref<inkWidget>;
  private let sortingDropdown: ref<inkWidget>;
  private let searchInput: wref<HubTextInput>;
  private let playerMoney: wref<inkText>;
  private let cartMoney: wref<inkText>;

  // Cart
  private let cartIcon: wref<VirtualCartImageButton>;
  private let cartButtonClear: wref<VirtualCartTextButton>;
  private let cartButtonAddAll: wref<VirtualCartTextButton>;

  // Store data
  private let virtualStock: array<ref<VirtualStockItem>>;
  private let virtualStore: ref<VirtualShop>;
  private let storeListController: wref<inkVirtualGridController>;
  private let storeDataView: ref<VirtualStoreDataView>;
  private let storeDataSource: ref<ScriptableDataSource>;
  private let storeItemsClassifier: ref<VirtualStoreTemplateClassifier>;

  private let popupToken: ref<inkGameNotificationToken>;
  private let currentTutorialsFact: Int32;
  private let lastVendorFilter: ItemFilterCategory;
  private let lastItemHoverOverEvent: ref<ItemDisplayHoverOverEvent>;
  private let totalItemsPrice: Int32;
  private let allItemsAdded: Bool;

  protected cb func OnInitialize() -> Bool {
    this.InitializeCoreSystems();
    this.InitializeWidgets();
    this.InitializeDataSource();
    this.InitializeListeners();
    this.SetupDropdown();

    this.PopulateVirtualShop();
    this.RefreshCartControls();
    this.RefreshMoneyLabels();

    this.SetTimeDilatation(true);
    this.PlaySound(n"GameMenu", n"OnOpen");
  }

  protected cb func OnUninitialize() -> Bool {
    this.cartManager.ClearCart();
    this.previewManager.SetPreviewState(false);
    this.questsSystem.SetFact(n"disable_tutorials", this.currentTutorialsFact);
    this.storeDataView.SetSource(null);
    this.storeListController.SetSource(null);
    this.storeListController.SetClassifier(null);
    this.storeDataView = null;
    this.storeDataSource = null;
    this.storeItemsClassifier = null;

    this.SetTimeDilatation(false);
    this.PlaySound(n"GameMenu", n"OnClose");
  }

  protected cb func OnVendorSortingButtonClicked(evt: ref<inkPointerEvent>) -> Bool {
    let controller: ref<DropdownListController>;
    if evt.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      this.sortingDropdown.SetTranslation(new Vector2(2650.00, 270.00));
      controller = this.sortingDropdown.GetController() as DropdownListController;
      controller.SetTriggerButton(this.vendorSortingButton.GetController() as DropdownButtonController);
      controller.Toggle();
      this.OnInventoryItemHoverOut(null);
    };
  }

  protected cb func OnDropdownItemClickedEvent(evt: ref<DropdownItemClickedEvent>) -> Bool {
    let setVendorSortingRequest: ref<UIScriptableSystemSetVendorPanelVendorSorting>;
    let identifier: ItemSortMode = FromVariant<ItemSortMode>(evt.identifier);
    let data: ref<DropdownItemData> = SortingDropdownData.GetDropdownOption((this.sortingDropdown.GetController() as DropdownListController).GetData(), identifier);
    if IsDefined(data) {
      if evt.triggerButton.GetRootWidget() == this.vendorSortingButton {
        evt.triggerButton.SetData(data);
        this.storeDataView.SetSortMode(identifier);
        setVendorSortingRequest = new UIScriptableSystemSetVendorPanelVendorSorting();
        setVendorSortingRequest.sortMode = EnumInt(identifier);
        this.uiScriptableSystem.QueueRequest(setVendorSortingRequest);
      };
    };
  }

  protected cb func OnSearchInput(widget: wref<inkWidget>) {
    this.storeDataView.SetSearchQuery(this.searchInput.GetText());
    this.storeDataView.Filter();
    this.storeDataView.EnableSorting();
    this.storeDataView.SetFilterType(this.lastVendorFilter);
    this.storeDataView.SetSortMode(this.storeDataView.GetSortMode());
    this.storeDataView.DisableSorting();
  }

  protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
    if IsDefined(this.searchInput) {
      this.searchInput.SetText("");
    };
    this.storeDataView.SetSearchQuery("");

    let category: ItemFilterCategory = this.filterManager.GetAt(selectedIndex);
    this.storeDataView.SetFilterType(category);
    this.lastVendorFilter = category;
    this.storeDataView.SetSortMode(this.storeDataView.GetSortMode());
    this.PlayLibraryAnimation(n"vendor_grid_show");
    this.PlaySound(n"Button", n"OnPress");
    this.scrollController.SetScrollPosition(0.0);
  }

  protected cb func OnFilterRadioItemHoverOver(evt: ref<FilterRadioItemHoverOver>) -> Bool {
    let tooltipData: ref<MessageTooltipData> = new MessageTooltipData();
    tooltipData.Title = NameToString(ItemFilterCategories.GetLabelKey(evt.identifier));
    this.tooltipsManager.ShowTooltipAtWidget(n"descriptionTooltip", evt.target, tooltipData, gameuiETooltipPlacement.RightTop, true);
  }

  protected cb func OnFilterRadioItemHoverOut(evt: ref<FilterRadioItemHoverOut>) -> Bool {
    this.tooltipsManager.HideTooltips();
  }

  protected cb func OnHandleGlobalInput(evt: ref<inkPointerEvent>) -> Bool {
    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);
    switch true {
      case evt.IsAction(atelierActions.resetGarment):
        this.previewManager.ResetGarment();
        this.RefreshEquippedState();
        break;
      case evt.IsAction(atelierActions.removeAllGarment):
        this.previewManager.RemoveAllGarment();
        this.RefreshEquippedState();
        break;
      case evt.IsAction(atelierActions.removePreviewGarment):
        this.previewManager.RemovePreviewGarment();
        this.RefreshEquippedState();
        break;
      case evt.IsAction(n"back"):
      case evt.IsAction(n"cancel"):
        this.previewManager.RemovePreviewGarment();
        break;
      case evt.IsAction(n"mouse_left"):
        if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
          this.RequestSetFocus(null);
        };
        break;
      case evt.IsAction(atelierActions.addToVirtualCart):
        this.HandleCartAction();
        break;
    };
  }

  protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);
    let itemID: ItemID = InventoryItemData.GetID(evt.itemData);
    let isEquipped: Bool = this.previewManager.GetIsEquipped(itemID);
    let isAddedToCart: Bool = this.cartManager.IsAddedToCart(itemID);
    let isWeapon: Bool = RPGManager.IsItemWeapon(itemID);
    let isClothing: Bool = RPGManager.IsItemClothing(itemID);
    let hintLabel: String;

    if (isWeapon || isClothing) {
      if isEquipped {
        hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Unequip");
      } else {
        hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Equip");
      };

      this.buttonHintsController.RemoveButtonHint(n"select");
      this.buttonHintsController.AddButtonHint(n"select", hintLabel);
    } else {
      this.buttonHintsController.RemoveButtonHint(n"select");
    };

    if isAddedToCart {
      hintLabel = GetLocalizedTextByKey(n"VA-Cart-Remove");
    } else {
      hintLabel = GetLocalizedTextByKey(n"VA-Cart-Add");
    };

    this.buttonHintsController.RemoveButtonHint(atelierActions.addToVirtualCart);
    this.buttonHintsController.AddButtonHint(atelierActions.addToVirtualCart, hintLabel);

    this.lastItemHoverOverEvent = evt;
    this.RequestSetFocus(null);
    
    let noCompare: InventoryItemData;
    this.ShowTooltipsForItemController(evt.widget, noCompare, evt.itemData, evt.display.DEBUG_GetIconErrorInfo(), false);
  }

  protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);
    this.tooltipsManager.HideTooltips();
    this.buttonHintsController.RemoveButtonHint(atelierActions.addToVirtualCart);
    this.buttonHintsController.RemoveButtonHint(n"select");
    this.lastItemHoverOverEvent = null;
  }

  protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
    let itemID: ItemID;
    let isEquipped: Bool;
    let isWeapon: Bool;
    let isClothing: Bool;
    let hintLabel: String;

    if evt.actionName.IsAction(n"click") {
      itemID = InventoryItemData.GetID(evt.itemData);
      isEquipped = this.previewManager.GetIsEquipped(itemID);
      isWeapon = RPGManager.IsItemWeapon(itemID);
      isClothing = RPGManager.IsItemClothing(itemID);

      if isClothing || isWeapon {
        this.previewManager.TogglePreviewItem(itemID);
        this.RefreshEquippedState();
        if isEquipped {
          hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Equip");
        } else {
          hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Unequip");
        };

        this.buttonHintsController.RemoveButtonHint(n"select");
        this.buttonHintsController.AddButtonHint(n"select", hintLabel);
      } else {
        this.buttonHintsController.RemoveButtonHint(n"select");
      };
    };
  }

  protected cb func OnVirtualAtelierControlClickEvent(evt: ref<VirtualAtelierControlClickEvent>) -> Bool {
    let name: CName = evt.name;
    switch name {
      case n"buy":
        break;
      case n"addAll":
        this.ShowAddAllConfirmationPopup();
        break;
      case n"clear":
        this.ShowRemoveAllConfirmationPopup();
        break;
      default:
        // do nothing
        break;
    }
  }

  private final func InitializeCoreSystems() -> Void {
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.previewManager = VirtualAtelierPreviewManager.GetInstance(this.player.GetGame());
    this.previewManager.SetPreviewState(true);
    this.cartManager = VirtualAtelierCartManager.GetInstance(this.player.GetGame());
    this.SpawnPreviewPuppet();
    this.storesManager = VirtualAtelierStoresManager.GetInstance(this.player.GetGame());
    this.virtualStore = this.storesManager.GetCurrentStore();
    this.questsSystem = GameInstance.GetQuestsSystem(this.player.GetGame());
    this.uiSystem = GameInstance.GetUISystem(this.player.GetGame());
    this.uiScriptableSystem = UIScriptableSystem.GetInstance(this.player.GetGame());
    this.vendorDataManager = new VendorDataManager();
    this.vendorDataManager.Initialize(this.player, this.player.GetEntityID());
    this.inventoryManager = new InventoryDataManagerV2();
    this.inventoryManager.Initialize(this.player);
    this.config = VirtualAtelierConfig.Get();

    this.currentTutorialsFact = this.questsSystem.GetFact(n"disable_tutorials");
    this.questsSystem.SetFact(n"disable_tutorials", 1);

    this.lastVendorFilter = ItemFilterCategory.AllItems;
  }

  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let wrapper: wref<inkCompoundWidget> = root.GetWidget(n"wrapper/wrapper") as inkCompoundWidget;
    let scrollable: ref<inkWidget> = root.GetWidget(n"wrapper/wrapper/vendorPanel/inventoryContainer");
    let grid: ref<inkWidget> = root.GetWidget(n"wrapper/wrapper/vendorPanel/inventoryContainer/stash_scroll_area_cache/scrollArea/vendor_virtualgrid");
    let vendorHeader: ref<inkCompoundWidget> = root.GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/vendoHeaderWrapper") as inkCompoundWidget;
    this.storeListController = grid.GetController() as inkVirtualGridController;
    this.buttonHintsController = this.SpawnFromExternal(root.GetWidget(n"button_hints"), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
    this.tooltipsManager = this.GetControllerByType(n"gameuiTooltipsManager") as gameuiTooltipsManager;
    this.tooltipsManager.Setup(ETooltipsStyle.Menus);
    this.scrollController = scrollable.GetController() as inkScrollController;
    this.filtersContainer = root.GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/filtersContainer");
    this.filterManager = ItemCategoryFliterManager.Make();
    this.vendorName = vendorHeader.GetWidget(n"vendorNameWrapper/value") as inkText;
    this.vendorSortingButton = root.GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/dropdownButton5");
    this.sortingDropdown = root.GetWidget(n"dropdownContainer");

    this.vendorName.SetText(this.GetVirtualStoreName());
    AtelierButtonHintsHelper.ToggleAtelierControlHints(this.buttonHintsController, this.player, true);

    let cartControls: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    cartControls.SetName(n"cartControls");
    cartControls.SetMargin(new inkMargin(0.0, 190.0, 0.0, 0.0));
    cartControls.SetAnchor(inkEAnchor.TopLeft);
    cartControls.SetHAlign(inkEHorizontalAlign.Left);
    cartControls.SetChildOrder(inkEChildOrder.Forward);
    cartControls.SetInteractive(true);
    cartControls.Reparent(vendorHeader);

    let buttonCart: ref<VirtualCartImageButton> = VirtualCartImageButton.Create();
    buttonCart.SetName(n"buy");
    buttonCart.Reparent(cartControls);

    let buttonClear: ref<VirtualCartTextButton> = VirtualCartTextButton.Create(AtelierTexts.ButtonClear());
    buttonClear.SetName(n"clear");
    buttonClear.Reparent(cartControls);

    let buttonAddAll: ref<VirtualCartTextButton> = VirtualCartTextButton.Create(AtelierTexts.ButtonAddAll());
    buttonAddAll.SetName(n"addAll");
    buttonAddAll.Reparent(cartControls);

    this.cartIcon = buttonCart;
    this.cartButtonClear = buttonClear;
    this.cartButtonAddAll = buttonAddAll;

    let searchContainer: ref<inkCanvas> = new inkCanvas();
    searchContainer.SetName(n"searchContainer");
    searchContainer.SetAnchor(inkEAnchor.TopRight);
    searchContainer.SetMargin(new inkMargin(0.0, 170.0, 600.0, 0.0));
    searchContainer.Reparent(vendorHeader);

    let searchInput: ref<HubTextInput> = HubTextInput.Create();
    searchInput.SetName(n"searchInput");
    searchInput.SetLetterCase(textLetterCase.UpperCase);
    searchInput.SetMaxLength(30);
    searchInput.SetDefaultText(GetLocalizedText("LocKey#48662"));
    searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
    searchInput.Reparent(searchContainer);
    this.searchInput = searchInput;

    let balancesContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
    balancesContainer.SetName(n"balancesContainer");
    balancesContainer.SetAnchor(inkEAnchor.TopCenter);
    balancesContainer.SetAnchorPoint(new Vector2(1.0, 0.5));
    balancesContainer.SetMargin(new inkMargin(0.0, 200.0, 0.0, 0.0));
    balancesContainer.SetSize(new Vector2(800.0, 400.0));
    balancesContainer.Reparent(wrapper);

    // Player
    let playerMoneyHeader: ref<inkText> = new inkText();
    playerMoneyHeader.SetName(n"playerMoneyHeader");
    playerMoneyHeader.SetAnchor(inkEAnchor.CenterRight);
    playerMoneyHeader.SetHAlign(inkEHorizontalAlign.Right);
    playerMoneyHeader.SetText(AtelierTexts.PlayerMoney());
    playerMoneyHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    playerMoneyHeader.SetFontSize(38);
    playerMoneyHeader.SetFontStyle(n"Medium");
    playerMoneyHeader.SetLetterCase(textLetterCase.UpperCase);
    playerMoneyHeader.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    playerMoneyHeader.BindProperty(n"tintColor", n"MainColors.PanelRed");
    playerMoneyHeader.BindProperty(n"fontSize", n"MainColors.ReadableSmall");
    playerMoneyHeader.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
    playerMoneyHeader.SetFitToContent(true);
    playerMoneyHeader.Reparent(balancesContainer);

    let playerMoneyValues: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    playerMoneyValues.SetName(n"playerMoneyValues");
    playerMoneyValues.SetAnchor(inkEAnchor.CenterRight);
    playerMoneyValues.SetHAlign(inkEHorizontalAlign.Right);
    playerMoneyValues.SetFitToContent(true);
    playerMoneyValues.SetChildOrder(inkEChildOrder.Backward);
    playerMoneyValues.Reparent(balancesContainer);

    let eddiesAmount: ref<inkText> = new inkText();
    eddiesAmount.SetName(n"eddiesAmount");
    eddiesAmount.SetAnchor(inkEAnchor.CenterRight);
    eddiesAmount.SetAnchorPoint(new Vector2(0.5, 0.5));
    eddiesAmount.SetHAlign(inkEHorizontalAlign.Right);
    eddiesAmount.SetText("1000");
    eddiesAmount.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    eddiesAmount.SetFontSize(50);
    eddiesAmount.SetFontStyle(n"Medium");
    eddiesAmount.SetFitToContent(true);
    eddiesAmount.SetLetterCase(textLetterCase.UpperCase);
    eddiesAmount.SetMargin(new inkMargin(20.0, 0.0, 0.0, 0.0));
    eddiesAmount.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    eddiesAmount.BindProperty(n"tintColor", n"MainColors.PanelRed");
    eddiesAmount.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
    eddiesAmount.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
    eddiesAmount.Reparent(playerMoneyValues);
    this.playerMoney = eddiesAmount;

    let eddiesIcon: ref<inkImage> = new inkImage();
    eddiesIcon.SetName(n"eddiesIcon");
    eddiesIcon.SetAnchor(inkEAnchor.Centered);
    eddiesIcon.SetAnchorPoint(new Vector2(0.5, 0.5));
    eddiesIcon.SetHAlign(inkEHorizontalAlign.Right);
    eddiesIcon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\atlas_cash.inkatlas");
    eddiesIcon.SetTexturePart(n"cash_symbol_normal");
    eddiesIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    eddiesIcon.BindProperty(n"tintColor", n"MainColors.Yellow");
    eddiesIcon.SetSize(new Vector2(58.0, 35.0));
    eddiesIcon.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    eddiesIcon.SetBrushTileType(inkBrushTileType.NoTile);
    eddiesIcon.SetContentHAlign(inkEHorizontalAlign.Center);
    eddiesIcon.SetContentVAlign(inkEVerticalAlign.Center);
    eddiesIcon.SetTileHAlign(inkEHorizontalAlign.Center);
    eddiesIcon.SetTileVAlign(inkEVerticalAlign.Center);
    eddiesIcon.Reparent(playerMoneyValues);

    // Cart
    let cartMoneyHeader: ref<inkText> = new inkText();
    cartMoneyHeader.SetName(n"cartMoneyHeader");
    cartMoneyHeader.SetAnchor(inkEAnchor.CenterRight);
    cartMoneyHeader.SetHAlign(inkEHorizontalAlign.Right);
    cartMoneyHeader.SetText(AtelierTexts.Cart());
    cartMoneyHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    cartMoneyHeader.SetFontSize(38);
    cartMoneyHeader.SetFontStyle(n"Medium");
    cartMoneyHeader.SetLetterCase(textLetterCase.UpperCase);
    cartMoneyHeader.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    cartMoneyHeader.BindProperty(n"tintColor", n"MainColors.PanelRed");
    cartMoneyHeader.BindProperty(n"fontSize", n"MainColors.ReadableSmall");
    cartMoneyHeader.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
    cartMoneyHeader.SetFitToContent(true);
    cartMoneyHeader.SetMargin(new inkMargin(0.0, 20.0, 0.0, 0.0));
    cartMoneyHeader.Reparent(balancesContainer);

    let cartMoneyValues: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    cartMoneyValues.SetName(n"cartMoneyValues");
    cartMoneyValues.SetAnchor(inkEAnchor.CenterRight);
    cartMoneyValues.SetHAlign(inkEHorizontalAlign.Right);
    cartMoneyValues.SetFitToContent(true);
    cartMoneyValues.SetChildOrder(inkEChildOrder.Backward);
    cartMoneyValues.Reparent(balancesContainer);

    let cartEddiesAmount: ref<inkText> = new inkText();
    cartEddiesAmount.SetName(n"cartEddiesAmount");
    cartEddiesAmount.SetAnchor(inkEAnchor.CenterRight);
    cartEddiesAmount.SetAnchorPoint(new Vector2(0.5, 0.5));
    cartEddiesAmount.SetHAlign(inkEHorizontalAlign.Right);
    cartEddiesAmount.SetText("0");
    cartEddiesAmount.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    cartEddiesAmount.SetFontSize(50);
    cartEddiesAmount.SetFontStyle(n"Medium");
    cartEddiesAmount.SetFitToContent(true);
    cartEddiesAmount.SetLetterCase(textLetterCase.UpperCase);
    cartEddiesAmount.SetMargin(new inkMargin(20.0, 0.0, 0.0, 0.0));
    cartEddiesAmount.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    cartEddiesAmount.BindProperty(n"tintColor", n"MainColors.PanelRed");
    cartEddiesAmount.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
    cartEddiesAmount.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
    cartEddiesAmount.Reparent(cartMoneyValues);
    this.cartMoney = cartEddiesAmount;

    let cartEddiesIcon: ref<inkImage> = new inkImage();
    cartEddiesIcon.SetName(n"cartEddiesIcon");
    cartEddiesIcon.SetAnchor(inkEAnchor.Centered);
    cartEddiesIcon.SetAnchorPoint(new Vector2(0.5, 0.5));
    cartEddiesIcon.SetHAlign(inkEHorizontalAlign.Right);
    cartEddiesIcon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\atlas_cash.inkatlas");
    cartEddiesIcon.SetTexturePart(n"cash_symbol_normal");
    cartEddiesIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    cartEddiesIcon.BindProperty(n"tintColor", n"MainColors.Yellow");
    cartEddiesIcon.SetSize(new Vector2(58.0, 35.0));
    cartEddiesIcon.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    cartEddiesIcon.SetBrushTileType(inkBrushTileType.NoTile);
    cartEddiesIcon.SetContentHAlign(inkEHorizontalAlign.Center);
    cartEddiesIcon.SetContentVAlign(inkEVerticalAlign.Center);
    cartEddiesIcon.SetTileHAlign(inkEHorizontalAlign.Center);
    cartEddiesIcon.SetTileVAlign(inkEVerticalAlign.Center);
    cartEddiesIcon.Reparent(cartMoneyValues);
  }

  private final func InitializeDataSource() -> Void {
    this.storeDataView = new VirtualStoreDataView();
    this.storeDataSource = new ScriptableDataSource();
    this.storeDataView.BindUIScriptableSystem(this.uiScriptableSystem);
    this.storeDataView.SetSource(this.storeDataSource);
    this.storeDataView.EnableSorting();
    this.storeItemsClassifier = new VirtualStoreTemplateClassifier();
    this.storeListController.SetClassifier(this.storeItemsClassifier);
    this.storeListController.SetSource(this.storeDataView);
  }

  private final func InitializeListeners() -> Void {
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnHandleGlobalInput");
  }

  private final func SetupDropdown() -> Void {
    let controller: ref<DropdownListController>;
    let data: ref<DropdownItemData>;
    let sorting: Int32;
    let vendorSortingButtonController: ref<DropdownButtonController>;
    this.vendorSortingButton.RegisterToCallback(n"OnRelease", this, n"OnVendorSortingButtonClicked");
    controller = this.sortingDropdown.GetController() as DropdownListController;
    vendorSortingButtonController = this.vendorSortingButton.GetController() as DropdownButtonController;
    controller.Setup(this, SortingDropdownData.GetDefaultDropdownOptions());
    sorting = this.uiScriptableSystem.GetVendorPanelVendorActiveSorting(EnumInt(ItemSortMode.Default));
    data = SortingDropdownData.GetDropdownOption(controller.GetData(), IntEnum<ItemSortMode>(sorting));
    vendorSortingButtonController.SetData(data);
    this.storeDataView.SetSortMode(FromVariant<ItemSortMode>(data.identifier));
  }

  private final func SetFilters(widget: ref<inkWidget>, data: array<Int32>, callback: CName) -> Void {
    let radioGroup: ref<FilterRadioGroup> = widget.GetController() as FilterRadioGroup;
    radioGroup.SetData(data);
    radioGroup.RegisterToCallback(n"OnValueChanged", this, callback);
    if ArraySize(data) == 1 {
      radioGroup.Toggle(data[0]);
    };
  }

  private final func ToggleFilter(widget: ref<inkWidget>, data: Int32) -> Void {
    let radioGroup: ref<FilterRadioGroup> = widget.GetController() as FilterRadioGroup;
    radioGroup.ToggleData(data);
  }

  private final func ShowTooltipsForItemController(targetWidget: wref<inkWidget>, equippedItem: InventoryItemData, inspectedItemData: InventoryItemData, iconErrorInfo: ref<DEBUG_IconErrorInfo>, isBuybackStack: Bool) -> Void {
    let data: ref<InventoryTooltipData>;
    data = this.inventoryManager.GetTooltipDataForInventoryItem(inspectedItemData, InventoryItemData.IsEquipped(inspectedItemData), iconErrorInfo, InventoryItemData.IsVendorItem(inspectedItemData));
    data.displayContext = InventoryTooltipDisplayContext.Vendor;
    data.isVirtualItem = true;
    data.virtualInventoryItemData = inspectedItemData;
    this.tooltipsManager.ShowTooltipAtWidget(n"itemTooltip", targetWidget, data, gameuiETooltipPlacement.RightTop);
  }

  private final func FillVirtualStock() -> Void {
    let inventoryManager: ref<InventoryManager> = GameInstance.GetInventoryManager(this.player.GetGame());
    let storeItems: array<String> = this.GetVirtualStoreItems();
    let itemsPrices: array<Int32> = this.GetVirtualStorePrices();
    let itemsQualities: array<CName> = this.GetVirtualStoreQualities();
    let itemsQuantities: array<Int32> = this.GetVirtualStoreQuantities();
    let vendorObject: ref<GameObject> = this.vendorDataManager.GetVendorInstance(); 
    let totalPrice: Float = 0.0;

    let stockItem: ref<VirtualStockItem>;
    let virtualItemIndex = 0;
    ArrayClear(this.virtualStock);
    while virtualItemIndex < ArraySize(storeItems) {
      let itemTDBID: TweakDBID = TDBID.Create(storeItems[virtualItemIndex]);
      let itemId = ItemID.FromTDBID(itemTDBID);
      let itemData: ref<gameItemData> = inventoryManager.CreateBasicItemData(itemId, this.player);
      AtelierDebug(s"Store item: \(ToString(storeItems[virtualItemIndex]))", this.config);
      itemData.isVirtualItem = true;
      stockItem = new VirtualStockItem();
      stockItem.itemID = itemId;
      stockItem.itemTDBID = itemTDBID;
      stockItem.price = Cast<Float>(itemsPrices[virtualItemIndex]);
      stockItem.quality = itemsQualities[virtualItemIndex];
      stockItem.quantity = itemsQuantities[virtualItemIndex];
      AtelierDebug(s"   Dynamic tags: \(ToString(itemData.GetDynamicTags()))", this.config);
      AtelierDebug(s"   VirtPrice: \(ToString(stockItem.price))", this.config);
      if (RoundF(stockItem.price) == 0) {
        stockItem.price = Cast<Float>(AtelierItemsHelper.ScaleItemPrice(this.player, vendorObject, itemId, stockItem.quality) * stockItem.quantity);
      };
      AtelierDebug(s"   CalcPrice: \(ToString(stockItem.price))", this.config);
      stockItem.itemData = itemData;
      ArrayPush(this.virtualStock, stockItem);
      virtualItemIndex += 1;
      totalPrice += stockItem.price;
    };

    this.totalItemsPrice = Cast<Int32>(totalPrice);
    this.ScaleStockItems();
  }

  private final func ScaleStockItems() -> Void {
    let itemData: wref<gameItemData>;
    let itemRecord: wref<Item_Record>;
    let i: Int32 = 0;
    while i < ArraySize(this.virtualStock) {
      itemRecord = TweakDBInterface.GetItemRecord(this.virtualStock[i].itemTDBID);
      if !itemRecord.IsSingleInstance() && !itemData.HasTag(n"Cyberware") {
        AtelierItemsHelper.ScaleItem(this.player, this.virtualStock[i].itemData, this.virtualStock[i].quality);
      };
      i += 1;
    };
  }

  private final func ConvertGameDataIntoInventoryData(data: array<ref<VirtualStockItem>>, owner: wref<GameObject>) -> array<InventoryItemData> {
    let itemData: InventoryItemData;
    let itemDataArray: array<InventoryItemData>;
    let stockItem: ref<VirtualStockItem>;
    let i: Int32 = 0;
    while i < ArraySize(data) {
      stockItem = data[i];
      itemData = this.inventoryManager.GetInventoryItemData(owner, stockItem.itemData);
      InventoryItemData.SetIsVendorItem(itemData, true);
      InventoryItemData.SetPrice(itemData, stockItem.price);
      InventoryItemData.SetBuyPrice(itemData, stockItem.price);
      InventoryItemData.SetQuantity(itemData, stockItem.quantity);
      InventoryItemData.SetQuality(itemData, stockItem.quality);
      ArrayPush(itemDataArray, itemData);
      i += 1;
    };
    return itemDataArray;
  }

  // Darkcopse prices tweak
  private final func GetVirtualStorePrices() -> array<Int32> { 
    let items: array<String> = this.virtualStore.items;
    let prices: array<Int32> = this.virtualStore.prices;
    let defaultPrice = 0;

    if (ArraySize(prices) == 1) {
      defaultPrice = prices[0];
    };

    let i = 0;
    if (ArraySize(items) > ArraySize(prices)) {
      while (i < (ArraySize(items) - ArraySize(prices))) {
        ArrayPush(prices, defaultPrice); 
      };
    };

    return prices;
  }

  private final func GetVirtualStoreQualities() -> array<CName> {
    let items: array<String> = this.virtualStore.items;
    let qualities: array<String> = this.virtualStore.qualities;
    let qualitiesCNames: array<CName> = [];

    let defaultQuality = n"Rare";
    // Darkcopse qualities tweak
    if (ArraySize(qualities) == 1) {
      defaultQuality = StringToName(qualities[0]);
    };

    let i: Int32 = 0;

    while (i < ArraySize(items)) {
      let itemQuality: String = qualities[i];

      if Equals(itemQuality, "") {
        ArrayPush(qualitiesCNames, defaultQuality);
      } else {
        let qualityCName: CName = StringToName(itemQuality);

        if IsNameValid(qualityCName) && !Equals(qualityCName, n"") {
          ArrayPush(qualitiesCNames, qualityCName);
        } else {
          ArrayPush(qualitiesCNames, defaultQuality);
        };
      };

      i += 1;
    };

    return qualitiesCNames;
  }

  // Darkcopse quantities tweak
  private final func GetVirtualStoreQuantities() -> array<Int32> {
    let items: array<String> = this.virtualStore.items;
    let quantities: array<Int32> = this.virtualStore.quantities;
    let i: Int32 = 0;
    if (ArraySize(items) > ArraySize(quantities)) {
      while (i < (ArraySize(items) - ArraySize(quantities))) {
        ArrayPush(quantities, 1); 
      };
    };
    return quantities;
  }

  private func PopulateVirtualShop() -> Void {
    let i: Int32;
    let items: array<ref<IScriptable>>;
    let currentPlayerMoney: Int32;
    let vendorInventory: array<InventoryItemData>;
    let vendorInventoryData: ref<VendorInventoryItemData>;
    let vendorInventorySize: Int32;
    this.filterManager.Clear();
    this.filterManager.AddFilter(ItemFilterCategory.AllItems);
    this.FillVirtualStock();
    vendorInventory = this.ConvertGameDataIntoInventoryData(this.virtualStock, this.vendorDataManager.GetVendorInstance());
    vendorInventorySize = ArraySize(vendorInventory);
    currentPlayerMoney = this.vendorDataManager.GetLocalPlayerCurrencyAmount();

    AtelierDebug(s"Resulting list size: \(vendorInventorySize)", this.config);

    i = 0;
    while i < vendorInventorySize {
      vendorInventoryData = new VendorInventoryItemData();
      vendorInventoryData.ItemData = vendorInventory[i];

      // Darkcopse requirements displaying fix
      if InventoryItemData.GetGameItemData(vendorInventoryData.ItemData).HasTag(n"Cyberware") {
        InventoryItemData.SetEquipRequirements(vendorInventoryData.ItemData, RPGManager.GetEquipRequirements(this.player, InventoryItemData.GetGameItemData(vendorInventoryData.ItemData)));
      };
      InventoryItemData.SetIsEquippable(vendorInventoryData.ItemData, EquipmentSystem.GetInstance(this.player).GetPlayerData(this.player).IsEquippable(InventoryItemData.GetGameItemData(vendorInventoryData.ItemData)));

      vendorInventoryData.IsVendorItem = true;
      vendorInventoryData.IsEnoughMoney = currentPlayerMoney >= Cast<Int32>(InventoryItemData.GetBuyPrice(vendorInventory[i]));
      vendorInventoryData.IsDLCAddedActiveItem = this.uiScriptableSystem.IsDLCAddedActiveItem(ItemID.GetTDBID(InventoryItemData.GetID(vendorInventory[i])));

      this.inventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.uiScriptableSystem);      
      this.filterManager.AddItem(vendorInventoryData.ItemData.GameItemData);
      ArrayPush(items, vendorInventoryData);
      i += 1;
    };

    this.storeDataSource.Reset(items);
    this.filterManager.SortFiltersList();
    this.filterManager.InsertFilter(0, ItemFilterCategory.AllItems);
    this.SetFilters(this.filtersContainer, this.filterManager.GetIntFiltersList(), n"OnVendorFilterChange");
    this.storeDataView.EnableSorting();
    this.storeDataView.SetFilterType(this.lastVendorFilter);
    this.storeDataView.SetSortMode(this.storeDataView.GetSortMode());
    this.storeDataView.DisableSorting();
    this.ToggleFilter(this.filtersContainer, EnumInt(this.lastVendorFilter));
    this.filtersContainer.SetVisible(ArraySize(items) > 0);
    this.PlayLibraryAnimation(n"vendor_grid_show");

    this.cartManager.StoreVendorInventory(vendorInventory);
  }

  private func HandleCartAction() -> Void {
    if !IsDefined(this.lastItemHoverOverEvent) {
      return ;
    };

    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);
    let itemID: ItemID = InventoryItemData.GetID(this.lastItemHoverOverEvent.itemData);
    let isAddedToCart: Bool = this.cartManager.IsAddedToCart(itemID);
    let isEnoughMoney: Bool = this.cartManager.PlayerHasEnoughMoneyFor(itemID);
    let hintLabel: String;

    if !isEnoughMoney && !isAddedToCart {
      return ;
    };

    let stockItem: ref<VirtualStockItem> = this.GetStockItem(itemID);
    if isAddedToCart {
      if this.cartManager.RemoveFromCart(stockItem) {
        hintLabel = GetLocalizedTextByKey(n"VA-Cart-Add");
      };
    } else {
      if this.cartManager.AddToCart(stockItem) {
        hintLabel = GetLocalizedTextByKey(n"VA-Cart-Remove");
      };
    };

    this.buttonHintsController.RemoveButtonHint(atelierActions.addToVirtualCart);
    this.buttonHintsController.AddButtonHint(atelierActions.addToVirtualCart, hintLabel);
    this.RefreshCartState();
    this.RefreshCartControls();
    this.RefreshMoneyLabels();
    this.RefreshMoneyRequirements();
  }

  private func RefreshEquippedState() -> Void {
   this.uiSystem.QueueEvent(AtelierEquipStateChangedEvent.Create(this.previewManager));
  }

  private func RefreshCartState() -> Void {
    this.uiSystem.QueueEvent(AtelierCartStateChangedEvent.Create(this.cartManager));
  }

  private func RefreshMoneyRequirements() -> Void {
    this.uiSystem.QueueEvent(AtelierMoneyRequirementChangedEvent.Create(this.cartManager));
  }

  private func RefreshCartControls() -> Void {
    let playerMoney: Int32 = this.cartManager.GetCurrentPlayerMoney();
    let cartSize: Int32 = this.cartManager.GetCartSize();
    this.cartIcon.SetCounter(cartSize);

    let cartIsNotEmpty: Bool = cartSize > 0;
    this.cartIcon.Dim(!cartIsNotEmpty);
    this.cartIcon.SetEnabled(cartIsNotEmpty);
    this.cartButtonClear.Dim(!cartIsNotEmpty);
    this.cartButtonClear.SetEnabled(cartIsNotEmpty);

    let enoughMoneyForBuyAll: Bool = playerMoney >= this.totalItemsPrice;
    let addAllButtonEnabled: Bool = enoughMoneyForBuyAll && !this.allItemsAdded;
    this.cartButtonAddAll.Dim(!addAllButtonEnabled);
    this.cartButtonAddAll.SetEnabled(addAllButtonEnabled);
  }

  private func RefreshMoneyLabels() -> Void {
    let playerAmount: Int32 = this.cartManager.GetCurrentPlayerMoney();
    let cartAmount: Int32 = this.cartManager.GetCurrentGoodsPrice();
    this.playerMoney.SetText(s"\(playerAmount)");
    this.cartMoney.SetText(s"\(cartAmount)");
  }

  private func ShowAddAllConfirmationPopup() -> Void {
    this.popupToken = GenericMessageNotification.Show(this, this.virtualStore.storeName, AtelierTexts.ConfirmationAddAll(), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnAddAllConfirmationPopupClosed");
  }

  private func ShowRemoveAllConfirmationPopup() -> Void {
    this.popupToken = GenericMessageNotification.Show(this, this.virtualStore.storeName, AtelierTexts.ConfirmationRemoveAll(), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnRemoveAllConfirmationPopupClosed");
  }

  protected cb func OnAddAllConfirmationPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
      for stockItem in this.virtualStock {
        this.cartManager.AddToCart(stockItem);
      };
      this.allItemsAdded = true;
      this.RefreshCartState();
      this.RefreshCartControls();
      this.RefreshMoneyLabels();
    };

    this.popupToken = null;
  }

  protected cb func OnRemoveAllConfirmationPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
      this.cartManager.ClearCart();
      this.allItemsAdded = false;
      this.RefreshCartState();
      this.RefreshCartControls();
      this.RefreshMoneyLabels();
      this.RefreshMoneyRequirements();
    };

    this.popupToken = null;
  }

  private final func GetVirtualStoreName() -> String {
    return this.virtualStore.storeName;
  }

  private final func GetVirtualStoreID() -> CName {
    return this.virtualStore.storeID;
  }

  private final func GetVirtualStoreItems() -> array<String> {
    return this.virtualStore.items;
  }
  
  private final func SetTimeDilatation(enable: Bool) -> Void {
    TimeDilationHelper.SetTimeDilationWithProfile(this.player, "radialMenu", enable);
  }

  private final func GetStockItem(itemID: ItemID) -> ref<VirtualStockItem> {
    for stockItem in this.virtualStock {
      if Equals(stockItem.itemID, itemID) {
        return stockItem;
      };
    };
    return null;
  }

  private final func SpawnPreviewPuppet() -> Void {
    let wrapper: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidgetByPathName(n"wrapper") as inkCompoundWidget;
    wrapper.SetInteractive(true);
    this.SpawnFromExternal(wrapper, r"base\\gameplay\\gui\\virtual_atelier_preview.inkwidget", n"Root");
  }
}
