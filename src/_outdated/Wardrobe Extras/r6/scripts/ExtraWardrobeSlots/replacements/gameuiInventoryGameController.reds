@replaceMethod(gameuiInventoryGameController)
private final func RefreshUI() -> Void {
  let categoryAreas: array<wref<InventoryItemDisplayEquipmentArea>>;
  let clothingSet: gameWardrobeClothingSetIndexExtra;
  let displays: array<ref<InventoryItemDisplayController>>;
  let equipmentAreas: array<gamedataEquipmentArea>;
  let equippedClothingSetIndex: Int32;
  let i: Int32;
  let isLockedArea: Bool;
  let isOutfitSlot: Bool;
  let j: Int32;
  let k: Int32;
  let wardrbeSetChanged: Bool;
  let outfit: ItemID = this.m_InventoryManager.GetEquippedItemIdInArea(gamedataEquipmentArea.Outfit);
  let isOutfitEquipped: Bool = ItemID.IsValid(outfit);
  this.HideTooltips();
  this.RefreshEquippedWardrobeItems();
  clothingSet = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetActiveClothingSetIndex();
  equippedClothingSetIndex = WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(clothingSet);
  wardrbeSetChanged = equippedClothingSetIndex != this.m_lastClothingSetIndex;
  i = 0;
  while i < ArraySize(this.m_equipmentAreaCategories) {
    isLockedArea = false;
    displays = this.m_equipmentAreaCategories[i].GetDisplays();
    categoryAreas = this.m_equipmentAreaCategories[i].parentCategory.GetCategoryAreas();
    j = 0;
    while j < ArraySize(categoryAreas) {
      equipmentAreas = categoryAreas[j].GetEquipmentAreas();
      k = 0;
      while k < ArraySize(equipmentAreas) {
        if this.IsAreaLockedByOutfit(equipmentAreas[k]) {
          isLockedArea = true;
        };
        k += 1;
      };
      j += 1;
    };
    j = 0;
    while j < ArraySize(displays) {
      isOutfitSlot = Equals(displays[j].GetEquipmentArea(), gamedataEquipmentArea.Outfit);
      if isOutfitSlot || !wardrbeSetChanged {
        displays[j].InvalidateContent(isOutfitSlot, equippedClothingSetIndex);
      };
      displays[j].SetLocked(isOutfitEquipped && isLockedArea);
      displays[j].SetTransmoged(ArrayContains(this.m_wardrobeOutfitAreas, displays[j].GetEquipmentArea()));
      j += 1;
    };
    i += 1;
  };
  this.m_lastClothingSetIndex = equippedClothingSetIndex;
}

@replaceMethod(gameuiInventoryGameController)
private final func RefreshEquippedWardrobeItems() -> Void {
  let clothingSet: ref<ClothingSetExtra> = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetActiveClothingSet();
  ArrayClear(this.m_wardrobeOutfitAreas);
  if IsDefined(clothingSet) {
    ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Head);
    ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Face);
    ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.OuterChest);
    ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.InnerChest);
    ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Legs);
    ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Feet);
  };
}

