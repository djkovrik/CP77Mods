/////////////////////////////////////////////////
// Show minimap depending on the module config //
/////////////////////////////////////////////////

import LimitedHudCommon.*

/////////////////////////////////////////////////////////
// Here you can configure widget visibility conditions //
// (true means visible, false means hidden)            //
/////////////////////////////////////////////////////////
class MinimapModuleConfig {
  public static func ShowInCombat() -> Bool = true
  public static func ShowInStealth() -> Bool = true
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = true
  // Configure minimap widget opacity (range from 0.0 to 1.0)
  public static func Opacity() -> Float = 0.75
}
/////////////////////////////////
// DO NOT EDIT ANYTHING BELOW! //
/////////////////////////////////


@addMethod(MinimapContainerController)
public func OnCombatStateChanged(newState: Int32) -> Void {
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
  // Basic checks
  let isCurrentStateCombat: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.InCombat);
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isCurrentStateInVehicle: Bool = this.m_vehicleBlackboard_LHUD.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Bind to config
  let showForCombat: Bool = isCurrentStateCombat && MinimapModuleConfig.ShowInCombat();
  let showForStealth: Bool =  isCurrentStateStealth && MinimapModuleConfig.ShowInStealth();
  let showForVehicle: Bool =  isCurrentStateInVehicle && MinimapModuleConfig.ShowInVehicle();
  let showForWeapon: Bool = isWeaponUnsheathed && MinimapModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && MinimapModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForStealth || showForVehicle || showForWeapon || showForZoom;
  this.GetRootWidget().SetVisible(isVisible);
}

@addMethod(MinimapContainerController)
public func InitBBs(playerPuppet: ref<GameObject>) -> Void {
  this.m_playerPuppet_LHUD = playerPuppet as PlayerPuppet;

  // Define blackboards
  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_vehicleBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);

    // Define callbacks
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
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
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
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
