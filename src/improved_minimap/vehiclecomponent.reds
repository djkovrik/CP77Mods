@replaceMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  let activePassengers: Int32;
  let engineOn: Bool;
  let turnedOn: Bool;
  let mountChild: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  let playerPuppet: ref<PlayerPuppet>;
  VehicleComponent.SetAnimsetOverrideForPassenger(mountChild, evt.request.lowLevelMountingInfo.parentId, evt.request.lowLevelMountingInfo.slotId.id, 0.00);
  if IsDefined(mountChild) && mountChild.IsPlayer() {
    PlayerPuppet.ReevaluateAllBreathingEffects(mountChild as PlayerPuppet);
    this.ToggleScanningComponent(true);
    if this.GetVehicle().ShouldRegisterToHUD() {
      this.RegisterToHUDManager(true);
    };
    this.UnregisterInputListener();
    FastTravelSystem.RemoveFastTravelLock(n"InVehicle", this.GetVehicle().GetGame());
    this.m_mounted = false;
    this.UnregisterListeners();
    this.ToggleSiren(false, false);
    if this.m_broadcasting {
      this.DrivingStimuli(false);
    };
    if Equals(evt.request.lowLevelMountingInfo.slotId.id, n"seat_front_left") {
      turnedOn = this.GetVehicle().IsTurnedOn();
      engineOn = this.GetVehicle().IsEngineTurnedOn();
      if turnedOn {
        turnedOn = !turnedOn;
      };
      if engineOn {
        engineOn = !engineOn;
      };
      this.ToggleVehicleSystems(false, turnedOn, engineOn);
      this.GetVehicleControllerPS().SetState(vehicleEState.Default);
      this.SetSteeringLimitAnimFeature(0);
      this.m_ignoreAutoDoorClose = false;
    };
    this.DoPanzerCleanup();
    this.m_mountedPlayer = null;
    this.CleanUpRace();
    // DIRTY HACK #4: trigger minimap refreshing on unmounting with faked zone
    playerPuppet = mountChild as PlayerPuppet;
    playerPuppet.SetFakedZone_IMZ();
  };
  if IsDefined(mountChild) && VehicleComponent.GetNumberOfActivePassengers(mountChild.GetGame(), this.GetVehicle().GetEntityID(), activePassengers) {
    if activePassengers <= 0 {
      this.DisableTargetingComponents();
    };
  };
}
