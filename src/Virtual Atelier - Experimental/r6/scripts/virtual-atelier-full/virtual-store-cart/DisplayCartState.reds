import VirtualAtelier.Systems.VirtualAtelierCartManager

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let indicator: ref<inkImage> = new inkImage();
  indicator.SetName(n"bg1");
  indicator.SetAnchor(inkEAnchor.Fill);
  indicator.SetAnchorPoint(new Vector2(0.5, 0.5));
  indicator.SetNineSliceScale(true);
  indicator.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
  indicator.SetTexturePart(n"item_bg");
  indicator.SetOpacity(0.6);
  indicator.SetVisible(false);
  indicator.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  indicator.BindProperty(n"tintColor", n"MainColors.Yellow");
  indicator.Reparent(this.GetRootCompoundWidget(), 10);
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
    scale = 0.9;
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
