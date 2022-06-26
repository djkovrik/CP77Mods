import MarkToSell.System.MarkToSellSystem

@wrapMethod(FullscreenVendorGameController)
private final func GetSellableJunk() -> array<wref<gameItemData>> {
  let result: array<wref<gameItemData>> = wrappedMethod();
  let additionalJunk: array<wref<gameItemData>>;
  this.m_InventoryManager.GetPlayerItemsMarkedToSell(additionalJunk);
  for additionalItem in additionalJunk {
    ArrayPush(result, additionalItem);
  };

  return result;
}

@wrapMethod(FullscreenVendorGameController)
private final func PopulatePlayerInventory() -> Void {
  wrappedMethod();

  let hasJunk: Bool;
  let inventoryData: ref<VendorInventoryItemData>;
  let sellable: array<ref<gameItemData>>;
  let index: Int32 = 0;
  if IsDefined(this.m_vendorUserData) {
    sellable = this.m_VendorDataManager.GetItemsPlayerCanSell();
    index = 0;
    while index < ArraySize(sellable) {
      inventoryData = new VendorInventoryItemData();
      this.m_InventoryManager.GetCachedInventoryItemData(sellable[index], inventoryData.ItemData);
      if !hasJunk && (Equals(InventoryItemData.GetItemType(inventoryData.ItemData), gamedataItemType.Gen_Junk) || Equals(InventoryItemData.GetItemType(inventoryData.ItemData), gamedataItemType.Gen_Jewellery)) {
        hasJunk = true;
      };
      index += 1;
    };
  };

  if MarkToSellSystem.GetInstance(this.m_player.GetGame()).HasAnythingMarked() {
    hasJunk = true;
  };

  if hasJunk {
    this.m_buttonHintsController.AddButtonHint(n"sell_junk", GetLocalizedText("UI-UserActions-SellJunk"));
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"sell_junk");
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnSellJunkPopupClosed(data: ref<inkGameNotificationData>) -> Bool {
  let sellJunkData: ref<VendorSellJunkPopupCloseData> = data as VendorSellJunkPopupCloseData;
  if sellJunkData.confirm {
    MarkToSellSystem.GetInstance(this.m_player.GetGame()).ClearAll();
  };
  wrappedMethod(data);
}
