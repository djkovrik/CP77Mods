@addMethod(InventoryDataManagerV2)
public final func GetSellablePlayerItems(out items: array<wref<gameItemData>>) -> Void {
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let data: ref<gameItemData>;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  let price: Int32;
  while i < limit {
    data = unfilteredItems[i];
    price = RPGManager.CalculateSellPrice(this.m_Player.GetGame(), this.m_Player, data.GetID());
    if price > 0 {
      ArrayPush(items, data);
    };
    i += 1;
  };
}

@addMethod(InventoryDataManagerV2)
public final func GetPlayerItemsMarkedToSell(out items: array<wref<gameItemData>>) -> Void {
  let unfilteredItems: array<wref<gameItemData>>;
  this.GetSellablePlayerItems(unfilteredItems);
  let data: ref<gameItemData>;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    if data.modMarkedForSale {
      ArrayPush(items, data);
    };
    i += 1;
  };
}
