import Edgerunning.System.EdgerunningSystem

@addMethod(PreventionSystem)
public func SpawnPoliceForPsychosis(config: ref<EdgerunningConfig>) -> Void {
  if !IsDefined(this.m_player) || !this.CanPreventionReactToInput() { return; };
  let target: EPreventionHeatStage = this.GetHeatStageLevel(config.psychoHeatLevel);
  if EnumInt(target) > EnumInt(this.m_heatStage) { this.ChangeHeatStage(target, "EnterCombat"); };
  if Equals(config.psychoHeatLevel, WannabeHeatLevel.MaxTac) && this.CanRequestAVSpawn() {
    this.CheckPossibleSpawnPosAndRequestAVSpawn();
  };
}


@addMethod(PreventionSystem)
public func GetHeatStageLevel(from: WannabeHeatLevel) -> EPreventionHeatStage {
  switch (from) {
    case WannabeHeatLevel.One: return EPreventionHeatStage.Heat_1;
    case WannabeHeatLevel.Two: return EPreventionHeatStage.Heat_2;
    case WannabeHeatLevel.Three: return EPreventionHeatStage.Heat_3;
    case WannabeHeatLevel.Four: return EPreventionHeatStage.Heat_4;
    case WannabeHeatLevel.Five: return EPreventionHeatStage.Heat_5;
    case WannabeHeatLevel.MaxTac: return EPreventionHeatStage.Heat_5;
  };

  return EPreventionHeatStage.Heat_1;
}

@addMethod(PreventionSystem)
public func ClearWantedLevel() -> Void {
  this.execInstructionSafe("ResetOnPlayerChoice");
}

@wrapMethod(PreventionSystem)
private final const func ShouldSpawnPatrolVehicleWhenInSearch() -> Bool {
  let shouldSpawn: Bool = wrappedMethod();
  if !IsDefined(this.m_player) { return shouldSpawn; };
  let isInInterior: Bool = IsEntityInInteriorArea(this.m_player);
  let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(this.m_player.GetGame());
  let isPsychosisActive: Bool = IsDefined(system) && system.IsPsychosisActive();
  return (isPsychosisActive && !isInInterior) || shouldSpawn;
}

// AV eligibility is owned by the original game (live squads, pending AVs, cooldown and quest rules).
