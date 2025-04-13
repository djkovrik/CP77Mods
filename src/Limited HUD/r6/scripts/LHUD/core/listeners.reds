module LimitedHudListeners

import LimitedHudCommon.*

// Input actions listener class
public class LHUDInputListener {
  private let playerInstance: wref<PlayerPuppet>;  // Player instance weak reference

  // Store player instance
  public func SetPlayerInstance(player: ref<PlayerPuppet>) -> Void {
    LHUDLogStartup("-- LHUDInputListener initialized");
    this.playerInstance = player;
  }

  // Listen for LHUD_Global and LHUD_Minimap actions and send LHUD events
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    let blackBoard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.playerInstance.GetGame()).Get(GetAllBlackboardDefs().UI_System);
    let isToggled: Bool;
    if Equals(actionName, n"LHUD_Global") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
      isToggled = blackBoard.GetBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD);
      blackBoard.SetBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, !isToggled, true);
    };

    if Equals(actionName, n"LHUD_Minimap") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
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
  private let wantedBlackboard: ref<IBlackboard>;         // Wanted status blackboard reference

  private let globalHotkeyCallback: ref<CallbackHandle>;  // Ref for registered global hotkey callback
  private let minimapHotkeyCallback: ref<CallbackHandle>; // Ref for registered minimap hotkey callback
  private let braindanceCallback: ref<CallbackHandle>;    // Ref for registered braindance callback
  private let scannerCallback: ref<CallbackHandle>;       // Ref for registered scanner callback
  private let psmCallback: ref<CallbackHandle>;           // Ref for registered player state callback
  private let vehicleCallback: ref<CallbackHandle>;       // Ref for registered vehicle mount callback
  private let vehicleStateCallback: ref<CallbackHandle>;       // Ref for registered vehicle mount callback
  private let weaponCallback: ref<CallbackHandle>;        // Ref for registered weapon state callback
  private let zoomCallback: ref<CallbackHandle>;          // Ref for registered zoom value callback
  private let stealthCallback: ref<CallbackHandle>;       // Ref for registered locomotion value callback
  private let metroCallback: ref<CallbackHandle>;         // Ref for registered metro ride value callback
  private let wantedCallback: ref<CallbackHandle>;        // Ref for registered wanted value callback
  private let zoneCallback: ref<CallbackHandle>;          // Ref for registered zone value callback

  private let delaySystem: ref<DelaySystem>;
  private let delayId: DelayID;

  // Initialise blackboards
  public func InitializeData(player: ref<PlayerPuppet>) -> Void {
    LHUDLogStartup("-- LHUDBlackboardsListener::InitializeData");
    this.playerInstance = player;
    this.bbDefs = GetAllBlackboardDefs();
    this.braindanceBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.Braindance);
    this.scannerBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_Scanner);
    this.stateMachineBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).GetLocalInstanced(player.GetEntityID(), this.bbDefs.PlayerStateMachine);
    this.vehicleBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_ActiveVehicleData);
    this.uiSystemBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_System);
    this.weaponBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_EquipmentData);
    this.wantedBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(this.bbDefs.UI_WantedBar);

    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
  }

  public func UninitializeData() -> Void {
    this.delaySystem.CancelCallback(this.delayId);
    this.playerInstance = null;
  }

  // Register listeners
  public func RegisterListeners() -> Void {
    LHUDLogStartup("-- LHUDBlackboardsListener::RegisterListeners");
    this.globalHotkeyCallback = this.uiSystemBlackboard.RegisterListenerBool(this.bbDefs.UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggle");
    this.minimapHotkeyCallback = this.uiSystemBlackboard.RegisterListenerBool(this.bbDefs.UI_System.IsMinimapToggled_LHUD, this, n"OnMinimapToggle");
    this.braindanceCallback = this.braindanceBlackboard.RegisterListenerBool(this.bbDefs.Braindance.IsActive, this, n"OnBraindanceToggle");
    this.scannerCallback = this.scannerBlackboard.RegisterListenerBool(this.bbDefs.UI_Scanner.UIVisible, this, n"OnScannerToggle");
    this.psmCallback = this.stateMachineBlackboard.RegisterListenerInt(this.bbDefs.PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.vehicleCallback = this.uiSystemBlackboard.RegisterListenerBool(this.bbDefs.UI_System.IsMounted_LHUD, this, n"OnMountedStateChanged");
    this.vehicleStateCallback = this.stateMachineBlackboard.RegisterListenerInt(this.bbDefs.PlayerStateMachine.Vehicle, this, n"OnPlayerVehicleStateChange", true);
    this.weaponCallback = this.weaponBlackboard.RegisterListenerBool(this.bbDefs.UI_EquipmentData.HasWeaponEquipped, this, n"OnWeaponStateChanged");
    this.zoomCallback = this.stateMachineBlackboard.RegisterListenerFloat(this.bbDefs.PlayerStateMachine.ZoomLevel, this, n"OnZoomChanged");
    this.stealthCallback = this.stateMachineBlackboard.RegisterListenerInt(this.bbDefs.PlayerStateMachine.Locomotion, this, n"OnCrouchChanged");
    this.metroCallback = this.uiSystemBlackboard.RegisterListenerBool(this.bbDefs.UI_System.IsInMetro_LHUD, this, n"OnMetroStateChanged");
    this.wantedCallback = this.wantedBlackboard.RegisterListenerInt(this.bbDefs.UI_WantedBar.CurrentWantedLevel, this, n"OnWantedDataChanged", true);
    this.zoneCallback = this.stateMachineBlackboard.RegisterListenerVariant(this.bbDefs.PlayerStateMachine.SecurityZoneData, this, n"OnPlayerZoneChanged", true);
  }

  // Unregister listeners
  public func UnregisterListeners() -> Void {
    LHUDLogStartup("-- LHUDBlackboardsListener::UnregisterListeners");
    this.uiSystemBlackboard.UnregisterListenerBool(this.bbDefs.UI_System.IsGlobalFlagToggled_LHUD, this.globalHotkeyCallback);
    this.uiSystemBlackboard.UnregisterListenerBool(this.bbDefs.UI_System.IsMinimapToggled_LHUD, this.minimapHotkeyCallback);
    this.braindanceBlackboard.UnregisterListenerBool(this.bbDefs.Braindance.IsActive, this.braindanceCallback);
    this.scannerBlackboard.UnregisterListenerBool(this.bbDefs.UI_Scanner.UIVisible, this.scannerCallback);
    this.stateMachineBlackboard.UnregisterListenerInt(this.bbDefs.PlayerStateMachine.Combat, this.psmCallback);
    this.uiSystemBlackboard.UnregisterListenerBool(this.bbDefs.UI_System.IsMounted_LHUD, this.vehicleCallback);
    this.stateMachineBlackboard.UnregisterListenerInt(this.bbDefs.PlayerStateMachine.Vehicle, this.vehicleStateCallback);
    this.weaponBlackboard.UnregisterListenerBool(this.bbDefs.UI_EquipmentData.HasWeaponEquipped, this.weaponCallback);
    this.stateMachineBlackboard.UnregisterListenerFloat(this.bbDefs.PlayerStateMachine.ZoomLevel, this.zoomCallback);
    this.stateMachineBlackboard.UnregisterListenerInt(this.bbDefs.PlayerStateMachine.Locomotion, this.stealthCallback);
    this.uiSystemBlackboard.UnregisterListenerBool(this.bbDefs.UI_System.IsInMetro_LHUD, this.metroCallback);
    this.wantedBlackboard.UnregisterListenerInt(this.bbDefs.UI_WantedBar.CurrentWantedLevel, this.wantedCallback);
    this.stateMachineBlackboard.UnregisterListenerVariant(this.bbDefs.PlayerStateMachine.SecurityZoneData, this.zoneCallback);

    this.delaySystem.CancelCallback(this.delayId);
  }

  // Trigger events which required to get some initial state
  public func LaunchInitialStateEvents() -> Void {
    LHUDLogStartup("-- InitialStateEvent - schedule callback");
    let callback: ref<LHUDLaunchCallback> = new LHUDLaunchCallback();
    callback.bbListener = this;
    this.delaySystem.CancelCallback(this.delayId);
    this.delayId = this.delaySystem.DelayCallback(callback, 1.0);
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
      case 0:
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, true);
        break;
      case 1:
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, true);
        break;
      case 2:
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.Combat, false);
        this.playerInstance.QueueLHUDEvent(LHUDEventType.OutOfCombat, true);
        break;
      default:
        // do nothing
    };
  }

  // Mounted state bb callback
  protected cb func OnMountedStateChanged(value: Bool) -> Bool {
    let isDriver: Bool = VehicleComponent.IsDriver(this.playerInstance.GetGame(), this.playerInstance);
    let show: Bool = isDriver && value;
    this.playerInstance.QueueLHUDEvent(LHUDEventType.InVehicle, show);
  }

  // Weapon + vehicle  
  protected cb func OnPlayerVehicleStateChange(value: Int32) -> Bool {
    let mountedWithWeapon: Bool = Equals(value, 6);
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Weapon, mountedWithWeapon);
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

  // Crouch value bb callback
  protected cb func OnCrouchChanged(value: Int32) -> Bool {
    let newValue: gamePSMLocomotionStates = IntEnum<gamePSMLocomotionStates>(value);
    let crouched: Bool = Equals(newValue, gamePSMLocomotionStates.Crouch) 
      || Equals(newValue, gamePSMLocomotionStates.CrouchSprint) 
      || Equals(newValue, gamePSMLocomotionStates.CrouchDodge);
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Stealth, crouched);
  }

  // Metro value bb callback
  protected cb func OnMetroStateChanged(value: Bool) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Metro, value);
  }

  // Wanted bb callback
  protected cb func OnWantedDataChanged(value: Int32) -> Bool {
    this.playerInstance.QueueLHUDEvent(LHUDEventType.Wanted, NotEquals(value, 0));
  }

  // player zone bb callback
  protected cb func OnPlayerZoneChanged(value: Variant) -> Bool {
    let securityZoneData: SecurityAreaData = FromVariant<SecurityAreaData>(value);
    let dangerousArea: Bool = Equals(securityZoneData.securityAreaType, ESecurityAreaType.RESTRICTED) || Equals(securityZoneData.securityAreaType, ESecurityAreaType.DANGEROUS);
    this.playerInstance.QueueLHUDEvent(LHUDEventType.DangerousZone, dangerousArea);
  }
}

