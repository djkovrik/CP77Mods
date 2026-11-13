import LimitedHudConfig.*
import LimitedHudMappinChecker.MappinChecker
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEvent
import LimitedHudCommon.LHUDMarkerConfigs

@addMethod(QuestMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@if(!ModuleExists("DisclosedHiddenGems.Core"))
@addMethod(QuestMappinController)
public func ShouldMappinBeVisible() -> Bool {
  let isInQuestArea: Bool = this.m_questMappin != null && this.m_questMappin.IsInsideTrigger();
  let showWhenClamped: Bool = this.isCurrentlyClamped ? !this.m_shouldHideWhenClamped : true;
  let shouldBeVisible: Bool = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea;

  return shouldBeVisible;
}

@if(ModuleExists("DisclosedHiddenGems.Core"))
@addMethod(QuestMappinController)
public func ShouldMappinBeVisible() -> Bool {
  let isInQuestArea: Bool = this.m_questMappin != null && this.m_questMappin.IsInsideTrigger();
  let showWhenClamped: Bool = this.isCurrentlyClamped ? !this.m_shouldHideWhenClamped : true;
  let shouldBeVisible: Bool = this.m_mappin.IsVisible() && showWhenClamped && !isInQuestArea;

  if this.IsHiddenGem() {
    return this.ShouldHiddenGemMappinBeVisible() && shouldBeVisible;
  } else {
    return shouldBeVisible;
  }
}

@addMethod(QuestMappinController)
public func DetermineCurrentVisibility() -> Bool {
  if !IsDefined(this.m_mappin) {
    return false;
  };
  // -- Default conditions
  let shouldBeVisible: Bool = this.ShouldMappinBeVisible();
  // -- LHUD Conditions
  // ---- Quests
  if this.lhudConfigs.quest.IsEnabled && MappinChecker.IsQuestIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigs.quest.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigs.quest.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigs.quest.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfigs.quest.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfigs.quest.ShowInVehicle;
    let showForAutoDrive: Bool = this.lhud_inAutoDrive && this.lhudConfigs.quest.ShowWithAutoDrive;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfigs.quest.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfigs.quest.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfigs.quest.ShowWithZoom;
    let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfigs.quest.ShowInDangerArea;
    let showIfTracked: Bool = this.lhudConfigs.quest.AlwaysShowTrackedMarker && MappinChecker.IsTracked(this.m_mappin);
    let isVisible: Bool = showIfTracked || showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForAutoDrive || showForScanner || showForWeapon || showForZoom || showForArea;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.ApplyLHUDMarkerOpacity(this.lhudConfigs.quest.Opacity);
    this.SetRootVisible(this.lhud_isVisibleNow);
    return true;
  };
  // ---- Loot
  if this.lhudConfigs.loot.IsEnabled && MappinChecker.IsLootMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigs.loot.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigs.loot.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigs.loot.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfigs.loot.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfigs.loot.ShowInVehicle;
    let showForAutoDrive: Bool = this.lhud_inAutoDrive && this.lhudConfigs.loot.ShowWithAutoDrive;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfigs.loot.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfigs.loot.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfigs.loot.ShowWithZoom;
    let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfigs.loot.ShowInDangerArea;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForAutoDrive || showForScanner || showForWeapon || showForZoom || showForArea;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.ApplyLHUDMarkerOpacity(this.lhudConfigs.loot.Opacity);
    this.SetRootVisible(this.lhud_isVisibleNow);
    return true;
  };
  // ---- Vehicles
  if this.lhudConfigs.vehicles.IsEnabled && MappinChecker.IsVehicleIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigs.vehicles.BindToGlobalHotkey;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfigs.vehicles.ShowInVehicle;
    let showForAutoDrive: Bool = this.lhud_inAutoDrive && this.lhudConfigs.vehicles.ShowWithAutoDrive;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfigs.vehicles.ShowWithScanner;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfigs.vehicles.ShowWithZoom;
    let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfigs.vehicles.ShowInDangerArea;
    let isVisible: Bool = showForGlobalHotkey || showForVehicle || showForAutoDrive || showForScanner || showForZoom || showForArea;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible && !this.lhud_isBraindanceActive;
    this.ApplyLHUDMarkerOpacity(this.lhudConfigs.vehicles.Opacity);
    this.SetRootVisible(this.lhud_isVisibleNow);
    return true;
  };
  // ---- POIs
  if this.lhudConfigs.poi.IsEnabled && MappinChecker.IsPlaceOfInterestIcon(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigs.poi.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigs.poi.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigs.poi.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfigs.poi.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfigs.poi.ShowInVehicle;
    let showForAutoDrive: Bool = this.lhud_inAutoDrive && this.lhudConfigs.poi.ShowWithAutoDrive;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfigs.poi.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfigs.poi.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfigs.poi.ShowWithZoom;
    let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfigs.poi.ShowInDangerArea;
    let showIfTracked: Bool = this.lhudConfigs.poi.AlwaysShowTrackedMarker && MappinChecker.IsTracked(this.m_mappin);
    let isVisible: Bool = showIfTracked || showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForAutoDrive || showForScanner || showForWeapon || showForZoom || showForArea;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible && !this.lhud_isBraindanceActive;
    this.ApplyLHUDMarkerOpacity(this.lhudConfigs.poi.Opacity);
    this.SetRootVisible(this.lhud_isVisibleNow);
    return true;
  };
  // ---- Combat
  if this.lhudConfigs.combat.IsEnabled && MappinChecker.IsCombatMarker(this.m_mappin) {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfigs.combat.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfigs.combat.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfigs.combat.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfigs.combat.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfigs.combat.ShowInVehicle;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfigs.combat.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed  && this.lhudConfigs.combat.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfigs.combat.ShowWithZoom;
    let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfigs.combat.ShowInDangerArea;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom || showForArea;
    this.lhud_isVisibleNow = shouldBeVisible && isVisible;
    this.ApplyLHUDMarkerOpacity(this.lhudConfigs.combat.Opacity);
    this.SetRootVisible(this.lhud_isVisibleNow);
    return true;
  };
  // ---- Devices and interactions
  if this.lhudConfigs.devices.IsEnabled && MappinChecker.IsDeviceInteraction(this.m_mappin) {
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfigs.devices.ShowWithScanner;
    let isVisible: Bool = showForScanner && shouldBeVisible;
    this.lhud_isVisibleNow = isVisible;
    this.ApplyLHUDMarkerOpacity(this.lhudConfigs.devices.Opacity);
    this.SetRootVisible(this.lhud_isVisibleNow);
    return true;
  };

  this.ApplyLHUDMarkerOpacity(1.0);
  return false;
}

