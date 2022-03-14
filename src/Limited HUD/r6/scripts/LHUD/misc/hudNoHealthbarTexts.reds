import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if LHUDAddonsConfig.RemoveHealthbarTexts() {
    this.GetRootCompoundWidget().GetWidget(n"buffsHolder/healthNumberContainer").SetVisible(false);
  };
}
