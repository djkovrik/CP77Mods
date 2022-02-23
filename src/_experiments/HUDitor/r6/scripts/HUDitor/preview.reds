// Widgets previewing stuff

@addMethod(inkGameController)
protected cb func OnDisplayPreviewEvent(event: ref<DisplayPreviewEvent>) -> Bool {
  this.ShowHealthbar(true);
  this.ShowIncomingPhoneCall(n"jackie", true);
  this.ShowIncomingCallController(n"jackie", true);
  this.ShowWantedBar(true);
  this.ShowItemsNotification();
  this.ShowJournalNotification(10);
  this.ShowJournalNotification(20);
  this.ShowJournalNotification(30);
  this.ShowJournalNotification(40);
  this.ShowStaminaBar(true);
  this.ShowVehicleSummonNotification(true);
}

@addMethod(inkGameController)
protected cb func OnHidePreviewEvent(event: ref<HidePreviewEvent>) -> Bool {
  this.ShowHealthbar(false);
  this.ShowIncomingPhoneCall(n"jackie", false);
  this.ShowIncomingCallController(n"jackie", false);
  this.ShowWantedBar(false);
  this.ShowStaminaBar(false);
  this.ShowVehicleSummonNotification(false);
}


// Preview helpers

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
private func ShowItemsNotification() -> Void {
  if this.IsA(n"ItemsNotificationQueue") {
    let controller = this as ItemsNotificationQueue;
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_01"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_02"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_01"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_02"), n"epic");
  };
}

@addMethod(inkGameController)
private func ShowJournalNotification(exp: Int32) -> Void {
  if this.IsA(n"JournalNotificationQueue") {
    let controller = this as JournalNotificationQueue;
    let evt = new NCPDJobDoneEvent();
    evt.levelXPAwarded = exp;
    evt.streetCredXPAwarded = exp;
    controller.OnNCPDJobDoneEvent(evt);
    controller.OnNewLocationDiscovered(true);
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
    let contact: wref<JournalContact> = controller.GetIncomingContact(phoneCallInfo);
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