import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager
import VendorPreview.Utils.AtelierUtils
import VendorPreview.Utils.AtelierDebug
import VendorPreview.Codeware.UI.*

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let parentContainer: ref<inkCompoundWidget>;
  let searchContainer: ref<inkCanvas>;
  if this.GetIsVirtual() {
    parentContainer = this.GetRootCompoundWidget().GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader") as inkCompoundWidget;
    searchContainer = new inkCanvas();
    searchContainer.SetMargin(new inkMargin(0.0, 8.0, 0.0, 32.0));
    searchContainer.Reparent(parentContainer);
    this.m_searchInput = HubTextInput.Create();
    this.m_searchInput.SetName(n"SearchTextInput");
    this.m_searchInput.SetLetterCase(textLetterCase.UpperCase);
    this.m_searchInput.SetMaxLength(30);
    this.m_searchInput.SetDefaultText(GetLocalizedText("LocKey#48662"));
    this.m_searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
    this.m_searchInput.Reparent(searchContainer);

    this.m_vendorItemsDataView.SetIsVirtual(true);
  };
}

@addMethod(VendorDataView)
public func SetIsVirtual(isVirtual: Bool) -> Void {
  this.m_isVirtual = isVirtual;
}

@addMethod(VendorDataView)
public func SetSearchQuery(query: String) -> Void {
  this.m_searchQuery = query;
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  if IsDefined(this.m_searchInput) {
    this.m_searchInput.SetText("");
  };
  this.m_vendorItemsDataView.SetSearchQuery("");
  return wrappedMethod(controller, selectedIndex);
}

@addMethod(FullscreenVendorGameController)
protected cb func OnSearchInput(widget: wref<inkWidget>) {
  this.m_vendorItemsDataView.SetSearchQuery(this.m_searchInput.GetText());
  this.m_vendorItemsDataView.Filter();
  this.m_vendorItemsDataView.EnableSorting();
  this.m_vendorItemsDataView.SetFilterType(this.m_lastVendorFilter);
  this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
  this.m_vendorItemsDataView.DisableSorting();
}

@wrapMethod(VendorDataView)
public func DerivedFilterItem(data: ref<IScriptable>) -> DerivedFilterResult {
  let wrapped: DerivedFilterResult = wrappedMethod(data);
  let data: ref<VendorInventoryItemData> = data as VendorInventoryItemData;
  let query: String = StrLower(this.m_searchQuery);

  if !IsDefined(data) || !this.m_isVirtual {
    return wrapped;
  };

  let itemName: String = StrLower(GetLocalizedText(InventoryItemData.GetName(data.ItemData)));

  if !StrContains(itemName, query) && NotEquals(query, "") {
    return DerivedFilterResult.False;
  };

  return wrapped;
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnHandleGlobalInput(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    };
  };
}

@addMethod(FullscreenVendorGameController)
private func BuyItemFromVirtualVendor(inventoryItemData: InventoryItemData) {
  let itemID: ItemID = InventoryItemData.GetID(inventoryItemData);
  let price = InventoryItemData.GetPrice(inventoryItemData);
  let quantity: Int32 = InventoryItemData.GetQuantity(inventoryItemData);
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_player.GetGame());
  let playerMoney: Int32 = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();
  let vendorNotification: ref<UIMenuNotificationEvent>;

  if playerMoney < Cast(price) {
    vendorNotification = new UIMenuNotificationEvent();
    vendorNotification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
    GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(vendorNotification);
  } else {
    transactionSystem.GiveItem(this.m_player, itemID, quantity);
    transactionSystem.RemoveItemByTDBID(this.m_player, t"Items.money", Cast(price));
    // Refresh stock to regenerate ItemIDs
    this.PopulateVendorInventory();
  };
}

@addMethod(FullscreenVendorGameController)
private func BuyAllItemsFromVirtualVendor() -> Void {
  if !this.BuyAllAvailable() {
    return ;
  };

  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_player.GetGame());
  let totalPrice: Int32 = Cast<Int32>(this.m_buyAllPrice);
  transactionSystem.RemoveItemByTDBID(this.m_player, t"Items.money", totalPrice);

  let item: ref<VirtualStockItem>;
  let i: Int32 = 0;
  while i < ArraySize(this.m_virtualStock) {
    item = this.m_virtualStock[i];
    transactionSystem.GiveItem(this.m_player, item.itemID, item.quantity);
    i += 1;
  };

  this.m_calledForBuyAll = true;
  AtelierButtonHintsHelper.UpdatePurchaseAllHint(this, this.BuyAllAvailable());

  // Refresh stock to regenerate ItemIDs
  this.PopulateVendorInventory();
}


