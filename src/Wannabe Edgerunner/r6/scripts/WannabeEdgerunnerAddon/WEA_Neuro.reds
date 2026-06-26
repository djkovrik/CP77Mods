// Wannabe Edgerunner Add-on - neuroblocker quality tracker (;¬_¬)
// watches for neuroblocker status effects applying/removing so we know which tier is active

module Edgerunning.System
import Edgerunning.Common.*

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
    let result = wrappedMethod(evt);
    let effectId: TweakDBID = evt.staticData.GetID();
    WEA_OnNeuroBlockerApplied(this, effectId);
    return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
    let result = wrappedMethod(evt);
    let effectId: TweakDBID = evt.staticData.GetID();
    WEA_OnNeuroBlockerRemoved(this, effectId);
    return result;
}

// stash reduction % on the system - AddHumanityDamage picks it up (ง •̀_•́)ง
public static func WEA_OnNeuroBlockerApplied(player: ref<PlayerPuppet>, effectId: TweakDBID) -> Void {
    if !WEA_IsNeuroBlockerEffect(effectId) { return; };

    let config = WEAConfig.Get();
    if !config.neuroEnabled { return; };

    let sys = EdgerunningSystem.GetInstance(player.GetGame());
    if !IsDefined(sys) { return; };

    // map the specific tweakDB id → config percent. base game has Common/Uncommon/the unnamed "Rare" one
    let reduction: Float;
    if Equals(effectId, t"BaseStatusEffect.RipperDocMedBuffCommon") {
        reduction = Cast<Float>(config.neuroReductionCommon) / 100.0;
        E(s"! WEA Neuro: Common neuroblocker applied, \(config.neuroReductionCommon)% reduction");
    } else {
        if Equals(effectId, t"BaseStatusEffect.RipperDocMedBuffUncommon") {
            reduction = Cast<Float>(config.neuroReductionUncommon) / 100.0;
            E(s"! WEA Neuro: Uncommon neuroblocker applied, \(config.neuroReductionUncommon)% reduction");
        } else {
            reduction = Cast<Float>(config.neuroReductionRare) / 100.0;
            E(s"! WEA Neuro: Rare neuroblocker applied, \(config.neuroReductionRare)% reduction");
        };
    };

    sys.m_weaNeuroReduction = reduction;
}

// neuroblocker wore off (｡•́︿•̀｡)
public static func WEA_OnNeuroBlockerRemoved(player: ref<PlayerPuppet>, effectId: TweakDBID) -> Void {
    if !WEA_IsNeuroBlockerEffect(effectId) { return; };

    let sys = EdgerunningSystem.GetInstance(player.GetGame());
    if !IsDefined(sys) { return; };

    sys.m_weaNeuroReduction = 0.0;
    E("! WEA Neuro: neuroblocker wore off, full damage restored");
}

// the three known neuroblocker buffs. the unnamed "Rare" one is just `RipperDocMedBuff` (no suffix)
public static func WEA_IsNeuroBlockerEffect(effectId: TweakDBID) -> Bool {
    return Equals(effectId, t"BaseStatusEffect.RipperDocMedBuff")
        || Equals(effectId, t"BaseStatusEffect.RipperDocMedBuffUncommon")
        || Equals(effectId, t"BaseStatusEffect.RipperDocMedBuffCommon");
}
