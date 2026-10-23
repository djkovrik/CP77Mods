import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(BaseMappinBaseController)
public final func GetAnimPlayer_Tracked() -> wref<animationPlayer> {
  let wrapped: wref<animationPlayer> = wrappedMethod();
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  return config.RemoveMarkerPulse ? null : wrapped;
}

@wrapMethod(BaseMappinBaseController)
protected func UpdateTrackedState() -> Void {
  wrappedMethod();
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let i: Int32;
  if config.RemoveMarkerPulse {
    i = 0;
    while i < ArraySize(this.m_taggedWidgets) {
      inkWidgetRef.SetVisible(this.m_taggedWidgets[i], false);
      i += 1;
    };
  };
}
