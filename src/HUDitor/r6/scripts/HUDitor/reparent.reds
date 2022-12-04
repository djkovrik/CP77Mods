@addField(inkGameController) let minimapSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let questTrackerSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let staminaBarSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let vehicleSummonSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let inputHintSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let wantedSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let phoneCallAvatarSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let weaponCrouchSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let dpadSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let healthbarSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let phoneControlSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let questNotificationsSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let itemNotificationsSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let carHudSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let bossHealthbarSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let dialogChoicesSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let dialogSubtitlesSlot: ref<HUDitorCustomSlot>;
// Spicy
@addField(inkGameController) let compassSlotScale: ref<HUDitorCustomSlot>;
@addField(inkGameController) let compassSlotMarkers: ref<HUDitorCustomSlot>;

@addMethod(inkGameController)
protected cb func OnScannerDetailsAppearedEvent(event: ref<ScannerDetailsAppearedEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnScannerDetailsAppearedEvent(event);
    this.questTrackerSlot.OnScannerDetailsAppearedEvent(event);
  };
}

@addMethod(inkGameController)
protected cb func OnGameSessionInitialized(event: ref<GameSessionInitializedEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnGameSessionInitialized(event);
    this.questTrackerSlot.OnGameSessionInitialized(event);
    this.staminaBarSlot.OnGameSessionInitialized(event);
    this.vehicleSummonSlot.OnGameSessionInitialized(event);
    this.inputHintSlot.OnGameSessionInitialized(event);
    this.wantedSlot.OnGameSessionInitialized(event);
    this.phoneCallAvatarSlot.OnGameSessionInitialized(event);
    this.weaponCrouchSlot.OnGameSessionInitialized(event);
    this.dpadSlot.OnGameSessionInitialized(event);
    this.healthbarSlot.OnGameSessionInitialized(event);
    this.phoneControlSlot.OnGameSessionInitialized(event);
    this.questNotificationsSlot.OnGameSessionInitialized(event);
    this.itemNotificationsSlot.OnGameSessionInitialized(event);
    this.carHudSlot.OnGameSessionInitialized(event);
    this.bossHealthbarSlot.OnGameSessionInitialized(event);
    this.dialogChoicesSlot.OnGameSessionInitialized(event);
    this.dialogSubtitlesSlot.OnGameSessionInitialized(event);

    if IsDefined(this.compassSlotScale) {
      this.compassSlotScale.OnGameSessionInitialized(event);
    };
    if IsDefined(this.compassSlotMarkers) {
      this.compassSlotMarkers.OnGameSessionInitialized(event);
    };
  };
}

@addMethod(inkGameController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidget>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnEnableHUDEditorWidget(event);
    this.questTrackerSlot.OnEnableHUDEditorWidget(event);
    this.staminaBarSlot.OnEnableHUDEditorWidget(event);
    this.vehicleSummonSlot.OnEnableHUDEditorWidget(event);
    this.inputHintSlot.OnEnableHUDEditorWidget(event);
    this.wantedSlot.OnEnableHUDEditorWidget(event);
    this.phoneCallAvatarSlot.OnEnableHUDEditorWidget(event);
    this.weaponCrouchSlot.OnEnableHUDEditorWidget(event);
    this.dpadSlot.OnEnableHUDEditorWidget(event);
    this.healthbarSlot.OnEnableHUDEditorWidget(event);
    this.phoneControlSlot.OnEnableHUDEditorWidget(event);
    this.questNotificationsSlot.OnEnableHUDEditorWidget(event);
    this.itemNotificationsSlot.OnEnableHUDEditorWidget(event);
    this.carHudSlot.OnEnableHUDEditorWidget(event);
    this.bossHealthbarSlot.OnEnableHUDEditorWidget(event);
    this.dialogChoicesSlot.OnEnableHUDEditorWidget(event);
    this.dialogSubtitlesSlot.OnEnableHUDEditorWidget(event);

    if IsDefined(this.compassSlotScale) {
      this.compassSlotScale.OnEnableHUDEditorWidget(event);
    };
    if IsDefined(this.compassSlotMarkers) {
      this.compassSlotMarkers.OnEnableHUDEditorWidget(event);
    };
  };
}

@addMethod(inkGameController)
protected cb func OnDisableHUDEditorWidgets(event: ref<DisableHUDEditor>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnDisableHUDEditorWidgets(event);
    this.questTrackerSlot.OnDisableHUDEditorWidgets(event);
    this.staminaBarSlot.OnDisableHUDEditorWidgets(event);
    this.vehicleSummonSlot.OnDisableHUDEditorWidgets(event);
    this.inputHintSlot.OnDisableHUDEditorWidgets(event);
    this.wantedSlot.OnDisableHUDEditorWidgets(event);
    this.phoneCallAvatarSlot.OnDisableHUDEditorWidgets(event);
    this.weaponCrouchSlot.OnDisableHUDEditorWidgets(event);
    this.dpadSlot.OnDisableHUDEditorWidgets(event);
    this.healthbarSlot.OnDisableHUDEditorWidgets(event);
    this.phoneControlSlot.OnDisableHUDEditorWidgets(event);
    this.questNotificationsSlot.OnDisableHUDEditorWidgets(event);
    this.itemNotificationsSlot.OnDisableHUDEditorWidgets(event);
    this.carHudSlot.OnDisableHUDEditorWidgets(event);
    this.bossHealthbarSlot.OnDisableHUDEditorWidgets(event);
    this.dialogChoicesSlot.OnDisableHUDEditorWidgets(event);
    this.dialogSubtitlesSlot.OnDisableHUDEditorWidgets(event);

    if IsDefined(this.compassSlotScale) {
      this.compassSlotScale.OnDisableHUDEditorWidgets(event);
    };
    if IsDefined(this.compassSlotMarkers) {
      this.compassSlotMarkers.OnDisableHUDEditorWidgets(event);
    };
  };
}

