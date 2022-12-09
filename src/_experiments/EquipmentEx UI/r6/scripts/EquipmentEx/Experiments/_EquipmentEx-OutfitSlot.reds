import EquipmentEx.OutfitSystem

@addField(InventoryItemDisplayController)
private let m_activeLabel: ref<inkText>;

@addField(InventoryItemDisplayController)
private let m_outfitVisualsActive: Bool;

@wrapMethod(gameuiInventoryGameController)
private final func PopulateArea(targetRoot: wref<inkCompoundWidget>, container: ref<EquipmentAreaDisplays>, numberOfSlots: Int32, equipmentAreas: array<gamedataEquipmentArea>) -> Void {
  wrappedMethod(targetRoot, container, numberOfSlots, equipmentAreas);
  this.RefreshOutfitSlot();
}

@addMethod(gameuiInventoryGameController)
private func RefreshOutfitSlot() -> Void {
  let isOutfitVisualsActive: Bool = this.outfitSystem.IsActive();
  let equipmentAreaDisplays: ref<EquipmentAreaDisplays> = this.GetEquipementAreaDisplays(gamedataEquipmentArea.Outfit);
  let i: Int32 = 0;

  while i < ArraySize(equipmentAreaDisplays.displayControllers) {
    equipmentAreaDisplays.displayControllers[i].SetOutfitManagerState(isOutfitVisualsActive);
    i += 1;
  };
}

@addMethod(gameuiInventoryGameController)
private func HandleOutfitSlotClick() -> Void {
  if this.outfitSystem.IsActive() {
    this.outfitSystem.Deactivate();
  } else {
    this.outfitSystem.Reactivate();
  };

  this.PlaySound(n"Button", n"OnPress");
  this.RefreshOutfitSlot();
  this.RefreshOutfitSlotHint();
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  if Equals(evt.display.m_equipmentArea, gamedataEquipmentArea.Outfit) {
    if evt.actionName.IsAction(n"unequip_item") {
      this.HandleOutfitSlotClick();
    };
    return false;
  };

  return wrappedMethod(evt);
}

@addMethod(InventoryItemDisplayController)
public func SetOutfitManagerState(active: Bool) -> Void {
  this.m_outfitVisualsActive = active;
  this.InvalidateContent();
}

@wrapMethod(InventoryItemDisplayController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.m_activeLabel = new inkText();
  this.m_activeLabel.SetName(n"OutfitActiveLabel");
  this.m_activeLabel.SetFontSize(34);
	this.m_activeLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
	this.m_activeLabel.SetFontStyle(n"Medium");
  this.m_activeLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.m_activeLabel.BindProperty(n"tintColor", n"MainColors.Orange");
  this.m_activeLabel.SetMargin(35.0, 10.0, 0.0, 0.0);
  this.m_activeLabel.SetAnchor(inkEAnchor.TopLeft);
  this.m_activeLabel.Reparent(this.GetRootCompoundWidget(), 0);
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() -> Void {
  wrappedMethod();
  this.RefreshOutfitManagerDisplaying();
}

@addMethod(InventoryItemDisplayController)
private func RefreshOutfitManagerDisplaying() -> Void {
  if NotEquals(this.m_equipmentArea, gamedataEquipmentArea.Outfit) {
    return ;
  };

  let enabled: Bool = this.m_outfitVisualsActive;
  // Placeholder
  let emptyItemImage: ref<inkImage> = inkWidgetRef.Get(this.m_itemEmptyImage) as inkImage;
  InkImageUtils.RequestSetImage(this, emptyItemImage, n"UIIcon.WardrobeOutfitSilhouette");
  emptyItemImage.SetVisible(enabled);
  emptyItemImage.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  if enabled {
    emptyItemImage.BindProperty(n"tintColor", n"MainColors.Gold");
    this.m_activeLabel.SetText(GetLocalizedTextByKey(n"UI-ScriptExports-Active"));
  } else {
    emptyItemImage.UnbindProperty(n"tintColor");
    this.m_activeLabel.SetText(GetLocalizedTextByKey(n"UI-ScriptExports-Inactive0"));
  };

  // Equipped
  let i: Int32 = 0;
  while i < ArraySize(this.m_equippedWidgets) {
    inkWidgetRef.SetVisible(this.m_equippedWidgets[i], enabled);
    i += 1;
  };
  i = 0;
  while i < ArraySize(this.m_hideWhenEquippedWidgets) {
    inkWidgetRef.SetVisible(this.m_hideWhenEquippedWidgets[i], !enabled);
    i += 1;
  };
  inkWidgetRef.SetVisible(this.m_equippedMarker, enabled);

  // Iconic tint
  inkWidgetRef.SetVisible(this.m_iconicTint, enabled);
}

@wrapMethod(InventoryItemModeLogicController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  wrappedMethod(evt);
  if Equals(evt.display.GetEquipmentArea(), gamedataEquipmentArea.Outfit) {
    GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(new OutfitSlotHoverEvent());
  };
}

@addMethod(gameuiInventoryGameController)
protected cb func OnOutfitSlotHoverEvent(evt: ref<OutfitSlotHoverEvent>) -> Bool {
  this.RefreshOutfitSlotHint();
}

@addMethod(gameuiInventoryGameController)
protected cb func RefreshOutfitSlotHint() -> Bool {
  this.m_buttonHintsController.RemoveButtonHint(n"unequip_item");
  if OutfitSystem.GetInstance(this.m_player.GetGame()).IsActive() {
    this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
  } else {
    this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Equip"));
  };
}
