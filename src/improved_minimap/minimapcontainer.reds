import ImprovedMinimapMain.ZoomConfig
import ImprovedMinimapUtil.*
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
public let m_isMountedBlackboard_IMZ: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_isMountedTrackingCallback_IMZ: ref<CallbackHandle>;

@addField(MinimapContainerController)
public let m_playerInstance_IMZ: ref<PlayerPuppet>;

@addField(MinimapContainerController)
public let m_isPeekActive_IMZ: Bool;

// Methods

@addMethod(MinimapContainerController)
protected cb func OnMountedStateChanged_IMZ(value: Bool) -> Bool {
  if !value && IsDefined(this.m_playerInstance_IMZ) {
    this.SetPreconfiguredZoomValues_IMZ();
  }
}

@addMethod(MinimapContainerController)
func InitBBs_IMZ(playerGameObject: ref<GameObject>) -> Void {
  this.m_playerInstance_IMZ = playerGameObject as PlayerPuppet;
  this.m_isMountedBlackboard_IMZ = GameInstance.GetBlackboardSystem(playerGameObject.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.m_isMountedTrackingCallback_IMZ = this.m_isMountedBlackboard_IMZ.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged_IMZ"); 
}

@addMethod(MinimapContainerController)
public func ClearBBs_IMZ() -> Void {
  this.m_isMountedBlackboard_IMZ.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_isMountedTrackingCallback_IMZ);
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

  this.visionRadiusVehicle = CastedValues.Vehicle();
  this.visionRadiusCombat = CastedValues.Combat() + peek;
  this.visionRadiusQuestArea = CastedValues.QuestArea() + peek;
  this.visionRadiusSecurityArea = CastedValues.SecurityArea() + peek;
  this.visionRadiusInterior = CastedValues.Interior() + peek;
  this.visionRadiusExterior = CastedValues.Exterior() + peek;
  this.m_playerInstance_IMZ.ForceMinimapRefreshWithFakeZone();
}

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