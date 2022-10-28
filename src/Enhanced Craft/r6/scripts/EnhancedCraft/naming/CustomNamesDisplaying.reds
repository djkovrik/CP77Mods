module EnhancedCraft.Naming
import EnhancedCraft.System.*
import EnhancedCraft.Common.*

// -- Item data
@wrapMethod(InventoryItemData)
public final static func GetName(self: InventoryItemData) -> String {
  let area: gamedataEquipmentArea = InventoryItemData.GetEquipmentArea(self);
  let showCustomData: Bool = ECraftUtils.IsClothes(area) || ECraftUtils.IsWeapon(area);
  if InventoryItemData.GetGameItemData(self).hasCustomName && showCustomData {
    return InventoryItemData.GetGameItemData(self).customName; 
  };
  return wrappedMethod(self);
}

// -- Tooltips
@wrapMethod(UIItemsHelper)
public final static func GetItemName(itemRecord: ref<Item_Record>, itemData: wref<gameItemData>) -> String {
  let area: gamedataEquipmentArea = itemRecord.EquipArea().Type();
  let showCustomData: Bool = ECraftUtils.IsClothes(area) || ECraftUtils.IsWeapon(area);
  if itemData.hasCustomName && showCustomData {
    return itemData.customName;
  };
  return wrappedMethod(itemRecord, itemData);
}

// -- Item upgrade
@wrapMethod(UpgradingScreenController)
private final func SetQualityHeader() -> Void {
  wrappedMethod();

  if this.m_selectedItemData.GameItemData.hasCustomName {
    inkTextRef.SetText(this.m_itemName, this.m_selectedItemData.GameItemData.customName);
  };
}
