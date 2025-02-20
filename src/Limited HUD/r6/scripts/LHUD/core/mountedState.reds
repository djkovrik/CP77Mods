module LimitedHudMounted
import LimitedHudListeners.DelayedCoolExitCallback

@addField(UI_SystemDef)
let IsMounted_LHUD: BlackboardID_Bool;

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

@wrapMethod(CoolExitingEvents)
protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  let gi: GameInstance = scriptInterface.owner.GetGame();
  GameInstance.GetDelaySystem(gi).DelayCallback(DelayedCoolExitCallback.Create(gi), 1.0, false);
}