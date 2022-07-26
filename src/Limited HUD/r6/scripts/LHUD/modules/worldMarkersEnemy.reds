import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudListeners.LHUDBlackboardsListener
import LimitedHudCommon.LHUDEvent

// -- Enemy head nameplate icons

@addMethod(StealthMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addField(StealthMappinController)
private let lhudConfig: ref<WorldMarkersModuleConfigCombat>;

@wrapMethod(StealthMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WorldMarkersModuleConfigCombat();
  this.FetchInitialStateFlags();
  this.DetermineCurrentVisibility();
}

@addMethod(StealthMappinController)
public func DetermineCurrentVisibility() -> Void {
  if this.lhudConfig.IsEnabled {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfig.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = isVisible;
  } else {
    this.lhud_isVisibleNow = true;
  };

  this.OnUpdate();
}

@wrapMethod(StealthMappinController)
private final func ShouldDisableMappin() -> Bool {
  if !this.lhud_isVisibleNow {
    return true;
  };
  return wrappedMethod();
}

// -- Enemy healthbar

@addMethod(NameplateVisualsLogicController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(NameplateVisualsLogicController)
public func DetermineCurrentVisibility() -> Void {
  if this.lhudConfig.IsEnabled {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfig.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = isVisible;
  } else {
    this.lhud_isVisibleNow = true;
  };

  this.UpdateHealthbarVisibility();
}

@addField(NameplateVisualsLogicController)
private let lhudConfig: ref<WorldMarkersModuleConfigCombat>;

@wrapMethod(NameplateVisualsLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WorldMarkersModuleConfigCombat();
  this.FetchInitialStateFlags();
  this.DetermineCurrentVisibility();
}

@replaceMethod(NameplateVisualsLogicController)
private final func UpdateHealthbarVisibility() -> Void {
  let hpVisible: Bool = this.lhud_isVisibleNow && this.m_npcIsAggressive && !this.m_isBoss && (this.m_healthNotFull || this.m_playerAimingDownSights || this.m_playerInCombat || this.m_playerInStealth);
  if NotEquals(this.m_healthbarVisible, hpVisible) {
    this.m_healthbarVisible = hpVisible;
    inkWidgetRef.SetVisible(this.m_healthbarWidget, this.m_healthbarVisible);
  };
}
