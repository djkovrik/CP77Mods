import LimitedHudConfig.LHUDAddonsConfig

@addMethod(dialogWidgetGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  let scaleValue: Float = LHUDAddonsConfig.DialogResizerScale();
  this.GetRootWidget().SetScale(new Vector2(scaleValue, scaleValue));
}
