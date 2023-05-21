import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Systems.VirtualAtelierCartManager
import VirtualAtelier.UI.VirtualAtelierControlStyle

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.CreateCartIndicator();
  this.CreateQuantityIndicator();
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() -> Void {
  wrappedMethod();
  let data: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_itemData);
  if data.isVirtualItem {
    this.RefreshAtelierEquipLabel();
    this.RefreshAtelierCartIndicator();
    this.RefreshAtelierQuantityIndicator();
    this.RefreshAtelierEnoughMoneyIndicator();
  };
}

@addMethod(InventoryItemDisplayController)
protected cb func OnVirtualItemStateRefreshEvent(evt: ref<VirtualItemStateRefreshEvent>) -> Bool {
  let data: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_itemData);
  if data.isVirtualItem {
    this.RefreshAtelierEquipLabel();
    this.RefreshAtelierCartIndicator();
    this.RefreshAtelierQuantityIndicator();
    this.RefreshAtelierEnoughMoneyIndicator();
  };
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
private final func RefreshAtelierQuantityIndicator() -> Void {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let quantity: Int32 = this.cartManager.GetAddedQuantity(itemID);
  this.quantityIndicator.SetVisible(quantity > 1);
  this.quantityIndicator.SetText(s"x\(quantity)");
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

@addMethod(InventoryItemDisplayController)
private final func CreateQuantityIndicator() -> Void {
  let container: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let quantity: ref<inkText> = new inkText();
  container.RemoveChildByName(n"cartQuantity");
  quantity.SetName(n"cartQuantity");
  quantity.SetVisible(false);
  quantity.SetAnchor(inkEAnchor.TopLeft);
  quantity.SetHAlign(inkEHorizontalAlign.Left);
  quantity.SetMargin(new inkMargin(40.0, 0.0, 0.0, 0.0));
  quantity.SetText("x1000");
  quantity.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  quantity.SetFontSize(38);
  quantity.SetFontStyle(n"Medium");
  quantity.SetLetterCase(textLetterCase.OriginalCase);
  quantity.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  quantity.BindProperty(n"tintColor", VirtualAtelierControlStyle.QuantityTextColor());
  quantity.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
  quantity.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
  quantity.SetFitToContent(true);
  quantity.Reparent(container, 10);
  this.quantityIndicator = quantity;
}
