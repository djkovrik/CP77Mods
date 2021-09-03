// -- Bottom Right

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {
  // Input Hunt
  this.inputHintRef.SetTranslation(new Vector2(10.0, 210.0));
  this.inputHintRef.Reparent(this.BottomRightSlot);

  // Minimap
  this.minimapRef.SetTranslation(new Vector2(25.0, 200.0));
  this.minimapRef.SetAnchor(inkEAnchor.BottomRight);
  this.minimapRef.Reparent(this.BottomRightSlot);

  // Wanted Bar
  this.wantedBarRef.SetTranslation(new Vector2(740.0, 20.0));
  this.wantedBarRef.Reparent(this.BottomCenterSlot);
  // Healthbar
  // Cooldowns
  // Vehicle summon
  this.vehicleSummonNotificationRef.SetTranslation(new Vector2(30.0, 320.0));
  // D-pad
  this.dpadHintRef.SetTranslation(new Vector2(-30.0, -40.0));
  this.dpadHintRef.SetAnchor(inkEAnchor.BottomLeft);
  this.dpadHintRef.SetAffectsLayoutWhenHidden(true);
  this.dpadHintRef.Reparent(this.BottomRightMainSlot);

  // Weapon roster
  this.ammoCounterRef.SetTranslation(new Vector2(-220.0, -20.0));
  // Crouch indicator
  this.BottomRightHorizontalSlot.SetAnchor(inkEAnchor.BottomLeft);
  this.BottomRightHorizontalSlot.SetChildOrder(inkEChildOrder.Backward);
  this.crouchIndicatorRef.SetTranslation(new Vector2(20.0, -15.0));
  this.BottomRightHorizontalSlot.Reparent(this.BottomLeftSlot);
  // Activity log
  // Warning
  // Boss healthbar
  // HUD progress
  // Oxygen bar
  // Car HUD
  // Zone alert
  // Stamina bar
  // Phone avatar
  this.phoneAvatarRef.SetTranslation(new Vector2(-10.0, 0.0));
  // Items notifications
  this.itemsNotificationsRef.SetTranslation(new Vector2(-80.0, -110.0));
  // Journal notifications
  this.journalNotificationsRef.SetTranslation(new Vector2(25.0, 0.0));
  // Level Up notifications
  // Militech warning
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
let weaponName_CHL: ref<inkText>;


// Init widgets with initial positions

@replaceMethod(weaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  // this.PlayInitFoldingAnim();
  this.InitWidgets();
  this.SetInitialWidgetPositions();
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
  this.weaponName_CHL = this.GetRootCompoundWidget().GetWidget(n"ammo_counter_and_the_holder/ammo_counter/inkHorizontalPanelWidget2/weapon_name") as inkText;
}

@addMethod(weaponRosterGameController)
private func SetInitialWidgetPositions() -> Void {
  this.weaponPanel_CHL.SetChildOrder(inkEChildOrder.Backward);
  this.weaponName_CHL.SetFontSize(24);
  this.damageIndicator_CHL.SetTranslation(new Vector2(-20.0, 0.0));
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
  alphaInterpolator.SetDuration(0.4);
  alphaInterpolator.SetStartDelay(startDelay);
  alphaInterpolator.SetType(inkanimInterpolationType.Exponential);
  alphaInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
  moveElementsAnimDef.AddInterpolator(alphaInterpolator);

  targetWidget.SetVisible(true);
  proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
  // proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnTranslationCompleted");
  return proxy;
}