public class LHUDLaunchCallback extends DelayCallback {
  public let bbListener: wref<LHUDBlackboardsListener>;

  public func Call() -> Void {
    LHUDLogStartup("-- InitialStateEvent - execute callback");
    let listener: ref<LHUDBlackboardsListener> = this.bbListener;
    let globalToggled: Bool = listener.uiSystemBlackboard.GetBool(listener.bbDefs.UI_System.IsGlobalFlagToggled_LHUD);
    let minimapToggled: Bool = listener.uiSystemBlackboard.GetBool(listener.bbDefs.UI_System.IsMinimapToggled_LHUD);
    listener.OnCombatStateChanged(listener.stateMachineBlackboard.GetInt(listener.bbDefs.PlayerStateMachine.Combat));
    listener.OnMountedStateChanged(VehicleComponent.IsMountedToVehicle(listener.playerInstance.GetGame(), listener.playerInstance));
    listener.OnPlayerVehicleStateChange(listener.stateMachineBlackboard.GetInt(listener.bbDefs.PlayerStateMachine.Vehicle));
    listener.OnWeaponStateChanged(listener.playerInstance.HasAnyWeaponEquipped_LHUD());
    listener.OnCrouchChanged(listener.stateMachineBlackboard.GetInt(listener.bbDefs.PlayerStateMachine.Locomotion));
    listener.OnMetroStateChanged(listener.uiSystemBlackboard.GetBool(listener.bbDefs.UI_System.IsInMetro_LHUD));
    listener.OnPlayerZoneChanged(listener.stateMachineBlackboard.GetVariant(listener.bbDefs.PlayerStateMachine.SecurityZoneData));
    listener.OnGlobalToggle(globalToggled);
    listener.OnMinimapToggle(minimapToggled);
  }
}

