import MutedMarkersConfig.*

@addField(GameplayRoleComponent) let lootConfig: ref<LootConfig>;
@addField(GameplayRoleComponent) let minimapConfig: ref<MiniMapConfig>;
@addField(GameplayRoleComponent) let worldConfig: ref<WorldConfig>;

@addMethod(GameplayRoleComponent)
protected cb func OnEvaluateVisibilitiesEvent(evt: ref<EvaluateVisibilitiesEvent>) -> Bool {
  this.EvaluateVisibilityMM();
}

@wrapMethod(GameplayRoleComponent)
protected cb func OnPostInitialize(evt: ref<entPostInitializeEvent>) -> Bool {
  this.lootConfig = new LootConfig();
  this.minimapConfig = new MiniMapConfig();
  this.worldConfig = new WorldConfig();
  wrappedMethod(evt);
}

@addMethod(GameplayRoleComponent)
public func EvaluateVisibilityMM() -> Void {
  let i: Int32 = 0;
  let visibility: MarkerVisibility;
  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, IntEnum(0)) || NotEquals(this.m_mappins[i].gameplayRole, IntEnum(1)) {
      visibility = MMUtils.GetVisibilityTypeFor(this.m_mappins[i], this, this.lootConfig, this.worldConfig);
      switch(visibility) {
        case MarkerVisibility.ThroughWallsScanner:
          this.ToggleMappin(i, this.isScannerActive);
          break;
        case MarkerVisibility.ThroughWalls:
          this.ActivateSingleMappin(i);
          break;
        case MarkerVisibility.LineOfSight:
          this.ActivateSingleMappin(i);
          break;
        case MarkerVisibility.Scanner:
          this.ToggleMappin(i, this.isScannerActive);
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
private final func CreateRoleMappinData(const data: script_ref<SDeviceMappinData>) -> ref<GameplayRoleMappinData> {
  let result: ref<GameplayRoleMappinData> = wrappedMethod(data);
  let showForThroughWallsNormal: Bool = Equals(MMUtils.GetVisibilityTypeFor(data, this, this.lootConfig, this.worldConfig), MarkerVisibility.ThroughWalls);
  let showForThroughWallsScanner: Bool = this.isScannerActive && Equals(MMUtils.GetVisibilityTypeFor(data, this, this.lootConfig, this.worldConfig), MarkerVisibility.ThroughWallsScanner);
  let showThroughWalls: Bool = showForThroughWallsNormal || showForThroughWallsScanner;
  result.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || showThroughWalls;
  result.isMMShard = Equals(result.m_textureID, t"MappinIcons.ShardMappin");
  result.m_showOnMiniMap = MMUtils.ShouldShowOnMinimap(data, result, this, this.lootConfig, this.minimapConfig, this.worldConfig);
  return result;
}

// Refresh markers
@addMethod(GameplayRoleComponent)
private func IsLootOrShardMM() -> Bool {
  let isLootOrShard: Bool = false;
  let j: Int32 = 0;
  while j < ArraySize(this.m_mappins) {
    PrintMMDump("Checking", this.m_mappins[j], this);
    if Equals(this.m_mappins[j].gameplayRole, EGameplayRole.Loot) || Equals(this.m_mappins[j].mappinVariant, gamedataMappinVariant.LootVariant ) || this.m_mappins[j].visualStateData.isMMShard {
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
