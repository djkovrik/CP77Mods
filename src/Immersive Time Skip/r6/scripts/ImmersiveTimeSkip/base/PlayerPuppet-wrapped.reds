import ImmersiveTimeSkip.Hotkey.CustomTimeSkipListener

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  this.itsTimeSkipListener = new CustomTimeSkipListener();
  this.itsTimeSkipListener.SetPlayer(this);
  this.RegisterInputListener(this.itsTimeSkipListener);
  this.itsTimeSystem = GameInstance.GetTimeSystem(this.GetGame());
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.itsTimeSkipListener);
    this.itsTimeSkipListener = null;
}
