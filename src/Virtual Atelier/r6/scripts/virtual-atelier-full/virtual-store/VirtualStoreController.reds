module VirtualAtelier.UI
import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Core.AtelierActions
import VirtualAtelier.Core.AtelierTexts
import VirtualAtelier.Logs.AtelierDebug
import VirtualAtelier.Helpers.*
import VirtualAtelier.Systems.*
import Codeware.UI.*

@if(ModuleExists("AtelierDelivery"))
import AtelierDelivery.*

public class VirtualStorePageRenderCallback extends DelayCallback {
  public let controller: wref<VirtualStoreController>;
  public let token: Int32;

  public func Call() -> Void {
    if IsDefined(this.controller) {
      this.controller.ContinuePageRender(this.token);
    };
  }

  public static func Create(controller: ref<VirtualStoreController>, token: Int32) -> ref<VirtualStorePageRenderCallback> {
    let callback: ref<VirtualStorePageRenderCallback> = new VirtualStorePageRenderCallback();
    callback.controller = controller;
    callback.token = token;
    return callback;
  }
}

public class VirtualStoreController extends gameuiMenuGameController {
  private let player: wref<PlayerPuppet>;
  private let previewManager: wref<VirtualAtelierPreviewManager>;
  private let cartManager: wref<VirtualAtelierCartManager>;
  private let storesManager: wref<VirtualAtelierStoresManager>;
  private let questsSystem: wref<QuestsSystem>;
  private let uiSystem: wref<UISystem>;
  private let uiScriptableSystem: wref<UIScriptableSystem>;
  private let uiInventorySystem: wref<UIInventoryScriptableSystem>;
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
  private let pagePrevButton: wref<VirtualCartTextButton>;
  private let pageNextButton: wref<VirtualCartTextButton>;
  private let pageLabel: wref<inkText>;

  // Store data
  private let virtualStock: array<ref<VirtualStockItem>>;
  private let filteredStock: array<ref<VirtualStockItem>>;
  private let currentPageItemData: array<ref<gameItemData>>;
  private let pendingPageStock: array<ref<VirtualStockItem>>;
  private let pendingPageItems: array<ref<IScriptable>>;
  private let pendingPageIndex: Int32;
  private let pageRenderToken: Int32;
  private let isUninitializing: Bool;
  private let pageBatchSize: Int32 = 50;
  private let virtualStore: ref<VirtualShop>;
  private let storeListController: wref<inkVirtualGridController>;
  private let storeDataView: ref<VirtualStoreDataView>;
  private let storeDataSource: ref<ScriptableDataSource>;
  private let storeItemsClassifier: ref<VirtualStoreTemplateClassifier>;
  private let currentPage: Int32;
  private let totalPages: Int32;
  private let pageSize: Int32;

  private let popupToken: ref<inkGameNotificationToken>;
  private let currentTutorialsFact: Int32;
  private let lastVendorFilter: ItemFilterCategory;
  private let lastItemHoverOverEvent: ref<ItemDisplayHoverOverEvent>;
  private let totalItemsPrice: Int32;
  private let allItemsAdded: Bool;

  public cb func OnInitialize() -> Bool {
    this.isUninitializing = false;
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

  public cb func OnUninitialize() -> Bool {
    this.isUninitializing = true;
    this.pageRenderToken += 1;
    ArrayClear(this.pendingPageStock);
    ArrayClear(this.pendingPageItems);
    ArrayClear(this.currentPageItemData);

    this.player.SetSkipDeviceExit(false);
    this.uiInventorySystem.FlushFullscreenCache();
    this.cartManager.ClearCart();
    this.cartManager.ClearVirtualStock();
    this.cartManager = null;
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
      this.sortingDropdown.SetTranslation(Vector2(2650.00, 270.00));
      controller = this.sortingDropdown.GetController() as DropdownListController;
      controller.SetTriggerButton(this.vendorSortingButton.GetController() as DropdownButtonController);
      controller.Toggle();
      this.OnInventoryItemHoverOut(null);
    };
  }

  protected cb func OnDropdownItemClickedEvent(evt: ref<DropdownItemClickedEvent>) -> Bool {
    let setVendorSortingRequest: ref<UIScriptableSystemSetVendorPanelVendorSorting>;
    let identifier: ItemSortMode = FromVariant<ItemSortMode>(evt.identifier);
    let options: array<ref<DropdownItemData>> = (this.sortingDropdown.GetController() as DropdownListController).GetData();
    let data: ref<DropdownItemData> = SortingDropdownData.GetDropdownOption(options, identifier);
    if IsDefined(data) {
      if evt.triggerButton.GetRootWidget() == this.vendorSortingButton {
        evt.triggerButton.SetData(data);
        this.storeDataView.SetSortMode(identifier);
        this.SortVirtualStock();
        this.ApplyStockView(true);
        setVendorSortingRequest = new UIScriptableSystemSetVendorPanelVendorSorting();
        setVendorSortingRequest.sortMode = EnumInt(identifier);
        this.uiScriptableSystem.QueueRequest(setVendorSortingRequest);
      };
    };
  }

  protected cb func OnSearchInput(widget: wref<inkWidget>) {
    this.ApplyStockView(true);
  }

  protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
    if IsDefined(this.searchInput) {
      this.searchInput.SetText("");
    };
    this.storeDataView.SetSearchQuery("");

    let category: ItemFilterCategory = this.filterManager.GetAt(selectedIndex);
    this.lastVendorFilter = category;
    this.ApplyStockView(true);
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

