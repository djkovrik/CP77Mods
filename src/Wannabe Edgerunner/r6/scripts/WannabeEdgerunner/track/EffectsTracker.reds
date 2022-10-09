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

// Reset on bed interaction

@addField(dialogWidgetGameController)
private let m_lastChoiceBB: wref<IBlackboard>;

@addField(dialogWidgetGameController)
private let m_lastChoiceCallbackId: ref<CallbackHandle>;

@addField(dialogWidgetGameController)
private let m_lastSelectedHub: String = "";

@wrapMethod(dialogWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.m_lastChoiceBB = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIInteractions);
  this.m_lastChoiceCallbackId = this.m_lastChoiceBB.RegisterListenerVariant(GetAllBlackboardDefs().UIInteractions.LastAttemptedChoice, this, n"OnLastAttemptedChoiceCustom");
}

@wrapMethod(dialogWidgetGameController)
protected cb func OnDialogsSelectIndex(index: Int32) -> Bool {
  wrappedMethod(index);
  if ArraySize(this.m_data.choiceHubs) > 0 {
    this.m_lastSelectedHub = this.m_data.choiceHubs[0].title;
  };
}

@addMethod(dialogWidgetGameController)
protected cb func OnLastAttemptedChoiceCustom(value: Variant) -> Bool {
  if Equals(this.m_lastSelectedHub, "LocKey#46418") {
    this.m_lastSelectedHub = "";
    EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).OnSleep();
    E("Bed activated - reset");
  };
}

@wrapMethod(dialogWidgetGameController)
protected cb func OnUninitialize() -> Bool {
  this.m_lastChoiceBB.UnregisterListenerVariant(GetAllBlackboardDefs().UIInteractions.LastAttemptedChoice, this.m_lastChoiceCallbackId);
  wrappedMethod();
}
