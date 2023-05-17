import VirtualAtelier.Systems.VirtualAtelierCartManager
import VirtualAtelier.UI.VirtualAtelierControlStyle

@addField(InventoryItemDisplayController)
public let cartBackground: wref<inkImage>;

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let source: ref<inkImage> = inkWidgetRef.Get(this.m_iconicTint) as inkImage;
  let container: ref<inkCompoundWidget> = source.GetParentWidget() as inkCompoundWidget;
  container.RemoveChildByName(n"cartBg");
  let indicator: ref<inkImage> = new inkImage();
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
protected cb func OnAtelierCartStateChangedEvent(evt: ref<AtelierCartStateChangedEvent>) -> Bool {
  let root: ref<inkWidget> = this.GetRootCompoundWidget();
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let cartManager: ref<VirtualAtelierCartManager> = evt.manager;
  let isAddedToCart: Bool = cartManager.IsAddedToCart(itemID);
  this.cartIndicator.SetVisible(isAddedToCart);
  let scale: Float;
  if isAddedToCart {
    scale = 0.95;
  } else {
    scale = 1.0;
  };
  if NotEquals(root.GetScale().X, scale) || NotEquals(root.GetScale().Y, scale){
    this.AnimateCartScale(root, scale);
  };
}

@addMethod(InventoryItemDisplayController)
private func AnimateCartScale(targetWidget: ref<inkWidget>, endScale: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
  scaleInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  scaleInterpolator.SetType(inkanimInterpolationType.Linear);
  scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  scaleInterpolator.SetStartScale(targetWidget.GetScale());
  scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
  scaleInterpolator.SetDuration(0.15);
  moveElementsAnimDef.AddInterpolator(scaleInterpolator);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  return proxy;
}
