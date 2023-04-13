import HUDrag.HUDitorConfig

@addField(inkGameController) let huditorWidgetName: wref<inkText>;
@addField(inkGameController) let carHudSlotPreview: wref<inkRectangle>;

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
@addField(inkGameController) let e3CompassSlot: wref<HUDitorCustomSlot>;

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
    this.e3CompassSlot.OnGameSessionInitialized(event);
  };
}

@addMethod(inkGameController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidgetEvent>) -> Bool {
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
    this.e3CompassSlot.OnEnableHUDEditorWidget(event);
    this.huditorWidgetName.SetVisible(true);
    this.huditorWidgetName.SetText(HUDitorTexts.GetWidgetName(event.activeWidget));
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
    this.e3CompassSlot.OnDisableHUDEditorWidgets(event);
    this.huditorWidgetName.SetVisible(false);
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
    this.e3CompassSlot.OnResetHUDWidgets(event);
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
    this.e3CompassSlot.OnAction(action, consumer);
  };
}

@addMethod(inkGameController)
private func InitWidgetNameLabel() -> Void {
  let system: ref<inkSystem> = GameInstance.GetInkSystem();
  let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  root.RemoveChildByName(n"huditorLabel");

  let label: ref<inkText> = new inkText();
  label.SetName(n"huditorLabel");
  label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  label.SetFontSize(24);
  label.SetLetterCase(textLetterCase.OriginalCase);
  label.SetMargin(new inkMargin(0.0, 0.0, 0.0, 20.0));
  label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  label.BindProperty(n"tintColor", n"MainColors.Yellow");
  label.SetAnchor(inkEAnchor.BottomCenter);
  label.SetAnchorPoint(new Vector2(0.5, 1.0));
  label.Reparent(root);
  this.huditorWidgetName = label;
}

