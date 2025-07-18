import LimitedHudConfig.PlayerHealthbarModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEventType
import LimitedHudCommon.LHUDEvent

@addField(healthbarWidgetGameController)
private let statusBBLHUD: wref<IBlackboard>;

@addMethod(healthbarWidgetGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.OnUpdateHealthBarVisibility();
}

@addMethod(healthbarWidgetGameController)
private func IsNonHousingEffect(id: TweakDBID) -> Bool {
  return NotEquals(t"HousingStatusEffect.Rested", id)
    && NotEquals(t"HousingStatusEffect.Refreshed", id)
    && NotEquals(t"HousingStatusEffect.Energized", id);
}

@replaceMethod(healthbarWidgetGameController)
protected cb func OnUpdateHealthBarVisibility() -> Bool {
  let isMaxHP: Bool = this.m_currentHealth == this.m_maximumHealth;
  let areQuickhacksUsed: Bool = this.m_usedQuickhacks > 0;
  this.UpdateGodModeVisibility();
  inkWidgetRef.SetVisible(this.m_quickhacksContainer, this.IsCyberdeckEquipped());
  if this.m_isAutodriveEnabled {
    this.HideRequest();
    return true;
  };
  if !this.m_isInOverclockedState {
    inkWidgetRef.Get(this.m_fullBar).SetEffectEnabled(inkEffectType.ScanlineWipe, n"ScanlineWipe_0", false);
    this.GetRootWidget().SetState(n"Default");
    this.m_healthMemoryJumpAnim.Stop();
    this.m_pulseBar.Stop();
    this.m_pulseText.Stop();
    this.m_pulse.Stop();
  };
  if NotEquals(this.m_currentVisionPSM, gamePSMVision.Default) || this.m_isControllingDevice {
    if !this.m_isInOverclockedState {
      this.HideRequest();
      return true;
    };
  };

  // Check active buffs
  let hasNonHousingBuff: Bool = true;
  let buffsVariant: Variant;
  let buffs: array<BuffInfo>;
  
  if IsDefined(this.statusBBLHUD) {
    hasNonHousingBuff = false;
    buffsVariant = this.statusBBLHUD.GetVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.BuffsList);
    buffs = FromVariant<array<BuffInfo>>(buffsVariant);
    for buff in buffs {
      if !hasNonHousingBuff && this.IsNonHousingEffect(buff.buffID) {
        hasNonHousingBuff = true;
      };
    };
  };

  // Additional flags
  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
  let showForHealthNotFull: Bool = !isMaxHP && this.lhudConfig.ShowWhenHealthNotFull;
  let showForMemoryNotFull: Bool = this.m_quickhacksMemoryPercent > 0.0 && this.m_quickhacksMemoryPercent <= 98.0 && this.lhudConfig.ShowWhenMemoryNotFull;
  let showForActiveBuffs: Bool = this.m_buffsVisible && hasNonHousingBuff && this.lhudConfig.ShowWhenBuffsActive;
  let showForActiveQuickhacks: Bool = areQuickhacksUsed && this.lhudConfig.ShowWhenQuickhacksActive;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfig.ShowInDangerArea;

  let defaultVisibility: Bool = !isMaxHP || areQuickhacksUsed || Equals(this.m_combatModePSM, gamePSMCombat.InCombat) || this.m_quickhacksMemoryPercent < 100.00 || this.m_buffsVisible || this.m_isInOverclockedState;
  let moddedVisibility: Bool = showForGlobalHotkey || showForStealth || showForZoom || showForWeapon || showForHealthNotFull || showForMemoryNotFull || showForActiveBuffs || showForActiveQuickhacks || showForCombat || showForOutOfCombat || showForArea;
  let isVisible: Bool = defaultVisibility;

  if this.lhudConfig.IsEnabled {
    isVisible = moddedVisibility;
  };

  if isVisible {
    this.ShowRequest();
    this.GetRootCompoundWidget().SetOpacity(this.lhudConfig.Opacity);
  } else {
    this.HideRequest();
  };
}

@addField(healthbarWidgetGameController)
private let lhudConfig: ref<PlayerHealthbarModuleConfig>;

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new PlayerHealthbarModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.statusBBLHUD = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerBioMonitor);
    this.m_moduleShown = false;
    this.GetRootWidget().SetVisible(false);
    this.OnInitializeFinished();
  };
}

@addMethod(healthbarWidgetGameController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new PlayerHealthbarModuleConfig();
}

// Refresh buffs visibility
@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  wrappedMethod(evt);
  this.QueueLHUDEvent(LHUDEventType.Refresh, true);
}

@wrapMethod(PlayerPuppet)
protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
  wrappedMethod(evt);
  this.QueueLHUDEvent(LHUDEventType.Refresh, true);
}
