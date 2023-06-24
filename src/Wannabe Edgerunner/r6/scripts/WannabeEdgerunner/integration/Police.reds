import Edgerunning.System.EdgerunningSystem

@addMethod(PreventionSystem)
public func SpawnPoliceForPsychosis(config: ref<EdgerunningConfig>) -> Void {
  if IsDefined(this.m_player) {
    this.AddGeneralPercent(Cast<Float>(config.psychoHeatLevel));
    this.HeatPipeline();
  };
}

@addMethod(PreventionSystem)
public func ClearWantedLevel() -> Void {
  this.execInstructionSafe();
}

@wrapMethod(PreventionSystem)
private final func ShouldSpawnVehicle() -> Bool {
  let shouldSpawn: Bool = wrappedMethod();
  let isInInterior: Bool = IsEntityInInteriorArea(this.m_player);
  let isPsychosisActive: Bool = Equals(StatusEffectSystem.ObjectHasStatusEffect(this.m_player, t"BaseStatusEffect.ActivePsychosisBuff"), true);
  return (isPsychosisActive && !isInInterior) || shouldSpawn;
}
