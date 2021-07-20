import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.ZoomCalc

@addField(UI_SystemDef)
let CurrentSpeed: BlackboardID_Float;

@addField(hudCarController)
let m_UIBlackboard: wref<IBlackboard>;

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
  this.m_UIBlackboard = GameInstance.GetBlackboardSystem(playerPuppet.GetGame()).Get(GetAllBlackboardDefs().UI_System);
}

@replaceMethod(hudCarController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  let resultingValue: Float;
  speedValue = AbsF(speedValue);
  let multiplier: Float = GameInstance.GetStatsDataSystem(this.m_activeVehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", speedValue, n"speed_to_multiplier");
  inkTextRef.SetText(this.m_SpeedValue, IntToString(RoundMath(speedValue * multiplier)));

  // Push speed value update if dynamic zoom enabled
  if ZoomConfig.IsDynamicZoomEnabled() {
    resultingValue = ZoomCalc.RoundTo05(speedValue * multiplier);
    this.m_UIBlackboard.SetFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed, resultingValue);
  }
}
