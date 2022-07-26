import MutedMarkersConfig.*

@addField(GameplayRoleComponent) let mm_lootConfig: ref<LootConfig>;
@addField(GameplayRoleComponent) let mm_minimapConfig: ref<MiniMapConfig>;
@addField(GameplayRoleComponent) let mm_worldConfig: ref<WorldConfig>;

@addMethod(GameplayRoleComponent)
protected cb func OnEvaluateVisibilitiesEvent(evt: ref<EvaluateVisibilitiesEvent>) -> Bool {
  this.EvaluateVisibilityMM();
}

@wrapMethod(GameplayRoleComponent)
protected cb func OnPostInitialize(evt: ref<entPostInitializeEvent>) -> Bool {
  wrappedMethod(evt);
  this.mm_lootConfig = new LootConfig();
  this.mm_minimapConfig = new MiniMapConfig();
  this.mm_worldConfig = new WorldConfig();
  MM("!!!!!!!!!!");
}

@addMethod(GameplayRoleComponent)
public func EvaluateVisibilityMM() -> Void {
  let i: Int32 = 0;
  let visibility: MarkerVisibility;
  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, IntEnum(0)) || NotEquals(this.m_mappins[i].gameplayRole, IntEnum(1)) {
      visibility = MMUtils.GetVisibilityTypeFor(this.m_mappins[i], this, this.mm_lootConfig, this.mm_worldConfig);
      switch(visibility) {
        case MarkerVisibility.ThroughWalls:
          this.ActivateSingleMappin(i);
          break;
        case MarkerVisibility.LineOfSight:
          this.ActivateSingleMappin(i);
          break;
        case MarkerVisibility.Scanner:
          this.ToggleMappin(i, this.isScannerActive_mm);
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

@wrapMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let result: ref<GameplayRoleMappinData> = wrappedMethod(data);
  let showThroughWalls: Bool = Equals(MMUtils.GetVisibilityTypeFor(data, this, this.mm_lootConfig, this.mm_worldConfig), MarkerVisibility.ThroughWalls);
  result.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || showThroughWalls;
  result.isShard_mm = Equals(result.m_textureID, t"MappinIcons.ShardMappin");
  result.m_showOnMiniMap = MMUtils.ShouldShowOnMinimap(data, result, this, this.mm_lootConfig, this.mm_minimapConfig, this.mm_worldConfig);
  return result;
}

// Refresh markers
@addMethod(GameplayRoleComponent)
private func IsLootOrShardMM() -> Bool {
  let isLootOrShard: Bool = false;
  let j: Int32 = 0;
  while j < ArraySize(this.m_mappins) {
    PrintDump("Checking", this.m_mappins[j], this);
    if Equals(this.m_mappins[j].gameplayRole, EGameplayRole.Loot) || Equals(this.m_mappins[j].mappinVariant, gamedataMappinVariant.LootVariant ) || this.m_mappins[j].visualStateData.isShard_mm {
      isLootOrShard = true;
    };
    j += 1;
  };

  return isLootOrShard;
}

//  Tweak show/hide logic
@wrapMethod(GameplayRoleComponent)
protected cb func OnHUDInstruction(evt: ref<HUDInstruction>) -> Bool {
  wrappedMethod(evt);
  this.EvaluateVisibilityMM();
}

@wrapMethod(GameplayRoleComponent)
protected func HideRoleMappinsByTask() -> Void {
  if this.IsLootOrShardMM() {
    this.EvaluateVisibilityMM();
  } else {
    wrappedMethod();
  };
}

@wrapMethod(GameplayRoleComponent)
public final func ShowRoleMappins() -> Void {
  wrappedMethod();
  this.EvaluateVisibilityMM();
}

@wrapMethod(GameplayRoleComponent)
public final func HideRoleMappins() -> Void {
  wrappedMethod();
  this.EvaluateVisibilityMM();
}