@addMethod(inkGameController)
private func CreateCustomSlots() -> Void {
  let system: ref<inkSystem> = GameInstance.GetInkSystem();
  let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let config: ref<HUDitorConfig> = new HUDitorConfig();

  if config.questTrackerEnabled {
    let questTrackerSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    questTrackerSlot.SetName(n"NewTracker");
    questTrackerSlot.SetFitToContent(true);
    questTrackerSlot.SetInteractive(false);
    questTrackerSlot.SetAffectsLayoutWhenHidden(false);
    questTrackerSlot.SetMargin(new inkMargin(0.0, 20.0, 20.0, 0.0));
    questTrackerSlot.SetAnchor(inkEAnchor.TopRight);
    questTrackerSlot.SetAnchorPoint(new Vector2(1.0, 0.0));

    root.RemoveChildByName(n"NewTracker");
    questTrackerSlot.Reparent(root, 0);
    this.questTrackerSlot = questTrackerSlot;
  };

  if config.minimapEnabled && !config.compatE3CompassEnabled {
    let minimapSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    minimapSlot.SetName(n"NewMinimap");
    minimapSlot.SetFitToContent(true);
    minimapSlot.SetInteractive(false);
    minimapSlot.SetAffectsLayoutWhenHidden(false);
    minimapSlot.SetMargin(new inkMargin(0.0, 140.0, 80.0, 0.0));
    minimapSlot.SetAnchor(inkEAnchor.TopRight);
    minimapSlot.SetAnchorPoint(new Vector2(1.0, 0.0));

    root.RemoveChildByName(n"NewMinimap");
    minimapSlot.Reparent(root, 1);
    this.minimapSlot = minimapSlot;
  };

  if config.wantedBarEnabled {
    let wantedSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    wantedSlot.SetName(n"NewWanted");
    wantedSlot.SetFitToContent(true);
    wantedSlot.SetInteractive(false);
    wantedSlot.SetAffectsLayoutWhenHidden(false);
    wantedSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    wantedSlot.SetAnchor(inkEAnchor.Centered);
    wantedSlot.SetAnchorPoint(new Vector2(0.0, 1.0));

    root.RemoveChildByName(n"NewWanted");
    wantedSlot.Reparent(root, 2);
    this.wantedSlot = wantedSlot;
  };

  if config.questNotificationsEnabled {
    let questNotificationsSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    questNotificationsSlot.SetName(n"NewQuestNotifications");
    questNotificationsSlot.SetFitToContent(true);
    questNotificationsSlot.SetInteractive(false);
    questNotificationsSlot.SetAffectsLayoutWhenHidden(false);
    questNotificationsSlot.SetMargin(new inkMargin(40.0, 0.0, 0.0, 0.0));
    questNotificationsSlot.SetAnchor(inkEAnchor.CenterLeft);
    questNotificationsSlot.SetAnchorPoint(new Vector2(1.0, 1.0));

    root.RemoveChildByName(n"NewQuestNotifications");
    questNotificationsSlot.Reparent(root, 3);
    this.questNotificationsSlot = questNotificationsSlot;
  };

  if config.itemNotificationsEnabled {
    let itemNotificationsSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    itemNotificationsSlot.SetName(n"NewItemNotifications");
    itemNotificationsSlot.SetFitToContent(true);
    itemNotificationsSlot.SetInteractive(false);
    itemNotificationsSlot.SetAffectsLayoutWhenHidden(false);
    itemNotificationsSlot.SetMargin(new inkMargin(40.0, 0.0, 0.0, 0.0));
    itemNotificationsSlot.SetAnchor(inkEAnchor.CenterLeft);
    itemNotificationsSlot.SetAnchorPoint(new Vector2(1.0, 0.0));

    root.RemoveChildByName(n"NewItemNotifications");
    itemNotificationsSlot.Reparent(root, 4);
    this.itemNotificationsSlot = itemNotificationsSlot;
  };

  if config.vehicleSummonEnabled {
    let vehicleSummonSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    vehicleSummonSlot.SetName(n"NewVehicleSummon");
    vehicleSummonSlot.SetFitToContent(true);
    vehicleSummonSlot.SetInteractive(false);
    vehicleSummonSlot.SetAffectsLayoutWhenHidden(false);
    vehicleSummonSlot.SetMargin(new inkMargin(0.0, 0.0, 80.0, 0.0));
    vehicleSummonSlot.SetAnchor(inkEAnchor.CenterRight);
    vehicleSummonSlot.SetAnchorPoint(new Vector2(0.0, 1.0));

    root.RemoveChildByName(n"NewVehicleSummon");
    vehicleSummonSlot.Reparent(root, 5);
    this.vehicleSummonSlot = vehicleSummonSlot;
  };

  if config.weaponRosterEnabled {
    let weaponRosterSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    weaponRosterSlot.SetName(n"NewWeaponRoster");
    weaponRosterSlot.SetFitToContent(true);
    weaponRosterSlot.SetInteractive(false);
    weaponRosterSlot.SetAffectsLayoutWhenHidden(false);
    weaponRosterSlot.SetMargin(new inkMargin(0.0, 0.0, 340.0, 40.0));
    weaponRosterSlot.SetAnchor(inkEAnchor.BottomRight);
    weaponRosterSlot.SetAnchorPoint(new Vector2(1.0, 1.0));

    root.RemoveChildByName(n"NewWeaponRoster");
    weaponRosterSlot.Reparent(root, 6);
    this.weaponRosterSlot = weaponRosterSlot;
  };

  if config.crouchIndicatorEnabled {
    let crouchIndicatorSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    crouchIndicatorSlot.SetName(n"NewCrouchIndicator");
    crouchIndicatorSlot.SetFitToContent(true);
    crouchIndicatorSlot.SetInteractive(false);
    crouchIndicatorSlot.SetAffectsLayoutWhenHidden(false);
    crouchIndicatorSlot.SetMargin(new inkMargin(0.0, 0.0, 40.0, 40.0));
    crouchIndicatorSlot.SetAnchor(inkEAnchor.BottomRight);
    crouchIndicatorSlot.SetAnchorPoint(new Vector2(1.0, 1.0));

    root.RemoveChildByName(n"NewCrouchIndicator");
    crouchIndicatorSlot.Reparent(root, 7);
    this.crouchIndicatorSlot = crouchIndicatorSlot;
  }

  if config.dpadEnabled {
    let dpadSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    dpadSlot.SetName(n"NewDpad");
    dpadSlot.SetFitToContent(true);
    dpadSlot.SetInteractive(false);
    dpadSlot.SetAffectsLayoutWhenHidden(false);
    dpadSlot.SetMargin(new inkMargin(40.0, 0.0, 0.0, 80.0));
    dpadSlot.SetAnchor(inkEAnchor.BottomLeft);
    dpadSlot.SetAnchorPoint(new Vector2(0.0, 1.0));

    root.RemoveChildByName(n"NewDpad");
    dpadSlot.Reparent(root, 8);
    this.dpadSlot = dpadSlot;
  };

  if config.playerHealthbarEnabled {
    let healthbarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    healthbarSlot.SetName(n"NewHealthBar");
    healthbarSlot.SetFitToContent(true);
    healthbarSlot.SetInteractive(false);
    healthbarSlot.SetAffectsLayoutWhenHidden(false);
    healthbarSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    healthbarSlot.SetAnchor(inkEAnchor.TopLeft);
    healthbarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));

    root.RemoveChildByName(n"NewHealthBar");
    healthbarSlot.Reparent(root, 9);
    this.healthbarSlot = healthbarSlot;
  };

  if config.playerStaminabarEnabled {
    let staminaBarSlot: ref<HUDitorCustomSlot>  = new HUDitorCustomSlot();
    staminaBarSlot.SetName(n"NewStaminaBar");
    staminaBarSlot.SetFitToContent(true);
    staminaBarSlot.SetInteractive(false);
    staminaBarSlot.SetAffectsLayoutWhenHidden(false);
    staminaBarSlot.SetMargin(new inkMargin(30.0, 100.0, 0.0, 0.0));
    staminaBarSlot.SetAnchor(inkEAnchor.TopLeft);
    staminaBarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));

    root.RemoveChildByName(n"NewStaminaBar");
    staminaBarSlot.Reparent(root, 10);
    this.staminaBarSlot = staminaBarSlot;
  };

  if config.incomingCallAvatarEnabled {
    let phoneCallAvatarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    phoneCallAvatarSlot.SetName(n"NewPhoneAvatar");
    phoneCallAvatarSlot.SetFitToContent(true);
    phoneCallAvatarSlot.SetInteractive(false);
    phoneCallAvatarSlot.SetAffectsLayoutWhenHidden(false);
    phoneCallAvatarSlot.SetMargin(new inkMargin(40.0, 160.0, 0.0, 0.0));
    phoneCallAvatarSlot.SetAnchor(inkEAnchor.TopLeft);
    phoneCallAvatarSlot.SetAnchorPoint(new Vector2(0.0, 0.0));

    root.RemoveChildByName(n"NewPhoneAvatar");
    phoneCallAvatarSlot.Reparent(root, 11);
    this.phoneCallAvatarSlot = phoneCallAvatarSlot;
  };

  if config.incomingCallButtonEnabled {
    let phoneControlSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    phoneControlSlot.SetName(n"NewPhoneControl");
    phoneControlSlot.SetFitToContent(true);
    phoneControlSlot.SetInteractive(false);
    phoneControlSlot.SetAffectsLayoutWhenHidden(false);
    phoneControlSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    phoneControlSlot.SetAnchor(inkEAnchor.TopCenter);
    phoneControlSlot.SetAnchorPoint(new Vector2(0.5, 0.0));

    root.RemoveChildByName(n"NewPhoneControl");
    phoneControlSlot.Reparent(root, 12);
    this.phoneControlSlot = phoneControlSlot;
  };

  if config.inputHintsEnabled {
    let inputHintSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    inputHintSlot.SetName(n"NewInputHint");
    inputHintSlot.SetFitToContent(true);
    inputHintSlot.SetInteractive(false);
    inputHintSlot.SetAffectsLayoutWhenHidden(false);
    inputHintSlot.SetMargin(new inkMargin(500.0, 0.0, 0.0, 0.0));
    inputHintSlot.SetAnchor(inkEAnchor.Centered);
    inputHintSlot.SetAnchorPoint(new Vector2(1.0, 0.5));

    root.RemoveChildByName(n"NewInputHint");
    inputHintSlot.Reparent(root, 13);
    this.inputHintSlot = inputHintSlot;
  };

  if config.speedometerEnabled {
    let carHudSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    carHudSlot.SetName(n"NewCarHud");
    carHudSlot.SetFitToContent(true);
    carHudSlot.SetInteractive(false);
    carHudSlot.SetAffectsLayoutWhenHidden(false);
    carHudSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    carHudSlot.SetAnchor(inkEAnchor.Centered);
    carHudSlot.SetAnchorPoint(new Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewCarHud");
    carHudSlot.Reparent(root, 14);
    this.carHudSlot = carHudSlot;
  };

  if config.bossHealthbarEnabled {
    let bossHealthbarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    bossHealthbarSlot.SetName(n"NewBossHealthbar");
    bossHealthbarSlot.SetFitToContent(true);
    bossHealthbarSlot.SetInteractive(false);
    bossHealthbarSlot.SetAffectsLayoutWhenHidden(false);
    bossHealthbarSlot.SetMargin(new inkMargin(0.0, 40.0, 0.0, 0.0));
    bossHealthbarSlot.SetAnchor(inkEAnchor.TopCenter);
    bossHealthbarSlot.SetAnchorPoint(new Vector2(0.5, 0.0));

    root.RemoveChildByName(n"NewBossHealthbar");
    bossHealthbarSlot.Reparent(root, 15);
    this.bossHealthbarSlot = bossHealthbarSlot;
  };

  if config.dialogChoicesEnabled {
    let dialogChoicesSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    dialogChoicesSlot.SetName(n"NewDialogChoices");
    dialogChoicesSlot.SetFitToContent(true);
    dialogChoicesSlot.SetInteractive(false);
    dialogChoicesSlot.SetAffectsLayoutWhenHidden(false);
    dialogChoicesSlot.SetMargin(new inkMargin(0.0, 120.0, 0.0, 0.0));
    dialogChoicesSlot.SetAnchor(inkEAnchor.Centered);
    dialogChoicesSlot.SetAnchorPoint(new Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewDialogChoices");
    dialogChoicesSlot.Reparent(root, 16);
    this.dialogChoicesSlot = dialogChoicesSlot;
  };

  if config.dialogSubtitlesEnabled {
    let dialogSubtitlesSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    dialogSubtitlesSlot.SetName(n"NewDialogSubtitles");
    dialogSubtitlesSlot.SetFitToContent(false);
    dialogSubtitlesSlot.SetInteractive(false);
    dialogSubtitlesSlot.SetAffectsLayoutWhenHidden(false);
    dialogSubtitlesSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 20.0));
    dialogSubtitlesSlot.SetAnchor(inkEAnchor.BottomFillHorizontaly);
    dialogSubtitlesSlot.SetAnchorPoint(new Vector2(0.5, 1.0));
    root.RemoveChildByName(n"NewDialogSubtitles");
    dialogSubtitlesSlot.Reparent(root, 16);
    this.dialogSubtitlesSlot = dialogSubtitlesSlot;
  };

  if config.compatE3CompassEnabled {
    let e3CompassSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    e3CompassSlot.SetName(n"NewCompass");
    e3CompassSlot.SetFitToContent(false);
    e3CompassSlot.SetInteractive(false);
    e3CompassSlot.SetAffectsLayoutWhenHidden(false);
    e3CompassSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    e3CompassSlot.SetAnchor(inkEAnchor.Centered);
    e3CompassSlot.SetAnchorPoint(new Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewCompass");
    e3CompassSlot.Reparent(root, 17);
    this.e3CompassSlot = e3CompassSlot;
  };
}

