@addField(UI_SystemDef)
let IsMounted_IMZ: BlackboardID_Bool;

@replaceMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  let PSvehicleDooropenRequest: ref<VehicleDoorOpen>;
  let vehicleDataPackage: wref<VehicleDataPackage_Record>;
  let vehicleNPCData: ref<AnimFeature_VehicleNPCData>;
  let vehicleRecord: ref<Vehicle_Record>;
  let mountChild: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  VehicleComponent.GetVehicleDataPackage(this.GetVehicle().GetGame(), this.GetVehicle(), vehicleDataPackage);
  if mountChild.IsPlayer() {
    this.m_mountedPlayer = mountChild as PlayerPuppet;
    VehicleComponent.QueueEventToAllPassengers(this.m_mountedPlayer.GetGame(), this.GetVehicle().GetEntityID(), PlayerMuntedToMyVehicle.Create(this.m_mountedPlayer));
    PlayerPuppet.ReevaluateAllBreathingEffects(mountChild as PlayerPuppet);
    if !this.GetVehicle().IsCrowdVehicle() {
      this.GetVehicle().GetDeviceLink().TriggerSecuritySystemNotification(this.GetVehicle().GetWorldPosition(), mountChild, ESecurityNotificationType.ALARM);
    };
    this.ToggleScanningComponent(false);
    if this.GetVehicle().GetHudManager().IsRegistered(this.GetVehicle().GetEntityID()) {
      this.RegisterToHUDManager(false);
    };
    this.RegisterInputListener();
    FastTravelSystem.AddFastTravelLock(n"InVehicle", this.GetVehicle().GetGame());
    this.m_mounted = true;
    this.m_ignoreAutoDoorClose = true;
    this.SetupListeners();
    this.DisableTargetingComponents();
    if EntityID.IsDefined(evt.request.mountData.mountEventOptions.entityID) {
      this.m_enterTime = vehicleDataPackage.Stealing() + vehicleDataPackage.SlideDuration();
    } else {
      this.m_enterTime = vehicleDataPackage.Entering() + vehicleDataPackage.SlideDuration();
    };
    this.DrivingStimuli(true);
    if Equals(evt.request.lowLevelMountingInfo.slotId.id, VehicleComponent.GetDriverSlotName()) {
      if IsDefined(this.GetVehicle() as TankObject) {
        this.TogglePlayerHitShapesForPanzer(this.m_mountedPlayer, false);
        this.ToggleTargetingSystemForPanzer(this.m_mountedPlayer, true);
      };
      this.SetSteeringLimitAnimFeature(1);
    };
    if evt.request.mountData.isInstant {
      this.DetermineShouldCrystalDomeBeOn(0.00);
    } else {
      this.DetermineShouldCrystalDomeBeOn(0.75);
    };
    // + Save actual mounted state
    GameInstance.GetBlackboardSystem(this.m_mountedPlayer.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, true, true);
    // + 
  };
  if !mountChild.IsPlayer() {
    if evt.request.mountData.isInstant {
      mountChild.QueueEvent(CreateDisableRagdollEvent());
    };
    vehicleNPCData = new AnimFeature_VehicleNPCData();
    VehicleComponent.GetVehicleNPCData(this.GetVehicle().GetGame(), mountChild, vehicleNPCData);
    AnimationControllerComponent.ApplyFeatureToReplicate(mountChild, n"VehicleNPCData", vehicleNPCData);
    AnimationControllerComponent.PushEventToReplicate(mountChild, n"VehicleNPCData");
    if mountChild.IsPuppet() && !this.GetVehicle().IsPlayerVehicle() && (IsHostileTowardsPlayer(mountChild) || (mountChild as ScriptedPuppet).IsAggressive()) {
      this.EnableTargetingComponents();
    };
  };
  if !evt.request.mountData.isInstant {
    PSvehicleDooropenRequest = new VehicleDoorOpen();
    PSvehicleDooropenRequest.slotID = this.GetVehicle().GetBoneNameFromSlot(evt.request.lowLevelMountingInfo.slotId.id);
    if EntityID.IsDefined(evt.request.mountData.mountEventOptions.entityID) {
      PSvehicleDooropenRequest.autoCloseTime = vehicleDataPackage.Stealing_open();
    } else {
      PSvehicleDooropenRequest.autoCloseTime = vehicleDataPackage.Normal_open();
    };
    if !this.GetPS().GetIsDestroyed() {
      PSvehicleDooropenRequest.shouldAutoClose = true;
    };
    GameInstance.GetPersistencySystem(this.GetVehicle().GetGame()).QueuePSEvent(this.GetPS().GetID(), this.GetPS().GetClassName(), PSvehicleDooropenRequest);
  };
}

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
    // Save actual mounted state
    GameInstance.GetBlackboardSystem(playerPuppet.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, false, true);
    // +
  };
  if IsDefined(mountChild) && VehicleComponent.GetNumberOfActivePassengers(mountChild.GetGame(), this.GetVehicle().GetEntityID(), activePassengers) {
    if activePassengers <= 0 {
      this.DisableTargetingComponents();
    };
  };
}
