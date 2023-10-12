import LimitedHudConfig.WorldMarkersModuleConfigCombat
import LimitedHudConfig.LHUDAddonsColoringConfig
import LimitedHudListeners.LHUDBlackboardsListener
import LimitedHudCommon.LHUDDamagePreviewColors
import LimitedHudCommon.LHUDArrowAndHpAppearance
import LimitedHudCommon.LHUDEvent

// -- Enemy nameplate icons
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
  this.RefreshTaggedArrowColor();
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

// -- Tagged arrow visibility
@wrapMethod(StealthMappinController)
protected cb func OnUpdate() -> Bool {
  wrappedMethod();

  if !this.lhud_isVisibleNow && !this.m_mappin.IsTagged() || Equals(this.lhudConfigAddons.NameplateHpAndArrowAppearance, LHUDArrowAndHpAppearance.Hide) {
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
  this.RefreshHpBarColors();
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

// -- Tag arrow color
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
    case LHUDArrowAndHpAppearance.Hide:
      newColor = n"MainColors.White";
      break;
    default:
      newColor = n"MainColors.EnemyBase";
      break;
  };

  let objectImage: ref<inkWidget> = root.GetWidgetByPathName(n"objectMarker/objectImage");
  objectImage.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  objectImage.BindProperty(n"tintColor", newColor);

  let arrowLeft: ref<inkWidget> = root.GetWidgetByPathName(n"objectMarker/taggedContainer/taggedArrowLeft");
  arrowLeft.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrowLeft.BindProperty(n"tintColor", newColor);

  let arrowRight: ref<inkWidget> = root.GetWidgetByPathName(n"objectMarker/taggedContainer/taggedArrowRight");
  arrowRight.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrowRight.BindProperty(n"tintColor", newColor);

  let arrow: ref<inkWidget> = root.GetWidgetByPathName(n"Arrow/arrowImage");
  arrow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrow.BindProperty(n"tintColor", newColor);

  if Equals(this.lhudConfigAddons.NameplateHpAndArrowAppearance, LHUDArrowAndHpAppearance.Hide) {
    objectImage.SetOpacity(0.0);
    arrowLeft.SetOpacity(0.0);
    arrowRight.SetOpacity(0.0);
    arrow.SetOpacity(0.0);
  };
}

// -- Enemy healthbar colors
@addMethod(NameplateVisualsLogicController)
private final func RefreshHpBarColors() -> Void {
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
    case LHUDArrowAndHpAppearance.Hide:
      newHpColor = n"MainColors.White";
      break;
    default:
      newHpColor = n"MainColors.EnemyBase";
      break;
  };

  if Equals(this.lhudConfigAddons.NameplateHpAndArrowAppearance, LHUDArrowAndHpAppearance.Hide) {
    inkWidgetRef.SetOpacity(this.m_healthbarWidget, 0.0);
    inkWidgetRef.SetOpacity(this.m_healthBarFull, 0.0);
    inkWidgetRef.SetOpacity(this.m_healthBarFrame, 0.0);
    inkWidgetRef.SetOpacity(this.m_damagePreviewWrapper, 0.0);
    inkWidgetRef.SetOpacity(this.m_damagePreviewWidget, 0.0);
    inkWidgetRef.SetOpacity(this.m_damagePreviewArrow, 0.0);

    return ;
  };

  // HP
  let strock: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/strock");
  strock.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  strock.BindProperty(n"tintColor", newHpColor);

  let full: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/logic/full");
  full.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  full.BindProperty(n"tintColor", newHpColor);

  let skull: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/skull");
  skull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  skull.BindProperty(n"tintColor", newHpColor);

  let newDamagePreviewColor: CName;
  switch(this.lhudConfigAddons.DamagePreviewColor) {
    case LHUDDamagePreviewColors.Red:
      newDamagePreviewColor = n"MainColors.Red";
      break;
    case LHUDDamagePreviewColors.Orange:
      newDamagePreviewColor = n"MainColors.EnemyBase";
      break;
    case LHUDDamagePreviewColors.Green:
      newDamagePreviewColor = n"MainColors.Green";
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


  // Damage preview  
  let arrow: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/stealth_kill/arrow");
  arrow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  arrow.BindProperty(n"tintColor", newDamagePreviewColor);

  let sfull: ref<inkWidget> = root.GetWidgetByPathName(n"name_health_horiz_panel/healthBar/wrapper/stealth_kill/full");
  sfull.DisableAllEffectsByType(inkEffectType.ScanlineWipe);
  sfull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  sfull.BindProperty(n"tintColor", newDamagePreviewColor);
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
      renderTransformXPivot = damagePercentage < 1.00 ? (currentHealthPercentage - damagePercentage) / (1.00 - damagePercentage) : 1.00;
      offset = 100.00 + 150.00 * damagePercentage - 150.00 * currentHealthPercentage;
      inkWidgetRef.SetRenderTransformPivot(this.m_damagePreviewWidget, new Vector2(renderTransformXPivot, 1.00));
      inkWidgetRef.SetScale(this.m_damagePreviewWidget, new Vector2(damagePercentage, 1.00));
      inkWidgetRef.SetMargin(this.m_damagePreviewArrow, 0.00, -22.00, offset, 0.00);
      // if !IsDefined(this.m_damagePreviewAnimProxy) || !this.m_damagePreviewAnimProxy.IsPlaying() {
      //   animOptions.loopType = inkanimLoopType.Cycle;
      //   animOptions.loopInfinite = true;
      //   this.m_damagePreviewAnimProxy = this.PlayLibraryAnimation(n"damage_preview_looping", animOptions);
      // };
      inkWidgetRef.SetVisible(this.m_damagePreviewWrapper, true);
    };
  };
}