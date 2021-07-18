// Fields

@addField(PlayerPuppet)
public let m_gameZoneReal: gamePSMZones;

@addField(PlayerPuppet)
public let m_gameZoneFaked: gamePSMZones;

@addField(PlayerPuppet)
public let m_isActiveZoneFaked: Bool;

// Methods

// To force minimap rendering with new zoom values we have to trigger one 
// of the callbacks which forces minimap refresh: public zone change, combat 
// mode change or mounted state change. 
@addMethod(PlayerPuppet)
public func IsActiveZoneFaked() -> Bool {
  return this.m_isActiveZoneFaked;
}

@addMethod(PlayerPuppet)
public func SetActiveZoneFaked(faked: Bool) -> Void {
  this.m_isActiveZoneFaked = faked;
}

@addMethod(PlayerPuppet)
public func SaveLastEnteredActiveZone(zone: gamePSMZones) -> Void {
  this.m_gameZoneReal = zone;
  if Equals(zone, gamePSMZones.Restricted) {
    this.m_gameZoneFaked = gamePSMZones.Public;
  } else {
    this.m_gameZoneFaked = gamePSMZones.Restricted;
  }
}

@addMethod(PlayerPuppet)
public func SetupFakedActiveZone() -> Void {
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(this.m_gameZoneFaked), false);
  this.SetActiveZoneFaked(true);
}

@addMethod(PlayerPuppet)
public func RestoreActiveZone() -> Void {
  this.SetActiveZoneFaked(false);
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(this.m_gameZoneReal), true);
}


// Overrides

@replaceMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  // Restore real active zone if faked
  if this.IsActiveZoneFaked() {
    this.RestoreActiveZone();
  };

  if GameInstance.GetRuntimeInfo(this.GetGame()).IsMultiplayer() || GameInstance.GetPlayerSystem(this.GetGame()).IsCPOControlSchemeForced() {
    this.OnActionMultiplayer(action, consumer);
  };
  if Equals(ListenerAction.GetName(action), n"IconicCyberware") && Equals(ListenerAction.GetType(action), this.DeductGameInputActionType()) && !this.CanCycleLootData() {
    this.ActivateIconicCyberware();
  } else {
    if !GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_PlayerStats).GetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer) && Equals(ListenerAction.GetName(action), n"CallVehicle") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
      this.ProcessCallVehicleAction(ListenerAction.GetType(action));
    };
  };
}

@replaceMethod(PlayerPuppet)
private final func OnEnterPublicZone() -> Void {
  let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
  psmEvent.id = n"InPublicZone";
  psmEvent.value = true;
  psmEvent.aspect = gamestateMachineParameterAspect.Permanent;
  this.QueueEvent(psmEvent);
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Public));
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterPublic");
  // Save entered zone as real
  this.SaveLastEnteredActiveZone(gamePSMZones.Public);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterSafeZone() -> Void {
  let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
  psmEvent.id = n"ForceEmptyHandsByZone";
  psmEvent.value = true;
  psmEvent.aspect = gamestateMachineParameterAspect.Permanent;
  this.QueueEvent(psmEvent);
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Safe));
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterSafe");
  // Save entered zone as real
  this.SaveLastEnteredActiveZone(gamePSMZones.Safe);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterRestrictedZone() -> Void {
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Restricted));
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterRestricted");
  // Save entered zone as real
  this.SaveLastEnteredActiveZone(gamePSMZones.Restricted);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterDangerousZone() -> Void {
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterDangerous");
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Dangerous));
  // Save entered zone as real
  this.SaveLastEnteredActiveZone(gamePSMZones.Dangerous);
}
