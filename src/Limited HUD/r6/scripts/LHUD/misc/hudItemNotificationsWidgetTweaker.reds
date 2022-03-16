import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(ItemsNotificationQueue)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let scale: Float = LHUDAddonsConfig.ItemNotificationScale();
  let opacity: Float = LHUDAddonsConfig.ItemNotificationOpacity();
  this.GetRootWidget().SetScale(new Vector2(scale, scale)); // Scale
  this.GetRootWidget().SetOpacity(opacity);                 // Opacity
}
