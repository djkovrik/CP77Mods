import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.*

// Native zoom fields, magic happens here =^_^=

// In vehicle
@addField(MinimapContainerController)
native let visionRadiusVehicle: Float;

// In combat
@addField(MinimapContainerController)
native let visionRadiusCombat: Float;

// Quest area
@addField(MinimapContainerController)
native let visionRadiusQuestArea: Float;

// Restricted area
@addField(MinimapContainerController)
native let visionRadiusSecurityArea: Float;

// Interior
@addField(MinimapContainerController)
native let visionRadiusInterior: Float;

// Exterior which does not fit above options
@addField(MinimapContainerController)
native let visionRadiusExterior: Float;


// Fields

@addField(MinimapContainerController)
public let m_speedTrackingBlackboard: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_speedTrackingCallback: Uint32;

@addField(MinimapContainerController)
public let m_playerInstance: ref<PlayerPuppet>;

@addField(MinimapContainerController)
public let m_currentInVehicleZoom: Float;

@addMethod(MinimapContainerController)
protected cb func OnSpeedValueChanged(speed: Int32) -> Bool {
  let newZoom: Float = ZoomCalc.GetForSpeed(speed);
  if IsDefined(this.m_playerInstance) {
    if NotEquals(this.m_currentInVehicleZoom, newZoom) && IsDefined(this.m_playerInstance) {
      IMZLog("New zoom available: " + ToString(newZoom));
      this.visionRadiusVehicle = newZoom;
      this.visionRadiusCombat = newZoom;
      this.visionRadiusQuestArea = newZoom;
      this.visionRadiusSecurityArea = newZoom;
      this.visionRadiusInterior = newZoom;
      this.visionRadiusExterior = newZoom;
      let flag = GameInstance.GetBlackboardSystem(this.m_playerInstance.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData).GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
      GameInstance.GetBlackboardSystem(this.m_playerInstance.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData).SetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, !flag, false);
    };
  };
}

@addMethod(MinimapContainerController)
func InitBBs(playerGameObject: ref<GameObject>) -> Void {
  this.m_playerInstance = playerGameObject as PlayerPuppet;
  this.m_speedTrackingBlackboard = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  this.m_speedTrackingCallback = this.m_speedTrackingBlackboard.RegisterListenerInt(GetAllBlackboardDefs().UI_System.CurrentSpeed, this, n"OnSpeedValueChanged");
}

@addMethod(MinimapContainerController)
public func ClearBBs() -> Void {
  this.m_speedTrackingBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().UI_System.CurrentSpeed, this.m_speedTrackingCallback);
}

// Overrides

@replaceMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  let alphaInterpolator: ref<inkAnimTransparency>;
  this.m_rootWidget = this.GetRootWidget();
  inkWidgetRef.SetOpacity(this.m_securityAreaVignetteWidget, 0.00);
  this.m_mapDefinition = GetAllBlackboardDefs().UI_Map;
  this.m_mapBlackboard = this.GetBlackboardSystem().Get(this.m_mapDefinition);
  this.m_locationDataCallback = this.m_mapBlackboard.RegisterListenerString(this.m_mapDefinition.currentLocation, this, n"OnLocationUpdated");
  this.OnLocationUpdated(this.m_mapBlackboard.GetString(this.m_mapDefinition.currentLocation));
  this.m_messageCounterController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_messageCounter), r"base\\gameplay\\gui\\widgets\\phone\\message_counter.inkwidget", n"messages") as inkCompoundWidget;
  
  this.visionRadiusVehicle = 90.0;
  this.visionRadiusCombat = 90.0;
  this.visionRadiusQuestArea = 90.0;
  this.visionRadiusSecurityArea = 90.0;
  this.visionRadiusInterior = 90.0;
  this.visionRadiusExterior = 90.0;
}

@replaceMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  this.InitializePlayer(playerGameObject);
  this.InitBBs(playerGameObject);
}

