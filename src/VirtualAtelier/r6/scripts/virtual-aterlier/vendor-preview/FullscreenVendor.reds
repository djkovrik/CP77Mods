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
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_player.GetGame()); //
  let inventorySystem: ref<InventoryManager> = GameInstance.GetInventoryManager(this.m_player.GetGame()); //

  let playerMoney = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();

  if playerMoney < Cast(price) {
    let vendorNotification = new UIMenuNotificationEvent();
    vendorNotification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
    GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(vendorNotification);
  } else {
    transactionSystem.GiveItem(this.m_player, itemID, 1);
    transactionSystem.RemoveItemByTDBID(this.m_player, t"Items.money", Cast(price));

    let itemData = transactionSystem.GetItemData(this.m_player, itemID);
    this.TryScaleItemToPlayer(itemData, inventoryItemData.Quality);
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

@addMethod(FullscreenVendorGameController)
private final func TryScaleItemToPlayer(itemData: ref<gameItemData>, quality: CName) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let powerLevelPlayer: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PowerLevel);
  let powerLevelItem: Float = itemData.GetStatValueByType(gamedataStatType.PowerLevel);
  let qualityMult: Float;

  // TODO Something more flexible?
  // Scale item from PowerLevel
  switch (quality) {
    case n"Legendary":
      qualityMult = 0.9;
      break;
    case n"Epic":
      qualityMult = 0.85;
      break;
    case n"Rare":
      qualityMult = 0.8;
      break;
    case n"Uncommon":
      qualityMult = 0.75;
      break;
    case n"Common":
      qualityMult = 0.7;
      break;
    default:
      qualityMult = 1.0;
      break;
  };

  let resultingValue: Float = powerLevelPlayer * qualityMult;
  let powerLevelMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.PowerLevel, gameStatModifierType.Additive, resultingValue);
  statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
  statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), powerLevelMod);
  RPGManager.ForceItemQuality(player, itemData, quality);
}

@wrapMethod(FullscreenVendorGameController)
private final func PopulateVendorInventory() -> Void {
  if this.GetIsVirtual() {
    let items: array<ref<IScriptable>>;
    let vendorInventory: array<InventoryItemData>;
    let vendorInventoryData: ref<VendorInventoryItemData>;

    this.m_vendorFilterManager.Clear();
    this.m_vendorFilterManager.AddFilter(ItemFilterCategory.AllItems);

    let itemDataArray: array<ref<gameItemData>>;
    let gameInstance = this.m_player.GetGame();
    let ts = GameInstance.GetTransactionSystem(gameInstance);

    let storeID = this.GetVirtualStoreID();
    let storeItems: array<String> = this.GetVirtualStoreItems();
    let itemsPrices: array<Int32> = this.GetVirtualStorePrices();
    let itemsQualities: array<CName> = this.GetVirtualStoreQualities();

    let virtualItemIndex = 0;

    while virtualItemIndex < ArraySize(storeItems) {
      let itemId = ItemID.FromTDBID(TDBID.Create(storeItems[virtualItemIndex]));
      let itemModParams: ItemModParams;
      itemModParams.itemID = itemId;
      itemModParams.quantity = 1;
      let itemData: ref<gameItemData> = Inventory.CreateItemData(itemModParams, this.m_player);
      itemData.isVirtualItem = true;
      this.TryScaleItemToPlayer(itemData, itemsQualities[virtualItemIndex]);
      ArrayPush(itemDataArray, itemData);

      virtualItemIndex += 1;
    }

    let vendorItems = this.ConvertGameDataIntoInventoryData(itemDataArray, this.m_VendorDataManager.GetVendorInstance(), true);

    let inventoryItemDataIndex = 0;

    while inventoryItemDataIndex < ArraySize(vendorItems) {
      vendorInventoryData = new VendorInventoryItemData();
      vendorInventoryData.ItemData = vendorItems[inventoryItemDataIndex];

      InventoryItemData.SetIsVendorItem(vendorInventoryData.ItemData, true);
      InventoryItemData.SetItemType(vendorInventoryData.ItemData, itemDataArray[inventoryItemDataIndex].GetItemType());
      InventoryItemData.SetPrice(vendorInventoryData.ItemData, Cast(itemsPrices[inventoryItemDataIndex]));
      InventoryItemData.SetBuyPrice(vendorInventoryData.ItemData, Cast(itemsPrices[inventoryItemDataIndex]));
      InventoryItemData.SetQuantity(vendorInventoryData.ItemData, 1);
      InventoryItemData.SetQuality(vendorInventoryData.ItemData, itemsQualities[inventoryItemDataIndex]);
      // TODO: Apply atlas/texture changes here also, as in the tooltip

      vendorInventoryData.IsVendorItem = true;
      vendorInventoryData.IsEnoughMoney = true;
      vendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);

      this.m_InventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.m_uiScriptableSystem);      
      this.m_vendorFilterManager.AddItem(vendorInventoryData.ItemData.GameItemData);

      ArrayPush(items, vendorInventoryData);

      inventoryItemDataIndex += 1;
    };

    this.m_vendorDataSource.Reset(items);
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


