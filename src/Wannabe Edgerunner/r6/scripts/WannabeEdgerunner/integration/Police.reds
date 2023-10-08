import Edgerunning.System.EdgerunningSystem

@addMethod(PreventionSystem)
public func SpawnPoliceForPsychosis(config: ref<EdgerunningConfig>) -> Void {
  if IsDefined(this.m_player) {
    this.m_heatStage = this.GetHeatStageLevel(config.psychoHeatLevel);
    this.HeatPipeline("EnterCombat");
  };
}


@addMethod(PreventionSystem)
public func GetHeatStageLevel(from: Int32) -> EPreventionHeatStage {
  switch (from) {
    case 1: return EPreventionHeatStage.Heat_1;
    case 2: return EPreventionHeatStage.Heat_2;
    case 3: return EPreventionHeatStage.Heat_3;
    case 4: return EPreventionHeatStage.Heat_4;
    case 5: return EPreventionHeatStage.Heat_5;
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
