import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudConfig.LHUDAddonsColoringConfig
import LimitedHudListeners.LHUDBlackboardsListener
import LimitedHudCommon.LHUDDamagePreviewColors
import LimitedHudCommon.LHUDArrowAndHpAppearance
import LimitedHudCommon.LHUDEvent

// -- MARKERS

@addMethod(StealthMappinController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addField(StealthMappinController)
private let lhudConfig: ref<WorldMarkersModuleConfigCombat>;

@addField(StealthMappinController)
private let lhudConfigAddons: ref<LHUDAddonsColoringConfig>;

@wrapMethod(StealthMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WorldMarkersModuleConfigCombat();
  this.lhudConfigAddons = new LHUDAddonsColoringConfig();
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
  showEliteIndicator = !this.m_statusEffectShowing && !this.m_detectionVisible && (Equals(npcRarity, gamedataNPCRarity.Elite) || Equals(npcRarity, gamedataNPCRarity.MaxTac)) && this.lhud_isVisibleNow;
  inkWidgetRef.SetVisible(this.m_levelIcon, showEliteIndicator);
  shouldShow = (this.m_detectionVisible || this.m_statusEffectShowing || this.m_inNameplateMode || this.m_nameplateAnimationIsPlaying) && !this.m_isHiddenByQuest && this.lhud_isVisibleNow;
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
    inkWidgetRef.SetVisible(this.m_distance, distance >= 10.0);
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

  // Colors
  if this.lhudConfigAddons.EnableCustomColors {
    this.RefreshTaggedArrowColor();
  };
}

@addMethod(StealthMappinController)
private final func RefreshTaggedArrowColor() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let newColor: CName;
  switch(this.lhudConfigAddons.NameplateHpAndArrowAppearance) {
    case LHUDArrowAndHpAppearance.Red:
      newColor = n"MainColors.Red";
      break;
    case LHUDArrowAndHpAppearance.Orange:
      newColor = n"MainColors.EnemyBase";
      break;
    case LHUDArrowAndHpAppearance.Green:
      newColor = n"MainColors.Green";
       break;
    case LHUDArrowAndHpAppearance.Blue:
      newColor = n"MainColors.Blue";
      break;
    case LHUDArrowAndHpAppearance.White:
      newColor = n"MainColors.White";
      break;
    case LHUDArrowAndHpAppearance.Transparent:
      newColor = n"MainColors.White";
      break;
    default:
      newColor = n"MainColors.EnemyBase";
      break;
  };

  let objectImage: ref<inkWidget> = root.GetWidgetByPathName(n"objectMarker/objectImage");
  let arrowLeft: ref<inkWidget> = root.GetWidgetByPathName(n"objectMarker/taggedContainer/taggedArrowLeft");
  let arrowRight: ref<inkWidget> = root.GetWidgetByPathName(n"objectMarker/taggedContainer/taggedArrowRight");
  let arrow: ref<inkWidget> = root.GetWidgetByPathName(n"Arrow/arrowImage");
  objectImage.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrowLeft.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrowRight.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");

  if !this.m_isNCPD {
    objectImage.BindProperty(n"tintColor", newColor);
    arrowLeft.BindProperty(n"tintColor", newColor);
    arrowRight.BindProperty(n"tintColor", newColor);
    arrow.BindProperty(n"tintColor", newColor);
  } else {
    objectImage.UnbindProperty(n"tintColor");
    arrowLeft.UnbindProperty(n"tintColor");
    arrowRight.UnbindProperty(n"tintColor");
    arrow.UnbindProperty(n"tintColor");
  };

  if Equals(this.lhudConfigAddons.NameplateHpAndArrowAppearance, LHUDArrowAndHpAppearance.Transparent) {
    objectImage.SetOpacity(0.0);
    arrowLeft.SetOpacity(0.0);
    arrowRight.SetOpacity(0.0);
    arrow.SetOpacity(0.0);
  };
}


// -- HEALTHBAR

