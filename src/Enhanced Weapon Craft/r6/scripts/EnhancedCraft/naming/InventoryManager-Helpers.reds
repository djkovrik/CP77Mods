module EnhancedCraft.Naming

// -- Returns ItemID array for weapons from player inventory
//    TODO Add stash?
@addMethod(InventoryDataManagerV2)
public final func GetPlayerItemsIDsByCategory(category: gamedataItemCategory, out items: array<ItemID>) -> Void {
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let itemId: ItemID;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  while i < limit {
    itemId = unfilteredItems[i].GetID();
    if Equals(RPGManager.GetItemCategory(itemId), category) {
      ArrayPush(items, itemId);
    };
    i += 1;
  };
}

// -- Returns gameItemData array for weapons from player inventory
@addMethod(InventoryDataManagerV2)
public final func GetPlayerItemsDataByCategory(category: gamedataItemCategory, out items: array<ref<gameItemData>>) -> Void {
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let data: ref<gameItemData>;
  let itemId: ItemID;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    itemId = data.GetID();
    if Equals(RPGManager.GetItemCategory(itemId), category) {
      ArrayPush(items, data);
    };
    i += 1;
  };
}
