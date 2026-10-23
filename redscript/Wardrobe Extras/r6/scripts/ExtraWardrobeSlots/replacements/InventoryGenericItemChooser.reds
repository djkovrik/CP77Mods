@replaceMethod(InventoryGenericItemChooser)
protected func RefreshMainItem(opt overrideClothingSet: Bool, opt clothingSetIndex: Int32, opt showTransmogedIcon: Bool) -> Void {
  let clothingSet: gameWardrobeClothingSetIndexExtra;
  let equippedClothingSetIndex: Int32;
  let isOutfitSlot: Bool;
  if overrideClothingSet {
    equippedClothingSetIndex = clothingSetIndex;
  } else {
    isOutfitSlot = Equals(this.equipmentArea, gamedataEquipmentArea.Outfit);
    if isOutfitSlot {
      clothingSet = WardrobeSystemExtra.GetInstance(this.player.GetGame()).GetActiveClothingSetIndex();
      equippedClothingSetIndex = WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(clothingSet);
    } else {
      equippedClothingSetIndex = -1;
    };
  };
  if !IsDefined(this.itemDisplay) {
    inkCompoundRef.RemoveAllChildren(this.m_itemContainer);
    this.itemDisplay = ItemDisplayUtils.SpawnCommonSlotController(this, this.m_itemContainer, this.GetDisplayToSpawn()) as InventoryItemDisplayController;
    this.itemDisplay.Bind(this.inventoryDataManager, this.equipmentArea, this.slotIndex, ItemDisplayContext.GearPanel, equippedClothingSetIndex > -1, equippedClothingSetIndex);
    this.itemDisplay.SetTransmoged(showTransmogedIcon);
    this.itemDisplay.GetRootWidget().RegisterToCallback(n"OnRelease", this, n"OnItemInventoryClick");
    this.itemDisplay.GetRootWidget().RegisterToCallback(n"OnHoverOver", this, n"OnInventoryItemHoverOver");
    this.itemDisplay.GetRootWidget().RegisterToCallback(n"OnHoverOut", this, n"OnInventoryItemHoverOut");
    this.ChangeSelectedItem(this.itemDisplay);
  } else {
    this.itemDisplay.InvalidateContent(equippedClothingSetIndex > -1 || overrideClothingSet, equippedClothingSetIndex);
    this.itemDisplay.SetTransmoged(showTransmogedIcon);
  };
}
