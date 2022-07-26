import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(ItemsNotificationQueue)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let scale: Float = config.ItemNotificationScale;
  let opacity: Float = config.ItemNotificationOpacity;
  this.GetRootWidget().SetScale(new Vector2(scale, scale)); // Scale
  this.GetRootWidget().SetOpacity(opacity);                 // Opacity
}
