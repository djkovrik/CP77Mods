import ImmersiveTimeskip.Events.InterruptCustomTimeSkipEvent

// Force popup canceling on any triggered call
@wrapMethod(PhoneSystem)
private final func OnTriggerCall(request: ref<questTriggerCallRequest>) -> Void {
  GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(new InterruptCustomTimeSkipEvent());
  wrappedMethod(request);
}
