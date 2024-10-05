import HUDrag.HUDitorConfig
import HUDrag.HUDWidgetsManager.*

@addField(inkGameController)
public let originalOpacity: Float;

@addField(inkGameController)
public let originalVisibility: Bool;

@addMethod(inkGameController)
protected cb func OnDisplayPreviewEvent(event: ref<DisplayPreviewEvent>) -> Bool {
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  if config.questTrackerEnabled { this.ShowQuestTracker(true); }
  if config.minimapEnabled && !config.compatE3CompassEnabled { this.ShowMinimap(true); }
  if config.wantedBarEnabled { this.ShowWantedBar(true); }
  if config.vehicleSummonEnabled { this.ShowVehicleSummonNotification(true); }
  if config.weaponRosterEnabled { this.ShowAmmoCounter(true); }
  if config.crouchIndicatorEnabled { this.ShowCrouchIndicator(true); }
  if config.dpadEnabled { this.ShowDpad(true); }
  if config.phoneHotkeyEnabled { this.ShowPhoneHotkey(true); }
  if config.playerHealthbarEnabled { this.ShowHealthbar(true); }
  if config.playerStaminabarEnabled { this.ShowStaminaBar(true); }
  if config.incomingCallAvatarEnabled { this.ShowIncomingPhoneCall(true); }
  if config.inputHintsEnabled { this.ShowInputHints(true); }
  if config.speedometerEnabled { this.ShowCarHUD(true); }
  if config.bossHealthbarEnabled { this.ShowBossHealthbar(true); }
  if config.dialogChoicesEnabled { this.ShowDialogPreview(true); }
  if config.dialogSubtitlesEnabled { this.ShowSubtitlesPreview(true); }
  if config.progressWidgetEnabled { this.ShowHudProgressBarController(true); }
}

// Can't show both notification previews at the same time so moved here to show preview when widget selected
@addMethod(inkGameController)
protected cb func OnActiveWidgetChanged(event: ref<SetActiveHUDEditorWidgetEvent>) -> Bool {
  let widgetName: CName = event.activeWidget;
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  if this.IsA(n"JournalNotificationQueue") && Equals(widgetName, n"NewQuestNotifications") && config.questNotificationsEnabled { 
    this.ShowJournalNotification(); 
  };

  if this.IsA(n"ItemsNotificationQueue") && Equals(widgetName, n"NewItemNotifications") &&config.itemNotificationsEnabled { 
    this.ShowItemsNotification(); 
  };
}

@addMethod(inkGameController)
protected cb func OnHidePreviewEvent(event: ref<HidePreviewEvent>) -> Bool {
  this.ShowQuestTracker(false);
  this.ShowMinimap(false);
  this.ShowWantedBar(false);
  this.ShowVehicleSummonNotification(false);
  this.ShowAmmoCounter(false);
  this.ShowCrouchIndicator(false);
  this.ShowDpad(false);
  this.ShowPhoneHotkey(false);
  this.ShowHealthbar(false);
  this.ShowStaminaBar(false);
  this.ShowIncomingPhoneCall(false);
  this.ShowInputHints(false);
  this.ShowCarHUD(false);
  this.ShowBossHealthbar(false);
  this.ShowDialogPreview(false);
  this.ShowSubtitlesPreview(false);
  this.ShowHudProgressBarController(false);
}

// Preview helpers
@addMethod(inkGameController)
private func ShowQuestTracker(show: Bool) -> Void {
  if this.IsA(n"QuestTrackerGameController") {
    if show {
      this.originalOpacity = this.GetRootWidget().GetOpacity();
      this.GetRootWidget().SetOpacity(1.0);
    } else {
      this.GetRootWidget().SetOpacity(this.originalOpacity);
    };
  };
}

@addMethod(inkGameController)
private func ShowMinimap(show: Bool) -> Void {
  if this.IsA(n"gameuiMinimapContainerController") {
    if show {
      this.originalOpacity = this.GetRootWidget().GetOpacity();
      this.GetRootWidget().SetOpacity(1.0);
    } else {
      this.GetRootWidget().SetOpacity(this.originalOpacity);
    };
  };
}

