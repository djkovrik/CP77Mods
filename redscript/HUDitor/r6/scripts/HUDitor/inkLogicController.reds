import HUDrag.HUDWidgetsManager.*

public class HUDitorDelayedInitCallback extends DelayCallback {
  public let manager: wref<HUDWidgetsManager>;
  public let requestId: Uint32;
  public func Call() -> Void {
    if IsDefined(this.manager) && !this.manager.disposed { this.manager.QueueBind(this.requestId); };
  }
}

@addMethod(inkGameController)
protected cb func OnHUDitorBindEvent(evt: ref<HUDitorBindEvent>) -> Bool {
  if IsDefined(evt.manager) && evt.manager.uiController == this {
    evt.manager.ApplyBind(evt.requestId);
  };
}

@wrapMethod(PhoneHotkeyController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  wrappedMethod(player);
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.RequestBind(); };
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScannedObjectChanged(value: EntityID) -> Bool {
  wrappedMethod(value);
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.scannerBlocked = EntityID.IsDefined(value) && !this.m_isQuickHackAble; manager.UpdateContext(); };
}

@wrapMethod(PlayerPuppet)
protected cb func OnSceneTierChange(newState: Int32) -> Bool {
  wrappedMethod(newState);
  if IsDefined(this.hudWidgetsManager) { this.hudWidgetsManager.sceneTier = newState; this.hudWidgetsManager.UpdateContext(); };
}

@wrapMethod(PlayerPuppet)
protected cb func OnVisionStateChange(newState: Int32) -> Bool {
  wrappedMethod(newState);
  if IsDefined(this.hudWidgetsManager) { this.hudWidgetsManager.visionState = newState; this.hudWidgetsManager.UpdateContext(); };
}

@wrapMethod(NewHudPhoneGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.RequestBind(); };
}

@addField(NewHudPhoneGameController)
public let huditorPhoneLayout: wref<HUDitorPhoneLayout>;

@wrapMethod(NewHudPhoneGameController)
private final func PlayPhoneIconAnim(element: gameuiActivePhoneElement, opt deactivation: Bool) -> Void {
  if IsDefined(this.huditorPhoneLayout) {
    let destination: gameuiActivePhoneElement = this.GetTopmostActivePhoneElement();
    if EnumInt(destination) >= EnumInt(element) {
      this.huditorPhoneLayout.PrepareTransition(deactivation ? destination : element);
    };
  };
  wrappedMethod(element, deactivation);
}

@wrapMethod(NewHudPhoneGameController)
protected cb func OnResolutionChanged() -> Bool {
  let result: Bool = wrappedMethod();
  if IsDefined(this.huditorPhoneLayout) {
    let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
    if IsDefined(manager) { manager.RequestPhoneGeometryRefresh(); };
  };
  return result;
}

@addMethod(NewHudPhoneGameController)
public func ResumeHUDitorPhoneIconAnim(paused: Bool) -> Void {
  this.PlayPhoneIconAnim(this.GetTopmostActivePhoneElement());
  if paused && IsDefined(this.m_phoneIconAnimProxy) { this.m_phoneIconAnimProxy.Pause(); };
}

@wrapMethod(HotkeysWidgetController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  wrappedMethod(player);
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.RequestBind(); };
}

@wrapMethod(HotkeyConsumableWidgetController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  wrappedMethod(player);
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.RequestBind(); };
}

@wrapMethod(hudCarController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.RequestBind(); };
}

@wrapMethod(HotkeyCustomRadioWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) { manager.RequestBind(); };
}
