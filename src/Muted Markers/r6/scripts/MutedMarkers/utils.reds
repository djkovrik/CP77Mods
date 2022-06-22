import MutedMarkersConfig.*


public class MMUtils {

  public static func GetVisibilityTypeFor(data: SDeviceMappinData, component: ref<GameplayRoleComponent>) -> MarkerVisibility {
    let isIconic: Bool = data.visualStateData.m_isIconic;
    let role: EGameplayRole = data.gameplayRole;
    let quality: gamedataQuality = data.visualStateData.m_quality;
    let puppet: ref<ScriptedPuppet> = component.GetOwner() as ScriptedPuppet;
    let container: ref<gameLootContainerBase> = component.GetOwner() as gameLootContainerBase;
    let alreadyLooted: Bool = false;

    // Check if looted
    if IsDefined(puppet) && puppet.IsLooted() {
      alreadyLooted = true;
    };

    if IsDefined(container) && container.IsEmpty() {
      alreadyLooted = true;
    };

    if alreadyLooted {
      return MarkerVisibility.Hidden;
    };

    // Shard check
    if data.visualStateData.isShard_mm {
      return LootConfig.Shards();
    };

    // Iconic check
    if isIconic {
      return LootConfig.Iconic();
    };

    // Access point check
    if WorldConfig.HideAccessPoints() && Equals(role, EGameplayRole.ControlNetwork) {
      return MarkerVisibility.Hidden;
    };

    // Body container check
    if WorldConfig.HideBodyContainers() && Equals(role, EGameplayRole.HideBody) {
      return MarkerVisibility.Hidden;
    };

    // Camera check
    if WorldConfig.HideCameras() && Equals(role, EGameplayRole.Alarm) {
      return MarkerVisibility.Hidden;
    };

    // Door check
    if WorldConfig.HideDoors() && Equals(role, EGameplayRole.OpenPath) {
      return MarkerVisibility.Hidden;
    };

    // Distraction check
    if WorldConfig.HideDistractions() && (Equals(role, EGameplayRole.Distract) || Equals(role, EGameplayRole.Fall)) {
      return MarkerVisibility.Hidden;
    };

    // Explosive check
    if WorldConfig.HideExplosives() && (Equals(role, EGameplayRole.ExplodeLethal) || Equals(role, EGameplayRole.ExplodeNoneLethal)) {
      return MarkerVisibility.Hidden;
    };

    // Networking check
    if WorldConfig.HideNetworking() && (Equals(role, EGameplayRole.ControlSelf) || Equals(role, EGameplayRole.GrantInformation)) {
      return MarkerVisibility.Hidden;
    };

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

  public static func ShouldShowOnMinimap(data: SDeviceMappinData, roleMappinData: ref<GameplayRoleMappinData>, component: ref<GameplayRoleComponent>) -> Bool {
    let quality: gamedataQuality = roleMappinData.m_quality;

    if Equals(quality, gamedataQuality.Legendary) {
      return !MiniMapConfig.HideLegendary();
    };

    if Equals(quality, gamedataQuality.Epic) {
      return !MiniMapConfig.HideEpic();
    };

    if Equals(quality, gamedataQuality.Rare) {
      return !MiniMapConfig.HideRare();
    };

    if Equals(quality, gamedataQuality.Uncommon) {
      return !MiniMapConfig.HideUncommon();
    };

    if Equals(quality, gamedataQuality.Common) {
      return !MiniMapConfig.HideCommon();
    };

    if roleMappinData.isShard_mm {
      return !MiniMapConfig.HideShards();
    };

    if Equals(data.mappinVariant, gamedataMappinVariant.LootVariant) {
      return true;
    };

    let showOnMiniMap: Bool;

    if Equals(data.mappinVariant, gamedataMappinVariant.Zzz07_PlayerStashVariant) {
      showOnMiniMap = true;
    } else {
      if roleMappinData.m_isQuest || roleMappinData.m_isTagged {
        showOnMiniMap = true;
      } else {
        if roleMappinData.m_isCurrentTarget || roleMappinData.m_visibleThroughWalls || Equals(MMUtils.GetVisibilityTypeFor(data, component), MarkerVisibility.ThroughWalls) {
          showOnMiniMap = true;
        } else {
          showOnMiniMap = false;
        };
      };
    };

    return showOnMiniMap;
  }
}

public static func MM(const str: script_ref<String>) -> Void {
  LogChannel(n"DEBUG", s"Markers: \(str)");
}

public static func PrintDump(title: String, data: SDeviceMappinData, source: ref<GameplayRoleComponent>) -> Void {
  MM(title + " " + ToString(data.id) + " / variant: " + ToString(data.mappinVariant) + " / role: " + ToString(data.gameplayRole) + ", enabled: " + ToString(data.enabled)  + ", active: " + ToString(data.active)+ ", range: " + ToString(data.range) + " - visual state data - " + ToString(data.visualStateData.m_mappinVisualState) + ", isQuest: " + ToString(data.visualStateData.m_isQuest) + ", through walls: " + ToString(data.visualStateData.m_visibleThroughWalls) + ", range: " + ToString(data.visualStateData.m_range) + ", duration: " + ToString(data.visualStateData.m_duration) + ", role: " + ToString(data.visualStateData.m_gameplayRole) + ", quality: " + ToString(data.visualStateData.m_quality) + ", is shard: " + ToString(data.visualStateData.isShard_mm));
}