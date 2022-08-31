import ImmersiveTimeSkip.Utils.ITS
import ImmersiveTimeSkip.Events.*

@addMethod(TimeskipGameController)
private func TweakWidgetAppearance() -> Void {
  let root = this.GetRootCompoundWidget() as inkCompoundWidget;
  root.GetWidget(n"bg1").SetVisible(false);
  root.GetWidget(n"bk").SetVisible(false);
  root.GetWidget(n"fluff").SetVisible(false);
}

@addMethod(TimeskipGameController)
private func FinalizeTimeSkip() -> Void {
  let player: ref<PlayerPuppet> = this.m_player as PlayerPuppet;
  let evt: ref<TimeSkipMenuVisibilityEvent> = new TimeSkipMenuVisibilityEvent();
  ITS("FinalizeTimeSkip");
  if player.itsTimeSkipActive {
    evt.visible = false;
    GameInstance.GetUISystem(player.GetGame()).QueueEvent(evt);
    player.itsTimeSkipActive = false;
    player.itsTimeSkipPopupToken = null;
  };
}

@addMethod(TimeskipGameController)
private func FastForwardTimeCustom(diff: Float) -> Void {
  let timeDiff: Float = this.itsInitialDiff - diff;
  let timeAddition: Float = timeDiff * this.itsSecondsPerDegree;
  let newTimestamp: Int32 = Cast<Int32>(this.itsInitialTimestamp + timeAddition);
  this.m_timeSystem.SetGameTimeBySeconds(newTimestamp);
}

@addMethod(TimeskipGameController)
protected cb func OnInterruptCustomTimeSkipEvent(evt: ref<InterruptCustomTimeSkipEvent>) -> Bool {
  let player: ref<PlayerPuppet> = this.m_player as PlayerPuppet;
  if player.itsTimeSkipActive {
    ITS("Interrupting...");
    player.DisableCustomTimeFastForward();
    GameInstance.GetAudioSystem(this.m_gameInstance).Play(n"ui_menu_map_timeskip_stop");
    this.m_inputEnabled = true;
    this.m_animProxy.Stop(true);
    this.m_progressAnimProxy.Stop(true);
    // let data: ref<TimeSkipPopupCloseData> = new TimeSkipPopupCloseData();
    // this.m_data.token.TriggerCallback(data);
    this.FinalizeTimeSkip();
    this.Cancel();
  };
}
