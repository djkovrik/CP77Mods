@addField(UI_SystemDef)
let CurrentSpeed: BlackboardID_Int;

@addField(hudCarController)
let m_speedBlackboard: wref<IBlackboard>;

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
  this.m_speedBlackboard = GameInstance.GetBlackboardSystem(playerPuppet.GetGame()).Get(GetAllBlackboardDefs().UI_System);
}

@replaceMethod(hudCarController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  speedValue = AbsF(speedValue);
  let multiplier: Float = GameInstance.GetStatsDataSystem(this.m_activeVehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", speedValue, n"speed_to_multiplier");
  let resultingValue: Int32 = RoundMath(speedValue * multiplier);
  inkTextRef.SetText(this.m_SpeedValue, IntToString(resultingValue));
  this.m_speedBlackboard.SetInt(GetAllBlackboardDefs().UI_System.CurrentSpeed, resultingValue);
}
