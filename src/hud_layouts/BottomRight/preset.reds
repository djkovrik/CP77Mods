// -- Bottom Right

public static func CarHudVehicleNameColor() -> HDRColor = new HDRColor(1.18, 0.38, 0.345, 1.0)    // Default game red
public static func CarHudSpeedTextColor() -> HDRColor = new HDRColor(0.368, 0.964, 1.0, 1.0)      // Default game blue
public static func CarHudVehicleNameFontSize() -> Int32 = 24
public static func CarHudSpeedLabelFontSize() -> Int32 = 68

@addField(inkGameController)
public let CustomBottomLeftVertical: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomRightVertical: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomRightMinimap: ref<inkHorizontalPanel>;

@addField(inkGameController)
public let BottomLeftCarHud: ref<inkVerticalPanel>;

@addMethod(inkGameController)
public func CreateCustomWidgets() -> Void {
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

  this.BottomLeftCarHud = this.MakeVerticalSlot(
    n"BottomLeftCarHud",
    new inkMargin(0.0, 0.0, 0.0, 10.0),
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.BottomLeftCarHud.SetAffectsLayoutWhenHidden(true);
  this.BottomLeftCarHud.Reparent(this.CustomBottomLeftVertical);

  this.InitializeSpeedometer();
}

@addMethod(inkGameController)
private func InitializeSpeedometer() -> Void {
  this.vehicleName_CHL = new inkText();
  this.vehicleName_CHL.SetName(n"chlVehicleName");
  this.vehicleName_CHL.SetSize(200.0, 50.0);
  this.SetWidgetParams(
    this.vehicleName_CHL, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.vehicleName_CHL.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  this.vehicleName_CHL.SetFontStyle(n"Medium");
  this.vehicleName_CHL.SetFontSize(CarHudVehicleNameFontSize());
  this.vehicleName_CHL.SetText("Vehicle name");
  this.vehicleName_CHL.SetLetterCase(textLetterCase.OriginalCase);
  this.vehicleName_CHL.SetTintColor(CarHudVehicleNameColor());
  this.vehicleName_CHL.Reparent(this.BottomLeftCarHud);

  this.vehicleSpeed_CHL = new inkText();
  this.vehicleSpeed_CHL.SetName(n"chlVehicleName");
  this.vehicleSpeed_CHL.SetSize(200.0, 50.0);
  this.SetWidgetParams(
    this.vehicleSpeed_CHL, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.vehicleSpeed_CHL.SetFontFamily("base\\gameplay\\gui\\fonts\\industry\\industry.inkfontfamily");
  this.vehicleSpeed_CHL.SetFontStyle(n"Medium");
  this.vehicleSpeed_CHL.SetFontSize(CarHudSpeedLabelFontSize());
  this.vehicleSpeed_CHL.SetText("123");
  this.vehicleSpeed_CHL.SetLetterCase(textLetterCase.OriginalCase);
  this.vehicleSpeed_CHL.SetTintColor(CarHudSpeedTextColor());
  this.vehicleSpeed_CHL.Reparent(this.BottomLeftCarHud);
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

  this.RootSlot.RemoveChild(this.carHudRef);

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
    this.questListRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Top, 
    inkEAnchor.TopRight, 
    new Vector2(1.0, 0.0),
    new Vector2(1.0, 0.0)
  );
  this.TopRightSlot.SetMargin(new inkMargin(0.0, 10.0, 10.0, 0.0));
  this.questListRef.SetScale(new Vector2(0.8, 0.8));

  this.SetWidgetParams(
    this.TopLeftPhoneSlot, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Left,
    inkEVerticalAlign.Top, 
    inkEAnchor.TopLeft, 
    new Vector2(0.0, 0.0),
    new Vector2(0.0, 0.0)
  );
  this.SetWidgetParams(
    this.phoneControlRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Left, 
    inkEVerticalAlign.Top, 
    inkEAnchor.TopLeft, 
    new Vector2(0.0, 0.0),
    new Vector2(0.0, 0.0)
  );
  this.phoneControlRef.SetScale(new Vector2(0.5, 0.5));
  this.phoneControlRef.SetSize(new Vector2(80.0, 30.0));
  this.phoneControlRef.Reparent(this.TopLeftPhoneSlot);

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


// Adjust weapon roster to revert widgets order and replace folding animation

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


// -- New speedometer widgets

@addField(inkGameController)
private let activeVehicle_CHL: wref<VehicleObject>;

@addField(inkGameController)
private let vehicleName_CHL: ref<inkText>;

@addField(inkGameController)
private let vehicleSpeed_CHL: ref<inkText>;

@addField(inkGameController)
private let speedBBConnectionId_CHL: ref<CallbackHandle>;

@addField(inkGameController)
private let tppBBConnectionId_CHL: ref<CallbackHandle>;

@addField(inkGameController)
private let isDriver_CHL: Bool;

@replaceMethod(hudCarController)
protected cb func OnInitialize() -> Bool {
  this.PlayLibraryAnimation(n"intro");
}

@addMethod(inkGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.activeVehicle_CHL = GetMountedVehicle(this.GetPlayerControlledObject());
    this.RegisterToVehicle(true);
  };
}

@addMethod(inkGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.RegisterToVehicle(false);
    this.activeVehicle_CHL = null;
  };
}

@addMethod(inkGameController)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.activeVehicle_CHL = GetMountedVehicle(this.GetPlayerControlledObject());
    let vehicleName: String = LocKeyToString(this.activeVehicle_CHL.GetRecord().DisplayName());
    this.vehicleName_CHL.SetText(vehicleName);
    this.isDriver_CHL = VehicleComponent.IsDriver(this.activeVehicle_CHL.GetGame(), this.GetPlayerControlledObject());
    this.RegisterToVehicle(true);
  };
}