@addMethod(inkGameController)
protected cb func OnResetHUDWidgets(event: ref<ResetAllHUDWidgets>) {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnResetHUDWidgets(event);
    this.questTrackerSlot.OnResetHUDWidgets(event);
    this.staminaBarSlot.OnResetHUDWidgets(event);
    this.vehicleSummonSlot.OnResetHUDWidgets(event);
    this.inputHintSlot.OnResetHUDWidgets(event);
    this.wantedSlot.OnResetHUDWidgets(event);
    this.phoneCallAvatarSlot.OnResetHUDWidgets(event);
    this.weaponCrouchSlot.OnResetHUDWidgets(event);
    this.dpadSlot.OnResetHUDWidgets(event);
    this.healthbarSlot.OnResetHUDWidgets(event);
    this.phoneControlSlot.OnResetHUDWidgets(event);
    this.questNotificationsSlot.OnResetHUDWidgets(event);
    this.itemNotificationsSlot.OnResetHUDWidgets(event);
    this.carHudSlot.OnResetHUDWidgets(event);
    this.bossHealthbarSlot.OnResetHUDWidgets(event);
    this.dialogChoicesSlot.OnResetHUDWidgets(event);
    this.dialogSubtitlesSlot.OnResetHUDWidgets(event);

    if IsDefined(this.compassSlotScale) {
      this.compassSlotScale.OnResetHUDWidgets(event);
    };
    if IsDefined(this.compassSlotMarkers) {
      this.compassSlotMarkers.OnResetHUDWidgets(event);
    };
  };
}

@addMethod(inkGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnAction(action, consumer);
    this.questTrackerSlot.OnAction(action, consumer);
    this.staminaBarSlot.OnAction(action, consumer);
    this.vehicleSummonSlot.OnAction(action, consumer);
    this.inputHintSlot.OnAction(action, consumer);
    this.wantedSlot.OnAction(action, consumer);
    this.phoneCallAvatarSlot.OnAction(action, consumer);
    this.weaponCrouchSlot.OnAction(action, consumer);
    this.dpadSlot.OnAction(action, consumer);
    this.healthbarSlot.OnAction(action, consumer);
    this.phoneControlSlot.OnAction(action, consumer);
    this.questNotificationsSlot.OnAction(action, consumer);
    this.itemNotificationsSlot.OnAction(action, consumer);
    this.carHudSlot.OnAction(action, consumer);
    this.bossHealthbarSlot.OnAction(action, consumer);
    this.dialogChoicesSlot.OnAction(action, consumer);
    this.dialogSubtitlesSlot.OnAction(action, consumer);

    if IsDefined(this.compassSlotScale) {
      this.compassSlotScale.OnAction(action, consumer);
    };
    if IsDefined(this.compassSlotMarkers) {
      this.compassSlotMarkers.OnAction(action, consumer);
    };
  };
}

@addField(inkGameController) let compatMode: HUDitorCompatMode;

@addField(inkGameController) let topRightSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let leftCenterSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let bottomRightHorizontalSlot: ref<inkCompoundWidget>;

@addField(inkGameController) let root: ref<inkCompoundWidget>;
@addField(inkGameController) let minimap: ref<inkWidget>;
@addField(inkGameController) let questList: ref<inkWidget>;
@addField(inkGameController) let staminabar: ref<inkWidget>;
@addField(inkGameController) let vehicleSummon: ref<inkWidget>;
@addField(inkGameController) let inputHint: ref<inkWidget>;
@addField(inkGameController) let wanted: ref<inkWidget>;
@addField(inkGameController) let phoneAvatar: ref<inkWidget>;
@addField(inkGameController) let dpad: ref<inkWidget>;
@addField(inkGameController) let healthbar: ref<inkWidget>;
@addField(inkGameController) let phoneControl: ref<inkWidget>;
@addField(inkGameController) let questNotifications: ref<inkWidget>;
@addField(inkGameController) let itemNotifications: ref<inkWidget>;
@addField(inkGameController) let carHud: ref<inkWidget>;
@addField(inkGameController) let bossHealthbar: ref<inkWidget>;
@addField(inkGameController) let interactionsHub: ref<inkCompoundWidget>;
@addField(inkGameController) let dialogChoices: ref<inkWidget>;
@addField(inkGameController) let dialogSubtitles: ref<inkWidget>;
// Spicy
@addField(inkGameController) let compassScale: ref<inkWidget>;
@addField(inkGameController) let compassMakers: ref<inkWidget>;

