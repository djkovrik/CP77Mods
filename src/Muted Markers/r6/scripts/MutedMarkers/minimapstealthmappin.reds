import MutedMarkersConfig.MiniMapConfig

// Hide shards
@wrapMethod(BaseMinimapMappinController)
protected cb func OnUpdate() -> Bool {
  wrappedMethod();
  let config: ref<MiniMapConfig> = new MiniMapConfig();
  let data: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
  if data.isMMShard && config.hideShards {
    this.GetRootWidget().SetVisible(false);
  };
}

// Hide enemies and loot
@replaceMethod(MinimapStealthMappinController)
protected func Update() -> Void {
  let config: ref<MiniMapConfig> = new MiniMapConfig();
  let gameDevice: wref<Device>;
  let hasItems: Bool;
  let isNonHostilePreventionTurret: Bool;
  let isOnSameFloor: Bool;
  let ownerSenseComponent: ref<SenseComponent>;
  let shouldShowMappin: Bool;
  let willStartDetectingPlayer: Bool = false;
  let isInactiveGameDevice: Bool = false;
  let gameObject: wref<GameObject> = this.m_stealthMappin.GetGameObject();
  this.m_isAlive = this.m_stealthMappin.IsAlive();
  let isTagged: Bool = this.m_stealthMappin.IsTagged();
  let hasBeenSeen: Bool = this.m_stealthMappin.HasBeenSeen();
  let isCompanion: Bool = gameObject != null && ScriptedPuppet.IsPlayerCompanion(gameObject);
  let attitude: EAIAttitude = this.m_stealthMappin.GetAttitudeTowardsPlayer();
  let vertRelation: gamemappinsVerticalPositioning = this.GetVerticalRelationToPlayer();
  this.m_highLevelState = this.m_stealthMappin.GetHighLevelState();
  let isHighlighted: Bool = this.m_stealthMappin.IsHighlighted();
  this.m_isSquadInCombat = this.m_stealthMappin.IsSquadInCombat();
  let canSeePlayer: Bool = this.m_stealthMappin.CanSeePlayer();
  this.m_detectionAboveZero = this.m_stealthMappin.GetDetectionProgress() > 0.00;
  let wasDetectionAboveZero: Bool = this.m_stealthMappin.WasDetectionAboveZero();
  let playerDetectionValue: Float = this.m_stealthMappin.GetDetectionProgress();
  let numberOfCombatantsAboveZero: Bool = this.m_stealthMappin.GetNumberOfCombatants() > 0u;
  let isUsingSenseCone: Bool = this.m_stealthMappin.IsUsingSenseCone();
  this.m_isHacking = this.m_stealthMappin.HasHackingStatusEffect();
  let isPlayerInterestingFromSecuritySystemPOV: Bool = this.m_stealthMappin.IsPlayerInterestingFromSecuritySystemPOV();
  let lootToCheck: Uint32;
  if this.m_isDevice {
    this.m_isAggressive = NotEquals(attitude, EAIAttitude.AIA_Friendly);
    if this.m_isAggressive {
      gameDevice = gameObject as Device;
      isInactiveGameDevice = IsDefined(gameDevice) && !gameDevice.GetDevicePS().IsON();
      if this.m_isCamera && numberOfCombatantsAboveZero {
        canSeePlayer = false;
      } else {
        if this.m_isTurret {
          isNonHostilePreventionTurret = NotEquals(attitude, EAIAttitude.AIA_Hostile) && this.m_isPrevention;
          if isInactiveGameDevice || isNonHostilePreventionTurret {
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
    };
  } else {
    if Equals(this.m_highLevelState, gamedataNPCHighLevelState.Relaxed) || Equals(this.m_highLevelState, gamedataNPCHighLevelState.Any) || this.m_isSquadInCombat || !this.m_isAlive {
      this.m_cautious = false;
    };
  };
  if this.m_hasBeenLooted || this.m_stealthMappin.IsHiddenByQuestOnMinimap() {
    shouldShowMappin = false;
  } else {
    if this.m_isPrevention && this.m_policeChasePrototypeEnabled {
      shouldShowMappin = !this.m_isInVehicleStance;
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
  };
  if shouldShowMappin && IsDefined(this.m_preventionMinimapMappinComponent) {
    shouldShowMappin = this.m_preventionMinimapMappinComponent.CanShowMappin(this.GetDistanceToPlayer());
  };
  // Hide enemies
  if config.hideEnemies && this.m_isAlive && NotEquals(attitude, EAIAttitude.AIA_Friendly) {
    shouldShowMappin = false;
  };
  // Hide loot
  if !this.m_isAlive {
    lootToCheck = this.m_stealthMappin.GetHighestLootQuality();
    if (config.hideLegendary && Equals(lootToCheck, 4u))
      || (config.hideEpic && Equals(lootToCheck, 3u))
      || (config.hideRare && Equals(lootToCheck, 2u))
      || (config.hideUncommon && Equals(lootToCheck, 1u))
      || (config.hideCommon && Equals(lootToCheck, 0u)) {
        shouldShowMappin = false;
      };
  };
  this.SetForceHide(!shouldShowMappin);
  if shouldShowMappin {
    if !this.m_isAlive && this.m_stealthMappin.HasLootProcessed() {
      hasItems = this.m_stealthMappin.HasItems();
      if hasItems {
        if this.m_wasAlive {
          if !this.m_isCamera {
            inkImageRef.SetTexturePart(this.iconWidget, n"enemy_icon_4");
            inkWidgetRef.SetScale(this.iconWidget, new Vector2(0.75, 0.75));
          };
          this.m_defaultOpacity = MinF(this.m_defaultOpacity, 0.50);
          this.m_wasAlive = false;
          this.m_lockLootQuality = false;
        };
      } else {
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
    isOnSameFloor = Equals(vertRelation, gamemappinsVerticalPositioning.Same);
    this.m_adjustedOpacity = isOnSameFloor ? this.m_defaultOpacity : 0.30 * this.m_defaultOpacity;
    if !this.m_isAlive || isInactiveGameDevice {
      this.ToggleVisionConeVisibility(false);
    } else {
      if this.m_isPrevention && this.m_stealthMappin.IsPlayerWanted() {
        if playerDetectionValue == 100.00 {
          this.m_wasMaxDetectionReached = true;
        } else {
          if playerDetectionValue < this.m_preventionDetectionDropThreshold {
            this.m_wasMaxDetectionReached = false;
          };
        };
        this.ToggleVisionConeVisibility(!this.m_wasMaxDetectionReached || !(playerDetectionValue > this.m_preventionDetectionDropThreshold));
      } else {
        if numberOfCombatantsAboveZero || !isUsingSenseCone {
          this.ToggleVisionConeVisibility(false);
        } else {
          ownerSenseComponent = gameObject.GetSensesComponent();
          willStartDetectingPlayer = IsDefined(ownerSenseComponent) && ownerSenseComponent.GetShouldStartDetectingPlayerCached() || this.m_isCamera;
          if !willStartDetectingPlayer && gameObject.IsConnectedToSecuritySystem() {
            willStartDetectingPlayer = isPlayerInterestingFromSecuritySystemPOV;
          };
          this.ToggleVisionConeVisibility(willStartDetectingPlayer);
        };
      };
    };
    if !this.m_wasVisible && !this.m_stealthMappin.GetSkipIntroAnim() {
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
  if this.m_stealthMappin.IsPrevention() {
    this.m_mappinState = this.GetPreventionMapinState();
  } else {
    this.m_mappinState = this.GetStateForAttitude(attitude, canSeePlayer);
  };
  this.m_stealthMappin.SetVisibleOnMinimap(shouldShowMappin);
  this.m_clampingAvailable = this.m_isTagged || this.m_isAggressive && (this.m_isSquadInCombat || this.m_detectionAboveZero);
  this.OverrideClamp(this.m_clampingAvailable);
  this.m_wasCompanion = isCompanion;
  this.m_wasSquadInCombat = this.m_isSquadInCombat;
  this.m_wasVisible = shouldShowMappin;
  super.Update();
}