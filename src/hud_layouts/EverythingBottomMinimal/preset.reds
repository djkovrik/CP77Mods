// -- Everything Bottom Minimal

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {

  this.dpadHintRef.Reparent(this.TopRightWantedSlot);
  this.inputHintRef.Reparent(this.TopRightSlot);
  this.carHudRef.Reparent(this.TopRightSlot);

  // Wanted Bar
  this.wantedBarRef.SetTranslation(new Vector2(250.0, 280.0));
  this.wantedBarRef.SetScale(new Vector2(0.75, 0.75));
  this.wantedBarRef.SetRotation(180.0);
  this.wantedBarRef.Reparent(this.BottomLeftSlot);

  // Quest List
  this.questListRef.SetScale(new Vector2(0.85, 0.85));
  this.questListRef.SetOpacity(0.8);
  this.questListRef.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  this.questListRef.SetTranslation(new Vector2(-60.0, 240.0));
  this.questListRef.SetHAlign(inkEHorizontalAlign.Left);
  this.questListRef.SetVAlign(inkEVerticalAlign.Bottom);
  this.questListRef.SetAnchor(inkEAnchor.BottomLeft);
  this.questListRef.Reparent(this.BottomLeftTopSlot);
  // Minimap
  this.minimapRef.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  this.minimapRef.SetTranslation(new Vector2(0.0, 35.0));
  this.minimapRef.SetHAlign(inkEHorizontalAlign.Left);
  this.minimapRef.SetVAlign(inkEVerticalAlign.Bottom);
  this.minimapRef.SetAnchor(inkEAnchor.BottomLeft);
  this.minimapRef.Reparent(this.BottomLeftSlot);
  // Healthbar
  this.playerHealthBarRef.SetTranslation(new Vector2(-240.0, -90.0));
  this.playerHealthBarRef.SetScale(new Vector2(0.9, 0.9));
  this.playerHealthBarRef.SetOpacity(0.9);
  this.playerHealthBarRef.Reparent(this.BottomRightSlot);

  // Crouch and Weapon roster
  this.ammoCounterRef.SetTranslation(new Vector2(-220.0, 0.0));
  this.crouchIndicatorRef.SetOpacity(0.8);
  this.BottomRightHorizontalSlot.SetTranslation(new Vector2(30.0, 20.0));
  this.BottomRightHorizontalSlot.SetHAlign(inkEHorizontalAlign.Left);
  this.BottomRightHorizontalSlot.SetAnchor(inkEAnchor.BottomLeft);
  this.BottomRightHorizontalSlot.SetChildOrder(inkEChildOrder.Backward);
  this.BottomRightHorizontalSlot.SetScale(new Vector2(0.8, 0.8));
  this.BottomRightHorizontalSlot.Reparent(this.BottomCenterSlot);
  // Stamina bar
  this.staminabarRef.SetScale(new Vector2(0.9, 0.9));
  this.staminabarRef.SetTranslation(new Vector2(297.0, -275.0));
  this.staminabarRef.SetAnchor(inkEAnchor.BottomLeft);
  // Cooldowns
  // Vehicle summon
  // D-pad
  // Input Hunt
  // Crouch Indicator
  // Weapon roster
  // Warning
  // HUD progress
  // Oxygen bar
  // Car HUD
  // Zone alert
  // Phone call
  // Items notifications
  // Journal notifications
  // Level Up notifications
  // Militech warning
}

// -- Hide elements

@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let compass: ref<inkWidget> = root.GetWidget(n"MiniMapContainer/compassContainer");
  let timeText: ref<inkWidget> = root.GetWidget(n"location/unredMessagesGroup");
  root.GetWidget(n"holder").SetVisible(false);
  compass.SetMargin(new inkMargin(-40.0, -20.0, 0.0, 0.0));
  compass.SetHAlign(inkEHorizontalAlign.Left);
  compass.SetVAlign(inkEVerticalAlign.Bottom);
  compass.SetAnchor(inkEAnchor.BottomLeft);
  timeText.SetTranslation(new Vector2(340.0, 0.0));
}

@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"inkVerticalPanelWidget2/QuestTracker/Fluff/AnchorPoint").SetVisible(false);
}

@wrapMethod(WantedBarGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"wanted_levels/attention").SetVisible(false);
}


@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let buffs: ref<inkWidget> = root.GetWidget(n"buffsHolder/inkVerticalPanelWidget2/buffs");
  root.GetWidget(n"buffsHolder/holder/holder_code").SetVisible(false);
  root.GetWidget(n"buffsHolder/holder/holder_core").SetVisible(false);
  root.GetWidget(n"buffsHolder/hpTextVert/hp_number_holder").SetVisible(false);
  root.GetWidget(n"buffsHolder/hpbar_fluff").SetVisible(false);
  buffs.SetScale(new Vector2(0.85, 0.85));
  buffs.SetTranslation(new Vector2(-50.0, 0.0));
}

@wrapMethod(StaminabarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let logo: ref<inkWidget> = root.GetWidget(n"staminaMain/stamina_logo");
  logo.SetTranslation(new Vector2(0.0, -40.0));
}

// -- Hijack weapon roster to revert widgets order and folding animation directions

// New widget defs for easier managing

@addField(weaponRosterGameController)
let weaponPanel_CHL: ref<inkHorizontalPanel>;

@addField(weaponRosterGameController)
let damageIndicator_CHL: ref<inkVerticalPanel>;

@addField(weaponRosterGameController)
let ammoWrapper_CHL: ref<inkHorizontalPanel>;

