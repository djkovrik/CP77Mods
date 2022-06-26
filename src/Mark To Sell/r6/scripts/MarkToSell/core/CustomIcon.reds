@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let image: ref<inkImage> = new inkImage();
  let itemContainer: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"itemWrapper/container/rightContainer") as inkCompoundWidget;
  let weaponContainer: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidget(n"weaponWrapper/container/rightContainer") as inkCompoundWidget;
  image.SetName(n"ForSaleImage");
  image.SetFitToContent(true);
  image.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  image.BindProperty(n"tintColor", n"MainColors.White");
  image.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
  image.SetTexturePart(n"junk");
  image.SetAnchor(inkEAnchor.Centered);
  image.SetSize(new Vector2(50.0, 50.0));
  image.SetScale(new Vector2(0.8, 0.8));
  image.SetOpacity(0.75);
  image.SetVisible(false);
  image.SetAnchorPoint(new Vector2(0.5, 0.5));
  image.SetMargin(new inkMargin(0.0, -10.0, -10.0, 0.0));

  if IsDefined(itemContainer) {
    image.Reparent(itemContainer, 100);
  } else {
    if IsDefined(weaponContainer) {
      image.Reparent(weaponContainer, 100);
    };
  };

  this.m_forSaleImage = image;
}

@addMethod(InventoryItemDisplayController)
private func UpdateMarkedForSale() -> Void {
  let itemData: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_itemData);
  let isVisible: Bool = !InventoryItemData.IsEmpty(this.m_itemData) && itemData.modMarkedForSale;
  this.m_forSaleImage.SetVisible(isVisible);
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() -> Void {
  wrappedMethod();
  this.UpdateMarkedForSale();
}
