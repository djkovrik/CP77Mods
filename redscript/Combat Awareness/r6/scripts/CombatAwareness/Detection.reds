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

@wrapMethod(SensorDevice)
protected cb func OnOnDetectedEvent(evt: ref<OnDetectedEvent>) -> Bool {
  if IsDefined(this as SurveillanceCamera) && evt.isVisible && evt.target.IsPlayer() && !this.m_playerDetected
    && this.CACanDetectPlayer(evt.target) {
    let system = AwarenessSystem.Get(this.GetGame());
    system.Contact(this);
    if system.Ready(0) && !this.m_isPLAYERSAFETargetLock {
      ReconSignal.Show(system, this, "Detecting");
    };
  };
  return wrappedMethod(evt);
}
