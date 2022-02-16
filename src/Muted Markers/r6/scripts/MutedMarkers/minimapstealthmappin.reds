import MutedMarkersConfig.MiniMapConfig

// Hide shards
@replaceMethod(BaseMinimapMappinController)
protected cb func OnUpdate() -> Bool {
  this.Update();
  let data: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
  if data.m_isShard_MM && MiniMapConfig.HideShards() {
    this.GetRootWidget().SetVisible(false);
  };
}

// Hide enemies and loot
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
  this.m_isHacking = this.m_stealthMappin.HasHackingStatusEffect();
  let lootToCheck: Uint32;
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
  // Hide enemies
  if MiniMapConfig.HideEnemies() && this.m_isAlive && NotEquals(attitude, EAIAttitude.AIA_Friendly) {
    shouldShowMappin = false;
  };
  // Hide loot
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
