@addField(inkGameController) let minimapSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let questTrackerSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let wantedSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let questNotificationsSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let itemNotificationsSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let vehicleSummonSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let weaponRosterSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let crouchIndicatorSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let dpadSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let healthbarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let staminaBarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let phoneCallAvatarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let phoneControlSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let inputHintSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let carHudSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let bossHealthbarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let dialogChoicesSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) let dialogSubtitlesSlot: wref<HUDitorCustomSlot>;

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
    this.wantedSlot.OnGameSessionInitialized(event);
    this.questNotificationsSlot.OnGameSessionInitialized(event);
    this.itemNotificationsSlot.OnGameSessionInitialized(event);
    this.vehicleSummonSlot.OnGameSessionInitialized(event);
    this.weaponRosterSlot.OnGameSessionInitialized(event);
    this.crouchIndicatorSlot.OnGameSessionInitialized(event);
    this.dpadSlot.OnGameSessionInitialized(event);
    this.healthbarSlot.OnGameSessionInitialized(event);
    this.staminaBarSlot.OnGameSessionInitialized(event);
    this.phoneCallAvatarSlot.OnGameSessionInitialized(event);
    this.phoneControlSlot.OnGameSessionInitialized(event);
    this.inputHintSlot.OnGameSessionInitialized(event);
    this.carHudSlot.OnGameSessionInitialized(event);
    this.bossHealthbarSlot.OnGameSessionInitialized(event);
    this.dialogChoicesSlot.OnGameSessionInitialized(event);
    this.dialogSubtitlesSlot.OnGameSessionInitialized(event);
  };
}

@addMethod(inkGameController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidget>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnEnableHUDEditorWidget(event);
    this.questTrackerSlot.OnEnableHUDEditorWidget(event);
    this.wantedSlot.OnEnableHUDEditorWidget(event);
    this.questNotificationsSlot.OnEnableHUDEditorWidget(event);
    this.itemNotificationsSlot.OnEnableHUDEditorWidget(event);
    this.vehicleSummonSlot.OnEnableHUDEditorWidget(event);
    this.weaponRosterSlot.OnEnableHUDEditorWidget(event);
    this.crouchIndicatorSlot.OnEnableHUDEditorWidget(event);
    this.dpadSlot.OnEnableHUDEditorWidget(event);
    this.healthbarSlot.OnEnableHUDEditorWidget(event);
    this.staminaBarSlot.OnEnableHUDEditorWidget(event);
    this.phoneCallAvatarSlot.OnEnableHUDEditorWidget(event);
    this.phoneControlSlot.OnEnableHUDEditorWidget(event);
    this.inputHintSlot.OnEnableHUDEditorWidget(event);
    this.carHudSlot.OnEnableHUDEditorWidget(event);
    this.bossHealthbarSlot.OnEnableHUDEditorWidget(event);
    this.dialogChoicesSlot.OnEnableHUDEditorWidget(event);
    this.dialogSubtitlesSlot.OnEnableHUDEditorWidget(event);
  };
}

@addMethod(inkGameController)
protected cb func OnDisableHUDEditorWidgets(event: ref<DisableHUDEditor>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnDisableHUDEditorWidgets(event);
    this.questTrackerSlot.OnDisableHUDEditorWidgets(event);
    this.wantedSlot.OnDisableHUDEditorWidgets(event);
    this.questNotificationsSlot.OnDisableHUDEditorWidgets(event);
    this.itemNotificationsSlot.OnDisableHUDEditorWidgets(event);
    this.vehicleSummonSlot.OnDisableHUDEditorWidgets(event);
    this.weaponRosterSlot.OnDisableHUDEditorWidgets(event);
    this.crouchIndicatorSlot.OnDisableHUDEditorWidgets(event);
    this.dpadSlot.OnDisableHUDEditorWidgets(event);
    this.healthbarSlot.OnDisableHUDEditorWidgets(event);
    this.staminaBarSlot.OnDisableHUDEditorWidgets(event);
    this.phoneCallAvatarSlot.OnDisableHUDEditorWidgets(event);
    this.phoneControlSlot.OnDisableHUDEditorWidgets(event);
    this.inputHintSlot.OnDisableHUDEditorWidgets(event);
    this.carHudSlot.OnDisableHUDEditorWidgets(event);
    this.bossHealthbarSlot.OnDisableHUDEditorWidgets(event);
    this.dialogChoicesSlot.OnDisableHUDEditorWidgets(event);
    this.dialogSubtitlesSlot.OnDisableHUDEditorWidgets(event);
  };
}

