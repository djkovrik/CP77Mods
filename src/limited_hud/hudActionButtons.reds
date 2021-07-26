//////////////////////////////////////////////////////////////
// Show action buttons panel depending on the module config //
//////////////////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.ActionButtonsModuleConfig

@addMethod(HotkeysWidgetController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func DetermineCurrentVisibility() -> Void {
  // Check if enabled
  if !ActionButtonsModuleConfig.IsEnabled() {
    return ;
  };

  // Check for braindance
  if this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive) {
    this.GetRootWidget().SetVisible(false);
    return;
  };

  // Basic checks
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isCurrentStateOutOfCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.OutOfCombat);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  let outOfCombatAvailable: Bool = isCurrentStateOutOfCombat && !isWeaponUnsheathed && !isZoomActive;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && ActionButtonsModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = outOfCombatAvailable && ActionButtonsModuleConfig.ShowOutOfCombat();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && ActionButtonsModuleConfig.BindToGlobalHotkey();
  let showForStealth: Bool =  isCurrentStateStealth && ActionButtonsModuleConfig.ShowInStealth();
  let showForWeapon: Bool = isWeaponUnsheathed && ActionButtonsModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && ActionButtonsModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForOutOfCombat || showForGlobalHotkey || showForStealth || showForWeapon || showForZoom;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(HotkeysWidgetController)
public func InitializeBBs(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    // Define blackboards
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("HotkeysWidgetController blackboards not defined!");
  }
}

@wrapMethod(HotkeysWidgetController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let puppet: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
  if IsDefined(puppet) {
    this.InitializeBBs(puppet);
  };
}

@addMethod(HotkeysWidgetController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}
