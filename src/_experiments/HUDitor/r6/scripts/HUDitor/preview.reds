// Widgets previewing stuff

@addMethod(inkGameController)
protected cb func OnDisplayPreviewEvent(event: ref<DisplayPreviewEvent>) -> Bool {
  this.ShowHealthbar(true);
  this.ShowIncomingPhoneCall(n"unknown", true);
  this.ShowWantedBar(true);
  this.ShowItemsNotification();
  this.ShowStaminaBar();
  this.ShowVehicleSummonNotification(true);
}

@addMethod(inkGameController)
protected cb func OnHidePreviewEvent(event: ref<HidePreviewEvent>) -> Bool {
  this.ShowHealthbar(false);
  this.ShowIncomingPhoneCall(n"unknown", false);
  this.ShowWantedBar(false);
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
    let phoneSystem: ref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"PhoneSystem") as PhoneSystem;
    if show {
      phoneSystem.TriggerCall(questPhoneCallMode.Video, false, name, false, questPhoneCallPhase.IncomingCall, true);
    } else {
      phoneSystem.TriggerCall(questPhoneCallMode.Video, false, name, false, questPhoneCallPhase.EndCall, true);    
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
    controller.m_showDuration = 10.0;
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_01"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_02"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_01"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_02"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_03"), n"epic");
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.TShirt_02_rich_04"), n"epic");
  };
}

@addMethod(inkGameController)
private func ShowStaminaBar() -> Void {
  if this.IsA(n"StaminabarWidgetGameController") {
    let controller = this as StaminabarWidgetGameController;
    controller.m_currentStamina = 87.7;
    controller.m_staminaPoolListener.OnStatPoolValueChanged(70.0, 87.7, 11.0);
    controller.m_RootWidget.SetOpacity(1.00);
    controller.m_RootWidget.SetVisible(true);
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