@addMethod(inkGameController)
private func ShowWantedBar(show: Bool) -> Void {
  if this.IsA(n"WantedBarGameController") {
    let controller = this as WantedBarGameController;
    let stars: Int32;
    if show {
      stars = 5;
    } else {
      stars = 0;
    }
    controller.OnWantedDataChange(stars);
  };
}


@addMethod(inkGameController)
private func ShowJournalNotification() -> Void {
  if this.IsA(n"JournalNotificationQueue") {
    let controller = this as JournalNotificationQueue;
    let notificationData: gameuiGenericNotificationData;
    let userData: ref<PhoneMessageNotificationViewData> = new PhoneMessageNotificationViewData();
    userData.entryHash = -1;
    userData.threadHash = -1;
    userData.contactHash = -1;
    userData.title = "Preview notifications";
    userData.SMSText = "Will disappear after 10 seconds";
    userData.action = new GenericNotificationBaseAction();
    userData.animation = n"notification_phone_MSG";
    userData.soundEvent = n"PhoneSmsPopup";
    userData.soundAction = n"OnOpen";
    notificationData.time = 10.0;
    notificationData.widgetLibraryItemName = n"notification_message";
    notificationData.notificationData = userData;
    controller.AddNewNotificationData(notificationData);
  };
}

@addMethod(inkGameController)
private func ShowItemsNotification() -> Void {
  if this.IsA(n"ItemsNotificationQueue") {
    let controller = this as ItemsNotificationQueue;
    let data: ref<ItemAddedNotificationViewData>;
    let notificationData: gameuiGenericNotificationData;
    data = new ItemAddedNotificationViewData();
    data.animation = n"Item_Received";
    data.itemRarity = n"epic";
    data.itemID = ItemID.FromTDBID(t"Items.Pants_03_rich_01");
    data.title = GetLocalizedText("Story-base-gameplay-gui-widgets-notifications-quest_update-_localizationString19");
    notificationData.time = 10.0;
    notificationData.widgetLibraryItemName = controller.m_itemNotification;
    notificationData.notificationData = data;
    controller.AddNewNotificationData(notificationData);
  };
}

@addMethod(inkGameController)
private func ShowVehicleSummonNotification(show: Bool) -> Void {
  if this.IsA(n"VehicleSummonWidgetGameController") {
    let controller = this as VehicleSummonWidgetGameController;
    controller.OnVehicleSummonStateChanged(1u);
    controller.m_rootWidget.SetVisible(show);
    let textParams: ref<inkTextParams> = new inkTextParams();
    textParams.AddMeasurement("distance", Cast<Float>(123), EMeasurementUnit.Meter);
    textParams.AddString("unit", GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(UILocalizationHelper.GetSystemBaseUnit()))));
    inkTextRef.SetText(controller.m_distanceLabel, "123M", textParams);
    controller.PlayAnimation(n"intro");
    let options: inkAnimOptions;
    options.loopType = inkanimLoopType.Cycle;
    options.loopCounter = 35u;
    controller.m_animationCounterProxy = controller.PlayLibraryAnimation(n"counter", options);
    GameInstance.GetAudioSystem(controller.m_gameInstance).Play(n"ui_jingle_car_call");
    inkTextRef.SetLocalizedTextScript(controller.m_vehicleNameLabel, "Your vehicle name");
  };
}

@addMethod(inkGameController)
private func ShowAmmoCounter(show: Bool) -> Void {
  if this.IsA(n"weaponRosterGameController") {
    let controller: ref<WeaponRosterGameController> = this as WeaponRosterGameController;
    if show {
      this.originalVisibility = controller.m_folded;
      if this.originalVisibility {
        controller.Unfold();
      };
    } else {
      if this.originalVisibility {
        controller.Fold();
      };
    };
  };
}

@addMethod(inkGameController)
private func ShowCrouchIndicator(show: Bool) -> Void {
  if this.IsA(n"CrouchIndicatorGameController") {
    if show {
      this.originalOpacity = this.GetRootWidget().GetOpacity();
      this.GetRootWidget().SetOpacity(1.0);
    } else {
      this.GetRootWidget().SetOpacity(this.originalOpacity);
    };
  };
}