@addField(weaponRosterGameController)
let weaponHolder_CHL: ref<inkVerticalPanel>;

@addField(weaponRosterGameController)
let weaponIcon_CHL: ref<inkImage>;

@addField(weaponRosterGameController)
let weaponName_CHL: ref<inkText>;


// Init widgets with initial positions

@replaceMethod(weaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  // this.PlayInitFoldingAnim();
  this.InitWidgets();
  this.SetWidgetsAppearance();
  inkWidgetRef.SetVisible(this.m_warningMessageWraper, false);
  this.m_damageTypeIndicator = inkWidgetRef.GetController(this.m_damageTypeRef) as DamageTypeIndicator;
  this.m_bbDefinition = GetAllBlackboardDefs().UIInteractions;
  this.m_blackboard = this.GetBlackboardSystem().Get(this.m_bbDefinition);
  this.m_UIBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);
  this.m_hackingBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Hacking);
  this.m_weaponBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveWeaponData);
  inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
  inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
}

@addMethod(weaponRosterGameController)
private func InitWidgets() -> Void {
  this.weaponPanel_CHL = this.GetRootCompoundWidget().GetWidget(n"ammo_counter_and_the_holder/ammo_counter/weapon_wrapper") as inkHorizontalPanel;
  this.damageIndicator_CHL = this.weaponPanel_CHL.GetWidget(n"damage_indicator") as inkVerticalPanel;
  this.ammoWrapper_CHL = this.weaponPanel_CHL.GetWidget(n"ammo_wrapper") as inkHorizontalPanel;
  this.weaponHolder_CHL = this.weaponPanel_CHL.GetWidget(n"weapon_holder") as inkVerticalPanel;
  this.weaponIcon_CHL = this.weaponHolder_CHL.GetWidget(n"weapon_icon") as inkImage;
  this.weaponName_CHL = this.GetRootCompoundWidget().GetWidget(n"ammo_counter_and_the_holder/ammo_counter/inkHorizontalPanelWidget2/weapon_name") as inkText;
}

@addMethod(weaponRosterGameController)
private func SetWidgetsAppearance() -> Void {
  this.weaponPanel_CHL.SetChildOrder(inkEChildOrder.Backward);
  this.weaponName_CHL.SetFontSize(26);
  this.damageIndicator_CHL.SetTranslation(new Vector2(-20.0, 0.0));
  this.weaponIcon_CHL.SetBrushMirrorType(inkBrushMirrorType.Both);
  this.weaponIcon_CHL.SetRotation(180.0);
  this.weaponIcon_CHL.SetHAlign(inkEHorizontalAlign.Left);
  this.weaponIcon_CHL.SetAnchor(inkEAnchor.CenterLeft);
  this.weaponIcon_CHL.SetFitToContent(true);
  this.weaponName_CHL.SetHAlign(inkEHorizontalAlign.Right);
  this.weaponName_CHL.SetAnchor(inkEAnchor.CenterRight);
  this.weaponName_CHL.Reparent(this.weaponHolder_CHL);
}

// Custom fold and unfold animations

@replaceMethod(weaponRosterGameController)
  private final func PlayFold() -> Void {
  if this.m_folded {
    return;
  };
  this.m_folded = true;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  // this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.TranslationAnimation(this.weaponHolder_CHL, 0.0, -600.0, 1.0, 0.0, 0.0);
  this.TranslationAnimation(this.weaponName_CHL, 0.0, -600.0, 1.0, 0.0, 0.0);
  this.TranslationAnimation(this.ammoWrapper_CHL, 0.0, -600.0, 1.0, 0.0, 0.1);
  this.TranslationAnimation(this.damageIndicator_CHL, -20.0, -600.0, 1.0, 0.0, 0.15);
}

@replaceMethod(weaponRosterGameController)
private final func PlayUnfold() -> Void {
  if !this.m_folded {
    return;
  };
  this.m_folded = false;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  // this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"unfold");
  this.TranslationAnimation(this.weaponHolder_CHL, -600.0, 0.0, 0.0, 1.0, 0.0);
  this.TranslationAnimation(this.weaponName_CHL, -600.0, 0.0, 0.0, 1.0, 0.05);
  this.TranslationAnimation(this.ammoWrapper_CHL, -600.0, 0.0, 0.0, 1.0, 0.1);
  this.TranslationAnimation(this.damageIndicator_CHL, -600.0, -20.0, 0.0, 1.0, 0.15);
}

@addMethod(weaponRosterGameController)
protected func TranslationAnimation(targetWidget: ref<inkWidget>, startTranslation: Float, endTranslation: Float, startAlpha: Float, endAlpha: Float, startDelay: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
  translationInterpolator.SetType(inkanimInterpolationType.Exponential);
  translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  translationInterpolator.SetStartTranslation(new Vector2(startTranslation, 0.00));
  translationInterpolator.SetEndTranslation(new Vector2(endTranslation, 0.00));
  translationInterpolator.SetDuration(0.3);
  translationInterpolator.SetStartDelay(startDelay);
  moveElementsAnimDef.AddInterpolator(translationInterpolator);

  let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
  alphaInterpolator.SetStartTransparency(startAlpha);
  alphaInterpolator.SetEndTransparency(endAlpha);
  alphaInterpolator.SetDuration(0.3);
  alphaInterpolator.SetStartDelay(startDelay);
  alphaInterpolator.SetType(inkanimInterpolationType.Exponential);
  alphaInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  moveElementsAnimDef.AddInterpolator(alphaInterpolator);

  targetWidget.SetVisible(true);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  // proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnTranslationCompleted");
  return proxy;
}
