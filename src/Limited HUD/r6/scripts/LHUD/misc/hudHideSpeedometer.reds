import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if LHUDAddonsConfig.HideSpeedometer() {
    this.GetRootWidget().SetOpacity(0.0);
  };
}
