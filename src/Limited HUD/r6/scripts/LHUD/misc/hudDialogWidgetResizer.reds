import LimitedHudConfig.LHUDAddonsConfig

@addMethod(dialogWidgetGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let scaleValue: Float = config.DialogResizerScale;
  this.GetRootWidget().SetScale(new Vector2(scaleValue, scaleValue));
}
