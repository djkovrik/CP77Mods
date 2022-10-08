import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  wrappedMethod(evt);
  let effectId: TweakDBID = evt.staticData.GetID();
  if this.IsHousingEffect(effectId) && !evt.isAppliedOnSpawn {
    EdgerunningSystem.GetInstance(this.GetGame()).OnSleep();
  } else {
    if this.IsRipperdocMedBuff(effectId) {
      EdgerunningSystem.GetInstance(this.GetGame()).OnBuff();
    };
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
  wrappedMethod(evt);
  let effectId: TweakDBID = evt.staticData.GetID();
  if this.IsRipperdocMedBuff(effectId)  {
    EdgerunningSystem.GetInstance(this.GetGame()).OnBuffEnded();
  };
}

@addMethod(PlayerPuppet)
private func IsRipperdocMedBuff(id: TweakDBID) -> Bool {
  return Equals(t"BaseStatusEffect.RipperDocMedBuff", id)
    || Equals(t"BaseStatusEffect.RipperDocMedBuffUncommon", id)
    || Equals(t"BaseStatusEffect.RipperDocMedBuffCommon", id);
}

@addMethod(PlayerPuppet)
private func IsHousingEffect(id: TweakDBID) -> Bool {
  return Equals(t"HousingStatusEffect.Rested", id)
    || Equals(t"HousingStatusEffect.Refreshed", id)
    || Equals(t"ousingStatusEffect.Energized", id);
}
