/////////////////////////////////////////////////
// Show minimap depending on the module config //
/////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.MinimapModuleConfig

@addMethod(MinimapContainerController)
public func OnBraindanceStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnMinimapToggleChanged(value: Bool) -> Void {
  this.m_isMinimapToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnMountedStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnScannerStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func DetermineCurrentVisibility() -> Void {
  // Check for braindance
  if this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive) {
    this.GetRootWidget().SetVisible(false);
    return;
  };

  // Basic checks
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isCurrentStateOutOfCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.OutOfCombat);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isCurrentStateInVehicle: Bool = this.m_vehicleBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  let isScannerEnabled: Bool = this.m_scannerBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && MinimapModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = isCurrentStateOutOfCombat && MinimapModuleConfig.ShowOutOfCombat();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && MinimapModuleConfig.BindToGlobalHotkey();
  let showForMinimapHotkey: Bool = this.m_isMinimapToggled_LHUD;
  let showForScanner: Bool =  isScannerEnabled && MinimapModuleConfig.ShowWithScanner();
  let showForStealth: Bool =  isCurrentStateStealth && MinimapModuleConfig.ShowInStealth();
  let showForVehicle: Bool =  isCurrentStateInVehicle && MinimapModuleConfig.ShowInVehicle();
  let showForWeapon: Bool = isWeaponUnsheathed && MinimapModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && MinimapModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForOutOfCombat || showForGlobalHotkey || showForMinimapHotkey || showForScanner || showForStealth || showForVehicle || showForWeapon || showForZoom;
  
    // Check if enabled
  if MinimapModuleConfig.IsEnabled() {
    this.GetRootWidget().SetVisible(isVisible);
  } else {
    this.GetRootWidget().SetVisible(!isScannerEnabled);
  };
}

@addMethod(MinimapContainerController)
public func InitBBs(playerPuppet: ref<GameObject>) -> Void {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    // Define blackboards
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
    this.m_minimapToggleCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, this, n"OnMinimapToggleChanged");
    this.m_scannerTrackingCallback_LHUD = this.m_scannerBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnScannerStateChanged");
    this.m_vehicleTrackingCallback_LHUD = this.m_vehicleBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("MinimapContainerController blackboards not defined!");
  }
}

@addMethod(MinimapContainerController)
public func ClearBBs() -> Void {
  this.m_braindanceBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this.m_braindanceTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, this.m_minimapToggleCallback_LHUD);
  this.m_scannerBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback_LHUD);
  this.m_vehicleBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_vehicleTrackingCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}

@replaceMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  this.InitializePlayer(playerGameObject);
  this.InitBBs(playerGameObject);
  this.GetRootWidget().SetOpacity(MinimapModuleConfig.Opacity());
}

@replaceMethod(MinimapContainerController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  let psmBlackboard: ref<IBlackboard> = this.GetPSMBlackboard(playerGameObject);
  if IsDefined(psmBlackboard) {
    if this.m_securityBlackBoardID > 0u {
      psmBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().PlayerStateMachine.SecurityZoneData, this.m_securityBlackBoardID);
      this.m_securityBlackBoardID = 0u;
    };
  };
  this.ClearBBs();
}
