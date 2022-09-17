@addField(InventoryItemModeLogicController)
private let m_wardrobeSystemExtra: wref<WardrobeSystemExtra>;

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnEquipmentInProgress(inProgress: Bool) -> Bool {
  let isSetDefined: Bool;
  let isSetEquipped: Bool;
  let targetSet: gameWardrobeClothingSetIndexExtra;
  let activeSet: wref<ClothingSetExtra> = this.m_wardrobeSystemExtra.GetActiveClothingSet();
  let sets: array<ref<ClothingSetExtra>> = this.m_wardrobeSystemExtra.GetClothingSets();
  let i: Int32 = 0;
  let limit: Int32 = ArraySize(this.m_wardrobeOutfitSlotControllers);
  while i < limit {
    targetSet = WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(this.m_wardrobeOutfitSlotControllers[i].GetIndex());
    if inProgress {
      isSetDefined = false;
    } else {
      isSetDefined = this.IsWardrobeSetDefinedExtra(sets, targetSet);
    };
    if activeSet == null {
      isSetEquipped = false;
    } else {
      isSetEquipped = Equals(activeSet.setID, targetSet);
    };
    this.m_wardrobeOutfitSlotControllers[i].Update(isSetDefined, isSetEquipped);
    i += 1;
  };
}

@replaceMethod(InventoryItemModeLogicController)
private final func UpdateOutfitWardrobe(active: Bool, activeSetOverride: Int32) -> Void {
  let slotsPerRow: Int32 = 7;
  let slotsTotal: Int32 = slotsPerRow * 2;
  let activeSet: wref<ClothingSetExtra>;
  let i: Int32;
  let isSetDefined: Bool;
  let isSetEquipped: Bool;
  let limit: Int32;
  let sets: array<ref<ClothingSetExtra>>;
  let spawnData: ref<OutfitWardrobeSlotSpawnData>;
  let targetSet: gameWardrobeClothingSetIndexExtra;
  inkWidgetRef.SetVisible(this.m_wardrobeSlotsContainer, active);
  inkWidgetRef.SetVisible(this.m_wardrobeSlotsLabel, active);
  inkWidgetRef.SetVisible(this.m_filterButtonsGrid, !active);
  inkWidgetRef.SetVisible(this.m_outfitsFilterInfoText, active);
  if active {
    sets = this.m_wardrobeSystemExtra.GetClothingSets();
    if activeSetOverride >= 0 {
      activeSet = this.GetClothingSetByIndexExtra(sets, activeSetOverride);
    } else {
      if activeSetOverride == -2 {
        activeSet = this.m_wardrobeSystemExtra.GetActiveClothingSet();
      };
    };
    if !this.m_outfitWardrobeSpawned {
      i = 0;
      while i < slotsTotal {
        targetSet = WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(i);
        spawnData = new OutfitWardrobeSlotSpawnData();
        spawnData.index = i;
        spawnData.active = this.IsWardrobeSetDefinedExtra(sets, targetSet);
        spawnData.isNew = this.m_uiScriptableSystem.IsWardrobeSetNewExtra(targetSet);
        if activeSet == null {
          spawnData.equipped = false;
        } else {
          spawnData.equipped = Equals(activeSet.setID, targetSet);
        };
        this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_wardrobeSlotsContainer), n"wardrobeOutfitSlot", this, n"OnOutfitWardrobeSlotSpawned", spawnData);
        i += 1;
      };
      this.m_outfitWardrobeSpawned = true;
      // Resize container
      let containerWidget: ref<inkHorizontalPanel> = inkWidgetRef.Get(this.m_wardrobeSlotsContainer) as inkHorizontalPanel;
      containerWidget.SetScale(new Vector2(0.75, 0.75));
      containerWidget.SetMargin(new inkMargin(-80.0, -40.0, 0.0, 80.0));
    } else {
      i = 0;
      limit = ArraySize(this.m_wardrobeOutfitSlotControllers);
      while i < limit {
        targetSet = WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(this.m_wardrobeOutfitSlotControllers[i].GetIndex());
        isSetDefined = this.IsWardrobeSetDefinedExtra(sets, targetSet);
        if activeSet == null {
          isSetEquipped = false;
        } else {
          isSetEquipped = Equals(activeSet.setID, targetSet);
        };
        this.m_wardrobeOutfitSlotControllers[i].Update(isSetDefined, isSetEquipped);
        i += 1;
      };
    };
  };
}

