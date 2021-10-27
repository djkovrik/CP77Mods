module LimitedHudListeners

import LimitedHudCommon.*

// Input actions listener class
public class LHUDInputListener {
  private let playerInstance: wref<PlayerPuppet>;  // Player instance weak reference

  // Store player instance
  public func SetPlayerInstance(player: ref<PlayerPuppet>) -> Void {
    this.playerInstance = player;
  }

  // Listen for ToggleGlobal and ToggleMinimap actions and send LHUD events
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    if Equals(actionName, n"ToggleGlobal") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      this.playerInstance.QueueEvent(LHUDEventType.GlobalHotkey, true);
    };

    if Equals(actionName, n"ToggleMinimap") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      this.playerInstance.QueueEvent(LHUDEventType.MinimapHotkey, true);
    };
  }
}

// Blackboards listener class
public class LHUDBlackboardsListener {
  private let playerInstance: wref<PlayerPuppet>;       // Player instance weak reference
  private let bbDefs: ref<AllBlackboardDefinitions>;    // All blackboard definitions reference
  private let braindanceBlackboard: ref<IBlackboard>;   // Braindance blackboard reference
  private let scannerBlackboard: ref<IBlackboard>;      // Scanner blackboard reference
  private let stateMachineBlackboard: ref<IBlackboard>; // Player state machine blackboard reference
  private let vehicleBlackboard: ref<IBlackboard>;      // Vehicle blackboard reference
  private let weaponBlackboard: ref<IBlackboard>;       // Active weapon blackboard reference

  private let braindanceCallback: ref<CallbackHandle>;  // Ref for registered braindance callback
  private let scannerCallback: ref<CallbackHandle>;     // Ref for registered scanner callback
  private let psmCallback: ref<CallbackHandle>;         // Ref for registered player state callback
  private let vehicleCallback: ref<CallbackHandle>;     // Ref for registered vehicle mount callback
  private let weaponCallback: ref<CallbackHandle>;      // Ref for registered weapon state callback
  private let zoomCallback: ref<CallbackHandle>;        // Ref for registered zoom value callback

  // Initialise blackboards
  public func InitializeData(player: ref<PlayerPuppet>) -> Void {
    this.playerInstance = player;
    this.bbDefs = GetAllBlackboardDefs();
    this.braindanceBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.Braindance);
    this.scannerBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_Scanner);
    this.stateMachineBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).GetLocalInstanced(player.GetEntityID(), this.bbDefs.PlayerStateMachine);
    this.vehicleBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_ActiveVehicleData);
    this.weaponBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_EquipmentData);
  }

  // Register listeners
  public func RegisterListeners() -> Void {
    this.braindanceCallback = this.braindanceBlackboard.RegisterListenerBool(this.bbDefs.Braindance.IsActive, this, n"OnBraindanceToggle");
    this.scannerCallback = this.scannerBlackboard.RegisterListenerBool(this.bbDefs.UI_Scanner.UIVisible, this, n"OnScannerToggle");
    this.psmCallback = this.stateMachineBlackboard.RegisterListenerInt(this.bbDefs.PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.vehicleCallback = this.vehicleBlackboard.RegisterListenerBool(this.bbDefs.UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.weaponCallback = this.weaponBlackboard.RegisterListenerVariant(this.bbDefs.UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.zoomCallback = this.stateMachineBlackboard.RegisterListenerFloat(this.bbDefs.PlayerStateMachine.ZoomLevel, this, n"OnZoomChanged");
  }

  // Unregister listeners
  public func UnregisterListeners() -> Void {
    this.braindanceBlackboard.UnregisterListenerBool(this.bbDefs.Braindance.IsActive, this.braindanceCallback);
    this.scannerBlackboard.UnregisterListenerBool(this.bbDefs.UI_Scanner.UIVisible, this.scannerCallback);
    this.stateMachineBlackboard.UnregisterListenerInt(this.bbDefs.PlayerStateMachine.Combat, this.psmCallback);
    this.vehicleBlackboard.UnregisterListenerBool(this.bbDefs.UI_ActiveVehicleData.IsPlayerMounted, this.vehicleCallback);
    this.weaponBlackboard.UnregisterListenerVariant(this.bbDefs.UI_EquipmentData.EquipmentData, this.weaponCallback);
    this.stateMachineBlackboard.UnregisterListenerFloat(this.bbDefs.PlayerStateMachine.ZoomLevel, this.zoomCallback);
  }

  // Trigger events which required to get some initial state
  public func LaunchInitialStateEvents() -> Void {
    this.OnCombatStateChanged(this.stateMachineBlackboard.GetInt(this.bbDefs.PlayerStateMachine.Combat));
  }

  // Braindance bb callback
  protected cb func OnBraindanceToggle(value: Bool) -> Bool {
    this.playerInstance.QueueEvent(LHUDEventType.Braindance, value);
  }

  // Scanner bb callback
  protected cb func OnScannerToggle(value: Bool) -> Bool {
    this.playerInstance.QueueEvent(LHUDEventType.Scanner, value);
  }
  
  // Player state bb callback
  protected cb func OnCombatStateChanged(newState: Int32) -> Bool {
    switch newState {
      case EnumInt(gamePSMCombat.Default):
        this.playerInstance.QueueEvent(LHUDEventType.OutOfCombat, true);
        break;
      case EnumInt(gamePSMCombat.InCombat):
        this.playerInstance.QueueEvent(LHUDEventType.Combat, true);
        break;
      case EnumInt(gamePSMCombat.OutOfCombat):
        this.playerInstance.QueueEvent(LHUDEventType.OutOfCombat, true);
        break;
      case EnumInt(gamePSMCombat.Stealth):
        this.playerInstance.QueueEvent(LHUDEventType.Stealth, true);
        break;
      default:
        // do nothing
    };
  }

  // Mounted state bb callback
  protected cb func OnMountedStateChanged(value: Bool) -> Bool {
    this.playerInstance.QueueEvent(LHUDEventType.InVehicle, value);
  }

  // Weapon state bb callback
  protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
    this.playerInstance.QueueEvent(LHUDEventType.Weapon, this.playerInstance.HasAnyWeaponEquipped_LHUD());
  }
  
  // Zoom value bb callback
  protected cb func OnZoomChanged(value: Float) -> Bool {
    let playerHasNoWeapon: Bool = !this.playerInstance.HasAnyWeaponEquipped_LHUD();
    let zoomActive: Bool = value > 1.0;
    this.playerInstance.QueueEvent(LHUDEventType.Zoom, playerHasNoWeapon && zoomActive);
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

@addMethod(inkGameController)
protected cb func OnInitializeFinished() -> Void {
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
}
