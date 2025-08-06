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

// -- Track for interactions

@addField(dialogWidgetGameController)
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
protected cb func OnUninitialize() -> Bool {
  this.m_lastChoiceBB.UnregisterListenerVariant(GetAllBlackboardDefs().UIInteractions.LastAttemptedChoice, this.m_lastChoiceCallbackId);
  wrappedMethod();
}

@addMethod(dialogWidgetGameController)
protected cb func OnLastAttemptedChoiceCustom(value: Variant) -> Bool {
  let action: HumanityRestoringAction = EdgerunnerInteractionChecker.Check(this.GetPlayerControlledObject().GetGame(), this.m_lastSelectedHub);
  if NotEquals(action, HumanityRestoringAction.Unknown) {
    EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).OnRestoreAction(action);
  };
  this.m_lastSelectedHub = "";
}

// -- Track for hub title

public class HubTitleUpdatedEvent extends Event {
  public let title: String;

  public static func Create(title: String) -> ref<HubTitleUpdatedEvent> {
    let instance: ref<HubTitleUpdatedEvent> = new HubTitleUpdatedEvent();
    instance.title = title;
    return instance;
  }
}

@addMethod(dialogWidgetGameController)
protected cb func OnHubTitleUpdatedEvent(evt: ref<HubTitleUpdatedEvent>) -> Bool {
  this.m_lastSelectedHub = evt.title;
}

@wrapMethod(DialogHubLogicController)
private final func SetupTitle(const title: script_ref<String>, isActive: Bool, isPossessed: Bool) -> Void {
  let titleStr: String = Deref(title);
  if NotEquals(titleStr, "") && isActive {
    this.QueueEvent(HubTitleUpdatedEvent.Create(titleStr));
  }
  wrappedMethod(title, isActive, isPossessed);
}

@addMethod(DialogHubLogicController)
protected cb func OnUninitialize() -> Bool {
  this.QueueEvent(HubTitleUpdatedEvent.Create(""));
}
