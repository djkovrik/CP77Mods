import Codeware.UI.inkCustomController
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
protected cb func OnActiveHuditorWidgetChanged(event: ref<SetActiveHUDEditorWidgetEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.huditorWidgetName.SetVisible(true);
    this.huditorWidgetName.SetText(HUDitorTexts.GetWidgetName(event.activeWidget));
  };
}

@addMethod(inkGameController)
protected cb func OnHuditorDisableEvent(event: ref<DisableHUDEditorEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.huditorWidgetName.SetVisible(false);
  };
}

@addMethod(inkGameController)
protected cb func OnScannerDetailsAppearedEvent(event: ref<ScannerDetailsAppearedEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnScannerDetailsAppearedEvent(event);
    this.questTrackerSlot.OnScannerDetailsAppearedEvent(event);
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
    let questTrackerSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewTracker");
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
    let minimapSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewMinimap");
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
    let wantedSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewWanted");
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
    let questNotificationsSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewQuestNotifications");
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
    let itemNotificationsSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewItemNotifications");
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
    let vehicleSummonSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewVehicleSummon");
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
    let weaponRosterSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewWeaponRoster");
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
    let crouchIndicatorSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewCrouchIndicator");
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
    let dpadSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewDpad");
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
    let phoneHotkeySlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewPhoneHotkey");
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
    let healthbarSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewHealthBar");
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
    let staminaBarSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewStaminaBar");
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
    let phoneCallAvatarSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewPhoneAvatar");
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
    let phoneControlSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewPhoneControl");
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
    let inputHintSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewInputHint");
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
    let carHudSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewCarHud");
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
    let autoDriveSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewAutoDrive");
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
    let crystalCoatSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewCrystalCoat");
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
    let vehicleRadioSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewVehicleRadio");
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
    let vehicleHotkeySlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewVehicleHotkey");
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
    let bossHealthbarSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewBossHealthbar");
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
    let dialogChoicesSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewDialogChoices");
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
    let dialogSubtitlesSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewDialogSubtitles");
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
    let progressBarSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewProgressBar");
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
    let e3CompassSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewCompass");
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
    let fpsCounterSlot: ref<HUDitorCustomSlot> = HUDitorCustomSlot.Create(n"NewFpsCounter");
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
        targetWidget.Reparent(this.questTrackerSlot.GetRootCompoundWidget());
        break;
      case n"gameuiMinimapContainerController":
        if !config.minimapEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 0.0));
        targetWidget.Reparent(this.minimapSlot.GetRootCompoundWidget());
        break;
      case n"WantedBarGameController":
        if !config.wantedBarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.wantedSlot.GetRootCompoundWidget());
        break;
      case n"JournalNotificationQueue":
        if !config.questNotificationsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.questNotificationsSlot.GetRootCompoundWidget());
        break;
      case n"ItemsNotificationQueue":
        if !config.itemNotificationsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 0.0));
        targetWidget.Reparent(this.itemNotificationsSlot.GetRootCompoundWidget());
        break;
      case n"VehicleSummonWidgetGameController":
        if !config.vehicleSummonEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 1.0));
        targetWidget.Reparent(this.vehicleSummonSlot.GetRootCompoundWidget());
        break;
      case n"gameuiWeaponRosterGameController":
        if !config.weaponRosterEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 1.0));
        targetWidget.Reparent(this.weaponRosterSlot.GetRootCompoundWidget());
        break;
      case n"CrouchIndicatorGameController":
        if !config.crouchIndicatorEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 1.0));
        targetWidget.Reparent(this.crouchIndicatorSlot.GetRootCompoundWidget());
        break;
      case n"HotkeysWidgetController":
        if !config.dpadEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.dpadSlot.GetRootCompoundWidget());
        break;
      case n"PhoneHotkeyController":
      if !config.phoneHotkeyEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 0.5));
        targetWidget.Reparent(this.phoneHotkeySlot.GetRootCompoundWidget());
        break;
      case n"gameuiHudHealthbarGameController":
        if !config.playerHealthbarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 0.0));
        targetWidget.Reparent(this.healthbarSlot.GetRootCompoundWidget());
        break;
      case n"StaminabarWidgetGameController":
        if !config.playerStaminabarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 0.0));
        targetWidget.Reparent(this.staminaBarSlot.GetRootCompoundWidget());
        break;
      case n"gameuiInputHintManagerGameController":
        if !config.inputHintsEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(1.0, 0.5));
        targetWidget.Reparent(this.inputHintSlot.GetRootCompoundWidget());
        break;
      case n"hudCarController":
        if !config.speedometerEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.carHudSlot.GetRootCompoundWidget());
        break;
      case n"AutoDriveController":
        if !config.autoDriveEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.autoDriveSlot.GetRootCompoundWidget());
        break;
      case n"vehicleVisualCustomizationHotkeyController":
        if !config.crystalCoatEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.crystalCoatSlot.GetRootCompoundWidget());
        break;
      case n"RadioHotkeyController":
        if !config.vehicleRadioEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.0, 1.0));
        targetWidget.Reparent(this.vehicleRadioSlot.GetRootCompoundWidget());
        break;
      case n"BossHealthBarGameController":
        if !config.bossHealthbarEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 0.0));
        targetWidget.Reparent(this.bossHealthbarSlot.GetRootCompoundWidget());
        break;
      case n"dialogWidgetGameController":
        if !config.dialogChoicesEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 0.5));
        targetWidget.Reparent(this.dialogChoicesSlot.GetRootCompoundWidget());
        break;
      case n"SubtitlesGameController":
        if !config.dialogSubtitlesEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 1.0));
        targetWidget.Reparent(this.dialogSubtitlesSlot.GetRootCompoundWidget());
        break;
      case n"HUDProgressBarController":
        if !config.progressWidgetEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.SetAnchorPoint(Vector2(0.5, 1.0));
        targetWidget.Reparent(this.progressBarSlot.GetRootCompoundWidget());
        break;
      case n"IronsightGameController":
        if !config.compatE3CompassEnabled { break; }
        targetWidget = controller.GetRootCompoundWidget();
        targetWidget.Reparent(this.e3CompassSlot.GetRootCompoundWidget());
        break;
    };
  }

  this.QueueEvent(new HuditorInitializedEvent());
}

