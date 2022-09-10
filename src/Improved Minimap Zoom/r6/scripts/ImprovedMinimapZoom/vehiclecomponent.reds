import ImprovedMinimapMain.ZoomConfig

@addField(UI_SystemDef)
let IsMounted_IMZ: BlackboardID_Bool;

@wrapMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  wrappedMethod(evt);
  let mounted: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  if IsDefined(mounted) && mounted.IsPlayer() {
    let player: ref<PlayerPuppet> = mounted as PlayerPuppet;
    if IsDefined(player) {
      let config: ref<ZoomConfig> = player.IMZConfig();
      GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, true, true);
      // Dirty hack #3: reset IsPlayerMounted to remove minimap shift
      if config.isDynamicZoomEnabled {
        GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData).SetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, false, false);
      };
    };
  };
}

@wrapMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  wrappedMethod(evt);
  let mounted: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  if IsDefined(mounted) && mounted.IsPlayer() {
    let player: ref<PlayerPuppet> = mounted as PlayerPuppet;
    if IsDefined(player) {
      GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, false, true);
    };
  };
}
