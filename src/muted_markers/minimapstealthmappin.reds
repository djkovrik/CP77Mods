import MutedMarkersConfig.MiniMapConfig

@wrapMethod(MinimapStealthMappinController)
protected cb func OnUpdate() -> Bool {
  wrappedMethod();
  // Enemies
  let attitude: EAIAttitude = this.m_stealthMappin.GetAttitudeTowardsPlayer();
  if MiniMapConfig.HideEnemies() && this.m_isAlive && NotEquals(attitude, EAIAttitude.AIA_Friendly) {
    this.GetRootWidget().SetVisible(false);
  };
}
