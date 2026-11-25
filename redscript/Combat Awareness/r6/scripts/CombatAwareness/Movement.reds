module CombatAwareness

@wrapMethod(ShootEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AwarenessSystem.Get(scriptInterface.GetGame()).Interrupt();
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(DodgeAirEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  AwarenessSystem.Get(scriptInterface.GetGame()).Interrupt();
  wrappedMethod(stateContext, scriptInterface);
}

@wrapMethod(DodgeEvents)
protected final func Dodge(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, isExhausted: Bool) -> Void {
  wrappedMethod(stateContext, scriptInterface, isExhausted);
  this.CAApplyManeuver(stateContext, scriptInterface, this.IsTouchingGround(scriptInterface));
}

@wrapMethod(DodgeEvents)
protected final func Dash(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, isExhausted: Bool, treatDashAsAirDash: Bool) -> Void {
  wrappedMethod(stateContext, scriptInterface, isExhausted, treatDashAsAirDash);
  this.CAApplyManeuver(stateContext, scriptInterface, !treatDashAsAirDash && this.IsTouchingGround(scriptInterface));
}

@wrapMethod(DodgeEvents)
protected final func LeapToTarget(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, target: wref<GameObject>) -> Void {
  AwarenessSystem.Get(scriptInterface.GetGame()).Interrupt();
  wrappedMethod(stateContext, scriptInterface, target);
}

@addMethod(DodgeEvents)
private final func CAApplyManeuver(ctx: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, ground: Bool) -> Void {
  AwarenessSystem.Get(scriptInterface.GetGame()).Interrupt();
}
