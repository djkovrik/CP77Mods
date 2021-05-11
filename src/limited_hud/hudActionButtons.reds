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
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func DetermineCurrentVisibility() -> Void {
  // Basic checks
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && ActionButtonsModuleConfig.ShowInCombat();
  let showForStealth: Bool =  isCurrentStateStealth && ActionButtonsModuleConfig.ShowInStealth();
  let showForWeapon: Bool = isWeaponUnsheathed && ActionButtonsModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && ActionButtonsModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForStealth || showForWeapon || showForZoom;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(HotkeysWidgetController)
public func InitializeBBs(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    // Define blackboards
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("HotkeysWidgetController blackboards not defined!");
  }
}

@replaceMethod(HotkeysWidgetController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  let controlledPuppet: wref<gamePuppetBase> = GetPlayer(this.m_gameInstance);
  let controlledPuppetRecordID: TweakDBID;
  if controlledPuppet != null {
    this.InitializeBBs(controlledPuppet);
    controlledPuppetRecordID = controlledPuppet.GetRecordID();
    if controlledPuppetRecordID == t"Character.johnny_replacer" {
      inkWidgetRef.SetMargin(this.m_hotkeysList, new inkMargin(84.00, 0.00, 0.00, 0.00));
    } else {
      inkWidgetRef.SetMargin(this.m_hotkeysList, new inkMargin(331.00, 0.00, 0.00, 0.00));
    };
  } else {
    inkWidgetRef.SetMargin(this.m_hotkeysList, new inkMargin(331.00, 0.00, 0.00, 0.00));
  };
}

@addMethod(HotkeysWidgetController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}
