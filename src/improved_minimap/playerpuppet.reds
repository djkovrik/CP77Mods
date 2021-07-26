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

@wrapMethod(PlayerPuppet)
private final func OnEnterPublicZone() -> Void {
  wrappedMethod();
  this.SaveActualZone_IMZ(gamePSMZones.Public);
}

@wrapMethod(PlayerPuppet)
private final func OnEnterSafeZone() -> Void {
  wrappedMethod();
  this.SaveActualZone_IMZ(gamePSMZones.Safe);
}

@wrapMethod(PlayerPuppet)
private final func OnEnterRestrictedZone() -> Void {
  wrappedMethod();
  this.SaveActualZone_IMZ(gamePSMZones.Restricted);
}

@wrapMethod(PlayerPuppet)
private final func OnEnterDangerousZone() -> Void {
  wrappedMethod();
  this.SaveActualZone_IMZ(gamePSMZones.Dangerous);
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  wrappedMethod(action, consumer);
  if this.IsPlayerZoneFaked_IMZ() {
    this.RestoreRealZone_IMZ();
  };
}