@addMethod(inkGameController)
protected cb func OnResetHUDWidgets(event: ref<ResetAllHUDWidgets>) {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnResetHUDWidgets(event);
    this.questTrackerSlot.OnResetHUDWidgets(event);
    this.wantedSlot.OnResetHUDWidgets(event);
    this.questNotificationsSlot.OnResetHUDWidgets(event);
    this.itemNotificationsSlot.OnResetHUDWidgets(event);
    this.vehicleSummonSlot.OnResetHUDWidgets(event);
    this.weaponRosterSlot.OnResetHUDWidgets(event);
    this.crouchIndicatorSlot.OnResetHUDWidgets(event);
    this.dpadSlot.OnResetHUDWidgets(event);
    this.healthbarSlot.OnResetHUDWidgets(event);
    this.staminaBarSlot.OnResetHUDWidgets(event);
    this.phoneCallAvatarSlot.OnResetHUDWidgets(event);
    this.phoneControlSlot.OnResetHUDWidgets(event);
    this.inputHintSlot.OnResetHUDWidgets(event);
    this.carHudSlot.OnResetHUDWidgets(event);
    this.bossHealthbarSlot.OnResetHUDWidgets(event);
    this.dialogChoicesSlot.OnResetHUDWidgets(event);
    this.dialogSubtitlesSlot.OnResetHUDWidgets(event);
  };
}

@addMethod(inkGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnAction(action, consumer);
    this.questTrackerSlot.OnAction(action, consumer);
    this.wantedSlot.OnAction(action, consumer);
    this.questNotificationsSlot.OnAction(action, consumer);
    this.itemNotificationsSlot.OnAction(action, consumer);
    this.vehicleSummonSlot.OnAction(action, consumer);
    this.weaponRosterSlot.OnAction(action, consumer);
    this.crouchIndicatorSlot.OnAction(action, consumer);
    this.dpadSlot.OnAction(action, consumer);
    this.healthbarSlot.OnAction(action, consumer);
    this.staminaBarSlot.OnAction(action, consumer);
    this.phoneCallAvatarSlot.OnAction(action, consumer);
    this.phoneControlSlot.OnAction(action, consumer);
    this.inputHintSlot.OnAction(action, consumer);
    this.carHudSlot.OnAction(action, consumer);
    this.bossHealthbarSlot.OnAction(action, consumer);
    this.dialogChoicesSlot.OnAction(action, consumer);
    this.dialogSubtitlesSlot.OnAction(action, consumer);
  };
}


