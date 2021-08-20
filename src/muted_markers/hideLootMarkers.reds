enum MarkerVisibility { ThroughWalls = 0, LineOfSight = 1, Scanner = 2, Hidden = 3, Default = 4 }

// Visibility types:
//   * MarkerVisibility.ThroughWalls - visible through walls
//   * MarkerVisibility.LineOfSight - visible when V sees it (very similar to default in-game behavior)
//   * MarkerVisibility.Scanner - visible only when scanner is active 
//   * MarkerVisibility.Hidden - not visible at all
//   * MarkerVisibility.Default - means do not change default game behavior, this variant was added 
//     just for scripting convenience so in most cases you probably want to use LineOfSight

// -- CONFIG SECTION STARTS HERE --
class LootConfig {
  // Visibility for Iconic items
  public static func Iconic() -> MarkerVisibility = MarkerVisibility.ThroughWalls
  // Visibility for Legendary items (gold)
  public static func Legendary() -> MarkerVisibility = MarkerVisibility.ThroughWalls
  // Visibility for Epic items (purple)
  public static func Epic() -> MarkerVisibility = MarkerVisibility.LineOfSight
  // Visibility for Rate items (blue)
  public static func Rare() -> MarkerVisibility = MarkerVisibility.Scanner
  // Visibility for Uncommon items (green)
  public static func Uncommon() -> MarkerVisibility = MarkerVisibility.Scanner
  // Visibility for Common items (white)
  public static func Common() -> MarkerVisibility = MarkerVisibility.Hidden
  // Visibility for Shards
  public static func Shards() -> MarkerVisibility = MarkerVisibility.LineOfSight
}

class WorldConfig {
  // Replace false with true if you want to hide icons for access points
  public static func HideAccessPoints() -> Bool = false
  // Replace false with true if you want to hide icons for containers where you can hide bodies
  public static func HideBodyContainers() -> Bool = false
  // Replace false with true if you want to hide icons for cameras
  public static func HideCameras() -> Bool = false
  // Replace false with true if you want to hide icons for doors
  public static func HideDoors() -> Bool = false
  // Replace false with true if you want to hide icons for distraction objects
  public static func HideDistractions() -> Bool = false
  // Replace false with true if you want to hide icons for explosive objects
  public static func HideExplosives() -> Bool = false
  // Replace false with true if you want to hide icons for misc network devices (computers, smart screens etc.)
  public static func HideNetworking() -> Bool = false
}

class MiniMapConfig {
  // Replace false with true for loot quality markers which you want to hide from minimap
  public static func HideLegendary() -> Bool = false
  public static func HideEpic() -> Bool = false
  public static func HideRare() -> Bool = false
  public static func HideUncommon() -> Bool = false
  public static func HideCommon() -> Bool = false
  // Replace false with true if you want to hide enemies on minimap
  public static func HideEnemies() -> Bool = false
  // Replace false with true if you want to hide shards on minimap
  public static func HideShards() -> Bool = false
}
// -- CONFIG SECTION ENDS HERE --


