// -- New fields

@addField(EquipmentSystemPlayerData) private persistent let m_headToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_faceToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_feetToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_legsToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_innerChestToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_outerChestToggleHG: Bool;
@addField(InventoryItemDisplayController) private let m_btnHideAppearanceCtrl: wref<TransmogButtonView>;
@addField(InventoryItemDisplayController) private let m_btnHideAppearance: wref<inkWidget>;


// -- Restoring toggle controls

@replaceMethod(InventoryItemDisplayController)
protected cb func OnDelayedHoverOver(proxy: ref<inkAnimProxy>) -> Bool {
  let DLCAddedHoverOverEvent: ref<DLCAddedItemDisplayHoverOverEvent>;
  let parentButton: wref<inkButtonController>;
  let hoverOverEvent: ref<ItemDisplayHoverOverEvent> = new ItemDisplayHoverOverEvent();
  hoverOverEvent.itemData = this.GetItemData();
  hoverOverEvent.display = this;
  hoverOverEvent.widget = this.m_hoverTarget;
  hoverOverEvent.isBuybackStack = this.m_isBuybackStack;
  hoverOverEvent.transmogItem = this.m_transmogItem;
  hoverOverEvent.isItemHidden = !this.m_btnHideAppearanceCtrl.IsActive();
  hoverOverEvent.uiInventoryItem = this.GetUIInventoryItem(); // merged from 1.6
  hoverOverEvent.displayContextData = this.m_displayContextData;  // merged from 1.6
  if this.m_hoverTarget == this.m_btnHideAppearance {
    hoverOverEvent.toggleVisibilityControll = true;
  };
  this.QueueEvent(hoverOverEvent);
  parentButton = this.GetParentButton();
  if !parentButton.GetAutoUpdateWidgetState() && !hoverOverEvent.toggleVisibilityControll {
    this.GetRootWidget().SetState(n"Hover");
  };
  if this.m_isNew {
    this.SetIsNew(false);
  };
  if this.m_isDLCNewItem {
    this.SetDLCNewIndicator(false);
    DLCAddedHoverOverEvent = new DLCAddedItemDisplayHoverOverEvent();
    DLCAddedHoverOverEvent.itemTDBID = ItemID.GetTDBID(this.GetItemID());
    this.QueueEvent(DLCAddedHoverOverEvent);
  };
  this.m_delayProxy = null;
}

@wrapMethod(InventoryItemDisplayController)
protected cb func OnDisplayClicked(evt: ref<inkPointerEvent>) -> Bool {
  if evt.GetTarget() == this.m_btnHideAppearance {
    let event: ref<ItemDisplayClickEvent> = new ItemDisplayClickEvent();
    event.itemData = this.GetItemData();
    event.actionName = evt.GetActionName();
    event.displayContext = this.m_itemDisplayContext;
    event.isBuybackStack = this.m_isBuybackStack;
    event.transmogItem = this.m_transmogItem;
    event.display = this;
    event.uiInventoryItem = this.GetUIInventoryItem();   // merged from 1.6
    event.displayContextData = this.m_displayContextData;   // merged from 1.6
    event.toggleVisibilityRequest = true;
    this.HandleLocalClick(evt);
    this.QueueEvent(event);
  } else {
    wrappedMethod(evt);
  }
}

@wrapMethod(InventoryItemModeLogicController)
protected cb func OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  // Restore toggle from 1.5
  if evt.toggleVisibilityRequest {
    if evt.actionName.IsAction(n"click") {
      this.m_InventoryManager.ToggleSlotHG(InventoryItemData.GetEquipmentArea(evt.itemData));
      this.PlaySound(n"Item", n"ItemGeneric");
    };
  } else {
    wrappedMethod(evt);
  };
}

@addMethod(InventoryItemDisplayController)
public func ShouldDisplayControl(area: gamedataEquipmentArea) -> Bool {
  return
    Equals(area, gamedataEquipmentArea.Head) || 
    Equals(area, gamedataEquipmentArea.Face) ||
    Equals(area, gamedataEquipmentArea.Feet) || 
    Equals(area, gamedataEquipmentArea.Legs) || 
    Equals(area, gamedataEquipmentArea.InnerChest) || 
    Equals(area, gamedataEquipmentArea.OuterChest) || 
  false;
}

