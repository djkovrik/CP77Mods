/////////////////////////////////////////////////////////////////////
// Show weapon roster and crouch indicator when weapon unsheathed  //
/////////////////////////////////////////////////////////////////////

@addMethod(PlayerPuppet)
public func HasAnyWeaponEquippedRoster() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(weapon) {
    if transactionSystem.HasTag(this, WeaponObject.GetMeleeWeaponTag(), weapon.GetItemID()) 
      || transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weapon.GetItemID()) {
        return true;
    };
  };
  return false;
}

@addMethod(CrouchIndicatorGameController)
public func ShowWidgets(show: Bool) -> Void {
  inkImageRef.SetVisible(this.m_crouchIcon, show);
}

@addMethod(weaponRosterGameController)
public func ShowWidgets(show: Bool) -> Void {
  inkImageRef.SetVisible(this.m_weaponIcon, show);
  inkImageRef.SetVisible(this.m_container, show);
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.m_Player.HasAnyWeaponEquippedRoster() {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.m_Player.HasAnyWeaponEquippedRoster() {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  this.ShowWidgets(this.m_Player.HasAnyWeaponEquippedRoster());
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  if ItemID.IsValid(currentData.weaponID) {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  this.ShowWidgets(this.m_Player.HasAnyWeaponEquippedRoster());
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  if ItemID.IsValid(currentData.weaponID) {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    this.PlayFold();
  };
}
