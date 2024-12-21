import LimitedHudConfig.ActionButtonsModuleConfig
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEvent

// ACTION BUTTONS

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


// NEW PHONE CONTROLLER

@addMethod(PhoneHotkeyController)
private final func ShouldDisplayPhoneForLHUD() -> Bool {
  let info: PhoneCallInformation = FromVariant<PhoneCallInformation>(this.m_comDeviceBB.GetVariant(GetAllBlackboardDefs().UI_ComDevice.PhoneCallInformation));
  let phase: questPhoneCallPhase = info.callPhase;
  return Equals(phase, questPhoneCallPhase.StartCall) || Equals(phase, questPhoneCallPhase.IncomingCall);
}

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
  let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
  let isPhoneInUse: Bool = this.ShouldDisplayPhoneForLHUD();

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForWeapon || showForZoom || isPhoneInUse;
  
  if this.lhud_isBraindanceActive { isVisible = false; };
  this.lhud_isVisibleNow = isVisible;
  if isVisible {
    this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.1);
  } else {
    this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.1);
  };
}

@addField(PhoneHotkeyController)
private let lhudConfig: ref<ActionButtonsModuleConfig>;

@wrapMethod(PhoneHotkeyController)
protected func Initialize() -> Bool {
  let wrapped: Bool = wrappedMethod();
  this.lhudConfig = new ActionButtonsModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };

  return wrapped;
}

@addMethod(PhoneHotkeyController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new ActionButtonsModuleConfig();
}

@wrapMethod(PhoneHotkeyController)
private final func UpdateData() -> Void {
  wrappedMethod();

  if this.lhudConfig.IsEnabled {
    this.DetermineCurrentVisibility();
  };
}

@wrapMethod(PhoneHotkeyController)
private final func OnVehiclesManagerPopupIsShown(value: Bool) -> Void {
  if value {
    wrappedMethod(value);
  } else {
    this.DetermineCurrentVisibility();
  };
}

@wrapMethod(PhoneHotkeyController)
private final func OnRadioManagerPopupIsShown(value: Bool) -> Void {
  if value {
    wrappedMethod(value);
  } else {
    this.DetermineCurrentVisibility();
  };
}

@wrapMethod(PhoneHotkeyController)
private final func OnPhoneEnabledChanged(val: Bool) -> Void {
  if this.lhud_isVisibleNow { 
    wrappedMethod(val);
  } else {
    this.DetermineCurrentVisibility();
  };
}

@wrapMethod(PhoneHotkeyController)
protected cb func OnPhoneDeviceSlot(target: wref<inkWidget>) -> Bool {
  let wrapped: Bool = wrappedMethod(target);
  if this.lhud_isVisibleNow {
    this.DetermineCurrentVisibility();
  };

  return wrapped;
}

@wrapMethod(PhoneHotkeyController)
protected cb func OnPhoneDeviceReset(target: wref<inkWidget>) -> Bool {
  let wrapped: Bool = wrappedMethod(target);
  if this.lhud_isVisibleNow {
    this.DetermineCurrentVisibility();
  };
  
  return wrapped;
}

@wrapMethod(PhoneHotkeyController)
private final func IsPhoneInUse() -> Bool {
  let wrapped: Bool = wrappedMethod();
  if this.lhud_isVisibleNow {
    this.DetermineCurrentVisibility();
  };
  
  return wrapped;
}

// IN VEHICLE ACTION BUTTONS

@addMethod(HotkeyConsumableWidgetController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeyConsumableWidgetController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForWeapon || showForZoom;
  if this.lhud_isBraindanceActive { isVisible = false; };
  this.lhud_isVisibleNow = isVisible;
  if isVisible {
    this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
  } else {
    this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.3);
  };
}

@addField(HotkeyConsumableWidgetController)
private let lhudConfig: ref<ActionButtonsModuleConfig>;

@wrapMethod(HotkeyConsumableWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new ActionButtonsModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@addMethod(HotkeyConsumableWidgetController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new ActionButtonsModuleConfig();
}


// IN VEHICLE RADIO

@addMethod(HotkeyCustomRadioWidgetController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeyCustomRadioWidgetController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForWeapon || showForZoom;
  if this.lhud_isBraindanceActive { isVisible = false; };
  this.lhud_isVisibleNow = isVisible;
  if isVisible {
    this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
  } else {
    this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.3);
  };
}

@addField(HotkeyCustomRadioWidgetController)
private let lhudConfig: ref<ActionButtonsModuleConfig>;

@wrapMethod(HotkeyCustomRadioWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new ActionButtonsModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@addMethod(HotkeyCustomRadioWidgetController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new ActionButtonsModuleConfig();
}