// Rearrange 7-14 slots
@replaceMethod(InventoryItemModeLogicController)
protected cb func OnOutfitWardrobeSlotSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  let slotsPerRow: Int32 = 7;
  let controller: wref<WardrobeOutfitSlotController> = widget.GetController() as WardrobeOutfitSlotController;
  let spawnData: wref<OutfitWardrobeSlotSpawnData> = userData as OutfitWardrobeSlotSpawnData;
  ArrayPush(this.m_wardrobeOutfitSlotControllers, controller);
  controller.Setup(spawnData.index, spawnData.active, spawnData.equipped, spawnData.isNew);

  if spawnData.index > 6 {
    widget.SetTranslation(-widget.GetWidth() * Cast<Float>(slotsPerRow) - Cast<Float>(Abs(Cast<Int32>(widget.GetWidth()))) / 4.0 - 7.5, widget.GetHeight() + 10.0);
  };
}

@addMethod(InventoryItemModeLogicController)
private final func GetClothingSetByIndexExtra(sets: array<ref<ClothingSetExtra>>, targetIndex: Int32) -> ref<ClothingSetExtra> {
  let targetSet: gameWardrobeClothingSetIndexExtra = WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(targetIndex);
  let i: Int32 = 0;
  let limit: Int32 = ArraySize(sets);
  while i < limit {
    if Equals(sets[i].setID, targetSet) {
      return sets[i];
    };
    i += 1;
  };
  return null;
}

@addMethod(InventoryItemModeLogicController)
private final func IsWardrobeSetDefinedExtra(sets: array<ref<ClothingSetExtra>>, targetSet: gameWardrobeClothingSetIndexExtra) -> Bool {
  let i: Int32 = 0;
  let limit: Int32 = ArraySize(sets);
  while i < limit {
    if Equals(sets[i].setID, targetSet) {
      return true;
    };
    i += 1;
  };
  return false;
}

@addMethod(InventoryItemModeLogicController)
private final func WardrobeOutfitEquipSetExtra(setID: gameWardrobeClothingSetIndexExtra) -> Void {
  let req: ref<EquipWardrobeSetRequest> = new EquipWardrobeSetRequest();
  req.setIDExtra = setID;
  req.owner = this.m_player;
  if IsDefined(this.m_delaySystem) {
    this.m_delaySystem.CancelCallback(this.m_delayedTimeoutCallbackId);
    this.m_delayedTimeoutCallbackId = this.m_delaySystem.DelayScriptableSystemRequest(n"EquipmentSystem", req, this.m_timeoutPeroid, false);
  };
}

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnWardrobeOutfitSlotClicked(e: ref<WardrobeOutfitSlotClickedEvent>) -> Bool {
  if this.m_InventoryManager.IsWardrobeEnabled() {
    if e.equipped {
      this.WardrobeOutfitUnequipSet();
      this.UpdateOutfitWardrobe(true, -1);
      this.itemChooser.RefreshItems(true, -1);
    } else {
      this.WardrobeOutfitEquipSetExtra(WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(e.index));
      this.UpdateOutfitWardrobe(true, e.index);
      this.itemChooser.RefreshItems(true, e.index);
    };
  } else {
    this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
  };
}

@addField(UIScriptableSystemWardrobeSetInspected)
public let wardrobeSetExtra: gameWardrobeClothingSetIndexExtra;

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnWardrobeOutfitSlotHoverOver(e: ref<WardrobeOutfitSlotHoverOverEvent>) -> Bool {
  let setInspectedEvent: ref<UIScriptableSystemWardrobeSetInspected>;
  let dummyData: ref<DummyTooltipData> = new DummyTooltipData();
  this.m_TooltipsManager.ShowTooltipAtWidget(n"outfitWardrobeInfoTooltip", e.evt.GetTarget(), dummyData, gameuiETooltipPlacement.RightTop);
  if e.controller.IsNew() {
    setInspectedEvent = new UIScriptableSystemWardrobeSetInspected();
    setInspectedEvent.wardrobeSetExtra = WardrobeSystemExtra.NumberToWardrobeClothingSetIndex(e.controller.GetIndex());
    this.m_uiScriptableSystem.QueueRequest(setInspectedEvent);
    e.controller.SetIsNew(false);
  };
}

@wrapMethod(InventoryItemModeLogicController)
public final func SetupData(buttonHints: wref<ButtonHints>, tooltipsManager: wref<gameuiTooltipsManager>, inventoryManager: ref<InventoryDataManagerV2>, player: wref<PlayerPuppet>) -> Void {
  wrappedMethod(buttonHints, tooltipsManager, inventoryManager, player);
  this.m_wardrobeSystemExtra = WardrobeSystemExtra.GetInstance(this.m_player.GetGame());
}

