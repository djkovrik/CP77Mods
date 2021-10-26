import LimitedHudConfig.ActionButtonsModuleConfig
import LimitedHudCommon.*

@addMethod(HotkeysWidgetController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func DetermineCurrentVisibility() -> Void {
  // Check if enabled
  if !ActionButtonsModuleConfig.IsEnabled() {
    return ;
  };

  // Check for braindance
  if this.l_isBraindanceActive {
    this.GetRootWidget().SetVisible(false);
    return;
  };

  // Bind to config
  let showForGlobalHotkey: Bool = this.l_isGlobalFlagToggled && ActionButtonsModuleConfig.BindToGlobalHotkey();
  let showForCombat: Bool = this.l_isCombatActive && ActionButtonsModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = this.l_isOutOfCombatActive && ActionButtonsModuleConfig.ShowOutOfCombat();
  let showForStealth: Bool =  this.l_isStealthActive && ActionButtonsModuleConfig.ShowInStealth();
  let showForWeapon: Bool = this.l_isWeaponUnsheathed && ActionButtonsModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  this.l_isZoomActive && ActionButtonsModuleConfig.ShowWithZoom();

  // Set visibility
  let isVisible: Bool = showForCombat || showForOutOfCombat || showForGlobalHotkey || showForStealth || showForWeapon || showForZoom;
  if NotEquals(this.l_isVisibleNow, isVisible) {
    this.l_isVisibleNow = isVisible;
    this.GetRootWidget().SetVisible(isVisible);
  };
}
