import VirtualAtelier.Systems.VirtualAtelierPreviewManager

@addMethod(InventoryItemDisplayController)
protected cb func OnAtelierEquipStateChangedEvent(evt: ref<AtelierEquipStateChangedEvent>) -> Bool {
  let itemID: ItemID;

  if IsDefined(this.m_uiInventoryItem) {
    itemID = this.m_uiInventoryItem.GetID();
  } else {
    itemID = InventoryItemData.GetID(this.m_itemData);
  };

  let previewManager: ref<VirtualAtelierPreviewManager> = evt.manager;
  let showEquipped: Bool = previewManager.GetIsEquipped(itemID);
  inkWidgetRef.SetVisible(this.m_equippedMarker, showEquipped);
}