public static func GetVisibilityTypeFor(data: SDeviceMappinData) -> MarkerVisibility {
  let isShard: Bool = Equals(data.visualStateData.m_textureID, t"MappinIcons.ShardMappin");
  let isIconic: Bool = data.visualStateData.m_isIconic;
  let role: EGameplayRole = data.gameplayRole;
  let quality: gamedataQuality = data.visualStateData.m_quality;

  // Shard check
  if isShard {
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

// -- Adds
@addMethod(HUDManager)
public func IsScannerActive() -> Bool {
  return Equals(this.m_activeMode, ActiveMode.FOCUS);
}

@addField(GameplayRoleComponent)
let m_hudManager: ref<HUDManager>;

@addMethod(GameplayRoleComponent)
public func IsScannerActive() -> Bool {
  return this.m_hudManager.IsScannerActive();
}

@addMethod(GameplayRoleComponent)
func EvaluateVisibilities() -> Void {
  let isScannerActive: Bool = this.IsScannerActive();
  let i: Int32 = 0;
  let visibility: MarkerVisibility;

  while i < ArraySize(this.m_mappins) {
    if NotEquals(this.m_mappins[i].gameplayRole, IntEnum(0)) || NotEquals(this.m_mappins[i].gameplayRole, IntEnum(1)) {
      visibility = GetVisibilityTypeFor(this.m_mappins[i]);

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
          break;
        case MarkerVisibility.Default:
          // do nothing
          break;
      };
    };
    i += 1;
  };
}

// -- Overrides
@wrapMethod(GameplayRoleComponent)
protected cb func OnPostInitialize(evt: ref<entPostInitializeEvent>) -> Bool {
  wrappedMethod(evt);
  this.m_hudManager = (GameInstance.GetScriptableSystemsContainer(this.GetOwner().GetGame()).Get(n"HUDManager") as HUDManager);
}

@wrapMethod(GameplayRoleComponent)
protected cb func OnHUDInstruction(evt: ref<HUDInstruction>) -> Bool {
  wrappedMethod(evt);
  this.EvaluateVisibilities();
}

@replaceMethod(GameplayRoleComponent)
private final func CreateRoleMappinData(data: SDeviceMappinData) -> ref<GameplayRoleMappinData> {
  let roleMappinData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
  roleMappinData.m_mappinVisualState = this.GetOwner().DeterminGameplayRoleMappinVisuaState(data);
  roleMappinData.m_isTagged = this.GetOwner().IsTaggedinFocusMode();
  roleMappinData.m_isQuest = this.GetOwner().IsQuest() || this.GetOwner().IsAnyClueEnabled() && !this.GetOwner().IsClueInspected();
  roleMappinData.m_visibleThroughWalls = this.m_isForcedVisibleThroughWalls || this.GetOwner().IsObjectRevealed() || this.IsCurrentTarget() || Equals(GetVisibilityTypeFor(data), MarkerVisibility.ThroughWalls);
  roleMappinData.m_range = this.GetOwner().DeterminGameplayRoleMappinRange(data);
  roleMappinData.m_isCurrentTarget = this.IsCurrentTarget();
  roleMappinData.m_gameplayRole = this.m_currentGameplayRole;
  roleMappinData.m_braindanceLayer = this.GetOwner().GetBraindanceLayer();
  roleMappinData.m_quality = this.GetOwner().GetLootQuality();
  roleMappinData.m_isIconic = this.GetOwner().GetIsIconic();
  roleMappinData.m_hasOffscreenArrow = this.HasOffscreenArrow();
  roleMappinData.m_isScanningCluesBlocked = this.GetOwner().IsAnyClueEnabled() && this.GetOwner().IsScaningCluesBlocked();
  roleMappinData.m_textureID = this.GetIconIdForMappinVariant(data.mappinVariant);
  roleMappinData.m_showOnMiniMap = this.ShouldShowOnMinimap(data, roleMappinData);
  return roleMappinData;
}

@addMethod(GameplayRoleComponent)
private final func ShouldShowOnMinimap(data: SDeviceMappinData, roleMappinData: ref<GameplayRoleMappinData> ) -> Bool {
  let quality: gamedataQuality = roleMappinData.m_quality;

  if MiniMapConfig.HideLegendary() && Equals(quality, gamedataQuality.Legendary) {
    return false;
  };

  if MiniMapConfig.HideEpic() && Equals(quality, gamedataQuality.Epic) {
    return false;
  };

  if MiniMapConfig.HideRare() && Equals(quality, gamedataQuality.Rare) {
    return false;
  };

  if MiniMapConfig.HideUncommon() && Equals(quality, gamedataQuality.Uncommon) {
    return false;
  };

  if MiniMapConfig.HideCommon() && Equals(quality, gamedataQuality.Common) {
    return false;
  };

  if MiniMapConfig.HideShards() && Equals(roleMappinData.m_textureID, t"MappinIcons.ShardMappin") {
    return false;
  };

  if Equals(data.mappinVariant, gamedataMappinVariant.LootVariant) {
    return true;
  }

  let showOnMiniMap: Bool;

  if roleMappinData.m_isQuest && roleMappinData.m_textureID != t"MappinIcons.ShardMappin" || roleMappinData.m_isTagged {
    showOnMiniMap = true;
  } else {
    if roleMappinData.m_isCurrentTarget || roleMappinData.m_visibleThroughWalls || Equals(GetVisibilityTypeFor(data), MarkerVisibility.ThroughWalls) {
      showOnMiniMap = true;
    } else {
      showOnMiniMap = false;
    };
  };

  return showOnMiniMap;
}

@replaceMethod(MinimapStealthMappinController)
protected func Update() -> Void {
  let gameDevice: wref<Device>;
  let hasItems: Bool;
  let isOnSameFloor: Bool;
  let shouldShowMappin: Bool;
  let shouldShowVisionCone: Bool;
  let gameObject: wref<GameObject> = this.m_stealthMappin.GetGameObject();
  this.m_isAlive = this.m_stealthMappin.IsAlive();
  let isTagged: Bool = this.m_stealthMappin.IsTagged();
  let hasBeenSeen: Bool = this.m_stealthMappin.HasBeenSeen();
  let isCompanion: Bool = gameObject != null && ScriptedPuppet.IsPlayerCompanion(gameObject);
  let attitude: EAIAttitude = this.m_stealthMappin.GetAttitudeTowardsPlayer();
  let vertRelation: gamemappinsVerticalPositioning = this.GetVerticalRelationToPlayer();
  let shotAttempts: Uint32 = this.m_stealthMappin.GetNumberOfShotAttempts();
  this.m_highLevelState = this.m_stealthMappin.GetHighLevelState();
  let isHighlighted: Bool = this.m_stealthMappin.IsHighlighted();
  this.m_isSquadInCombat = this.m_stealthMappin.IsSquadInCombat();
  let canSeePlayer: Bool = this.m_stealthMappin.CanSeePlayer();
  this.m_detectionAboveZero = this.m_stealthMappin.GetDetectionProgress() > 0.00;
  let wasDetectionAboveZero: Bool = this.m_stealthMappin.WasDetectionAboveZero();
  let numberOfCombatantsAboveZero: Bool = this.m_stealthMappin.GetNumberOfCombatants() > 0u;
  let isUsingSenseCone: Bool = this.m_stealthMappin.IsUsingSenseCone();
  let lootToCheck: Uint32;
  this.m_isHacking = this.m_stealthMappin.HasHackingStatusEffect();
  if this.m_isDevice {
    this.m_isAggressive = NotEquals(attitude, EAIAttitude.AIA_Friendly);
    if this.m_isAggressive {
      gameDevice = gameObject as Device;
      if IsDefined(gameDevice) {
        isUsingSenseCone = gameDevice.GetDevicePS().IsON();
      };
      if this.m_isCamera && numberOfCombatantsAboveZero {
        canSeePlayer = false;
        isUsingSenseCone = false;
      } else {
        if this.m_isTurret {
          isUsingSenseCone = isUsingSenseCone && (Equals(attitude, EAIAttitude.AIA_Hostile) || !this.m_isPrevention);
          if !isUsingSenseCone {
            this.m_isSquadInCombat = false;
          };
        };
      };
      if Equals(this.m_stealthMappin.GetStealthAwarenessState(), gameEnemyStealthAwarenessState.Combat) {
        this.m_isSquadInCombat = true;
      };
    };
  } else {
    this.m_isAggressive = this.m_stealthMappin.IsAggressive() && NotEquals(attitude, EAIAttitude.AIA_Friendly);
  };
  if !this.m_cautious {
    if !this.m_isDevice && NotEquals(this.m_highLevelState, gamedataNPCHighLevelState.Relaxed) && NotEquals(this.m_highLevelState, gamedataNPCHighLevelState.Any) && !this.m_isSquadInCombat && this.m_isAlive && this.m_isAggressive {
      this.m_cautious = true;
      this.PulseContinuous(true);
    };
  } else {
    if Equals(this.m_highLevelState, gamedataNPCHighLevelState.Relaxed) || Equals(this.m_highLevelState, gamedataNPCHighLevelState.Any) || this.m_isSquadInCombat || !this.m_isAlive {
      this.m_cautious = false;
      this.PulseContinuous(false);
    };
  };
  if this.m_hasBeenLooted || this.m_stealthMappin.IsHiddenByQuestOnMinimap() {
    shouldShowMappin = false;
  } else {
    if this.m_isDevice && !this.m_isAggressive {
      shouldShowMappin = false;
    } else {
      if !IsMultiplayer() {
        shouldShowMappin = hasBeenSeen || !this.m_isAlive || isCompanion || wasDetectionAboveZero || isHighlighted || isTagged;
      } else {
        shouldShowMappin = (isCompanion || wasDetectionAboveZero || isHighlighted) && this.m_isAlive;
      };
    };
  };
  // Hide enemies
  if MiniMapConfig.HideEnemies() && this.m_isAlive && NotEquals(attitude, EAIAttitude.AIA_Friendly) {
    shouldShowMappin = false;
  };
  // Loot checks
  if !this.m_isAlive {
    lootToCheck = this.m_stealthMappin.GetHighestLootQuality();
    if (MiniMapConfig.HideLegendary() && Equals(lootToCheck, 4u))
      || (MiniMapConfig.HideEpic() && Equals(lootToCheck, 3u))
      || (MiniMapConfig.HideRare() && Equals(lootToCheck, 2u))
      || (MiniMapConfig.HideUncommon() && Equals(lootToCheck, 1u))
      || (MiniMapConfig.HideCommon() && Equals(lootToCheck, 0u)) {
        shouldShowMappin = false;
      };
  };
  this.SetForceHide(!shouldShowMappin);
  if shouldShowMappin {
    if !this.m_isAlive {
      if this.m_wasAlive {
        if !this.m_isCamera {
          inkImageRef.SetTexturePart(this.iconWidget, n"enemy_icon_4");
          inkWidgetRef.SetScale(this.iconWidget, new Vector2(0.75, 0.75));
        };
        this.m_defaultOpacity = MinF(this.m_defaultOpacity, 0.50);
        this.m_wasAlive = false;
      };
      hasItems = this.m_stealthMappin.HasItems();
      if !hasItems || this.m_isDevice {
        this.FadeOut();
      };
    } else {
      if isCompanion && !this.m_wasCompanion {
        inkImageRef.SetTexturePart(this.iconWidget, n"friendly_ally15");
      } else {
        if NotEquals(this.m_isTagged, isTagged) && !this.m_isCamera {
          if isTagged {
            inkImageRef.SetTexturePart(this.iconWidget, n"enemyMappinTagged");
          } else {
            inkImageRef.SetTexturePart(this.iconWidget, n"enemyMappin");
          };
        };
      };
    };
    this.m_isTagged = isTagged;
    if this.m_isSquadInCombat && !this.m_wasSquadInCombat || this.m_numberOfShotAttempts != shotAttempts {
      this.m_numberOfShotAttempts = shotAttempts;
      this.Pulse(2);
    };
    isOnSameFloor = Equals(vertRelation, gamemappinsVerticalPositioning.Same);
    this.m_adjustedOpacity = isOnSameFloor ? this.m_defaultOpacity : 0.30 * this.m_defaultOpacity;
    shouldShowVisionCone = this.m_isAlive && isUsingSenseCone && this.m_isAggressive;
    if NotEquals(this.m_shouldShowVisionCone, shouldShowVisionCone) {
      this.m_shouldShowVisionCone = shouldShowVisionCone;
      this.m_stealthMappin.UpdateSenseConeAvailable(this.m_shouldShowVisionCone);
      if this.m_shouldShowVisionCone {
        this.m_stealthMappin.UpdateSenseCone();
      };
    };
    if this.m_shouldShowVisionCone {
      if NotEquals(canSeePlayer, this.m_couldSeePlayer) || this.m_isSquadInCombat && !this.m_wasSquadInCombat {
        if canSeePlayer && !this.m_isSquadInCombat {
          inkWidgetRef.SetOpacity(this.visionConeWidget, this.m_detectingConeOpacity);
          inkWidgetRef.SetScale(this.visionConeWidget, new Vector2(1.50, 1.50));
        } else {
          inkWidgetRef.SetOpacity(this.visionConeWidget, this.m_defaultConeOpacity);
          inkWidgetRef.SetScale(this.visionConeWidget, new Vector2(1.00, 1.00));
        };
        this.m_couldSeePlayer = canSeePlayer;
      };
    };
    inkWidgetRef.SetVisible(this.visionConeWidget, this.m_shouldShowVisionCone);
    if !this.m_wasVisible {
      if IsDefined(this.m_showAnim) {
        this.m_showAnim.Stop();
      };
      this.m_showAnim = this.PlayLibraryAnimation(n"Show");
    };
  };
  if this.m_isNetrunner {
    if !this.m_isAlive {
      this.m_iconWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", false);
      this.m_visionConeWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", false);
      this.m_clampArrowWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", false);
    } else {
      if this.m_isHacking {
        this.m_iconWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.70);
        this.m_visionConeWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.80);
        this.m_clampArrowWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.20);
      } else {
        this.m_iconWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.05);
        this.m_visionConeWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.05);
        this.m_clampArrowWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.05);
      };
    };
  };
  if !this.m_lockLootQuality {
    this.m_highestLootQuality = this.m_stealthMappin.GetHighestLootQuality();
  };
  this.m_attitudeState = this.GetStateForAttitude(attitude, canSeePlayer);
  this.m_stealthMappin.SetVisibleOnMinimap(shouldShowMappin);
  this.m_stealthMappin.SetIsPulsing(this.m_pulsing);
  this.m_clampingAvailable = this.m_isTagged || this.m_isAggressive && (this.m_isSquadInCombat || this.m_detectionAboveZero);
  this.OverrideClamp(this.m_clampingAvailable);
  this.m_wasCompanion = isCompanion;
  this.m_wasSquadInCombat = this.m_isSquadInCombat;
  this.m_wasVisible = shouldShowMappin;
  super.Update();
}
