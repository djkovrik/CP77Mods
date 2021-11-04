import LimitedHudConfig.CrouchIndicatorModuleConfig
import LimitedHudCommon.LHUDEvent

@addMethod(CrouchIndicatorGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(CrouchIndicatorGameController)
public func DetermineCurrentVisibility() -> Void {
  if !CrouchIndicatorModuleConfig.IsEnabled() {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && CrouchIndicatorModuleConfig.BindToGlobalHotkey();
  let showForCombat: Bool = this.lhud_isCombatActive && CrouchIndicatorModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && CrouchIndicatorModuleConfig.ShowOutOfCombat();
  let showForStealth: Bool =  this.lhud_isStealthActive && CrouchIndicatorModuleConfig.ShowInStealth();
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && !this.lhud_isCombatActive && CrouchIndicatorModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  this.lhud_isZoomActive && CrouchIndicatorModuleConfig.ShowWithZoom();

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

@wrapMethod(CrouchIndicatorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if CrouchIndicatorModuleConfig.IsEnabled() {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}