@addMethod(inkGameController)
private func CreateCustomSlots() -> Void {
  let uiSystem: wref<UISystem> = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
  let root: ref<inkCompoundWidget> = uiSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();

  let minimapSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  minimapSlot.SetName(n"NewMinimap");
  minimapSlot.SetFitToContent(true);
  minimapSlot.SetInteractive(false);
  minimapSlot.SetAffectsLayoutWhenHidden(false);
  minimapSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  minimapSlot.SetHAlign(inkEHorizontalAlign.Right);
  minimapSlot.SetVAlign(inkEVerticalAlign.Top);
  minimapSlot.SetAnchor(inkEAnchor.TopRight);
  minimapSlot.SetAnchorPoint(new Vector2(1.0, 0.0));
  minimapSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      inkEHorizontalAlign.Right,
      inkEVerticalAlign.Top,
      inkEAnchor.TopRight,
      new Vector2(1.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewMinimap");
  minimapSlot.Reparent(root, 0);
  this.minimapSlot = minimapSlot;

  let questTrackerSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  questTrackerSlot.SetName(n"NewTracker");
  questTrackerSlot.SetFitToContent(true);
  questTrackerSlot.SetInteractive(false);
  questTrackerSlot.SetAffectsLayoutWhenHidden(false);
  questTrackerSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  questTrackerSlot.SetHAlign(inkEHorizontalAlign.Right);
  questTrackerSlot.SetVAlign(inkEVerticalAlign.Top);
  questTrackerSlot.SetAnchor(inkEAnchor.TopRight);
  questTrackerSlot.SetAnchorPoint(new Vector2(1.0, 0.0));
  questTrackerSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      inkEHorizontalAlign.Right,
      inkEVerticalAlign.Top,
      inkEAnchor.TopRight,
      new Vector2(1.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewTracker");
  questTrackerSlot.Reparent(root, 1);
  this.questTrackerSlot = questTrackerSlot;

  let wantedSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  wantedSlot.SetName(n"NewWanted");
  wantedSlot.SetFitToContent(true);
  wantedSlot.SetInteractive(false);
  wantedSlot.SetAffectsLayoutWhenHidden(false);
  wantedSlot.SetMargin(new inkMargin(0.0, 60.0, 160.0, 0.0));
  wantedSlot.SetHAlign(inkEHorizontalAlign.Center);
  wantedSlot.SetVAlign(inkEVerticalAlign.Center);
  wantedSlot.SetAnchor(inkEAnchor.Centered);
  wantedSlot.SetAnchorPoint(new Vector2(1.0, 0.0));
  wantedSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      inkEHorizontalAlign.Center,
      inkEVerticalAlign.Center,
      inkEAnchor.Centered,
      new Vector2(1.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewWanted");
  wantedSlot.Reparent(root, 2);
  this.wantedSlot = wantedSlot;

  let questNotificationsSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  questNotificationsSlot.SetName(n"NewQuestNotifications");
  questNotificationsSlot.SetFitToContent(true);
  questNotificationsSlot.SetInteractive(false);
  questNotificationsSlot.SetAffectsLayoutWhenHidden(false);
  questNotificationsSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 120.0));
  questNotificationsSlot.SetHAlign(inkEHorizontalAlign.Left);
  questNotificationsSlot.SetVAlign(inkEVerticalAlign.Center);
  questNotificationsSlot.SetAnchor(inkEAnchor.CenterLeft);
  questNotificationsSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
  questNotificationsSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 120.0),
      inkEHorizontalAlign.Left,
      inkEVerticalAlign.Center,
      inkEAnchor.CenterLeft,
      new Vector2(0.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewQuestNotifications");
  questNotificationsSlot.Reparent(root, 3);
  this.questNotificationsSlot = questNotificationsSlot;

  let itemNotificationsSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  itemNotificationsSlot.SetName(n"NewItemNotifications");
  itemNotificationsSlot.SetFitToContent(true);
  itemNotificationsSlot.SetInteractive(false);
  itemNotificationsSlot.SetAffectsLayoutWhenHidden(false);
  itemNotificationsSlot.SetMargin(new inkMargin(0.0, 120.0, 0.0, 0.0));
  itemNotificationsSlot.SetHAlign(inkEHorizontalAlign.Left);
  itemNotificationsSlot.SetVAlign(inkEVerticalAlign.Center);
  itemNotificationsSlot.SetAnchor(inkEAnchor.CenterLeft);
  itemNotificationsSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
  itemNotificationsSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 120.0, 0.0, 0.0),
      inkEHorizontalAlign.Left,
      inkEVerticalAlign.Center,
      inkEAnchor.CenterLeft,
      new Vector2(0.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewItemNotifications");
  itemNotificationsSlot.Reparent(root, 4);
  this.itemNotificationsSlot = itemNotificationsSlot;

  let vehicleSummonSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  vehicleSummonSlot.SetName(n"NewVehicleSummon");
  vehicleSummonSlot.SetFitToContent(true);
  vehicleSummonSlot.SetInteractive(false);
  vehicleSummonSlot.SetAffectsLayoutWhenHidden(false);
  vehicleSummonSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  vehicleSummonSlot.SetHAlign(inkEHorizontalAlign.Center);
  vehicleSummonSlot.SetVAlign(inkEVerticalAlign.Center);
  vehicleSummonSlot.SetAnchor(inkEAnchor.Centered);
  vehicleSummonSlot.SetAnchorPoint(new Vector2(0.5, 1.0));
  vehicleSummonSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      inkEHorizontalAlign.Center,
      inkEVerticalAlign.Bottom,
      inkEAnchor.Centered,
      new Vector2(0.5, 1.0)
    )
  );

  root.RemoveChildByName(n"NewVehicleSummon");
  vehicleSummonSlot.Reparent(root, 5);
  this.vehicleSummonSlot = vehicleSummonSlot;

  let weaponRosterSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  weaponRosterSlot.SetName(n"NewWeaponRoster");
  weaponRosterSlot.SetFitToContent(true);
  weaponRosterSlot.SetInteractive(false);
  weaponRosterSlot.SetAffectsLayoutWhenHidden(false);
  weaponRosterSlot.SetMargin(new inkMargin(0.0, 0.0, 40.0, 100.0));
  weaponRosterSlot.SetHAlign(inkEHorizontalAlign.Right);
  weaponRosterSlot.SetVAlign(inkEVerticalAlign.Bottom);
  weaponRosterSlot.SetAnchor(inkEAnchor.BottomRight);
  weaponRosterSlot.SetAnchorPoint(new Vector2(1.0, 1.0));
  weaponRosterSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 40.0, 100.0),
      inkEHorizontalAlign.Right,
      inkEVerticalAlign.Bottom,
      inkEAnchor.BottomRight,
      new Vector2(1.0, 1.0)
    )
  );

  root.RemoveChildByName(n"NewWeaponRoster");
  weaponRosterSlot.Reparent(root, 6);
  this.weaponRosterSlot = weaponRosterSlot;

  let crouchIndicatorSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  crouchIndicatorSlot.SetName(n"NewCrouchIndicator");
  crouchIndicatorSlot.SetFitToContent(true);
  crouchIndicatorSlot.SetInteractive(false);
  crouchIndicatorSlot.SetAffectsLayoutWhenHidden(false);
  crouchIndicatorSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 100.0));
  crouchIndicatorSlot.SetHAlign(inkEHorizontalAlign.Right);
  crouchIndicatorSlot.SetVAlign(inkEVerticalAlign.Bottom);
  crouchIndicatorSlot.SetAnchor(inkEAnchor.BottomRight);
  crouchIndicatorSlot.SetAnchorPoint(new Vector2(1.0, 1.0));
  crouchIndicatorSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 100.0),
      inkEHorizontalAlign.Right,
      inkEVerticalAlign.Bottom,
      inkEAnchor.BottomRight,
      new Vector2(1.0, 1.0)
    )
  );

  root.RemoveChildByName(n"NewCrouchIndicator");
  crouchIndicatorSlot.Reparent(root, 7);
  this.crouchIndicatorSlot = crouchIndicatorSlot;

  let dpadSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  dpadSlot.SetName(n"NewDpad");
  dpadSlot.SetFitToContent(true);
  dpadSlot.SetInteractive(false);
  dpadSlot.SetAffectsLayoutWhenHidden(false);
  dpadSlot.SetMargin(new inkMargin(20.0, 0.0, 0.0, 50.0));
  dpadSlot.SetHAlign(inkEHorizontalAlign.Fill);
  dpadSlot.SetVAlign(inkEVerticalAlign.Fill);
  dpadSlot.SetAnchor(inkEAnchor.BottomLeft);
  dpadSlot.SetAnchorPoint(new Vector2(0.0, 1.0));
  dpadSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(20.0, 0.0, 0.0, 50.0),
      inkEHorizontalAlign.Fill,
      inkEVerticalAlign.Fill,
      inkEAnchor.BottomLeft,
      new Vector2(0.0, 1.0)
    )
  );

  root.RemoveChildByName(n"NewDpad");
  dpadSlot.Reparent(root, 8);
  this.dpadSlot = dpadSlot;

  let healthbarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  healthbarSlot.SetName(n"NewHealthBar");
  healthbarSlot.SetFitToContent(true);
  healthbarSlot.SetInteractive(false);
  healthbarSlot.SetAffectsLayoutWhenHidden(false);
  healthbarSlot.SetMargin(new inkMargin(30.0, 50.0, 0.0, 0.0));
  healthbarSlot.SetHAlign(inkEHorizontalAlign.Left);
  healthbarSlot.SetVAlign(inkEVerticalAlign.Top);
  healthbarSlot.SetAnchor(inkEAnchor.TopLeft);
  healthbarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
  healthbarSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(30.0, 50.0, 0.0, 0.0),
      inkEHorizontalAlign.Left,
      inkEVerticalAlign.Top,
      inkEAnchor.TopLeft,
      new Vector2(0.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewHealthBar");
  healthbarSlot.Reparent(root, 9);
  this.healthbarSlot = healthbarSlot;

  let staminaBarSlot: ref<HUDitorCustomSlot>  = new HUDitorCustomSlot();
  staminaBarSlot.SetName(n"NewStaminaBar");
  staminaBarSlot.SetFitToContent(true);
  staminaBarSlot.SetInteractive(false);
  staminaBarSlot.SetAffectsLayoutWhenHidden(false);
  staminaBarSlot.SetMargin(new inkMargin(0.0, 80.0, 0.0, 0.0));
  staminaBarSlot.SetHAlign(inkEHorizontalAlign.Center);
  staminaBarSlot.SetVAlign(inkEVerticalAlign.Center);
  staminaBarSlot.SetAnchor(inkEAnchor.Centered);
  staminaBarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
  staminaBarSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 80.0, 0.0, 0.0),
      inkEHorizontalAlign.Center,
      inkEVerticalAlign.Center,
      inkEAnchor.Centered,
      new Vector2(0.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewStaminaBar");
  staminaBarSlot.Reparent(root, 10);
  this.staminaBarSlot = staminaBarSlot;

  let phoneCallAvatarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  phoneCallAvatarSlot.SetName(n"NewPhoneAvatar");
  phoneCallAvatarSlot.SetFitToContent(true);
  phoneCallAvatarSlot.SetInteractive(false);
  phoneCallAvatarSlot.SetAffectsLayoutWhenHidden(false);
  phoneCallAvatarSlot.SetMargin(new inkMargin(60.0, 300.0, 0.0, 0.0));
  phoneCallAvatarSlot.SetHAlign(inkEHorizontalAlign.Left);
  phoneCallAvatarSlot.SetVAlign(inkEVerticalAlign.Top);
  phoneCallAvatarSlot.SetAnchor(inkEAnchor.TopLeft);
  phoneCallAvatarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));
  phoneCallAvatarSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(60.0, 300.0, 0.0, 0.0),
      inkEHorizontalAlign.Left,
      inkEVerticalAlign.Top,
      inkEAnchor.TopLeft,
      new Vector2(0.0, 0.0)
    )
  );

  root.RemoveChildByName(n"NewPhoneAvatar");
  phoneCallAvatarSlot.Reparent(root, 11);
  this.phoneCallAvatarSlot = phoneCallAvatarSlot;

  let phoneControlSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  phoneControlSlot.SetName(n"NewPhoneControl");
  phoneControlSlot.SetFitToContent(true);
  phoneControlSlot.SetInteractive(false);
  phoneControlSlot.SetAffectsLayoutWhenHidden(false);
  phoneControlSlot.SetMargin(new inkMargin(0.0, 100.0, 0.0, 0.0));
  phoneControlSlot.SetHAlign(inkEHorizontalAlign.Center);
  phoneControlSlot.SetVAlign(inkEVerticalAlign.Top);
  phoneControlSlot.SetAnchor(inkEAnchor.TopCenter);
  phoneControlSlot.SetScale(new Vector2(0.666667, 0.666667));
  phoneControlSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
  phoneControlSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 100.0, 0.0, 0.0),
      inkEHorizontalAlign.Center,
      inkEVerticalAlign.Top,
      inkEAnchor.TopCenter,
      new Vector2(0.5, 0.5)
    )
  );

  root.RemoveChildByName(n"NewPhoneControl");
  phoneControlSlot.Reparent(root, 12);
  this.phoneControlSlot = phoneControlSlot;

  let inputHintSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  inputHintSlot.SetName(n"NewInputHint");
  inputHintSlot.SetFitToContent(true);
  inputHintSlot.SetInteractive(false);
  inputHintSlot.SetAffectsLayoutWhenHidden(false);
  inputHintSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  inputHintSlot.SetHAlign(inkEHorizontalAlign.Center);
  inputHintSlot.SetVAlign(inkEVerticalAlign.Center);
  inputHintSlot.SetAnchor(inkEAnchor.Centered);
  inputHintSlot.SetAnchorPoint(new Vector2(1.0, 1.0));
  inputHintSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      inkEHorizontalAlign.Center,
      inkEVerticalAlign.Center,
      inkEAnchor.Centered,
      new Vector2(1.0, 1.0)
    )
  );

  root.RemoveChildByName(n"NewInputHint");
  inputHintSlot.Reparent(root, 13);
  this.inputHintSlot = inputHintSlot;

  let carHudSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  carHudSlot.SetName(n"NewCarHud");
  carHudSlot.SetFitToContent(true);
  carHudSlot.SetInteractive(false);
  carHudSlot.SetAffectsLayoutWhenHidden(false);
  carHudSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
  carHudSlot.SetHAlign(inkEHorizontalAlign.Center);
  carHudSlot.SetVAlign(inkEVerticalAlign.Bottom);
  carHudSlot.SetAnchor(inkEAnchor.BottomCenter);
  carHudSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
  carHudSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      inkEHorizontalAlign.Center,
      inkEVerticalAlign.Bottom,
      inkEAnchor.BottomCenter,
      new Vector2(0.5, 0.5)
    )
  );

  root.RemoveChildByName(n"NewCarHud");
  carHudSlot.Reparent(root, 14);
  this.carHudSlot = carHudSlot;

  let bossHealthbarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  bossHealthbarSlot.SetName(n"NewBossHealthbar");
  bossHealthbarSlot.SetFitToContent(true);
  bossHealthbarSlot.SetInteractive(false);
  bossHealthbarSlot.SetAffectsLayoutWhenHidden(false);
  bossHealthbarSlot.SetMargin(new inkMargin(60.0, 100.0, 0.0, 0.0));
  bossHealthbarSlot.SetHAlign(inkEHorizontalAlign.Fill);
  bossHealthbarSlot.SetVAlign(inkEVerticalAlign.Fill);
  bossHealthbarSlot.SetAnchor(inkEAnchor.TopCenter);
  bossHealthbarSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
  bossHealthbarSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(60.0, 100.0, 0.0, 0.0),
      inkEHorizontalAlign.Fill,
      inkEVerticalAlign.Fill,
      inkEAnchor.TopCenter,
      new Vector2(0.5, 0.5)
    )
  );

  root.RemoveChildByName(n"NewBossHealthbar");
  bossHealthbarSlot.Reparent(root, 15);
  this.bossHealthbarSlot = bossHealthbarSlot;

  let dialogChoicesSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  dialogChoicesSlot.SetName(n"NewDialogChoices");
  dialogChoicesSlot.SetFitToContent(true);
  dialogChoicesSlot.SetInteractive(false);
  dialogChoicesSlot.SetAffectsLayoutWhenHidden(false);
  dialogChoicesSlot.SetMargin(new inkMargin(0.0, 120.0, 0.0, 0.0));
  dialogChoicesSlot.SetHAlign(inkEHorizontalAlign.Fill);
  dialogChoicesSlot.SetVAlign(inkEVerticalAlign.Fill);
  dialogChoicesSlot.SetAnchor(inkEAnchor.Centered);
  dialogChoicesSlot.SetAnchorPoint(new Vector2(0.5, 0.0));
  dialogChoicesSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 120.0, 0.0, 0.0),
      inkEHorizontalAlign.Fill,
      inkEVerticalAlign.Fill,
      inkEAnchor.Centered,
      new Vector2(0.5, 0.0)
    )
  );

  root.RemoveChildByName(n"NewDialogChoices");
  dialogChoicesSlot.Reparent(root, 16);
  this.dialogChoicesSlot = dialogChoicesSlot;

  let dialogSubtitlesSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
  dialogSubtitlesSlot.SetName(n"NewDialogSubtitles");
  dialogSubtitlesSlot.SetFitToContent(false);
  dialogSubtitlesSlot.SetInteractive(false);
  dialogSubtitlesSlot.SetAffectsLayoutWhenHidden(false);
  dialogSubtitlesSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 16.0));
  dialogSubtitlesSlot.SetHAlign(inkEHorizontalAlign.Fill);
  dialogSubtitlesSlot.SetVAlign(inkEVerticalAlign.Fill);
  dialogSubtitlesSlot.SetAnchor(inkEAnchor.BottomFillHorizontaly);
  dialogSubtitlesSlot.SetAnchorPoint(new Vector2(0.0, 1.0));
  dialogSubtitlesSlot.SetLayout(
    new inkWidgetLayout(
      new inkMargin(0.0, 0.0, 0.0, 0.0),
      new inkMargin(0.0, 0.0, 0.0, 16.0),
      inkEHorizontalAlign.Fill,
      inkEVerticalAlign.Fill,
      inkEAnchor.BottomFillHorizontaly,
      new Vector2(0.0, 1.0)
    )
  );

  root.RemoveChildByName(n"NewDialogSubtitles");
  dialogSubtitlesSlot.Reparent(root, 16);
  this.dialogSubtitlesSlot = dialogSubtitlesSlot;
}

