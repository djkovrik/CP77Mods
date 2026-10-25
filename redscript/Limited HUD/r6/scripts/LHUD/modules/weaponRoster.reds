import LimitedHudConfig.WeaponRosterModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDOnCoolExitEvent
import LimitedHudCommon.LHUDEvent

@addMethod(WeaponRosterGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(WeaponRosterGameController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
  let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfig.ShowInDangerArea;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom || showForArea;
  if this.lhud_isBraindanceActive { isVisible = false; };
  this.lhud_isVisibleNow = isVisible;
  if isVisible {
    this.GetRootCompoundWidget().SetOpacity(this.lhudConfig.Opacity);
    this.Unfold();
    this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOffline, this.lhudConfig.Opacity, 0.3);
    this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOnline, this.lhudConfig.Opacity, 0.3);
  } else {
    this.Fold();
    this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOffline, 0.0, 0.3);
    this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOnline, 0.0, 0.3);
  };
}

@addField(WeaponRosterGameController)
private let lhudConfig: ref<WeaponRosterModuleConfig>;

@wrapMethod(WeaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WeaponRosterModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = this.m_player.HasAnyWeaponEquipped_LHUD();
    this.OnInitializeFinished();
    this.DetermineCurrentVisibility();
  };
}

@replaceMethod(WeaponRosterGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  switch IntEnum<gamePSMVision>(value) {
    case gamePSMVision.Default:
      if this.m_isUnholstered && this.lhud_isVisibleNow {
        this.GetRootCompoundWidget().SetOpacity(this.lhudConfig.Opacity);
        this.Unfold();
      };
      break;
    case gamePSMVision.Focus:
      this.Fold();
  };
}

@replaceMethod(WeaponRosterGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  let rightWeaponData: SlotWeaponData = FromVariant<ref<SlotDataHolder>>(value).rightWeapon;
  let leftWeaponData: SlotWeaponData = FromVariant<ref<SlotDataHolder>>(value).leftWeapon;
  this.m_isUnholstered = ItemID.IsValid(rightWeaponData.weaponID);
  if this.m_isUnholstered {
    if this.m_activeRightWeapon.weaponID != rightWeaponData.weaponID {
      this.ChangeWeaponData(rightWeaponData, this.m_rightWeaponItemData, this.m_rightWeaponRecord, this.m_rightWeaponName, false);
    };
    if this.m_activeLeftWeapon.weaponID != leftWeaponData.weaponID {
      if ItemID.IsValid(leftWeaponData.weaponID) {
        this.ChangeWeaponData(leftWeaponData, this.m_leftWeaponItemData, this.m_leftWeaponRecord, this.m_leftWeaponName, true);
      };
      this.ToggleLeftWeaponVisibility(ItemID.IsValid(leftWeaponData.weaponID));
    };
    this.m_activeLeftWeapon = leftWeaponData;
    this.m_activeRightWeapon = rightWeaponData;
    this.SetRosterSlotData();
    if !this.lhudConfig.IsEnabled {
      this.Unfold();
    };
  } else {
    if !this.lhudConfig.IsEnabled {
      this.Fold();
    };
  };
}

@addMethod(WeaponRosterGameController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Bool {
  this.lhudConfig = new WeaponRosterModuleConfig();
}

@addMethod(WeaponRosterGameController)
protected cb func OnLHUDOnCoolExitEvent(evt: ref<LHUDOnCoolExitEvent>) -> Bool {
  let weaponTotalAmmo: Int32 = this.GetAllAmmoCount();
  let isWeaponTotalAmmoVisible: Bool = !this.m_inVehicle && !this.m_player.IsReplacer();
  if isWeaponTotalAmmoVisible {
    inkTextRef.SetText(this.m_rightWeaponTotalAmmo, this.GetAmmoText(weaponTotalAmmo, 4));
  };
  inkWidgetRef.SetVisible(this.m_rightWeaponTotalAmmo, isWeaponTotalAmmoVisible);
  let isLeftWeaponTotalAmmoVisible: Bool = isWeaponTotalAmmoVisible
    && ItemID.IsValid(this.m_activeLeftWeapon.weaponID)
    && this.m_activeLeftWeapon.ammoId != this.m_activeRightWeapon.ammoId;
  if isLeftWeaponTotalAmmoVisible {
    inkTextRef.SetText(this.m_leftWeaponTotalAmmo, this.GetAmmoText(this.GetLeftAmmoCount(), 4));
  };
  inkWidgetRef.SetVisible(this.m_leftWeaponTotalAmmo, isLeftWeaponTotalAmmoVisible);
}
