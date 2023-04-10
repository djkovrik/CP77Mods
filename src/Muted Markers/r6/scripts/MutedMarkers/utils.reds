import MutedMarkersConfig.*

public class MutedMarkersVisibilityChecker {
  private let component: wref<GameplayRoleComponent>;
  private let lootConfig: ref<LootConfig>;
  private let minimapConfig: ref<MiniMapConfig>;
  private let worldConfig: ref<WorldConfig>;

  public func Init(component: ref<GameplayRoleComponent>) -> Void {
    this.component = component;
    this.lootConfig = new LootConfig();
    this.minimapConfig = new MiniMapConfig();
    this.worldConfig = new WorldConfig();
  }

  public func GetVisibility(data: SDeviceMappinData) -> MutedMarkerVisibility {
    let isIconic: Bool = data.visualStateData.m_isIconic;
    let role: EGameplayRole = data.gameplayRole;
    let quality: gamedataQuality = data.visualStateData.m_quality;
    let puppet: ref<ScriptedPuppet> = this.component.GetOwner() as ScriptedPuppet;
    let container: ref<gameLootContainerBase> = this.component.GetOwner() as gameLootContainerBase;
    let notReady: Bool = false;

    // Check if puppet & looted
    if IsDefined(puppet) && puppet.IsLooted() {
      notReady = true;
    };

    // Check if container & looted
    if IsDefined(container) && (container.IsEmpty() || !container.IsLogicReady() ) {
      notReady = true;
    };

    if notReady {
      return MutedMarkerVisibility.Hidden;
    };

    // Shard check
    if data.visualStateData.isMMShard {
      return this.lootConfig.shards;
    };

    // Iconic check
    if isIconic {
      return this.lootConfig.iconic;
    };

    // Access point check
    if this.worldConfig.hideAccessPoints && Equals(role, EGameplayRole.ControlNetwork) {
      return MutedMarkerVisibility.Hidden;
    };

    // Body container check
    if this.worldConfig.hideBodyContainers && Equals(role, EGameplayRole.HideBody) {
      return MutedMarkerVisibility.Hidden;
    };

    // Camera check
    if this.worldConfig.hideCameras && Equals(role, EGameplayRole.Alarm) {
      return MutedMarkerVisibility.Hidden;
    };

    // Door check
    if this.worldConfig.hideDoors && Equals(role, EGameplayRole.OpenPath) {
      return MutedMarkerVisibility.Hidden;
    };

    // Distraction check
    if this.worldConfig.hideDistractions && (Equals(role, EGameplayRole.Distract) || Equals(role, EGameplayRole.Fall)) {
      return MutedMarkerVisibility.Hidden;
    };

    // Explosive check
    if this.worldConfig.hideExplosives && (Equals(role, EGameplayRole.ExplodeLethal) || Equals(role, EGameplayRole.ExplodeNoneLethal)) {
      return MutedMarkerVisibility.Hidden;
    };

    // Networking check
    if this.worldConfig.hideNetworking && (Equals(role, EGameplayRole.ControlSelf) || Equals(role, EGameplayRole.GrantInformation)) {
      return MutedMarkerVisibility.Hidden;
    };

    // Quality check
    if Equals(data.visualStateData.m_textureID, t"MappinIcons.LootMappin") {
      switch(quality) {
        case gamedataQuality.Iconic: return this.lootConfig.iconic;
        case gamedataQuality.Legendary: return this.lootConfig.legendary;
        case gamedataQuality.Epic: return this.lootConfig.epic;
        case gamedataQuality.Rare: return this.lootConfig.rare;
        case gamedataQuality.Uncommon: return this.lootConfig.uncommon;
        case gamedataQuality.Common: return this.lootConfig.common;
      };
    };

    return MutedMarkerVisibility.Default;
  }

  public func ShouldShowOnMinimap(data: SDeviceMappinData, roleMappinData: ref<GameplayRoleMappinData>) -> Bool {
    let quality: gamedataQuality = roleMappinData.m_quality;

    if roleMappinData.isMMShard {
      return !this.minimapConfig.hideShards;
    };

    if Equals(quality, gamedataQuality.Legendary) {
      return !this.minimapConfig.hideLegendary;
    };

    if Equals(quality, gamedataQuality.Epic) {
      return !this.minimapConfig.hideEpic;
    };

    if Equals(quality, gamedataQuality.Rare) {
      return !this.minimapConfig.hideRare;
    };

    if Equals(quality, gamedataQuality.Uncommon) {
      return !this.minimapConfig.hideUncommon;
    };

    if Equals(quality, gamedataQuality.Common) {
      return !this.minimapConfig.hideCommon;
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
        if roleMappinData.m_isCurrentTarget || roleMappinData.m_visibleThroughWalls || Equals(this.GetVisibility(data), MutedMarkerVisibility.ThroughWalls) {
          showOnMiniMap = true;
        } else {
          showOnMiniMap = false;
        };
      };
    };

    return showOnMiniMap;
  }
}

public static func PrintDump(title: String, data: SDeviceMappinData, source: ref<GameplayRoleComponent>) -> Void {
  MM(title + " " + ToString(data.id) + " / variant: " + ToString(data.mappinVariant) + " / role: " + ToString(data.gameplayRole) + ", enabled: " + ToString(data.enabled)  + ", active: " + ToString(data.active)+ ", range: " + ToString(data.range) + " - visual state data - " + ToString(data.visualStateData.m_mappinVisualState) + ", isQuest: " + ToString(data.visualStateData.m_isQuest) + ", through walls: " + ToString(data.visualStateData.m_visibleThroughWalls) + ", range: " + ToString(data.visualStateData.m_range) + ", duration: " + ToString(data.visualStateData.m_duration) + ", role: " + ToString(data.visualStateData.m_gameplayRole) + ", quality: " + ToString(data.visualStateData.m_quality) + ", is shard: " + ToString(data.visualStateData.isMMShard));
}

public static func MM(const str: script_ref<String>) -> Void {
  // LogChannel(n"DEBUG", s"Markers: \(str)");
}
