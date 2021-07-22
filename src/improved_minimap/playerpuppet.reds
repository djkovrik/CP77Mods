@addField(PlayerPuppet)
public let m_realZone_IMZ: Int32;

@addField(PlayerPuppet)
public let m_fakedZone_IMZ: Int32;

@addField(PlayerPuppet)
public let m_isPlayerZoneFaked_IMZ: Bool;

@addField(PlayerPuppet)
public let m_isPlayerMountedFaked_IMZ: Bool;

@addMethod(PlayerPuppet)
public func SetPlayerZoneFaked_IMZ(faked: Bool) -> Void {
  this.m_isPlayerZoneFaked_IMZ = faked;
}

@addMethod(PlayerPuppet)
public func IsPlayerZoneFaked_IMZ() -> Bool {
  return this.m_isPlayerZoneFaked_IMZ;
}

@addMethod(PlayerPuppet)
public func SaveActualZone_IMZ(zone: gamePSMZones) {
  this.m_realZone_IMZ = EnumInt(zone);
  if this.m_realZone_IMZ == 3 {
    this.m_fakedZone_IMZ = 1;
  } else {
    this.m_fakedZone_IMZ = 3;
  };
}

@addMethod(PlayerPuppet)
public func SetFakedZone_IMZ() -> Void {
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, this.m_fakedZone_IMZ, false);
  this.SetPlayerZoneFaked_IMZ(true);
}

@addMethod(PlayerPuppet)
public func RestoreRealZone_IMZ() -> Void {
  this.SetPlayerZoneFaked_IMZ(false);
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, this.m_realZone_IMZ, false);
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
  this.SaveActualZone_IMZ(gamePSMZones.Public);
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
  this.SaveActualZone_IMZ(gamePSMZones.Safe);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterRestrictedZone() -> Void {
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Restricted));
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterRestricted");
  this.SaveActualZone_IMZ(gamePSMZones.Restricted);
}

@replaceMethod(PlayerPuppet)
private final func OnEnterDangerousZone() -> Void {
  GameInstance.GetAudioSystem(this.GetGame()).NotifyGameTone(n"EnterDangerous");
  this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine.Zones, EnumInt(gamePSMZones.Dangerous));
  this.SaveActualZone_IMZ(gamePSMZones.Dangerous);
}


@replaceMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  // + Restore player zone if faked
  if this.IsPlayerZoneFaked_IMZ() {
    this.RestoreRealZone_IMZ();
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