@addMethod(inkGameController)
private func InitResolutionWatcher() -> Void {
  let system: ref<HUDitorWatcher> = HUDitorWatcher.Get(GetGameInstance());
  system.AddTarget(this.huditorWidgetName);
  
  if IsDefined(this.minimapSlot) { system.AddTarget(this.minimapSlot.GetRootCompoundWidget()); }
  if IsDefined(this.questTrackerSlot) { system.AddTarget(this.questTrackerSlot.GetRootCompoundWidget()); }
  if IsDefined(this.wantedSlot) { system.AddTarget(this.wantedSlot.GetRootCompoundWidget()); }
  if IsDefined(this.questNotificationsSlot) { system.AddTarget(this.questNotificationsSlot.GetRootCompoundWidget()); }
  if IsDefined(this.itemNotificationsSlot) { system.AddTarget(this.itemNotificationsSlot.GetRootCompoundWidget()); }
  if IsDefined(this.vehicleSummonSlot) { system.AddTarget(this.vehicleSummonSlot.GetRootCompoundWidget()); }
  if IsDefined(this.weaponRosterSlot) { system.AddTarget(this.weaponRosterSlot.GetRootCompoundWidget()); }
  if IsDefined(this.crouchIndicatorSlot) { system.AddTarget(this.crouchIndicatorSlot.GetRootCompoundWidget()); }
  if IsDefined(this.dpadSlot) { system.AddTarget(this.dpadSlot.GetRootCompoundWidget()); }
  if IsDefined(this.phoneHotkeySlot) { system.AddTarget(this.phoneHotkeySlot.GetRootCompoundWidget()); }
  if IsDefined(this.healthbarSlot) { system.AddTarget(this.healthbarSlot.GetRootCompoundWidget()); }
  if IsDefined(this.staminaBarSlot) { system.AddTarget(this.staminaBarSlot.GetRootCompoundWidget()); }
  if IsDefined(this.phoneCallAvatarSlot) { system.AddTarget(this.phoneCallAvatarSlot.GetRootCompoundWidget()); }
  if IsDefined(this.phoneControlSlot) { system.AddTarget(this.phoneControlSlot.GetRootCompoundWidget()); }
  if IsDefined(this.inputHintSlot) { system.AddTarget(this.inputHintSlot.GetRootCompoundWidget()); }
  if IsDefined(this.carHudSlot) { system.AddTarget(this.carHudSlot.GetRootCompoundWidget()); }
  if IsDefined(this.bossHealthbarSlot) { system.AddTarget(this.bossHealthbarSlot.GetRootCompoundWidget()); }
  if IsDefined(this.dialogChoicesSlot) { system.AddTarget(this.dialogChoicesSlot.GetRootCompoundWidget()); }
  if IsDefined(this.dialogSubtitlesSlot) { system.AddTarget(this.dialogSubtitlesSlot.GetRootCompoundWidget()); }
  if IsDefined(this.progressBarSlot) { system.AddTarget(this.progressBarSlot.GetRootCompoundWidget()); }
  if IsDefined(this.e3CompassSlot) { system.AddTarget(this.e3CompassSlot.GetRootCompoundWidget()); }
  if IsDefined(this.fpsCounterSlot) { system.AddTarget(this.fpsCounterSlot.GetRootCompoundWidget()); }
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