public class DelayedVehicleExitCallback extends DelayCallback {
    private let gameInstance: GameInstance;

    public func Call() -> Void {
      let player: ref<PlayerPuppet> = GetPlayer(this.gameInstance);
      let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
      let uiSystemDef: ref<UI_SystemDef> = GetAllBlackboardDefs().UI_System;
      let hasAnyWeapon: Bool = false;
      if IsDefined(player) {
        hasAnyWeapon = player.HasAnyWeaponEquipped_LHUD();
        GameInstance.GetBlackboardSystem(this.gameInstance).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, hasAnyWeapon, true);
        GameInstance.GetBlackboardSystem(this.gameInstance).Get(uiSystemDef).SetBool(uiSystemDef.IsMounted_LHUD, false, true);
        GameInstance.GetUISystem(this.gameInstance).QueueEvent(new LHUDOnCoolExitEvent());
      };
    }

    public static func Create(gameInstance: GameInstance) -> ref<DelayedVehicleExitCallback> {
      let instance: ref<DelayedVehicleExitCallback> = new DelayedVehicleExitCallback();
      instance.gameInstance = gameInstance;
      return instance;
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
  this.blabockardsListenerLHUD.UninitializeData();
  this.blabockardsListenerLHUD = null;
  wrappedMethod(playerPuppet);
}

