module LimitedHudListeners

import LimitedHudCommon.*

// Input actions listener class
public class LHUDInputListener {
  private let m_playerInstance: wref<PlayerPuppet>;  // Player instance weak reference

  // Store player instance
  public func SetPlayerInstance(player: ref<PlayerPuppet>) -> Void {
    this.m_playerInstance = player;
  }

  // Listen for ToggleGlobal and ToggleMinimap actions and send LHUD events
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    if Equals(actionName, n"ToggleGlobal") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      this.m_playerInstance.QueueEvent(LHUDEventType.GlobalHotkey, true);
    };

    if Equals(actionName, n"ToggleMinimap") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      this.m_playerInstance.QueueEvent(LHUDEventType.MinimapHotkey, true);
    };
  }
}

// Blackboards listener class
public class LHUDBlackboardsListener {
  private let m_playerInstance: wref<PlayerPuppet>;       // Player instance weak reference
  private let m_bbDefs: ref<AllBlackboardDefinitions>;    // All blackboard definitions reference
  private let m_braindanceBlackboard: ref<IBlackboard>;   // Braindance blackboard reference
  private let m_scannerBlackboard: ref<IBlackboard>;      // Scanner blackboard reference
  private let m_stateMachineBlackboard: ref<IBlackboard>; // Player state machine blackboard reference
  private let m_vehicleBlackboard: ref<IBlackboard>;      // Vehicle blackboard reference
  private let m_weaponBlackboard: ref<IBlackboard>;       // Active weapon blackboard reference

  private let m_braindanceCallback: ref<CallbackHandle>;  // Ref for registered braindance callback
  private let m_scannerCallback: ref<CallbackHandle>;     // Ref for registered scanner callback
  private let m_psmCallback: ref<CallbackHandle>;         // Ref for registered player state callback
  private let m_vehicleCallback: ref<CallbackHandle>;     // Ref for registered vehicle mount callback
  private let m_weaponCallback: ref<CallbackHandle>;      // Ref for registered weapon state callback
  private let m_zoomCallback: ref<CallbackHandle>;        // Ref for registered zoom value callback

