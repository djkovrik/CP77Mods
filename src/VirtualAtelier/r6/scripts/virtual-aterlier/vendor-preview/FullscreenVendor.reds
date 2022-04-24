module VendorPreview.FullscreenVendorGameController

import VendorPreview.ItemPreviewManager.*
import VendorPreview.constants.*
import VendorPreview.utils.*

@addField(FullscreenVendorGameController)
public let m_isPreviewMode: Bool;

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  if !this.GetIsVirtual() {
    ItemPreviewManager.AddPreviewModeToggleButtonHint(this);
  }
}

@addMethod(FullscreenVendorGameController)
private final func GetIsVirtual() -> Bool {
  return Equals(this.m_vendorUserData.vendorData.data.vendorId, "VirtualVendor");
}

// TODO: Add custom background support [+ other custom stuff?]
@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreName() -> String {
  return this.m_vendorUserData.vendorData.virtualStore.storeName;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreID() -> CName {
  return this.m_vendorUserData.vendorData.virtualStore.storeID;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreItems() -> array<String> {
  return this.m_vendorUserData.vendorData.virtualStore.items;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStorePrices() -> array<Int32> {
  return this.m_vendorUserData.vendorData.virtualStore.prices;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreQualities() -> array<CName> {
  let items: array<String> = this.m_vendorUserData.vendorData.virtualStore.items;
  let qualities: array<String> = this.m_vendorUserData.vendorData.virtualStore.qualities;
  let qualitiesCNames: array<CName> = [];

  let defaultQuality = n"Rare";

  let i = 0;

  while (i < ArraySize(items)) {
    let itemQuality = qualities[i];

    if Equals(itemQuality, "") {
      ArrayPush(qualitiesCNames, defaultQuality);
    } else {
      let qualityCName = StringToName(itemQuality);

      if IsNameValid(qualityCName) && !Equals(qualityCName, n"") {
        ArrayPush(qualitiesCNames, qualityCName);
      } else {
         ArrayPush(qualitiesCNames, defaultQuality);
      }
    }

    i += 1;
  }

  return qualitiesCNames;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreAtlasResource() -> ResRef {
  return this.m_vendorUserData.vendorData.virtualStore.atlasResource;
}

@addMethod(FullscreenVendorGameController)
private final func GetVirtualStoreTexturePart() -> CName {
  return this.m_vendorUserData.vendorData.virtualStore.texturePart;
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

  if !Equals(this.m_itemPreviewPopupToken, null) {
    this.m_itemPreviewPopupToken.TriggerCallback(null);
  }
}

@addMethod(FullscreenVendorGameController)
protected cb func OnTogglePreviewMode(evt: ref<inkPointerEvent>) -> Bool {
  if this.m_isPreviewMode {
    this.m_itemPreviewPopupToken.TriggerCallback(null);
  } else {
    this.ShowGarmentPreview();
  }
}

@addMethod(FullscreenVendorGameController)
private final func ShowGarmentPreview() -> Void {
  this.m_isPreviewMode = true;

  let displayContext: ItemDisplayContext;

  if (this.GetIsVirtual()) {
    displayContext = ItemDisplayContext.VendorPlayer; 
  } else {
    displayContext = ItemDisplayContext.Vendor;
  }

  this.m_itemPreviewPopupToken = ItemPreviewManager.GetGarmentPreviewNotificationToken(this, displayContext) as inkGameNotificationToken;
  this.m_itemPreviewPopupToken.RegisterListener(this, n"OnEquipPreviewClosed");

  ItemPreviewManager.OnToggleGarmentPreview(this, true);
}

@addMethod(FullscreenVendorGameController)
protected cb func OnEquipPreviewClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.m_isPreviewMode = false;
  this.m_itemPreviewPopupToken = null;
  
  ItemPreviewManager.OnToggleGarmentPreview(this, false);
}

@addMethod(FullscreenVendorGameController)
private func BuyItemFromVirtualVendor(inventoryItemData: InventoryItemData) {
  let itemID: ItemID = InventoryItemData.GetID(inventoryItemData);
  let price = InventoryItemData.GetPrice(inventoryItemData);

  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_player.GetGame());
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_player.GetGame());
  let inventorySystem: ref<InventoryManager> = GameInstance.GetInventoryManager(this.m_player.GetGame());

  let playerMoney = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();

  if playerMoney < Cast(price) {
    let vendorNotification = new UIMenuNotificationEvent();
    vendorNotification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
    GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(vendorNotification);
  } else {
    transactionSystem.GiveItem(this.m_player, itemID, 1);
    transactionSystem.RemoveItemByTDBID(this.m_player, t"Items.money", Cast(price));
  }
}

@wrapMethod(FullscreenVendorGameController)
private final func HandleVendorSlotInput(evt: ref<ItemDisplayClickEvent>, itemData: InventoryItemData) -> Void {
  if (!this.m_isPreviewMode) {
    wrappedMethod(evt, itemData);
    return;
  }

  let isVendorItem = InventoryItemData.IsVendorItem(itemData);
  let isVirtual = this.GetIsVirtual();
  
  if (isVirtual && evt.actionName.IsAction(VendorPreviewButtonHint.Get().previewModeToggleName)) {
    this.BuyItemFromVirtualVendor(itemData);
    return;
  }

  // Override the "click" action on item, if the preview widget is currently open
  if (evt.actionName.IsAction(n"click") && isVendorItem) {
    let itemId = InventoryItemData.GetID(itemData);

    let itemName = InventoryItemData.GetName(itemData);

    let isEquipped = ItemPreviewManager.GetInstance().GetIsEquipped(itemId);
    let hintLabel: String;
    let isWeapon = IsItemWeapon(itemId);
    let isClothing = IsItemClothing(itemId);

    if (isClothing || isWeapon) {
      ItemPreviewManager.GetInstance().TogglePreviewItem(itemData);

      if isEquipped {
        hintLabel = VirtualAtelierText.PreviewEquip();
      } else {
        hintLabel = VirtualAtelierText.PreviewUnequip();
      }

      this.m_buttonHintsController.RemoveButtonHint(n"select");
      this.m_buttonHintsController.AddButtonHint(n"select", hintLabel);
    } else {
      this.m_buttonHintsController.RemoveButtonHint(n"select");
    }
	}
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnHandleGlobalInput(event: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(event);

  let vendorPreviewButtonHint = VendorPreviewButtonHint.Get();
  let isVirtual: Bool = this.GetIsVirtual();

  switch true {
    case event.IsAction(vendorPreviewButtonHint.previewModeToggleName) && !isVirtual:
      if (this.m_isPreviewMode) {
        this.m_itemPreviewPopupToken.TriggerCallback(null);
      } else {
        this.ShowGarmentPreview();
      }
      break;
    
    case event.IsAction(vendorPreviewButtonHint.resetGarmentName):
      ItemPreviewManager.GetInstance().ResetGarment();
      break;
      
    case event.IsAction(vendorPreviewButtonHint.removeAllGarmentName):
      ItemPreviewManager.GetInstance().RemoveAllGarment();
      break;
      
    case event.IsAction(vendorPreviewButtonHint.removePreviewGarmentName):
      ItemPreviewManager.GetInstance().RemovePreviewGarment();
      break;

    case (event.IsAction(n"back") && isVirtual && this.m_isPreviewMode):
    case (event.IsAction(n"cancel") && isVirtual && this.m_isPreviewMode):
      this.m_menuEventDispatcher.SpawnEvent(n"OnVendorClose");
      break;
  }
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  if (this.m_isPreviewMode) {
    let itemId = InventoryItemData.GetID(evt.itemData);
    let isEquipped = ItemPreviewManager.GetInstance().GetIsEquipped(itemId);
    let isWeapon = IsItemWeapon(itemId);
    let isClothing = IsItemClothing(itemId);

    if (isWeapon || isClothing) {
      let hintLabel: String;

      if isEquipped {
        hintLabel = VirtualAtelierText.PreviewUnequip();
      } else {
        hintLabel = VirtualAtelierText.PreviewEquip();
      };

      this.m_buttonHintsController.RemoveButtonHint(n"select");
      this.m_buttonHintsController.AddButtonHint(n"select", hintLabel);
    } else {
      this.m_buttonHintsController.RemoveButtonHint(n"select");
    };

    if this.GetIsVirtual() {
      let vendorPreviewButtonHint = VendorPreviewButtonHint.Get();
      this.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.previewModeToggleName);
      this.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName, vendorPreviewButtonHint.previewModeTogglePurchaseLabel);
    };

    let noCompare: InventoryItemData;
    this.ShowTooltipsForItemController(evt.widget, noCompare, evt.itemData, evt.display.DEBUG_GetIconErrorInfo(), false);
  } else {
    wrappedMethod(evt);
  }
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
  wrappedMethod(userData);

  if this.GetIsVirtual() {
    let storeName = this.GetVirtualStoreName();

    inkTextRef.SetText(this.m_vendorName, storeName);
    this.m_lastVendorFilter = ItemFilterCategory.AllItems;
    inkWidgetRef.SetVisible(this.m_vendorBalance, false);
    this.ShowGarmentPreview();
  }
}

@addField(gameItemData)
let isVirtualItem: Bool;

@wrapMethod(FullscreenVendorGameController)
private final func ShowTooltipsForItemController(targetWidget: wref<inkWidget>, equippedItem: InventoryItemData, inspectedItemData: InventoryItemData, iconErrorInfo: ref<DEBUG_IconErrorInfo>, isBuybackStack: Bool) -> Void {
  if this.GetIsVirtual() {
    let data: ref<InventoryTooltipData>;
    let isComparable: Bool;
    let tooltipData: ref<IdentifiedWrappedTooltipData>;
    let tooltipsData: array<ref<ATooltipData>>;
    let isPlayerItem: Bool = !InventoryItemData.IsVendorItem(inspectedItemData);
    let placement: gameuiETooltipPlacement = isPlayerItem ? gameuiETooltipPlacement.RightTop : gameuiETooltipPlacement.LeftTop;
    
    data = this.m_InventoryManager.GetTooltipDataForInventoryItem(inspectedItemData, InventoryItemData.IsEquipped(inspectedItemData), iconErrorInfo, InventoryItemData.IsVendorItem(inspectedItemData));
    data.displayContext = InventoryTooltipDisplayContext.Vendor;
    data.isVirtualItem = true;
    data.virtualInventoryItemData = inspectedItemData;
    this.m_TooltipsManager.ShowTooltipAtWidget(n"itemTooltip", targetWidget, data, placement);
  } else {
    wrappedMethod(targetWidget, equippedItem, inspectedItemData, iconErrorInfo, isBuybackStack);
  }
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  wrappedMethod(controller, selectedIndex);
  
  if this.GetIsVirtual() {
    this.PopulateVendorInventory();
  };
}


// POPULATE VIRTUAL STOCK & SCALE

class VirtualStockItem {
  public let itemID: ItemID;
  public let itemTDBID: TweakDBID;
  public let price: Float;
  public let quality: CName;
  public let itemData: ref<gameItemData>;
}

@addField(FullscreenVendorGameController)
private let m_virtualStock: array<ref<VirtualStockItem>>;

@addMethod(FullscreenVendorGameController)
private final func FillVirtualStock() -> Void {
  let inventoryManager: ref<InventoryManager> = GameInstance.GetInventoryManager(this.m_player.GetGame());
  let itemDataArray: array<ref<gameItemData>>;
  let storeID: CName = this.GetVirtualStoreID();
  let storeItems: array<String> = this.GetVirtualStoreItems();
  let itemsPrices: array<Int32> = this.GetVirtualStorePrices();
  let itemsQualities: array<CName> = this.GetVirtualStoreQualities();

  let stockItem: ref<VirtualStockItem>;
  let virtualItemIndex = 0;
  ArrayClear(this.m_virtualStock);
  while virtualItemIndex < ArraySize(storeItems) {
    let itemTDBID: TweakDBID = TDBID.Create(storeItems[virtualItemIndex]);
    let itemId = ItemID.FromTDBID(itemTDBID);
    let itemData: ref<gameItemData> = inventoryManager.CreateBasicItemData(itemId, this.m_player);
    itemData.isVirtualItem = true;
    stockItem = new VirtualStockItem();
    stockItem.itemID = itemId;
    stockItem.itemTDBID = itemTDBID;
    stockItem.price = Cast<Float>(itemsPrices[virtualItemIndex]);
    stockItem.quality = itemsQualities[virtualItemIndex];
    stockItem.itemData = itemData;
    ArrayPush(this.m_virtualStock, stockItem);
    virtualItemIndex += 1;
  };

  this.ScaleStockItems();
}

@addMethod(FullscreenVendorGameController)
private final func ScaleStockItems() -> Void {
  let itemData: wref<gameItemData>;
  let itemRecord: wref<Item_Record>;
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_player.GetGame());
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_player.GetGame());
  let powerLevelPlayer: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.PowerLevel);
  let powerLevelMod: ref<gameStatModifierData>;
  let qualityMod: ref<gameStatModifierData>;
  let i: Int32 = 0;
  while i < ArraySize(this.m_virtualStock) {
    itemRecord = TweakDBInterface.GetItemRecord(this.m_virtualStock[i].itemTDBID);
    if !itemRecord.IsSingleInstance() && !itemData.HasTag(n"Cyberware") {
      this.m_player.ScaleAtelierItem(this.m_virtualStock[i].itemData, this.m_virtualStock[i].quality);
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
    InventoryItemData.SetQuantity(itemData, 1);
    InventoryItemData.SetQuality(itemData, stockItem.quality);
    ArrayPush(itemDataArray, itemData);
    i += 1;
  };
  return itemDataArray;
}

@wrapMethod(FullscreenVendorGameController)
private final func PopulateVendorInventory() -> Void {
  if this.GetIsVirtual() {
    let i: Int32;
    let items: array<ref<IScriptable>>;
    let j: Int32;
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

    // AtelierLog(s"Resulting list size: \(vendorInventorySize)");

    i = 0;
    while i < vendorInventorySize {
      vendorInventoryData = new VendorInventoryItemData();
      vendorInventoryData.ItemData = vendorInventory[i];
      vendorInventoryData.IsVendorItem = true;
      vendorInventoryData.IsEnoughMoney = playerMoney >= Cast<Int32>(InventoryItemData.GetBuyPrice(vendorInventory[i]));
      vendorInventoryData.IsDLCAddedActiveItem = this.m_uiScriptableSystem.IsDLCAddedActiveItem(ItemID.GetTDBID(InventoryItemData.GetID(vendorInventory[i])));
      vendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);

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
  } else {
    wrappedMethod();
  }
}
