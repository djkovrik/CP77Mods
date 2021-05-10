/////////////////////////////////////////////////////////////////////////////////
// Show world mappins when player in stealth, combat or when scanner is active //
/////////////////////////////////////////////////////////////////////////////////

@addField(WorldMappinsContainerController)
public let m_playerPuppet: wref<PlayerPuppet>;

@addField(WorldMappinsContainerController)
public let m_playerStateMachineBlackboard: ref<IBlackboard>;

@addField(WorldMappinsContainerController)
public let m_scannerTrackingBlackboard: ref<IBlackboard>;

@addField(WorldMappinsContainerController)
public let m_playerStateCallback: Uint32;

@addField(WorldMappinsContainerController)
public let m_scannerTrackingCallback: Uint32;

@addMethod(WorldMappinsContainerController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func OnScannerStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
public func DetermineCurrentVisibility() -> Void {
  let isInCombat: Bool = Equals(this.m_playerStateMachineBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isInStealth: Bool = Equals(this.m_playerStateMachineBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isScannerEnabled: Bool = this.m_scannerTrackingBlackboard.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  let isVisible: Bool = isInCombat || isInStealth || isScannerEnabled;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(WorldMappinsContainerController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerPuppet = playerPuppet as PlayerPuppet;
  // Define blackboards
  if IsDefined(this.m_playerPuppet) && this.m_playerPuppet.IsControlledByLocalPeer() {
    this.m_playerStateMachineBlackboard = this.GetPSMBlackboard(this.m_playerPuppet);
  } else {
    Log("PlayerStateMachine blackboard not defined!");
  }

  this.m_scannerTrackingBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
  // Define callbacks
  this.m_playerStateCallback = this.m_playerStateMachineBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
  this.m_scannerTrackingCallback = this.m_scannerTrackingBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnScannerStateChanged"); 

  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_playerStateMachineBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_playerStateCallback);
  this.m_scannerTrackingBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback);
  this.m_playerPuppet = null;
}