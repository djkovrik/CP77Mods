
import MutedMarkersConfig.LootConfig
import MutedMarkersConfig.WorldConfig

public static func GetVisibilityTypeFor(data: SDeviceMappinData, owner: ref<GameplayRoleComponent>) -> MarkerVisibility {
  let isIconic: Bool = data.visualStateData.m_isIconic;
  let role: EGameplayRole = data.gameplayRole;
  let quality: gamedataQuality = data.visualStateData.m_quality;

  // Shard check
  if data.visualStateData.m_isShard_MM {
    return LootConfig.Shards();
  }

  // Iconic check
  if isIconic {
    return LootConfig.Iconic();
  }

  // Access point check
  if WorldConfig.HideAccessPoints() && Equals(role, EGameplayRole.ControlNetwork) {
    return MarkerVisibility.Hidden;
  }

  // Body container check
  if WorldConfig.HideBodyContainers() && Equals(role, EGameplayRole.HideBody) {
    return MarkerVisibility.Hidden;
  }

  // Camera check
  if WorldConfig.HideCameras() && Equals(role, EGameplayRole.Alarm) {
    return MarkerVisibility.Hidden;
  }

  // Door check
  if WorldConfig.HideDoors() && Equals(role, EGameplayRole.OpenPath) {
    return MarkerVisibility.Hidden;
  }

  // Distraction check
  if WorldConfig.HideDistractions() && (Equals(role, EGameplayRole.Distract) || Equals(role, EGameplayRole.Fall)) {
    return MarkerVisibility.Hidden;
  }

  // Explosive check
  if WorldConfig.HideExplosives() && (Equals(role, EGameplayRole.ExplodeLethal) || Equals(role, EGameplayRole.ExplodeNoneLethal)) {
    return MarkerVisibility.Hidden;
  }

  // Networking check
  if WorldConfig.HideNetworking() && (Equals(role, EGameplayRole.ControlSelf) || Equals(role, EGameplayRole.GrantInformation)) {
    return MarkerVisibility.Hidden;
  }

  // Quality check
  if Equals(data.visualStateData.m_textureID, t"MappinIcons.LootMappin") {
    switch(quality) {
      case gamedataQuality.Iconic: return LootConfig.Iconic();
      case gamedataQuality.Legendary: return LootConfig.Legendary();
      case gamedataQuality.Epic: return LootConfig.Epic();
      case gamedataQuality.Rare: return LootConfig.Rare();
      case gamedataQuality.Uncommon: return LootConfig.Uncommon();
      case gamedataQuality.Common: return LootConfig.Common();
    };
  };

  return MarkerVisibility.Default;
}

public static func MM(const str: script_ref<String>) -> Void {
  LogChannel(n"DEBUG", str);
}

public static func PrintDump(title: String, data: SDeviceMappinData, source: ref<GameplayRoleComponent>) -> Void {
  MM(title + " " + ToString(data.id) + " / variant: " + ToString(data.mappinVariant) + " / role: " + ToString(data.gameplayRole) + ", enabled: " + ToString(data.enabled)  + ", active: " + ToString(data.active)+ ", range: " + ToString(data.range) + " - visual state data - " + ToString(data.visualStateData.m_mappinVisualState) + ", isQuest: " + ToString(data.visualStateData.m_isQuest) + ", through walls: " + ToString(data.visualStateData.m_visibleThroughWalls) + ", range: " + ToString(data.visualStateData.m_range) + ", duration: " + ToString(data.visualStateData.m_duration) + ", role: " + ToString(data.visualStateData.m_gameplayRole) + ", quality: " + ToString(data.visualStateData.m_quality) + ", is shard: " + ToString(data.visualStateData.m_isShard_MM) + ", owner looted: " + ToString(source.IsOwnerLooted()));
}
