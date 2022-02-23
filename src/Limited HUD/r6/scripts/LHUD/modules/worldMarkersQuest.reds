import LimitedHudConfig.WorldMarkersModuleConfigQuest
import LimitedHudConfig.WorldMarkersModuleConfigVehicles
import LimitedHudConfig.WorldMarkersModuleConfigPOI
import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudConfig.WorldMarkersModuleConfigLoot
import LimitedHudConfig.WorldMarkersModuleConfigDevices
import LimitedHudMappinChecker.MappinChecker
import LimitedHudCommon.LHUDEvent
import LimitedHudCommon.LHUDLog

@addMethod(QuestMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.UpdateVisibility();
}

@replaceMethod(QuestMappinController)
private func UpdateVisibility() -> Void {
  // -- Default conditions
  let isInQuestArea: Bool = this.m_questMappin != null && this.m_questMappin.IsInsideTrigger();
  let showWhenClamped: Bool = this.isCurrentlyClamped ? !this.m_shouldHideWhenClamped : true;
  let shouldBeVisible: Bool = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea;
  // -- LHUD Conditions
  // ---- Quests
  if WorldMarkersModuleConfigQuest.IsEnabled() && MappinChecker.IsQuestIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigQuest.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigQuest.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigQuest.ShowOutOfCombat();
    let showForStealth: Bool =  this.lhud_isStealthActive && WorldMarkersModuleConfigQuest.ShowInStealth();
    let showForVehicle: Bool =  this.lhud_isInVehicle && WorldMarkersModuleConfigQuest.ShowInVehicle();
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigQuest.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && WorldMarkersModuleConfigQuest.ShowWithWeapon();
    let showForZoom: Bool =  this.lhud_isZoomActive && WorldMarkersModuleConfigQuest.ShowWithZoom();
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Loot
  if WorldMarkersModuleConfigLoot.IsEnabled() && MappinChecker.IsLootMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigLoot.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigLoot.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigLoot.ShowOutOfCombat();
    let showForStealth: Bool =  this.lhud_isStealthActive && WorldMarkersModuleConfigLoot.ShowInStealth();
    let showForVehicle: Bool =  this.lhud_isInVehicle && WorldMarkersModuleConfigLoot.ShowInVehicle();
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigLoot.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && WorldMarkersModuleConfigLoot.ShowWithWeapon();
    let showForZoom: Bool =  this.lhud_isZoomActive && WorldMarkersModuleConfigLoot.ShowWithZoom();
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Vehicles
  if WorldMarkersModuleConfigVehicles.IsEnabled() && MappinChecker.IsVehicleIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigVehicles.BindToGlobalHotkey();
    let showForVehicle: Bool =  this.lhud_isInVehicle && WorldMarkersModuleConfigVehicles.ShowInVehicle();
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigVehicles.ShowWithScanner();
    let showForZoom: Bool =  this.lhud_isZoomActive && WorldMarkersModuleConfigVehicles.ShowWithZoom();
    let isVisible: Bool = showForGlobalHotkey || showForVehicle || showForScanner || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- POIs
  if WorldMarkersModuleConfigPOI.IsEnabled() && MappinChecker.IsPlaceOfInterestIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigPOI.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigPOI.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigPOI.ShowOutOfCombat();
    let showForStealth: Bool =  this.lhud_isStealthActive && WorldMarkersModuleConfigPOI.ShowInStealth();
    let showForVehicle: Bool =  this.lhud_isInVehicle && WorldMarkersModuleConfigPOI.ShowInVehicle();
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigPOI.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && WorldMarkersModuleConfigPOI.ShowWithWeapon();
    let showForZoom: Bool =  this.lhud_isZoomActive && WorldMarkersModuleConfigPOI.ShowWithZoom();
    let showIfTracked: Bool = WorldMarkersModuleConfigPOI.AlwaysShowTrackedMarker() && MappinChecker.IsTracked(this.m_mappin);
    let isVisible: Bool = showIfTracked || showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Combat
  if WorldMarkersModuleConfigCombat.IsEnabled() && MappinChecker.IsCombatMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && WorldMarkersModuleConfigCombat.BindToGlobalHotkey();
    let showForCombat: Bool = this.lhud_isCombatActive && WorldMarkersModuleConfigCombat.ShowInCombat();
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && WorldMarkersModuleConfigCombat.ShowOutOfCombat();
    let showForStealth: Bool =  this.lhud_isStealthActive && WorldMarkersModuleConfigCombat.ShowInStealth();
    let showForVehicle: Bool =  this.lhud_isInVehicle && WorldMarkersModuleConfigCombat.ShowInVehicle();
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigCombat.ShowWithScanner();
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed  && WorldMarkersModuleConfigCombat.ShowWithWeapon();
    let showForZoom: Bool =  this.lhud_isZoomActive && WorldMarkersModuleConfigCombat.ShowWithZoom();
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Devices and interactions
  if WorldMarkersModuleConfigDevices.IsEnabled() && MappinChecker.IsDeviceInteraction(this.m_mappin) {
    let showForScanner: Bool =  this.lhud_isScannerActive && WorldMarkersModuleConfigDevices.ShowWithScanner();
    let isVisible: Bool = showForScanner && shouldBeVisible;
    this.lhud_isVisibleNow = isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };

  this.lhud_isVisibleNow = shouldBeVisible;
  this.SetRootVisible(shouldBeVisible);
  let data: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
  LHUDLog("Missed mappin: " + ToString(this.m_mappin.GetVariant()) + ", role: " + ToString(data.m_gameplayRole)  + ", visibility: " + ToString(this.lhud_isVisibleNow));
}

@wrapMethod(QuestMappinController)
protected cb func OnInitialize() -> Bool {
  // set to true for initial loading
  this.lhud_isOutOfCombatActive = true;
  wrappedMethod();
  this.lhud_isVisibleNow = false;
  this.SetRootVisible(false);
  this.UpdateVisibility();
}

@replaceMethod(GameplayMappinController)
private func UpdateVisibility() -> Void {
  super.UpdateVisibility();
}
