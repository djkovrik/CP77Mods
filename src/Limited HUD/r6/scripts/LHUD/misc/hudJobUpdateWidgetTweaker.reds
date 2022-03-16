import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(JournalNotification)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let scale: Float = LHUDAddonsConfig.JournalNotificationScale();
  let opacity: Float = LHUDAddonsConfig.JournalNotificationOpacity();
  this.GetRootWidget().SetScale(new Vector2(scale, scale)); // Scale
  this.GetRootWidget().SetOpacity(opacity);                 // Opacity
}
