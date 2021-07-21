import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.*

// IF YOU READ THIS - THERE ARE A FEW DIRTY HACKS RIGHT HERE :(
// Minimap widget reloading with new zoom values can be triggered only by a few events like combat mode, 
// active zone or mount state change and vehicle minimap refreshed only with IsPlayerMounted change


// Native zoom fields, magic happens here

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
public let m_UIBlackboard: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_isMountedBlackboard: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_speedTrackingCallback: Uint32;

@addField(MinimapContainerController)
public let m_isMountedTrackingCallback: Uint32;

@addField(MinimapContainerController)
public let m_playerInstance: ref<PlayerPuppet>;

@addField(MinimapContainerController)
public let m_currentInVehicleZoom: Float;


// Methods

// DIRTY HACK #1:
// Swap IsPlayerMounted flag to trigger minimap refresh for dynamic zoom
@addMethod(MinimapContainerController)
private func SwapIsMountedFlag() -> Void {
  let flag: Bool = this.m_isMountedBlackboard.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  this.m_isMountedBlackboard.SetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, !flag, false);
}

@addMethod(MinimapContainerController)
protected cb func OnSpeedValueChanged(speed: Float) -> Bool {
  let newZoom: Float = ZoomCalc.GetForSpeed(speed);
  // IMZLog("New zoom available: " + ToString(newZoom));
  if IsDefined(this.m_playerInstance) {
    if NotEquals(this.m_currentInVehicleZoom, newZoom) && IsDefined(this.m_playerInstance) && speed > 0.0 {
      this.HackAllZoomValues(newZoom);
      this.SwapIsMountedFlag();
    };
    // Restore zoom values from config
    if speed == 0.0 {
      this.SetPreconfiguredZoomValues();
    };
  };
}

@addMethod(MinimapContainerController)
protected cb func OnMountedStateChanged(value: Bool) -> Bool {
  IMZLog("! OnMountedStateChanged " + ToString(value));
}

@addMethod(MinimapContainerController)
func InitBBs(playerGameObject: ref<GameObject>) -> Void {
  this.m_playerInstance = playerGameObject as PlayerPuppet;
  this.m_UIBlackboard = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  this.m_speedTrackingCallback = this.m_UIBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed, this, n"OnSpeedValueChanged");
  this.m_isMountedBlackboard = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.m_isMountedTrackingCallback = this.m_isMountedBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged"); 
}

@addMethod(MinimapContainerController)
public func ClearBBs() -> Void {
  this.m_UIBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed, this.m_speedTrackingCallback);
  this.m_isMountedBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_isMountedTrackingCallback);
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
  this.SetPreconfiguredZoomValues();
}

// Set native zoom values for MinimapContainerControllerm, yay ^_^
@addMethod(MinimapContainerController)
public func SetPreconfiguredZoomValues() -> Void {
  this.visionRadiusVehicle = CastedValues.MinZoom();
  this.visionRadiusCombat = CastedValues.Combat();
  this.visionRadiusQuestArea = CastedValues.QuestArea();
  this.visionRadiusSecurityArea = CastedValues.SecurityArea();
  this.visionRadiusInterior = CastedValues.Interior();
  this.visionRadiusExterior = CastedValues.Exterior();
}

// DIRTY HACK #2: 
// Flatten all zoom values to prevent dynamic zoom flickering because of constant IsPlayerMounted swaps
@addMethod(MinimapContainerController)
public func HackAllZoomValues(value: Float) -> Void {
  this.visionRadiusVehicle = value;
  this.visionRadiusCombat = value;
  this.visionRadiusQuestArea = value;
  this.visionRadiusSecurityArea = value;
  this.visionRadiusInterior = value;
  this.visionRadiusExterior = value;
}

// DIRTY HACK #3: trigger minimap refresh after the game loaded with faked zone
@replaceMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  this.InitializePlayer(playerGameObject);
  this.InitBBs(playerGameObject);
  playerGameObject.RegisterInputListener(this);
  this.m_playerInstance.SetFakedZone();
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
