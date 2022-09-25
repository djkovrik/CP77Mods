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
public let imzBlackboard: ref<IBlackboard>;

@addField(MinimapContainerController)
public let imzIsMountedBlackboard: ref<IBlackboard>;

@addField(MinimapContainerController)
public let imzSpeedTrackCallback: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let imzIsMountedCallback: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let imzIsActuallyMountedCallback: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let imzPlayer: wref<PlayerPuppet>;

@addField(MinimapContainerController)
public let imzConfig: ref<ZoomConfig>;

@addField(MinimapContainerController)
public let imzCurrentZoom: Float;

@addField(MinimapContainerController)
public let imzPeekActive: Bool;

// Methods

@addMethod(MinimapContainerController)
protected cb func OnSpeedValueChanged_IMZ(speed: Float) -> Bool {
  if this.imzConfig.isDynamicZoomEnabled {
    let newZoom: Float = ZoomCalc.GetForSpeed(speed, this.imzConfig);
    IMZLog("New zoom available: " + ToString(newZoom));
    if NotEquals(this.imzCurrentZoom, newZoom) && IsDefined(this.imzPlayer) {
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
  if !value && IsDefined(this.imzPlayer) {
    this.SetPreconfiguredZoomValues_IMZ();
  }
}

@addMethod(MinimapContainerController)
func InitBBs_IMZ(playerGameObject: ref<GameObject>) -> Void {
  this.imzPlayer = playerGameObject as PlayerPuppet;
  this.imzConfig = new ZoomConfig();
  this.imzBlackboard = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_System);
  this.imzSpeedTrackCallback = this.imzBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed_IMZ, this, n"OnSpeedValueChanged_IMZ");
  this.imzIsMountedBlackboard = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.imzIsMountedCallback = this.imzIsMountedBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged_IMZ"); 
  this.imzIsActuallyMountedCallback = this.imzBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this, n"OnActualMountedStateChanged_IMZ"); 
}

@addMethod(MinimapContainerController)
public func ClearBBs_IMZ() -> Void {
  this.imzBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().UI_System.CurrentSpeed_IMZ, this.imzSpeedTrackCallback);
  this.imzIsMountedBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.imzIsMountedCallback);
  this.imzBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsMounted_IMZ, this.imzIsActuallyMountedCallback);
}

// Overrides

// Set native zoom values for MinimapContainerController, yay ^_^
@addMethod(MinimapContainerController)
public func SetPreconfiguredZoomValues_IMZ() -> Void {
  let peek: Float;

  if this.imzPeekActive {
    peek = this.imzConfig.peek;
  } else {
    peek = 0.0;
  }

  this.visionRadiusVehicle = this.imzConfig.minZoom;
  this.visionRadiusCombat = this.imzConfig.combat + peek;
  this.visionRadiusQuestArea = this.imzConfig.questArea + peek;
  this.visionRadiusSecurityArea = this.imzConfig.securityArea + peek;
  this.visionRadiusInterior = this.imzConfig.interior + peek;
  this.visionRadiusExterior = this.imzConfig.exterior + peek;

  IMZLog(s"Zooms: \(this.imzConfig.minZoom) \(this.imzConfig.combat + peek) \(this.imzConfig.questArea + peek) \(this.imzConfig.securityArea) \(this.imzConfig.interior) \(this.imzConfig.exterior)");
  this.imzPlayer.ForceMinimapRefreshWithFakeZone();
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
  this.imzPlayer.ForceMinimapRefreshWithFakeZone();
}

// DIRTY HACK #2: 
// Trigger minimap refresh after the game loaded with faked zone
@wrapMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);
  this.InitBBs_IMZ(playerGameObject);
  this.imzPeekActive = false;
  this.SetPreconfiguredZoomValues_IMZ();
  playerGameObject.RegisterInputListener(this, IMZAction());
}

@wrapMethod(MinimapContainerController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);
  this.ClearBBs_IMZ();
}

@addMethod(MinimapContainerController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let actionName: CName = ListenerAction.GetName(action);
  if Equals(actionName, IMZAction()) {
    if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      if this.imzConfig.replaceHoldWithToggle {
        this.imzPeekActive = !this.imzPeekActive;
      } else {
        this.imzPeekActive = true;
      };
    };
    if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
      if !this.imzConfig.replaceHoldWithToggle {
        this.imzPeekActive = false;
      };
    };
    this.SetPreconfiguredZoomValues_IMZ();
  };
}

@addMethod(MinimapContainerController)
protected cb func OnRefreshZoomConfigsEvent(evt: ref<RefreshZoomConfigsEvent>) -> Void {
  this.imzConfig = new ZoomConfig();
}
