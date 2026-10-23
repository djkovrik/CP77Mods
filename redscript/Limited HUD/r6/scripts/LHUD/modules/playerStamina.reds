import LimitedHudConfig.PlayerStaminabarModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEventType
import LimitedHudCommon.LHUDEvent

@addMethod(StaminabarWidgetGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(StaminabarWidgetGameController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  this.m_RootWidget.SetVisible(true);

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
  let showNotFull: Bool = this.m_currentBarValue < 1.0 && this.lhudConfig.ShowNotFull;
  let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfig.ShowInDangerArea;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom || showNotFull || showForArea;
  if this.lhud_isBraindanceActive { isVisible = false; };
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlphaLHUD(this.GetRootWidget(), this.lhudConfig.Opacity, 0.25);
    } else {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.25);
    };
  };
}

@addField(StaminabarWidgetGameController)
private let lhudConfig: ref<PlayerStaminabarModuleConfig>;

@wrapMethod(StaminabarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new PlayerStaminabarModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@addMethod(StaminabarWidgetGameController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new PlayerStaminabarModuleConfig();
}

@wrapMethod(StaminabarWidgetGameController)
public final func EvaluateStaminaBarVisibility() -> Void {
  if this.lhudConfig.IsEnabled {
    this.DetermineCurrentVisibility();
  } else {
    wrappedMethod();
  };
}

@wrapMethod(StaminabarWidgetGameController)
protected cb func OnFocusedCoolPerkActive(evt: ref<FocusPerkTriggerd>) -> Bool {
  wrappedMethod(evt);
  if !evt.isActive {
    this.lhud_isVisibleNow = true;
    this.DetermineCurrentVisibility();
  };
}