@replaceMethod(InventoryItemModeLogicController)
public final func CreateItemChooser(displayData: InventoryItemDisplayData, dataSource: ref<InventoryDataManagerV2>) -> ref<InventoryGenericItemChooser> {
  let itemChooserRet: ref<InventoryGenericItemChooser>;
  let showTransmogedIcon: Bool;
  let itemChooserToCreate: CName = n"genericItemChooser";
  switch displayData.m_equipmentArea {
    case gamedataEquipmentArea.Weapon:
      itemChooserToCreate = n"weaponItemChooser";
      break;
    case gamedataEquipmentArea.EyesCW:
    case gamedataEquipmentArea.HandsCW:
    case gamedataEquipmentArea.ArmsCW:
    case gamedataEquipmentArea.SystemReplacementCW:
      itemChooserToCreate = n"cyberwareModsChooser";
  };
  inkCompoundRef.RemoveAllChildren(this.m_itemCategoryList);
  if NotEquals(this.m_wardrobeSystemExtra.GetActiveClothingSetIndex(), gameWardrobeClothingSetIndexExtra.INVALID) {
    showTransmogedIcon = true;
  };
  itemChooserRet = this.SpawnFromLocal(inkWidgetRef.Get(this.m_itemCategoryList), itemChooserToCreate).GetController() as InventoryGenericItemChooser;
  itemChooserRet.Bind(this.m_player, dataSource, displayData.m_equipmentArea, displayData.m_slotIndex, this.m_TooltipsManager, showTransmogedIcon);
  return itemChooserRet;
}

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnItemChooserUnequipItem(evt: ref<ItemChooserUnequipItem>) -> Bool {
  let equipedItem: InventoryItemData = this.itemChooser.GetModifiedItemData();
  if !InventoryGPRestrictionHelper.CanEquip(equipedItem, this.m_player) || this.IsUnequipBlocked(InventoryItemData.GetID(equipedItem)) {
    this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
    return false;
  };
  if NotEquals(this.m_currentHotkey, EHotkey.INVALID) {
    this.m_equipmentSystem.GetPlayerData(this.m_player).ClearItemFromHotkey(this.m_currentHotkey);
    this.RefreshAvailableItems();
    this.NotifyItemUpdate();
    this.itemChooser.RefreshItems();
  } else {
    if ArrayContains(this.m_lastEquipmentAreas, gamedataEquipmentArea.Outfit) {
      if NotEquals(this.m_wardrobeSystemExtra.GetActiveClothingSetIndex(), gameWardrobeClothingSetIndexExtra.INVALID) {
        if this.m_InventoryManager.IsWardrobeEnabled() {
          this.WardrobeOutfitUnequipSet();
          this.UpdateOutfitWardrobe(true, -1);
          this.itemChooser.RefreshItems(true, -1);
        } else {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
        };
        return false;
      };
    };
    this.UnequipItem(this.itemChooser.GetModifiedItem(), equipedItem);
  };
}

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  let equippedItem: InventoryItemData;
  let iconPath: String;
  let iconsNameResolver: ref<IconsNameResolver>;
  let isClothing: Bool;
  let itemTransmogRecord: wref<Item_Record>;
  let msgTooltipData: ref<MessageTooltipData>;
  let noTransmogIcon: Bool;
  let resolvedIcon: CName;
  let transmogItem: ItemID;
  let transmogMsgTooltipData: ref<TransmogMessageTooltipData>;
  let useMaleIcon: Bool;
  let useTransmogTooltip: Bool;
  this.m_lastItemHoverOverEvent = evt;
  let skipCompare: Bool = !this.m_isShown || Equals(evt.display.GetDisplayContext(), ItemDisplayContext.Attachment) || this.m_isComparisionDisabled;
  let isEmpty: Bool = InventoryItemData.IsEmpty(evt.itemData);
  if !InventoryItemData.IsEmpty(evt.itemData) {
    this.RequestItemInspected(InventoryItemData.GetID(evt.itemData));
  };
  if evt.toggleVisibilityControll {
    msgTooltipData = new MessageTooltipData();
    if evt.isItemHidden {
      msgTooltipData.Title = GetLocalizedText("UI-Inventory-Tooltips-ShowItem");
    } else {
      msgTooltipData.Title = GetLocalizedText("UI-Inventory-Tooltips-HideItem");
    };
    this.m_TooltipsManager.ShowTooltipAtWidget(0, evt.widget, msgTooltipData, gameuiETooltipPlacement.RightTop, true, new inkMargin(2.00, 0.00, 0.00, 0.00));
  } else {
    if !isEmpty {
      equippedItem = this.itemChooser.GetSelectedItem().GetItemData();
      if this.m_InventoryManager.IsSlotOverriden(evt.display.GetEquipmentArea()) {
        transmogItem = this.m_InventoryManager.GetVisualItemInSlot(evt.display.GetEquipmentArea());
      };
      this.ShowTooltipsForItemData(equippedItem, evt.widget, evt.itemData, skipCompare, evt.display.DEBUG_GetIconErrorInfo(), evt.display, transmogItem);
    } else {
      iconsNameResolver = IconsNameResolver.GetIconsNameResolver();
      useMaleIcon = Equals(this.m_InventoryManager.GetIconGender(), ItemIconGender.Male);
      isClothing = this.IsEquipmentAreaClothing(evt.display.GetEquipmentArea());
      transmogItem = this.m_InventoryManager.GetVisualItemInSlot(evt.display.GetEquipmentArea());
      if isClothing {
        if ItemID.IsValid(transmogItem) {
          itemTransmogRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(transmogItem));
          iconPath = itemTransmogRecord.IconPath();
          useTransmogTooltip = true;
        } else {
          if NotEquals(this.m_wardrobeSystemExtra.GetActiveClothingSetIndex(), gameWardrobeClothingSetIndexExtra.INVALID) {
            noTransmogIcon = true;
            useTransmogTooltip = true;
          };
        };
      };
      if IsStringValid(iconPath) {
        resolvedIcon = StringToName("UIIcon." + iconPath);
      } else {
        if ItemID.IsValid(transmogItem) {
          resolvedIcon = iconsNameResolver.TranslateItemToIconName(ItemID.GetTDBID(transmogItem), useMaleIcon);
        };
        resolvedIcon = StringToName("UIIcon." + NameToString(resolvedIcon));
      };
      if isClothing && useTransmogTooltip {
        transmogMsgTooltipData = this.m_InventoryManager.GetTransmogTooltipForEmptySlot(evt.display.GetSlotName(), transmogItem, resolvedIcon, noTransmogIcon);
        this.m_TooltipsManager.ShowTooltipAtWidget(n"descriptionTooltipV3Transmog", evt.widget, transmogMsgTooltipData, gameuiETooltipPlacement.RightTop, true, new inkMargin(2.00, 0.00, 0.00, 0.00));
      } else {
        msgTooltipData = this.m_InventoryManager.GetTooltipForEmptySlot(evt.display.GetSlotName());
        this.m_TooltipsManager.ShowTooltipAtWidget(0, evt.widget, msgTooltipData, gameuiETooltipPlacement.RightTop, true, new inkMargin(2.00, 0.00, 0.00, 0.00));
      };
    };
  };
  this.SetInventoryItemButtonHintsHoverOver(evt.itemData, evt.display);
  if InventoryItemData.IsEmpty(evt.itemData) && TDBID.IsValid(evt.display.GetSlotID()) {
    this.m_buttonHintsController.AddButtonHint(n"select", GetLocalizedText("UI-UserActions-Select"));
  };
}

