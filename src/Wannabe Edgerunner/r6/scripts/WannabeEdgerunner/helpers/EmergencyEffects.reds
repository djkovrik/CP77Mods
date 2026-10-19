public class WEEmergencyEffects {
  public static func IsOwned(id: TweakDBID) -> Bool {
    return id == t"BaseStatusEffect.NewPrePsychosisEffectBase"
      || id == t"BaseStatusEffect.NewPrePsychosisEffectLightFx"
      || id == t"BaseStatusEffect.NewPrePsychosisEffectNormalFx"
      || id == t"BaseStatusEffect.NewPsychosisEffectBase"
      || id == t"BaseStatusEffect.NewPsychosisEffectLightFx"
      || id == t"BaseStatusEffect.NewPsychosisEffectNormalFx"
      || id == t"BaseStatusEffect.NewPostPsychosisEffectBase"
      || id == t"BaseStatusEffect.NewPostPsychosisEffectLightFx"
      || id == t"BaseStatusEffect.NewPostPsychosisEffectNormalFx"
      || id == t"BaseStatusEffect.RipperDocMedBuff"
      || id == t"BaseStatusEffect.RipperDocMedBuffUncommon"
      || id == t"BaseStatusEffect.RipperDocMedBuffCommon"
      || id == t"BaseStatusEffect.LifeAffirmedBuff";
  }

  public static func Clear(player: ref<PlayerPuppet>) -> Int32 {
    if !IsDefined(player) { return 0; };
    if IsDefined(player.wePsychosisCombat) { player.wePsychosisCombat.EmergencyStop(); };
    let effects: array<ref<StatusEffect>>;
    let statuses: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(player.GetGame());
    statuses.GetAppliedEffects(player.GetEntityID(), effects);
    for effect in effects {
      if WEEmergencyEffects.IsOwned(effect.GetRecord().GetID()) {
        statuses.RemoveStatusEffect(player.GetEntityID(), effect.GetRecord().GetID(), effect.GetStackCount());
      };
    };

    // Emergency fallback also handles FX detached from their original status effect.
    let visuals: array<CName> = [n"status_bleeding", n"fx_damage_high", n"personal_link_glitch", n"hacking_glitch_low", n"fast_travel_glitch", n"johnny_sickness_blackout", n"reflex_buster"];
    for name in visuals { GameObjectEffectHelper.StopEffectEvent(player, name); };
    let sounds: array<CName> = [n"ONO_V_LongPain", n"ui_gmpl_perk_edgerunner", n"ono_v_pain_short", n"ono_v_fear_panic_scream", n"ono_v_pain_long"];
    for name in sounds { GameObject.StopSoundEvent(player, name); };
    let breathing: ref<AnimFeature_CameraBreathing> = new AnimFeature_CameraBreathing();
    breathing.amplitudeWeight = 0.0;
    breathing.dampIncreaseSpeed = 9999.0;
    breathing.dampDecreaseSpeed = 9999.0;
    AnimationControllerComponent.ApplyFeature(player, n"CameraBreathingMedium", breathing);

    ArrayClear(effects);
    statuses.GetAppliedEffects(player.GetEntityID(), effects);
    let remaining: Int32 = 0;
    for effect in effects {
      if WEEmergencyEffects.IsOwned(effect.GetRecord().GetID()) { remaining += 1; };
    };
    return remaining;
  }
}
