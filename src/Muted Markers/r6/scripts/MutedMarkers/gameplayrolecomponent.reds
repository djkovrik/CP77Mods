import MutedMarkersConfig.*

@addMethod(GameplayRoleComponent)
protected cb func OnEvaluateVisibilitiesEvent(evt: ref<EvaluateVisibilitiesEvent>) -> Bool {
  this.EvaluateVisibilities();
}

@addMethod(GameplayRoleComponent)
public func EvaluateVisibilities() -> Void {
  let isScannerActive: Bool = this.IsScannerActive_MM();
  let i: Int32 = 0;
  let visibility: MarkerVisibility;
  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, IntEnum(0)) || NotEquals(this.m_mappins[i].gameplayRole, IntEnum(1)) {
      visibility = MMUtils.GetVisibilityTypeFor(this.m_mappins[i], this);
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

@wrapMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let result: ref<GameplayRoleMappinData> = wrappedMethod(data);
  let showThroughWalls: Bool = Equals(MMUtils.GetVisibilityTypeFor(data, this), MarkerVisibility.ThroughWalls);
  result.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || showThroughWalls;
  result.isShard_mm = Equals(result.m_textureID, t"MappinIcons.ShardMappin");
  result.m_showOnMiniMap = MMUtils.ShouldShowOnMinimap(data, result, this);
  return result;
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
