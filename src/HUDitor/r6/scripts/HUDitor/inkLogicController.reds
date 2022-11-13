// Called when gameplay actually starts & widgets are loaded
@wrapMethod(dialogWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.QueueEvent(new HijackSlotsEvent());
  this.QueueEvent(new GameSessionInitializedEvent());
}

@wrapMethod(scannerDetailsGameController)
protected cb func OnScannedObjectChanged(value: EntityID) -> Bool {
  wrappedMethod(value);
  let evt: ref<ScannerDetailsAppearedEvent> = new ScannerDetailsAppearedEvent();
  evt.isVisible = EntityID.IsDefined(value);
  evt.isHackable = this.m_hasHacks;
  GameInstance.GetUISystem(this.m_gameInstance).QueueEvent(evt);
}
