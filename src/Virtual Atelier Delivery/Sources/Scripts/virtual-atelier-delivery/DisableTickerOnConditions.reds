module AtelierDelivery

// Timeskip menu
@wrapMethod(TimeskipGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  OrderTrackingTicker.Get(this.m_player.GetGame()).CancelScheduledCallback();
}

@wrapMethod(TimeskipGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  OrderTrackingTicker.Get(this.m_player.GetGame()).ScheduleCallbackShortened();
}

// Braindance
@wrapMethod(HUDManager)
protected cb func OnBraindanceToggle(value: Bool) -> Bool {
  wrappedMethod(value);
  if this.m_isBraindanceActive {
    OrderTrackingTicker.Get(this.GetGameInstance()).CancelScheduledCallback();
  } else {
    OrderTrackingTicker.Get(this.GetGameInstance()).ScheduleCallbackNormal();
  };
}

// Johnny
@wrapMethod(PlayerSystem)
protected final cb func OnLocalPlayerPossesionChanged(playerPossesion: gamedataPlayerPossesion) -> Bool {
  if Equals(playerPossesion, gamedataPlayerPossesion.Johnny) {
    OrderTrackingTicker.Get(this.GetGameInstance()).CancelScheduledCallback();
  } else {
    OrderTrackingTicker.Get(this.GetGameInstance()).ScheduleCallbackNormal();
  };

  return wrappedMethod(playerPossesion);
}