@addMethod(InventoryItemDisplayController)
private final func UpdateTransmogControlsRestored() -> Void {
  let isItemHidden: Bool;
  let isSlotEmpty: Bool = this.m_inventoryDataManager.IsSlotEmptyHG(this.m_slotID);
  let showControl: Bool = this.ShouldDisplayControl(this.m_equipmentArea) && !this.m_isLocked;
  if !inkWidgetRef.IsValid(this.m_transmogContainer) {
    return;
  };
  if !isSlotEmpty && showControl {
    if !IsDefined(this.m_btnHideAppearance) {
      this.m_btnHideAppearance = this.SpawnFromLocal(inkWidgetRef.Get(this.m_transmogContainer), n"hideButton");
      this.m_btnHideAppearanceCtrl = this.m_btnHideAppearance.GetControllerByType(n"TransmogButtonView") as TransmogButtonView;
    };
    isItemHidden = this.m_inventoryDataManager.IsSlotHiddenHG(this.m_equipmentArea);
    this.m_btnHideAppearanceCtrl.SetActive(!isItemHidden);
  } else {
    if IsDefined(this.m_btnHideAppearance) {
      inkCompoundRef.RemoveAllChildren(this.m_transmogContainer);
      this.m_btnHideAppearance = null;
      this.m_btnHideAppearanceCtrl = null;
    };
  };
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() -> Void {
  wrappedMethod();
  this.UpdateTransmogControlsRestored();
}

public class ResetTransmogControlsEvent extends Event {}

@addMethod(InventoryItemDisplayController)
protected cb func OnResetTransmogControls(evt: ref<ResetTransmogControlsEvent>) -> Bool {
  this.UpdateTransmogControlsRestored();
}

// -- Custom helpers for InventoryDataManagerV2

@addMethod(InventoryDataManagerV2)
public func IsSlotEmptyHG(slotId: TweakDBID) -> Bool {
  return GameInstance.GetTransactionSystem(this.GetGame()).IsSlotEmpty(this.m_Player, slotId);
}

@addMethod(InventoryDataManagerV2)
public final func IsSlotHiddenHG(area: gamedataEquipmentArea) -> Bool {
  return this.m_EquipmentSystem.GetPlayerData(this.m_Player).IsSlotHiddenHG(area);
}

@addMethod(InventoryDataManagerV2)
public final func ToggleSlotHG(area: gamedataEquipmentArea) -> Void {
  this.m_EquipmentSystem.GetPlayerData(this.m_Player).ToggleSlotVisibilityHG(area);
}


// -- Handle slots in EquipmentSystemPlayerData

@addMethod(EquipmentSystemPlayerData)
public func IsSlotHiddenHG(area: gamedataEquipmentArea) -> Bool {
  let notCensored: Bool = this.IsBuildCensored();
  let showGenitals: Bool = this.ShouldShowGenitals();
  switch (area) {
    case gamedataEquipmentArea.Head: return this.m_headToggleHG;
    case gamedataEquipmentArea.Face: return this.m_faceToggleHG;
    case gamedataEquipmentArea.Feet: return this.m_feetToggleHG;
    case gamedataEquipmentArea.Legs: return this.m_legsToggleHG;
    case gamedataEquipmentArea.InnerChest: return this.m_innerChestToggleHG;
    case gamedataEquipmentArea.OuterChest: return this.m_outerChestToggleHG;
    case gamedataEquipmentArea.UnderwearBottom: return notCensored && showGenitals;
    case gamedataEquipmentArea.UnderwearTop: return notCensored;
    default: return false;
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetHeadSlotToggleHG(visible: Bool) -> Void {
  this.m_headToggleHG = visible;
  this.ToggleItemVisibility(gamedataEquipmentArea.Head, this.m_headToggleHG);
}

@addMethod(EquipmentSystemPlayerData)
private func SetFaceSlotToggleHG(visible: Bool) -> Void {
  this.m_faceToggleHG = visible;
  this.ToggleItemVisibility(gamedataEquipmentArea.Face, this.m_faceToggleHG);
}

@addMethod(EquipmentSystemPlayerData)
private func SetFeetSlotToggleHG(visible: Bool) -> Void {
  this.m_feetToggleHG = visible;
  this.ToggleItemVisibility(gamedataEquipmentArea.Feet, this.m_feetToggleHG);
}

@addMethod(EquipmentSystemPlayerData)
private func SetLegsSlotToggleHG(visible: Bool) -> Void {
  this.m_legsToggleHG = visible;
  this.ToggleItemVisibility(gamedataEquipmentArea.Legs, this.m_legsToggleHG);
}

@addMethod(EquipmentSystemPlayerData)
private func SetInnerChestSlotToggleHG(visible: Bool) -> Void {
  this.m_innerChestToggleHG = visible;
  this.ToggleItemVisibility(gamedataEquipmentArea.InnerChest, this.m_innerChestToggleHG);
}

@addMethod(EquipmentSystemPlayerData)
private func SetOuterChestSlotToggleHG(visible: Bool) -> Void {
  this.m_outerChestToggleHG = visible;
  this.ToggleItemVisibility(gamedataEquipmentArea.OuterChest, this.m_outerChestToggleHG);
}

@addMethod(EquipmentSystemPlayerData)
public func ToggleSlotVisibilityHG(area: gamedataEquipmentArea) -> Void {
  switch (area) {
    case gamedataEquipmentArea.Head:
      this.SetHeadSlotToggleHG(!this.m_headToggleHG);
      break;
    case gamedataEquipmentArea.Face:
      this.SetFaceSlotToggleHG(!this.m_faceToggleHG);
      break;
    case gamedataEquipmentArea.Feet:
      this.SetFeetSlotToggleHG(!this.m_feetToggleHG);
      break;
    case gamedataEquipmentArea.Legs:
      this.SetLegsSlotToggleHG(!this.m_legsToggleHG);
      break;
    case gamedataEquipmentArea.InnerChest:
      this.SetInnerChestSlotToggleHG(!this.m_innerChestToggleHG);
      break;
    case gamedataEquipmentArea.OuterChest:
      this.SetOuterChestSlotToggleHG(!this.m_outerChestToggleHG);
      break;
    default:
      break;
  };
}

@addMethod(EquipmentSystemPlayerData)
private func ToggleItemVisibility(area: gamedataEquipmentArea, shouldHide: Bool) {
  if shouldHide {
    this.ClearItemAppearanceEvent(area);
  } else {
    this.ResetItemAppearanceEvent(area);
  };
}

// -- Reset all toggles
@addMethod(EquipmentSystemPlayerData)
private func ResetAllTogglesHG() -> Void {
  this.SetHeadSlotToggleHG(false);
  this.SetFaceSlotToggleHG(false);
  this.SetFeetSlotToggleHG(false);
  this.SetLegsSlotToggleHG(false);
  this.SetInnerChestSlotToggleHG(false);
  this.SetOuterChestSlotToggleHG(false);
  GameInstance.GetUISystem((this.m_owner as PlayerPuppet).GetGame()).QueueEvent(new ResetTransmogControlsEvent());
}

// -- Reset toggles on wardrobe set equip
@wrapMethod(EquipmentSystemPlayerData)
public final func EquipWardrobeSet(setID: gameWardrobeClothingSetIndex) -> Void {
  this.ResetAllTogglesHG();
  wrappedMethod(setID);
}

// -- Reset toggles on wardrobe set unequip
@wrapMethod(EquipmentSystemPlayerData)
public final func UnequipWardrobeSet() -> Void {
  this.ResetAllTogglesHG();
  wrappedMethod();
}


@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  let data: wref<gameItemData> = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, itemID);
  if !this.IsEquippable(data) {
    return;
  };
  let index: Int32 = this.GetEquipAreaIndex(EquipmentSystem.GetEquipAreaType(itemID));
  let area: SEquipArea = this.m_equipment.equipAreas[index];

  // Reset all toggles on Outfit slot equip
  if Equals(area.areaType, gamedataEquipmentArea.Outfit) {
    this.ResetAllTogglesHG();
  };

  wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
}

// -- Disable toggle for specific area
@addMethod(EquipmentSystemPlayerData)
private func DisableToggleForAreaTypeHG(areaType: gamedataEquipmentArea) -> Void {
  switch areaType {
    case gamedataEquipmentArea.Head:
      this.SetHeadSlotToggleHG(false);
      break;
    case gamedataEquipmentArea.Face:
      this.SetFaceSlotToggleHG(false);
      break;
    case gamedataEquipmentArea.Feet:
      this.SetFeetSlotToggleHG(false);
      break;
    case gamedataEquipmentArea.Legs:
      this.SetLegsSlotToggleHG(false);
      break;
    case gamedataEquipmentArea.InnerChest:
      this.SetInnerChestSlotToggleHG(false);
      break;
    case gamedataEquipmentArea.OuterChest:
      this.SetOuterChestSlotToggleHG(false);
      break;
  };
}

// -- Reset toggle on item unequip
@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, opt slotIndex: Int32) -> Void {
  let area: SEquipArea = this.m_equipment.equipAreas[equipAreaIndex];
  let areaType: gamedataEquipmentArea = area.areaType;
  this.DisableToggleForAreaTypeHG(areaType);
  wrappedMethod(equipAreaIndex, slotIndex);
}

