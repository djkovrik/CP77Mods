@wrapMethod(scannerGameController)
private final func ShowScanner(show: Bool) -> Void {
  wrappedMethod(show);
  let event: ref<ScannerStateChangedEvent> = new ScannerStateChangedEvent();
  event.isEnabled = show;
  GameInstance.GetUISystem(this.m_playerPuppet.GetGame()).QueueEvent(event);
}