@addMethod(inkGameController)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.vehicleName_CHL.SetText("");
    this.RegisterToVehicle(false);
    this.activeVehicle_CHL = null;
  };
}

@addMethod(inkGameController)
private final func RegisterToVehicle(register: Bool) -> Void {
  if !this.IsA(n"gameuiRootHudGameController") {
    return ;
  };

  let activeVehicleUIBlackboard: wref<IBlackboard>;
  let vehicleBlackboard: wref<IBlackboard>;
  let vehicle: ref<VehicleObject> = this.activeVehicle_CHL;
  if vehicle == null {
    return;
  };
  vehicleBlackboard = vehicle.GetBlackboard();
  if IsDefined(vehicleBlackboard) {
    if register {
      this.speedBBConnectionId_CHL = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnSpeedValueChanged");
    } else {
      vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.speedBBConnectionId_CHL);
    };
  };
  activeVehicleUIBlackboard = GameInstance.GetBlackboardSystem(vehicle.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  if IsDefined(activeVehicleUIBlackboard) {
    if register {
      this.tppBBConnectionId_CHL = activeVehicleUIBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnCameraModeChanged", true);
    } else {
      activeVehicleUIBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.tppBBConnectionId_CHL);
    };
  };
  // this.BottomRightCarHud.SetVisible(register);
}


@addMethod(inkGameController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    speedValue = AbsF(speedValue);
    let multiplier: Float = GameInstance.GetStatsDataSystem(this.activeVehicle_CHL.GetGame()).GetValueFromCurve(n"vehicle_ui", speedValue, n"speed_to_multiplier");
    this.vehicleSpeed_CHL.SetText(IntToString(RoundMath(speedValue * multiplier)));
  };
}

@addMethod(inkGameController)
protected cb func OnCameraModeChanged(mode: Bool) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    if this.isDriver_CHL {
      // this.BottomRightCarHud.SetVisible(mode);
    };
  };
}

