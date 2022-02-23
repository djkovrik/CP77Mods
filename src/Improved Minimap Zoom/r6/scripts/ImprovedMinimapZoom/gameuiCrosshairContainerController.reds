@replaceMethod(gameuiCrosshairContainerController)
protected final func RegisterPSMListeners(playerPuppet: ref<GameObject>) -> Void {
  let bbCrosshairInfo: ref<IBlackboard>;
  let bbVehicleInfo: ref<IBlackboard>;
  this.m_Player = playerPuppet as PlayerPuppet;
  let playerSMDef: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
  if IsDefined(playerSMDef) {
    bbCrosshairInfo = this.GetPSMBlackboard(playerPuppet);
    if IsDefined(bbCrosshairInfo) {
      this.m_crosshairStateBlackboardId = bbCrosshairInfo.RegisterListenerInt(playerSMDef.Crosshair, this, n"OnPSMCrosshairStateChanged");
      this.m_visionStateBlackboardId = bbCrosshairInfo.RegisterDelayedListenerInt(playerSMDef.Vision, this, n"OnPSMVisionStateChanged");
      this.m_bbPlayerTierEventId = bbCrosshairInfo.RegisterListenerInt(playerSMDef.SceneTier, this, n"OnSceneTierChange");
    };
  };
  if IsDefined(this.m_Player) && this.m_Player.IsControlledByLocalPeer() {
    // bbVehicleInfo = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    // this.m_isMountedBlackboardId = bbVehicleInfo.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountChanged");
    bbVehicleInfo = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_isMountedBlackboardId = bbVehicleInfo.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this, n"OnMountChanged");
  };
}

@replaceMethod(gameuiCrosshairContainerController)
protected final func UnregisterPSMListeners(playerPuppet: ref<GameObject>) -> Void {
  let bbCrosshairInfo: ref<IBlackboard>;
  let bbVehicleInfo: ref<IBlackboard>;
  let playerSMBB: ref<IBlackboard>;
  let playerSMDef: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
  if IsDefined(playerSMDef) {
    bbCrosshairInfo = this.GetPSMBlackboard(playerPuppet);
    if IsDefined(bbCrosshairInfo) {
      bbCrosshairInfo.UnregisterListenerInt(playerSMDef.Crosshair, this.m_crosshairStateBlackboardId);
      bbCrosshairInfo.UnregisterDelayedListener(playerSMDef.Vision, this.m_visionStateBlackboardId);
      bbCrosshairInfo.UnregisterListenerInt(playerSMDef.SceneTier, this.m_bbPlayerTierEventId);
    };
  };
  playerSMBB = this.GetPSMBlackboard(playerPuppet);
  if IsDefined(this.m_crosshairStateBlackboardId) {
    playerSMBB.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.Crosshair, this.m_crosshairStateBlackboardId);
  };
  if IsDefined(this.m_CombatStateBlackboardId) {
    playerSMBB.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_CombatStateBlackboardId);
  };
  if IsDefined(this.m_isMountedBlackboardId) {
    // bbVehicleInfo = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    // bbVehicleInfo.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_isMountedBlackboardId);
    bbVehicleInfo = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    bbVehicleInfo.UnregisterDelayedListener(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this.m_isMountedBlackboardId);
  };
}