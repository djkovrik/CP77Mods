import ImprovedMinimapMain.ZoomConfig

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
public let m_mountedTrackBlackboard: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_PSMZoneTrackingBlackboard: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_speedTrackingBlackboard: wref<IBlackboard>;

@addField(inkGameController)
public let m_mountedTrackingCallback: Uint32;

@addField(MinimapContainerController)
public let m_PSMZoneTrackingCallback: Uint32;

@addField(MinimapContainerController)
public let m_speedTrackingCallback: Uint32;

@addField(MinimapContainerController)
public let m_playerInstance: ref<PlayerPuppet>;


// Methods
@addMethod(MinimapContainerController)
public func OnMountedStateChanged(value: Bool) -> Void {
  Log("! OnMountedStateChanged: " + ToString(value));
}

@addMethod(MinimapContainerController)
public func OnPSMZoneChanged(value: Int32) -> Void {
  Log("! OnPSMZoneChanged: " + ToString(value));
}

@addMethod(MinimapContainerController)
protected cb func OnSpeedValueChanged(speed: Int32) -> Bool {
  Log("! OnSpeedValueChanged: " + ToString(speed));
}

@addMethod(MinimapContainerController)
func ApplyInitialMinimapZoomValues() -> Void {
  this.visionRadiusVehicle = Cast(ZoomConfig.MinZoom());
  this.visionRadiusCombat = Cast(ZoomConfig.Combat());
  this.visionRadiusQuestArea = Cast(ZoomConfig.QuestArea());
  this.visionRadiusSecurityArea = Cast(ZoomConfig.SecurityArea());
  this.visionRadiusInterior = Cast(ZoomConfig.Interior());
  this.visionRadiusExterior = Cast(ZoomConfig.Exterior());

  if IsDefined(this.m_playerInstance) {
    this.m_playerInstance.SetupFakedActiveZone();
  } else {
    Log("Player instance not defined!");
  };
}

@addMethod(MinimapContainerController)
func ApplyInVehicleZoomValues() -> Void {
  this.visionRadiusVehicle = Cast(ZoomConfig.MinZoom());
  this.visionRadiusCombat = Cast(ZoomConfig.MinZoom());
  this.visionRadiusQuestArea = Cast(ZoomConfig.MinZoom());
  this.visionRadiusSecurityArea = Cast(ZoomConfig.MinZoom());
  this.visionRadiusInterior = Cast(ZoomConfig.MinZoom());
  this.visionRadiusExterior = Cast(ZoomConfig.MinZoom());

  if IsDefined(this.m_playerInstance) {
    this.m_playerInstance.SetupFakedActiveZone();
  } else {
    Log("Player instance not defined!");
  };
}

@addMethod(MinimapContainerController)
func InitBBs(playerGameObject: ref<GameObject>) -> Void {
  this.m_playerInstance = playerGameObject as PlayerPuppet;
  this.m_mountedTrackBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.m_PSMZoneTrackingBlackboard = this.GetPSMBlackboard(playerGameObject);
  this.m_speedTrackingBlackboard = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  this.m_mountedTrackingCallback = this.m_mountedTrackBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
  this.m_PSMZoneTrackingCallback = this.m_PSMZoneTrackingBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, this, n"OnPSMZoneChanged");
  this.m_speedTrackingCallback = this.m_speedTrackingBlackboard.RegisterListenerInt(GetAllBlackboardDefs().UI_System.CurrentSpeed, this, n"OnSpeedValueChanged");
}

@addMethod(MinimapContainerController)
public func ClearBBs() -> Void {
  this.m_mountedTrackBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_mountedTrackingCallback);
  this.m_PSMZoneTrackingBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Zones, this.m_PSMZoneTrackingCallback);
  this.m_speedTrackingBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().UI_System.CurrentSpeed, this.m_speedTrackingCallback);
}

// Overrides

@replaceMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  this.InitializePlayer(playerGameObject);
  this.InitBBs(playerGameObject);
  this.ApplyInitialMinimapZoomValues();
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