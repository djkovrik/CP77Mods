import ImmersiveTimeskip.Events.OpenTimeSkipMenuEvent
import ImmersiveTimeskip.Config.ITSConfig

@replaceMethod(HubTimeSkipController)
protected cb func OnTimeSkipButtonPressed(e: ref<inkPointerEvent>) -> Bool {
  let data: ref<TimeSkipPopupData>;
  if !e.IsAction(n"click") {
    return true;
  };

  if ITSConfig.ReplaceIngameTimeskip() {
    this.itsMenuEventDispatcher.SpawnEvent(n"OnCloseHubMenu");
    GameInstance.GetUISystem(this.itsPlayerInstance.GetGame()).QueueEvent(new OpenTimeSkipMenuEvent());
  } else {
    this.SetCursorVisibility(false);
    data = new TimeSkipPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\time_skip\\time_skip.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    this.m_timeSkipPopupToken = this.m_gameCtrlRef.ShowGameNotification(data);
    this.m_timeSkipPopupToken.RegisterListener(this, n"OnTimeSkipPopupClosed");
    this.PlaySound(n"Button", n"OnPress");
  };
}
