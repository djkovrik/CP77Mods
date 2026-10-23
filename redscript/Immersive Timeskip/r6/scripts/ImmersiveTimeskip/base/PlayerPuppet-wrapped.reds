import ImmersiveTimeskip.Events.InterruptCustomTimeSkipEvent
import ImmersiveTimeskip.Hotkey.CustomTimeSkipListener

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  this.itsTimeskipListener = new CustomTimeSkipListener();
  this.itsTimeskipListener.SetPlayer(this);
  this.RegisterInputListener(this.itsTimeskipListener);
  this.itsTimeSystem = GameInstance.GetTimeSystem(this.GetGame());
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.itsTimeskipListener);
    this.itsTimeskipListener = null;
}

@wrapMethod(PlayerPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
  wrappedMethod(evt);
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(new InterruptCustomTimeSkipEvent());
}
