import MutedMarkersConfig.MiniMapConfig

@addMethod(BaseMinimapMappinController)
private func ShouldHideLootQuality(quality: gamedataQuality, config: ref<MiniMapConfig>) -> Bool {
  switch quality {
    case gamedataQuality.Common: return config.hideCommon;
    case gamedataQuality.Uncommon: return config.hideUncommon;
    case gamedataQuality.Rare: return config.hideRare;
    case gamedataQuality.Epic: return config.hideEpic;
    case gamedataQuality.Legendary : return config.hideLegendary;
  };

  return false;
}

@addMethod(BaseMinimapMappinController)
private func GetQualityName(value: Uint32) -> gamedataQuality {
  switch value {
    case 0u: return gamedataQuality.Common;
    case 1u: return gamedataQuality.Uncommon;
    case 2u: return gamedataQuality.Rare;
    case 3u: return gamedataQuality.Epic;
    case 4u: return gamedataQuality.Legendary;
  };
  return gamedataQuality.Invalid;
}

@addMethod(MinimapStealthMappinController)
public func ShouldHideLoot() -> Bool {
  let config: ref<MiniMapConfig> = new MiniMapConfig();
  let highest: Uint32 = this.m_stealthMappin.GetHighestLootQuality();
  let quality: gamedataQuality = this.GetQualityName(highest);

  if NotEquals(quality, gamedataQuality.Invalid) {
    return this.ShouldHideLootQuality(quality, config);
  };

  return false;
}


@addMethod(MinimapStealthMappinController)
public func ShouldHideEnemy() -> Bool {
  let config: ref<MiniMapConfig> = new MiniMapConfig();
  let attitude: EAIAttitude = this.m_stealthMappin.GetAttitudeTowardsPlayer();

  if this.m_isAlive && NotEquals(attitude, EAIAttitude.AIA_Friendly) {
    return config.hideEnemies;
  };

  return false;
}

@wrapMethod(MinimapStealthMappinController)
protected func Update() -> Void {
  wrappedMethod();
  if this.ShouldHideEnemy() { this.GetRootWidget().SetOpacity(0.0); };
  if this.ShouldHideLoot() { this.SetForceHide(true); };
}
