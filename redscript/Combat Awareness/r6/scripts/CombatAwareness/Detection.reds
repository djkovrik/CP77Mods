module CombatAwareness

@wrapMethod(PlayerPuppet)
protected cb func OnCombatStateChanged(newState: Int32) -> Bool {
  if newState == 1 && !this.m_inCombat { 
    AwarenessSystem.Get(this.GetGame()).EnterCombat(); 
  };

  return wrappedMethod(newState);
}

@wrapMethod(NPCPuppet)
protected cb func OnPlayerDetectionChangedEvent(evt: ref<PlayerDetectionChangedEvent>) -> Bool {
  let previous: Float = this.GetDetectionPercentage();
  let result: Bool = wrappedMethod(evt);
  let detected: Bool = evt.newDetectionValue >= 100.0 && previous < 100.0;

  if (detected || (evt.newDetectionValue > 0.0 && previous <= 0.0)) && Training.CanStudy(this, GetPlayer(this.GetGame())) {
    AwarenessSystem.Get(this.GetGame()).Contact(this);
  };

  return result;
}