@addField(QuestMappinController) private let lhudConfigs: ref<LHUDMarkerConfigs>;
@addField(QuestMappinController) private let lhudMarkerOpacity: Float;

@addMethod(QuestMappinController)
private final func ApplyLHUDMarkerOpacity(opacity: Float) -> Void {
  if opacity == this.lhudMarkerOpacity {
    return;
  };
  this.lhudMarkerOpacity = opacity;

  let canvas = this.GetWidget(n"Canvas");
  let arrow = this.GetWidget(n"Arrow");
  if IsDefined(canvas) {
    canvas.SetOpacity(opacity);
  };
  if IsDefined(arrow) {
    arrow.SetOpacity(opacity);
  };
}

@wrapMethod(QuestMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfigs = LHUDMarkerConfigs.Get();
  this.lhudMarkerOpacity = 1.0;
  this.FetchInitialStateFlags();
}

@wrapMethod(QuestMappinController)
private func UpdateVisibility() -> Void {
  if !this.DetermineCurrentVisibility() {
    wrappedMethod();
    this.lhud_isVisibleNow = this.GetRootWidget().IsVisible();
  }
}

@wrapMethod(GameplayMappinController)
private func UpdateVisibility() -> Void {
  if !this.DetermineCurrentVisibility() {
    wrappedMethod();
    this.lhud_isVisibleNow = this.GetRootWidget().IsVisible();
  }
}

@addMethod(QuestMappinController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  if IsDefined(this.m_mappin) {
    this.UpdateVisibility();
  };
}

@wrapMethod(QuickHackMappinController)
protected cb func OnIntro() -> Bool {
  wrappedMethod();
  this.ApplyLHUDQuickHackOpacity();
}

@addMethod(QuickHackMappinController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.ApplyLHUDQuickHackOpacity();
}

@addMethod(QuickHackMappinController)
private final func ApplyLHUDQuickHackOpacity() -> Void {
  if !IsDefined(this.m_mappin) {
    return;
  };
  let configs = LHUDMarkerConfigs.Get();
  let opacity: Float = 1.0;
  if configs.quest.IsEnabled && MappinChecker.IsQuestIcon(this.m_mappin) {
    opacity = configs.quest.Opacity;
  } else {
    if configs.combat.IsEnabled && MappinChecker.IsCombatMarker(this.m_mappin) {
      opacity = configs.combat.Opacity;
    };
  };
  this.m_rootWidget.SetOpacity(opacity);
}
