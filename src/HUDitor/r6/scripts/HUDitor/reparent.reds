import HUDrag.HUDitorConfig
import HUDrag.HUDitorWatcher

@if(ModuleExists("FpsCounter"))
import FpsCounter.FPSCounterChangeStateEvent

@addField(inkGameController) public let huditorWidgetName: wref<inkText>;

@addField(inkGameController) public let minimapSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let questTrackerSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let wantedSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let questNotificationsSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let itemNotificationsSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let vehicleSummonSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let weaponRosterSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let crouchIndicatorSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let dpadSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let phoneHotkeySlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let healthbarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let staminaBarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let phoneCallAvatarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let phoneControlSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let inputHintSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let carHudSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let autoDriveSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let crystalCoatSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let vehicleRadioSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let vehicleHotkeySlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let bossHealthbarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let dialogChoicesSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let dialogSubtitlesSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let progressBarSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let e3CompassSlot: wref<HUDitorCustomSlot>;
@addField(inkGameController) public let fpsCounterSlot: wref<HUDitorCustomSlot>;

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
    this.phoneHotkeySlot.OnGameSessionInitialized(event);
    this.healthbarSlot.OnGameSessionInitialized(event);
    this.staminaBarSlot.OnGameSessionInitialized(event);
    this.phoneCallAvatarSlot.OnGameSessionInitialized(event);
    this.phoneControlSlot.OnGameSessionInitialized(event);
    this.inputHintSlot.OnGameSessionInitialized(event);
    this.carHudSlot.OnGameSessionInitialized(event);
    this.autoDriveSlot.OnGameSessionInitialized(event);
    this.crystalCoatSlot.OnGameSessionInitialized(event);
    this.vehicleRadioSlot.OnGameSessionInitialized(event);
    this.vehicleHotkeySlot.OnGameSessionInitialized(event);
    this.bossHealthbarSlot.OnGameSessionInitialized(event);
    this.dialogChoicesSlot.OnGameSessionInitialized(event);
    this.dialogSubtitlesSlot.OnGameSessionInitialized(event);
    this.progressBarSlot.OnGameSessionInitialized(event);
    this.e3CompassSlot.OnGameSessionInitialized(event);
    this.fpsCounterSlot.OnGameSessionInitialized(event);
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
    this.phoneHotkeySlot.OnEnableHUDEditorWidget(event);
    this.healthbarSlot.OnEnableHUDEditorWidget(event);
    this.staminaBarSlot.OnEnableHUDEditorWidget(event);
    this.phoneCallAvatarSlot.OnEnableHUDEditorWidget(event);
    this.phoneControlSlot.OnEnableHUDEditorWidget(event);
    this.inputHintSlot.OnEnableHUDEditorWidget(event);
    this.carHudSlot.OnEnableHUDEditorWidget(event);
    this.autoDriveSlot.OnEnableHUDEditorWidget(event);
    this.crystalCoatSlot.OnEnableHUDEditorWidget(event);
    this.vehicleRadioSlot.OnEnableHUDEditorWidget(event);
    this.vehicleHotkeySlot.OnEnableHUDEditorWidget(event);
    this.bossHealthbarSlot.OnEnableHUDEditorWidget(event);
    this.dialogChoicesSlot.OnEnableHUDEditorWidget(event);
    this.dialogSubtitlesSlot.OnEnableHUDEditorWidget(event);
    this.progressBarSlot.OnEnableHUDEditorWidget(event);
    this.e3CompassSlot.OnEnableHUDEditorWidget(event);
    this.fpsCounterSlot.OnEnableHUDEditorWidget(event);
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
    this.phoneHotkeySlot.OnDisableHUDEditorWidgets(event);
    this.healthbarSlot.OnDisableHUDEditorWidgets(event);
    this.staminaBarSlot.OnDisableHUDEditorWidgets(event);
    this.phoneCallAvatarSlot.OnDisableHUDEditorWidgets(event);
    this.phoneControlSlot.OnDisableHUDEditorWidgets(event);
    this.inputHintSlot.OnDisableHUDEditorWidgets(event);
    this.carHudSlot.OnDisableHUDEditorWidgets(event);
    this.autoDriveSlot.OnDisableHUDEditorWidgets(event);
    this.crystalCoatSlot.OnDisableHUDEditorWidgets(event);
    this.vehicleRadioSlot.OnDisableHUDEditorWidgets(event);
    this.vehicleHotkeySlot.OnDisableHUDEditorWidgets(event);
    this.bossHealthbarSlot.OnDisableHUDEditorWidgets(event);
    this.dialogChoicesSlot.OnDisableHUDEditorWidgets(event);
    this.dialogSubtitlesSlot.OnDisableHUDEditorWidgets(event);
    this.progressBarSlot.OnDisableHUDEditorWidgets(event);
    this.e3CompassSlot.OnDisableHUDEditorWidgets(event);
    this.fpsCounterSlot.OnDisableHUDEditorWidgets(event);
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
    this.phoneHotkeySlot.OnResetHUDWidgets(event);
    this.healthbarSlot.OnResetHUDWidgets(event);
    this.staminaBarSlot.OnResetHUDWidgets(event);
    this.phoneCallAvatarSlot.OnResetHUDWidgets(event);
    this.phoneControlSlot.OnResetHUDWidgets(event);
    this.inputHintSlot.OnResetHUDWidgets(event);
    this.carHudSlot.OnResetHUDWidgets(event);
    this.autoDriveSlot.OnResetHUDWidgets(event);
    this.crystalCoatSlot.OnResetHUDWidgets(event);
    this.vehicleRadioSlot.OnResetHUDWidgets(event);
    this.vehicleHotkeySlot.OnResetHUDWidgets(event);
    this.bossHealthbarSlot.OnResetHUDWidgets(event);
    this.dialogChoicesSlot.OnResetHUDWidgets(event);
    this.dialogSubtitlesSlot.OnResetHUDWidgets(event);
    this.progressBarSlot.OnResetHUDWidgets(event);
    this.e3CompassSlot.OnResetHUDWidgets(event);
    this.fpsCounterSlot.OnResetHUDWidgets(event);
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
    this.phoneHotkeySlot.OnAction(action, consumer);
    this.healthbarSlot.OnAction(action, consumer);
    this.staminaBarSlot.OnAction(action, consumer);
    this.phoneCallAvatarSlot.OnAction(action, consumer);
    this.phoneControlSlot.OnAction(action, consumer);
    this.inputHintSlot.OnAction(action, consumer);
    this.carHudSlot.OnAction(action, consumer);
    this.autoDriveSlot.OnAction(action, consumer);
    this.crystalCoatSlot.OnAction(action, consumer);
    this.vehicleRadioSlot.OnAction(action, consumer);
    this.vehicleHotkeySlot.OnAction(action, consumer);
    this.bossHealthbarSlot.OnAction(action, consumer);
    this.dialogChoicesSlot.OnAction(action, consumer);
    this.dialogSubtitlesSlot.OnAction(action, consumer);
    this.progressBarSlot.OnAction(action, consumer);
    this.e3CompassSlot.OnAction(action, consumer);
    this.fpsCounterSlot.OnAction(action, consumer);
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
  label.SetFontSize(38);
  label.SetLetterCase(textLetterCase.OriginalCase);
  label.SetMargin(inkMargin(0.0, 0.0, 0.0, 20.0));
  label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  label.BindProperty(n"tintColor", n"MainColors.Yellow");
  label.SetAnchor(inkEAnchor.BottomCenter);
  label.SetAnchorPoint(Vector2(0.5, 1.0));
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
    questTrackerSlot.SetAnchor(inkEAnchor.Centered);
    questTrackerSlot.SetAnchorPoint(Vector2(0.5, 0.5));

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
    minimapSlot.SetAnchor(inkEAnchor.Centered);
    minimapSlot.SetAnchorPoint(Vector2(0.5, 0.5));

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
    wantedSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    wantedSlot.SetAnchor(inkEAnchor.Centered);
    wantedSlot.SetAnchorPoint(Vector2(0.0, 1.0));

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
    questNotificationsSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    questNotificationsSlot.SetAnchor(inkEAnchor.Centered);
    questNotificationsSlot.SetAnchorPoint(Vector2(1.0, 1.0));

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
    itemNotificationsSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    itemNotificationsSlot.SetAnchor(inkEAnchor.Centered);
    itemNotificationsSlot.SetAnchorPoint(Vector2(0.0, 1.0));

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
    vehicleSummonSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    vehicleSummonSlot.SetAnchor(inkEAnchor.Centered);
    vehicleSummonSlot.SetAnchorPoint(Vector2(1.0, 0.0));

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
    weaponRosterSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    weaponRosterSlot.SetAnchor(inkEAnchor.Centered);
    weaponRosterSlot.SetAnchorPoint(Vector2(0.5, 0.5));

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
    crouchIndicatorSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    crouchIndicatorSlot.SetAnchor(inkEAnchor.Centered);
    crouchIndicatorSlot.SetAnchorPoint(Vector2(0.0, 0.0));

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
    dpadSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    dpadSlot.SetAnchor(inkEAnchor.Centered);
    dpadSlot.SetAnchorPoint(Vector2(0.0, 1.0));

    root.RemoveChildByName(n"NewDpad");
    dpadSlot.Reparent(root, 8);
    this.dpadSlot = dpadSlot;
  };

  if config.phoneHotkeyEnabled {
    let phoneHotkeySlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    phoneHotkeySlot.SetName(n"NewPhoneHotkey");
    phoneHotkeySlot.SetFitToContent(true);
    phoneHotkeySlot.SetInteractive(false);
    phoneHotkeySlot.SetAffectsLayoutWhenHidden(false);
    phoneHotkeySlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    phoneHotkeySlot.SetAnchor(inkEAnchor.Centered);
    phoneHotkeySlot.SetAnchorPoint(Vector2(1.0, 1.0));

    root.RemoveChildByName(n"NewPhoneHotkey");
    phoneHotkeySlot.Reparent(root, 9);
    this.phoneHotkeySlot = phoneHotkeySlot;
  };

  if config.playerHealthbarEnabled {
    let healthbarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    healthbarSlot.SetName(n"NewHealthBar");
    healthbarSlot.SetFitToContent(true);
    healthbarSlot.SetInteractive(false);
    healthbarSlot.SetAffectsLayoutWhenHidden(false);
    healthbarSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    healthbarSlot.SetAnchor(inkEAnchor.Centered);
    healthbarSlot.SetAnchorPoint(Vector2(0.0, 0.0));

    root.RemoveChildByName(n"NewHealthBar");
    healthbarSlot.Reparent(root, 10);
    this.healthbarSlot = healthbarSlot;
  };

  if config.playerStaminabarEnabled {
    let staminaBarSlot: ref<HUDitorCustomSlot>  = new HUDitorCustomSlot();
    staminaBarSlot.SetName(n"NewStaminaBar");
    staminaBarSlot.SetFitToContent(true);
    staminaBarSlot.SetInteractive(false);
    staminaBarSlot.SetAffectsLayoutWhenHidden(false);
    staminaBarSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    staminaBarSlot.SetAnchor(inkEAnchor.Centered);
    staminaBarSlot.SetAnchorPoint(Vector2(0.0, 1.0));

    root.RemoveChildByName(n"NewStaminaBar");
    staminaBarSlot.Reparent(root, 11);
    this.staminaBarSlot = staminaBarSlot;
  };

  if config.incomingCallAvatarEnabled {
    let phoneCallAvatarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    phoneCallAvatarSlot.SetName(n"NewPhoneAvatar");
    phoneCallAvatarSlot.SetFitToContent(true);
    phoneCallAvatarSlot.SetInteractive(false);
    phoneCallAvatarSlot.SetAffectsLayoutWhenHidden(false);
    phoneCallAvatarSlot.SetAnchor(inkEAnchor.Centered);
    phoneCallAvatarSlot.SetAnchorPoint(Vector2(1.0, 1.0));

    root.RemoveChildByName(n"NewPhoneAvatar");
    phoneCallAvatarSlot.Reparent(root, 12);
    this.phoneCallAvatarSlot = phoneCallAvatarSlot;
  };

  if config.incomingCallButtonEnabled {
    let phoneControlSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    phoneControlSlot.SetName(n"NewPhoneControl");
    phoneControlSlot.SetFitToContent(true);
    phoneControlSlot.SetInteractive(false);
    phoneControlSlot.SetAffectsLayoutWhenHidden(false);
    phoneControlSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    phoneControlSlot.SetAnchor(inkEAnchor.Centered);
    phoneControlSlot.SetAnchorPoint(Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewPhoneControl");
    phoneControlSlot.Reparent(root, 13);
    this.phoneControlSlot = phoneControlSlot;
  };

  if config.inputHintsEnabled {
    let inputHintSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    inputHintSlot.SetName(n"NewInputHint");
    inputHintSlot.SetFitToContent(true);
    inputHintSlot.SetInteractive(false);
    inputHintSlot.SetAffectsLayoutWhenHidden(false);
    inputHintSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    inputHintSlot.SetAnchor(inkEAnchor.Centered);
    inputHintSlot.SetAnchorPoint(Vector2(1.0, 0.5));

    root.RemoveChildByName(n"NewInputHint");
    inputHintSlot.Reparent(root, 14);
    this.inputHintSlot = inputHintSlot;
  };

  if config.speedometerEnabled {
    let carHudSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    carHudSlot.SetName(n"NewCarHud");
    carHudSlot.SetFitToContent(true);
    carHudSlot.SetInteractive(false);
    carHudSlot.SetAffectsLayoutWhenHidden(false);
    carHudSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    carHudSlot.SetAnchor(inkEAnchor.Centered);
    carHudSlot.SetAnchorPoint(Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewCarHud");
    carHudSlot.Reparent(root, 15);
    this.carHudSlot = carHudSlot;
  };

  if config.autoDriveEnabled {
    let autoDriveSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    autoDriveSlot.SetName(n"NewAutoDrive");
    autoDriveSlot.SetFitToContent(true);
    autoDriveSlot.SetInteractive(false);
    autoDriveSlot.SetAffectsLayoutWhenHidden(false);
    autoDriveSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    autoDriveSlot.SetAnchor(inkEAnchor.Centered);
    autoDriveSlot.SetAnchorPoint(Vector2(1.0, 0.0));

    root.RemoveChildByName(n"NewAutoDrive");
    autoDriveSlot.Reparent(root, 16);
    this.autoDriveSlot = autoDriveSlot;
  };

  if config.crystalCoatEnabled {
    let crystalCoatSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    crystalCoatSlot.SetName(n"NewCrystalCoat");
    crystalCoatSlot.SetFitToContent(true);
    crystalCoatSlot.SetInteractive(false);
    crystalCoatSlot.SetAffectsLayoutWhenHidden(false);
    crystalCoatSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    crystalCoatSlot.SetAnchor(inkEAnchor.Centered);
    crystalCoatSlot.SetAnchorPoint(Vector2(0.0, 1.0));

    root.RemoveChildByName(n"NewCrystalCoat");
    crystalCoatSlot.Reparent(root, 17);
    this.crystalCoatSlot = crystalCoatSlot;
  };

  if config.vehicleRadioEnabled {
    let vehicleRadioSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    vehicleRadioSlot.SetName(n"NewVehicleRadio");
    vehicleRadioSlot.SetFitToContent(true);
    vehicleRadioSlot.SetInteractive(false);
    vehicleRadioSlot.SetAffectsLayoutWhenHidden(false);
    vehicleRadioSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    vehicleRadioSlot.SetAnchor(inkEAnchor.Centered);
    vehicleRadioSlot.SetAnchorPoint(Vector2(0.0, 0.0));

    root.RemoveChildByName(n"NewVehicleRadio");
    vehicleRadioSlot.Reparent(root, 18);
    this.vehicleRadioSlot = vehicleRadioSlot;
  };

  if config.vehicleHotkeyEnabled {
    let vehicleHotkeySlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    vehicleHotkeySlot.SetName(n"NewVehicleHotkey");
    vehicleHotkeySlot.SetFitToContent(true);
    vehicleHotkeySlot.SetInteractive(false);
    vehicleHotkeySlot.SetAffectsLayoutWhenHidden(false);
    vehicleHotkeySlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    vehicleHotkeySlot.SetAnchor(inkEAnchor.Centered);
    vehicleHotkeySlot.SetAnchorPoint(Vector2(1.0, 1.0));

    root.RemoveChildByName(n"NewVehicleHotkey");
    vehicleHotkeySlot.Reparent(root, 19);
    this.vehicleHotkeySlot = vehicleHotkeySlot;
  };

  if config.bossHealthbarEnabled {
    let bossHealthbarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    bossHealthbarSlot.SetName(n"NewBossHealthbar");
    bossHealthbarSlot.SetFitToContent(true);
    bossHealthbarSlot.SetInteractive(false);
    bossHealthbarSlot.SetAffectsLayoutWhenHidden(false);
    bossHealthbarSlot.SetMargin(inkMargin(0.0, 60.0, 0.0, 0.0));
    bossHealthbarSlot.SetAnchor(inkEAnchor.TopCenter);
    bossHealthbarSlot.SetAnchorPoint(Vector2(0.5, 0.0));

    root.RemoveChildByName(n"NewBossHealthbar");
    bossHealthbarSlot.Reparent(root, 20);
    this.bossHealthbarSlot = bossHealthbarSlot;
  };

  if config.dialogChoicesEnabled {
    let dialogChoicesSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    dialogChoicesSlot.SetName(n"NewDialogChoices");
    dialogChoicesSlot.SetFitToContent(true);
    dialogChoicesSlot.SetInteractive(false);
    dialogChoicesSlot.SetAffectsLayoutWhenHidden(false);
    dialogChoicesSlot.SetMargin(inkMargin(0.0, 120.0, 0.0, 0.0));
    dialogChoicesSlot.SetAnchor(inkEAnchor.Centered);
    dialogChoicesSlot.SetAnchorPoint(Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewDialogChoices");
    dialogChoicesSlot.Reparent(root, 21);
    this.dialogChoicesSlot = dialogChoicesSlot;
  };

  if config.dialogSubtitlesEnabled {
    let dialogSubtitlesSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    dialogSubtitlesSlot.SetName(n"NewDialogSubtitles");
    dialogSubtitlesSlot.SetFitToContent(false);
    dialogSubtitlesSlot.SetInteractive(false);
    dialogSubtitlesSlot.SetAffectsLayoutWhenHidden(false);
    dialogSubtitlesSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 20.0));
    dialogSubtitlesSlot.SetAnchor(inkEAnchor.BottomFillHorizontaly);
    dialogSubtitlesSlot.SetAnchorPoint(Vector2(0.5, 1.0));
    root.RemoveChildByName(n"NewDialogSubtitles");
    dialogSubtitlesSlot.Reparent(root, 22);
    this.dialogSubtitlesSlot = dialogSubtitlesSlot;
  };

  if config.progressWidgetEnabled {
    let progressBarSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    progressBarSlot.SetName(n"NewProgressBar");
    progressBarSlot.SetFitToContent(false);
    progressBarSlot.SetInteractive(false);
    progressBarSlot.SetAffectsLayoutWhenHidden(false);
    progressBarSlot.SetAnchor(inkEAnchor.BottomCenter);
    progressBarSlot.SetAnchorPoint(Vector2(0.5, 1.0));
    root.RemoveChildByName(n"NewProgressBar");
    progressBarSlot.Reparent(root, 23);
    this.progressBarSlot = progressBarSlot;
  };

  if config.compatE3CompassEnabled {
    let e3CompassSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    e3CompassSlot.SetName(n"NewCompass");
    e3CompassSlot.SetFitToContent(false);
    e3CompassSlot.SetInteractive(false);
    e3CompassSlot.SetAffectsLayoutWhenHidden(false);
    e3CompassSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    e3CompassSlot.SetAnchor(inkEAnchor.Centered);
    e3CompassSlot.SetAnchorPoint(Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewCompass");
    e3CompassSlot.Reparent(root, 24);
    this.e3CompassSlot = e3CompassSlot;
  };

  if config.fpsCounterEnabled {
    let fpsCounterSlot: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    fpsCounterSlot.SetName(n"NewFpsCounter");
    fpsCounterSlot.SetFitToContent(false);
    fpsCounterSlot.SetInteractive(false);
    fpsCounterSlot.SetAffectsLayoutWhenHidden(false);
    fpsCounterSlot.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    fpsCounterSlot.SetAnchor(inkEAnchor.Centered);
    fpsCounterSlot.SetAnchorPoint(Vector2(0.5, 0.5));

    root.RemoveChildByName(n"NewFpsCounter");
    fpsCounterSlot.Reparent(root, 25);
    this.fpsCounterSlot = fpsCounterSlot;
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
        targetWidget.SetAnchorPoint(Vector2(1.0, 0.0));
        targetWidget.Reparent(this.questTrackerSlot);
        break;
      case n"gameuiMinimapContainerController":
        if !config.minimapEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 0.0));
        targetWidget.Reparent(this.minimapSlot);
        break;
      case n"WantedBarGameController":
        if !config.wantedBarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.wantedSlot);
        break;
      case n"JournalNotificationQueue":
        if !config.questNotificationsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.questNotificationsSlot);
        break;
      case n"ItemsNotificationQueue":
        if !config.itemNotificationsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 0.0));
        targetWidget.Reparent(this.itemNotificationsSlot);
        break;
      case n"VehicleSummonWidgetGameController":
        if !config.vehicleSummonEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 1.0));
        targetWidget.Reparent(this.vehicleSummonSlot);
        break;
      case n"gameuiWeaponRosterGameController":
        if !config.weaponRosterEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 1.0));
        targetWidget.Reparent(this.weaponRosterSlot);
        break;
      case n"CrouchIndicatorGameController":
        if !config.crouchIndicatorEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 1.0));
        targetWidget.Reparent(this.crouchIndicatorSlot);
        break;
      case n"HotkeysWidgetController":
        if !config.dpadEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.dpadSlot);
        break;
      case n"PhoneHotkeyController":
      if !config.phoneHotkeyEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 0.5));
        targetWidget.Reparent(this.phoneHotkeySlot);
        break;
      case n"gameuiHudHealthbarGameController":
        if !config.playerHealthbarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 0.0));
        targetWidget.Reparent(this.healthbarSlot);
        break;
      case n"StaminabarWidgetGameController":
        if !config.playerStaminabarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 0.0));
        targetWidget.Reparent(this.staminaBarSlot);
        break;
      case n"gameuiInputHintManagerGameController":
        if !config.inputHintsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 0.5));
        targetWidget.Reparent(this.inputHintSlot);
        break;
      case n"hudCarController":
        if !config.speedometerEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.carHudSlot);
        break;
      case n"AutoDriveController":
        if !config.autoDriveEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.autoDriveSlot);
        break;
      case n"vehicleVisualCustomizationHotkeyController":
        if !config.crystalCoatEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.crystalCoatSlot);
        break;
      case n"RadioHotkeyController":
        if !config.vehicleRadioEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.vehicleRadioSlot);
        break;
      case n"BossHealthBarGameController":
        if !config.bossHealthbarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 0.0));
        targetWidget.Reparent(this.bossHealthbarSlot);
        break;
      case n"dialogWidgetGameController":
        if !config.dialogChoicesEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 0.5));
        targetWidget.Reparent(this.dialogChoicesSlot);
        break;
      case n"SubtitlesGameController":
        if !config.dialogSubtitlesEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 1.0));
        targetWidget.Reparent(this.dialogSubtitlesSlot);
        break;
      case n"HUDProgressBarController":
        if !config.progressWidgetEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 1.0));
        targetWidget.Reparent(this.progressBarSlot);
        break;
      case n"IronsightGameController":
        if !config.compatE3CompassEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.e3CompassSlot);
        break;
    };
  }

  this.QueueEvent(new HuditorInitializedEvent());
}

