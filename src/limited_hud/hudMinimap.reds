/////////////////////////////////////////////////
// Show minimap depending on the module config //
/////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.MinimapModuleConfig

@addField(UI_SystemDef)
public let IsMinimapToggled_LHUD: BlackboardID_Bool;

@addField(MinimapContainerController)
public let m_isMinimapToggled_LHUD: Bool;

@addField(MinimapContainerController)
public let m_minimapToggleBlackboard_LHUD: wref<IBlackboard>;

@addField(MinimapContainerController)
public let m_minimapToggleCallback_LHUD: Uint32;

@addMethod(MinimapContainerController)
public func OnBraindanceStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnScannerStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnMinimapToggleChanged(value: Bool) -> Void {
  this.m_isMinimapToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnMountedStateChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(MinimapContainerController)
public func DetermineCurrentVisibility() -> Void {
  // Check for braindance
  if this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive) {
    this.GetRootWidget().SetVisible(false);
    return;
  };

  // Basic checks
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isScannerEnabled: Bool = this.m_scannerBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isCurrentStateInVehicle: Bool = this.m_vehicleBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && MinimapModuleConfig.ShowInCombat();
  let showForScanner: Bool =  isScannerEnabled && MinimapModuleConfig.ShowWithScanner();
  let showForStealth: Bool =  isCurrentStateStealth && MinimapModuleConfig.ShowInStealth();
  let showForVehicle: Bool =  isCurrentStateInVehicle && MinimapModuleConfig.ShowInVehicle();
  let showForWeapon: Bool = isWeaponUnsheathed && MinimapModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && MinimapModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForScanner || showForStealth || showForVehicle || showForWeapon || showForZoom || this.m_isMinimapToggled_LHUD;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(MinimapContainerController)
public func InitBBs(playerPuppet: ref<GameObject>) -> Void {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    // Define blackboards
    this.m_minimapToggleBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_braindanceBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().Braindance);
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_scannerBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
    this.m_vehicleBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_minimapToggleCallback_LHUD = this.m_minimapToggleBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, this, n"OnMinimapToggleChanged");
    this.m_braindanceTrackingCallback_LHUD = this.m_braindanceBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this, n"OnBraindanceStateChanged");
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_scannerTrackingCallback_LHUD = this.m_scannerBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnScannerStateChanged");
    this.m_vehicleTrackingCallback_LHUD = this.m_vehicleBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");

    this.DetermineCurrentVisibility();
  } else {
    LHUDLog("MinimapContainerController blackboards not defined!");
  }
}

@addMethod(MinimapContainerController)
public func ClearBBs() -> Void {
  this.m_minimapToggleBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, this.m_minimapToggleCallback_LHUD);
  this.m_braindanceBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this.m_braindanceTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_scannerBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback_LHUD);
  this.m_vehicleBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_vehicleTrackingCallback_LHUD);
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}

@replaceMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  this.InitializePlayer(playerGameObject);
  this.InitBBs(playerGameObject);
}

@replaceMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  this.m_rootWidget = this.GetRootWidget();
  let alphaInterpolator: ref<inkAnimTransparency>;
  inkWidgetRef.SetOpacity(this.m_securityAreaVignetteWidget, 0.00);
  this.m_mapDefinition = GetAllBlackboardDefs().UI_Map;
  this.m_mapBlackboard = this.GetBlackboardSystem().Get(this.m_mapDefinition);
  this.m_locationDataCallback = this.m_mapBlackboard.RegisterListenerString(this.m_mapDefinition.currentLocation, this, n"OnLocationUpdated");
  this.OnLocationUpdated(this.m_mapBlackboard.GetString(this.m_mapDefinition.currentLocation));
  this.m_messageCounterController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_messageCounter), r"base\\gameplay\\gui\\widgets\\phone\\message_counter.inkwidget", n"messages") as inkCompoundWidget;
  this.m_rootWidget.SetOpacity(MinimapModuleConfig.Opacity());
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


// Register for minimap toggle actions
@replaceMethod(HUDManager)
protected final func RegisterToInput() -> Void {
  this.GetPlayer().RegisterInputListener(this, n"QH_MoveLeft");
  this.GetPlayer().RegisterInputListener(this, n"QH_MoveRight");
  this.GetPlayer().RegisterInputListener(this, n"Ping");
  this.GetPlayer().RegisterInputListener(this, n"OpenQuickHackPanel");
  this.GetPlayer().RegisterInputListener(this, n"DescriptionChange");
  this.GetPlayer().RegisterInputListener(this, n"ToggleMinimap");
  this.m_stickInputListener = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_QuickSlotsData).RegisterListenerVector4(GetAllBlackboardDefs().UI_QuickSlotsData.leftStick, this, n"OnStickInputChanged");
}

// Fire minimap toggle events here
@replaceMethod(HUDManager)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let isReleased: Bool;
  let isToggled: Bool;
  let actionName: CName;
  if this.IsHackingMinigameActive() {
    return false;
  };
  isReleased = Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED);
  actionName = ListenerAction.GetName(action);

  if Equals(actionName, n"ToggleMinimap") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
    LHUDLog("Toggle hotkey pressed");
    isToggled = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD);
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, !isToggled, true);
  };

  if this.IsQuickHackPanelOpened() && !this.m_isQHackUIInputLocked {
    if isReleased && !GameObject.IsCooldownActive(this.GetPlayer(), n"Qhack_targetChange_lock") {
      switch actionName {
        case n"QH_MoveLeft":
          if isReleased {
            this.JumpToNextTarget(false);
          };
          GameObject.StartCooldown(this.GetPlayer(), n"Qhack_targetChange_lock", 0.00);
          break;
        case n"QH_MoveRight":
          if isReleased {
            this.JumpToNextTarget(true);
          };
          GameObject.StartCooldown(this.GetPlayer(), n"Qhack_targetChange_lock", 0.00);
          break;
        default:
      };
    };
  };
  if ListenerAction.IsButtonJustPressed(action) {
    switch actionName {
      case n"Ping":
        this.StartPulse();
        break;
      case n"DescriptionChange":
        if this.IsQuickHackPanelOpened() {
          this.SetQhuickHackDescriptionVisibility(!this.m_quickHackDescriptionVisible);
        };
        break;
      default:
    };
  };
}
