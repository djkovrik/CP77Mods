public class RestorePlayerZoneEvent extends Event {
  public let realZone: Int32;
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
  let fakedEvent: ref<RestorePlayerZoneEvent> = new RestorePlayerZoneEvent();
  fakedEvent.realZone = realZone;
  GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, fakedEvent, 0.1);
}

@addMethod(PlayerPuppet)
protected cb func OnRestorePlayerZoneEvent(evt: ref<RestorePlayerZoneEvent>) -> Bool {
  this.GetPlayerStateMachineBlackboard().SetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, evt.realZone, false);
}