@replaceMethod(MinimapContainerController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  let psmBlackboard: ref<IBlackboard> = this.GetPSMBlackboard(playerGameObject);
  if IsDefined(psmBlackboard) {
    if this.m_securityBlackBoardID > 0u {
      psmBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().PlayerStateMachine.SecurityZoneData, this.m_securityBlackBoardID);
      this.m_securityBlackBoardID = 0u;
    };
  };
  this.ClearBBs();
}



/////

// @replaceMethod(VehicleComponent)
// protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
//   IMZLog("OnMountingEvent");
//   let PSvehicleDooropenRequest: ref<VehicleDoorOpen>;
//   let vehicleDataPackage: wref<VehicleDataPackage_Record>;
//   let vehicleNPCData: ref<AnimFeature_VehicleNPCData>;
//   let vehicleRecord: ref<Vehicle_Record>;
//   let mountChild: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
//   VehicleComponent.GetVehicleDataPackage(this.GetVehicle().GetGame(), this.GetVehicle(), vehicleDataPackage);
//   if mountChild.IsPlayer() {
//     this.m_mountedPlayer = mountChild as PlayerPuppet;
//     VehicleComponent.QueueEventToAllPassengers(this.m_mountedPlayer.GetGame(), this.GetVehicle().GetEntityID(), PlayerMuntedToMyVehicle.Create(this.m_mountedPlayer));
//     PlayerPuppet.ReevaluateAllBreathingEffects(mountChild as PlayerPuppet);
//     if !this.GetVehicle().IsCrowdVehicle() {
//       this.GetVehicle().GetDeviceLink().TriggerSecuritySystemNotification(this.GetVehicle().GetWorldPosition(), mountChild, ESecurityNotificationType.ALARM);
//     };
//     this.ToggleScanningComponent(false);
//     if this.GetVehicle().GetHudManager().IsRegistered(this.GetVehicle().GetEntityID()) {
//       this.RegisterToHUDManager(false);
//     };
//     this.RegisterInputListener();
//     FastTravelSystem.AddFastTravelLock(n"InVehicle", this.GetVehicle().GetGame());
//     this.m_mounted = true;
//     this.m_ignoreAutoDoorClose = true;
//     this.SetupListeners();
//     this.DisableTargetingComponents();
//     if EntityID.IsDefined(evt.request.mountData.mountEventOptions.entityID) {
//       this.m_enterTime = vehicleDataPackage.Stealing() + vehicleDataPackage.SlideDuration();
//     } else {
//       this.m_enterTime = vehicleDataPackage.Entering() + vehicleDataPackage.SlideDuration();
//     };
//     this.DrivingStimuli(true);
//     if Equals(evt.request.lowLevelMountingInfo.slotId.id, VehicleComponent.GetDriverSlotName()) {
//       if IsDefined(this.GetVehicle() as TankObject) {
//         this.TogglePlayerHitShapesForPanzer(this.m_mountedPlayer, false);
//         this.ToggleTargetingSystemForPanzer(this.m_mountedPlayer, true);
//       };
//       this.SetSteeringLimitAnimFeature(1);
//     };
//     if evt.request.mountData.isInstant {
//       this.DetermineShouldCrystalDomeBeOn(0.00);
//     } else {
//       this.DetermineShouldCrystalDomeBeOn(0.75);
//     };
//   };
//   if !mountChild.IsPlayer() {
//     if evt.request.mountData.isInstant {
//       mountChild.QueueEvent(CreateDisableRagdollEvent());
//     };
//     vehicleNPCData = new AnimFeature_VehicleNPCData();
//     VehicleComponent.GetVehicleNPCData(this.GetVehicle().GetGame(), mountChild, vehicleNPCData);
//     AnimationControllerComponent.ApplyFeatureToReplicate(mountChild, n"VehicleNPCData", vehicleNPCData);
//     AnimationControllerComponent.PushEventToReplicate(mountChild, n"VehicleNPCData");
//     if mountChild.IsPuppet() && !this.GetVehicle().IsPlayerVehicle() && (IsHostileTowardsPlayer(mountChild) || (mountChild as ScriptedPuppet).IsAggressive()) {
//       this.EnableTargetingComponents();
//     };
//   };
//   if !evt.request.mountData.isInstant {
//     PSvehicleDooropenRequest = new VehicleDoorOpen();
//     PSvehicleDooropenRequest.slotID = this.GetVehicle().GetBoneNameFromSlot(evt.request.lowLevelMountingInfo.slotId.id);
//     if EntityID.IsDefined(evt.request.mountData.mountEventOptions.entityID) {
//       PSvehicleDooropenRequest.autoCloseTime = vehicleDataPackage.Stealing_open();
//     } else {
//       PSvehicleDooropenRequest.autoCloseTime = vehicleDataPackage.Normal_open();
//     };
//     if !this.GetPS().GetIsDestroyed() {
//       PSvehicleDooropenRequest.shouldAutoClose = true;
//     };
//     GameInstance.GetPersistencySystem(this.GetVehicle().GetGame()).QueuePSEvent(this.GetPS().GetID(), this.GetPS().GetClassName(), PSvehicleDooropenRequest);
//   };
// }

