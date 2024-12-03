import LimitedHudConfig.WeaponRosterModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
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
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
  if this.lhud_isBraindanceActive { isVisible = false; };
  this.lhud_isVisibleNow = isVisible;
  if isVisible {
    this.Unfold();
    this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOffline, 1.0, 0.3);
    this.AnimateAlphaLHUD(this.m_smartLinkFirmwareOnline, 1.0, 0.3);
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
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_activeWeapon.weaponID) && this.lhud_isVisibleNow {
        this.Unfold();
      };
      break;
    case gamePSMVision.Focus:
      this.Fold();
  };
}

@replaceMethod(WeaponRosterGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  let item: ref<gameItemData>;
  let weaponType: gamedataItemType;
  let data: SlotWeaponData = FromVariant<ref<SlotDataHolder>>(value).weapon;
  this.m_isUnholstered = ItemID.IsValid(data.weaponID);
  if this.m_isUnholstered {
    if this.m_activeWeapon.weaponID != data.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(data.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
      this.m_weaponRecord = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(data.weaponID));
      weaponType = this.m_weaponRecord.ItemTypeHandle().Type();
      if NotEquals(weaponType, gamedataItemType.Wea_VehiclePowerWeapon) && NotEquals(weaponType, gamedataItemType.Wea_VehicleMissileLauncher) {
        this.LoadWeaponIcon();
        inkTextRef.SetText(this.m_weaponName, InventoryItemData.GetName(this.m_weaponItemData));
        if NotEquals(this.m_weaponRecord.EvolutionHandle().Type(), gamedataWeaponEvolution.Smart) || this.ShouldIgnoreSmartUI() {
          inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
          inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
        };
      };
    };
    this.m_activeWeapon = data;
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
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new WeaponRosterModuleConfig();
}