  protected cb func OnHandleGlobalHold(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"upgrade_perk") && !this.IsInstantBuyEnabled() {
      if evt.GetHoldProgress() >= 0.9 {
        this.OpenCartQuantityPopup();
      };
    };
  }

  protected cb func OnHandleGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);

    // Esc: UI_Cancel -> cancel -> back
    // C: UI_Cancel -> cancel -> UI_Exit
    if evt.IsAction(atelierActions.resetGarment) {
      this.previewManager.ResetGarment();
      this.RefreshVirtualItemState();
    } else if evt.IsAction(atelierActions.removeAllGarment) {
      this.previewManager.RemoveAllGarment();
      this.RefreshVirtualItemState();
    } else if evt.IsAction(atelierActions.removePreviewGarment) {
      this.previewManager.RemovePreviewGarment();
      this.RefreshVirtualItemState();
    } else if evt.IsAction(n"UI_Cancel") || evt.IsAction(n"cancel") || evt.IsAction(n"back") {
      evt.Consume();
      this.previewManager.RemovePreviewGarment();
      this.QueueEvent(new AtelierCloseVirtualStore());
    } else if evt.IsAction(n"mouse_left") {
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        this.RequestSetFocus(null);
      };
    } else if evt.IsAction(atelierActions.addToVirtualCart) {
      if this.IsInstantBuyEnabled() {
        if this.lastItemHoverOverEvent != null {
          this.BuyItemFromVirtualVendor(this.lastItemHoverOverEvent.itemData);
        };
      } else {
        this.HandleCartAction();
      };
    };
  }

  protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);
    let itemID: ItemID = InventoryItemData.GetID(evt.itemData);
    let quantity: Int32 = InventoryItemData.GetQuantity(evt.itemData);
    let isEquipped: Bool = this.previewManager.GetIsEquipped(itemID);
    let isAddedToCart: Bool = this.cartManager.IsAddedToCart(itemID, quantity);
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

    if this.IsInstantBuyEnabled() {
      hintLabel = AtelierTexts.Purchase();
    } else {
      if isAddedToCart {
        hintLabel = AtelierTexts.CartRemove();
      } else {
        hintLabel = AtelierTexts.CartAdd();
      };
    }

    this.buttonHintsController.RemoveButtonHint(atelierActions.addToVirtualCart);
    this.buttonHintsController.AddButtonHint(atelierActions.addToVirtualCart, hintLabel);

    this.lastItemHoverOverEvent = evt;
    this.RequestSetFocus(null);
    
    let noCompare: InventoryItemData;
    this.ShowTooltipsForItemController(evt.widget, noCompare, evt.itemData, evt.display.DEBUG_GetIconErrorInfo(), false);

    let cursorContext = n"Default";
    let cursorData: ref<MenuCursorUserData> = new MenuCursorUserData();
    cursorData.SetAnimationOverride(n"hoverOnHoldToComplete");
    cursorData.AddAction(n"upgrade_perk");
    cursorContext = n"HoldToComplete";
    this.SetCursorContext(cursorContext, cursorData);
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
      // If no hold then change equip state
      itemID = InventoryItemData.GetID(evt.itemData);
      isEquipped = this.previewManager.GetIsEquipped(itemID);
      isWeapon = RPGManager.IsItemWeapon(itemID);
      isClothing = RPGManager.IsItemClothing(itemID);

      if isClothing || isWeapon {
        this.previewManager.TogglePreviewItem(itemID);
        this.RefreshVirtualItemState();
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

  @if(ModuleExists("AtelierDelivery"))
  private final func WrapStockItem(from: ref<VirtualStockItem>) -> ref<WrappedVirtualStockItem> {
    let wrapped: ref<WrappedVirtualStockItem> = new WrappedVirtualStockItem();
    wrapped.id = from.itemTDBID;
    wrapped.price = from.price;
    wrapped.weight = from.weight;
    wrapped.quality = from.quality;
    wrapped.quantity = from.quantity;

    return wrapped;
  }

  @if(ModuleExists("AtelierDelivery"))
  protected cb func OnAtelierDeliveryOrderCreatedEvent(evt: ref<AtelierDeliveryOrderCreatedEvent>) -> Bool {
    this.cartManager.ClearCart();
    this.allItemsAdded = false;
    this.RefreshCartControls();
    this.RefreshMoneyLabels();
    this.RefreshVirtualItemState();
    this.PlaySound(n"Item", n"OnBuy");
  }

  @if(ModuleExists("AtelierDelivery"))
  private final func HandleBuyButtonClick() -> Void {
    let store: String = this.GetVirtualStoreName();
    let orderId: Int32 = OrderProcessingSystem.Get(this.player.GetGame()).GetNextOrderId();
    let currentGoods: array<ref<VirtualCartItem>> = this.cartManager.GetCurrentGoods();
    
    let purchasedItems: array<ref<WrappedVirtualCartItem>>;
    let wrapper: ref<WrappedVirtualCartItem>;
    for item in currentGoods {
      wrapper = new WrappedVirtualCartItem();
      wrapper.stockItem = this.WrapStockItem(item.stockItem);
      wrapper.purchaseAmount = item.purchaseAmount;
      ArrayPush(purchasedItems, wrapper);
    };

    let price: Int32 = this.cartManager.GetCurrentGoodsPrice();
    let weight: Float = this.cartManager.GetCurrentGoodsWeight();
    let quantity: Int32 = this.cartManager.GetCurrentGoodsQuantity();
    let timeSystem: ref<TimeSystem> = GameInstance.GetTimeSystem(this.player.GetGame());
    let ordersSystem: ref<OrderProcessingSystem> = OrderProcessingSystem.Get(this.player.GetGame());
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.player.GetGame());

    let currentBalance: Int32 = this.vendorDataManager.GetLocalPlayerCurrencyAmount();
    let currentConfig: ref<VirtualAtelierDeliveryConfig> = new VirtualAtelierDeliveryConfig();
    let standardCost: Int32 = currentConfig.standardDeliveryPrice + price;
    let priorityCost: Int32 = Cast<Int32>(Cast<Float>(currentConfig.priorityDeliveryPrice) * weight) + price;
    let enoughForStandard: Bool = currentBalance >= standardCost;
    let enoughForPriority: Bool = currentBalance >= priorityCost;

    let params: ref<AtelierDeliveryPopupParams> = new AtelierDeliveryPopupParams();
    params.store = store;
    params.orderId = orderId;
    params.price = price;
    params.weight = weight;
    params.quantity = quantity;
    params.items = purchasedItems;
    params.enoughForStandard = enoughForStandard;
    params.enoughForPriority = enoughForPriority;

    if enoughForStandard {
      OrderCheckoutPopup.Show(this, params, timeSystem, ordersSystem, uiSystem);
    } else {
      this.ShowNotEnoughMoneyNotification();
    };
  }

  @if(!ModuleExists("AtelierDelivery"))
  private final func HandleBuyButtonClick() -> Void {
    this.ShowPurchaseAllConfirmationPopup();
  }

  @if(ModuleExists("AtelierDelivery"))
  private final func IsInstantBuyEnabled() -> Bool {
    return false;
  }

  @if(!ModuleExists("AtelierDelivery"))
  private final func IsInstantBuyEnabled() -> Bool {
    return this.config.instantBuy;
  }

  private func ShowOrderCreatedNotification(id: Int32) {
    let notification: ref<UIMenuNotificationEvent> = new UIMenuNotificationEvent();
    notification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
    this.QueueEvent(notification);
  }

  private func ShowNotEnoughMoneyNotification() {
    let notification: ref<UIMenuNotificationEvent> = new UIMenuNotificationEvent();
    notification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
    this.QueueEvent(notification);
  }

  protected cb func OnVirtualAtelierControlClickEvent(evt: ref<VirtualAtelierControlClickEvent>) -> Bool {
    let name: CName = evt.name;
    switch name {
      case n"buy":
        this.HandleBuyButtonClick();
        break;
      case n"addAll":
        this.ShowAddAllConfirmationPopup();
        break;
      case n"clear":
        this.ShowRemoveAllConfirmationPopup();
        break;
      case n"prevPage":
        this.ShowPreviousPage();
        break;
      case n"nextPage":
        this.ShowNextPage();
        break;
      default:
        // do nothing
        break;
    }
  }

  private final func InitializeCoreSystems() -> Void {
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.player.SetSkipDeviceExit(true);
    this.previewManager = VirtualAtelierPreviewManager.GetInstance(this.player.GetGame());
    this.previewManager.SetPreviewState(true);
    this.cartManager = VirtualAtelierCartManager.GetInstance(this.player.GetGame());
    this.SpawnPreviewPuppet();
    this.storesManager = VirtualAtelierStoresManager.GetInstance(this.player.GetGame());
    this.virtualStore = this.storesManager.GetCurrentStore();
    this.questsSystem = GameInstance.GetQuestsSystem(this.player.GetGame());
    this.uiSystem = GameInstance.GetUISystem(this.player.GetGame());
    this.uiScriptableSystem = UIScriptableSystem.GetInstance(this.player.GetGame());
    this.uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.player.GetGame());
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

    let notificationsRoot: ref<inkCompoundWidget> = root.GetWidget(n"itemListRoot") as inkCompoundWidget;
    this.SpawnFromExternal(notificationsRoot, r"base\\gameplay\\gui\\widgets\\activity_log\\activity_log_panels.inkwidget", n"RootVert");

    this.vendorName.SetText(this.GetVirtualStoreName());
    AtelierButtonHintsHelper.ToggleAtelierControlHints(this.buttonHintsController, this.player, true);

    let cartControls: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    cartControls.SetName(n"cartControls");
    cartControls.SetMargin(inkMargin(0.0, 190.0, 0.0, 0.0));
    cartControls.SetAnchor(inkEAnchor.TopLeft);
    cartControls.SetHAlign(inkEHorizontalAlign.Left);
    cartControls.SetChildOrder(inkEChildOrder.Forward);
    cartControls.SetInteractive(true);

    if !this.IsInstantBuyEnabled() {
      cartControls.Reparent(vendorHeader);
    };

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

    let pageControls: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    pageControls.SetName(n"pageControls");
    pageControls.SetMargin(inkMargin(0.0, 220.0, 0.0, 0.0));
    pageControls.SetAnchor(inkEAnchor.Centered);
    pageControls.SetAnchorPoint(Vector2(0.5, 0.0));
    pageControls.SetHAlign(inkEHorizontalAlign.Center);
    pageControls.SetChildOrder(inkEChildOrder.Forward);
    pageControls.SetInteractive(true);
    pageControls.Reparent(vendorHeader);

    let pagePrev: ref<VirtualCartTextButton> = VirtualCartTextButton.Create("<");
    pagePrev.SetName(n"prevPage");
    pagePrev.SetFontSize(60);
    pagePrev.Reparent(pageControls);

    let pageText: ref<inkText> = new inkText();
    pageText.SetName(n"pageLabel");
    pageText.SetAnchor(inkEAnchor.Centered);
    pageText.SetHAlign(inkEHorizontalAlign.Center);
    pageText.SetVAlign(inkEVerticalAlign.Center);
    pageText.SetAnchorPoint(Vector2(0.5, 0.5));
    pageText.SetMargin(inkMargin(36.0, 0.0, 0.0, 0.0));
    pageText.SetText("1 / 1");
    pageText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    pageText.SetFontSize(42);
    pageText.SetFontStyle(n"Medium");
    pageText.SetFitToContent(true);
    pageText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    pageText.BindProperty(n"tintColor", n"MainColors.Blue");
    pageText.Reparent(pageControls);

    let pageNext: ref<VirtualCartTextButton> = VirtualCartTextButton.Create(">");
    pageNext.SetName(n"nextPage");
    pageNext.SetFontSize(60);
    pageNext.Reparent(pageControls);

    this.pagePrevButton = pagePrev;
    this.pageNextButton = pageNext;
    this.pageLabel = pageText;

    let searchContainer: ref<inkCanvas> = new inkCanvas();
    searchContainer.SetName(n"searchContainer");
    searchContainer.SetAnchor(inkEAnchor.TopRight);
    searchContainer.SetMargin(inkMargin(0.0, 170.0, 600.0, 0.0));
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
    balancesContainer.SetAnchorPoint(Vector2(1.0, 0.5));
    balancesContainer.SetMargin(inkMargin(0.0, 200.0, 0.0, 0.0));
    balancesContainer.SetSize(Vector2(800.0, 400.0));
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
    eddiesAmount.SetAnchorPoint(Vector2(0.5, 0.5));
    eddiesAmount.SetHAlign(inkEHorizontalAlign.Right);
    eddiesAmount.SetText("1000");
    eddiesAmount.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    eddiesAmount.SetFontSize(50);
    eddiesAmount.SetFontStyle(n"Medium");
    eddiesAmount.SetFitToContent(true);
    eddiesAmount.SetLetterCase(textLetterCase.UpperCase);
    eddiesAmount.SetMargin(inkMargin(20.0, 0.0, 0.0, 0.0));
    eddiesAmount.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    eddiesAmount.BindProperty(n"tintColor", n"MainColors.PanelRed");
    eddiesAmount.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
    eddiesAmount.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
    eddiesAmount.Reparent(playerMoneyValues);
    this.playerMoney = eddiesAmount;

    let eddiesIcon: ref<inkImage> = new inkImage();
    eddiesIcon.SetName(n"eddiesIcon");
    eddiesIcon.SetAnchor(inkEAnchor.Centered);
    eddiesIcon.SetAnchorPoint(Vector2(0.5, 0.5));
    eddiesIcon.SetHAlign(inkEHorizontalAlign.Right);
    eddiesIcon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\atlas_cash.inkatlas");
    eddiesIcon.SetTexturePart(n"cash_symbol_normal");
    eddiesIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    eddiesIcon.BindProperty(n"tintColor", n"MainColors.Yellow");
    eddiesIcon.SetSize(Vector2(58.0, 35.0));
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
    cartMoneyHeader.SetMargin(inkMargin(0.0, 20.0, 0.0, 0.0));

    let cartMoneyValues: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    cartMoneyValues.SetName(n"cartMoneyValues");
    cartMoneyValues.SetAnchor(inkEAnchor.CenterRight);
    cartMoneyValues.SetHAlign(inkEHorizontalAlign.Right);
    cartMoneyValues.SetFitToContent(true);
    cartMoneyValues.SetChildOrder(inkEChildOrder.Backward);

    let cartEddiesAmount: ref<inkText> = new inkText();
    cartEddiesAmount.SetName(n"cartEddiesAmount");
    cartEddiesAmount.SetAnchor(inkEAnchor.CenterRight);
    cartEddiesAmount.SetAnchorPoint(Vector2(0.5, 0.5));
    cartEddiesAmount.SetHAlign(inkEHorizontalAlign.Right);
    cartEddiesAmount.SetText("0");
    cartEddiesAmount.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    cartEddiesAmount.SetFontSize(50);
    cartEddiesAmount.SetFontStyle(n"Medium");
    cartEddiesAmount.SetFitToContent(true);
    cartEddiesAmount.SetLetterCase(textLetterCase.UpperCase);
    cartEddiesAmount.SetMargin(inkMargin(20.0, 0.0, 0.0, 0.0));
    cartEddiesAmount.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    cartEddiesAmount.BindProperty(n"tintColor", n"MainColors.PanelRed");
    cartEddiesAmount.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
    cartEddiesAmount.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
    this.cartMoney = cartEddiesAmount;

    if !this.IsInstantBuyEnabled() {
      cartMoneyHeader.Reparent(balancesContainer);
      cartMoneyValues.Reparent(balancesContainer);
      cartEddiesAmount.Reparent(cartMoneyValues);
    };

    let cartEddiesIcon: ref<inkImage> = new inkImage();
    cartEddiesIcon.SetName(n"cartEddiesIcon");
    cartEddiesIcon.SetAnchor(inkEAnchor.Centered);
    cartEddiesIcon.SetAnchorPoint(Vector2(0.5, 0.5));
    cartEddiesIcon.SetHAlign(inkEHorizontalAlign.Right);
    cartEddiesIcon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\atlas_cash.inkatlas");
    cartEddiesIcon.SetTexturePart(n"cash_symbol_normal");
    cartEddiesIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    cartEddiesIcon.BindProperty(n"tintColor", n"MainColors.Yellow");
    cartEddiesIcon.SetSize(Vector2(58.0, 35.0));
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
    this.RegisterToGlobalInputCallback(n"OnPostOnHold", this, n"OnHandleGlobalHold");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnHandleGlobalRelease");
  }

  private final func SetupDropdown() -> Void {
    let controller: ref<DropdownListController>;
    let data: ref<DropdownItemData>;
    let sorting: Int32;
    let vendorSortingButtonController: ref<DropdownButtonController>;
    this.vendorSortingButton.RegisterToCallback(n"OnRelease", this, n"OnVendorSortingButtonClicked");
    controller = this.sortingDropdown.GetController() as DropdownListController;
    vendorSortingButtonController = this.vendorSortingButton.GetController() as DropdownButtonController;
    let options: array<ref<DropdownItemData>> = SortingDropdownData.GetDefaultDropdownOptions();
    controller.Setup(this, options);
    sorting = this.uiScriptableSystem.GetVendorPanelVendorActiveSorting(EnumInt(ItemSortMode.Default));
    let options: array<ref<DropdownItemData>> = controller.GetData();
    data = SortingDropdownData.GetDropdownOption(options, IntEnum<ItemSortMode>(sorting));
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
    // Get player items
    let playerItems: ref<inkHashMap>;
    let values: array<wref<IScriptable>>;
    let itemsData: array<wref<gameItemData>>;
    let uiInventoryItem: ref<UIInventoryItem>;
    let data: ref<gameItemData>;
    this.uiInventorySystem.FlushTempData();
    playerItems = this.uiInventorySystem.GetPlayerItemsMap();
    playerItems.GetValues(values);
    for value in values {
      uiInventoryItem = value as UIInventoryItem;
      if IsDefined(uiInventoryItem) {
        data = uiInventoryItem.GetRealItemData();
        ArrayPush(itemsData, data);
      };
    }

    this.cartManager.SaveOwnedItems(itemsData);

    // Get wardrobe items
    let wardrobeItemIDs: array<ItemID> = GameInstance.GetWardrobeSystem(this.player.GetGame()).GetStoredItemIDs();
    this.cartManager.AppendWardrobeItems(wardrobeItemIDs);

    let storeItems: array<String> = this.GetVirtualStoreItems();
    let itemsPrices: array<Int32> = this.GetVirtualStorePrices();
    let itemsQualities: array<CName> = this.GetVirtualStoreQualities();
    let itemsQuantities: array<Int32> = this.GetVirtualStoreQuantities();
    let vendorObject: ref<GameObject> = this.vendorDataManager.GetVendorInstance(); 
    let totalPrice: Float = 0.0;
    let wardrobeItemAppearances: array<CName> = this.GetWardrobeAppearances(wardrobeItemIDs);

    let stockItem: ref<VirtualStockItem>;
    let virtualItemIndex = 0;
    ArrayClear(this.virtualStock);
    while virtualItemIndex < ArraySize(storeItems) {
      let itemTDBID: TweakDBID = TDBID.Create(storeItems[virtualItemIndex]);
      let itemId: ItemID = ItemID.FromTDBID(itemTDBID);
      let itemRecord: ref<Item_Record>;
      if ItemID.IsValid(itemId) {
        AtelierDebug(s"Store item: \(ToString(storeItems[virtualItemIndex]))");
        itemRecord = TweakDBInterface.GetItemRecord(itemTDBID);
        if !IsDefined(itemRecord) {
          AtelierDebug(s"Store item skipped, Item_Record not found: \(ToString(storeItems[virtualItemIndex]))");
        } else {
        stockItem = new VirtualStockItem();
        stockItem.itemID = itemId;
        stockItem.itemTDBID = itemTDBID;
        stockItem.price = Cast<Float>(itemsPrices[virtualItemIndex]);
        if (RoundF(stockItem.price) == 0) {
          stockItem.price = Cast<Float>(RPGManager.CalculateBuyPrice(this.player.GetGame(), vendorObject, itemId, 1.0) * itemsQuantities[virtualItemIndex]);
        };
        stockItem.weight = 0.1;
        stockItem.quality = itemsQualities[virtualItemIndex];
        stockItem.quantity = itemsQuantities[virtualItemIndex];
        stockItem.name = LocKeyToString(itemRecord.DisplayName());
        stockItem.searchName = UTF8StrLower(GetLocalizedText(stockItem.name));
        stockItem.equipmentArea = itemRecord.EquipArea().Type();
        stockItem.itemType = itemRecord.ItemType().Type();
        stockItem.itemCategory = itemRecord.ItemCategory().Type();
        stockItem.isClothing = UIInventoryItemsManager.IsItemTypeCloting(stockItem.itemType) || itemRecord.TagsContains(n"Clothing");
        stockItem.isRangedWeapon = itemRecord.TagsContains(n"RangedWeapon");
        stockItem.isMeleeWeapon = itemRecord.TagsContains(n"MeleeWeapon");
        stockItem.isCyberware = UIInventoryItemsManager.IsItemTypeCyberware(stockItem.itemType) || itemRecord.TagsContains(n"Cyberware") || itemRecord.TagsContains(n"Fragment");
        stockItem.isConsumable = itemRecord.TagsContains(n"Consumable");
        stockItem.isGrenade = itemRecord.TagsContains(n"Grenade");
        stockItem.isAttachment = itemRecord.TagsContains(n"itemPart") && !itemRecord.TagsContains(n"Fragment") && !itemRecord.TagsContains(n"SoftwareShard");
        stockItem.isProgram = itemRecord.TagsContains(n"SoftwareShard") || itemRecord.TagsContains(n"QuickhackCraftingPart");
        stockItem.isQuest = itemRecord.TagsContains(n"Quest");
        stockItem.isJunk = itemRecord.TagsContains(n"Junk");
        stockItem.isDLCAdded = itemRecord.TagsContains(n"DLCAdded");
        stockItem.isOwnable = stockItem.isClothing || stockItem.isRangedWeapon || stockItem.isMeleeWeapon || stockItem.isCyberware;
        stockItem.notInWardrobe = stockItem.isClothing && !ArrayContains(wardrobeItemAppearances, itemRecord.AppearanceName());
        stockItem.qualityRank = this.GetQualityRank(stockItem.quality);
        stockItem.itemTypeRank = EnumInt(stockItem.equipmentArea) * 10000 + EnumInt(stockItem.itemType);
        AtelierDebug(s"   VirtPrice: \(ToString(stockItem.price))");
        ArrayPush(this.virtualStock, stockItem);
        totalPrice += stockItem.price;
        };
      };
      virtualItemIndex += 1;
    };

    this.totalItemsPrice = Cast<Int32>(totalPrice);
    this.BuildFilterList();
    this.SortVirtualStock();
  }

  private final func ConvertStockIntoInventoryData(data: array<ref<VirtualStockItem>>, owner: wref<GameObject>) -> array<InventoryItemData> {
    let gameItemData: ref<gameItemData>;
    let itemData: InventoryItemData;
    let itemDataArray: array<InventoryItemData>;
    let stockItem: ref<VirtualStockItem>;
    let inventoryManager: ref<InventoryManager> = GameInstance.GetInventoryManager(this.player.GetGame());
    let itemRecord: wref<Item_Record>;
    let i: Int32 = 0;
    ArrayClear(this.currentPageItemData);
    while i < ArraySize(data) {
      stockItem = data[i];
      gameItemData = inventoryManager.CreateBasicItemData(stockItem.itemID, this.player);
      gameItemData.isVirtualItem = true;
      gameItemData.hasOwned = this.cartManager.IsItemOwned(stockItem.itemTDBID);
      itemRecord = TweakDBInterface.GetItemRecord(stockItem.itemTDBID);
      if IsDefined(itemRecord) && !itemRecord.IsSingleInstance() {
        AtelierItemsHelper.ScaleItem(this.player, gameItemData, stockItem.quality);
      };
      itemData = this.inventoryManager.GetInventoryItemData(owner, gameItemData);
      InventoryItemData.SetIsVendorItem(itemData, true);
      InventoryItemData.SetPrice(itemData, stockItem.price);
      InventoryItemData.SetBuyPrice(itemData, stockItem.price);
      InventoryItemData.SetQuantity(itemData, stockItem.quantity);
      InventoryItemData.SetQuality(itemData, stockItem.quality);
      ArrayPush(this.currentPageItemData, gameItemData);
      ArrayPush(itemDataArray, itemData);
      i += 1;
    };
    return itemDataArray;
  }

  private final func MaterializeStockItem(stockItem: ref<VirtualStockItem>, owner: wref<GameObject>) -> ref<VendorInventoryItemData> {
    let gameItemData: ref<gameItemData>;
    let itemData: InventoryItemData;
    let itemRecord: wref<Item_Record>;
    let inventoryManager: ref<InventoryManager> = GameInstance.GetInventoryManager(this.player.GetGame());

    gameItemData = inventoryManager.CreateBasicItemData(stockItem.itemID, this.player);
    gameItemData.isVirtualItem = true;
    gameItemData.hasOwned = this.cartManager.IsItemOwned(stockItem.itemTDBID);
    itemRecord = TweakDBInterface.GetItemRecord(stockItem.itemTDBID);
    if IsDefined(itemRecord) && !itemRecord.IsSingleInstance() {
      AtelierItemsHelper.ScaleItem(this.player, gameItemData, stockItem.quality);
    };
    itemData = this.inventoryManager.GetInventoryItemData(owner, gameItemData);
    InventoryItemData.SetIsVendorItem(itemData, true);
    InventoryItemData.SetPrice(itemData, stockItem.price);
    InventoryItemData.SetBuyPrice(itemData, stockItem.price);
    InventoryItemData.SetQuantity(itemData, stockItem.quantity);
    InventoryItemData.SetQuality(itemData, stockItem.quality);
    ArrayPush(this.currentPageItemData, gameItemData);

    return this.WrapVendorInventoryData(itemData, stockItem);
  }

  private final func GetWardrobeAppearances(wardrobeItemIDs: array<ItemID>) -> array<CName> {
    let result: array<CName>;
    let itemRecord: wref<Item_Record>;
    let i: Int32 = 0;
    while i < ArraySize(wardrobeItemIDs) {
      itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(wardrobeItemIDs[i]));
      if IsDefined(itemRecord) {
        ArrayPush(result, itemRecord.AppearanceName());
      };
      i += 1;
    };
    return result;
  }

  private final func BuildFilterList() -> Void {
    let i: Int32 = 0;
    let stockItem: ref<VirtualStockItem>;
    this.filterManager.Clear(true);
    this.filterManager.AddFilter(ItemFilterCategory.AllItems);
    while i < ArraySize(this.virtualStock) {
      stockItem = this.virtualStock[i];
      if stockItem.isRangedWeapon {
        this.filterManager.AddFilter(ItemFilterCategory.RangedWeapons);
      };
      if stockItem.isMeleeWeapon {
        this.filterManager.AddFilter(ItemFilterCategory.MeleeWeapons);
      };
      if stockItem.isClothing {
        this.filterManager.AddFilter(ItemFilterCategory.Clothes);
      };
      if stockItem.isConsumable {
        this.filterManager.AddFilter(ItemFilterCategory.Consumables);
      };
      if stockItem.isGrenade {
        this.filterManager.AddFilter(ItemFilterCategory.Grenades);
      };
      if stockItem.isAttachment {
        this.filterManager.AddFilter(ItemFilterCategory.Attachments);
      };
      if stockItem.isProgram {
        this.filterManager.AddFilter(ItemFilterCategory.Programs);
      };
      if stockItem.isCyberware {
        this.filterManager.AddFilter(ItemFilterCategory.Cyberware);
      };
      if stockItem.isJunk {
        this.filterManager.AddFilter(ItemFilterCategory.Junk);
      };
      if stockItem.isQuest {
        this.filterManager.AddFilter(ItemFilterCategory.Quest);
      };
      if stockItem.notInWardrobe {
        this.filterManager.AddFilter(ItemFilterCategory.NewWardrobeAppearances);
      };
      i += 1;
    };
    this.filterManager.SortFiltersList();
    this.filterManager.InsertFilter(0, ItemFilterCategory.AllItems);
  }

  private final func ApplyStockView(resetPage: Bool) -> Void {
    let i: Int32 = 0;
    let query: String = "";
    if IsDefined(this.searchInput) {
      query = UTF8StrLower(this.searchInput.GetText());
    };
    ArrayClear(this.filteredStock);
    while i < ArraySize(this.virtualStock) {
      if this.FilterStockItem(this.virtualStock[i], this.lastVendorFilter, query) {
        ArrayPush(this.filteredStock, this.virtualStock[i]);
      };
      i += 1;
    };
    this.UpdatePageSize();
    this.totalPages = (ArraySize(this.filteredStock) + this.pageSize - 1) / this.pageSize;
    if this.totalPages < 1 {
      this.totalPages = 1;
    };
    if resetPage {
      this.currentPage = 0;
    };
    if this.currentPage >= this.totalPages {
      this.currentPage = this.totalPages - 1;
    };
    this.RenderCurrentPage();
  }

  private final func UpdatePageSize() -> Void {
    if IsDefined(this.config) && this.config.enableStorePagination {
      this.pageSize = this.config.paginationPageSize;
    } else {
      this.pageSize = ArraySize(this.filteredStock);
    };
    if this.pageSize < 1 {
      this.pageSize = 1;
    };
  }

  private final func FilterStockItem(stockItem: ref<VirtualStockItem>, filter: ItemFilterCategory, query: String) -> Bool {
    if NotEquals(query, "") && !StrContains(stockItem.searchName, query) {
      return false;
    };
    switch filter {
      case ItemFilterCategory.RangedWeapons:
        return stockItem.isRangedWeapon;
      case ItemFilterCategory.MeleeWeapons:
        return stockItem.isMeleeWeapon;
      case ItemFilterCategory.Clothes:
        return stockItem.isClothing;
      case ItemFilterCategory.Consumables:
        return stockItem.isConsumable;
      case ItemFilterCategory.Grenades:
        return stockItem.isGrenade;
      case ItemFilterCategory.Attachments:
        return stockItem.isAttachment;
      case ItemFilterCategory.Programs:
        return stockItem.isProgram;
      case ItemFilterCategory.Cyberware:
        return stockItem.isCyberware;
      case ItemFilterCategory.Junk:
        return stockItem.isJunk;
      case ItemFilterCategory.Quest:
        return stockItem.isQuest;
      case ItemFilterCategory.NewWardrobeAppearances:
        return stockItem.notInWardrobe;
      case ItemFilterCategory.AllItems:
        return true;
    };
    return true;
  }

  private final func SortVirtualStock() -> Void {
    if ArraySize(this.virtualStock) > 1 {
      this.QuickSortVirtualStock(0, ArraySize(this.virtualStock) - 1);
    };
  }

  private final func QuickSortVirtualStock(leftIndex: Int32, rightIndex: Int32) -> Void {
    let i: Int32 = leftIndex;
    let j: Int32 = rightIndex;
    let pivot: ref<VirtualStockItem> = this.virtualStock[(leftIndex + rightIndex) / 2];
    let temp: ref<VirtualStockItem>;

    while i <= j {
      while this.IsStockLess(this.virtualStock[i], pivot) {
        i += 1;
      };
      while this.IsStockLess(pivot, this.virtualStock[j]) {
        j -= 1;
      };
      if i <= j {
        temp = this.virtualStock[i];
        this.virtualStock[i] = this.virtualStock[j];
        this.virtualStock[j] = temp;
        i += 1;
        j -= 1;
      };
    };

    if leftIndex < j {
      this.QuickSortVirtualStock(leftIndex, j);
    };
    if i < rightIndex {
      this.QuickSortVirtualStock(i, rightIndex);
    };
  }

  private final func IsStockLess(left: ref<VirtualStockItem>, right: ref<VirtualStockItem>) -> Bool {
    switch this.storeDataView.GetSortMode() {
      case ItemSortMode.NameAsc:
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.NameDesc:
        return StrCmp(left.searchName, right.searchName) > 0;
      case ItemSortMode.QualityAsc:
        if NotEquals(left.qualityRank, right.qualityRank) {
          return left.qualityRank < right.qualityRank;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.QualityDesc:
        if NotEquals(left.qualityRank, right.qualityRank) {
          return left.qualityRank > right.qualityRank;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.WeightAsc:
        if NotEquals(left.weight, right.weight) {
          return left.weight < right.weight;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.WeightDesc:
        if NotEquals(left.weight, right.weight) {
          return left.weight > right.weight;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.PriceAsc:
        if NotEquals(left.price, right.price) {
          return left.price < right.price;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.PriceDesc:
        if NotEquals(left.price, right.price) {
          return left.price > right.price;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
      case ItemSortMode.ItemType:
        if NotEquals(left.itemTypeRank, right.itemTypeRank) {
          return left.itemTypeRank < right.itemTypeRank;
        };
        return StrCmp(left.searchName, right.searchName) < 0;
    };
    if NotEquals(left.qualityRank, right.qualityRank) {
      return left.qualityRank > right.qualityRank;
    };
    if NotEquals(left.itemTypeRank, right.itemTypeRank) {
      return left.itemTypeRank < right.itemTypeRank;
    };
    return StrCmp(left.searchName, right.searchName) < 0;
  }

  private final func RenderCurrentPage() -> Void {
    let items: array<ref<IScriptable>>;
    let startIndex: Int32 = this.currentPage * this.pageSize;
    let endIndex: Int32 = startIndex + this.pageSize;
    let i: Int32 = startIndex;

    this.pageRenderToken += 1;
    this.pendingPageIndex = 0;
    ArrayClear(this.pendingPageStock);
    ArrayClear(this.pendingPageItems);
    this.storeDataSource.Reset(items);
    ArrayClear(this.currentPageItemData);
    this.RefreshPaginationControls();
    this.scrollController.SetScrollPosition(0.0);

    while i < endIndex && i < ArraySize(this.filteredStock) {
      ArrayPush(this.pendingPageStock, this.filteredStock[i]);
      i += 1;
    };

    this.RefreshCartControls();

    if ArraySize(this.pendingPageStock) > 0 {
      this.SchedulePageRenderBatch(this.pageRenderToken);
    };
  }

  private final func SchedulePageRenderBatch(token: Int32) -> Void {
    if this.isUninitializing || !IsDefined(this.player) {
      return;
    };
    GameInstance.GetDelaySystem(this.player.GetGame()).DelayCallback(VirtualStorePageRenderCallback.Create(this, token), 0.01, false);
  }

  public final func ContinuePageRender(token: Int32) -> Void {
    let owner: wref<GameObject>;
    let processed: Int32 = 0;
    let item: ref<VendorInventoryItemData>;
    let isFirstBatch: Bool;

    if this.isUninitializing || NotEquals(token, this.pageRenderToken) || !IsDefined(this.storeDataSource) || !IsDefined(this.vendorDataManager) || !IsDefined(this.cartManager) || !IsDefined(this.player) {
      return;
    };

    isFirstBatch = this.pendingPageIndex == 0;
    owner = this.vendorDataManager.GetVendorInstance();
    while this.pendingPageIndex < ArraySize(this.pendingPageStock) && processed < this.pageBatchSize {
      item = this.MaterializeStockItem(this.pendingPageStock[this.pendingPageIndex], owner);
      if IsDefined(item) {
        ArrayPush(this.pendingPageItems, item);
      };
      this.pendingPageIndex += 1;
      processed += 1;
    };
    if (this.config.enableStorePagination && isFirstBatch) || this.pendingPageIndex >= ArraySize(this.pendingPageStock) {
      this.storeDataSource.Reset(this.pendingPageItems);
    };

    if this.pendingPageIndex < ArraySize(this.pendingPageStock) {
      this.SchedulePageRenderBatch(token);
    };
  }

  private final func WrapVendorInventoryData(itemData: InventoryItemData, stockItem: ref<VirtualStockItem>) -> ref<VendorInventoryItemData> {
    let requirements: array<SItemStackRequirementData>;
    let data: ref<VendorInventoryItemData> = new VendorInventoryItemData();
    data.ItemData = itemData;
    if stockItem.isCyberware {
      requirements = RPGManager.GetEquipRequirements(this.player, InventoryItemData.GetGameItemData(data.ItemData));
      InventoryItemData.SetEquipRequirements(data.ItemData, requirements);
    };
    InventoryItemData.SetIsEquippable(data.ItemData, EquipmentSystem.GetInstance(this.player).GetPlayerData(this.player).IsEquippable(InventoryItemData.GetGameItemData(data.ItemData)));
    data.IsVendorItem = true;
    data.IsEnoughMoney = this.vendorDataManager.GetLocalPlayerCurrencyAmount() >= Cast<Int32>(InventoryItemData.GetBuyPrice(itemData));
    data.IsDLCAddedActiveItem = stockItem.isDLCAdded && this.uiScriptableSystem.IsDLCAddedActiveItem(stockItem.itemTDBID);
    data.NotInWardrobe = stockItem.notInWardrobe;
    this.inventoryManager.GetOrCreateInventoryItemSortData(data.ItemData, this.uiScriptableSystem);
    return data;
  }

  private final func RefreshPaginationControls() -> Void {
    let hasMultiplePages: Bool = this.totalPages > 1;
    if IsDefined(this.pageLabel) {
      this.pageLabel.SetText(s"\(this.currentPage + 1) / \(this.totalPages)");
      this.pageLabel.SetVisible(hasMultiplePages);
    };
    if IsDefined(this.pagePrevButton) {
      this.pagePrevButton.Dim(this.currentPage <= 0);
      this.pagePrevButton.SetEnabled(this.currentPage > 0);
      this.pagePrevButton.GetRootWidget().SetVisible(hasMultiplePages);
    };
    if IsDefined(this.pageNextButton) {
      this.pageNextButton.Dim(this.currentPage >= this.totalPages - 1);
      this.pageNextButton.SetEnabled(this.currentPage < this.totalPages - 1);
      this.pageNextButton.GetRootWidget().SetVisible(hasMultiplePages);
    };
  }

  private final func ShowPreviousPage() -> Void {
    if this.currentPage > 0 {
      this.currentPage -= 1;
      this.RenderCurrentPage();
    };
  }

  private final func ShowNextPage() -> Void {
    if this.currentPage < this.totalPages - 1 {
      this.currentPage += 1;
      this.RenderCurrentPage();
    };
  }

  private final func GetQualityRank(quality: CName) -> Int32 {
    if Equals(quality, n"Common") {
      return 1;
    };
    if Equals(quality, n"Uncommon") {
      return 2;
    };
    if Equals(quality, n"Rare") {
      return 3;
    };
    if Equals(quality, n"Epic") {
      return 4;
    };
    if Equals(quality, n"Legendary") {
      return 5;
    };
    if Equals(quality, n"Iconic") {
      return 6;
    };
    return 0;
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
      let qualityCName: CName = StringToName(qualities[0]);
      if IsNameValid(qualityCName) && !Equals(qualityCName, n"") {
        defaultQuality = qualityCName;
      };
    };

    let i: Int32 = 0;

    while (i < ArraySize(items)) {
      let itemQuality: String = "";
      if i < ArraySize(qualities) {
        itemQuality = qualities[i];
      };

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
    this.FillVirtualStock();
    this.SetFilters(this.filtersContainer, this.filterManager.GetIntFiltersList(), n"OnVendorFilterChange");
    this.ApplyStockView(true);
    this.ToggleFilter(this.filtersContainer, EnumInt(this.lastVendorFilter));
    this.filtersContainer.SetVisible(ArraySize(this.virtualStock) > 0);
    this.PlayLibraryAnimation(n"vendor_grid_show");

    this.cartManager.StoreVirtualStock(this.virtualStock);
  }

  private final func HandleCartAction() -> Void {
    if !IsDefined(this.lastItemHoverOverEvent) {
      return ;
    };

    let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.player);
    let itemID: ItemID = InventoryItemData.GetID(this.lastItemHoverOverEvent.itemData);
    let quantity: Int32 = InventoryItemData.GetQuantity(this.lastItemHoverOverEvent.itemData);
    let isAddedToCart: Bool = this.cartManager.IsAddedToCart(itemID, quantity);
    let isEnoughMoney: Bool = this.cartManager.PlayerHasEnoughMoneyFor(itemID);
    let hintLabel: String;

    if !isEnoughMoney && !isAddedToCart {
      return ;
    };

    let stockItem: ref<VirtualStockItem> = this.GetStockItem(itemID, quantity);
    if isAddedToCart {
      if this.cartManager.RemoveFromCart(stockItem) {
        hintLabel = GetLocalizedTextByKey(n"VA-Cart-Add");
      };
    } else {
      if this.cartManager.AddToCart(stockItem, 1) {
        hintLabel = GetLocalizedTextByKey(n"VA-Cart-Remove");
      };
    };

    this.buttonHintsController.RemoveButtonHint(atelierActions.addToVirtualCart);
    this.buttonHintsController.AddButtonHint(atelierActions.addToVirtualCart, hintLabel);
    this.tooltipsManager.HideTooltips();
    this.RefreshCartControls();
    this.RefreshMoneyLabels();
    this.RefreshVirtualItemState();
  }

  private final func OpenCartQuantityPopup() -> Void {
    if !IsDefined(this.lastItemHoverOverEvent) {
      return ;
    };

    let itemID: ItemID = InventoryItemData.GetID(this.lastItemHoverOverEvent.itemData);
    let quantity: Int32 = InventoryItemData.GetQuantity(this.lastItemHoverOverEvent.itemData);
    let availableForPurchase: Int32 = this.cartManager.GetBuyableAmount(itemID, quantity);

    if availableForPurchase < 1 {
      return ;
    };

    this.uiSystem.QueueEvent(VirtualStorePickerActiveEvent.Create(true));
    this.tooltipsManager.HideTooltips();

    let data: ref<QuantityPickerPopupData> = new QuantityPickerPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\item_quantity_picker.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.maxValue = availableForPurchase;
    data.gameItemData = this.lastItemHoverOverEvent.itemData;
    data.actionType = QuantityPickerActionType.Buy;
    data.vendor = this.player;
    data.virtualItemPrice = Cast<Int32>(InventoryItemData.GetPrice(this.lastItemHoverOverEvent.itemData));
    this.popupToken = this.ShowGameNotification(data);
    this.popupToken.RegisterListener(this, n"OnQuantityPickerPopupClosed");
    this.buttonHintsController.Hide();
  }

protected cb func OnQuantityPickerPopupClosed(data: ref<inkGameNotificationData>) -> Bool {
    let quantityData: ref<QuantityPickerPopupCloseData> = data as QuantityPickerPopupCloseData;
    let itemID: ItemID = InventoryItemData.GetID(quantityData.itemData);
    let quantity: Int32 = InventoryItemData.GetQuantity(quantityData.itemData);
    let stockItem: ref<VirtualStockItem> = this.GetStockItem(itemID, quantity);
    if quantityData.choosenQuantity != -1 {
      this.cartManager.AddToCart(stockItem, quantityData.choosenQuantity);
    };

    this.popupToken = null;
    this.buttonHintsController.Show();
    this.PlaySound(n"Button", n"OnPress");
    this.uiSystem.QueueEvent(VirtualStorePickerActiveEvent.Create(false));

    this.RefreshCartControls();
    this.RefreshMoneyLabels();
    this.RefreshVirtualItemState();
  }

  private final func RefreshVirtualItemState() -> Void {
    this.uiSystem.QueueEvent(VirtualItemStateRefreshEvent.Create());
  }

  private func RefreshCartControls() -> Void {
    if this.IsInstantBuyEnabled() {
      return ;
    };

    let playerMoney: Int32 = this.cartManager.GetCurrentPlayerMoney();
    let cartSize: Int32 = this.cartManager.GetCartSize();
    this.cartIcon.SetCounter(cartSize);

    let cartIsNotEmpty: Bool = cartSize > 0;
    this.cartIcon.Dim(!cartIsNotEmpty);
    this.cartIcon.SetEnabled(cartIsNotEmpty);
    this.cartButtonClear.Dim(!cartIsNotEmpty);
    this.cartButtonClear.SetEnabled(cartIsNotEmpty);

    let enoughMoneyForBuyAll: Bool = playerMoney >= this.cartManager.GetCurrentGoodsPrice() + this.GetCurrentPageGoodsPriceToAdd();
    let addAllButtonEnabled: Bool = ArraySize(this.pendingPageStock) > 0 && enoughMoneyForBuyAll && !this.AreCurrentPageGoodsAdded();
    this.cartButtonAddAll.Dim(!addAllButtonEnabled);
    this.cartButtonAddAll.SetEnabled(addAllButtonEnabled);
  }

  private final func GetCurrentPageGoodsPriceToAdd() -> Int32 {
    let total: Float = 0.0;
    for stockItem in this.pendingPageStock {
      if !this.cartManager.IsAddedToCart(stockItem.itemID, stockItem.quantity) {
        total += stockItem.price;
      };
    };
    return Cast<Int32>(total);
  }

  private final func AreCurrentPageGoodsAdded() -> Bool {
    if ArraySize(this.pendingPageStock) < 1 {
      return false;
    };

    for stockItem in this.pendingPageStock {
      if !this.cartManager.IsAddedToCart(stockItem.itemID, stockItem.quantity) {
        return false;
      };
    };

    return true;
  }

  private func RefreshMoneyLabels() -> Void {
    let playerAmount: Int32 = this.cartManager.GetCurrentPlayerMoney();
    let cartAmount: Int32 = this.cartManager.GetCurrentGoodsPrice();
    this.playerMoney.SetText(GetFormattedMoneyVA(playerAmount));
    this.cartMoney.SetText(GetFormattedMoneyVA(cartAmount));
  }

  private func ShowAddAllConfirmationPopup() -> Void {
    this.popupToken = GenericMessageNotification.Show(this, this.virtualStore.storeName, AtelierTexts.ConfirmationAddAll(), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnAddAllConfirmationPopupClosed");
  }

  private func ShowRemoveAllConfirmationPopup() -> Void {
    this.popupToken = GenericMessageNotification.Show(this, this.virtualStore.storeName, AtelierTexts.ConfirmationRemoveAll(), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnRemoveAllConfirmationPopupClosed");
  }

  private func ShowPurchaseAllConfirmationPopup() -> Void {
    let price: Int32 = this.cartManager.GetCurrentGoodsPrice();
    let priceStr: String = GetFormattedMoneyVA(price);
    this.popupToken = GenericMessageNotification.Show(this, this.virtualStore.storeName, AtelierTexts.ConfirmationPurchase(priceStr), GenericMessageNotificationType.ConfirmCancel);
    this.popupToken.RegisterListener(this, n"OnPurchaseConfirmationPopupClosed");
  }

  protected cb func OnAddAllConfirmationPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
      for stockItem in this.pendingPageStock {
        if !this.cartManager.IsAddedToCart(stockItem.itemID, stockItem.quantity) {
          this.cartManager.AddToCart(stockItem, 1);
        };
      };
      this.allItemsAdded = true;
      this.RefreshCartControls();
      this.RefreshMoneyLabels();
      this.RefreshVirtualItemState();
      this.PlaySound(n"Item", n"OnDisassemble");
    };

    this.popupToken = null;
  }

  protected cb func OnRemoveAllConfirmationPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
      this.cartManager.ClearCart();
      this.allItemsAdded = false;
      this.RefreshCartControls();
      this.RefreshMoneyLabels();
      this.RefreshVirtualItemState();
      this.PlaySound(n"Item", n"OnDisassemble");
    };

    this.popupToken = null;
  }

  protected cb func OnPurchaseConfirmationPopupClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
      this.cartManager.PurchaseGoods(this.cartManager.GetCurrentGoods());
      this.allItemsAdded = false;
      this.RefreshCartControls();
      this.RefreshMoneyLabels();
      this.RefreshVirtualItemState();
      this.PlaySound(n"Item", n"OnBuy");
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
    TimeDilationHelper.SetTimeDilationWithProfile(this.player, "radialMenu", enable, false);
  }

  private final func GetStockItem(itemID: ItemID, quantity: Int32) -> ref<VirtualStockItem> {
    for stockItem in this.virtualStock {
      if Equals(stockItem.itemID, itemID) && Equals(stockItem.quantity, quantity) {
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

  private func BuyItemFromVirtualVendor(inventoryItemData: InventoryItemData) {
    let itemID: ItemID = InventoryItemData.GetID(inventoryItemData);
    let price = InventoryItemData.GetPrice(inventoryItemData);
    let quantity: Int32 = InventoryItemData.GetQuantity(inventoryItemData);
    let stockItem: ref<VirtualStockItem> = this.GetStockItem(itemID, quantity);
    let itemData: ref<gameItemData>;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.player.GetGame());
    let inventoryManager: ref<InventoryManager> = GameInstance.GetInventoryManager(this.player.GetGame());
    let playerMoney: Int32 = this.vendorDataManager.GetLocalPlayerCurrencyAmount();
    let vendorNotification: ref<UIMenuNotificationEvent>;

    if playerMoney < Cast<Int32>(price) {
      vendorNotification = new UIMenuNotificationEvent();
      vendorNotification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
      GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(vendorNotification);
    } else {
      if IsDefined(stockItem) {
        itemID = ItemID.FromTDBID(stockItem.itemTDBID);
        itemData = inventoryManager.CreateBasicItemData(itemID, this.player);
        itemData.isVirtualItem = true;
        AtelierItemsHelper.ScaleItem(this.player, itemData, stockItem.quality);
      };
      transactionSystem.GiveItem(this.player, itemID, quantity);
      transactionSystem.RemoveItemByTDBID(this.player, t"Items.money", Cast(price));
      if IsDefined(stockItem) {
        this.cartManager.SaveOwnedItem(stockItem);
      };
      this.cartManager.SyncCurrentBalances();
      this.RefreshMoneyLabels();
      this.RefreshVirtualItemState();
      this.PlaySound(n"Item", n"OnBuy");
    };
  }

  private final func HasClothingCategory(data: InventoryItemData) -> Bool {
    let item: ItemID = InventoryItemData.GetID(data);
    return EquipmentSystem.IsItemOfCategory(item, gamedataItemCategory.Clothing);
  }
}

