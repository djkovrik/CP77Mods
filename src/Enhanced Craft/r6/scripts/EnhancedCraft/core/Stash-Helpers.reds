import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Common.ECraftUtils
import EnhancedCraft.Common.L

@wrapMethod(Stash)
protected cb func OnOpenStash(evt: ref<OpenStash>) -> Bool {
  wrappedMethod(evt);
  let items: array<ref<gameItemData>>;
  let manager: ref<VendorDataManager> = new VendorDataManager();
  manager.Initialize(GetPlayer(this.GetGame()), this.GetEntityID());
  items = manager.GetStorageItems();
  EnhancedCraftSystem.GetInstance(this.GetGame()).RefreshPlayerInventoryAndStash(items);
}

// -- Refresh data for vendor list items (affects stash too)
@wrapMethod(FullscreenVendorGameController)
private final func PopulateVendorInventory() -> Void {
  wrappedMethod();
  let system: ref<EnhancedCraftSystem> = EnhancedCraftSystem.GetInstance(this.m_player.GetGame());
  let itemData: ref<gameItemData>;
  for item in this.m_vendorUIInventoryItems {
    itemData = item.GetItemData();
    L(s" > Stash item: \(itemData.GetName()) \(itemData.GetItemType()), has custom data: \(system.HasCustomName(item.GetID()))");
    if ECraftUtils.IsWeapon(itemData.GetItemType()) || ECraftUtils.IsClothes(itemData.GetItemType()) {
      system.RefreshSingleItem(itemData);
    };
  };
}

// -- Show custom name for new tooltips
@wrapMethod(UIInventoryItem)
public final func GetName() -> String {
  let itemData: ref<gameItemData> = this.GetItemData();

  if itemData.hasCustomName {
    return itemData.customName;
  };

  return wrappedMethod();
}