@replaceMethod(InventoryItemModeLogicController)
private final func HandleItemClick(itemData: InventoryItemData, actionName: ref<inkActionName>, opt displayContext: ItemDisplayContext) -> Void {
  let isEquippedItemBlocked: Bool;
  let item: ItemModParams;
  let shouldUpdate: Bool;
  if actionName.IsAction(n"drop_item") {
    if !InventoryItemData.IsEquipped(itemData) && RPGManager.CanItemBeDropped(this.m_player, InventoryItemData.GetGameItemData(itemData)) {
      if InventoryItemData.GetQuantity(itemData) > 1 {
        this.OpenQuantityPicker(itemData, QuantityPickerActionType.Drop);
      } else {
        item.itemID = InventoryItemData.GetID(itemData);
        item.quantity = 1;
        this.AddToDropQueue(item);
        this.RefreshAvailableItems(ItemViewModes.Item, true);
        this.PlaySound(n"Item", n"OnDrop");
      };
    };
  } else {
    if actionName.IsAction(n"equip_item") && NotEquals(displayContext, ItemDisplayContext.Attachment) && !(InventoryItemData.IsEquipped(itemData) && Equals(this.m_currentHotkey, EHotkey.INVALID)) {
      shouldUpdate = true;
      isEquippedItemBlocked = InventoryItemData.GetGameItemData(this.itemChooser.GetModifiedItemData()).HasTag(n"UnequipBlocked");
      if isEquippedItemBlocked || !InventoryGPRestrictionHelper.CanEquip(itemData, this.m_player) {
        this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
        return;
      };
      this.EquipItem(itemData, this.itemChooser.GetSlotIndex());
      if ArrayContains(this.m_lastEquipmentAreas, gamedataEquipmentArea.Outfit) {
        if NotEquals(this.m_wardrobeSystemExtra.GetActiveClothingSetIndex(), gameWardrobeClothingSetIndexExtra.INVALID) && InventoryItemData.IsEmpty(itemData) {
          shouldUpdate = false;
        };
      };
      this.itemChooser.RefreshItems(shouldUpdate, -1);
      this.RefreshAvailableItems();
      this.NotifyItemUpdate();
    };
  };
}
