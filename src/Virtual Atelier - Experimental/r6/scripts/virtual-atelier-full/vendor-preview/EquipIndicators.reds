import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Systems.VirtualAtelierCartManager

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.cartManager = VirtualAtelierCartManager.GetInstance(GetGameInstance());
  this.previewManager = VirtualAtelierPreviewManager.GetInstance(GetGameInstance());
}

@wrapMethod(InventoryItemDisplayController)
protected func NewUpdateEquipped(itemData: ref<UIInventoryItem>) -> Void {
  wrappedMethod(itemData);
  let itemID: ItemID = itemData.GetID();
  let isPreviewEquipped: Bool = this.previewManager.GetIsEquipped(itemID);
  inkWidgetRef.SetVisible(this.m_equippedMarker, isPreviewEquipped);
}

@addMethod(InventoryItemDisplayController)
protected cb func OnVendorItemStateRefreshEvent(evt: ref<VendorItemStateRefreshEvent>) -> Bool {
  let itemID: ItemID;
  if IsDefined(this.m_uiInventoryItem) {
    itemID = this.m_uiInventoryItem.GetID();
  } else {
    itemID = InventoryItemData.GetID(this.m_itemData);
  };

  inkWidgetRef.SetVisible(this.m_equippedMarker, this.previewManager.GetIsEquipped(itemID));
}
