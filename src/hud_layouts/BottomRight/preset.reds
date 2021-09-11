// -- Bottom Right

@addField(inkGameController)
public let CustomBottomLeftVertical: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomRightVertical: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomRightMinimap: ref<inkHorizontalPanel>;

@addMethod(inkGameController)
public func CreateCustomSlots() -> Void {
  this.CustomBottomLeftVertical = this.MakeVerticalSlot(
    n"CustomBottomLeftVertical",
    new inkMargin(25.0, 25.0, 25.0, 25.0),
    inkEHorizontalAlign.Left,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomLeft,
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.CustomBottomLeftVertical.Reparent(this.RootSlot);

  this.CustomBottomRightVertical = this.MakeVerticalSlot(
    n"CustomBottomRightVertical",
    new inkMargin(25.0, 25.0, 25.0, 25.0),
    inkEHorizontalAlign.Right,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomRight,
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.CustomBottomRightVertical.Reparent(this.RootSlot);

  this.CustomBottomRightMinimap = this.MakeHorizontalSlot(
    n"CustomBottomRightHorizontal",
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Right,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomRight,
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );

}

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {

  this.SetWidgetParams(
    this.BottomRightHorizontalSlot, 
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.BottomRightHorizontalSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 10.0));
  this.BottomRightHorizontalSlot.SetChildOrder(inkEChildOrder.Backward);
  this.BottomRightHorizontalSlot.Reparent(this.CustomBottomLeftVertical);
  this.ammoCounterRef.SetTranslation(new Vector2(-this.ammoCounterRef.GetWidth() / 4.0, 0.0));

  this.SetWidgetParams(
    this.carHudRef, 
    new inkMargin(25.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );

  this.SetWidgetParams(
    this.vehicleSummonNotificationRef, 
    new inkMargin(0.0, 0.0, 40.0, 0.0), 
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Center, 
    inkEAnchor.CenterRight, 
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.vehicleSummonNotificationRef.Reparent(this.RootSlot);

  this.inputHintRef.SetMargin(new inkMargin(0.0, 0.0, 0.0, 40.0));
  this.inputHintRef.Reparent(this.CustomBottomRightVertical);
  this.CustomBottomRightMinimap.Reparent(this.CustomBottomRightVertical);

  this.SetWidgetParams(
    this.wantedBarRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomRight, 
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.wantedBarRef.Reparent(this.CustomBottomRightMinimap);

  this.SetWidgetParams(
    this.minimapRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomRight, 
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.minimapRef.Reparent(this.CustomBottomRightMinimap);

  this.SetWidgetParams(
    this.dpadHintRef, 
    new inkMargin(25.0, 0.0, 25.0, 100.0),
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomCenter, 
    new Vector2(-0.4, 1.0),
    new Vector2(-0.4, 1.0)
  );
  this.dpadHintRef.Reparent(this.RootSlot);
}


// -- Hijack weapon roster to revert widgets order and replace folding animation

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
  this.damageIndicator_CHL.SetTranslation(new Vector2(-20.0, 0.0));
  this.weaponPanel_CHL.SetChildOrder(inkEChildOrder.Backward);
  this.weaponIcon_CHL.SetBrushMirrorType(inkBrushMirrorType.Both);
  this.weaponIcon_CHL.SetRotation(180.0);
  this.weaponIcon_CHL.SetHAlign(inkEHorizontalAlign.Left);
  this.weaponIcon_CHL.SetContentHAlign(inkEHorizontalAlign.Left);
  this.weaponIcon_CHL.SetAnchor(inkEAnchor.CenterLeft);
  this.weaponIcon_CHL.SetFitToContent(false);
  this.weaponName_CHL.SetFontSize(24); 
  this.weaponName_CHL.SetHAlign(inkEHorizontalAlign.Right);
  this.weaponName_CHL.SetAnchor(inkEAnchor.CenterRight);
  this.weaponName_CHL.Reparent(this.weaponHolder_CHL);
}

// -- Custom fold and unfold animations

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
  this.TranslationAnimation(this.weaponIcon_CHL, 0.0, -600.0, 1.0, 0.0, 0.0);
  this.TranslationAnimation(this.weaponName_CHL, 0.0, -600.0, 1.0, 0.0, 0.05);
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
  this.TranslationAnimation(this.weaponIcon_CHL, -600.0, 0.0, 0.0, 1.0, 0.0);
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
  return proxy;
}
