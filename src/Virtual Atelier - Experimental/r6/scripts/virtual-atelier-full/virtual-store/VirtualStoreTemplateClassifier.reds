module VirtualAtelier.UI

public class VirtualStoreTemplateClassifier extends inkVirtualItemTemplateClassifier {

  public func ClassifyItem(data: Variant) -> Uint32 {
    let m_wrappedData: ref<WrappedInventoryItemData> = FromVariant<ref<IScriptable>>(data) as WrappedInventoryItemData;
    if !IsDefined(m_wrappedData) {
      return 0u;
    };
    if IsDefined(m_wrappedData.Item) {
      if m_wrappedData.Item.IsWeapon() && !m_wrappedData.Item.IsRecipe() {
        return 1u;
      };
    };
    if Equals(InventoryItemData.GetEquipmentArea(m_wrappedData.ItemData), gamedataEquipmentArea.Weapon) {
      return 1u;
    };
    return 0u;
  }
}
