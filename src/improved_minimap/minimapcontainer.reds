import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.*

// IF YOU READ THIS - THERE ARE A FEW DIRTY HACKS RIGHT HERE :(
// Minimap widget reloading with new zoom values can be triggered only by a few events like combat mode, 
// active zone or mount state change so I constantly swap player zone flag while driving =\

// Patch 1.3 added minimap internal container offset for vehicle minimap mode so 
// I disabled it with IsPlayerMounted bb value reset inside VehicleComponent OnUnmountingEvent


// -- Native zoom fields, magic happens here

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


// -- Fields

@addField(MinimapContainerController)
public let m_UIBlackboard_IMZ: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_isMountedBlackboard_IMZ: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_speedTrackingCallback_IMZ: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let m_isMountedTrackingCallback_IMZ: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let m_isActuallyMountedTrackingCallback_IMZ: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let m_playerInstance_IMZ: ref<PlayerPuppet>;

@addField(MinimapContainerController)
public let m_currentInVehicleZoom_IMZ: Float;

@addField(MinimapContainerController)
public let m_isPeekActive_IMZ: Bool;

// Methods

@addMethod(MinimapContainerController)
protected cb func OnSpeedValueChanged_IMZ(speed: Float) -> Bool {
  if ZoomConfig.IsDynamicZoomEnabled() {
    let newZoom: Float = ZoomCalc.GetForSpeed(speed);
    IMZLog("New zoom available: " + ToString(newZoom));
    if NotEquals(this.m_currentInVehicleZoom_IMZ, newZoom) && IsDefined(this.m_playerInstance_IMZ) {
      this.HackAllZoomValues_IMZ(newZoom);
    };
  };
}

@addMethod(MinimapContainerController)
protected cb func OnMountedStateChanged_IMZ(value: Bool) -> Bool {
  IMZLog("! OnMountedStateChanged " + ToString(value));
}

@addMethod(MinimapContainerController)
protected cb func OnActualMountedStateChanged_IMZ(value: Bool) -> Bool {
  IMZLog("! OnActualMountedStateChanged " + ToString(value));
  if !value && IsDefined(this.m_playerInstance_IMZ) {
    this.SetPreconfiguredZoomValues_IMZ();
  }
}

@addMethod(MinimapContainerController)
func InitBBs_IMZ(playerGameObject: ref<GameObject>) -> Void {
  this.m_playerInstance_IMZ = playerGameObject as PlayerPuppet;
  this.m_UIBlackboard_IMZ = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  this.m_speedTrackingCallback_IMZ = this.m_UIBlackboard_IMZ.RegisterListenerFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed_IMZ, this, n"OnSpeedValueChanged_IMZ");
  this.m_isMountedBlackboard_IMZ = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.m_isMountedTrackingCallback_IMZ = this.m_isMountedBlackboard_IMZ.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged_IMZ"); 
  this.m_isActuallyMountedTrackingCallback_IMZ = this.m_UIBlackboard_IMZ.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this, n"OnActualMountedStateChanged_IMZ"); 
}

@addMethod(MinimapContainerController)
public func ClearBBs_IMZ() -> Void {
  this.m_UIBlackboard_IMZ.UnregisterListenerFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed_IMZ, this.m_speedTrackingCallback_IMZ);
  this.m_isMountedBlackboard_IMZ.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_isMountedTrackingCallback_IMZ);
  this.m_UIBlackboard_IMZ.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this.m_isActuallyMountedTrackingCallback_IMZ);
}

// Overrides

// Set native zoom values for MinimapContainerController, yay ^_^
@addMethod(MinimapContainerController)
public func SetPreconfiguredZoomValues_IMZ() -> Void {
  let peek: Float;

  if this.m_isPeekActive_IMZ {
    peek = CastedValues.Peek();
  } else {
    peek = 0.0;
  }

  this.visionRadiusVehicle = CastedValues.MinZoom();
  this.visionRadiusCombat = CastedValues.Combat() + peek;
  this.visionRadiusQuestArea = CastedValues.QuestArea() + peek;
  this.visionRadiusSecurityArea = CastedValues.SecurityArea() + peek;
  this.visionRadiusInterior = CastedValues.Interior() + peek;
  this.visionRadiusExterior = CastedValues.Exterior() + peek;
  this.m_playerInstance_IMZ.ForceMinimapRefreshWithFakeZone();
}

// DIRTY HACK #1: 
// Flatten all zoom values to prevent dynamic zoom flickering because of constant IsPlayerMounted swaps
@addMethod(MinimapContainerController)
public func HackAllZoomValues_IMZ(value: Float) -> Void {
  this.visionRadiusVehicle = value;
  this.visionRadiusCombat = value;
  this.visionRadiusQuestArea = value;
  this.visionRadiusSecurityArea = value;
  this.visionRadiusInterior = value;
  this.visionRadiusExterior = value;
  this.m_playerInstance_IMZ.ForceMinimapRefreshWithFakeZone();
}

// DIRTY HACK #2: 
// Trigger minimap refresh after the game loaded with faked zone
@wrapMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);
  this.InitBBs_IMZ(playerGameObject);
  this.m_isPeekActive_IMZ = false;
  this.SetPreconfiguredZoomValues_IMZ();
  playerGameObject.RegisterInputListener(this, n"minimapPeek");
}

@wrapMethod(MinimapContainerController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);
  this.ClearBBs_IMZ();
}

@addMethod(MinimapContainerController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let actionName: CName = ListenerAction.GetName(action);
  if Equals(actionName, n"minimapPeek") {
    if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      if ZoomConfig.ReplaceHoldWithToggle() {
        this.m_isPeekActive_IMZ = !this.m_isPeekActive_IMZ;
      } else {
        this.m_isPeekActive_IMZ = true;
      };
    };
    if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
      if !ZoomConfig.ReplaceHoldWithToggle() {
        this.m_isPeekActive_IMZ = false;
      };
    };
    this.SetPreconfiguredZoomValues_IMZ();
  };
}