@addMethod(FullscreenVendorGameController)
private final func ShowTooltipsForItemController(targetWidget: wref<inkWidget>, equippedItem: InventoryItemData, inspectedItemData: InventoryItemData, iconErrorInfo: ref<DEBUG_IconErrorInfo>, isBuybackStack: Bool) -> Void {
  let data: ref<InventoryTooltipData>;
  data = this.m_InventoryManager.GetTooltipDataForInventoryItem(inspectedItemData, InventoryItemData.IsEquipped(inspectedItemData), iconErrorInfo, InventoryItemData.IsVendorItem(inspectedItemData));
  data.displayContext = InventoryTooltipDisplayContext.Vendor;
  data.isVirtualItem = true;
  data.virtualInventoryItemData = inspectedItemData;
  this.m_TooltipsManager.ShowTooltipAtWidget(n"itemTooltip", targetWidget, data, gameuiETooltipPlacement.RightTop);
}


@wrapMethod(FullscreenVendorGameController)
protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  wrappedMethod(controller, selectedIndex);
  
  if this.GetIsVirtual() {
    this.PopulateVendorInventory();
  };
}


// POPULATE VIRTUAL STOCK & SCALE

@addMethod(FullscreenVendorGameController)
private final func FillVirtualStock() -> Void {
  let inventoryManager: ref<InventoryManager> = GameInstance.GetInventoryManager(this.m_player.GetGame());
  let storeItems: array<String> = this.GetVirtualStoreItems();
  let itemsPrices: array<Int32> = this.GetVirtualStorePrices();
  let itemsQualities: array<CName> = this.GetVirtualStoreQualities();
  let itemsQuantities: array<Int32> = this.GetVirtualStoreQuantities();
  let vendorObject: ref<GameObject> = this.m_VendorDataManager.GetVendorInstance(); 
  let totalPrice: Float = 0.0;

  let stockItem: ref<VirtualStockItem>;
  let virtualItemIndex = 0;
  ArrayClear(this.m_virtualStock);
  while virtualItemIndex < ArraySize(storeItems) {
    let itemTDBID: TweakDBID = TDBID.Create(storeItems[virtualItemIndex]);
    let itemId = ItemID.FromTDBID(itemTDBID);
    let itemData: ref<gameItemData> = inventoryManager.CreateBasicItemData(itemId, this.m_player);
    AtelierDebug(s"Store item: \(ToString(storeItems[virtualItemIndex]))");
    itemData.isVirtualItem = true;
    stockItem = new VirtualStockItem();
    stockItem.itemID = itemId;
    stockItem.itemTDBID = itemTDBID;
    stockItem.price = Cast<Float>(itemsPrices[virtualItemIndex]);
    stockItem.quality = itemsQualities[virtualItemIndex];
    stockItem.quantity = itemsQuantities[virtualItemIndex];
    AtelierDebug(s"   Dynamic tags: \(ToString(itemData.GetDynamicTags()))");
    AtelierDebug(s"   VirtPrice: \(ToString(stockItem.price))");
    if (RoundF(stockItem.price) == 0) {
      stockItem.price = Cast<Float>(AtelierUtils.ScaleItemPrice(this.m_player, vendorObject, itemId, stockItem.quality) * stockItem.quantity);
     };
    AtelierDebug(s"   CalcPrice: \(ToString(stockItem.price))");
    stockItem.itemData = itemData;
    ArrayPush(this.m_virtualStock, stockItem);
    virtualItemIndex += 1;
    totalPrice += stockItem.price;
  };

  this.m_buyAllPrice = totalPrice;
  this.ScaleStockItems();
}

@addMethod(FullscreenVendorGameController)
private final func ScaleStockItems() -> Void {
  let itemData: wref<gameItemData>;
  let itemRecord: wref<Item_Record>;
  let i: Int32 = 0;
  while i < ArraySize(this.m_virtualStock) {
    itemRecord = TweakDBInterface.GetItemRecord(this.m_virtualStock[i].itemTDBID);
    if !itemRecord.IsSingleInstance() && !itemData.HasTag(n"Cyberware") {
      AtelierUtils.ScaleItem(this.m_player, this.m_virtualStock[i].itemData, this.m_virtualStock[i].quality);
    };
    i += 1;
  };
}

