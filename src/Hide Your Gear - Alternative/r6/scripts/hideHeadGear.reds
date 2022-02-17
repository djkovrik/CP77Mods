public static func ShouldHideHG(area: gamedataEquipmentArea) -> Bool {
  return
    Equals(area, gamedataEquipmentArea.Head) || 
    Equals(area, gamedataEquipmentArea.Face) ||
    Equals(area, gamedataEquipmentArea.Feet) || 
    Equals(area, gamedataEquipmentArea.Legs) || 
    Equals(area, gamedataEquipmentArea.InnerChest) || 
    Equals(area, gamedataEquipmentArea.OuterChest) || 
  false;
}

@replaceMethod(InventoryDataManagerV2)
public final func IsTransmogEnabled() -> Int32 {
  return 1;
}

@replaceMethod(InventoryItemDisplayController)
private final func UpdateTransmogControls(isEmpty: Bool) -> Void {
  let isItemHidden: Bool;
  let showHideIcon: Bool = ShouldHideHG(this.m_equipmentArea);
  if !inkWidgetRef.IsValid(this.m_transmogContainer) {
    return;
  };
  if !isEmpty && showHideIcon {
    if !IsDefined(this.m_btnHideAppearance) {
      this.m_btnHideAppearance = this.SpawnFromLocal(inkWidgetRef.Get(this.m_transmogContainer), n"hideButton");
      this.m_btnHideAppearanceCtrl = this.m_btnHideAppearance.GetControllerByType(n"TransmogButtonView") as TransmogButtonView;
    };
    isItemHidden = this.m_inventoryDataManager.IsSlotHidden(this.m_equipmentArea);
    this.m_btnHideAppearanceCtrl.SetActive(!isItemHidden);
  } else {
    if IsDefined(this.m_btnHideAppearance) {
      inkCompoundRef.RemoveAllChildren(this.m_transmogContainer);
      this.m_btnHideAppearance = null;
      this.m_btnHideAppearanceCtrl = null;
    };
  };
  if !isEmpty && this.m_inventoryDataManager.IsSlotOverriden(this.m_equipmentArea) {
    this.m_transmogItem = this.m_inventoryDataManager.GetVisualItemInSlot(this.m_equipmentArea);
  } else {
    this.m_transmogItem = ItemID.FromTDBID(t"");
  };
}

@replaceMethod(InventoryDataManagerV2)
public final func ToggleItemVisibility(area: gamedataEquipmentArea) -> Void {
  this.m_EquipmentSystem.GetPlayerData(this.m_Player).ToggleSlotVisibilityCustom(area);
}

@replaceMethod(InventoryDataManagerV2)
public final func IsSlotHidden(area: gamedataEquipmentArea) -> Bool {
  return this.m_EquipmentSystem.GetPlayerData(this.m_Player).GetSlotVisibilityCustom(area);
}


// -- [EquipmentSystemPlayerData]

@addField(EquipmentSystemPlayerData) private persistent let m_headToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_faceToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_feetToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_legsToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_innerChestToggleHG: Bool;
@addField(EquipmentSystemPlayerData) private persistent let m_outerChestToggleHG: Bool;

@addMethod(EquipmentSystemPlayerData)
public func GetSlotVisibilityCustom(area: gamedataEquipmentArea) -> Bool {
  switch (area) {
    case gamedataEquipmentArea.Head: return this.m_headToggleHG;
    case gamedataEquipmentArea.Face: return this.m_faceToggleHG;
    case gamedataEquipmentArea.Feet: return this.m_feetToggleHG;
    case gamedataEquipmentArea.Legs: return this.m_legsToggleHG;
    case gamedataEquipmentArea.InnerChest: return this.m_innerChestToggleHG;
    case gamedataEquipmentArea.OuterChest: return this.m_outerChestToggleHG;
    default: return false;
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetHeadSlotVisibilityHG(visible: Bool) -> Void {
  this.m_headToggleHG = visible;
  if this.IsVisualTagActive(n"hide_H1") {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Head);
  } else {
    this.ResetItemAppearanceEvent(gamedataEquipmentArea.Head);
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetFaceSlotVisibilityHG(visible: Bool) -> Void {
  this.m_faceToggleHG = visible;
  if this.IsVisualTagActive(n"hide_F1") {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Face);
  } else {
    this.ResetItemAppearanceEvent(gamedataEquipmentArea.Face);
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetFeetSlotVisibilityHG(visible: Bool) -> Void {
  this.m_feetToggleHG = visible;
  if this.IsVisualTagActive(n"hide_S1") {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Feet);
  } else {
    this.ResetItemAppearanceEvent(gamedataEquipmentArea.Feet);
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetLegsSlotVisibilityHG(visible: Bool) -> Void {
  this.m_legsToggleHG = visible;
  if this.IsVisualTagActive(n"hide_L1") {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Legs);
  } else {
    this.ResetItemAppearanceEvent(gamedataEquipmentArea.Legs);
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetInnerChestSlotVisibilityHG(visible: Bool) -> Void {
  this.m_innerChestToggleHG = visible;
  if this.IsVisualTagActive(n"hide_T1") {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.InnerChest);
  } else {
    this.ResetItemAppearanceEvent(gamedataEquipmentArea.InnerChest);
  };
}

@addMethod(EquipmentSystemPlayerData)
private func SetOuterChestSlotVisibilityHG(visible: Bool) -> Void {
  this.m_outerChestToggleHG = visible;
  if this.IsVisualTagActive(n"hide_T2") {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.OuterChest);
  } else {
    this.ResetItemAppearanceEvent(gamedataEquipmentArea.OuterChest);
  };
}

@addMethod(EquipmentSystemPlayerData)
public func ToggleSlotVisibilityCustom(area: gamedataEquipmentArea) -> Void {
  switch (area) {
    case gamedataEquipmentArea.Head:
      this.SetHeadSlotVisibilityHG(!this.m_headToggleHG);
      break;
    case gamedataEquipmentArea.Face:
      this.SetFaceSlotVisibilityHG(!this.m_faceToggleHG);
      break;
    case gamedataEquipmentArea.Feet:
      this.SetFeetSlotVisibilityHG(!this.m_feetToggleHG);
      break;
    case gamedataEquipmentArea.Legs:
      this.SetLegsSlotVisibilityHG(!this.m_legsToggleHG);
      break;
    case gamedataEquipmentArea.InnerChest:
      this.SetInnerChestSlotVisibilityHG(!this.m_innerChestToggleHG);
      break;
    case gamedataEquipmentArea.OuterChest:
      this.SetOuterChestSlotVisibilityHG(!this.m_outerChestToggleHG);
      break;
    default:
      break;
  };
}
@addMethod(EquipmentSystemPlayerData)
private func ShouldHideAreaByTag(tag: CName) -> Bool {
  if Equals(tag, n"hide_H1") { return this.m_headToggleHG; }
  if Equals(tag, n"hide_F1") { return this.m_faceToggleHG; }
  if Equals(tag, n"hide_S1") { return this.m_feetToggleHG; }
  if Equals(tag, n"hide_L1") { return this.m_legsToggleHG; }
  if Equals(tag, n"hide_T1") { return this.m_innerChestToggleHG; }
  if Equals(tag, n"hide_T2") { return this.m_outerChestToggleHG; }

  return false;
}

@wrapMethod(EquipmentSystemPlayerData)
private final func IsVisualTagActive(tag: CName) -> Bool {
  if this.ShouldHideAreaByTag(tag) {
    return true;
  } else {
    return wrappedMethod(tag);
  };
}