@replaceMethod(gameuiInventoryGameController)
private final func PopulateArea(targetRoot: wref<inkCompoundWidget>, container: ref<EquipmentAreaDisplays>, numberOfSlots: Int32, equipmentAreas: array<gamedataEquipmentArea>) -> Void {
  let clothingSet: gameWardrobeClothingSetIndexExtra;
  let clothingSetIndex: Int32;
  let currentEquipmentArea: gamedataEquipmentArea;
  let equipedCyberwares: array<InventoryItemData>;
  let i: Int32;
  let slot: wref<InventoryItemDisplayController>;
  let outfit: ItemID = this.m_InventoryManager.GetEquippedItemIdInArea(gamedataEquipmentArea.Outfit);
  let isOutfitEquipped: Bool = ItemID.IsValid(outfit);
  let isOutfitSlot: Bool = ArrayContains(equipmentAreas, gamedataEquipmentArea.Outfit);
  if isOutfitSlot {
    clothingSet = WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetActiveClothingSetIndex();
    clothingSetIndex = WardrobeSystemExtra.WardrobeClothingSetIndexToNumber(clothingSet);
  } else {
    clothingSetIndex = -1;
  };
  while ArraySize(container.displayControllers) > numberOfSlots {
    slot = ArrayPop(container.displayControllers);
    targetRoot.RemoveChild(slot.GetRootWidget());
  };
  while ArraySize(container.displayControllers) < numberOfSlots {
    slot = ItemDisplayUtils.SpawnCommonSlotController(this, targetRoot, this.GetSlotType(equipmentAreas)) as InventoryItemDisplayController;
    ArrayPush(container.displayControllers, slot);
  };
  i = 0;
  while i < numberOfSlots {
    currentEquipmentArea = gamedataEquipmentArea.Invalid;
    if IsDefined(container.displayControllers[i]) {
      if InventoryDataManagerV2.IsEquipmentAreaCyberware(equipmentAreas) {
        equipedCyberwares = this.m_InventoryManager.GetInventoryCyberware();
        currentEquipmentArea = InventoryItemData.GetEquipmentArea(equipedCyberwares[i]);
        container.displayControllers[i].Bind(this.m_InventoryManager, currentEquipmentArea, i, ItemDisplayContext.GearPanel);
      } else {
        currentEquipmentArea = equipmentAreas[0];
        container.displayControllers[i].Bind(this.m_InventoryManager, currentEquipmentArea, i, ItemDisplayContext.GearPanel, clothingSetIndex > -1, clothingSetIndex);
      };
      container.displayControllers[i].BindComparisonAndScriptableSystem(this.m_uiScriptableSystem, this.m_comparisonResolver);
      container.displayControllers[i].SetLocked(isOutfitEquipped && this.IsAreaLockedByOutfit(currentEquipmentArea));
      container.displayControllers[i].SetTransmoged(ArrayContains(this.m_wardrobeOutfitAreas, currentEquipmentArea));
    };
    i += 1;
  };
}

@replaceMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  let hotkey: EHotkey;
  let itemData: InventoryItemData;
  let controller: wref<InventoryItemDisplayController> = evt.display;
  if Equals(this.m_mode, InventoryModes.Item) {
    return false;
  };
  if evt.actionName.IsAction(n"unequip_item") {
    itemData = controller.GetItemData();
    if Equals(controller.GetEquipmentArea(), gamedataEquipmentArea.Outfit) {
      if NotEquals(WardrobeSystemExtra.GetInstance(this.m_player.GetGame()).GetActiveClothingSetIndex(), gameWardrobeClothingSetIndexExtra.INVALID) {
        if this.m_InventoryManager.IsWardrobeEnabled() {
          this.WardrobeOutfitUnequipSet();
          return false;
        };
      };
    };
    if !InventoryItemData.IsEmpty(itemData) {
      this.m_InventoryManager.GetHotkeyTypeForItemID(InventoryItemData.GetID(itemData), hotkey);
      if NotEquals(hotkey, EHotkey.INVALID) {
        this.m_equipmentSystem.GetPlayerData(this.m_player).ClearItemFromHotkey(hotkey);
        this.NotifyItemUpdate(gamedataEquipmentArea.Invalid, 0, hotkey);
      } else {
        if this.IsEquipmentAreaCyberware(itemData) {
          return false;
        };
        if !InventoryGPRestrictionHelper.CanUse(itemData, this.m_player) || this.IsUnequipBlocked(InventoryItemData.GetID(itemData)) {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
          return false;
        };
        if controller.IsLocked() {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
          return false;
        };
        this.UnequipItem(controller, itemData);
      };
      this.PlaySound(n"ItemAdditional", n"OnUnequip");
    };
  } else {
    if evt.actionName.IsAction(n"select") || evt.actionName.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      if Equals(controller.GetEquipmentArea(), gamedataEquipmentArea.Invalid) {
        return false;
      };
      if controller.IsLocked() {
        this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
        return false;
      };
      itemData = controller.GetItemData();
      if InventoryDataManagerV2.IsEquipmentAreaCyberware(controller.GetEquipmentArea()) && (InventoryItemData.IsEmpty(itemData) || controller.GetAttachmentsSize() <= 0) {
        return false;
      };
      if !evt.toggleVisibilityRequest {
        this.OpenItemMode(controller.GetItemDisplayData());
      };
    };
  };
}

@replaceMethod(gameuiInventoryGameController)
private final func SetupSetButton() -> Void {
  let btnConrtoller: wref<MenuItemController>;
  let setLabel: String;
  let set: ref<ClothingSetExtra> = EquipmentSystem.GetActiveWardrobeSetExtra(this.m_player);
  if set != null && !ClothingSetExtra.IsEmpty(set) {
    btnConrtoller = inkWidgetRef.GetController(this.m_btnSets) as MenuItemController;
    setLabel = "#" + ToString(set.setID);
    btnConrtoller.UpdateButton(setLabel, set.iconID);
  };
}