@if(!ModuleExists("e3hud"))
@addMethod(inkGameController)
private func InitBaseWidgets() -> Void {
    this.root = this.GetRootCompoundWidget();
    this.topRightSlot = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight")) as inkCompoundWidget;
    this.leftCenterSlot = this.root.GetWidgetByPath(inkWidgetPath.Build(n"LeftCenter")) as inkCompoundWidget;
    this.bottomRightHorizontalSlot = this.root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal")) as inkCompoundWidget;

    this.minimap = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"minimap")) as inkWidget;
    this.questList = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"quest_list")) as inkWidget;
    this.staminabar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"staminabar")) as inkWidget;
    this.vehicleSummon = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"vehicle_summon_notification")) as inkWidget;
    this.inputHint = this.root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"InputHint", n"input_hint")) as inkWidget;
    this.wanted = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRightWanted", n"wanted_bar")) as inkWidget;
    this.phoneAvatar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftPhone", n"phone")) as inkWidget;
    this.dpad = this.root.GetWidgetByPath(inkWidgetPath.Build(n"BottomLeft", n"dpad_hint")) as inkWidget;
    this.healthbar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeft", n"player_health_bar")) as inkWidget;
    this.phoneControl = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"PhoneCall") as inkWidget;
    this.questNotifications = this.leftCenterSlot.GetWidgetByIndex(1) as inkWidget;
    this.itemNotifications = this.leftCenterSlot.GetWidgetByIndex(0) as inkWidget;
    this.carHud = this.root.GetWidgetByPath(inkWidgetPath.Build(n"car hud")) as inkWidget;
    this.bossHealthbar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"boss_healthbar")) as inkWidget;
    this.interactionsHub = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"InteractionsHub") as inkCompoundWidget;
    this.dialogChoices = this.interactionsHub.GetWidgetByIndex(4) as inkWidget;
    this.dialogSubtitles  = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"Subtitles") as inkWidget;

    // Detect E3 Compass
    let scale: ref<inkWidget> = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"CompassCompat") as inkWidget;
    let markers: ref<inkWidget> = this.root.GetWidgetByPath(inkWidgetPath.Build(n"cumpass_mappins")) as inkWidget;
    if IsDefined(scale) {
      if IsDefined(markers) {
        this.compassScale = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"CompassCompat") as inkWidget;
        this.compassMakers = this.root.GetWidgetByPath(inkWidgetPath.Build(n"cumpass_mappins")) as inkWidget;
        this.compatMode = HUDitorCompatMode.E3CompassMinimap;
      } else {
        this.compassScale = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"CompassCompat") as inkWidget;
        this.compassMakers = this.root.GetWidgetByPath(inkWidgetPath.Build(n"minimap")) as inkWidget;
        this.compatMode = HUDitorCompatMode.E3CompassFaithful;
      };
    } else {
      this.compatMode = HUDitorCompatMode.Default;
    };
}

@if(ModuleExists("e3hud"))
@addMethod(inkGameController)
private func InitBaseWidgets() -> Void {
    this.root = this.GetRootCompoundWidget();
    this.topRightSlot = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight")) as inkCompoundWidget;
    this.leftCenterSlot = this.root.GetWidgetByPath(inkWidgetPath.Build(n"LeftCenter")) as inkCompoundWidget;
    this.bottomRightHorizontalSlot = this.root.GetWidgetByPath(inkWidgetPath.Build(n"BottomLeft")) as inkCompoundWidget;

    this.minimap = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"minimap")) as inkWidget;
    this.questList = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"quest_list")) as inkWidget;
    this.staminabar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"staminabar")) as inkWidget;
    this.vehicleSummon = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"vehicle_summon_notification")) as inkWidget;
    this.inputHint = this.root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"InputHint", n"input_hint")) as inkWidget;
    this.wanted = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRightWanted", n"wanted_bar")) as inkWidget;
    this.phoneAvatar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftPhone", n"phone")) as inkWidget;
    this.dpad = this.root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal", n"dpad_hint")) as inkWidget;
    this.healthbar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeft", n"player_health_bar")) as inkWidget;
    this.phoneControl = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"PhoneCall") as inkWidget;
    this.questNotifications = this.leftCenterSlot.GetWidgetByIndex(1) as inkWidget;
    this.itemNotifications = this.leftCenterSlot.GetWidgetByIndex(0) as inkWidget;
    this.carHud = this.root.GetWidgetByPath(inkWidgetPath.Build(n"car hud")) as inkWidget;
    this.bossHealthbar = this.root.GetWidgetByPath(inkWidgetPath.Build(n"boss_healthbar")) as inkWidget;
    this.interactionsHub = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"InteractionsHub") as inkCompoundWidget;
    this.dialogChoices = this.interactionsHub.GetWidgetByIndex(4) as inkWidget;
    this.dialogSubtitles  = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"Subtitles") as inkWidget;

    // Detect E3 Compass
    let scale: ref<inkWidget> = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"CompassCompat") as inkWidget;
    let markers: ref<inkWidget> = this.root.GetWidgetByPath(inkWidgetPath.Build(n"cumpass_mappins")) as inkWidget;
    if IsDefined(scale) {
      if IsDefined(markers) {
        this.compassScale = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"CompassCompat") as inkWidget;
        this.compassMakers = this.root.GetWidgetByPath(inkWidgetPath.Build(n"cumpass_mappins")) as inkWidget;
        this.compatMode = HUDitorCompatMode.E3CompassMinimapE3HUD;
      } else {
        this.compassScale = this.SearchForWidget(this.root, n"HUDMiddleWidget", n"CompassCompat") as inkWidget;
        this.compassMakers = this.root.GetWidgetByPath(inkWidgetPath.Build(n"minimap")) as inkWidget;
        this.compatMode = HUDitorCompatMode.E3CompassFaithfulE3HUD;
      };
    } else {
      this.compatMode = HUDitorCompatMode.E3HUD;
    };
}

