import LimitedHudConfig.LHUDAddonsConfig

@addField(ScriptedPuppet)
private let lhudAddonsConfig: ref<LHUDAddonsConfig>;

@wrapMethod(ScriptedPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@replaceMethod(ScriptedPuppet)
public const func GetCurrentOutline() -> EFocusOutlineType {
  let attitude: EAIAttitude;
  let outlineType: EFocusOutlineType;
  let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let hasPingEffect: Bool = this.HasPingEffectLHUD();
  if this.IsQuest() {
    return EFocusOutlineType.QUEST;
  };
  if !this.IsActive() {
    return EFocusOutlineType.ITEM;
  };
  attitude = GameObject.GetAttitudeTowards(this, playerPuppet);
  if this.IsAggressive() || this.IsBoss() || Equals(this.GetNPCRarity(), gamedataNPCRarity.MaxTac) {
    if Equals(attitude, EAIAttitude.AIA_Friendly) {
      outlineType = EFocusOutlineType.FRIENDLY;
    } else {
      if this.IsPrevention() && Equals(attitude, EAIAttitude.AIA_Neutral) {
        outlineType = EFocusOutlineType.NEUTRAL;
      } else {
        if this.lhudAddonsConfig.HighlightUnderPingOnly {
          if hasPingEffect {
            outlineType = EFocusOutlineType.HOSTILE;
          } else {
            outlineType = EFocusOutlineType.INVALID;
          };
        } else {
          outlineType = EFocusOutlineType.HOSTILE;
        };
      };
    };
  } else {
    if this.IsTaggedinFocusMode() {
      outlineType = EFocusOutlineType.NEUTRAL;
    } else {
      outlineType = EFocusOutlineType.INVALID;
    };
  };
  return outlineType;
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
