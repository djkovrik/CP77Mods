import LimitedHudConfig.CrouchIndicatorModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEvent

@addMethod(CrouchIndicatorGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(CrouchIndicatorGameController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled || this.lhud_isBraindanceActive {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

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

@addField(CrouchIndicatorGameController)
private let lhudConfig: ref<CrouchIndicatorModuleConfig>;

@wrapMethod(CrouchIndicatorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new CrouchIndicatorModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@addMethod(CrouchIndicatorGameController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new CrouchIndicatorModuleConfig();
}