@addMethod(inkGameController)
protected cb func OnHijackSlotsEvent(evt: ref<HijackSlotsEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {

    this.compatMode = HUDitorCompatMode.Default;
    this.InitBaseWidgets();

    let evt: ref<SetHUDitorCompatMode> = new SetHUDitorCompatMode();
    evt.mode = this.compatMode;
    GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(evt);

    this.minimapSlot = new HUDitorCustomSlot();
    this.minimapSlot.SetName(n"NewMinimap");
    this.minimapSlot.SetFitToContent(this.topRightSlot.GetFitToContent());
    this.minimapSlot.SetInteractive(false);
    this.minimapSlot.SetAffectsLayoutWhenHidden(false);
    this.minimapSlot.SetMargin(this.topRightSlot.GetMargin());
    this.minimapSlot.SetHAlign(this.topRightSlot.GetHAlign());
    this.minimapSlot.SetVAlign(this.topRightSlot.GetVAlign());
    this.minimapSlot.SetAnchor(this.topRightSlot.GetAnchor());
    this.minimapSlot.SetAnchorPoint(this.topRightSlot.GetAnchorPoint());
    this.minimapSlot.SetLayout(
      new inkWidgetLayout(
        this.topRightSlot.GetPadding(),
        this.topRightSlot.GetMargin(),
        this.topRightSlot.GetHAlign(),
        this.topRightSlot.GetVAlign(),
        this.topRightSlot.GetAnchor(),
        this.topRightSlot.GetAnchorPoint()
      )
    );

    this.minimap.Reparent(this.minimapSlot);
    this.minimapSlot.Reparent(this.root, 0);

    this.questTrackerSlot = new HUDitorCustomSlot();
    this.questTrackerSlot.SetName(n"NewTracker");
    this.questTrackerSlot.SetFitToContent(this.topRightSlot.GetFitToContent());
    this.questTrackerSlot.SetInteractive(false);
    this.questTrackerSlot.SetAffectsLayoutWhenHidden(false);
    this.questTrackerSlot.SetMargin(this.topRightSlot.GetMargin());
    this.questTrackerSlot.SetHAlign(this.topRightSlot.GetHAlign());
    this.questTrackerSlot.SetVAlign(this.topRightSlot.GetVAlign());
    this.questTrackerSlot.SetAnchor(this.topRightSlot.GetAnchor());
    this.questTrackerSlot.SetAnchorPoint(this.topRightSlot.GetAnchorPoint());
    this.questTrackerSlot.SetLayout(
      new inkWidgetLayout(
        this.topRightSlot.GetPadding(),
        this.topRightSlot.GetMargin(),
        this.topRightSlot.GetHAlign(),
        this.topRightSlot.GetVAlign(),
        this.topRightSlot.GetAnchor(),
        this.topRightSlot.GetAnchorPoint()
      )
    );

    this.questList.Reparent(this.questTrackerSlot);
    this.questTrackerSlot.Reparent(this.root, 1);

    this.staminaBarSlot = new HUDitorCustomSlot();
    this.staminaBarSlot.SetName(n"NewStaminaBar");
    this.staminaBarSlot.SetFitToContent(true);
    this.staminaBarSlot.SetInteractive(false);
    this.staminaBarSlot.SetAffectsLayoutWhenHidden(false);
    this.staminaBarSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    this.staminaBarSlot.SetHAlign(inkEHorizontalAlign.Center);
    this.staminaBarSlot.SetVAlign(inkEVerticalAlign.Top);
    this.staminaBarSlot.SetAnchor(inkEAnchor.TopCenter);
    this.staminaBarSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
    this.staminaBarSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        inkEHorizontalAlign.Center,
        inkEVerticalAlign.Top,
        inkEAnchor.TopCenter,
        new Vector2(0.5, 0.5)
      )
    );

    this.staminabar.Reparent(this.staminaBarSlot);
    this.staminaBarSlot.Reparent(this.root, 2);

    this.vehicleSummonSlot = new HUDitorCustomSlot();
    this.vehicleSummonSlot.SetName(n"NewVehicleSummon");
    this.vehicleSummonSlot.SetFitToContent(true);
    this.vehicleSummonSlot.SetInteractive(false);
    this.vehicleSummonSlot.SetAffectsLayoutWhenHidden(false);
    this.vehicleSummonSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    this.vehicleSummonSlot.SetHAlign(inkEHorizontalAlign.Center);
    this.vehicleSummonSlot.SetVAlign(inkEVerticalAlign.Center);
    this.vehicleSummonSlot.SetAnchor(inkEAnchor.Centered);
    this.vehicleSummonSlot.SetAnchorPoint(new Vector2(0.5, 1.0));
    this.vehicleSummonSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        inkEHorizontalAlign.Center,
        inkEVerticalAlign.Bottom,
        inkEAnchor.Centered,
        new Vector2(0.5, 1.0)
      )
    );

    this.vehicleSummon.Reparent(this.vehicleSummonSlot);
    this.vehicleSummonSlot.Reparent(this.root, 3);

    this.inputHintSlot = new HUDitorCustomSlot();
    this.inputHintSlot.SetName(n"NewInputHint");
    this.inputHintSlot.SetFitToContent(true);
    this.inputHintSlot.SetInteractive(false);
    this.inputHintSlot.SetAffectsLayoutWhenHidden(false);
    this.inputHintSlot.SetMargin(new inkMargin(0.0, 60.0, 50.0, 0.0));
    this.inputHintSlot.SetHAlign(inkEHorizontalAlign.Right);
    this.inputHintSlot.SetVAlign(inkEVerticalAlign.Center);
    this.inputHintSlot.SetAnchor(inkEAnchor.CenterRight);
    this.inputHintSlot.SetAnchorPoint(new Vector2(1.0, 1.0));
    this.inputHintSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 60.0, 50.0, 0.0),
        inkEHorizontalAlign.Right,
        inkEVerticalAlign.Center,
        inkEAnchor.CenterRight,
        new Vector2(1.0, 1.0)
      )
    );

    this.inputHint.Reparent(this.inputHintSlot);
    this.inputHintSlot.Reparent(this.root, 4);

    this.wantedSlot = new HUDitorCustomSlot();
    this.wantedSlot.SetName(n"NewWanted");
    this.wantedSlot.SetFitToContent(true);
    this.wantedSlot.SetInteractive(false);
    this.wantedSlot.SetAffectsLayoutWhenHidden(false);
    this.wantedSlot.SetMargin(new inkMargin(0.0, 60.0, 160.0, 0.0));
    this.wantedSlot.SetHAlign(inkEHorizontalAlign.Right);
    this.wantedSlot.SetVAlign(inkEVerticalAlign.Center);
    this.wantedSlot.SetAnchor(inkEAnchor.CenterRight);
    this.wantedSlot.SetAnchorPoint(new Vector2(1.0, 0.0));
    this.wantedSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 60.0, 160.0, 0.0),
        inkEHorizontalAlign.Right,
        inkEVerticalAlign.Center,
        inkEAnchor.CenterRight,
        new Vector2(1.0, 0.0)
      )
    );

    this.wanted.Reparent(this.wantedSlot);
    this.wantedSlot.Reparent(this.root, 5);

    this.phoneCallAvatarSlot = new HUDitorCustomSlot();
    this.phoneCallAvatarSlot.SetName(n"NewPhoneAvatar");
    this.phoneCallAvatarSlot.SetFitToContent(true);
    this.phoneCallAvatarSlot.SetInteractive(false);
    this.phoneCallAvatarSlot.SetAffectsLayoutWhenHidden(false);
    this.phoneCallAvatarSlot.SetMargin(new inkMargin(60.0, 300.0, 0.0, 0.0));
    this.phoneCallAvatarSlot.SetHAlign(inkEHorizontalAlign.Left);
    this.phoneCallAvatarSlot.SetVAlign(inkEVerticalAlign.Top);
    this.phoneCallAvatarSlot.SetAnchor(inkEAnchor.TopLeft);
    this.phoneCallAvatarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
    this.phoneCallAvatarSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(60.0, 300.0, 0.0, 0.0),
        inkEHorizontalAlign.Left,
        inkEVerticalAlign.Top,
        inkEAnchor.TopLeft,
        new Vector2(0.0, 0.0)
      )
    );

    this.phoneAvatar.Reparent(this.phoneCallAvatarSlot);
    this.phoneCallAvatarSlot.Reparent(this.root, 6);

    this.questNotificationsSlot = new HUDitorCustomSlot();
    this.questNotificationsSlot.SetName(n"NewQuestNotifications");
    this.questNotificationsSlot.SetFitToContent(this.leftCenterSlot.GetFitToContent());
    this.questNotificationsSlot.SetInteractive(false);
    this.questNotificationsSlot.SetAffectsLayoutWhenHidden(false);
    this.questNotificationsSlot.SetMargin(this.leftCenterSlot.GetMargin());
    this.questNotificationsSlot.SetHAlign(this.leftCenterSlot.GetHAlign());
    this.questNotificationsSlot.SetVAlign(this.leftCenterSlot.GetVAlign());
    this.questNotificationsSlot.SetAnchor(this.leftCenterSlot.GetAnchor());
    this.questNotificationsSlot.SetAnchorPoint(this.leftCenterSlot.GetAnchorPoint());
    this.questNotificationsSlot.SetLayout(
      new inkWidgetLayout(
        this.leftCenterSlot.GetPadding(),
        this.leftCenterSlot.GetMargin(),
        this.leftCenterSlot.GetHAlign(),
        this.leftCenterSlot.GetVAlign(),
        this.leftCenterSlot.GetAnchor(),
        this.leftCenterSlot.GetAnchorPoint()
      )
    );

    this.questNotifications.Reparent(this.questNotificationsSlot);
    this.questNotificationsSlot.Reparent(this.root, 7);

    this.itemNotificationsSlot = new HUDitorCustomSlot();
    this.itemNotificationsSlot.SetName(n"NewItemNotifications");
    this.itemNotificationsSlot.SetFitToContent(this.leftCenterSlot.GetFitToContent());
    this.itemNotificationsSlot.SetInteractive(false);
    this.itemNotificationsSlot.SetAffectsLayoutWhenHidden(false);
    this.itemNotificationsSlot.SetMargin(this.leftCenterSlot.GetMargin());
    this.itemNotificationsSlot.SetHAlign(this.leftCenterSlot.GetHAlign());
    this.itemNotificationsSlot.SetVAlign(this.leftCenterSlot.GetVAlign());
    this.itemNotificationsSlot.SetAnchor(this.leftCenterSlot.GetAnchor());
    this.itemNotificationsSlot.SetAnchorPoint(this.leftCenterSlot.GetAnchorPoint());
    this.itemNotificationsSlot.SetLayout(
      new inkWidgetLayout(
        this.leftCenterSlot.GetPadding(),
        this.leftCenterSlot.GetMargin(),
        this.leftCenterSlot.GetHAlign(),
        this.leftCenterSlot.GetVAlign(),
        this.leftCenterSlot.GetAnchor(),
        this.leftCenterSlot.GetAnchorPoint()
      )
    );

    this.itemNotifications.Reparent(this.itemNotificationsSlot);
    this.itemNotificationsSlot.Reparent(this.root, 8);

    // Reparent BottomRightHorizontal to custom slot
    this.weaponCrouchSlot = new HUDitorCustomSlot();
    this.weaponCrouchSlot.SetName(n"NewWeaponCrouch");
    this.weaponCrouchSlot.SetFitToContent(true);
    this.weaponCrouchSlot.SetInteractive(false);
    this.weaponCrouchSlot.SetAffectsLayoutWhenHidden(false);
    this.weaponCrouchSlot.SetMargin(new inkMargin(0.0, 0.0, 40.0, 100.0));
    this.weaponCrouchSlot.SetHAlign(inkEHorizontalAlign.Right);
    this.weaponCrouchSlot.SetVAlign(inkEVerticalAlign.Bottom);
    this.weaponCrouchSlot.SetAnchor(inkEAnchor.BottomRight);
    this.weaponCrouchSlot.SetAnchorPoint(new Vector2(1.0, 1.0));
    this.weaponCrouchSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 40.0, 100.0),
        inkEHorizontalAlign.Right,
        inkEVerticalAlign.Bottom,
        inkEAnchor.BottomRight,
        new Vector2(1.0, 1.0)
      )
    );

    this.bottomRightHorizontalSlot.Reparent(this.weaponCrouchSlot);
    this.weaponCrouchSlot.Reparent(this.root, 9);

    this.dpadSlot = new HUDitorCustomSlot();
    this.dpadSlot.SetName(n"NewDpad");
    this.dpadSlot.SetFitToContent(true);
    this.dpadSlot.SetInteractive(false);
    this.dpadSlot.SetAffectsLayoutWhenHidden(false);
    this.dpadSlot.SetMargin(new inkMargin(20.0, 0.0, 0.0, 50.0));
    this.dpadSlot.SetHAlign(inkEHorizontalAlign.Fill);
    this.dpadSlot.SetVAlign(inkEVerticalAlign.Fill);
    this.dpadSlot.SetAnchor(inkEAnchor.BottomLeft);
    this.dpadSlot.SetAnchorPoint(new Vector2(0.0, 1.0));
    this.dpadSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(20.0, 0.0, 0.0, 50.0),
        inkEHorizontalAlign.Fill,
        inkEVerticalAlign.Fill,
        inkEAnchor.BottomLeft,
        new Vector2(0.0, 1.0)
      )
    );

    this.dpad.Reparent(this.dpadSlot);
    this.dpadSlot.Reparent(this.root, 10);

    this.healthbarSlot = new HUDitorCustomSlot();
    this.healthbarSlot.SetName(n"NewHealthBar");
    this.healthbarSlot.SetFitToContent(true);
    this.healthbarSlot.SetInteractive(false);
    this.healthbarSlot.SetAffectsLayoutWhenHidden(false);
    this.healthbarSlot.SetMargin(new inkMargin(30.0, 50.0, 0.0, 0.0));
    this.healthbarSlot.SetHAlign(inkEHorizontalAlign.Left);
    this.healthbarSlot.SetVAlign(inkEVerticalAlign.Top);
    this.healthbarSlot.SetAnchor(inkEAnchor.TopLeft);
    this.healthbarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
    this.healthbarSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(30.0, 50.0, 0.0, 0.0),
        inkEHorizontalAlign.Left,
        inkEVerticalAlign.Top,
        inkEAnchor.TopLeft,
        new Vector2(0.0, 0.0)
      )
    );

    this.healthbar.Reparent(this.healthbarSlot);
    this.healthbarSlot.Reparent(this.root, 11);

    this.phoneControlSlot = new HUDitorCustomSlot();
    this.phoneControlSlot.SetName(n"NewPhoneControl");
    this.phoneControlSlot.SetFitToContent(true);
    this.phoneControlSlot.SetInteractive(false);
    this.phoneControlSlot.SetAffectsLayoutWhenHidden(false);
    this.phoneControlSlot.SetMargin(new inkMargin(0.0, 100.0, 0.0, 0.0));
    this.phoneControlSlot.SetHAlign(inkEHorizontalAlign.Center);
    this.phoneControlSlot.SetVAlign(inkEVerticalAlign.Top);
    this.phoneControlSlot.SetAnchor(inkEAnchor.TopCenter);
    this.phoneControlSlot.SetScale(new Vector2(0.666667, 0.666667));
    this.phoneControlSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
    this.phoneControlSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 100.0, 0.0, 0.0),
        inkEHorizontalAlign.Center,
        inkEVerticalAlign.Top,
        inkEAnchor.TopCenter,
        new Vector2(0.5, 0.5)
      )
    );

    this.phoneControl.Reparent(this.phoneControlSlot);
    this.phoneControlSlot.Reparent(this.root, 12);

    this.carHudSlot = new HUDitorCustomSlot();
    this.carHudSlot.SetName(n"NewCarHud");
    this.carHudSlot.SetFitToContent(true);
    this.carHudSlot.SetInteractive(false);
    this.carHudSlot.SetAffectsLayoutWhenHidden(false);
    this.carHudSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    this.carHudSlot.SetHAlign(inkEHorizontalAlign.Center);
    this.carHudSlot.SetVAlign(inkEVerticalAlign.Bottom);
    this.carHudSlot.SetAnchor(inkEAnchor.BottomCenter);
    this.carHudSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
    this.carHudSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        inkEHorizontalAlign.Center,
        inkEVerticalAlign.Bottom,
        inkEAnchor.BottomCenter,
        new Vector2(0.5, 0.5)
      )
    );

    this.carHud.Reparent(this.carHudSlot);
    this.carHudSlot.Reparent(this.root, 13);

    this.bossHealthbarSlot = new HUDitorCustomSlot();
    this.bossHealthbarSlot.SetName(n"NewBossHealthbar");
    this.bossHealthbarSlot.SetFitToContent(true);
    this.bossHealthbarSlot.SetInteractive(false);
    this.bossHealthbarSlot.SetAffectsLayoutWhenHidden(false);
    this.bossHealthbarSlot.SetMargin(new inkMargin(60.0, 100.0, 0.0, 0.0));
    this.bossHealthbarSlot.SetHAlign(inkEHorizontalAlign.Fill);
    this.bossHealthbarSlot.SetVAlign(inkEVerticalAlign.Fill);
    this.bossHealthbarSlot.SetAnchor(inkEAnchor.TopCenter);
    this.bossHealthbarSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
    this.bossHealthbarSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(60.0, 100.0, 0.0, 0.0),
        inkEHorizontalAlign.Fill,
        inkEVerticalAlign.Fill,
        inkEAnchor.TopCenter,
        new Vector2(0.5, 0.5)
      )
    );

    this.bossHealthbar.Reparent(this.bossHealthbarSlot);
    this.bossHealthbarSlot.Reparent(this.root, 14);

    this.dialogChoicesSlot = new HUDitorCustomSlot();
    this.dialogChoicesSlot.SetName(n"NewDialogChoices");
    this.dialogChoicesSlot.SetFitToContent(true);
    this.dialogChoicesSlot.SetInteractive(false);
    this.dialogChoicesSlot.SetAffectsLayoutWhenHidden(false);
    this.dialogChoicesSlot.SetMargin(new inkMargin(0.0, 220.0, 0.0, 0.0));
    this.dialogChoicesSlot.SetHAlign(inkEHorizontalAlign.Fill);
    this.dialogChoicesSlot.SetVAlign(inkEVerticalAlign.Fill);
    this.dialogChoicesSlot.SetAnchor(inkEAnchor.Centered);
    this.dialogChoicesSlot.SetAnchorPoint(new Vector2(0.5, 0.0));
    this.dialogChoicesSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 220.0, 0.0, 0.0),
        inkEHorizontalAlign.Fill,
        inkEVerticalAlign.Fill,
        inkEAnchor.Centered,
        new Vector2(0.5, 0.0)
      )
    );

    this.dialogChoices.Reparent(this.dialogChoicesSlot);
    this.dialogChoicesSlot.Reparent(this.root, 15);

    this.dialogSubtitlesSlot = new HUDitorCustomSlot();
    this.dialogSubtitlesSlot.SetName(n"NewDialogSubtitles");
    this.dialogSubtitlesSlot.SetFitToContent(false);
    this.dialogSubtitlesSlot.SetInteractive(false);
    this.dialogSubtitlesSlot.SetAffectsLayoutWhenHidden(false);
    this.dialogSubtitlesSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 16.0));
    this.dialogSubtitlesSlot.SetHAlign(inkEHorizontalAlign.Fill);
    this.dialogSubtitlesSlot.SetVAlign(inkEVerticalAlign.Fill);
    this.dialogSubtitlesSlot.SetAnchor(inkEAnchor.BottomFillHorizontaly);
    this.dialogSubtitlesSlot.SetAnchorPoint(new Vector2(0.0, 1.0));
    this.dialogSubtitlesSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 16.0),
        inkEHorizontalAlign.Fill,
        inkEVerticalAlign.Fill,
        inkEAnchor.BottomFillHorizontaly,
        new Vector2(0.0, 1.0)
      )
    );

    this.dialogSubtitles.Reparent(this.dialogSubtitlesSlot);
    this.dialogSubtitlesSlot.Reparent(this.root, 16);

    // Spicy
    if IsDefined(this.compassScale) {
      this.compassSlotScale = new HUDitorCustomSlot();
      this.compassSlotScale.SetName(n"NewCompassScale");
      this.compassSlotScale.SetFitToContent(true);
      this.compassSlotScale.SetInteractive(false);
      this.compassSlotScale.SetAffectsLayoutWhenHidden(false);
      this.compassSlotScale.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
      this.compassSlotScale.SetHAlign(inkEHorizontalAlign.Center);
      this.compassSlotScale.SetVAlign(inkEVerticalAlign.Center);
      this.compassSlotScale.SetAnchor(inkEAnchor.Centered);
      this.compassSlotScale.SetScale(new Vector2(0.666667, 0.666667));
      this.compassSlotScale.SetAnchorPoint(new Vector2(0.5, 0.5));
      this.compassSlotScale.SetLayout(
        new inkWidgetLayout(
          new inkMargin(0.0, 0.0, 0.0, 0.0),
          new inkMargin(0.0, 0.0, 0.0, 0.0),
          inkEHorizontalAlign.Center,
          inkEVerticalAlign.Center,
          inkEAnchor.Centered,
          new Vector2(0.5, 0.5)
        )
      );

      this.compassScale.Reparent(this.compassSlotScale);
      this.compassSlotScale.Reparent(this.root, 17);
    };

    if IsDefined(this.compassMakers) {
      this.compassSlotMarkers = new HUDitorCustomSlot();
      this.compassSlotMarkers.SetName(n"NewCompassMarkers");
      this.compassSlotMarkers.SetFitToContent(true);
      this.compassSlotMarkers.SetInteractive(false);
      this.compassSlotMarkers.SetAffectsLayoutWhenHidden(false);
      this.compassSlotMarkers.SetMargin(new inkMargin(0.0, 15.0, 0.0, 0.0));
      this.compassSlotMarkers.SetHAlign(inkEHorizontalAlign.Fill);
      this.compassSlotMarkers.SetVAlign(inkEVerticalAlign.Fill);
      this.compassSlotMarkers.SetAnchor(inkEAnchor.TopCenter);
      this.compassSlotMarkers.SetAnchorPoint(new Vector2(0.5, 0.5));
      this.compassSlotMarkers.SetLayout(
        new inkWidgetLayout(
          new inkMargin(0.0, 0.0, 0.0, 0.0),
          new inkMargin(0.0, 15.0, 0.0, 0.0),
          inkEHorizontalAlign.Fill,
          inkEVerticalAlign.Fill,
          inkEAnchor.TopCenter,
          new Vector2(0.5, 0.5)
        )
      );

      this.compassMakers.Reparent(this.compassSlotMarkers);
      this.compassSlotMarkers.Reparent(this.root, 18);
    };
  };
}


