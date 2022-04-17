module EnhancedCraft.Naming
import EnhancedCraft.System.*
import EnhancedCraft.Common.*

// -- Item data
@wrapMethod(InventoryItemData)
public final static func GetName(self: InventoryItemData) -> String {
  if self.GameItemData.hasCustomName {
    return self.GameItemData.customName; 
  }
  return wrappedMethod(self);
}

// -- Tooltips
@wrapMethod(UIItemsHelper)
public final static func GetItemName(itemRecord: ref<Item_Record>, itemData: wref<gameItemData>) -> String {
  if itemData.hasCustomName {
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
