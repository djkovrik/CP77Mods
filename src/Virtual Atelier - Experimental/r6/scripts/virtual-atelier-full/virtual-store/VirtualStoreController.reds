module VirtualAtelier.UI
import VirtualAtelier.Config.VirtualAtelierConfig
import VirtualAtelier.Logs.AtelierDebug
import VirtualAtelier.Helpers.*
import VirtualAtelier.Systems.*
import Codeware.UI.*

public class VirtualStoreController extends gameuiMenuGameController {
  private let player: wref<PlayerPuppet>;
  private let previewManager: wref<VirtualAtelierPreviewManager>;
  private let storesManager: wref<VirtualAtelierStoresSystem>;
  private let questsSystem: wref<QuestsSystem>;
  private let uiScriptableSystem: wref<UIScriptableSystem>;
  private let previewPopupToken: ref<inkGameNotificationToken>;
  private let vendorDataManager: ref<VendorDataManager>;
  private let inventoryManager: ref<InventoryDataManagerV2>;
  private let config: ref<VirtualAtelierConfig>;

  // inkwidget refs
  private let buttonHintsController: wref<ButtonHints>;
  private let tooltipsManager: wref<gameuiTooltipsManager>;
  private let scrollController: wref<inkScrollController>;
  private let filtersContainer: wref<inkWidget>;
  private let filterManager: wref<ItemCategoryFliterManager>;
  private let filtersRadioGroup: wref<FilterRadioGroup>;
  private let vendorName: wref<inkText>;
  private let vendorSortingButton: ref<inkWidget>;
  private let sortingDropdown: ref<inkWidget>;
  private let searchInput: wref<HubTextInput>;

  // Store data
  private let virtualStock: array<ref<VirtualStockItem>>;
  private let virtualStore: ref<VirtualShop>;
  private let storeListController: wref<inkVirtualGridController>;
  private let storeDataView: ref<VirtualStoreDataView>;
  private let storeDataSource: ref<ScriptableDataSource>;
  private let storeItemsClassifier: ref<VirtualStoreTemplateClassifier>;

  private let currentTutorialsFact: Int32;
  private let lastVendorFilter: ItemFilterCategory;
  private let totalItemsPrice: Float;

  protected cb func OnInitialize() -> Bool {
    this.player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.previewManager = VirtualAtelierPreviewManager.GetInstance(this.player.GetGame());
    this.previewManager.SetPreviewState(true);
    this.previewPopupToken = AtelierNotificationTokensHelper.GetGarmentPreviewNotificationToken(this, ItemDisplayContext.VendorPlayer) as inkGameNotificationToken;
    this.storesManager = VirtualAtelierStoresSystem.GetInstance(this.player.GetGame());
    this.virtualStore = this.storesManager.GetCurrentStore();
    this.questsSystem = GameInstance.GetQuestsSystem(this.player.GetGame());
    this.uiScriptableSystem = UIScriptableSystem.GetInstance(this.player.GetGame());
    this.vendorDataManager = new VendorDataManager();
    this.vendorDataManager.Initialize(this.player, this.player.GetEntityID());
    this.inventoryManager = new InventoryDataManagerV2();
    this.inventoryManager.Initialize(this.player);
    this.config = VirtualAtelierConfig.Get();

    this.currentTutorialsFact = this.questsSystem.GetFact(n"disable_tutorials");
    this.questsSystem.SetFact(n"disable_tutorials", 1);

    this.lastVendorFilter = ItemFilterCategory.AllItems;

    this.InitializeWidgetRefs();
    this.InitializeWidgetData();
    this.InitializeListeners();
    this.SetupDropdown();

    this.SetTimeDilatation(true);
    this.PlaySound(n"GameMenu", n"OnOpen");

    this.PopulateVirtualShop();
  }

  protected cb func OnUninitialize() -> Bool {
    this.previewManager.SetPreviewState(false);
    this.previewPopupToken.TriggerCallback(null);
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

  protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
    this.tooltipsManager.HideTooltips();
  }

  protected cb func OnHandleGlobalInput(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"mouse_left") {
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        this.RequestSetFocus(null);
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

  private func InitializeWidgetRefs() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
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
    this.filtersRadioGroup = this.filtersContainer.GetController() as FilterRadioGroup;
    this.vendorName = vendorHeader.GetWidget(n"vendorNameWrapper/value") as inkText;
    this.vendorSortingButton = root.GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/dropdownButton5");
    this.sortingDropdown = root.GetWidget(n"dropdownContainer");

    let searchContainer: ref<inkCanvas> = new inkCanvas();
    searchContainer = new inkCanvas();
    searchContainer.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    searchContainer.Reparent(vendorHeader);

    let searchInput: ref<HubTextInput> = HubTextInput.Create();
    searchInput.SetName(n"SearchTextInput");
    searchInput.SetLetterCase(textLetterCase.UpperCase);
    searchInput.SetMaxLength(30);
    searchInput.SetDefaultText(GetLocalizedText("LocKey#48662"));
    searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
    searchInput.Reparent(searchContainer);
    this.searchInput = searchInput;
  }

  private func InitializeWidgetData() -> Void {
    this.storeDataView = new VirtualStoreDataView();
    this.storeDataSource = new ScriptableDataSource();
    this.storeDataView.BindUIScriptableSystem(this.uiScriptableSystem);
    this.storeDataView.SetSource(this.storeDataSource);
    this.storeDataView.EnableSorting();
    this.storeDataView.SetVendorGrid(true);
    this.storeItemsClassifier = new VirtualStoreTemplateClassifier();
    this.storeListController.SetClassifier(this.storeItemsClassifier);
    this.storeListController.SetSource(this.storeDataView);

    this.vendorName.SetText(this.GetVirtualStoreName());
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

  private final func SetFilters(root: ref<inkWidget>, data: array<Int32>, callback: CName) -> Void {
    let radioGroup: ref<FilterRadioGroup> = root.GetControllerByType(n"FilterRadioGroup") as FilterRadioGroup;
    radioGroup.SetData(data);
    radioGroup.RegisterToCallback(n"OnValueChanged", this, callback);
    if ArraySize(data) == 1 {
      radioGroup.Toggle(data[0]);
    };
  }

  private final func ToggleFilter(root: ref<inkWidget>, data: Int32) -> Void {
    let radioGroup: ref<FilterRadioGroup> = root.GetControllerByType(n"FilterRadioGroup") as FilterRadioGroup;
    radioGroup.ToggleData(data);
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
  
  public final func SetTimeDilatation(enable: Bool) -> Void {
    TimeDilationHelper.SetTimeDilationWithProfile(this.player, "radialMenu", enable);
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

    this.totalItemsPrice = totalPrice;
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
    let playerMoney: Int32;
    let vendorInventory: array<InventoryItemData>;
    let vendorInventoryData: ref<VendorInventoryItemData>;
    let vendorInventorySize: Int32;
    this.filterManager.Clear();
    this.filterManager.AddFilter(ItemFilterCategory.AllItems);
    this.FillVirtualStock();
    vendorInventory = this.ConvertGameDataIntoInventoryData(this.virtualStock, this.vendorDataManager.GetVendorInstance());
    vendorInventorySize = ArraySize(vendorInventory);
    playerMoney = this.vendorDataManager.GetLocalPlayerCurrencyAmount();

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
      vendorInventoryData.IsEnoughMoney = playerMoney >= Cast<Int32>(InventoryItemData.GetBuyPrice(vendorInventory[i]));
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
  }
}
