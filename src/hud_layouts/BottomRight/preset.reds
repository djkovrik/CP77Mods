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
  this.dpadHintRef.Reparent(this.BottomRightMainSlot);

  // Weapon roster
  this.ammoCounterRef.SetTranslation(new Vector2(-180.0, -20.0));

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
  // Phone call
  // Items notifications
  this.itemsNotificationsRef.SetTranslation(new Vector2(-80.0, -110.0));
  // Journal notifications
  // Level Up notifications
  // Militech warning
}

@replaceMethod(weaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  // this.PlayInitFoldingAnim();
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
  CHL(WidgetAsString(inkWidgetRef.Get(this.m_container)));
  CHL(WidgetAsString(inkWidgetRef.Get(this.m_weaponName)));
  CHL(WidgetAsString(inkWidgetRef.Get(this.m_container)));
}

@addMethod(weaponRosterGameController)
private func SetInitialWidgetPositions() -> Void {
  inkWidgetRef.SetVisible(this.m_weaponIcon, true);
  inkWidgetRef.SetVisible(this.m_weaponName, true);
  inkWidgetRef.SetVisible(this.m_damageTypeRef, true);
  inkWidgetRef.SetVisible(this.m_CurrentAmmoRef, true);
  inkWidgetRef.SetVisible(this.m_AllAmmoRef, true);
  inkWidgetRef.SetTranslation(this.m_weaponIcon, new Vector2(0.0, 0.0));
  inkWidgetRef.SetTranslation(this.m_weaponName, new Vector2(0.0, 0.0));
  inkWidgetRef.SetTranslation(this.m_damageTypeRef, new Vector2(0.0, 0.0));
  inkWidgetRef.SetTranslation(this.m_CurrentAmmoRef, new Vector2(0.0, 0.0));
  inkWidgetRef.SetTranslation(this.m_AllAmmoRef, new Vector2(0.0, 0.0));
}

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
}

@addMethod(weaponRosterGameController)
protected func TranslationAnimation(targetWidget: inkWidgetRef, startTranslation: Float, endTranslation: Float) -> ref<inkAnimProxy> {
  let proxy: ref<inkAnimProxy>;
  let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
  let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
  translationInterpolator.SetType(inkanimInterpolationType.Linear);
  translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
  translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
  translationInterpolator.SetStartTranslation(new Vector2(startTranslation, 0.00));
  translationInterpolator.SetEndTranslation(new Vector2(endTranslation, 0.00));
  translationInterpolator.SetDuration(0.3);
  moveElementsAnimDef.AddInterpolator(translationInterpolator);
  inkWidgetRef.SetVisible(targetWidget, true);
  proxy = inkWidgetRef.PlayAnimation(targetWidget, moveElementsAnimDef);
  proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnTranslationCompleted");
  return proxy;
}
