module EnhancedCraft.Naming
import EnhancedCraft.System.EnhancedCraftSystem

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

// -- Get IDs from array
@addMethod(InventoryDataManagerV2)
public final func GetItemsIdsFromGameData(targetItems: array<ref<gameItemData>>, out items: array<ItemID>) -> Void {
  let itemId: ItemID;
  let limit: Int32 = ArraySize(targetItems);
  let i: Int32 = 0;
  while i < limit {
    itemId = targetItems[i].GetID();
    ArrayPush(items, itemId);
    i += 1;
  };
}

// -- Refresh data for item tooltip
@wrapMethod(InventoryDataManagerV2)
public final func GetExternalGameItemData(ownerId: EntityID, externalItemId: ItemID) -> wref<gameItemData> {
  let data: wref<gameItemData> = wrappedMethod(ownerId, externalItemId);
  EnhancedCraftSystem.GetInstance(this.m_Player.GetGame()).RefreshSingleItem(data);
  return data;
}
