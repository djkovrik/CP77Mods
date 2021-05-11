///////////////////////////////////////////////////////////////////////
// Show player healthbar and statuses depending on the module config //
///////////////////////////////////////////////////////////////////////

import LimitedHudCommon.*

// Default healthbar visibility conditions: HP or memory not full, 
// player has active quickhacks or buffs, combat mode activated

// Here you can enable additional conditions
// (true means visible, false means hidden)
class PlayerHealthbarModuleConfig {
  public static func ShowInStealth() -> Bool = true
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = true
}
// DO NOT EDIT ANYTHING BELOW!


@addMethod(healthbarWidgetGameController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.ComputeHealthBarVisibility();
}

@addMethod(healthbarWidgetGameController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.ComputeHealthBarVisibility();
}

@replaceMethod(healthbarWidgetGameController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  let controlledPuppet: wref<gamePuppetBase>;
  let controlledPuppetRecordID: TweakDBID;
  this.RegisterPSMListeners(playerGameObject);
  if IsDefined(this.m_foldingAnimProxy) {
    this.m_foldingAnimProxy.Stop();
  };
  this.m_foldingAnimProxy = this.PlayLibraryAnimation(n"unfold");
  controlledPuppet = GetPlayer(this.m_gameInstance);
  if controlledPuppet != null {
    controlledPuppetRecordID = controlledPuppet.GetRecordID();
    if controlledPuppetRecordID == t"Character.johnny_replacer" {
      inkWidgetRef.SetVisible(this.m_levelUpRectangle, false);
    } else {
      inkWidgetRef.SetVisible(this.m_levelUpRectangle, true);
    };
  } else {
    inkWidgetRef.SetVisible(this.m_levelUpRectangle, true);
  };

  this.m_playerPuppet_LHUD = playerGameObject as PlayerPuppet;
  if IsDefined(this.m_playerPuppet_LHUD) {
    // Define bbs
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    // Define callbacks
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");
  } else {
    LHUDLog("healthbarWidgetGameController blackboard not defined!");
  };
}

@replaceMethod(healthbarWidgetGameController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  this.UnregisterPSMListeners(playerGameObject);
  if IsDefined(this.m_foldingAnimProxy) {
    this.m_foldingAnimProxy.Stop();
  };
  this.m_foldingAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.m_weaponBlackboard_LHUD.UnregisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this.m_weaponTrackingCallback_LHUD);
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_zoomTrackingCallback_LHUD);
  this.m_playerPuppet_LHUD = null;
}

@replaceMethod(healthbarWidgetGameController)
private final func ComputeHealthBarVisibility() -> Void {
  let isMaxHP: Bool = this.m_currentHealth == this.m_maximumHealth;
  let isUnarmed: Bool = this.IsUnarmed();
  let isMultiplayer: Bool = this.IsPlayingMultiplayer();
  let areQuickhacksUsed: Bool = this.m_usedQuickhacks > 0;
  let animFade: ref<inkAnimDef>;
  let isTemperatureSafe: Bool;

  // Additional conditions
  let isInStealth: Bool = Equals(this.m_combatModePSM, gamePSMCombat.Stealth);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Additional flags
  let showForStealth: Bool =  isInStealth && PlayerHealthbarModuleConfig.ShowInStealth();
  let showForWeapon: Bool = isWeaponUnsheathed && PlayerHealthbarModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && PlayerHealthbarModuleConfig.ShowWithZoom();

  this.m_armorBar.SetVisible(isMultiplayer);
  this.UpdateGodModeVisibility();
  inkWidgetRef.SetVisible(this.m_quickhacksContainer, this.IsCyberdeckEquipped());
  if NotEquals(this.m_currentVisionPSM, gamePSMVision.Default) {
    this.HideRequest();
    return ;
  };
  if !isMaxHP || areQuickhacksUsed || isMultiplayer || Equals(this.m_combatModePSM, gamePSMCombat.InCombat) || this.m_quickhacksMemoryPercent < 100.00 || this.m_buffsVisible || showForStealth || showForWeapon || showForZoom {
    this.ShowRequest();
  } else {
    this.HideRequest();
  };
}