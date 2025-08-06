module LimitedHudMounted
import LimitedHudListeners.DelayedVehicleExitCallback

@addField(UI_SystemDef)
public let IsMounted_LHUD: BlackboardID_Bool;

@wrapMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  wrappedMethod(evt);
  let child: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  if child.IsPlayer() {
    let player: ref<PlayerPuppet> = child as PlayerPuppet;
    GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_LHUD, true, true);
  }
}

@wrapMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  wrappedMethod(evt);

  let child: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  if child.IsPlayer() {
    let player: ref<PlayerPuppet> = child as PlayerPuppet;
    GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_LHUD, false, true);
  }
}

@addField(ExitingEvents)
private let exitingDelayId: DelayID;

@wrapMethod(ExitingEvents)
protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  let gi: GameInstance = scriptInterface.owner.GetGame();
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(gi);
  delaySystem.CancelCallback(this.exitingDelayId);
  this.exitingDelayId = delaySystem.DelayCallback(DelayedVehicleExitCallback.Create(gi), 1.2, false);
}