@addMethod(FullscreenVendorGameController)
private final func ConvertGameDataIntoInventoryData(data: array<ref<VirtualStockItem>>, owner: wref<GameObject>) -> array<InventoryItemData> {
  let itemData: InventoryItemData;
  let itemDataArray: array<InventoryItemData>;
  let stockItem: ref<VirtualStockItem>;
  let i: Int32 = 0;
  while i < ArraySize(data) {
    stockItem = data[i];
    itemData = this.m_InventoryManager.GetInventoryItemData(owner, stockItem.itemData);
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

@wrapMethod(FullscreenVendorGameController)
private final func PopulateVendorInventory() -> Void {
  if this.GetIsVirtual() {
    this.PopulateVirtualShop();
  } else {
    wrappedMethod();
  };
}

@addMethod(FullscreenVendorGameController)
private func PopulateVirtualShop() -> Void {
  let i: Int32;
  let items: array<ref<IScriptable>>;
  let playerMoney: Int32;
  let vendorInventory: array<InventoryItemData>;
  let vendorInventoryData: ref<VendorInventoryItemData>;
  let vendorInventorySize: Int32;
  this.m_vendorFilterManager.Clear();
  this.m_vendorFilterManager.AddFilter(ItemFilterCategory.AllItems);
  this.FillVirtualStock();
  vendorInventory = this.ConvertGameDataIntoInventoryData(this.m_virtualStock, this.m_VendorDataManager.GetVendorInstance());
  vendorInventorySize = ArraySize(vendorInventory);
  playerMoney = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();

  AtelierDebug(s"Resulting list size: \(vendorInventorySize)");

  i = 0;
  while i < vendorInventorySize {
    vendorInventoryData = new VendorInventoryItemData();
    vendorInventoryData.ItemData = vendorInventory[i];

    // Darkcopse requirements displaying fix
    if InventoryItemData.GetGameItemData(vendorInventoryData.ItemData).HasTag(n"Cyberware") {
      InventoryItemData.SetEquipRequirements(vendorInventoryData.ItemData, RPGManager.GetEquipRequirements(this.m_player, InventoryItemData.GetGameItemData(vendorInventoryData.ItemData)));
    };
    InventoryItemData.SetIsEquippable(vendorInventoryData.ItemData, EquipmentSystem.GetInstance(this.m_player).GetPlayerData(this.m_player).IsEquippable(InventoryItemData.GetGameItemData(vendorInventoryData.ItemData)));

    vendorInventoryData.IsVendorItem = true;
    vendorInventoryData.IsEnoughMoney = playerMoney >= Cast<Int32>(InventoryItemData.GetBuyPrice(vendorInventory[i]));
    vendorInventoryData.IsDLCAddedActiveItem = this.m_uiScriptableSystem.IsDLCAddedActiveItem(ItemID.GetTDBID(InventoryItemData.GetID(vendorInventory[i])));

    this.m_InventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.m_uiScriptableSystem);      
    this.m_vendorFilterManager.AddItem(vendorInventoryData.ItemData.GameItemData);
    ArrayPush(items, vendorInventoryData);
    i += 1;
  };

  this.m_vendorDataSource.Reset(items);
  this.m_vendorFilterManager.SortFiltersList();
  this.m_vendorFilterManager.InsertFilter(0, ItemFilterCategory.AllItems);
  this.SetFilters(this.m_vendorFiltersContainer, this.m_vendorFilterManager.GetIntFiltersList(), n"OnVendorFilterChange");
  this.m_vendorItemsDataView.EnableSorting();
  this.m_vendorItemsDataView.SetFilterType(this.m_lastVendorFilter);
  this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
  this.m_vendorItemsDataView.DisableSorting();
  this.ToggleFilter(this.m_vendorFiltersContainer, EnumInt(this.m_lastVendorFilter));
  inkWidgetRef.SetVisible(this.m_vendorFiltersContainer, ArraySize(items) > 0);
  this.PlayLibraryAnimation(n"vendor_grid_show");
  
  AtelierButtonHintsHelper.UpdatePurchaseAllHint(this, this.BuyAllAvailable());
}

@addMethod(FullscreenVendorGameController)
private func BuyAllAvailable() -> Bool {
  let playerMoney: Int32 = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();
  let totalPrice: Int32 = Cast<Int32>(this.m_buyAllPrice);
  return playerMoney > totalPrice && !this.m_calledForBuyAll;
}

@addMethod(FullscreenVendorGameController)
public func GetTotalVirtualStorePrice() -> Int32 {
  let totalPrice: Int32 = Cast<Int32>(this.m_buyAllPrice);
  return totalPrice;
}