@addMethod(inkGameController)
private func InitBaseWidgets() -> Void {
  let uiSystem = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
  let hudLayer: ref<inkLayerWrapper> = uiSystem.GetLayer(n"inkHUDLayer");

  let name: CName;
  let targetWidget: ref<inkCompoundWidget>; 
  for controller in hudLayer.GetGameControllers() {
    name = controller.GetClassName();
    switch name {
      case n"gameuiMinimapContainerController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.minimapSlot);
        break;
      case n"QuestTrackerGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.questTrackerSlot);
        break;
      case n"WantedBarGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.wantedSlot);
        break;
      case n"JournalNotificationQueue":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.questNotificationsSlot);
        break;
      case n"ItemsNotificationQueue":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.itemNotificationsSlot);
        break;
      case n"VehicleSummonWidgetGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.vehicleSummonSlot);
        break;
      case n"weaponRosterGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.weaponRosterSlot);
        break;
      case n"CrouchIndicatorGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.crouchIndicatorSlot);
        break;
      case n"HotkeysWidgetController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.dpadSlot);
        break;
      case n"healthbarWidgetGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.healthbarSlot);
        break;
      case n"StaminabarWidgetGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.staminaBarSlot);
        break;
      case n"HudPhoneGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.phoneCallAvatarSlot);
        break;
      case n"IncomingCallGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.phoneControlSlot);
        break;
      case n"gameuiInputHintManagerGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.inputHintSlot);
        break;
      case n"hudCarController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.carHudSlot);
        break;
      case n"BossHealthBarGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.bossHealthbarSlot);
        break;
      case n"dialogWidgetGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.dialogChoicesSlot);
        break;
      case n"SubtitlesGameController":
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.dialogSubtitlesSlot);
        break;
    };
  }
}

@addMethod(inkGameController)
protected cb func OnHijackSlotsEvent(evt: ref<HijackSlotsEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.CreateCustomSlots();
    this.InitBaseWidgets();
  };
}
