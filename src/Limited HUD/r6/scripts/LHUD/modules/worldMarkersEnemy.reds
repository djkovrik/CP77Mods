import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudListeners.LHUDBlackboardsListener
import LimitedHudCommon.LHUDEvent

// -- Enemy head nameplate icons

@addMethod(StealthMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addField(StealthMappinController)
private let lhudConfig: ref<WorldMarkersModuleConfigCombat>;

@wrapMethod(StealthMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WorldMarkersModuleConfigCombat();
  this.FetchInitialStateFlags();
  this.DetermineCurrentVisibility();
}

@addMethod(StealthMappinController)
public func DetermineCurrentVisibility() -> Void {
  if this.lhudConfig.IsEnabled {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfig.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = isVisible;
  } else {
    this.lhud_isVisibleNow = true;
  };

  this.OnUpdate();
}

// Hiding enemy markers
@replaceMethod(StealthMappinController)
protected cb func OnUpdate() -> Bool {
  let distance: Float;
  let npcRarity: gamedataNPCRarity;
  let ownerPuppet: ref<ScriptedPuppet>;
  let percent: Float;
  let playerPuppet: ref<PlayerPuppet>;
  let shouldShow: Bool;
  let showEliteIndicator: Bool;
  let attitude: EAIAttitude = this.m_mappin.GetAttitudeTowardsPlayer();
  this.m_isFriendly = Equals(attitude, EAIAttitude.AIA_Friendly);
  this.m_isFriendlyFromHack = this.m_mappin.IsFriendlyFromHack();
  this.m_isHostile = Equals(attitude, EAIAttitude.AIA_Hostile);
  this.m_isAggressive = this.m_mappin.IsAggressive();
  this.m_isHiddenByQuest = this.m_mappin.IsHiddenByQuestIn3D();
  this.m_isNCPD = ScriptedPuppet.IsCharacterPolice(this.m_ownerObject);
  if this.ShouldDisableMappin() {
    inkWidgetRef.SetVisible(this.m_mainArt, false);
    inkWidgetRef.SetVisible(this.m_arrow, false);
    if this.m_isFriendlyFromHack && ScriptedPuppet.IsActive(this.m_ownerObject) {
      this.UpdateObjectMarkerAndTagging();
      this.m_root.SetState(n"Friendly");
      this.m_mappin.UpdateCombatantState(false);
      this.m_mappin.SetVisibleIn3D(this.m_objectMarkerVisible);
      this.SetRootVisible(this.m_objectMarkerVisible);
    } else {
      this.UpdateObjectMarkerVisibility(false, false);
      this.m_mappin.SetVisibleIn3D(false);
      this.SetRootVisible(false);
    };
    return true;
  };
  ownerPuppet = this.m_ownerObject as ScriptedPuppet;
  playerPuppet = GameInstance.GetPlayerSystem(this.m_ownerObject.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  percent = this.m_mappin.GetDetectionProgress();
  this.m_canSeePlayer = this.m_mappin.CanSeePlayer();
  this.m_squadInCombat = this.m_mappin.IsSquadInCombat();
  this.m_numberOfCombatants = Cast<Int32>(this.m_mappin.GetNumberOfCombatants());
  this.m_isInCombatWithPlayer = IsDefined(ownerPuppet) && NPCPuppet.IsInCombatWithTarget(ownerPuppet, playerPuppet);
  if this.m_mappin.HideUIDetection() || !this.m_canSeePlayer && NotEquals(this.m_currentAnimState, gameEnemyStealthAwarenessState.Combat) && this.m_numberOfCombatants >= 1 {
    this.m_detectionVisible = false;
  } else {
    this.m_detectionVisible = NotEquals(this.m_currentAnimState, gameEnemyStealthAwarenessState.Relaxed) && NotEquals(this.m_currentAnimState, gameEnemyStealthAwarenessState.Combat) || this.m_animationIsPlaying;
  };
  this.OverrideClamp(this.m_detectionVisible);
  this.UpdateStatusEffectIcon();
  this.UpdateCanvasOpacity();
  npcRarity = ownerPuppet.GetNPCRarity();
  showEliteIndicator = !this.m_statusEffectShowing && !this.m_detectionVisible && (Equals(npcRarity, gamedataNPCRarity.Elite) || Equals(npcRarity, gamedataNPCRarity.MaxTac));
  inkWidgetRef.SetVisible(this.m_levelIcon, showEliteIndicator);
  shouldShow = (this.m_detectionVisible || this.m_statusEffectShowing || this.m_inNameplateMode || this.m_nameplateAnimationIsPlaying) && !this.m_isHiddenByQuest  && this.lhud_isVisibleNow;
  inkWidgetRef.SetVisible(this.m_mainArt, shouldShow);
  if IsDefined(this.m_ownerNPC) {
    this.UpdateNPCDetection(percent);
  } else {
    this.UpdateDeviceDetection(percent);
  };
  this.UpdateObjectMarkerAndTagging();
  this.UpdateDetectionMeter(percent);
  inkWidgetRef.SetVisible(this.m_arrow, this.isCurrentlyClamped && shouldShow);
  if this.ShouldShowDistance() {
    distance = this.GetDistanceToPlayer();
    inkTextRef.SetText(this.m_distance, UnitsLocalizationHelper.LocalizeDistance(distance));
    inkWidgetRef.SetVisible(this.m_distance, distance >= 10.00);
  };
  this.m_mappin.SetStealthAwarenessState(this.m_currentAnimState);
  this.m_mappin.SetVisibleIn3D(shouldShow || this.m_objectMarkerVisible);
  this.SetRootVisible(shouldShow || this.m_objectMarkerVisible);
  this.SetIgnorePriority(!this.m_detectionVisible);
  this.m_lastPercent = percent;

  // Arrows
  if !this.lhud_isVisibleNow && !this.m_mappin.IsTagged() {
    inkWidgetRef.SetOpacity(this.m_arrow, 0.0);
    inkWidgetRef.SetOpacity(this.m_objectMarker, 0.0);
    inkWidgetRef.SetOpacity(this.m_taggedContainer, 0.0);
  } else {
    inkWidgetRef.SetOpacity(this.m_arrow, 1.0);  
    inkWidgetRef.SetOpacity(this.m_objectMarker, 1.0);  
    inkWidgetRef.SetOpacity(this.m_taggedContainer, 1.0);  
  };
}


// -- Enemy healthbar

@addMethod(NameplateVisualsLogicController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(NameplateVisualsLogicController)
public func DetermineCurrentVisibility() -> Void {
  if this.lhudConfig.IsEnabled {
    let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
    let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
    let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
    let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
    let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
    let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfig.ShowWithScanner;
    let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
    let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
    let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
    this.lhud_isVisibleNow = isVisible;
  } else {
    this.lhud_isVisibleNow = true;
  };

  this.UpdateHealthbarVisibility();
}

@addField(NameplateVisualsLogicController)
private let lhudConfig: ref<WorldMarkersModuleConfigCombat>;

@wrapMethod(NameplateVisualsLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WorldMarkersModuleConfigCombat();
  this.FetchInitialStateFlags();
  this.DetermineCurrentVisibility();
}

@replaceMethod(NameplateVisualsLogicController)
private final func UpdateHealthbarVisibility() -> Void {
  let playerPuppet: wref<PlayerPuppet>;
  let threatPuppet: wref<NPCPuppet>;
  let hpVisible: Bool = this.m_npcIsAggressive && (this.m_healthNotFull || this.m_playerAimingDownSights || this.m_playerInCombat || this.m_playerInStealth) && this.lhud_isVisibleNow;
  let nameplateHpVisible: Bool = hpVisible && !this.m_isBoss;
  if NotEquals(this.m_healthbarVisible, nameplateHpVisible) {
    this.m_healthbarVisible = nameplateHpVisible;
    inkWidgetRef.SetVisible(this.m_healthbarWidget, this.m_healthbarVisible);
  };
  if this.m_isBoss && IsDefined(this.m_cachedPuppet) {
    playerPuppet = GetPlayer(this.m_cachedPuppet.GetGame());
    threatPuppet = this.m_cachedPuppet as NPCPuppet;
    if ScriptedPuppet.IsAlive(threatPuppet) && hpVisible && !ScriptedPuppet.IsDefeated(threatPuppet) {
      BossHealthBarGameController.ReevaluateBossHealthBar(threatPuppet, playerPuppet);
    };
  };
}
