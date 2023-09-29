import LimitedHudConfig.ActionButtonsModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEvent

@addMethod(HotkeysWidgetController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
  if this.lhud_isBraindanceActive { isVisible = false; };
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
    } else {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.3);
    };
  };
}

@addField(HotkeysWidgetController)
private let lhudConfig: ref<ActionButtonsModuleConfig>;

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new ActionButtonsModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@addMethod(HotkeysWidgetController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new ActionButtonsModuleConfig();
}


// New phone controller

@addMethod(PhoneHotkeyController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(PhoneHotkeyController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
  if this.lhud_isBraindanceActive { isVisible = false; };
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
    } else {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.3);
    };
  };
}

@addField(PhoneHotkeyController)
private let lhudConfig: ref<ActionButtonsModuleConfig>;

@wrapMethod(PhoneHotkeyController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  wrappedMethod(player);
  this.lhudConfig = new ActionButtonsModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@addMethod(PhoneHotkeyController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new ActionButtonsModuleConfig();
}