@addMethod(NameplateVisualsLogicController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@wrapMethod(NameplateVisualsLogicController)
public final func SetVisualData(puppet: ref<GameObject>, const incomingData: script_ref<NPCNextToTheCrosshair>, opt isNewNpc: Bool) -> Void {
  wrappedMethod(puppet, incomingData, isNewNpc);
  if this.lhudConfigAddons.EnableCustomColors {
    this.RefreshHpBarColors();
  };
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

@addField(NameplateVisualsLogicController)
private let lhudConfigAddons: ref<LHUDAddonsColoringConfig>;

@wrapMethod(NameplateVisualsLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new WorldMarkersModuleConfigCombat();
  this.lhudConfigAddons = new LHUDAddonsColoringConfig();
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

@addMethod(NameplateVisualsLogicController)
private final func RefreshHpBarColors() -> Void {
  if Equals(this.lhudConfigAddons.NameplateHpAndArrowAppearance, LHUDArrowAndHpAppearance.Transparent) {
    inkWidgetRef.SetOpacity(this.m_healthbarWidget, 0.0);
    inkWidgetRef.SetOpacity(this.m_healthBarFull, 0.0);
    inkWidgetRef.SetOpacity(this.m_healthBarFrame, 0.0);
    inkWidgetRef.SetOpacity(this.m_damagePreviewWrapper, 0.0);
    inkWidgetRef.SetOpacity(this.m_damagePreviewWidget, 0.0);
    inkWidgetRef.SetOpacity(this.m_damagePreviewArrow, 0.0);

    return ;
  };

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let newHpColor: CName;
  switch(this.lhudConfigAddons.NameplateHpAndArrowAppearance) {
    case LHUDArrowAndHpAppearance.Red:
      newHpColor = n"MainColors.Red";
      break;
    case LHUDArrowAndHpAppearance.Orange:
      newHpColor = n"MainColors.EnemyBase";
      break;
    case LHUDArrowAndHpAppearance.Green:
      newHpColor = n"MainColors.Green";
       break;
    case LHUDArrowAndHpAppearance.Blue:
      newHpColor = n"MainColors.Blue";
      break;
    case LHUDArrowAndHpAppearance.White:
      newHpColor = n"MainColors.White";
      break;
    case LHUDArrowAndHpAppearance.Transparent:
      newHpColor = n"MainColors.White";
      break;
    default:
      newHpColor = n"MainColors.EnemyBase";
      break;
  };

  let newDamagePreviewColor: CName;
  switch(this.lhudConfigAddons.DamagePreviewColor) {
    case LHUDDamagePreviewColors.Red:
      newDamagePreviewColor = n"MainColors.ActiveRed";
      break;
    case LHUDDamagePreviewColors.Orange:
      newDamagePreviewColor = n"MainColors.EnemyBase";
      break;
    case LHUDDamagePreviewColors.Green:
      newDamagePreviewColor = n"MainColors.ActiveGreen";
       break;
    case LHUDDamagePreviewColors.Blue:
      newDamagePreviewColor = n"MainColors.Blue";
      break;
    case LHUDDamagePreviewColors.Black:
      newDamagePreviewColor = n"MainColors.Black";
      break;
    case LHUDDamagePreviewColors.White:
      newDamagePreviewColor = n"MainColors.White";
      break;
    default:
      newDamagePreviewColor = n"MainColors.Blue";
      break;
  };

  // HP
  let strock: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/strock");
  let full: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/logic/full");
  let skull: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/skull");
  strock.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  full.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  skull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  

  // Damage preview  
  let arrow: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/stealth_kill/arrow");
  let sfull: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/stealth_kill/full");
  arrow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  sfull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  sfull.DisableAllEffectsByType(inkEffectType.ScanlineWipe);

  if !this.m_isNCPD {
    strock.BindProperty(n"tintColor", newHpColor);
    full.BindProperty(n"tintColor", newHpColor);
    skull.BindProperty(n"tintColor", newHpColor);
    arrow.BindProperty(n"tintColor", newDamagePreviewColor);
    sfull.BindProperty(n"tintColor", newDamagePreviewColor);
  } else {
    strock.UnbindProperty(n"tintColor");
    full.UnbindProperty(n"tintColor");
    skull.UnbindProperty(n"tintColor");
    arrow.UnbindProperty(n"tintColor");
    sfull.UnbindProperty(n"tintColor");
  };
}

// Disable damage preview pulsing
@replaceMethod(NameplateVisualsLogicController)
public final func PreviewDamage(value: Int32) -> Void {
  // let animOptions: inkAnimOptions;
  let currentHealthPercentage: Float;
  let damagePercentage: Float;
  let offset: Float;
  let renderTransformXPivot: Float;
  this.m_currentDamagePreviewValue = value;
  if value <= 0 {
    if IsDefined(this.m_damagePreviewAnimProxy) && this.m_damagePreviewAnimProxy.IsPlaying() {
      this.m_damagePreviewAnimProxy.Stop();
    };
    inkWidgetRef.SetVisible(this.m_damagePreviewWrapper, false);
  } else {
    if this.m_maximumHealth > 0 {
      currentHealthPercentage = Cast<Float>(this.m_currentHealth) / Cast<Float>(this.m_maximumHealth);
      damagePercentage = Cast<Float>(value) / Cast<Float>(this.m_maximumHealth);
      damagePercentage = MinF(damagePercentage, currentHealthPercentage);
      renderTransformXPivot = damagePercentage < 1.0 ? (currentHealthPercentage - damagePercentage) / (1.0 - damagePercentage) : 1.0;
      offset = 100.0 + 150.0 * damagePercentage - 150.0 * currentHealthPercentage;
      inkWidgetRef.SetRenderTransformPivot(this.m_damagePreviewWidget, new Vector2(renderTransformXPivot, 1.0));
      inkWidgetRef.SetScale(this.m_damagePreviewWidget, new Vector2(damagePercentage, 1.0));
      inkWidgetRef.SetMargin(this.m_damagePreviewArrow, 0.0, -22.0, offset, 0.0);
      // if !IsDefined(this.m_damagePreviewAnimProxy) || !this.m_damagePreviewAnimProxy.IsPlaying() {
      //   animOptions.loopType = inkanimLoopType.Cycle;
      //   animOptions.loopInfinite = true;
      //   this.m_damagePreviewAnimProxy = this.PlayLibraryAnimation(n"damage_preview_looping", animOptions);
      // };
      inkWidgetRef.SetVisible(this.m_damagePreviewWrapper, true);
    };
  };
}