@addMethod(inkGameController)
private func InitResolutionWatcher() -> Void {
  let system: ref<HUDitorWatcher> = HUDitorWatcher.Get(GetGameInstance());
  system.AddTarget(this.huditorWidgetName);
  
  if IsDefined(this.minimapSlot) { system.AddTarget(this.minimapSlot); }
  if IsDefined(this.questTrackerSlot) { system.AddTarget(this.questTrackerSlot); }
  if IsDefined(this.wantedSlot) { system.AddTarget(this.wantedSlot); }
  if IsDefined(this.questNotificationsSlot) { system.AddTarget(this.questNotificationsSlot); }
  if IsDefined(this.itemNotificationsSlot) { system.AddTarget(this.itemNotificationsSlot); }
  if IsDefined(this.vehicleSummonSlot) { system.AddTarget(this.vehicleSummonSlot); }
  if IsDefined(this.weaponRosterSlot) { system.AddTarget(this.weaponRosterSlot); }
  if IsDefined(this.crouchIndicatorSlot) { system.AddTarget(this.crouchIndicatorSlot); }
  if IsDefined(this.dpadSlot) { system.AddTarget(this.dpadSlot); }
  if IsDefined(this.phoneHotkeySlot) { system.AddTarget(this.phoneHotkeySlot); }
  if IsDefined(this.healthbarSlot) { system.AddTarget(this.healthbarSlot); }
  if IsDefined(this.staminaBarSlot) { system.AddTarget(this.staminaBarSlot); }
  if IsDefined(this.phoneCallAvatarSlot) { system.AddTarget(this.phoneCallAvatarSlot); }
  if IsDefined(this.phoneControlSlot) { system.AddTarget(this.phoneControlSlot); }
  if IsDefined(this.inputHintSlot) { system.AddTarget(this.inputHintSlot); }
  if IsDefined(this.carHudSlot) { system.AddTarget(this.carHudSlot); }
  if IsDefined(this.bossHealthbarSlot) { system.AddTarget(this.bossHealthbarSlot); }
  if IsDefined(this.dialogChoicesSlot) { system.AddTarget(this.dialogChoicesSlot); }
  if IsDefined(this.dialogSubtitlesSlot) { system.AddTarget(this.dialogSubtitlesSlot); }
  if IsDefined(this.progressBarSlot) { system.AddTarget(this.progressBarSlot); }
  if IsDefined(this.e3CompassSlot) { system.AddTarget(this.e3CompassSlot); }
  if IsDefined(this.fpsCounterSlot) { system.AddTarget(this.fpsCounterSlot); }
}

