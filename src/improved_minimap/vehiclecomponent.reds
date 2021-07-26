@addField(UI_SystemDef)
let IsMounted_IMZ: BlackboardID_Bool;

@wrapMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  wrappedMethod(evt);
  let mounted: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  let player: ref<PlayerPuppet>;
  if mounted.IsPlayer() {
    player = mounted as PlayerPuppet;
    GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, true, true);
  }
}

@wrapMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  wrappedMethod(evt);
  let mounted: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  let player: ref<PlayerPuppet>;
  if mounted.IsPlayer() {
    player = mounted as PlayerPuppet;
    GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, false, true);
  }
}
