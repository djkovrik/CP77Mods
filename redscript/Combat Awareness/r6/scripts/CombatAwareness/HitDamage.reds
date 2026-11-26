module CombatAwareness

@addField(gameHitEvent)
public let caDamageDisplayDelta: Float;

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

  let system = AwarenessSystem.Get(target.GetGame());
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
  };

  if target.IsPlayer() && hitEvent.attackData.HasFlag(hitFlag.CannotKillPlayer) {
    let health = pool.GetStatPoolValue(healthID, gamedataStatPoolType.Health, false);
    if initialDamageValue > health { eligibleLoss = MinF(eligibleLoss, health - 1.0); };
  };

  if eligibleLoss <= 0.0 { 
    return; 
  };

  if target.IsPlayer() { 
    system.Interrupt(); 
  };

  let kind = hitEvent.attackData.GetAttackType();
  if !IsDefined(source) 
    || AttackData.IsDoT(hitEvent.attackData)
    || hitEvent.attackData.HasFlag(hitFlag.QuickHack) 
    || !(AttackData.IsRangedOrDirect(kind) 
    || AttackData.IsThrown(kind) 
    || AttackData.IsMelee(kind) 
    || AttackData.IsWhip(kind)) {
      return; 
  };

  if target.IsPlayer() && source != target && Equals(GameObject.GetAttitudeTowards(source, target), EAIAttitude.AIA_Hostile) {
    system.Contact(source);
    if system.Deflect(hitEvent) {
      initialDamageValue = eligibleLoss * 0.75;
    };
  } else {
    if source.IsPlayer() 
      && (
      IsDefined(hitEvent.attackData.GetWeapon())
      || AttackData.IsMelee(kind) 
      || AttackData.IsThrown(kind) 
      || AttackData.IsWhip(kind)
      ) 
      && IsDefined(target as NPCPuppet) 
      && (
      target.GetEntityID() == system.studied || Equals(GameObject.GetAttitudeTowards(target, source), EAIAttitude.AIA_Hostile)
      ) {
        system.Contact(target);
        if system.Amplify(hitEvent) {
          let bonus = initialDamageValue * 0.25;
          initialDamageValue += bonus;
          hitEvent.caDamageDisplayDelta += bonus;
        };
    };
  };
}

@wrapMethod(DamageSystem)
public final func ConvertHitDataToDamageInfo(hitEvent: ref<gameHitEvent>) -> array<DamageInfo> {
  let result: array<DamageInfo> = wrappedMethod(hitEvent);
  if hitEvent.caDamageDisplayDelta > 0.0 && ArraySize(result) > 0 && result[0].damageValue > 0.0 {
    result[0].damageValue += hitEvent.caDamageDisplayDelta;
  };
  return result;
}
