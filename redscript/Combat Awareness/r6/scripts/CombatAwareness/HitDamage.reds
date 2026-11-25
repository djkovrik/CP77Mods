module CombatAwareness

@wrapMethod(StatPoolsManager)
private final static func ApplyDamageToArmorSingle(hitEvent: ref<gameHitEvent>, dmgType: gamedataDamageType, out initialDamageValue: Float, forReal: Bool, valuesLost: script_ref<array<SDamageDealt>>) -> Void {
  wrappedMethod(hitEvent, dmgType, initialDamageValue, forReal, valuesLost);

  if !forReal || hitEvent.projectionPipeline || initialDamageValue <= 0.0 {
     return; 
  };

  let source = hitEvent.attackData.GetInstigator();
  let target = hitEvent.target;
  if !target.IsPlayer() && (!IsDefined(source) || !source.IsPlayer()) { 
    return; 
  };

  let system: ref<AwarenessSystem> = AwarenessSystem.Get(target.GetGame());
  let pool = GameInstance.GetStatPoolsSystem(target.GetGame());
  let minimum = hitEvent.attackData.GetMinimumHealthPercent();

  if GameInstance.GetGodModeSystem(target.GetGame()).HasGodMode(target.GetEntityID(), gameGodModeType.Immortal) {
    minimum = MaxF(minimum, 1.0);
  };

  let healthID = Cast<StatsObjectID>(target.GetEntityID());
  let eligibleLoss = initialDamageValue;

  if minimum > 0.0 {
    let percent = pool.GetStatPoolValue(healthID, gamedataStatPoolType.Health);
    eligibleLoss = MinF(eligibleLoss, pool.ToPoints(healthID, gamedataStatPoolType.Health, MaxF(0.0, percent - minimum)));
  }

  if target.IsPlayer() && hitEvent.attackData.HasFlag(hitFlag.CannotKillPlayer) {
    let health = pool.GetStatPoolValue(healthID, gamedataStatPoolType.Health, false);
    if initialDamageValue > health { eligibleLoss = MinF(eligibleLoss, health - 1.0); };
  }

  if eligibleLoss <= 0.0 { return; };
  if target.IsPlayer() { system.Interrupt(); };
}
