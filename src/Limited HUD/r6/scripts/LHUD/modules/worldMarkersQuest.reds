import LimitedHudConfig.WorldMarkersModuleConfigQuest
import LimitedHudConfig.WorldMarkersModuleConfigVehicles
import LimitedHudConfig.WorldMarkersModuleConfigPOI
import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudConfig.WorldMarkersModuleConfigLoot
import LimitedHudConfig.WorldMarkersModuleConfigDevices
import LimitedHudMappinChecker.MappinChecker
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEvent
import LimitedHudCommon.LHUDLogMarker

@addMethod(QuestMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(QuestMappinController)
private func DetermineCurrentVisibility() -> Void {
  // -- Default conditions
  let isInQuestArea: Bool = this.m_questMappin != null && this.m_questMappin.IsInsideTrigger();
  let showWhenClamped: Bool = this.isCurrentlyClamped ? !this.m_shouldHideWhenClamped : true;
  let shouldBeVisible: Bool = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea;
  // -- LHUD Conditions
  // ---- Quests
  if this.lhudConfigQuest.IsEnabled && MappinChecker.IsQuestIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigQuest.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigQuest.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigQuest.ShowOutOfCombat;
    let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfigQuest.ShowInStealth;
    let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfigQuest.ShowInVehicle;
    let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfigQuest.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfigQuest.ShowWithWeapon;
    let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfigQuest.ShowWithZoom;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Loot
  if this.lhudConfigLoot.IsEnabled && MappinChecker.IsLootMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigLoot.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigLoot.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigLoot.ShowOutOfCombat;
    let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfigLoot.ShowInStealth;
    let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfigLoot.ShowInVehicle;
    let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfigLoot.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfigLoot.ShowWithWeapon;
    let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfigLoot.ShowWithZoom;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Vehicles
  if this.lhudConfigVehicles.IsEnabled && MappinChecker.IsVehicleIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigVehicles.BindToGlobalHotkey;
    let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfigVehicles.ShowInVehicle;
    let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfigVehicles.ShowWithScanner;
    let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfigVehicles.ShowWithZoom;
    let isVisible: Bool = showForGlobalHotkey || showForVehicle || showForScanner || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible && !this.lhud_isBraindanceActive;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- POIs
  if this.lhudConfigPOI.IsEnabled && MappinChecker.IsPlaceOfInterestIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigPOI.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigPOI.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigPOI.ShowOutOfCombat;
    let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfigPOI.ShowInStealth;
    let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfigPOI.ShowInVehicle;
    let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfigPOI.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfigPOI.ShowWithWeapon;
    let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfigPOI.ShowWithZoom;
    let showIfTracked: Bool = this.lhudConfigPOI.AlwaysShowTrackedMarker && MappinChecker.IsTracked(this.m_mappin);
    let isVisible: Bool = showIfTracked || showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible && !this.lhud_isBraindanceActive;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Combat
  if this.lhudConfigCombat.IsEnabled && MappinChecker.IsCombatMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigCombat.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigCombat.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigCombat.ShowOutOfCombat;
    let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfigCombat.ShowInStealth;
    let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfigCombat.ShowInVehicle;
    let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfigCombat.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed  && this.lhudConfigCombat.ShowWithWeapon;
    let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfigCombat.ShowWithZoom;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };
  // ---- Devices and interactions
  if this.lhudConfigDevices.IsEnabled && MappinChecker.IsDeviceInteraction(this.m_mappin) {
    let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfigDevices.ShowWithScanner;
    let isVisible: Bool = showForScanner && shouldBeVisible;
    this.lhud_isVisibleNow = isVisible;
    this.SetRootVisible(this.lhud_isVisibleNow);
    return ;
  };

  this.lhud_isVisibleNow = shouldBeVisible;
  this.SetRootVisible(shouldBeVisible);
  let data: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
  LHUDLogMarker(s"MISSED MAPPIN: \(this.m_mappin.GetVariant()), role: \(data.m_gameplayRole), visibility \(this.lhud_isVisibleNow)");
}

@addField(QuestMappinController) private let lhudConfigQuest: ref<WorldMarkersModuleConfigQuest>;
@addField(QuestMappinController) private let lhudConfigVehicles: ref<WorldMarkersModuleConfigVehicles>;
@addField(QuestMappinController) private let lhudConfigPOI: ref<WorldMarkersModuleConfigPOI>;
@addField(QuestMappinController) private let lhudConfigCombat: ref<WorldMarkersModuleConfigCombat>;
@addField(QuestMappinController) private let lhudConfigLoot: ref<WorldMarkersModuleConfigLoot>;
@addField(QuestMappinController) private let lhudConfigDevices: ref<WorldMarkersModuleConfigDevices>;

@wrapMethod(QuestMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfigQuest = new WorldMarkersModuleConfigQuest();
  this.lhudConfigVehicles = new WorldMarkersModuleConfigVehicles();
  this.lhudConfigPOI = new WorldMarkersModuleConfigPOI();
  this.lhudConfigCombat = new WorldMarkersModuleConfigCombat();
  this.lhudConfigLoot = new WorldMarkersModuleConfigLoot();
  this.lhudConfigDevices = new WorldMarkersModuleConfigDevices();
  this.FetchInitialStateFlags();
  this.DetermineCurrentVisibility();
}

@wrapMethod(QuestMappinController)
protected cb func OnUpdate() -> Bool {
  wrappedMethod();
  this.DetermineCurrentVisibility();
}


@wrapMethod(GameplayMappinController)
protected cb func OnUpdate() -> Bool {
  wrappedMethod();
  super.DetermineCurrentVisibility();
}

@addMethod(QuestMappinController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfigQuest = new WorldMarkersModuleConfigQuest();
  this.lhudConfigVehicles = new WorldMarkersModuleConfigVehicles();
  this.lhudConfigPOI = new WorldMarkersModuleConfigPOI();
  this.lhudConfigCombat = new WorldMarkersModuleConfigCombat();
  this.lhudConfigLoot = new WorldMarkersModuleConfigLoot();
  this.lhudConfigDevices = new WorldMarkersModuleConfigDevices();
}
