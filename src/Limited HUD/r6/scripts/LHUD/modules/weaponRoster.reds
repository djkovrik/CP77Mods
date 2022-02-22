import LimitedHudConfig.WeaponRosterModuleConfig
import LimitedHudCommon.LHUDEvent

@addMethod(weaponRosterGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(weaponRosterGameController)
public func DetermineCurrentVisibility() -> Void {
  if !WeaponRosterModuleConfig.IsEnabled() {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WeaponRosterModuleConfig.BindToGlobalHotkey();
  let showForCombat: Bool = this.lhud_isCombatActive && WeaponRosterModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WeaponRosterModuleConfig.ShowOutOfCombat();
  let showForStealth: Bool =  this.lhud_isStealthActive && WeaponRosterModuleConfig.ShowInStealth();
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && WeaponRosterModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  this.lhud_isZoomActive && WeaponRosterModuleConfig.ShowWithZoom();

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.PlayUnfold();
      this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOffline, 1.0, 0.3);
      this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOnline, 1.0, 0.3);
    } else {
      this.PlayFold();
      this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOffline, 0.0, 0.3);
      this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOnline, 0.0, 0.3);
    };
  };
}

@wrapMethod(weaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if WeaponRosterModuleConfig.IsEnabled() {
    this.lhud_isVisibleNow = this.m_Player.HasAnyWeaponEquipped_LHUD();
    this.OnInitializeFinished();
    this.DetermineCurrentVisibility();
  };
}

@replaceMethod(weaponRosterGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.lhud_isVisibleNow {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  if ItemID.IsValid(currentData.weaponID) {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    // this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    // this.PlayFold();
  };
}
