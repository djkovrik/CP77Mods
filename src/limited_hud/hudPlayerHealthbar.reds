///////////////////////////////////////////////////////////////////////
// Show player healthbar and statuses depending on the module config //
///////////////////////////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.PlayerHealthbarModuleConfig

@addMethod(healthbarWidgetGameController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.ComputeHealthBarVisibility();
}

@addMethod(healthbarWidgetGameController)
public func OnWeaponDataChanged(value: Variant) -> Bool {
  this.ComputeHealthBarVisibility();
}

@addMethod(healthbarWidgetGameController)
public func OnZoomStateChanged(value: Float) -> Void {
  this.ComputeHealthBarVisibility();
}

@addMethod(inkHUDGameController)
public func SetModuleVisibility(visible: Bool) -> Void {
  this.m_moduleShown = visible;
}

@replaceMethod(healthbarWidgetGameController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  let controlledPuppet: wref<gamePuppetBase>;
  let controlledPuppetRecordID: TweakDBID;
  // New stuff
  this.m_playerPuppet_LHUD = playerGameObject as PlayerPuppet;
  if IsDefined(this.m_playerPuppet_LHUD) {
    // Define bbs
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.m_weaponBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);
    // Define callbacks
    this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
    this.m_weaponTrackingCallback_LHUD = this.m_weaponBlackboard_LHUD.RegisterListenerVariant(GetAllBlackboardDefs().UI_EquipmentData.EquipmentData, this, n"OnWeaponDataChanged");
    this.m_zoomTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomStateChanged");
  } else {
    LHUDLog("healthbarWidgetGameController blackboard not defined!");
  };

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
}

@replaceMethod(healthbarWidgetGameController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  this.UnregisterPSMListeners(playerGameObject);
  if IsDefined(this.m_foldingAnimProxy) {
    this.m_foldingAnimProxy.Stop();
  };
  this.m_foldingAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
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

  this.m_armorBar.SetVisible(true);
  this.UpdateGodModeVisibility();
  inkWidgetRef.SetVisible(this.m_quickhacksContainer, this.IsCyberdeckEquipped());
  if NotEquals(this.m_currentVisionPSM, gamePSMVision.Default) {
    this.HideRequest();
    return ;
  };

  // Additional conditions
  let isInStealth: Bool = Equals(this.m_combatModePSM, gamePSMCombat.Stealth);
  let isOutOfCombat: Bool = NotEquals(this.m_combatModePSM, gamePSMCombat.InCombat) && NotEquals(this.m_combatModePSM, gamePSMCombat.Stealth);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let isZoomActive: Bool = (this.m_playerStateMachineBlackboard_LHUD.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel) > 1.0) && !isWeaponUnsheathed;
  // Additional flags
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && PlayerHealthbarModuleConfig.BindToGlobalHotkey();
  let showForStealth: Bool =  isInStealth && PlayerHealthbarModuleConfig.ShowInStealth();
  let showForWeapon: Bool = isWeaponUnsheathed && PlayerHealthbarModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  isZoomActive && PlayerHealthbarModuleConfig.ShowWithZoom();
  let showForHealthNotFull: Bool = !isMaxHP && PlayerHealthbarModuleConfig.ShowWhenHealthNotFull();
  let showForMemoryNotFull: Bool = this.m_quickhacksMemoryPercent < 100.00 && PlayerHealthbarModuleConfig.ShowWhenMemoryNotFull();
  let showForActiveBuffs: Bool = this.m_buffsVisible && PlayerHealthbarModuleConfig.ShowWhenBuffsActive();
  let showForActiveQuickhacks: Bool = areQuickhacksUsed && PlayerHealthbarModuleConfig.ShowWhenQuickhacksActive();
  let showForCombat: Bool = Equals(this.m_combatModePSM, gamePSMCombat.InCombat) && PlayerHealthbarModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = isOutOfCombat && PlayerHealthbarModuleConfig.ShowOutOfCombat();
  let outOfCombatAvailable: Bool = showForOutOfCombat && !isInStealth && !isWeaponUnsheathed && !isZoomActive;

  let defaultVisibility: Bool = !isMaxHP || this.m_quickhacksMemoryPercent < 100.00 || this.m_buffsVisible || areQuickhacksUsed || Equals(this.m_combatModePSM, gamePSMCombat.InCombat);
  let moddedVisibility: Bool = showForHealthNotFull || showForMemoryNotFull || showForActiveBuffs || showForActiveQuickhacks || showForCombat || outOfCombatAvailable || showForGlobalHotkey || showForStealth || showForWeapon || showForZoom;
  let isVisible: Bool = defaultVisibility;

  if PlayerHealthbarModuleConfig.IsEnabled() {
    isVisible = moddedVisibility;
  };

  if isVisible {
    this.ShowRequest();
  } else {
    this.HideRequest();
  };
}