  // Initialise blackboards
  public func InitializeData(player: ref<PlayerPuppet>) -> Void {
    this.m_playerInstance = player;
    this.m_bbDefs = GetAllBlackboardDefs();
    this.m_braindanceBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.m_bbDefs.Braindance);
    this.m_scannerBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.m_bbDefs.UI_Scanner);
    this.m_stateMachineBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).GetLocalInstanced(player.GetEntityID(), this.m_bbDefs.PlayerStateMachine);
    this.m_vehicleBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.m_bbDefs.UI_ActiveVehicleData);
    this.m_weaponBlackboard =  GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.m_bbDefs.UI_EquipmentData);
  }

  // Register listeners
  public func RegisterListeners() -> Void {
    this.m_braindanceCallback = this.m_braindanceBlackboard.RegisterListenerBool(this.m_bbDefs.Braindance.IsActive, this, n"OnBraindanceToggle");
    this.m_scannerCallback = this.m_scannerBlackboard.RegisterListenerBool(this.m_bbDefs.UI_Scanner.UIVisible, this, n"OnScannerToggle");
    this.m_psmCallback = this.m_stateMachineBlackboard.RegisterListenerInt(this.m_bbDefs.PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_vehicleCallback = this.m_vehicleBlackboard.RegisterListenerBool(this.m_bbDefs.UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.m_weaponCallback = this.m_weaponBlackboard.RegisterListenerVariant(this.m_bbDefs.UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomCallback = this.m_stateMachineBlackboard.RegisterListenerFloat(this.m_bbDefs.PlayerStateMachine.ZoomLevel, this, n"OnZoomChanged");
  }

  // Unregister listeners
  public func UnregisterListeners() -> Void {
    this.m_braindanceBlackboard.UnregisterListenerBool(this.m_bbDefs.Braindance.IsActive, this.m_braindanceCallback);
    this.m_scannerBlackboard.UnregisterListenerBool(this.m_bbDefs.UI_Scanner.UIVisible, this.m_scannerCallback);
    this.m_stateMachineBlackboard.UnregisterListenerInt(this.m_bbDefs.PlayerStateMachine.Combat, this.m_psmCallback);
    this.m_vehicleBlackboard.UnregisterListenerBool(this.m_bbDefs.UI_ActiveVehicleData.IsPlayerMounted, this.m_vehicleCallback);
    this.m_weaponBlackboard.UnregisterListenerVariant(this.m_bbDefs.UI_EquipmentData.EquipmentData, this.m_weaponCallback);
    this.m_stateMachineBlackboard.UnregisterListenerFloat(this.m_bbDefs.PlayerStateMachine.ZoomLevel, this.m_zoomCallback);
  }

  // Launch events which required to get some initial state
  public func LaunchInitialStateEvents() -> Void {
    this.OnCombatStateChanged(this.m_stateMachineBlackboard.GetInt(this.m_bbDefs.PlayerStateMachine.Combat));
  }

  // Braindance bb callback
  protected cb func OnBraindanceToggle(value: Bool) -> Bool {
    this.m_playerInstance.QueueEvent(LHUDEventType.Braindance, value);
  }

  // Scanner bb callback
  protected cb func OnScannerToggle(value: Bool) -> Bool {
    this.m_playerInstance.QueueEvent(LHUDEventType.Scanner, value);
  }
  
  // Player state bb callback
  protected cb func OnCombatStateChanged(newState: Int32) -> Bool {
    switch newState {
      case EnumInt(gamePSMCombat.Default):
        this.m_playerInstance.QueueEvent(LHUDEventType.OutOfCombat, true);
        break;
      case EnumInt(gamePSMCombat.InCombat):
        this.m_playerInstance.QueueEvent(LHUDEventType.Combat, true);
        break;
      case EnumInt(gamePSMCombat.OutOfCombat):
        this.m_playerInstance.QueueEvent(LHUDEventType.OutOfCombat, true);
        break;
      case EnumInt(gamePSMCombat.Stealth):
        this.m_playerInstance.QueueEvent(LHUDEventType.Stealth, true);
        break;
      default:
        // do nothing
    };
  }

  // Mounted state bb callback
  protected cb func OnMountedStateChanged(value: Bool) -> Bool {
    this.m_playerInstance.QueueEvent(LHUDEventType.InVehicle, value);
  }

  // Weapon state bb callback
  protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
    this.m_playerInstance.QueueEvent(LHUDEventType.Weapon, this.m_playerInstance.HasAnyWeaponEquipped_LHUD());
  }
  
  // Zoom value bb callback
  protected cb func OnZoomChanged(value: Float) -> Bool {
    let playerHasNoWeapon: Bool = !this.m_playerInstance.HasAnyWeaponEquipped_LHUD();
    let zoomActive: Bool = value > 1.0;
    this.m_playerInstance.QueueEvent(LHUDEventType.Zoom, playerHasNoWeapon && zoomActive);
  }
}

// -- INITIALIZE LHUD LISTENERS

@addField(HUDManager) 
private let m_inputListenerLHUD: ref<LHUDInputListener>;

@addField(HUDManager) 
private let m_blabockardsListenerLHUD: ref<LHUDBlackboardsListener>;

@wrapMethod(HUDManager)
private final func PlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
    wrappedMethod(playerPuppet);
    let player: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
    // Hotkeys listener
    this.m_inputListenerLHUD = new LHUDInputListener();
    this.m_inputListenerLHUD.SetPlayerInstance(player);
    player.RegisterInputListener(this.m_inputListenerLHUD);
    // Blackborards listener
    this.m_blabockardsListenerLHUD = new LHUDBlackboardsListener();
    this.m_blabockardsListenerLHUD.InitializeData(player);
    this.m_blabockardsListenerLHUD.RegisterListeners();
    this.m_blabockardsListenerLHUD.LaunchInitialStateEvents();
}

@wrapMethod(HUDManager)
private final func PlayerDetachedCallback(playerPuppet: ref<GameObject>) -> Void {
  let player: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
  player.UnregisterInputListener(this.m_inputListenerLHUD);
  this.m_inputListenerLHUD = null;
  this.m_blabockardsListenerLHUD.UnregisterListeners();
  this.m_blabockardsListenerLHUD = null;
  wrappedMethod(playerPuppet);
}
