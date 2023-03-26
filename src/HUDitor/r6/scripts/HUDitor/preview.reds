import HUDrag.HUDitorConfig

@addField(inkGameController)
public let originalOpacity: Float;

@addField(inkGameController)
public let originalVisibility: Bool;

@addMethod(inkGameController)
protected cb func OnDisplayPreviewEvent(event: ref<DisplayPreviewEvent>) -> Bool {
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  if config.questTrackerEnabled { this.ShowQuestTracker(true); }
  if config.minimapEnabled { this.ShowMinimap(true); }
  if config.wantedBarEnabled { this.ShowWantedBar(true); }
  if config.questNotificationsEnabled { this.ShowJournalNotification(); }
  if config.itemNotificationsEnabled { this.ShowItemsNotification(); }
  if config.vehicleSummonEnabled { this.ShowVehicleSummonNotification(true); }
  if config.weaponRosterEnabled { this.ShowAmmoCounter(true); }
  if config.crouchIndicatorEnabled { this.ShowCrouchIndicator(true); }
  if config.dpadEnabled { this.ShowDpad(true); }
  if config.playerHealthbarEnabled { this.ShowHealthbar(true); }
  if config.playerStaminabarEnabled { this.ShowStaminaBar(true); }
  if config.incomingCallAvatarEnabled { this.ShowIncomingPhoneCall(n"jackie", true); }
  if config.incomingCallButtonEnabled { this.ShowIncomingCallController(n"jackie", true); }
  if config.inputHintsEnabled { this.ShowInputHints(true); }
  // if config.speedometerEnabled no preview here;
  if config.bossHealthbarEnabled { this.ShowBossHealthbar(true); }
  if config.dialogChoicesEnabled { this.ShowDialogPreview(true); }
  if config.dialogSubtitlesEnabled { this.ShowSubtitlesPreview(true); }
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
  this.ShowHealthbar(false);
  this.ShowStaminaBar(false);
  this.ShowIncomingPhoneCall(n"jackie", false);
  this.ShowIncomingCallController(n"jackie", false);
  this.ShowInputHints(false);
  this.ShowBossHealthbar(false);
  this.ShowDialogPreview(false);
  this.ShowSubtitlesPreview(false);
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
    let userData: ref<PhoneMessageNotificationViewData> = new PhoneMessageNotificationViewData();
    let notificationData: gameuiGenericNotificationData;
    userData.entryHash = -1;
    userData.threadHash = -1;
    userData.contactHash = -1;
    userData.title = "Preview notifications";
    userData.SMSText = "Will disappear after 20 seconds";
    userData.action = new GenericNotificationBaseAction();
    userData.animation = n"notification_phone_MSG";
    userData.soundEvent = n"PhoneSmsPopup";
    userData.soundAction = n"OnOpen";
    notificationData.time = 20.0;
    notificationData.widgetLibraryItemName = controller.m_messageNotification;
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
    notificationData.time = 20.0;
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
    controller.m_textParams = new inkTextParams();
    controller.m_textParams.AddMeasurement("distance", Cast<Float>(controller.m_distance), EMeasurementUnit.Meter);
    controller.m_textParams.AddString("unit", GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(UILocalizationHelper.GetSystemBaseUnit()))));
    inkTextRef.SetText(controller.m_distanceLabel, "123M", controller.m_textParams);
    controller.PlayAnim(n"intro", n"OnIntroFinished");
    controller.m_optionCounter.loopType = inkanimLoopType.Cycle;
    controller.m_optionCounter.loopCounter = 35u;
    controller.m_animationCounterProxy = controller.PlayLibraryAnimation(n"counter", controller.m_optionCounter);
    GameInstance.GetAudioSystem(controller.m_gameInstance).Play(n"ui_jingle_car_call");
    inkTextRef.SetLocalizedTextScript(controller.m_vehicleNameLabel, "Your vehicle name");
  };
}