@if(!ModuleExists("CustomQuickslotsConfig"))
@addMethod(HotkeysWidgetController)
public func RefreshHUDitor() -> Void {
  // do nothing
}

@if(ModuleExists("CustomQuickslotsConfig"))
@addMethod(HotkeysWidgetController)
public func RefreshHUDitor() -> Void {
  this.CustomQuickslotsRefreshSlots();
}

@addMethod(inkGameController)
private func ShowPhoneHotkey(show: Bool) -> Void {
  if this.IsA(n"PhoneHotkeyController") {
    let controller = this as PhoneHotkeyController;
    if show {
      this.originalVisibility = controller.GetRootWidget().IsVisible();
      controller.ToggleVisibility(true, true);
    } else {
      controller.ToggleVisibility(this.originalVisibility, true);
    };
  };
}

@addMethod(inkGameController)
private func ShowDpad(show: Bool) -> Void {
  if this.IsA(n"HotkeysWidgetController") {
    let controller = this as HotkeysWidgetController;
    if show {
      this.originalOpacity = this.GetRootWidget().GetOpacity();
      this.GetRootWidget().SetOpacity(1.0);
    } else {
      this.GetRootWidget().SetOpacity(this.originalOpacity);
    };
    controller.RefreshHUDitor();
  };
}


@addMethod(inkGameController)
private func ShowHealthbar(show: Bool) -> Void {
  if this.IsA(n"healthbarWidgetGameController") {
    let controller = this as healthbarWidgetGameController;
    if show {
      controller.ShowRequest();
    } else {
      controller.OnUpdateHealthBarVisibility();
    };
  };
}

@addMethod(inkGameController)
private func ShowStaminaBar(show: Bool) -> Void {
  if this.IsA(n"StaminabarWidgetGameController") {
    let controller = this as StaminabarWidgetGameController;
    controller.UpdateStaminaValue(70.0, 87.7, 11.0, gamedataStatPoolType.Stamina);

    if show {
      controller.m_RootWidget.SetOpacity(1.0);
      controller.m_RootWidget.SetVisible(true);
    } else {
      controller.m_RootWidget.SetOpacity(0.0);
      controller.m_RootWidget.SetVisible(false);
    };
  };
}

@addMethod(inkGameController)
private func ShowInputHints(show: Bool) -> Void {
  if this.IsA(n"gameuiInputHintManagerGameController") {
    if show {
      this.originalOpacity = this.GetRootWidget().GetOpacity();
      this.GetRootWidget().SetOpacity(1.0);
    } else {
      this.GetRootWidget().SetOpacity(this.originalOpacity);
    };
  };
}

@addMethod(inkGameController)
private func ShowCarHUD(show: Bool) -> Void {
  if IsDefined(this.carHudSlotPreview) {
    this.carHudSlotPreview.SetVisible(show);
  };
}

@addMethod(inkGameController)
private func ShowBossHealthbar(show: Bool) -> Void {
  if this.IsA(n"BossHealthBarGameController") {
    let controller = this as BossHealthBarGameController;
    controller.m_root.SetVisible(show);

    if show {
      inkTextRef.SetText(controller.m_bossName, "Boss name here");
      controller.UpdateHealthValue(75);
      if IsDefined(controller.m_foldAnimation) {
        controller.m_foldAnimation.Stop();
      };
      controller.m_foldAnimation = this.PlayLibraryAnimation(n"unfold");
    } else {
      if IsDefined(controller.m_foldAnimation) {
        controller.m_foldAnimation.Stop();
      };
      controller.m_foldAnimation = this.PlayLibraryAnimation(n"fold");
    };
  };
}

@addMethod(inkGameController)
private func ShowDialogPreview(show: Bool) -> Void {
  let controller: ref<dialogWidgetGameController>;
  let root: ref<inkCompoundWidget>;
  let preview: ref<inkWidget>;
  if this.IsA(n"dialogWidgetGameController") {
    controller = this as dialogWidgetGameController;
    root = this.GetRootCompoundWidget();
    if show {
      preview = new inkRectangle();
      preview.SetName(n"previewFill");
      preview.SetHAlign(inkEHorizontalAlign.Fill);
      preview.SetVAlign(inkEVerticalAlign.Fill);
      preview.SetAnchor(inkEAnchor.Fill);
      preview.SetTintColor(new HDRColor(1.0, 0.0, 0.0, 1.0));
      preview.SetSize(new Vector2(500.0, 200.0));
      if Equals(ArraySize(controller.m_data.choiceHubs), 0) {
        preview.Reparent(root);
      };
    } else {
      root.RemoveChildByName(n"previewFill");
    };
  };
}

