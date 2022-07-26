import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.ZoomCalc

@addField(UI_SystemDef)
let CurrentSpeed_IMZ: BlackboardID_Float;

@addField(hudCarController)
let m_UIBlackboard_IMZ: wref<IBlackboard>;

@addField(hudCarController)
let m_config: wref<ZoomConfig>;

@wrapMethod(hudCarController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let puppet: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
  if IsDefined(puppet) {
    this.m_config = puppet.IMZConfig();
    this.m_UIBlackboard_IMZ = GameInstance.GetBlackboardSystem(puppet.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  };
}

@wrapMethod(hudCarController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  wrappedMethod(speedValue);

  let resultingValue: Float;
  let m: Float;
  // Push speed value update if dynamic zoom enabled
  if this.m_config.isDynamicZoomEnabled {
    m = GameInstance.GetStatsDataSystem(this.m_activeVehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", speedValue, n"speed_to_multiplier");
    resultingValue = ZoomCalc.RoundTo05(speedValue * m);
    this.m_UIBlackboard_IMZ.SetFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed_IMZ, resultingValue);
  }
}
