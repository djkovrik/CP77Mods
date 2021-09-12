// -- Everything Bottom Minimal

@addField(inkGameController)
public let TestSlot: ref<inkHorizontalPanel>;

@addField(inkGameController)
public let BottomLeftMain: ref<inkHorizontalPanel>;

@addField(inkGameController)
public let BottomRightCarHud: ref<inkVerticalPanel>;

@addField(inkGameController)
public let m_vehicleName_CHL: ref<inkText>;

@addMethod(inkGameController)
public func CreateCustomSlots() -> Void {
  this.TestSlot = this.MakeHorizontalSlot(
    n"TestSlot",
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Center,
    inkEVerticalAlign.Center,
    inkEAnchor.Centered,
    new Vector2(0.5, 0.5),
    new Vector2(0.5, 0.5)
  );
  this.TestSlot.Reparent(this.RootSlot);

  this.BottomLeftMain = this.MakeHorizontalSlot(
    n"BottomLeftMain",
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Fill,
    inkEVerticalAlign.Fill,
    inkEAnchor.BottomLeft,
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.BottomLeftMain.Reparent(this.RootSlot);

  this.BottomRightCarHud = this.MakeVerticalSlot(
    n"BottomRightCarHud",
    new inkMargin(0.0, 0.0, 0.0, 0.0),
    inkEHorizontalAlign.Right,
    inkEVerticalAlign.Fill,
    inkEAnchor.BottomRight,
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.BottomRightCarHud.Reparent(this.RootSlot);
}

@addMethod(inkGameController)
public func CreateCustomWidgets() {
  this.m_vehicleName_CHL = new inkText();
  this.m_vehicleName_CHL.SetName(n"chlVehicleName");
  this.m_vehicleName_CHL.SetFontFamily("base\\gameplay\\gui\\fonts\\orbitron\\orbitron.inkfontfamily");
  this.m_vehicleName_CHL.SetFontStyle(n"Medium");
  this.m_vehicleName_CHL.SetFontSize(24);
  this.m_vehicleName_CHL.SetLetterCase(textLetterCase.OriginalCase);
  this.m_vehicleName_CHL.SetText("Vehicle name");
  this.m_vehicleName_CHL.SetSize(200.0, 50.0);
  this.SetWidgetParams(
    this.m_vehicleName_CHL, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Center, 
    inkEVerticalAlign.Center, 
    inkEAnchor.Centered, 
    new Vector2(0.5, 0.5),
    new Vector2(0.5, 0.5)
  );
  this.m_vehicleName_CHL.Reparent(this.TestSlot);
}

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {
  // Minimap
  this.minimapRef.Reparent(this.BottomLeftMain);
  // Wanted Bar
  // Quest List
  // Healthbar
  // Crouch and Weapon roster
  // Stamina bar
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
  // let margins: inkMargin = this.carHudRef.GetMargin();
  // this.carHudRef.SetTranslation(new Vector2(120.0, margins.bottom));
  // this.SetWidgetParams(
  //   this.carHudRef, 
  //   new inkMargin(0.0, 0.0, 0.0, 0.0), 
  //   inkEHorizontalAlign.Right, 
  //   inkEVerticalAlign.Bottom, 
  //   inkEAnchor.BottomRight, 
  //   new Vector2(1.0, 1.0),
  //   new Vector2(1.0, 1.0)
  // );
  this.carHudRef.Reparent(this.BottomRightCarHud);
  // Zone alert
  // Phone call
  // Items notifications
  // Journal notifications
  // Level Up notifications
  // Militech warning

  this.RootSlot.RemoveChild(this.TopLeftMainSlot);
  this.RootSlot.RemoveChild(this.TopRightMainSlot);
  this.RootSlot.RemoveChild(this.BottomCenterSlot);
  this.RootSlot.RemoveChild(this.BottomLeftSlot);
  this.RootSlot.RemoveChild(this.BottomLeftTopSlot);
  this.RootSlot.RemoveChild(this.BottomRightMainSlot);
  this.RootSlot.RemoveChild(this.TopCenterSlot);
  this.RootSlot.RemoveChild(this.LeftCenterSlot);
}


//--  Adjust weapon roster to revert widgets order and replace folding animation

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

// Init widgets and replace folding animations
@replaceMethod(weaponRosterGameController)
protected cb func OnInitialize() -> Bool {
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
  this.weaponName_CHL.SetFontSize(22); 
  this.weaponName_CHL.SetHAlign(inkEHorizontalAlign.Right);
  this.weaponName_CHL.SetAnchor(inkEAnchor.CenterRight);
  this.weaponName_CHL.SetMargin(new inkMargin(0.0, 30.0, 20.0, 0.0));
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


// -- Widget tweaks

// Move compass and current time widgets to bottom of the minimap
@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let compass: ref<inkWidget> = root.GetWidget(n"MiniMapContainer/compassContainer");
  let timeText: ref<inkWidget> = root.GetWidget(n"location/unredMessagesGroup");
  let timeTranslation: Float = root.GetWidth() - timeText.GetWidth() - 40.0;
  let compassMarginLeft: Float = compass.GetWidth() / 2.5;
  let compassMarginTop: Float = compass.GetWidth() / 5;
  root.GetWidget(n"holder").SetVisible(false);
  compass.SetMargin(new inkMargin(-compassMarginLeft, -compassMarginTop, 0.0, 0.0));
  compass.SetHAlign(inkEHorizontalAlign.Left);
  compass.SetVAlign(inkEVerticalAlign.Bottom);
  compass.SetAnchor(inkEAnchor.BottomLeft);
  timeText.SetTranslation(new Vector2(timeTranslation, 0.0));
}

// -- New style for car hud

@replaceMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
  this.PlayLibraryAnimation(n"intro");
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let speedText: ref<inkText> = root.GetWidget(n"maindashcontainer/dynamic/speed_text") as inkText;
  root.GetWidget(n"holder_code").SetVisible(false);
  root.GetWidget(n"flufftext").SetVisible(false);
  root.GetWidget(n"speed_fluff").SetVisible(false);
  root.GetWidget(n"maindashcontainer/main").SetVisible(false);
  root.GetWidget(n"maindashcontainer/dynamic/rpm_full").SetVisible(false);
  speedText.SetFontSize(120);

  CHL("Margins 1: " + ToString(this.GetRootWidget().GetMargin()));
  CHL("Margins 2: " + ToString(this.GetRootCompoundWidget().GetMargin()));
  CHL("Margins 3: " + ToString(speedText.GetMargin()));
}

// @wrapMethod(hudCarController)
// protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
//   wrappedMethod(evt);
//   inkVehicleName.SetNameWidgetText(this.GetRootCompoundWidget(), "Vehicle name");
// }








// Remove quest tracker widget holder
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"inkVerticalPanelWidget2/QuestTracker/Fluff/AnchorPoint").SetVisible(false);
}

// Remove crime reported label from wanted bar widget
@wrapMethod(WantedBarGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidget(n"wanted_levels/attention").SetVisible(false);
}


// Scale widget size plus remove  widget holder and hp texts
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

// ReMove text label for stamina bar widget
@wrapMethod(StaminabarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.GetRootCompoundWidget().GetWidget(n"staminaMain/stamina_logo").SetVisible(false);
}
