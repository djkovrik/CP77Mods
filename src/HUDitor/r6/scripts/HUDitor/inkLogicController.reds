import HUDrag.HUDitorConfig

// Called when gameplay actually starts & widgets are loaded
@addField(PhoneHotkeyController)
private let huditorDelayId: DelayID;

@wrapMethod(PhoneHotkeyController)
protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
  wrappedMethod(player);

  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(player.GetGame());
  let uiSystem: ref<UISystem> = GameInstance.GetUISystem(player.GetGame());
  let delayCallback: ref<HUDitorDelayedInitCallback> = new HUDitorDelayedInitCallback();
  delayCallback.uiSystem = uiSystem;
  delaySystem.CancelCallback(this.huditorDelayId);
  this.huditorDelayId = delaySystem.DelayCallback(delayCallback, 0.1, false);
}

public class HUDitorDelayedInitCallback extends DelayCallback {
  public let uiSystem: wref<UISystem>;

  public func Call() -> Void {
    let cfg: ref<HUDitorConfig> = new HUDitorConfig();
    this.uiSystem.QueueEvent(new HijackSlotsEvent());
    this.uiSystem.QueueEvent(new GameSessionInitializedEvent());
    if cfg.fpsCounterEnabled {
      this.uiSystem.QueueEvent(new ReparentFpsCounterEvent());
    };
  }
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScannedObjectChanged(value: EntityID) -> Bool {
  wrappedMethod(value);
  let evt: ref<ScannerDetailsAppearedEvent> = new ScannerDetailsAppearedEvent();
  evt.isVisible = EntityID.IsDefined(value);
  evt.isHackable = this.m_isQuickHackAble;
  GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(evt);
}
