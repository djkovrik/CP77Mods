module LimitedHudListeners

import LimitedHudCommon.*

// Input actions listener class
public class LHUDInputListener {
  private let playerInstance: wref<PlayerPuppet>;  // Player instance weak reference

  // Store player instance
  public func SetPlayerInstance(player: ref<PlayerPuppet>) -> Void {
    LHUDLog("-- LHUDInputListener initialized");
    this.playerInstance = player;
  }

  // Listen for ToggleGlobal and ToggleMinimap actions and send LHUD events
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    let blackBoard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.playerInstance.GetGame()).Get(GetAllBlackboardDefs().UI_System);
    let isToggled: Bool;
    if Equals(actionName, n"ToggleGlobal") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      isToggled = blackBoard.GetBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD);
      blackBoard.SetBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, !isToggled, true);
    };

    if Equals(actionName, n"ToggleMinimap") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      isToggled = blackBoard.GetBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD);
      blackBoard.SetBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, !isToggled, true);
    };
  }
}

// Add weapon state bool
@addField(UI_EquipmentDataDef)
public let HasWeaponEquipped: BlackboardID_Bool;

// Blackboards listener class
public class LHUDBlackboardsListener {
  private let playerInstance: wref<PlayerPuppet>;         // Player instance weak reference
  private let bbDefs: ref<AllBlackboardDefinitions>;      // All blackboard definitions reference
  private let braindanceBlackboard: ref<IBlackboard>;     // Braindance blackboard reference
  private let scannerBlackboard: ref<IBlackboard>;        // Scanner blackboard reference
  private let stateMachineBlackboard: ref<IBlackboard>;   // Player state machine blackboard reference
  private let vehicleBlackboard: ref<IBlackboard>;        // Vehicle blackboard reference
  private let uiSystemBlackboard: ref<IBlackboard>;       // UI system blackboard reference
  private let weaponBlackboard: ref<IBlackboard>;         // Active weapon blackboard reference

  private let globalHotkeyCallback: ref<CallbackHandle>;  // Ref for registered global hotkey callback
  private let minimapHotkeyCallback: ref<CallbackHandle>; // Ref for registered minimap hotkey callback
  private let braindanceCallback: ref<CallbackHandle>;    // Ref for registered braindance callback
  private let scannerCallback: ref<CallbackHandle>;       // Ref for registered scanner callback
  private let psmCallback: ref<CallbackHandle>;           // Ref for registered player state callback
  private let vehicleCallback: ref<CallbackHandle>;       // Ref for registered vehicle mount callback
  private let weaponCallback: ref<CallbackHandle>;        // Ref for registered weapon state callback
  private let zoomCallback: ref<CallbackHandle>;          // Ref for registered zoom value callback

  private let delaySystem: ref<DelaySystem>;
  private let delayId: DelayID;

  // Initialise blackboards
  public func InitializeData(player: ref<PlayerPuppet>) -> Void {
    LHUDLog("-- LHUDBlackboardsListener::InitializeData");
    this.playerInstance = player;
    this.bbDefs = GetAllBlackboardDefs();
    this.braindanceBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.Braindance);
    this.scannerBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_Scanner);
    this.stateMachineBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).GetLocalInstanced(player.GetEntityID(), this.bbDefs.PlayerStateMachine);
    this.vehicleBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_ActiveVehicleData);
    this.uiSystemBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_System);
    this.weaponBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_EquipmentData);

    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
  }

  // Register listeners
  public func RegisterListeners() -> Void {
    LHUDLog("-- LHUDBlackboardsListener::RegisterListeners");
    this.globalHotkeyCallback = this.uiSystemBlackboard.RegisterListenerBool(this.bbDefs.UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggle");
    this.minimapHotkeyCallback = this.uiSystemBlackboard.RegisterListenerBool(this.bbDefs.UI_System.IsMinimapToggled_LHUD, this, n"OnMinimapToggle");
    this.braindanceCallback = this.braindanceBlackboard.RegisterListenerBool(this.bbDefs.Braindance.IsActive, this, n"OnBraindanceToggle");
    this.scannerCallback = this.scannerBlackboard.RegisterListenerBool(this.bbDefs.UI_Scanner.UIVisible, this, n"OnScannerToggle");
    this.psmCallback = this.stateMachineBlackboard.RegisterListenerInt(this.bbDefs.PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.vehicleCallback = this.vehicleBlackboard.RegisterListenerBool(this.bbDefs.UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.weaponCallback = this.weaponBlackboard.RegisterListenerBool(this.bbDefs.UI_EquipmentData.HasWeaponEquipped, this, n"OnWeaponStateChanged");
    this.zoomCallback = this.stateMachineBlackboard.RegisterListenerFloat(this.bbDefs.PlayerStateMachine.ZoomLevel, this, n"OnZoomChanged");
  }

  // Unregister listeners
  public func UnregisterListeners() -> Void {
    LHUDLog("-- LHUDBlackboardsListener::UnregisterListeners");
    this.uiSystemBlackboard.UnregisterListenerBool(this.bbDefs.UI_System.IsGlobalFlagToggled_LHUD, this.globalHotkeyCallback);
    this.uiSystemBlackboard.UnregisterListenerBool(this.bbDefs.UI_System.IsMinimapToggled_LHUD, this.minimapHotkeyCallback);
    this.braindanceBlackboard.UnregisterListenerBool(this.bbDefs.Braindance.IsActive, this.braindanceCallback);
    this.scannerBlackboard.UnregisterListenerBool(this.bbDefs.UI_Scanner.UIVisible, this.scannerCallback);
    this.stateMachineBlackboard.UnregisterListenerInt(this.bbDefs.PlayerStateMachine.Combat, this.psmCallback);
    this.vehicleBlackboard.UnregisterListenerBool(this.bbDefs.UI_ActiveVehicleData.IsPlayerMounted, this.vehicleCallback);
    this.weaponBlackboard.UnregisterListenerBool(this.bbDefs.UI_EquipmentData.HasWeaponEquipped, this.weaponCallback);
    this.stateMachineBlackboard.UnregisterListenerFloat(this.bbDefs.PlayerStateMachine.ZoomLevel, this.zoomCallback);

    this.delaySystem.CancelCallback(this.delayId);
  }

  // Trigger events which required to get some initial state
  public func LaunchInitialStateEvents() -> Void {
    LHUDLog("-- InitialStateEvent - schedule callback");
    let callback: ref<LHUDLaunchCallback> = new LHUDLaunchCallback();
    callback.bbListener = this;
    this.delaySystem.CancelCallback(this.delayId);
    this.delayId = this.delaySystem.DelayCallback(callback, 0.5);
  }

  // Global hotkey bb callback
  protected cb func OnGlobalToggle(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.GlobalHotkey, value);
  }

  // Minimap hotkey bb callback
  protected cb func OnMinimapToggle(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.MinimapHotkey, value);
  }

  // Braindance bb callback
  protected cb func OnBraindanceToggle(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Braindance, value);
  }

  // Scanner bb callback
  protected cb func OnScannerToggle(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Scanner, value);
  }
  
  // Player state bb callback
  protected cb func OnCombatStateChanged(newState: Int32) -> Bool {
    switch newState {
      case EnumInt(gamePSMCombat.Default):
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, true);
        break;
      case EnumInt(gamePSMCombat.InCombat):
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, true);
        break;
      case EnumInt(gamePSMCombat.OutOfCombat):
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, true);
        break;
      case EnumInt(gamePSMCombat.Stealth):
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, true);
        break;
      default:
        // do nothing
    };
  }

  // Mounted state bb callback
  protected cb func OnMountedStateChanged(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Weapon, false);
    this.playerInstance.QueueLHUDEvent(LHUDEventType.InVehicle, value);
  }

  // Weapon state bb callback
  protected cb func OnWeaponStateChanged(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Weapon, value);
  }
  
  // Zoom value bb callback
  protected cb func OnZoomChanged(value: Float) -> Bool {
    let playerHasNoWeapon: Bool = !this.playerInstance.HasAnyWeaponEquipped_LHUD();
    let zoomActive: Bool = value > 1.0;
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Zoom, playerHasNoWeapon && zoomActive);
  }
}

