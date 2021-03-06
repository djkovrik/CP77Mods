///////////////////////////////////////////////////////
// Show world mappins depending on the module config //
///////////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.WorldMarkersModuleConfig

@addMethod(WorldMappinsContainerController)
public func OnBraindanceStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnMountedStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnScannerStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func DetermineCurrentVisibility() -> Void {
  // Check if enabled
  if !WorldMarkersModuleConfig.IsEnabled() {
    return ;
  };

  // Basic checks
  let isBraindanceActive: Bool = this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive);
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isCurrentStateOutOfCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.OutOfCombat);
  let isScannerEnabled: Bool = this.m_scannerBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isCurrentStateInVehicle: Bool = this.m_vehicleBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed && !isScannerEnabled;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && WorldMarkersModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = isCurrentStateOutOfCombat && WorldMarkersModuleConfig.ShowOutOfCombat();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && WorldMarkersModuleConfig.BindToGlobalHotkey();
  let showForScanner: Bool =  isScannerEnabled && WorldMarkersModuleConfig.ShowWithScanner();
  let showForStealth: Bool =  isCurrentStateStealth && WorldMarkersModuleConfig.ShowInStealth();
  let showForVehicle: Bool =  isCurrentStateInVehicle && WorldMarkersModuleConfig.ShowInVehicle();
  let showForWeapon: Bool = isWeaponUnsheathed && WorldMarkersModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && WorldMarkersModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = isBraindanceActive || showForCombat || showForOutOfCombat || showForGlobalHotkey || showForScanner || showForStealth || showForVehicle || showForWeapon || showForZoom;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(WorldMappinsContainerController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  // Define blackboards
  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    this.m_braindanceBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().Braindance);
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_scannerBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
    this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_vehicleBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_braindanceTrackingCallback_LHUD = this.m_braindanceBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this, n"OnBraindanceStateChanged");
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
    this.m_scannerTrackingCallback_LHUD = this.m_scannerBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnScannerStateChanged");
    this.m_vehicleTrackingCallback_LHUD = this.m_vehicleBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("WorldMappinsContainerController blackboards not defined!");
  }
}

@addMethod(WorldMappinsContainerController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_braindanceBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this.m_braindanceTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_scannerBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback_LHUD);
  this.m_vehicleBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_vehicleTrackingCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}