@addMethod(inkGameController)
private func InitBaseWidgets() -> Void {
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  let system: ref<inkSystem> = GameInstance.GetInkSystem();
  let hudLayer: ref<inkLayerWrapper> = system.GetLayer(n"inkHUDLayer");

  let name: CName;
  let targetWidget: ref<inkCompoundWidget>; 
  for controller in hudLayer.GetGameControllers() {
    name = controller.GetClassName();
    switch name {
      case n"QuestTrackerGameController":
        if !config.questTrackerEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(1.0, 0.0));
        targetWidget.Reparent(this.questTrackerSlot);
        break;
      case n"gameuiMinimapContainerController":
        if !config.minimapEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(1.0, 0.0));
        targetWidget.Reparent(this.minimapSlot);
        break;
      case n"WantedBarGameController":
        if !config.wantedBarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 1.0));
        targetWidget.Reparent(this.wantedSlot);
        break;
      case n"JournalNotificationQueue":
        if !config.questNotificationsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 1.0));
        targetWidget.Reparent(this.questNotificationsSlot);
        break;
      case n"ItemsNotificationQueue":
        if !config.itemNotificationsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 0.0));
        targetWidget.Reparent(this.itemNotificationsSlot);
        break;
      case n"VehicleSummonWidgetGameController":
        if !config.vehicleSummonEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(1.0, 1.0));
        targetWidget.Reparent(this.vehicleSummonSlot);
        break;
      case n"weaponRosterGameController":
        if !config.weaponRosterEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(1.0, 1.0));
        targetWidget.Reparent(this.weaponRosterSlot);
        break;
      case n"CrouchIndicatorGameController":
        if !config.crouchIndicatorEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(1.0, 1.0));
        targetWidget.Reparent(this.crouchIndicatorSlot);
        break;
      case n"HotkeysWidgetController":
        if !config.dpadEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 1.0));
        targetWidget.Reparent(this.dpadSlot);
        break;
      case n"healthbarWidgetGameController":
        if !config.playerHealthbarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 0.0));
        targetWidget.Reparent(this.healthbarSlot);
        break;
      case n"StaminabarWidgetGameController":
        if !config.playerStaminabarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 0.0));
        targetWidget.Reparent(this.staminaBarSlot);
        break;
      case n"HudPhoneGameController":
        if !config.incomingCallAvatarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.0, 0.0));
        targetWidget.Reparent(this.phoneCallAvatarSlot);
        break;
      case n"IncomingCallGameController":
        if !config.incomingCallButtonEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.5, 0.0));
        targetWidget.Reparent(this.phoneControlSlot);
        break;
      case n"gameuiInputHintManagerGameController":
        if !config.inputHintsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(1.0, 0.5));
        targetWidget.Reparent(this.inputHintSlot);
        break;
      case n"hudCarController":
        if !config.speedometerEnabled { break; }
        let slotPreview: ref<inkRectangle> = this.CreateCarHudPreview();
        slotPreview.Reparent(this.carHudSlot);
        this.carHudSlotPreview = slotPreview;

        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.carHudSlot);
        break;
      case n"BossHealthBarGameController":
        if !config.bossHealthbarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.5, 0.0));
        targetWidget.Reparent(this.bossHealthbarSlot);
        break;
      case n"dialogWidgetGameController":
        if !config.dialogChoicesEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.5, 0.5));
        targetWidget.Reparent(this.dialogChoicesSlot);
        break;
      case n"SubtitlesGameController":
        if !config.dialogSubtitlesEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(new Vector2(0.5, 1.0));
        targetWidget.Reparent(this.dialogSubtitlesSlot);
        break;
      case n"IronsightGameController":
        if !config.compatE3CompassEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.e3CompassSlot);
        break;
    };
  }
}

@addMethod(inkGameController)
protected cb func OnHijackSlotsEvent(evt: ref<HijackSlotsEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.InitWidgetNameLabel();
    this.CreateCustomSlots();
    this.InitBaseWidgets();
  };
}

@addMethod(inkGameController)
private func CreateCarHudPreview() -> ref<inkRectangle> {
  let preview: ref<inkRectangle> = new inkRectangle();
  preview.SetName(n"carHudPreview");
  preview.SetAnchor(inkEAnchor.Centered);
  preview.SetAnchorPoint(0.5, 0.5);
  preview.SetTintColor(new HDRColor(1.0, 1.0, 0.0, 1.0));
  preview.SetSize(new Vector2(440.0, 120.0));
  preview.SetMargin(new inkMargin(250.0, 80.0, 0.0, 0.0));
  preview.SetVisible(false);
  return preview;
}
