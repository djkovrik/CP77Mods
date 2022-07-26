import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  if config.HideSpeedometer {
    this.GetRootWidget().SetOpacity(0.0);
  };
}
