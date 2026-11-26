module CombatAwareness

@addField(PlayerPuppet)
public let caKnockdown: TweakDBID;

@addField(StatusEffectEvents)
public let caFastRecovery: Bool;

@addField(StatusEffectEvents)
public let caRecoveryTotalDuration: Float;

@addField(StatusEffectEvents)
public let caRecoveryHitDirection: Vector4;

@addField(PlayerPuppet)
public let caRecoveryAnimation: wref<AnimFeature_StatusEffect>;

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  if Equals(evt.staticData.StatusEffectType().Type(), gamedataStatusEffectType.Knockdown) {
    this.caKnockdown = evt.isAppliedOnSpawn ? TDBID.None() : evt.staticData.GetID();
  };

  return wrappedMethod(evt);
}

@addMethod(KnockdownEvents)
private final func CATryFastRecovery(si: ref<StateGameScriptInterface>) -> Void {
  let system = AwarenessSystem.Get(si.GetGame());
  if !system.Ready(5) || !IsDefined(this.m_statusEffectRecord) { 
    return;
   };

  let id = this.m_statusEffectRecord.GetID();
  if system.player.caKnockdown != id { 
    return; 
  };

  let effects: array<ref<StatusEffect>>;
  let statuses = si.GetStatusEffectSystem();
  let ownerID = si.owner.GetEntityID();
  statuses.GetAppliedEffectsWithID(ownerID, id, effects);

  if ArraySize(effects) == 0 { 
    return; 
  }

  let effect = effects[0];
  let source = GameInstance.FindEntityByID(si.GetGame(), effect.GetInstigatorEntityID()) as GameObject;
  if !IsDefined(source) || NotEquals(GameObject.GetAttitudeTowards(source, si.owner), EAIAttitude.AIA_Hostile) { 
    return; 
  };

  let remaining = effect.GetRemainingDuration();
  if remaining == 0.0 { return; };
  let total = effect.GetTotalDuration();
  if remaining > 0.0 && !statuses.SetStatusEffectRemainingDuration(ownerID, id, remaining / Training.KnockdownRecoveryRate()) { 
    return; 
  };

  this.caRecoveryTotalDuration = total;
  this.caRecoveryHitDirection = effect.GetDirection();
  this.caFastRecovery = true;

  system.player.caRecoveryAnimation = this.m_animFeatureStatusEffect;
  system.Spend(5);
}

@wrapMethod(KnockdownEvents)
protected func SendStatusEffectAnimDataToGraph(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, state: EKnockdownStates) -> Void {
  if Equals(state, EKnockdownStates.Land) && !this.m_bikeKnockdown && !this.caFastRecovery {
    this.CATryFastRecovery(scriptInterface);
  };
  wrappedMethod(stateContext, scriptInterface, state);
}

@wrapMethod(StatusEffectHelper)
public final static func PopulateStatusEffectAnimData(owner: ref<GameObject>, statusEffectRecord: wref<StatusEffect_Record>, state: EKnockdownStates, hitDirection: Vector4, out animData: ref<AnimFeature_StatusEffect>) -> Void {
  wrappedMethod(owner, statusEffectRecord, state, hitDirection, animData);
  if Equals(state, EKnockdownStates.Land) || Equals(state, EKnockdownStates.Recovery) {
    let player = owner as PlayerPuppet;
    if IsDefined(player) && IsDefined(animData) && animData == player.caRecoveryAnimation {
      animData.duration /= Training.KnockdownRecoveryRate();
    };
  };
}

@wrapMethod(StatusEffectEvents)
private final func UpdateTimes(timeDelta: Float, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if this.caFastRecovery { 
    timeDelta *= Training.KnockdownRecoveryRate(); 
  };
  wrappedMethod(timeDelta, scriptInterface);
}

@wrapMethod(StatusEffectEvents)
protected final const func GetStatusEffectRemainingDuration(const scriptInterface: ref<StateGameScriptInterface>, const stateContext: ref<StateContext>) -> Float {
  if this.caFastRecovery {
    return this.caRecoveryTotalDuration - this.m_timeInEffect;
  };
  return wrappedMethod(scriptInterface, stateContext);
}

@wrapMethod(StatusEffectEvents)
protected final const func GetStatusEffectHitDirection(const scriptInterface: ref<StateGameScriptInterface>) -> Vector4 {
  if this.caFastRecovery {
    return this.caRecoveryHitDirection;
  };
  return wrappedMethod(scriptInterface);
}

@wrapMethod(KnockdownEvents)
protected func CommonOnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if this.caFastRecovery {
    let player = scriptInterface.owner as PlayerPuppet;
    if IsDefined(player) && player.caRecoveryAnimation == this.m_animFeatureStatusEffect {
      player.caRecoveryAnimation = null;
    };
    this.caFastRecovery = false;
  };
 
  wrappedMethod(stateContext, scriptInterface);
}
