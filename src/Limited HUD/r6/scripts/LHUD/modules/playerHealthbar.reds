import LimitedHudConfig.PlayerHealthbarModuleConfig
import LimitedHudCommon.LHUDEvent

@addMethod(healthbarWidgetGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.ComputeHealthBarVisibility();
}

@replaceMethod(healthbarWidgetGameController)
private final func ComputeHealthBarVisibility() -> Void {
  let isMaxHP: Bool = this.m_currentHealth == this.m_maximumHealth;
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
  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && PlayerHealthbarModuleConfig.BindToGlobalHotkey();
  let showForStealth: Bool =  this.lhud_isStealthActive && PlayerHealthbarModuleConfig.ShowInStealth();
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && PlayerHealthbarModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  this.lhud_isZoomActive && PlayerHealthbarModuleConfig.ShowWithZoom();
  let showForHealthNotFull: Bool = !isMaxHP && PlayerHealthbarModuleConfig.ShowWhenHealthNotFull();
  let showForMemoryNotFull: Bool = this.m_quickhacksMemoryPercent > 0.0 && this.m_quickhacksMemoryPercent < 100.0 && PlayerHealthbarModuleConfig.ShowWhenMemoryNotFull();
  let showForActiveBuffs: Bool = this.m_buffsVisible && PlayerHealthbarModuleConfig.ShowWhenBuffsActive();
  let showForActiveQuickhacks: Bool = areQuickhacksUsed && PlayerHealthbarModuleConfig.ShowWhenQuickhacksActive();
  let showForCombat: Bool = this.lhud_isCombatActive && PlayerHealthbarModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && PlayerHealthbarModuleConfig.ShowOutOfCombat();

  let defaultVisibility: Bool = !isMaxHP || areQuickhacksUsed || isMultiplayer || Equals(this.m_combatModePSM, gamePSMCombat.InCombat) || (this.m_quickhacksMemoryPercent > 0.0 && this.m_quickhacksMemoryPercent < 100.0) || this.m_buffsVisible;
  let moddedVisibility: Bool = showForGlobalHotkey || showForStealth || showForZoom || showForWeapon || showForHealthNotFull || showForMemoryNotFull || showForActiveBuffs || showForActiveQuickhacks || showForCombat || showForOutOfCombat;
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

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if PlayerHealthbarModuleConfig.IsEnabled() {
    this.m_moduleShown = false;
    this.GetRootWidget().SetVisible(false);
    this.OnInitializeFinished();
  };
}
