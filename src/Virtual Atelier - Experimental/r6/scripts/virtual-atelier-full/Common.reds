import VirtualAtelier.Systems.VirtualAtelierPreviewManager

// Darkcopse itemParts fix
@wrapMethod(InventoryDataManagerV2)
private final func GetPartInventoryItemData(owner: wref<GameObject>, itemId: ItemID, innerItemData: InnerItemData, opt itemData: wref<gameItemData>, opt record: wref<Item_Record>) -> InventoryItemData {
  if !(ItemID.IsValid(itemId)) && itemData.isVirtualItem {
    itemId = itemData.GetID();
  };
  return wrappedMethod(owner, itemId, innerItemData, itemData);
}

@addMethod(InventoryItemDisplayController)
protected cb func VendorInventoryEquipStateChanged(evt: ref<VendorInventoryEquipStateChanged>) -> Bool {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let system: ref<VirtualAtelierPreviewManager> = evt.system;
  let showEquipped: Bool = system.GetIsEquipped(itemID);
  let i: Int32 = 0;
  while i < ArraySize(this.m_equippedWidgets) {
    inkWidgetRef.SetVisible(this.m_equippedWidgets[i], showEquipped);
    i += 1;
  };
  i = 0;
  while i < ArraySize(this.m_hideWhenEquippedWidgets) {
    inkWidgetRef.SetVisible(this.m_hideWhenEquippedWidgets[i], !showEquipped);
    i += 1;
  };
  inkWidgetRef.SetVisible(this.m_equippedMarker, showEquipped);
}