@addMethod(inkGameController)
protected cb func OnHijackSlotsEvent(evt: ref<HijackSlotsEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.InitWidgetNameLabel();
    this.CreateCustomSlots();
    this.InitResolutionWatcher();
    this.InitBaseWidgets();
  };
}

// -- Reparent incoming call parts separately
@wrapMethod(HoloAudioCallLogicController)
protected cb func OnInitialize() -> Bool {
  let wrap: Bool = wrappedMethod();
  let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(GetGameInstance());
  let carHudUnlocked: Bool = questSystem.GetFact(n"unlock_car_hud_dpad") > 0;

  let system: ref<inkSystem> = GameInstance.GetInkSystem();
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let newParent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"NewPhoneAvatar") as inkCompoundWidget;
  let targetWidget: ref<inkCompoundWidget>;
  if config.incomingCallAvatarEnabled && carHudUnlocked { 
    targetWidget= this.GetRootCompoundWidget();
    targetWidget.SetAnchorPoint(Vector2(0.5, 0.5));
    targetWidget.Reparent(newParent, 24);
  };
  return wrap;
}

@wrapMethod(IncomingCallLogicController)
protected cb func OnInitialize() -> Bool {
  let wrap: Bool = wrappedMethod();
  let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(GetGameInstance());
  let carHudUnlocked: Bool = questSystem.GetFact(n"unlock_car_hud_dpad") > 0;
  let system: ref<inkSystem> = GameInstance.GetInkSystem();
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let newParent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"NewPhoneControl") as inkCompoundWidget;
  let targetWidget: ref<inkCompoundWidget>;
  if config.incomingCallAvatarEnabled && carHudUnlocked { 
    targetWidget= this.GetRootCompoundWidget();
    targetWidget.SetAnchorPoint(Vector2(0.5, 0.5));
    targetWidget.Reparent(newParent, 25);
  };
  return wrap;
}

