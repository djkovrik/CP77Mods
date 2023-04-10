import MutedMarkersConfig.*

@wrapMethod(GameplayRoleComponent)
protected cb func OnPostInitialize(evt: ref<entPostInitializeEvent>) -> Bool {
  wrappedMethod(evt);
  this.checker = new MutedMarkersVisibilityChecker();
  this.checker.Init(this);
}

@wrapMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let roleMappinData: ref<GameplayRoleMappinData> = wrappedMethod(data);
  let showThroughWalls: Bool = Equals(this.checker.GetVisibility(data), MutedMarkerVisibility.ThroughWalls) || roleMappinData.m_visibleThroughWalls;
  let showOnMinimap: Bool = this.checker.ShouldShowOnMinimap(data, roleMappinData) || roleMappinData.m_showOnMiniMap;
  roleMappinData.m_visibleThroughWalls = showThroughWalls;
  roleMappinData.m_showOnMiniMap = showOnMinimap;
  roleMappinData.isMMShard = Equals(roleMappinData.m_textureID, t"MappinIcons.ShardMappin");
  return roleMappinData;
}

@addMethod(GameplayRoleComponent)
private func ShouldControlWithMM() -> Bool {
  for pin in this.m_mappins {
    if Equals(pin.gameplayRole, EGameplayRole.Loot) || Equals(pin.mappinVariant, gamedataMappinVariant.LootVariant ) || pin.visualStateData.isMMShard {
      return true;
    };
  };

  return false;
}

@addMethod(GameplayRoleComponent)
public func EvaluateVisibilityMM() -> Void {
  let visibility: MutedMarkerVisibility;
  let pin: SDeviceMappinData;
  let i: Int32 = 0;
  while i < ArraySize(this.m_mappins) {
    pin = this.m_mappins[i];
    if NotEquals(pin.gameplayRole, EGameplayRole.None) || NotEquals(pin.gameplayRole, EGameplayRole.UnAssigned) {
      visibility = this.checker.GetVisibility(pin);
      switch(visibility) {
        case MutedMarkerVisibility.ThroughWalls:
          this.ActivateSingleMappin(i);
          break;
        case MutedMarkerVisibility.LineOfSight:
          this.ActivateSingleMappin(i);
          break;
        case MutedMarkerVisibility.Scanner:
          this.ToggleMappin(i, this.isScannerActive);
          break;
        case MutedMarkerVisibility.Hidden:
          this.DeactivateSingleMappin(i);
          this.m_isForceHidden = true;
          break;
        case MutedMarkerVisibility.Default:
          // do nothing
          break;
      };
    };
    i += 1;
  };
}

@addMethod(GameplayRoleComponent)
protected cb func OnEvaluateVisibilitiesEvent(evt: ref<EvaluateVisibilitiesEvent>) -> Bool {
  this.EvaluateVisibilityMM();
}

@wrapMethod(GameplayRoleComponent)
protected cb func OnHUDInstruction(evt: ref<HUDInstruction>) -> Bool {
  wrappedMethod(evt);
  this.EvaluateVisibilityMM();
}

@wrapMethod(GameplayRoleComponent)
protected func HideRoleMappinsByTask() -> Void {
  if this.ShouldControlWithMM() {
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