// Reference for future use
// @wrapMethod(LootingController)
// public final func SetLootData(data: LootData) -> Void {
//   let board: wref<IBlackboard> = GameInstance.GetBlackboardSystem(this.m_gameInstance).Get(GetAllBlackboardDefs().VirtualShop);
//   let atelierItems: array<ItemID> = FromVariant(board.GetVariant(GetAllBlackboardDefs().VirtualShop.AtelierItems));

//   if Equals(EntityID.ToDebugString(data.ownerId), "$/03_night_city/c_watson/little_china/loc_megabuilding_a_prefab4KCU2IQ/loc_megabuilding_a_gameplay_prefab2GWVWSA/#loc_megabuilding_a_devices/#mq000_clothes_container") {
//     data.itemIDs = atelierItems;

//     let firstChoices = data.choices[0];

//     ArrayClear(data.choices);

//     let i = 0;

//     while i < ArraySize(data.choices) {
//       let newChoice = firstChoices;
//       newChoice.localizedName = "OLOLOOL";
//       ArrayPush(data.choices, newChoice);
//     }
//   } 

//   wrappedMethod(data);
// }     

// QueueEventForEntityID
// EntityID & PersistentID: 
// EntityID has: -784947793
// create extended ItemAddedEvent -> add a cb to gameLootContainerBase > use TransactionSystem on `this` to add item
// @wrapMethod(LootContainerObjectAnimatedByTransform)
// protected cb func OnInteraction(choiceEvent: ref<InteractionChoiceEvent>) -> Bool {
//   // EntityID.GetHash(this.GetEntityID())
//   // PersistentID.ExtractEntityID(this.GetPS().GetID())
//   // this.GetPS().GetID()

//   // let nullArrayOfNames: array<CName>;
//   // let entityRef = CreateEntityReference("$/03_night_city/c_watson/little_china/loc_megabuilding_a_prefab4KCU2IQ/loc_megabuilding_a_gameplay_prefab2GWVWSA/#loc_megabuilding_a_devices/#mq000_clothes_container", nullArrayOfNames);
//   // // let entityRef = CreateEntityReference("#mq000_clothes_container", nullArrayOfNames);
  
//   // let gameObject: ref<GameObject>;
//   // let entityIDs: array<EntityID>;
//   // GetFixedEntityIdsFromEntityReference(entityRef, this.GetGame(), entityIDs);
//   // GetGameObjectFromEntityReference(entityRef, this.GetGame(), gameObject);

//   // Log("OLOLOLOL NAME: " + NameToString(gameObject.GetName()));
//   // Log("OLOLOLO entity ids length: " + ArraySize(entityIDs));

//   // let id: EntityID = Cast(ResolveNodeRefWithEntityID(nodeRef, this.GetEntityID()));
//   // return 

//   // let i = 0;

//   // while i < ArraySize(entityIDs) {
//   //   let entity = GameInstance.FindEntityByID(this.GetGame(), entityIDs[i]);

//   //   Log("ENTITY NAME: " + entity.GetName());
//   //   i += 1;
//   // }
//   let board: wref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().VirtualShop);
//   let lootContainer: ref<LootContainerObjectAnimatedByTransform> = FromVariant(board.GetVariant(GetAllBlackboardDefs().VirtualShop.StorageID));

//   Log("OLOLOLO OnInteraction: " + NameToString(lootContainer.GetName()));

//   return wrappedMethod(choiceEvent);
// }