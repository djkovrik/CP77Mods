import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(JournalNotification)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let scale: Float = config.JournalNotificationScale;
  let opacity: Float = config.JournalNotificationOpacity;
  this.GetRootWidget().SetScale(new Vector2(scale, scale)); // Scale
  this.GetRootWidget().SetOpacity(opacity);                 // Opacity
}
