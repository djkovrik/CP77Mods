import MutedMarkersConfig.MiniMapConfig
@replaceMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let showOnMiniMap: Bool;
  let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
  let showThroughWalls: Bool = Equals(GetVisibilityTypeFor(data.visualStateData), MarkerVisibility.ThroughWalls);
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
  if roleMappinData.m_isQuest && roleMappinData.m_textureID != t"MappinIcons.ShardMappin" || roleMappinData.m_isTagged {
    showOnMiniMap = true;
  } else {
    if NotEquals(data.mappinVariant, gamedataMappinVariant.LootVariant) && (roleMappinData.m_isCurrentTarget || roleMappinData.m_visibleThroughWalls) {
      showOnMiniMap = true;
    } else {
      showOnMiniMap = false;
    };
  };
  roleMappinData.m_showOnMiniMap = showOnMiniMap;
  return roleMappinData;
}
