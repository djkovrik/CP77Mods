import EquipmentEx.OutfitSystem

@addField(gameuiInventoryGameController)
private let m_outfitManagerActive: Bool;

@addField(gameuiInventoryGameController)
private let m_outfitManagerWidget: ref<inkWidget>;

@addField(gameuiInventoryGameController)
private let m_btnOutfitManager: ref<inkWidget>;

@addField(gameuiInventoryGameController)
private let outfitSystem: wref<OutfitSystem>;

@wrapMethod(gameuiInventoryGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.outfitSystem = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidget(n"default_wrapper/menuLinks/btnsContainer") as inkCompoundWidget;
  this.m_btnOutfitManager = this.SpawnFromLocal(container, n"HyperlinkButton");
  this.SetupOutfitManagerButton(this.m_btnOutfitManager, n"ico_wardrobe", n"UI-Wardrobe-Tooltip-OutfitInfoTitle");
  // Move fluff and divider
  let divider: ref<inkWidget> = root.GetWidget(n"default_wrapper/menuLinks/divider");
  let fluff: ref<inkWidget> = root.GetWidget(n"default_wrapper/menuLinks/buttonFluff2");
  divider.SetTranslation(0.0, 127.0);
  fluff.SetTranslation(0.0, 127.0);

  this.m_btnOutfitManager.RegisterToCallback(n"OnClick", this, n"OnOutfitManagerClick");

  this.RefreshOutfitSlot();
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  this.m_btnOutfitManager.UnregisterFromCallback(n"OnClick", this, n"OnOutfitManagerClick");
}

@addMethod(gameuiInventoryGameController)
private func SetupOutfitManagerButton(button: ref<inkWidget>, icon: CName, labelKey: CName) -> Void {
  let controller: ref<MenuItemController> = button.GetController() as MenuItemController;
  let data: MenuData;
  data.label = GetLocalizedTextByKey(labelKey);
  data.icon = icon;
  data.fullscreenName = n"inventory_screen";
  data.identifier = EnumInt(HubMenuItems.Inventory);
  data.parentIdentifier = EnumInt(HubMenuItems.None);
  controller.Init(data);
  controller.SetHyperlink(false);
}

@addMethod(gameuiInventoryGameController)
protected cb func OnOutfitManagerClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    if !IsDefined(this.m_outfitManagerWidget) {
      this.m_outfitManagerWidget = this.SpawnFromExternal(this.GetRootCompoundWidget(), r"base\\gameplay\\gui\\ex\\outfit_ctrl.inkwidget", n"Root");
    };
    this.m_outfitManagerActive = true;
    this.EnableOutfitManagerMode();
  };
}

@addMethod(gameuiInventoryGameController)
private func EnableOutfitManagerMode() -> Void {
  this.PlayShowHideItemChooserAnimation(true);
  this.ZoomCamera(EnumInt(InventoryPaperdollZoomArea.Default));
  this.PlaySlidePaperdollAnimation(PaperdollPositionAnimation.LeftFullBody, true);
  this.PlayLibraryAnimation(n"default_wrapper_outro");
  this.PlayLibraryAnimation(n"inventory_grid_intro");

  this.GetRootCompoundWidget().GetWidget(n"item_wrapper/main_wrapper").SetVisible(false);
  this.m_buttonHintsController.Hide();
  this.m_outfitManagerWidget.SetVisible(true);
}

@addMethod(gameuiInventoryGameController)
private func DisableOutfitManagerMode() -> Void {
  this.GetRootCompoundWidget().GetWidget(n"item_wrapper/main_wrapper").SetVisible(true);
  this.m_buttonHintsController.Show();
  this.m_outfitManagerWidget.SetVisible(false);

  this.PlayShowHideItemChooserAnimation(false);
  this.ZoomCamera(EnumInt(InventoryPaperdollZoomArea.Default));
  this.PlaySlidePaperdollAnimation(PaperdollPositionAnimation.Center, false);
  this.PlayLibraryAnimation(n"default_wrapper_Intro");
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
  if this.m_outfitManagerActive {
    this.m_outfitManagerActive = false;
    this.DisableOutfitManagerMode();
    this.RefreshOutfitSlot();
    return true;
  };

  return wrappedMethod(userData);
}