@addMethod(inkGameController)
private func ShowSubtitlesPreview(show: Bool) -> Void {
  let controller: ref<SubtitlesGameController>;
  let data: ref<LineSpawnData>;
  let dataStruct: scnDialogLineData;
  if this.IsA(n"SubtitlesGameController") {
    controller = this as SubtitlesGameController;
    if show {
      data = new LineSpawnData();
      dataStruct.text = "Good morning, Night City! Yesterday's body-count lottery rounded out to a solid 'n' sturdy thirty! Ten outta Heywood thanks to unabated gang wars!";
      dataStruct.speaker = this.GetPlayerControlledObject();
      dataStruct.speakerName = "Speaker";
      dataStruct.isPersistent = false;
      dataStruct.type = scnDialogLineType.Regular;
      dataStruct.duration = 20.0;
      data.m_lineData = dataStruct;
      controller.CreateLine(data);
    } else {
      controller.m_subtitlesPanel.RemoveAllChildren();
    };
  };
}

@addMethod(inkGameController)
private func ShowIncomingPhoneCall(show: Bool) -> Void {
  if this.IsA(n"NewHudPhoneGameController") {
    let controller = this as NewHudPhoneGameController;
    let phoneCallInfo: PhoneCallInformation;
    phoneCallInfo.callMode = questPhoneCallMode.Video;
    phoneCallInfo.isAudioCall = false;
    phoneCallInfo.contactName = n"jackie";
    phoneCallInfo.isPlayerCalling = true;
    phoneCallInfo.isPlayerTriggered = true;
    if show {
      phoneCallInfo.callPhase = questPhoneCallPhase.IncomingCall;
    } else {
      phoneCallInfo.callPhase = questPhoneCallPhase.EndCall;
    };
    controller.m_CurrentCallInformation = phoneCallInfo;
    controller.m_CurrentPhoneCallContact = controller.GetIncomingContact();
    if show {
      controller.SetPhoneFunction(EHudPhoneFunction.IncomingCall);
      controller.incomingCallElement.request = this.AsyncSpawnFromLocal(inkWidgetRef.Get(controller.incomingCallElement.slot), controller.incomingCallElement.libraryID, this, n"OnIncommingCallSpawned");
      controller.HandleCall();
    } else {
      controller.CancelPendingSpawnRequests();
      controller.SetTalkingTrigger(controller.m_CurrentCallInformation.isPlayerCalling, questPhoneTalkingState.Ended);
      controller.SetPhoneFunction(EHudPhoneFunction.Inactive);
      
      let system: ref<inkSystem> = GameInstance.GetInkSystem();
      let hudRoot: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
      let phoneAvatar: ref<inkCompoundWidget> = hudRoot.GetWidgetByPathName(n"NewPhoneAvatar") as inkCompoundWidget;
      phoneAvatar.RemoveAllChildren();
    };
  };
}

@wrapMethod(IncomingCallLogicController)
protected cb func OnRingAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
  let previewActive: Bool = HUDWidgetsManager.GetInstance().IsActive();
  if previewActive {
    this.m_animProxy = this.PlayLibraryAnimation(n"ring");
    this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnRingAnimFinished");
  } else {
    wrappedMethod(proxy);
  };
}

@addMethod(inkGameController)
private func ShowHudProgressBarController(show: Bool) -> Void {
  if this.IsA(n"HUDProgressBarController") {
    let controller = this as HUDProgressBarController;
    controller.m_type = SimpleMessageType.Reveal;
    controller.UpdateRevealType();
    controller.OnProgressChanged(0.5);
    controller.UpdateTimerHeader("Tracing your position");
    controller.m_rootWidget.SetVisible(show);
  };
}