// -- Phone avatar fluff cleanup (kudos to Strahlimeier)
@wrapMethod(NewHudPhoneGameController)
private func SetPhoneFunction(newState: EHudPhoneFunction) -> Void {
  wrappedMethod(newState);
 
  // When phone goes inactive, clean up avatar slot
  if Equals(newState, EHudPhoneFunction.Inactive) {
    let system: ref<inkSystem> = GameInstance.GetInkSystem();
    if IsDefined(system) {
      let hudRoot: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
      if IsDefined(hudRoot) {
        let phoneAvatarSlot: ref<inkCompoundWidget> = hudRoot.GetWidgetByPathName(n"NewPhoneAvatar") as inkCompoundWidget;
        if IsDefined(phoneAvatarSlot) {
          phoneAvatarSlot.RemoveAllChildren();
        };
      };
    };
  };
}

// -- FPS Counter hacks
@addMethod(inkHUDGameController)
protected cb func OnReparentFpsCounterEvent(evt: ref<ReparentFpsCounterEvent>) -> Bool {
  if this.IsA(n"gameuiFPSCounterGameController") {
    let system: ref<inkSystem> = GameInstance.GetInkSystem();
    let hudRoot: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let container: ref<inkCompoundWidget> = hudRoot.GetWidgetByPathName(n"NewFpsCounter") as inkCompoundWidget;
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    root.Reparent(container, 26);
  };
}

