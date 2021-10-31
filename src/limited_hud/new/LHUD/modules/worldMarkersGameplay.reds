import LimitedHudConfig.WorldMarkersModuleConfigLoot
import LimitedHudMappinChecker.MappinChecker
import LimitedHudCommon.LHUDEvent
import LimitedHudCommon.LHUDLog

@addMethod(GameplayMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeEvent(evt);
  this.UpdateVisibility();
}

@replaceMethod(GameplayMappinController)
private func UpdateVisibility() -> Void {
  // -- Default conditions
  let shouldBeVisible: Bool = this.m_mappin.IsVisible();
  // -- LHUD Conditions
  // ---- Loot
  if WorldMarkersModuleConfigLoot.IsEnabled() && MappinChecker.IsLootMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigLoot.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigLoot.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigLoot.ShowOutOfCombat();
    let showForStealth: Bool =  this.lhud_isStealthActive && WorldMarkersModuleConfigLoot.ShowInStealth();
    let showForVehicle: Bool =  this.lhud_isInVehicle && WorldMarkersModuleConfigLoot.ShowInVehicle();
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigLoot.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && !this.lhud_isCombatActive && WorldMarkersModuleConfigLoot.ShowWithWeapon();
    let showForZoom: Bool =  this.lhud_isZoomActive && WorldMarkersModuleConfigLoot.ShowWithZoom();
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };

  this.lhud_isVisibleNow = shouldBeVisible;
  this.SetRootVisible(shouldBeVisible);
  let data: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
  LHUDLog("Missed gameplay mappin! Variant: " + ToString(this.m_mappin.GetVariant()) + ", role: " + ToString(data.m_gameplayRole)  + ", visibility: " + ToString(this.lhud_isVisibleNow));
}

@wrapMethod(GameplayMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhud_isVisibleNow = false;
  this.SetRootVisible(false);
  this.UpdateVisibility();
}
