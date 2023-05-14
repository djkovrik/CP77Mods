import VirtualAtelier.Systems.VirtualAtelierPreviewManager

@addMethod(InventoryItemDisplayController)
protected cb func OnAtelierEquipStateChangedEvent(evt: ref<AtelierEquipStateChangedEvent>) -> Bool {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let previewManager: ref<VirtualAtelierPreviewManager> = evt.manager;
  let showEquipped: Bool = previewManager.GetIsEquipped(itemID);

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
