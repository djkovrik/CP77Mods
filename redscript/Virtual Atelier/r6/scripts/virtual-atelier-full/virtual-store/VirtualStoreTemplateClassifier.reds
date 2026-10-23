module VirtualAtelier.UI

public class VirtualStoreTemplateClassifier extends inkVirtualItemTemplateClassifier {

  public func ClassifyItem(data: Variant) -> Uint32 {
    let wrappedData: ref<WrappedInventoryItemData> = FromVariant<ref<IScriptable>>(data) as WrappedInventoryItemData;
    let wrappedHeader: ref<VirtualStoreHeaderWrapper> = FromVariant<ref<IScriptable>>(data) as VirtualStoreHeaderWrapper;
    if !IsDefined(wrappedData) && !IsDefined(wrappedHeader) {
      return 0u;
    };
    if IsDefined(wrappedHeader) {
      return 2u;
    };
    if IsDefined(wrappedData.Item) {
      if wrappedData.Item.IsWeapon() && !wrappedData.Item.IsRecipe() {
        return 1u;
      };
    };
    if Equals(InventoryItemData.GetEquipmentArea(wrappedData.ItemData), gamedataEquipmentArea.Weapon) {
      return 1u;
    };
    return 0u;
  }
}