@addMethod(inkGameController)
private func ShowAmmoCounter(show: Bool) -> Void {
  if this.IsA(n"weaponRosterGameController") {
    let controller: ref<weaponRosterGameController> = this as weaponRosterGameController;
    if show {
      this.originalVisibility = controller.m_folded;
      if this.originalVisibility {
        controller.PlayUnfold();
      };
    } else {
      if this.originalVisibility {
        controller.PlayFold();
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

@addMethod(inkGameController)
private func ShowDpad(show: Bool) -> Void {
  if this.IsA(n"HotkeysWidgetController") {
    if show {
      this.originalOpacity = this.GetRootWidget().GetOpacity();
      this.GetRootWidget().SetOpacity(1.0);
    } else {
      this.GetRootWidget().SetOpacity(this.originalOpacity);
    };
  };
}

@addMethod(inkGameController)
private func ShowHealthbar(show: Bool) -> Void {
  if this.IsA(n"healthbarWidgetGameController") {
    let controller = this as healthbarWidgetGameController;
    if show {
      controller.ShowRequest();
    } else {
      controller.ComputeHealthBarVisibility();
    };
  };
}

@addMethod(inkGameController)
private func ShowStaminaBar(show: Bool) -> Void {
  if this.IsA(n"StaminabarWidgetGameController") {
    let controller = this as StaminabarWidgetGameController;
    controller.m_currentStamina = 87.7;
    controller.m_staminaPoolListener.OnStatPoolValueChanged(70.0, 87.7, 11.0);

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
private func ShowIncomingPhoneCall(name: CName, show: Bool) -> Void {
  if this.IsA(n"HudPhoneGameController") {
    let controller = this as HudPhoneGameController;
    let phoneCallInfo: PhoneCallInformation;
    phoneCallInfo.callMode = questPhoneCallMode.Video;
    phoneCallInfo.isAudioCall = false;
    phoneCallInfo.contactName = name;
    phoneCallInfo.isPlayerCalling = true;
    phoneCallInfo.isPlayerTriggered = true;
    if show {
      phoneCallInfo.callPhase = questPhoneCallPhase.IncomingCall;
    } else {
      phoneCallInfo.callPhase = questPhoneCallPhase.EndCall;
    };
    controller.m_CurrentCallInformation = phoneCallInfo;
    controller.m_CurrentPhoneCallContact = controller.GetIncomingContact();
    controller.m_RootWidget.SetVisible(show);
    if show {
      controller.SetPhoneFunction(EHudPhoneFunction.IncomingCall);
    } else {
      controller.SetPhoneFunction(EHudPhoneFunction.Inactive);  
    };
  };
}


@addMethod(inkGameController)
private func ShowIncomingCallController(name: CName, show: Bool) -> Void {
  if this.IsA(n"IncomingCallGameController") {
    let controller = this as IncomingCallGameController;
    let phoneCallInfo: PhoneCallInformation;
    phoneCallInfo.callMode = questPhoneCallMode.Video;
    phoneCallInfo.isAudioCall = false;
    phoneCallInfo.contactName = name;
    phoneCallInfo.isPlayerCalling = true;
    phoneCallInfo.isPlayerTriggered = true;
    phoneCallInfo.callPhase = questPhoneCallPhase.IncomingCall;

    let options: inkAnimOptions;
    options.playReversed = false;
    options.executionDelay = 0.0;
    options.loopType = inkanimLoopType.Cycle;
    options.loopCounter = 100u;
    options.loopInfinite = true;
    inkTextRef.SetLetterCase(controller.m_contactNameWidget, textLetterCase.UpperCase);
    inkTextRef.SetText(controller.m_contactNameWidget, "Unknown");
    inkWidgetRef.SetVisible(controller.m_buttonHint, phoneCallInfo.isRejectable);
    controller.GetRootWidget().SetVisible(show);
    if IsDefined(controller.m_animProxy) {
      controller.m_animProxy.Stop();
      controller.m_animProxy = null;
    };
    if show {
      controller.m_animProxy = this.PlayLibraryAnimation(n"ring", options);
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

@addMethod(hudCarController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidgetEvent>) -> Bool {
  let config: ref<HUDitorConfig> = new HUDitorConfig();
  let widgetName: CName = n"NewCarHud";
  let hudEditorWidgetName: CName = event.activeWidget;
  let isEnabled: Bool = Equals(widgetName, hudEditorWidgetName) && config.speedometerEnabled;
  this.ShowCarHUD(isEnabled);
}

@addMethod(hudCarController)
private func ShowCarHUD(show: Bool) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let uiSystem: ref<UISystem> = GameInstance.GetUISystem(player.GetGame());
  if show {
    uiSystem.PushGameContext(UIGameContext.VehicleMounted);
    this.GetRootWidget().SetVisible(true);
    this.RegisterToVehicle(true);
    this.OnSpeedValueChanged(145.0);
    this.OnRpmValueChanged(2500.0);
    inkTextRef.SetText(this.m_SpeedValue, ToString(145));
  } else {
    this.GetRootWidget().SetVisible(false);
    uiSystem.ResetGameContext();
  };
}

@addMethod(inkGameController)
private func ShowBossHealthbar(show: Bool) -> Void {
  if this.IsA(n"BossHealthBarGameController") {
    let controller = this as BossHealthBarGameController;
    controller.m_root.SetVisible(show);

    if show {
      inkTextRef.SetText(controller.m_bossName, "Some boss name here");
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
