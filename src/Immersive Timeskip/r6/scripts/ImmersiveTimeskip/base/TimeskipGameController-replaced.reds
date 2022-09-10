@replaceMethod(TimeskipGameController)
protected cb func OnInitialize() -> Bool {
  let cursorEvent: ref<TimeSkipCursorInitFinishedEvent>;
  this.m_player = this.GetPlayerControlledObject();
  this.m_player.RegisterInputListener(this, n"__DEVICE_CHANGED__");
  this.m_gameInstance = (this.GetOwnerEntity() as GameObject).GetGame();
  this.m_timeSystem = GameInstance.GetTimeSystem(this.m_gameInstance);
  this.m_data = this.GetRootWidget().GetUserData(n"TimeSkipPopupData") as TimeSkipPopupData;
  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");
  this.RegisterToGlobalInputCallback(n"OnPostOnRelative", this, n"OnMouseInput");
  this.RegisterToGlobalInputCallback(n"OnPostOnAxis", this, n"OnGlobalAxisInput");
  inkWidgetRef.RegisterToCallback(this.m_mouseHitTestRef, n"OnHoverOver", this, n"OnHoverOver");
  inkWidgetRef.RegisterToCallback(this.m_mouseHitTestRef, n"OnHoverOut", this, n"OnHoverOut");
  this.PlayAnimation(this.m_intoAnimation);
  this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnIntroFinished");
  cursorEvent = new TimeSkipCursorInitFinishedEvent();
  this.QueueEvent(cursorEvent);
  // Disable world freezing
  // GameInstance.GetTimeSystem(this.m_player.GetGame()).SetTimeDilation(n"TimeSkip", 0.00);
  GameInstance.GetGodModeSystem(this.m_player.GetGame()).AddGodMode(this.m_player.GetEntityID(), gameGodModeType.Invulnerable, n"TimeSkip");
  this.DisplayTimeCurrent();
  this.UpdateTargetTime(this.m_currentTimeAngle + 0.79);

  // Tweak widget appearance
  let player: ref<PlayerPuppet> = this.m_player as PlayerPuppet;
  if player.itsTimeskipActive {
    this.TweakWidgetAppearance();
  };
}

@replaceMethod(TimeskipGameController)
protected cb func OnUninitialize() -> Bool {
  // GameInstance.GetTimeSystem(this.m_player.GetGame()).UnsetTimeDilation(n"TimeSkip");
  GameInstance.GetGodModeSystem(this.m_player.GetGame()).RemoveGodMode(this.m_player.GetEntityID(), gameGodModeType.Invulnerable, n"TimeSkip");
}