// -- Reset toggle on item unequip
@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(itemID: ItemID) -> Void {
  let index: Int32 = this.GetEquipAreaIndex(EquipmentSystem.GetEquipAreaType(itemID));
  let area: SEquipArea = this.m_equipment.equipAreas[index];
  let areaType: gamedataEquipmentArea = area.areaType;
  this.DisableToggleForAreaTypeHG(areaType);
  wrappedMethod(itemID);
}


// -- MISC FIXES

// Reset toggles on BD activation
@wrapMethod(HUDManager)
protected cb func OnBraindanceToggle(value: Bool) -> Bool {
  wrappedMethod(value);
  if value {
    EquipmentSystem.GetInstance(this.GetPlayer()).GetPlayerData(this.GetPlayer()).ResetAllTogglesHG();
  };
}


// Hide underwear after the game loaded
@addMethod(EquipmentSystemPlayerData)
private func ResetItemVisibility(area: gamedataEquipmentArea) {
  this.ResetItemAppearanceEvent(area);
}

public class EvaluateSlotsVisibilityCallback extends DelayCallback {
  public let playerData: wref<EquipmentSystemPlayerData>;

  public func Call() -> Void {
    this.playerData.ResetItemVisibility(gamedataEquipmentArea.Head);
    this.playerData.ResetItemVisibility(gamedataEquipmentArea.Face);
    this.playerData.ResetItemVisibility(gamedataEquipmentArea.Feet);
    this.playerData.ResetItemVisibility(gamedataEquipmentArea.Legs);
    this.playerData.ResetItemVisibility(gamedataEquipmentArea.InnerChest);
    this.playerData.ResetItemVisibility(gamedataEquipmentArea.OuterChest);

    this.playerData.ToggleItemVisibility(gamedataEquipmentArea.Head, this.playerData.IsSlotHiddenHG(gamedataEquipmentArea.Head));
    this.playerData.ToggleItemVisibility(gamedataEquipmentArea.Face, this.playerData.IsSlotHiddenHG(gamedataEquipmentArea.Face));
    this.playerData.ToggleItemVisibility(gamedataEquipmentArea.Feet, this.playerData.IsSlotHiddenHG(gamedataEquipmentArea.Feet));
    this.playerData.ToggleItemVisibility(gamedataEquipmentArea.Legs, this.playerData.IsSlotHiddenHG(gamedataEquipmentArea.Legs));
    this.playerData.ToggleItemVisibility(gamedataEquipmentArea.InnerChest, this.playerData.IsSlotHiddenHG(gamedataEquipmentArea.InnerChest));
    this.playerData.ToggleItemVisibility(gamedataEquipmentArea.OuterChest, this.playerData.IsSlotHiddenHG(gamedataEquipmentArea.OuterChest));
  }
}

@addField(EquipmentSystemPlayerData)
public let m_slotsRefreshDelayId: DelayID;

@addMethod(EquipmentSystemPlayerData)
public func ScheduleSlotsVisibilityRefresh(delay: Float) -> Void {
  let callback: ref<EvaluateSlotsVisibilityCallback> = new EvaluateSlotsVisibilityCallback();
  callback.playerData = this;
  GameInstance.GetDelaySystem(this.m_owner.GetGame()).CancelDelay(this.m_slotsRefreshDelayId);
  this.m_slotsRefreshDelayId = GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayCallback(callback, delay);
}


// Refresh on game loading
@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  EquipmentSystem.GetData(this).ScheduleSlotsVisibilityRefresh(1.0);
}