public class LHUDLaunchCallback extends DelayCallback {
  public let bbListener: wref<LHUDBlackboardsListener>;

  public func Call() -> Void {
    LHUDLog("-- InitialStateEvent - execute callback");
    let listener: ref<LHUDBlackboardsListener> = this.bbListener;
    listener.OnCombatStateChanged(listener.stateMachineBlackboard.GetInt(listener.bbDefs.PlayerStateMachine.Combat));
    listener.OnWeaponStateChanged(listener.playerInstance.HasAnyWeaponEquipped_LHUD());
  }
}

// -- INITIALIZE LHUD LISTENERS

@addField(HUDManager) 
public let inputListenerLHUD: ref<LHUDInputListener>;

@addField(HUDManager) 
public let blabockardsListenerLHUD: ref<LHUDBlackboardsListener>;

@wrapMethod(HUDManager)
private final func PlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
    wrappedMethod(playerPuppet);
    let player: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
    // Hotkeys listener
    this.inputListenerLHUD = new LHUDInputListener();
    this.inputListenerLHUD.SetPlayerInstance(player);
    player.RegisterInputListener(this.inputListenerLHUD);
    // Blackborards listener
    this.blabockardsListenerLHUD = new LHUDBlackboardsListener();
    this.blabockardsListenerLHUD.InitializeData(player);
    this.blabockardsListenerLHUD.RegisterListeners();
}

@wrapMethod(HUDManager)
private final func PlayerDetachedCallback(playerPuppet: ref<GameObject>) -> Void {
  let player: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
  player.UnregisterInputListener(this.inputListenerLHUD);
  this.inputListenerLHUD = null;
  this.blabockardsListenerLHUD.UnregisterListeners();
  this.blabockardsListenerLHUD = null;
  wrappedMethod(playerPuppet);
}

// Launch additional initial events

@addMethod(inkGameController)
protected cb func OnInitializeFinished() -> Void {
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
}

@addField(PlayerPuppet)
private let lhud_initEvent: DelayID;

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  this.lhud_initEvent = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, new LHUDInitLaunchEvent(), 1.0);
}

@addMethod(PlayerPuppet)
protected cb func OnLHUDInitLaunchEvent(evt: ref<LHUDInitLaunchEvent>) -> Bool {
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
}

// -- SEND EVENTS FOR NEW BLACKBOARD VARIABLE

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipmentSystemWeaponManipulationRequest(request: ref<EquipmentSystemWeaponManipulationRequest>) -> Void {
  let targetItem: ItemID = this.GetItemIDfromEquipmentManipulationAction(request.requestType);
  let isTargetRequestUnequip: Bool = this.IsEquipmentManipulationAnUnequipRequest(request.requestType);
  let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
  if !isTargetRequestUnequip {
    GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, true);
  } else {
    if ItemID.IsValid(targetItem) {
      GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, false);
    };
  };

  wrappedMethod(request);
}

@wrapMethod(RadialWheelController)
private final func DisarmPlayer() -> Void {
  let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
  GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, false);
  wrappedMethod();
}
