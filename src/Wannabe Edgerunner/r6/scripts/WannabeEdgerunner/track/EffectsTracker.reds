import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  wrappedMethod(evt);
  let effectId: TweakDBID = evt.staticData.GetID();
  if this.IsRipperdocMedBuff(effectId) {
    EdgerunningSystem.GetInstance(this.GetGame()).OnBuff();
  };
  if Equals(effectId, t"BaseStatusEffect.Tech_Master_Perk_3_Buff") {
    EdgerunningSystem.GetInstance(this.GetGame()).OnEdgerunnerPerkActivated();
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

// -- TRACK FOR HUB INTERACTION TITLES

public class ResetSavedHub extends Event {}

@addField(InteractionUIBase)
private let m_lastSelectedHub: String = "";

@addField(dialogWidgetGameController)
private let m_lastChoiceBB: wref<IBlackboard>;

@addField(dialogWidgetGameController)
private let m_lastChoiceCallbackId: ref<CallbackHandle>;

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

@wrapMethod(dialogWidgetGameController)
protected cb func OnUninitialize() -> Bool {
  this.m_lastChoiceBB.UnregisterListenerVariant(GetAllBlackboardDefs().UIInteractions.LastAttemptedChoice, this.m_lastChoiceCallbackId);
  wrappedMethod();
}

@addMethod(dialogWidgetGameController)
protected cb func OnLastAttemptedChoiceCustom(value: Variant) -> Bool {
  let action: HumanityRestoringAction = EdgerunnerInteractionChecker.Check(this.m_lastSelectedHub);

  if Equals(action, HumanityRestoringAction.Lover) {
      // FIXME: There has to be a better way to handle these. This is far to high up in the stack.
      // FIXME: Need some of the idle values for non-Judy lovers
      // sq027_panam_lover -> After Romance chosen in Queen of the Highway
      // sq028_kerry_lover -> After Romance chosen in Boat Drinks
      // sq029_river_lover -> After Romance chosen in Following the River
      // sq030_judy_lover  -> After Romance chosen in Pyramid Song
      if (Equals("Judy", this.m_lastSelectedHub) || Equals("LocKey#34479", this.m_lastSelectedHub)) && GameInstance.GetQuestsSystem(this.GetPlayerControlledObject().GetGame()).GetFactStr("sq030_judy_lover") == 1 {
        action = HumanityRestoringAction.Lover;
      } else if (Equals("River", this.m_lastSelectedHub)) && GameInstance.GetQuestsSystem(this.GetPlayerControlledObject().GetGame()).GetFactStr("sq029_river_lover") == 1 {
        action = HumanityRestoringAction.Lover;
      } else if (Equals("Kerry", this.m_lastSelectedHub)) && GameInstance.GetQuestsSystem(this.GetPlayerControlledObject().GetGame()).GetFactStr("sq028_kerry_lover") == 1 {
        action = HumanityRestoringAction.Lover;
      } else if (Equals("Panam", this.m_lastSelectedHub)) && GameInstance.GetQuestsSystem(this.GetPlayerControlledObject().GetGame()).GetFactStr("sq027_panam_lover") == 1 {
        action = HumanityRestoringAction.Lover;
      } else {
        action = HumanityRestoringAction.Unknown;
      };
    };

  if NotEquals(action, HumanityRestoringAction.Unknown) {
    EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).OnRestoreAction(action);
  };
  this.m_lastSelectedHub = "";
}

@wrapMethod(InteractionUIBase)
protected cb func OnLootingData(value: Variant) -> Bool {
  this.m_lastSelectedHub = "";
  wrappedMethod(value);
}

@addMethod(InteractionUIBase)
protected cb func OnResetSavedHub(evt: ref<ResetSavedHub>) -> Bool {
  this.m_lastSelectedHub = "";
}

@wrapMethod(interactionWidgetGameController)
protected cb func OnUpdateInteraction(argValue: Variant) -> Bool {
  GameInstance.GetUISystem(this.GetOwner().GetGame()).QueueEvent(new ResetSavedHub());
  return wrappedMethod(argValue);
}
