import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  if config.RemoveHealthbarTexts {
    this.GetRootCompoundWidget().GetWidget(n"buffsHolder/healthNumberContainer").SetVisible(false);
  };
}
