// Time dilation stuff

@addMethod(PlayerPuppet)
public func EnableCustomTimeFastForward() -> Void {
  this.itsTimeSystem.SetTimeDilation(n"customTimeSkip", 500.0);
}

@addMethod(PlayerPuppet)
public func DisableCustomTimeFastForward() -> Void {
  this.itsTimeSystem.UnsetTimeDilation(n"customTimeSkip");
}
