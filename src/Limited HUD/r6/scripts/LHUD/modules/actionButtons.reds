import LimitedHudConfig.ActionButtonsModuleConfig
import LimitedHudCommon.LHUDEvent

@addMethod(HotkeysWidgetController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func DetermineCurrentVisibility() -> Void {
  if !ActionButtonsModuleConfig.IsEnabled() {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && ActionButtonsModuleConfig.BindToGlobalHotkey();
  let showForCombat: Bool = this.lhud_isCombatActive && ActionButtonsModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && ActionButtonsModuleConfig.ShowOutOfCombat();
  let showForStealth: Bool =  this.lhud_isStealthActive && ActionButtonsModuleConfig.ShowInStealth();
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && !this.lhud_isCombatActive && ActionButtonsModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  this.lhud_isZoomActive && ActionButtonsModuleConfig.ShowWithZoom();

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
    } else {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.3);
    };
  };
}

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if ActionButtonsModuleConfig.IsEnabled() {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}
