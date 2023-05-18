import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Systems.VirtualAtelierCartManager
import VirtualAtelier.UI.VirtualAtelierControlStyle

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.cartManager = VirtualAtelierCartManager.GetInstance(GetGameInstance());
  this.previewManager = VirtualAtelierPreviewManager.GetInstance(GetGameInstance());
}


// -- Vendor

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


// -- Virtual Store

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.CreateCartIndicator();
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() -> Void {
  wrappedMethod();
  this.RefreshAtelierEquipLabel();
  this.RefreshAtelierCartIndicator();
  this.RefreshAtelierEnoughMoneyIndicator();
}

@addMethod(InventoryItemDisplayController)
protected cb func OnVirtualItemStateRefreshEvent(evt: ref<VirtualItemStateRefreshEvent>) -> Bool {
  this.RefreshAtelierEquipLabel();
  this.RefreshAtelierCartIndicator();
  this.RefreshAtelierEnoughMoneyIndicator();
}

@addMethod(InventoryItemDisplayController)
private final func RefreshAtelierEquipLabel() -> Void {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let isPreviewEquipped: Bool = this.previewManager.GetIsEquipped(itemID);
  inkWidgetRef.SetVisible(this.m_equippedMarker, isPreviewEquipped);
}

@addMethod(InventoryItemDisplayController)
private final func RefreshAtelierCartIndicator() -> Void {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let isAddedToCart: Bool = this.cartManager.IsAddedToCart(itemID);
  this.cartIndicator.SetVisible(isAddedToCart);
}

@addMethod(InventoryItemDisplayController)
private final func RefreshAtelierEnoughMoneyIndicator() -> Void {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let enoughMoney: Bool = this.cartManager.PlayerHasEnoughMoneyFor(itemID);
  let isAddedToCart: Bool = this.cartManager.IsAddedToCart(itemID);
  if !enoughMoney && !isAddedToCart {
    inkWidgetRef.SetState(this.m_requirementsWrapper, n"Money");
    this.m_requirementsMet = false;
  } else {
    this.UpdateRequirements();
  };
}

@addMethod(InventoryItemDisplayController)
private final func CreateCartIndicator() -> Void {
  let source: ref<inkImage> = inkWidgetRef.Get(this.m_iconicTint) as inkImage;
  let container: ref<inkCompoundWidget> = source.GetParentWidget() as inkCompoundWidget;
  let indicator: ref<inkImage> = new inkImage();
  container.RemoveChildByName(n"cartBg");
  indicator.SetName(n"cartBg");
  indicator.SetAnchor(source.GetAnchor());
  indicator.SetAnchorPoint(source.GetAnchorPoint());
  indicator.SetNineSliceScale(source.UsesNineSliceScale());
  indicator.SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\atlas_inventory.inkatlas");
  indicator.SetTexturePart(source.GetTexturePart());
  indicator.SetOpacity(source.GetOpacity());
  indicator.SetVisible(false);
  indicator.SetSize(source.GetSize());
  indicator.SetTileHAlign(source.GetTileHAlign());
  indicator.SetTileVAlign(source.GetTileVAlign());
  indicator.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  indicator.BindProperty(n"tintColor", VirtualAtelierControlStyle.CartItemBackground());
  indicator.Reparent(container, 20);
  this.cartIndicator = indicator;
}