@if(ModuleExists("FpsCounter"))
@addMethod(inkHUDGameController)
protected cb func OnHuditorFpsCounterTrack(evt: ref<FPSCounterChangeStateEvent>) -> Bool {
  if this.IsA(n"gameuiFPSCounterGameController") {
    let system: ref<inkSystem> = GameInstance.GetInkSystem();
    let hudRoot: ref<inkCompoundWidget>;
    let container: ref<inkCompoundWidget>;
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    if Equals(root.parentWidget.GetName(), n"HUDMiddleWidget") {
      hudRoot = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
      container = hudRoot.GetWidgetByPathName(n"NewFpsCounter") as inkCompoundWidget;
      root.Reparent(container, 27);
    };
  };
}

// -- Reparent vehicle hotkey
@addMethod(HotkeysWidgetController)
protected cb func OnHuditorInitializedEvent(evt: ref<HuditorInitializedEvent>) -> Bool {
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  let vehicleSlot: ref<inkWidget>;
  let system: ref<inkSystem>;
  let root: ref<inkCompoundWidget>;
  let newParent: ref<inkCompoundWidget>;

  if config.vehicleHotkeyEnabled {
    vehicleSlot = this.GetRootCompoundWidget().GetWidget(n"mainCanvas/vehicleSlot");
    system = GameInstance.GetInkSystem();
    root = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    newParent = root.GetWidgetByPathName(n"NewVehicleHotkey") as inkCompoundWidget;
    vehicleSlot.Reparent(newParent);
  };
}
