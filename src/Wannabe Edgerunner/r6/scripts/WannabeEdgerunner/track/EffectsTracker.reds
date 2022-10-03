import Edgerunning.System.EdgerunningSystem

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  wrappedMethod(evt);
  let effectId: TweakDBID = evt.staticData.GetID();
  if Equals(t"HousingStatusEffect.Rested", effectId) {
    EdgerunningSystem.GetInstance(this.GetGame()).OnSleep();
  } else {
    if Equals(t"BaseStatusEffect.RipperDocMedBuff", effectId) {
      EdgerunningSystem.GetInstance(this.GetGame()).OnBuff();
    };
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
  wrappedMethod(evt);
  let effectId: TweakDBID = evt.staticData.GetID();
  if Equals(t"BaseStatusEffect.RipperDocMedBuff", effectId) {
    EdgerunningSystem.GetInstance(this.GetGame()).OnBuffEnded();
  };
}
