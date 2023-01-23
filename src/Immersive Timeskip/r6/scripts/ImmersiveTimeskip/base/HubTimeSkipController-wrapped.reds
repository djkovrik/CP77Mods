import ImmersiveTimeskip.Events.OpenTimeSkipMenuEvent
import ImmersiveTimeskip.Config.ITSConfig

@wrapMethod(HubTimeSkipController)
protected cb func OnTimeSkipButtonPressed(e: ref<inkPointerEvent>) -> Bool {
  if !e.IsAction(n"click") {
    return true;
  };

  if ITSConfig.ReplaceIngameTimeskip() {
    this.itsMenuEventDispatcher.SpawnEvent(n"OnCloseHubMenu");
    GameInstance.GetUISystem(this.itsPlayerInstance.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
  } else {
    wrappedMethod(e);
  }
}
