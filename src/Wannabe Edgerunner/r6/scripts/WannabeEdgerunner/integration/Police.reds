import Edgerunning.System.EdgerunningSystem

@addMethod(PreventionSystem)
public func SpawnPoliceForPsychosis(config: ref<EdgerunningConfig>) -> Void {
  let current: Int32 = EnumInt(this.m_heatStage);
  let target: EPreventionHeatStage;
  if IsDefined(this.m_player) {
    target = this.GetHeatStageLevel(config.psychoHeatLevel);
    if EnumInt(target) > current {
      this.m_heatStage = target;
    };
    this.HeatPipeline("EnterCombat");
    if Equals(config.psychoHeatLevel, WannabeHeatLevel.MaxTac) {
      this.ChangeHeatStage(EPreventionHeatStage.Heat_5, "EnterCombat");
      this.CheckPossibleSpawnPosAndRequestAVSpawn();
    };
  };
}


@addMethod(PreventionSystem)
public func GetHeatStageLevel(from: WannabeHeatLevel) -> EPreventionHeatStage {
  switch (from) {
    case WannabeHeatLevel.One: return EPreventionHeatStage.Heat_0;
    case WannabeHeatLevel.Two: return EPreventionHeatStage.Heat_1;
    case WannabeHeatLevel.Three: return EPreventionHeatStage.Heat_2;
    case WannabeHeatLevel.Four: return EPreventionHeatStage.Heat_3;
    case WannabeHeatLevel.Five: return EPreventionHeatStage.Heat_4;
    case WannabeHeatLevel.MaxTac: return EPreventionHeatStage.Heat_4;
  };

  return EPreventionHeatStage.Heat_0;
}

@addMethod(PreventionSystem)
public func ClearWantedLevel() -> Void {
  this.execInstructionSafe("ResetOnPlayerChoice");
}

@wrapMethod(PreventionSystem)
private final func ShouldSpawnPatrolVehicleWhenInSearch() -> Bool {
  let shouldSpawn: Bool = wrappedMethod();
  let isInInterior: Bool = IsEntityInInteriorArea(this.m_player);
  let isPsychosisActive: Bool = Equals(StatusEffectSystem.ObjectHasStatusEffect(this.m_player, t"BaseStatusEffect.ActivePsychosisBuff"), true);
  return (isPsychosisActive && !isInInterior) || shouldSpawn;
}

@wrapMethod(PreventionSystem)
private final func CanRequestAVSpawn() -> Bool {
  let config: ref<EdgerunningConfig> = new EdgerunningConfig();
  let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(this.m_player.GetGame());
  let maxTacAvailable: Bool = Equals(config.psychoHeatLevel, WannabeHeatLevel.MaxTac) && system.IsPsychosisActive();
  let wrapped: Bool = wrappedMethod();
  return wrapped || maxTacAvailable;
}
