module CombatAwareness

@addMethod(SensorDevice)
private final func CACanDetectPlayer(target: ref<GameObject>) -> Bool {
  let ps = this.GetDevicePS();

  if ps.IsControlledByPlayer() || !ps.GetBehaviourCanDetectIntruders() || ps.IsBroken() { 
    return false; 
  };

  let attitude = this.GetAttitudeTowards(target);
  return Equals(attitude, EAIAttitude.AIA_Hostile) 
    || (NotEquals(attitude, EAIAttitude.AIA_Friendly) 
    && this.SetAsIntrestingTarget(target));
}

@wrapMethod(SensorDevice)
protected cb func OnDetectionRiseEvent(evt: ref<DetectionRiseEvent>) -> Bool {
  if IsDefined(this as SurveillanceCamera) 
    && evt.isVisible && evt.target.IsPlayer() 
    && !this.m_isPLAYERSAFETargetLock
    && !IsDefined(this.m_currentlyFollowedTarget) 
    && !this.GetDevicePS().IsInFollowMode()
    && this.GetDetectionFactor() >= 0.0 && this.CACanDetectPlayer(evt.target) {
      let system = AwarenessSystem.Get(this.GetGame());
      system.Contact(this);

      if system.Ready(0) { 
        ReconSignal.Show(system, this, "Detecting"); 
      };
  };

  return wrappedMethod(evt);
}

@wrapMethod(SecuritySystemControllerPS)
public final const func ReportPotentialSituation(input: ref<SecuritySystemInput>) -> Bool {
  let accepted: Bool = wrappedMethod(input);
  if IsDefined(input.GetWhoBreached() as PlayerPuppet) 
    && IsDefined(input.GetNotifierHandle())
    && (Equals(input.GetNotificationType(), ESecurityNotificationType.COMBAT) 
    || Equals(input.GetNotificationType(), ESecurityNotificationType.DEFAULT)) {
      let system = AwarenessSystem.Get(this.GetGameInstance());
      let source = input.GetNotifierHandle().GetOwnerEntityWeak() as GameObject;
      if IsDefined(source as NPCPuppet) || IsDefined(source as SurveillanceCamera) {
        let id = source.GetEntityID();
        if accepted {
          if system.RecordReport(id) && system.Ready(0) { 
            ReconSignal.Show(system, source, "Sent"); 
          };
        } else {
          if system.Ready(0) && !system.HasReport(id) { 
            ReconSignal.Show(system, source, "Attempt"); 
          };
        };
      };
  };

  return accepted;
}
