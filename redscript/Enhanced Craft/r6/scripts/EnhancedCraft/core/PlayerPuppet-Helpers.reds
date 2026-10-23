module EnhancedCraft.Core
import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Common.ECraftUtils
import EnhancedCraft.Common.L

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToInventory(evt: ref<ItemAddedEvent>) -> Bool {
  wrappedMethod(evt);
  let itemData: ref<gameItemData> = evt.itemData;
  if ECraftUtils.IsWeapon(itemData.GetItemType()) {
    EnhancedCraftSystem.GetInstance(this.GetGame()).RefreshSingleItem(itemData);
  };
}
