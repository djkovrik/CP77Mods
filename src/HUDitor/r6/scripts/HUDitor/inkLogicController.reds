// Called when gameplay actually starts & widgets are loaded
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.QueueEvent(new HijackSlotsEvent());
  this.QueueEvent(new GameSessionInitializedEvent());
}
