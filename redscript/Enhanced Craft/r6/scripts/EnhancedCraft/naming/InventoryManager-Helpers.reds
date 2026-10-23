module EnhancedCraft.Naming
import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Common.ECraftUtils
import EnhancedCraft.Common.L

// -- Returns gameItemData array for weapons from player inventory
@addMethod(InventoryDataManagerV2)
public final func GetPlayerItemsDataByCategory(out items: array<ref<gameItemData>>) -> Void {
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let data: ref<gameItemData>;
  let itemId: ItemID;
  let limit: Int32 = ArraySize(unfilteredItems);
  let category: gamedataItemCategory;
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    itemId = data.GetID();
    category = RPGManager.GetItemCategory(itemId);
    if Equals(category, gamedataItemCategory.Weapon) {
      ArrayPush(items, data);
    };
    i += 1;
  };
}

// -- Refresh data for loot item tooltip
@wrapMethod(InventoryDataManagerV2)
public final func GetPlayerItemData(itemId: ItemID) -> wref<gameItemData> {
  let itemData: wref<gameItemData> = wrappedMethod(itemId);
  if ECraftUtils.IsWeapon(itemData.GetItemType()) {
    EnhancedCraftSystem.GetInstance(this.m_Player.GetGame()).RefreshSingleItem(itemData);
  };
  return itemData;
}

@wrapMethod(InventoryDataManagerV2)
public final func GetExternalGameItemData(ownerId: EntityID, externalItemId: ItemID) -> wref<gameItemData> {
  let itemData: wref<gameItemData> = wrappedMethod(ownerId, externalItemId);
  if ECraftUtils.IsWeapon(itemData.GetItemType()) {
    EnhancedCraftSystem.GetInstance(this.m_Player.GetGame()).RefreshSingleItem(itemData);
  };
  return itemData;
}
