@addField(PlayerPuppet)
public let m_realZone: Int32;

@addField(PlayerPuppet)
public let m_fakedZone: Int32;

@addField(PlayerPuppet)
public let m_isPlayerZoneFaked: Bool;

@addField(PlayerPuppet)
public let m_isPlayerMountedFaked: Bool;

@addMethod(PlayerPuppet)
public func SetPlayerZoneFaked(faked: Bool) -> Void {
  this.m_isPlayerZoneFaked = faked;
}

@addMethod(PlayerPuppet)
public func IsPlayerZoneFaked() -> Bool {
  return this.m_isPlayerZoneFaked;
}

@addMethod(PlayerPuppet)
public func SaveActualZone(zone: gamePSMZones) {
  this.m_realZone = EnumInt(zone);
  if this.m_realZone == 3 {
    this.m_fakedZone = 1;
  } else {
    this.m_fakedZone = 3;
  };
}

@addMethod(PlayerPuppet)
public func SetFakedZone() -> Void {
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, this.m_fakedZone, false);
  this.SetPlayerZoneFaked(true);
}

@addMethod(PlayerPuppet)
public func RestoreRealZone() -> Void {
  this.SetPlayerZoneFaked(false);
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, this.m_realZone, false);
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
  this.SaveActualZone(gamePSMZones.Public);
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
  this.SaveActualZone(gamePSMZones.Safe);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterRestrictedZone() -> Void {
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Restricted));
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterRestricted");
  this.SaveActualZone(gamePSMZones.Restricted);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterDangerousZone() -> Void {
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterDangerous");
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Dangerous));
  this.SaveActualZone(gamePSMZones.Dangerous);
}


@replaceMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  // + Restore player zone if faked
  if this.IsPlayerZoneFaked() {
    this.RestoreRealZone();
  };
  // +
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
