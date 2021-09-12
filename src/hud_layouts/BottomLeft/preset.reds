// -- Bottom Left

public static func CarHudVehicleNameColor() -> HDRColor = new HDRColor(1.18, 0.38, 0.345, 1.0)    // Default game red
public static func CarHudSpeedTextColor() -> HDRColor = new HDRColor(0.368, 0.964, 1.0, 1.0)      // Default game blue
public static func CarHudVehicleNameFontSize() -> Int32 = 24
public static func CarHudSpeedLabelFontSize() -> Int32 = 68

@addField(inkGameController)
public let CustomBottomLeftMinimap: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomLeftWanted: ref<inkVerticalPanel>;

@addField(inkGameController)
public let CustomBottomRight: ref<inkVerticalPanel>;

@addField(inkGameController)
public let BottomRightCarHud: ref<inkVerticalPanel>;

@addMethod(inkGameController)
public func CreateCustomWidgets() -> Void {
  this.CustomBottomLeftMinimap = this.MakeVerticalSlot(
    n"CustomBottomLeftMinimap",
    new inkMargin(25.0, 0.0, 0.0, 25.0),
    inkEHorizontalAlign.Left,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomLeft,
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.CustomBottomLeftMinimap.Reparent(this.RootSlot);

  this.CustomBottomLeftWanted = this.MakeVerticalSlot(
    n"CustomBottomLeftWanted",
    new inkMargin(20.0, 0.0, 20.0, 20.0),
    inkEHorizontalAlign.Left,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomLeft,
    new Vector2(1.5, -0.4),
    new Vector2(1.5, -0.4)
  );
  this.CustomBottomLeftWanted.SetRotation(180.0);
  this.CustomBottomLeftWanted.Reparent(this.RootSlot);

  this.CustomBottomRight = this.MakeVerticalSlot(
    n"CustomBottomRight",
    new inkMargin(0.0, 0.0, 25.0, 25.0),
    inkEHorizontalAlign.Right,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomRight,
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.CustomBottomRight.Reparent(this.RootSlot);

  this.BottomRightCarHud = this.MakeVerticalSlot(
    n"BottomRightCarHud",
    new inkMargin(0.0, 0.0, 0.0, 10.0),
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomRight, 
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.BottomRightCarHud.SetAffectsLayoutWhenHidden(true);

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
  this.vehicleName_CHL.Reparent(this.BottomRightCarHud);

  this.vehicleSpeed_CHL = new inkText();
  this.vehicleSpeed_CHL.SetName(n"chlVehicleName");
  this.vehicleSpeed_CHL.SetSize(200.0, 50.0);
  this.SetWidgetParams(
    this.vehicleSpeed_CHL, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Center, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomLeft, 
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.vehicleSpeed_CHL.SetFontFamily("base\\gameplay\\gui\\fonts\\industry\\industry.inkfontfamily");
  this.vehicleSpeed_CHL.SetFontStyle(n"Medium");
  this.vehicleSpeed_CHL.SetFontSize(CarHudSpeedLabelFontSize());
  this.vehicleSpeed_CHL.SetText("123");
  this.vehicleSpeed_CHL.SetLetterCase(textLetterCase.OriginalCase);
  this.vehicleSpeed_CHL.SetTintColor(CarHudSpeedTextColor());
  this.vehicleSpeed_CHL.Reparent(this.BottomRightCarHud);
}

@addMethod(inkGameController)
public func AdjustWidgetsPositions() -> Void {
  this.minimapRef.Reparent(this.CustomBottomLeftMinimap);
  this.SetWidgetParams(
    this.dpadHintRef, 
    new inkMargin(0.0, 0.0, 0.0, 10.0), 
    inkEHorizontalAlign.Center, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomCenter, 
    new Vector2(0.0, 0.0),
    new Vector2(0.0, 0.0)
  );
  this.BottomCenterSlot.SetMargin(new inkMargin(60.0, 0.0, 30.0, 40.0));
  this.dpadHintRef.SetScale(new Vector2(0.8, 0.8));
  this.dpadHintRef.Reparent(this.BottomCenterSlot);
  this.SetWidgetParams(
    this.inputHintRef, 
    new inkMargin(0.0, 0.0, 0.0, 20.0),
    inkEHorizontalAlign.Right,
    inkEVerticalAlign.Bottom,
    inkEAnchor.BottomRight,
    new Vector2(1.0, 1.0),
    new Vector2(1.0, 1.0)
  );
  this.inputHintRef.SetScale(new Vector2(0.8, 0.8));
  this.inputHintRef.Reparent(this.CustomBottomRight);
  this.itemsNotificationsRef.SetMargin(new inkMargin(0.0, -100.0, 0.0, 0.0));

  this.BottomRightCarHud.Reparent(this.CustomBottomRight);

  this.SetWidgetParams(
    this.wantedBarRef, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Center, 
    inkEVerticalAlign.Top, 
    inkEAnchor.Centered, 
    new Vector2(1.0, 0.75),
    new Vector2(1.0, 0.75)
  );
  this.wantedBarRef.SetScale(new Vector2(0.5, 0.5));
  this.wantedBarRef.Reparent(this.CustomBottomLeftWanted);

  this.RootSlot.RemoveChild(this.carHudRef);

  this.SetWidgetParams(
    this.BottomRightHorizontalSlot, 
    new inkMargin(0.0, 0.0, 0.0, 0.0), 
    inkEHorizontalAlign.Right, 
    inkEVerticalAlign.Bottom, 
    inkEAnchor.BottomRight, 
    new Vector2(0.0, 1.0),
    new Vector2(0.0, 1.0)
  );
  this.BottomRightHorizontalSlot.Reparent(this.CustomBottomRight);

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
}

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

