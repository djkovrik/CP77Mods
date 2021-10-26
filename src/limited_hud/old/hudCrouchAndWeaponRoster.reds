/////////////////////////////////////////////////////////////////////
// Show weapon roster and crouch indicator when weapon unsheathed  //
/////////////////////////////////////////////////////////////////////

import LimitedHudCommon.*
import LimitedHudConfig.CrouchAndWeaponRosterModuleConfig

// ---------- CrouchIndicatorGameController

@addMethod(CrouchIndicatorGameController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(CrouchIndicatorGameController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(CrouchIndicatorGameController)
public func DetermineCurrentVisibility() {
  // Check if enabled
  if !CrouchAndWeaponRosterModuleConfig.IsEnabled() {
    return ;
  };

  // Check for braindance
  if this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive) {
    this.ShowWidget(false);
    return ;
  };

  // Basic checks
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let showForStealth = isCurrentStateStealth && CrouchAndWeaponRosterModuleConfig.ShowInStealth();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && CrouchAndWeaponRosterModuleConfig.BindToGlobalHotkey();
  let isVisible: Bool = isWeaponUnsheathed || showForStealth || showForGlobalHotkey;
  this.ShowWidget(isVisible);
}

@addMethod(CrouchIndicatorGameController)
public func ShowWidget(show: Bool) -> Void {
  if show {
    this.GetRootWidget().SetOpacity(1.0);
  } else {
    this.GetRootWidget().SetOpacity(0.0);
  };
}

@addMethod(CrouchIndicatorGameController)
public func OnFoldFinished(proxy: ref<inkAnimProxy>) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(CrouchIndicatorGameController)
public func OnUnfoldStarted(proxy: ref<inkAnimProxy>) -> Bool {
  this.ShowWidget(true);
}

@wrapMethod(CrouchIndicatorGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  this.m_playerPuppet_LHUD = this.m_Player;
  // Register BBs
  this.m_braindanceBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().Braindance);
  this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
  this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
  // Register callbacks
  this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
  this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
  this.DetermineCurrentVisibility();
}

@wrapMethod(CrouchIndicatorGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  // Unregister callbacks
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_Player = null;
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  if ItemID.IsValid(currentData.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    this.PlayFold();
  };
}

@replaceMethod(CrouchIndicatorGameController)
private final func PlayFold() -> Void {
  if this.m_folded {
    return ;
  };
  this.m_folded = true;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFoldFinished");
}

@replaceMethod(CrouchIndicatorGameController)
private final func PlayUnfold() -> Void {
  if !this.m_folded || !this.m_Player.HasAnyWeaponEquipped_LHUD() {
    return ;
  };
  this.m_folded = false;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"unfold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnUnfoldStarted");
}


// ---------- weaponRosterGameController
@addMethod(weaponRosterGameController)
public func OnCombatStateChanged(newState: Int32) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(weaponRosterGameController)
public func OnGlobalToggleChanged(value: Bool) -> Void {
  this.m_isGlobalFlagToggled_LHUD = value;
  this.DetermineCurrentVisibility();
}

@addMethod(weaponRosterGameController)
public func DetermineCurrentVisibility() {
  // Check if enabled
  if !CrouchAndWeaponRosterModuleConfig.IsEnabled() {
    return ;
  };

  // Check for braindance
  if this.m_braindanceBlackboard_LHUD.GetBool(GetAllBlackboardDefs().Braindance.IsActive) {
    this.ShowWidget(false);
    return ;
  };

  // Basic checks
  let isCurrentStateStealth: Bool = Equals(this.m_playerStateMachineBlackboard_LHUD.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat), gamePSMCombat.Stealth);
  let isWeaponUnsheathed: Bool = this.m_playerPuppet_LHUD.HasAnyWeaponEquipped_LHUD();
  let showForStealth = isCurrentStateStealth && CrouchAndWeaponRosterModuleConfig.ShowInStealth();
  let showForGlobalHotkey: Bool = this.m_isGlobalFlagToggled_LHUD && CrouchAndWeaponRosterModuleConfig.BindToGlobalHotkey();
  let isVisible: Bool = isWeaponUnsheathed || showForStealth || showForGlobalHotkey;
  this.ShowWidget(isVisible);
}

@addMethod(weaponRosterGameController)
public func ShowWidget(show: Bool) -> Void {
  inkImageRef.SetVisible(this.m_container, show);
}

@addMethod(weaponRosterGameController)
public func OnFoldFinished(proxy: ref<inkAnimProxy>) -> Bool {
  this.DetermineCurrentVisibility();
}

@addMethod(weaponRosterGameController)
public func OnUnfoldStarted(proxy: ref<inkAnimProxy>) -> Bool {
  this.ShowWidget(true);
}

@wrapMethod(weaponRosterGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  this.m_playerPuppet_LHUD = this.m_Player;
  if IsDefined(this.m_playerPuppet_LHUD) && this.m_playerPuppet_LHUD.IsControlledByLocalPeer() {
    // Register BBs
    this.m_braindanceBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().Braindance);
    this.m_playerStateMachineBlackboard_LHUD = this.GetPSMBlackboard(this.m_playerPuppet_LHUD);
    this.m_systemBlackboard_LHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    // Register callbacks
    this.m_combatTrackingCallback_LHUD = this.m_playerStateMachineBlackboard_LHUD.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    this.m_globalFlagCallback_LHUD = this.m_systemBlackboard_LHUD.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this, n"OnGlobalToggleChanged");
    this.DetermineCurrentVisibility();
  };
}

@wrapMethod(weaponRosterGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  // Unregister callbacks
  this.m_playerStateMachineBlackboard_LHUD.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatTrackingCallback_LHUD);
  this.m_systemBlackboard_LHUD.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, this.m_globalFlagCallback_LHUD);
  this.m_Player = null;
}

@replaceMethod(weaponRosterGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  if ItemID.IsValid(currentData.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
private final func PlayFold() -> Void {
  if this.m_folded {
    return ;
  };
  this.m_folded = true;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFoldFinished");
}

@replaceMethod(weaponRosterGameController)
private final func PlayUnfold() -> Void {
  if !this.m_folded || !this.m_Player.HasAnyWeaponEquipped_LHUD() {
    return ;
  };
  this.m_folded = false;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"unfold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnUnfoldStarted");
}