// Launch additional initial events

@addMethod(inkGameController)
protected cb func OnInitializeFinished() -> Void {
  LHUDLogStartup("LaunchInitialStateEvents - inkGameController -> OnInitializeFinished");
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
}

@addField(PlayerPuppet)
private let lhud_initEvent: DelayID;

@addMethod(PlayerPuppet)
public final func InitializeLHUD(delay: Float) -> Void {
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  delaySystem.CancelDelay(this.lhud_initEvent);
  this.lhud_initEvent = delaySystem.DelayEvent(this, new LHUDInitLaunchEvent(), delay);
}

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  this.InitializeLHUD(1.0);
}

@addMethod(PlayerPuppet)
protected cb func OnLHUDInitLaunchEvent(evt: ref<LHUDInitLaunchEvent>) -> Bool {
  LHUDLogStartup("LaunchInitialStateEvents - PlayerPuppet -> OnLHUDInitLaunchEvent");
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
}

@wrapMethod(PauseMenuGameController)
protected cb func OnUninitialize() -> Bool {
  LHUDLogStartup("LaunchInitialStateEvents - PauseMenuGameController -> OnUninitialize");
  let manager: ref<HUDManager> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"HUDManager") as HUDManager;
  manager.blabockardsListenerLHUD.LaunchInitialStateEvents();
  wrappedMethod();
}

// -- SEND EVENTS FOR NEW BLACKBOARD VARIABLE

@addMethod(EquipmentSystemPlayerData)
private func IsUnquipRequest(requestType: EquipmentManipulationAction) -> Bool {
  return
    Equals(requestType, EquipmentManipulationAction.UnequipWeapon) ||
    Equals(requestType, EquipmentManipulationAction.UnequipAll) ||
  false;
}

@addMethod(EquipmentSystemPlayerData)
private func ShouldSkipThisRequest(requestType: EquipmentManipulationAction) -> Bool {
  return
    Equals(requestType, EquipmentManipulationAction.RequestConsumable) ||
    Equals(requestType, EquipmentManipulationAction.RequestGadget) ||
    Equals(requestType, EquipmentManipulationAction.RequestLeftHandCyberware) ||
    Equals(requestType, EquipmentManipulationAction.UnequipConsumable) ||
    Equals(requestType, EquipmentManipulationAction.UnequipGadget) ||
    Equals(requestType, EquipmentManipulationAction.UnequipLeftHandCyberware) ||
  false;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipmentSystemWeaponManipulationRequest(request: ref<EquipmentSystemWeaponManipulationRequest>) -> Void {
  wrappedMethod(request);

  let isUnequipRequest: Bool = this.IsUnquipRequest(request.requestType);
  let shouldSkipRequest: Bool = this.ShouldSkipThisRequest(request.requestType);
  let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
  if isUnequipRequest {
    GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, false);
  } else {
    if !shouldSkipRequest {
      GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, true);
    };
  };
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnGameplayEquipRequest(request: ref<GameplayEquipRequest>) -> Void {
  wrappedMethod(request);

  let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
  if request.forceEquipWeapon {
    GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, true);
  };
}

@wrapMethod(RadialWheelController)
private final func DisarmPlayer() -> Void {
  let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
  GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, false);
  wrappedMethod();
}

// METRO
@wrapMethod(PocketRadio)
public final func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>, gameplayTags: script_ref<array<CName>>) -> Void {
  wrappedMethod(evt, gameplayTags);
  if ArrayContains(Deref(gameplayTags), n"MetroRide") {
    this.RefreshMetroFlag(true);
  };
}


@wrapMethod(PocketRadio)
public final func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>, gameplayTags: script_ref<array<CName>>) -> Void {
  wrappedMethod(evt, gameplayTags);
  if ArrayContains(Deref(gameplayTags), n"MetroRide") {
    this.RefreshMetroFlag(false);
  };
}

@addMethod(PocketRadio)
private final func RefreshMetroFlag(value: Bool) -> Void {
  GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsInMetro_LHUD, value, true);
}

// SCANNER DETAILS PANEL
@wrapMethod(scannerDetailsGameController)
protected cb func OnScannerDetailsShown(animationProxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(animationProxy);
  this.m_player.QueueLHUDEvent(LHUDEventType.ScannerDetails, true);
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScannerDetailsHidden(animationProxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(animationProxy);
  this.m_player.QueueLHUDEvent(LHUDEventType.ScannerDetails, false);
}
