import MutedMarkersConfig.*


public class MMUtils {

  public static func GetVisibilityTypeFor(const data: script_ref<SDeviceMappinData>, component: ref<GameplayRoleComponent>, loot: ref<LootConfig>, world: ref<WorldConfig>) -> MarkerVisibility {
    let isIconic: Bool = Deref(data).visualStateData.m_isIconic;
    let role: EGameplayRole = Deref(data).gameplayRole;
    let quality: gamedataQuality = Deref(data).visualStateData.m_quality;
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
    if Deref(data).visualStateData.isMMShard {
      return loot.shards;
    };

    // Iconic check
    if isIconic {
      return loot.iconic;
    };

    // Access point check
    if world.hideAccessPoints && Equals(role, EGameplayRole.ControlNetwork) {
      return MarkerVisibility.Hidden;
    };

    // Body container check
    if world.hideBodyContainers && Equals(role, EGameplayRole.HideBody) {
      return MarkerVisibility.Hidden;
    };

    // Camera check
    if world.hideCameras && Equals(role, EGameplayRole.Alarm) {
      return MarkerVisibility.Hidden;
    };

    // Door check
    if world.hideDoors && (Equals(role, EGameplayRole.OpenPath) || Equals(role, EGameplayRole.Push)) {
      return MarkerVisibility.Hidden;
    };

    // Distraction check
    if world.hideDistractions && (Equals(role, EGameplayRole.Distract) || Equals(role, EGameplayRole.Fall)) {
      return MarkerVisibility.Hidden;
    };

    // Explosive check
    if world.hideExplosives && (Equals(role, EGameplayRole.ExplodeLethal) || Equals(role, EGameplayRole.ExplodeNoneLethal)) {
      return MarkerVisibility.Hidden;
    };

    // Networking check
    if world.hideNetworking && (
      Equals(role, EGameplayRole.ControlSelf) || 
      Equals(role, EGameplayRole.GrantInformation) || 
      Equals(role, EGameplayRole.ControlOtherDevice) || 
      Equals(role, EGameplayRole.CutPower) || 
      Equals(role, EGameplayRole.DistractVendingMachine) || 
      Equals(role, EGameplayRole.ClearPath) || 
      Equals(role, EGameplayRole.ClearPathAd)
      ) {
      return MarkerVisibility.Hidden;
    };

    // Ammo check
    if Equals(Deref(data).visualStateData.m_textureID, t"MappinIcons.LootAmmoGenericMappin") {
      return loot.ammo;
    };

    // Quality check
    if Equals(Deref(data).visualStateData.m_textureID, t"MappinIcons.LootMappin") {
      switch(quality) {
        case gamedataQuality.Iconic: return loot.iconic;
        case gamedataQuality.Legendary: return loot.legendary;
        case gamedataQuality.Epic: return loot.epic;
        case gamedataQuality.Rare: return loot.rare;
        case gamedataQuality.Uncommon: return loot.uncommon;
        case gamedataQuality.Common: return loot.common;
      };
    };

    return MarkerVisibility.Default;
  }

  public static func ShouldShowOnMinimap(const data: script_ref<SDeviceMappinData>, roleMappinData: ref<GameplayRoleMappinData>, component: ref<GameplayRoleComponent>, loot: ref<LootConfig>, minimap: ref<MiniMapConfig>, world: ref<WorldConfig>) -> Bool {
    let quality: gamedataQuality = roleMappinData.m_quality;

    if roleMappinData.isMMShard {
      return !minimap.hideShards;
    };

    if Equals(quality, gamedataQuality.Legendary) {
      return !minimap.hideLegendary;
    };

    if Equals(quality, gamedataQuality.Epic) {
      return !minimap.hideEpic;
    };

    if Equals(quality, gamedataQuality.Rare) {
      return !minimap.hideRare;
    };

    if Equals(quality, gamedataQuality.Uncommon) {
      return !minimap.hideUncommon;
    };

    if Equals(quality, gamedataQuality.Common) {
      return !minimap.hideCommon;
    };

    if Equals(Deref(data).mappinVariant, gamedataMappinVariant.LootVariant) {
      return true;
    };

    let showOnMiniMap: Bool;

    if Equals(Deref(data).mappinVariant, gamedataMappinVariant.Zzz07_PlayerStashVariant) {
      showOnMiniMap = true;
    } else {
      if roleMappinData.m_isQuest || roleMappinData.m_isTagged {
        showOnMiniMap = true;
      } else {
        if roleMappinData.m_isCurrentTarget 
          || roleMappinData.m_visibleThroughWalls 
          || Equals(MMUtils.GetVisibilityTypeFor(data, component, loot, world), MarkerVisibility.ThroughWalls)
          || Equals(MMUtils.GetVisibilityTypeFor(data, component, loot, world), MarkerVisibility.ThroughWallsScanner) {
          showOnMiniMap = true;
        } else {
          showOnMiniMap = false;
        };
      };
    };

    return showOnMiniMap;
  }
}

public func PrintMMDump(title: String, data: SDeviceMappinData, source: ref<GameplayRoleComponent>) -> Void {
  MM(title + " " + ToString(data.id) + " / variant: " + ToString(data.mappinVariant) + " / role: " + ToString(data.gameplayRole) + ", enabled: " + ToString(data.enabled)  + ", active: " + ToString(data.active)+ ", range: " + ToString(data.range) + " - visual state data - " + ToString(data.visualStateData.m_mappinVisualState) + ", isQuest: " + ToString(data.visualStateData.m_isQuest) + ", through walls: " + ToString(data.visualStateData.m_visibleThroughWalls) + ", range: " + ToString(data.visualStateData.m_range) + ", duration: " + ToString(data.visualStateData.m_duration) + ", role: " + ToString(data.visualStateData.m_gameplayRole) + ", quality: " + ToString(data.visualStateData.m_quality) + ", is shard: " + ToString(data.visualStateData.isMMShard));
}

public func MM(const str: script_ref<String>) -> Void {
  // LogChannel(n"DEBUG", s"Markers: \(str)");
}