// -- Utils

@addMethod(inkGameController)
private func SearchForWidget(node: ref<inkCompoundWidget>, first: CName, second: CName) -> ref<inkWidget> {
  for compound in this.GetCompounds(node, first) {
    let widget: ref<inkWidget> = compound.GetWidget(second);
    if IsDefined(widget) {
      return widget;
    };
  };
  return null;
}

@addMethod(inkGameController)
private func GetCompounds(root: ref<inkCompoundWidget>, first: CName) -> array<ref<inkCompoundWidget>> {
  let result: array<ref<inkCompoundWidget>>;
  let numChild: Int32 = root.GetNumChildren();
  let compound: ref<inkCompoundWidget>;
  let i: Int32 = 0;
  while i < numChild {
    compound = root.GetWidgetByIndex(i) as inkCompoundWidget;
    if IsDefined(compound) && Equals(compound.GetName(), first) {
      ArrayPush(result, compound);
    };
    i += 1;
  };
  return result;
}

// -- Misc

// Reparent dialog window to make it moveable
@wrapMethod(InteractionsHubGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dialogContainer: ref<inkWidget> = root.GetWidget(n"botWidgets/hubVert");
  root.SetName(n"InteractionsHub");
  dialogContainer.SetName(n"DialogChoicesWidget");
  dialogContainer.Reparent(root);
}

// Rename subtitles controller
@wrapMethod(SubtitlesGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.GetRootCompoundWidget().SetName(n"Subtitles");
}

// Compass fixes
@addField(inkWidget)
native let parentWidget: wref<inkWidget>;

@addMethod(CompassController)
protected cb func OnInitialize() -> Bool {
  this.GetRootCompoundWidget().parentWidget.SetName(n"CompassCompat");
}