// @replaceMethod(VehicleComponent)
// protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
//   IMZLog("OnUnmountingEvent");
//   let activePassengers: Int32;
//   let engineOn: Bool;
//   let turnedOn: Bool;
//   let mountChild: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
//   VehicleComponent.SetAnimsetOverrideForPassenger(mountChild, evt.request.lowLevelMountingInfo.parentId, evt.request.lowLevelMountingInfo.slotId.id, 0.00);
//   if IsDefined(mountChild) && mountChild.IsPlayer() {
//       PlayerPuppet.ReevaluateAllBreathingEffects(mountChild as PlayerPuppet);
//       this.ToggleScanningComponent(true);
//       if this.GetVehicle().ShouldRegisterToHUD() {
//         this.RegisterToHUDManager(true);
//       };
//       this.UnregisterInputListener();
//       FastTravelSystem.RemoveFastTravelLock(n"InVehicle", this.GetVehicle().GetGame());
//       this.m_mounted = false;
//       this.UnregisterListeners();
//       this.ToggleSiren(false, false);
//       if this.m_broadcasting {
//         this.DrivingStimuli(false);
//       };
//       if Equals(evt.request.lowLevelMountingInfo.slotId.id, n"seat_front_left") {
//         turnedOn = this.GetVehicle().IsTurnedOn();
//         engineOn = this.GetVehicle().IsEngineTurnedOn();
//         if turnedOn {
//           turnedOn = !turnedOn;
//         };
//         if engineOn {
//           engineOn = !engineOn;
//         };
//         this.ToggleVehicleSystems(false, turnedOn, engineOn);
//         this.GetVehicleControllerPS().SetState(vehicleEState.Default);
//         this.SetSteeringLimitAnimFeature(0);
//         this.m_ignoreAutoDoorClose = false;
//       };
//       this.DoPanzerCleanup();
//       this.m_mountedPlayer = null;
//       this.CleanUpRace();
//     };
//     if IsDefined(mountChild) && VehicleComponent.GetNumberOfActivePassengers(mountChild.GetGame(), this.GetVehicle().GetEntityID(), activePassengers) {
//       if activePassengers <= 0 {
//         this.DisableTargetingComponents();
//       };
//     };
//   }

// @replaceMethod(VehicleComponent)
// protected cb func OnVehicleStartedMountingEvent(evt: ref<VehicleStartedMountingEvent>) -> Bool {
//   IMZLog("OnVehicleStartedMountingEvent");
//   if !evt.isMounting {
//     this.SendVehicleStartedUnmountingEventToPS(evt.isMounting, evt.slotID, evt.character);
//     if Equals(evt.slotID, n"seat_front_left") {
//       this.ToggleVehicleSystems(false, true, true);
//       this.GetVehicleControllerPS().SetState(vehicleEState.Default);
//     };
//   } else {
//     this.GetVehicle().SendDelayedFinishedMountingEventToPS(evt.isMounting, evt.slotID, evt.character, evt.instant ? 0.00 : this.m_enterTime);
//   };
// }

// @replaceMethod(VehicleComponent)
// protected cb func OnVehicleStartedUnmountingEvent(evt: ref<VehicleStartedUnmountingEvent>) -> Bool {
//   IMZLog("OnVehicleStartedUnmountingEvent");
// }
