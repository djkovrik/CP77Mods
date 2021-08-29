///////////////////////////////////////////////////////
// Show quest tracker depending on the module config //
///////////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.QuestTrackerModuleConfig

@addMethod(QuestTrackerGameController)
public func OnBraindanceStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func OnMountedStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func OnScannerStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func DetermineCurrentVisibility() -> Void {
  // Check if enabled
  if !QuestTrackerModuleConfig.IsEnabled() {
    return ;
  };

  // Basic checks
  let currentState: gamePSMCombat = IntEnum(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat));
  let isCurrentStateCombat: Bool = Equals(currentState, gamePSMCombat.InCombat);
  let isCurrentStateOutOfCombat: Bool = Equals(currentState, gamePSMCombat.OutOfCombat) || Equals(currentState, gamePSMCombat.Default);
  let isScannerEnabled: Bool = this.m_scannerBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  let isCurrentStateStealth: Bool = Equals(currentState, gamePSMCombat.Stealth);
  let isBraindanceActive: Bool = this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive);
  let isCurrentStateInVehicle: Bool = this.m_systemBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed && !isScannerEnabled;
  let outOfCombatAvailable: Bool = isCurrentStateOutOfCombat && !isScannerEnabled && !isCurrentStateInVehicle && !isWeaponUnsheathed && !isZoomActive;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && QuestTrackerModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = outOfCombatAvailable && QuestTrackerModuleConfig.ShowOutOfCombat();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && QuestTrackerModuleConfig.BindToGlobalHotkey();
  let showForScanner: Bool =  isScannerEnabled && QuestTrackerModuleConfig.ShowWithScanner();
  let showForStealth: Bool =  isCurrentStateStealth && QuestTrackerModuleConfig.ShowInStealth();
  let showForVehicle: Bool =  isCurrentStateInVehicle && QuestTrackerModuleConfig.ShowInVehicle();
  let showForWeapon: Bool = isWeaponUnsheathed && QuestTrackerModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && QuestTrackerModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = isBraindanceActive || showForCombat || showForOutOfCombat || showForGlobalHotkey || showForScanner || showForStealth || showForVehicle || showForWeapon || showForZoom;

  if isVisible {
    this.GetRootWidget().SetOpacity(1.0);
  } else {
    this.GetRootWidget().SetOpacity(0.0);
  };
}

@addMethod(QuestTrackerGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  // Define blackboards
  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    this.m_braindanceBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().Braindance);
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_scannerBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
    this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_braindanceTrackingCallback_LHUD = this.m_braindanceBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this, n"OnBraindanceStateChanged");
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
    this.m_scannerTrackingCallback_LHUD = this.m_scannerBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnScannerStateChanged");
    this.m_vehicleTrackingCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this, n"OnMountedStateChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("QuestTrackerGameController blackboards not defined!");
  }
}

@addMethod(QuestTrackerGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_braindanceBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this.m_braindanceTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_scannerBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this.m_vehicleTrackingCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}
