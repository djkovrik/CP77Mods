import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudListeners.LHUDBlackboardsListener
import LimitedHudCommon.LHUDEvent

// -- Enemy head nameplate icons

@addMethod(StealthMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@wrapMethod(StealthMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhud_isOutOfCombatActive = true;
  this.lhud_isVisibleNow = false;
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.m_ownerObject.GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
}

@addMethod(StealthMappinController)
public func DetermineCurrentVisibility() -> Void {
  if WorldMarkersModuleConfigCombat.IsEnabled() {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigCombat.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigCombat.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigCombat.ShowOutOfCombat();
    let showForStealth: Bool = this.lhud_isStealthActive && WorldMarkersModuleConfigCombat.ShowInStealth();
    let showForVehicle: Bool = this.lhud_isInVehicle && WorldMarkersModuleConfigCombat.ShowInVehicle();
    let showForScanner: Bool = this.lhud_isScannerActive && WorldMarkersModuleConfigCombat.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && WorldMarkersModuleConfigCombat.ShowWithWeapon();
    let showForZoom: Bool = this.lhud_isZoomActive && WorldMarkersModuleConfigCombat.ShowWithZoom();

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
  if WorldMarkersModuleConfigCombat.IsEnabled() {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigCombat.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigCombat.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigCombat.ShowOutOfCombat();
    let showForStealth: Bool = this.lhud_isStealthActive && WorldMarkersModuleConfigCombat.ShowInStealth();
    let showForVehicle: Bool = this.lhud_isInVehicle && WorldMarkersModuleConfigCombat.ShowInVehicle();
    let showForScanner: Bool = this.lhud_isScannerActive && WorldMarkersModuleConfigCombat.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && WorldMarkersModuleConfigCombat.ShowWithWeapon();
    let showForZoom: Bool = this.lhud_isZoomActive && WorldMarkersModuleConfigCombat.ShowWithZoom();
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = isVisible;
  } else {
    this.lhud_isVisibleNow = true;
  };

  this.UpdateHealthbarVisibility();
}

@wrapMethod(NameplateVisualsLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  // set for initial loading
  this.lhud_isOutOfCombatActive = true;
  this.lhud_isVisibleNow = false;
}

@replaceMethod(NameplateVisualsLogicController)
private final func UpdateHealthbarVisibility() -> Void {
  let hpVisible: Bool = this.lhud_isVisibleNow && this.m_npcIsAggressive && !this.m_isBoss && (this.m_healthNotFull || this.m_playerAimingDownSights || this.m_playerInCombat || this.m_playerInStealth);
  if NotEquals(this.m_healthbarVisible, hpVisible) {
    this.m_healthbarVisible = hpVisible;
    inkWidgetRef.SetVisible(this.m_healthbarWidget, this.m_healthbarVisible);
  };
}
