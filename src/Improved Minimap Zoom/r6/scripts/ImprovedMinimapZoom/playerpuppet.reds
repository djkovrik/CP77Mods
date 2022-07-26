import ImprovedMinimapMain.ZoomConfig

public class RestorePlayerZoneEvent extends Event {
  public let realZone: Int32;
}

@addField(PlayerPuppet)
public let imz_config: ref<ZoomConfig>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  this.imz_config = new ZoomConfig();
}

@addMethod(PlayerPuppet)
public func IMZConfig() -> ref<ZoomConfig> {
  return this.imz_config;
}

@addMethod(PlayerPuppet)
public func ForceMinimapRefreshWithFakeZone() -> Void {
  let realZone: Int32 = this.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
  let fakedZone: Int32;
  if realZone == 3 {
    fakedZone = 1;
  } else {
    fakedZone = 3;
  };

  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, fakedZone, false);
  let event: ref<RestorePlayerZoneEvent> = new RestorePlayerZoneEvent();
  event.realZone = realZone;
  GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, event, 0.1);
}

@addMethod(PlayerPuppet)
protected cb func OnRestorePlayerZoneEvent(evt: ref<RestorePlayerZoneEvent>) -> Bool {
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, evt.realZone, false);
}
