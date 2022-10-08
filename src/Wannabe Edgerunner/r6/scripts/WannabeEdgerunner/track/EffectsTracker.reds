import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  wrappedMethod(evt);
  let effectId: TweakDBID = evt.staticData.GetID();
  let isHousingEffect: Bool = Equals(t"HousingStatusEffect.Rested", effectId) 
    || Equals(t"HousingStatusEffect.Refreshed", effectId) 
    || Equals(t"HousingStatusEffect.Energized", effectId); 

  if isHousingEffect && !evt.isAppliedOnSpawn {
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
