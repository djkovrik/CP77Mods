import MutedMarkersConfig.*

@addField(GameplayRoleMappinData)
public let m_isShard_MM: Bool;

@addMethod(GameplayRoleComponent)
public func ShouldShowOnMinimap(data: SDeviceMappinData, roleMappinData: ref<GameplayRoleMappinData> ) -> Bool {
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

  if roleMappinData.m_isShard_MM {
    return !MiniMapConfig.HideShards();
  };

  if Equals(data.mappinVariant, gamedataMappinVariant.LootVariant) {
    return true;
  }

  let showOnMiniMap: Bool;

  if Equals(data.mappinVariant, gamedataMappinVariant.Zzz07_PlayerStashVariant) {
    showOnMiniMap = true;
  } else {
    if roleMappinData.m_isQuest || roleMappinData.m_isTagged {
      showOnMiniMap = true;
    } else {
      if roleMappinData.m_isCurrentTarget || roleMappinData.m_visibleThroughWalls || Equals(GetVisibilityTypeFor(data, this), MarkerVisibility.ThroughWalls) {
        showOnMiniMap = true;
      } else {
        showOnMiniMap = false;
      };
    };
  };

  return showOnMiniMap;
}

@addMethod(GameplayRoleComponent)
public func IsOwnerLooted() -> Bool {
  let owner: ref<GameObject> = this.GetOwner();
  let puppet: ref<ScriptedPuppet> = owner as ScriptedPuppet;
  let container: ref<gameLootContainerBase> = this.GetOwner() as gameLootContainerBase;
  if IsDefined(puppet) {
    return puppet.IsLooted();
  };
  if IsDefined(container) {
    return Equals(container.GetLootQuality(), gamedataQuality.Invalid);
  };

  return false;
}

@addMethod(GameplayRoleComponent)
public func EvaluateVisibilities() -> Void {
  let isScannerActive: Bool = this.IsScannerActive_MM();
  let i: Int32 = 0;
  let visibility: MarkerVisibility;

  // Stuck icon fix
  if this.IsOwnerLooted() {
    return ;
  };

  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, IntEnum(0)) || NotEquals(this.m_mappins[i].gameplayRole, IntEnum(1)) {
      visibility = GetVisibilityTypeFor(this.m_mappins[i], this);
      switch(visibility) {
        case MarkerVisibility.ThroughWalls:
          this.ActivateSingleMappin(i);
          break;
        case MarkerVisibility.LineOfSight:
          this.ActivateSingleMappin(i);
          break;
        case MarkerVisibility.Scanner:
          this.ToggleMappin(i, isScannerActive);
          break;
        case MarkerVisibility.Hidden:
          this.DeactivateSingleMappin(i);
          this.m_isForceHidden = true;
          break;
        case MarkerVisibility.Default:
          // do nothing
          break;
      };
    };
    i += 1;
  };
}

@replaceMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let showOnMiniMap: Bool;
  let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
  let showThroughWalls: Bool = Equals(GetVisibilityTypeFor(data, this), MarkerVisibility.ThroughWalls);
  roleMappinData.m_mappinVisualState = this.GetOwner().DeterminGameplayRoleMappinVisuaState(data);
  roleMappinData.m_isTagged = this.GetOwner().IsTaggedinFocusMode();
  roleMappinData.m_isQuest = this.GetOwner().IsQuest() || this.GetOwner().IsAnyClueEnabled() && !this.GetOwner().IsClueInspected();
  roleMappinData.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || showThroughWalls;
  roleMappinData.m_range = this.GetOwner().DeterminGameplayRoleMappinRange(data);
  roleMappinData.m_isCurrentTarget = this.IsCurrentTarget();
  roleMappinData.m_gameplayRole = this.m_currentGameplayRole;
  roleMappinData.m_braindanceLayer = this.GetOwner().GetBraindanceLayer();
  roleMappinData.m_quality = this.GetOwner().GetLootQuality();
  roleMappinData.m_isIconic = this.GetOwner().GetIsIconic();
  roleMappinData.m_hasOffscreenArrow = this.HasOffscreenArrow();
  roleMappinData.m_isScanningCluesBlocked = this.GetOwner().IsAnyClueEnabled() && this.GetOwner().IsScaningCluesBlocked();
  roleMappinData.m_textureID = this.GetIconIdForMappinVariant(data.mappinVariant);
  roleMappinData.m_isShard_MM = Equals(roleMappinData.m_textureID, t"MappinIcons.ShardMappin");
  roleMappinData.m_showOnMiniMap = this.ShouldShowOnMinimap(data, roleMappinData);
  return roleMappinData;
}

// Refresh markers
@wrapMethod(GameplayRoleComponent)
protected cb func OnHUDInstruction(evt: ref<HUDInstruction>) -> Bool {
  wrappedMethod(evt);
  this.EvaluateVisibilities();
}

@wrapMethod(GameplayRoleComponent)
public final func ShowRoleMappins() -> Void {
  wrappedMethod();
  this.EvaluateVisibilities();
}

@wrapMethod(GameplayRoleComponent)
public final func HideRoleMappins() -> Void {
  wrappedMethod();
  this.EvaluateVisibilities();
}
