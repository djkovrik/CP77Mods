@addField(gameuiInventoryGameController)
private let equipmentExWidget: ref<inkWidget>;

@addMethod(gameuiInventoryGameController)
private func IsTargetSlotArea(area: gamedataEquipmentArea) -> Bool {
  return Equals(area, gamedataEquipmentArea.Head) 
    || Equals(area, gamedataEquipmentArea.Face)
    || Equals(area, gamedataEquipmentArea.Legs)
    || Equals(area, gamedataEquipmentArea.Feet)
    || Equals(area, gamedataEquipmentArea.Outfit)
    || Equals(area, gamedataEquipmentArea.InnerChest)
    || Equals(area, gamedataEquipmentArea.OuterChest);
}

// TODO Replace with separate button? Now conflicts with Hide Your Gear
@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  let controller: wref<InventoryItemDisplayController> = evt.display;
  let area: gamedataEquipmentArea = controller.GetEquipmentArea();
  if this.IsTargetSlotArea(area) {
    if evt.actionName.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      this.ShowCustomSlotsMenu();
    };
  } else {
    wrappedMethod(evt);
  };
}

@addMethod(gameuiInventoryGameController)
private func ShowCustomSlotsMenu() -> Void {
  this.MovePaperdollToTheLeftAndHide();
  this.GetRootCompoundWidget().GetWidget(n"item_wrapper/main_wrapper").SetVisible(false);
  this.m_buttonHintsController.Hide();
  this.equipmentExWidget = this.SpawnFromExternal(this.GetRootCompoundWidget(), r"base\\gameplay\\gui\\ex\\outfit_ctrl.inkwidget", n"Root");
}

@addMethod(gameuiInventoryGameController)
private func MovePaperdollToTheLeftAndHide() -> Void {
  this.PlayShowHideItemChooserAnimation(true);
  this.ZoomCamera(EnumInt(InventoryPaperdollZoomArea.Default));
  this.PlaySlidePaperdollAnimation(PaperdollPositionAnimation.LeftFullBody, true);
  this.PlayLibraryAnimation(n"default_wrapper_outro");
  this.PlayLibraryAnimation(n"inventory_grid_intro");
}

@addMethod(gameuiInventoryGameController)
private func MovePaperdollBackToCenterAndShow() -> Void {
  this.PlayShowHideItemChooserAnimation(false);
  this.ZoomCamera(EnumInt(InventoryPaperdollZoomArea.Default));
  this.PlaySlidePaperdollAnimation(PaperdollPositionAnimation.Center, false);
  this.PlayLibraryAnimation(n"default_wrapper_Intro");
}


@wrapMethod(gameuiInventoryGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
  if IsDefined(this.equipmentExWidget) {
    this.GetRootCompoundWidget().RemoveChild(this.equipmentExWidget);
    this.GetRootCompoundWidget().GetWidget(n"item_wrapper/main_wrapper").SetVisible(true);
    this.equipmentExWidget = null;
    this.MovePaperdollBackToCenterAndShow();
    this.m_buttonHintsController.Show();
  } else {
    wrappedMethod(userData);
  };
}
