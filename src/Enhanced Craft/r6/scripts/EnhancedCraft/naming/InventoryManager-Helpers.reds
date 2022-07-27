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

// -- Refresh data for loot item tooltip
@wrapMethod(InventoryDataManagerV2)
public final func GetPlayerItemData(itemId: ItemID) -> wref<gameItemData> {
  let itemData: wref<gameItemData> = wrappedMethod(itemId);
  if this.m_Player.IsWeaponECraft(itemData) {
    EnhancedCraftSystem.GetInstance(this.m_Player.GetGame()).RefreshSingleItem(itemData);
  };
  return itemData;
}

@wrapMethod(InventoryDataManagerV2)
public final func GetExternalGameItemData(ownerId: EntityID, externalItemId: ItemID) -> wref<gameItemData> {
  let itemData: wref<gameItemData> = wrappedMethod(ownerId, externalItemId);
  if this.m_Player.IsWeaponECraft(itemData) {
    EnhancedCraftSystem.GetInstance(this.m_Player.GetGame()).RefreshSingleItem(itemData);
  };
  return itemData;
}

// -- Refresh data for stash item tooltip
@wrapMethod(InventoryDataManagerV2)
public final func GetTooltipDataForInventoryItem(tooltipItemData: InventoryItemData, equipped: Bool, opt vendorItem: Bool, opt overrideRarity: Bool) -> ref<InventoryTooltipData> {
  let system: ref<EnhancedCraftSystem> = EnhancedCraftSystem.GetInstance(this.m_Player.GetGame());
  let newItemData: ref<gameItemData> = InventoryItemData.GetGameItemData(tooltipItemData);
  let newInventoryItemData: InventoryItemData;
  if this.m_Player.IsWeaponECraft(newItemData) {
    if system.HasCustomName(newItemData.GetID()) || system.HasCustomDamageStats(newItemData.GetID()) {
      EnhancedCraftSystem.GetInstance(this.m_Player.GetGame()).RefreshSingleItem(newItemData);
      newInventoryItemData = this.GetInventoryItemData(newItemData);
      return wrappedMethod(newInventoryItemData, equipped, vendorItem, overrideRarity);
    };
  };

  return wrappedMethod(tooltipItemData, equipped, vendorItem, overrideRarity);
}
