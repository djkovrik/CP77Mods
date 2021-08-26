import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.ZoomCalc

@addField(UI_SystemDef)
let CurrentSpeed_IMZ: BlackboardID_Float;

@addField(hudCarController)
let m_UIBlackboard_IMZ: wref<IBlackboard>;

@wrapMethod(hudCarController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  this.m_UIBlackboard_IMZ = GameInstance.GetBlackboardSystem(playerPuppet.GetGame()).Get(GetAllBlackboardDefs().UI_System);
}

@wrapMethod(hudCarController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  wrappedMethod(speedValue);

  let resultingValue: Float;
  let m: Float;
  // Push speed value update if dynamic zoom enabled
  if ZoomConfig.IsDynamicZoomEnabled() {
    m = GameInstance.GetStatsDataSystem(this.m_activeVehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", speedValue, n"speed_to_multiplier");
    resultingValue = ZoomCalc.RoundTo05(speedValue * m);
    this.m_UIBlackboard_IMZ.SetFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed_IMZ, resultingValue);
  }
}
