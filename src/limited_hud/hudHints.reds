///////////////////////////////////////////////////////////////////////
// Show vanilla hotkey hints depending on the module config //
///////////////////////////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.HintsModuleConfig

@addMethod(InputHintManagerGameController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(InputHintManagerGameController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(InputHintManagerGameController)
public func OnMountedStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(InputHintManagerGameController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(InputHintManagerGameController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(InputHintManagerGameController)
public func DetermineCurrentVisibility() -> Void {
  // Check if enabled
  if !HintsModuleConfig.IsEnabled() {
    return ;
  };

  // Basic checks
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isCurrentStateInVehicle: Bool = this.m_vehicleBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && HintsModuleConfig.ShowInCombat();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && HintsModuleConfig.BindToGlobalHotkey();
  let showForStealth: Bool =  isCurrentStateStealth && HintsModuleConfig.ShowInStealth();
  let showForVehicle: Bool =  isCurrentStateInVehicle && HintsModuleConfig.ShowInVehicle();
  let showForWeapon: Bool = isWeaponUnsheathed && HintsModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && HintsModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForGlobalHotkey || showForStealth || showForVehicle || showForWeapon || showForZoom;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(InputHintManagerGameController)
public func InitBBs(playerPuppet: ref<GameObject>) -> Void {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    // Define blackboards
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_vehicleBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
    this.m_vehicleTrackingCallback_LHUD = this.m_vehicleBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("InputHintManagerGameController blackboards not defined!");
  }
}

@addMethod(InputHintManagerGameController)
public func ClearBBs() -> Void {
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_vehicleBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_vehicleTrackingCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}

@addMethod(InputHintManagerGameController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  this.InitBBs(playerGameObject);
}

@addMethod(InputHintManagerGameController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
let psmBlackboard: ref<IBlackboard> = this.GetPSMBlackboard(playerGameObject);
  this.ClearBBs();
}
