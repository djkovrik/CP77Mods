import LimitedHudConfig.PlayerHealthbarModuleConfig
import LimitedHudCommon.LHUDEvent

@addMethod(healthbarWidgetGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.ComputeHealthBarVisibility();
}

@replaceMethod(healthbarWidgetGameController)
private final func ComputeHealthBarVisibility() -> Void {
  let isMaxHP: Bool = this.m_currentHealth >= this.m_maximumHealth - 2;
  let isMultiplayer: Bool = this.IsPlayingMultiplayer();
  let areQuickhacksUsed: Bool = this.m_usedQuickhacks > 0;
  this.m_armorBar.SetVisible(isMultiplayer);
  this.UpdateGodModeVisibility();
  inkWidgetRef.SetVisible(this.m_quickhacksContainer, this.IsCyberdeckEquipped());
  if NotEquals(this.m_currentVisionPSM, gamePSMVision.Default) {
    this.HideRequest();
    return;
  };

  // Additional flags
  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
  let showForHealthNotFull: Bool = !isMaxHP && this.lhudConfig.ShowWhenHealthNotFull;
  let showForMemoryNotFull: Bool = this.m_quickhacksMemoryPercent > 0.0 && this.m_quickhacksMemoryPercent <= 98.0 && this.lhudConfig.ShowWhenMemoryNotFull;
  let showForActiveBuffs: Bool = this.m_buffsVisible && this.lhudConfig.ShowWhenBuffsActive;
  let showForActiveQuickhacks: Bool = areQuickhacksUsed && this.lhudConfig.ShowWhenQuickhacksActive;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;

  let defaultVisibility: Bool = !isMaxHP || areQuickhacksUsed || isMultiplayer || Equals(this.m_combatModePSM, gamePSMCombat.InCombat) || (this.m_quickhacksMemoryPercent > 0.0 && this.m_quickhacksMemoryPercent < 100.0) || this.m_buffsVisible;
  let moddedVisibility: Bool = showForGlobalHotkey || showForStealth || showForZoom || showForWeapon || showForHealthNotFull || showForMemoryNotFull || showForActiveBuffs || showForActiveQuickhacks || showForCombat || showForOutOfCombat;
  let isVisible: Bool = defaultVisibility;

  if this.lhudConfig.IsEnabled {
    isVisible = moddedVisibility;
  };

  if isVisible {
    this.ShowRequest();
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
    this.m_moduleShown = false;
    this.GetRootWidget().SetVisible(false);
    this.OnInitializeFinished();
  };
}
