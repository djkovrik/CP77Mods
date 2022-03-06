public class EvaluateVisibilitiesEvent extends Event {}

@wrapMethod(ScriptedPuppet)
protected cb func OnInventoryEmptyEvent(evt: ref<OnInventoryEmptyEvent>) -> Bool {
  wrappedMethod(evt);
  this.QueueEvent(new EvaluateVisibilitiesEvent());
}
