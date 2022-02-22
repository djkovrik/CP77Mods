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
    this.OnUpdate();
};
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
    this.SetVisible(this.lhud_isVisibleNow);
  };
}

@addMethod(NameplateVisualsLogicController)
private func SetVisible(visible: Bool) -> Void {
  if (visible) {
    inkWidgetRef.SetOpacity(this.m_healthbarWidget, 1.0);
  } else {
    inkWidgetRef.SetOpacity(this.m_healthbarWidget, 0.0);
  };
}
