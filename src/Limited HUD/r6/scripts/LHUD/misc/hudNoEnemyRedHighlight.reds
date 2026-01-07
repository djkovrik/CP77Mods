import LimitedHudConfig.LHUDAddonsConfig

@addField(ScriptedPuppet)
private let lhudAddonsConfig: ref<LHUDAddonsConfig>;

@wrapMethod(ScriptedPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@wrapMethod(ScriptedPuppet)
public const func GetCurrentOutline() -> EFocusOutlineType {
  let wrapped: EFocusOutlineType = wrappedMethod();
  let hasPingEffect: Bool = this.HasPingEffectLHUD();
  let puppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let puppetAttitude: EAIAttitude = GameObject.GetAttitudeTowards(this, puppet);

  if Equals(puppetAttitude, EAIAttitude.AIA_Hostile) && this.lhudAddonsConfig.HighlightUnderPingOnly && hasPingEffect {
    return EFocusOutlineType.HOSTILE;
  };

  return wrapped;
}


@addMethod(ScriptedPuppet)
private func HasPingEffectLHUD() -> Bool {
  for effect in [t"BaseStatusEffect.Ping", t"BaseStatusEffect.PingLevel2", t"BaseStatusEffect.PingLevel3", t"BaseStatusEffect.PingLevel4"] {
    if StatusEffectSystem.ObjectHasStatusEffect(this, effect) {
      return true;
    };
  };

  return StatusEffectSystem.ObjectHasStatusEffectWithTag(this, n"Ping");
}
