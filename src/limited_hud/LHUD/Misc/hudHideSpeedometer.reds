// Hides TPP speedometer widget
@replaceMethod(hudCarController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_psmBlackboard = this.GetPSMBlackboard(playerPuppet);
  if IsDefined(this.m_psmBlackboard) {
    this.m_PSM_BBID = this.m_psmBlackboard.RegisterDelayedListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomChange");
  };
  this.m_activeVehicle = GetMountedVehicle(this.GetPlayerControlledObject());
  if IsDefined(this.m_activeVehicle) {
    this.GetRootWidget().SetVisible(true);
    this.RegisterToVehicle(true);
    this.Reset();
  };
  this.GetRootWidget().SetOpacity(0.0);
}
