public class DisplayPresetEvent extends Event {}

public class CHLGlobalInputListener {

  private let m_player: ref<PlayerPuppet>;

  public func SetPlayerInstance(player: ref<PlayerPuppet>) -> Void {
    this.m_player = player;
  }
  
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"UI_Unequip") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)  {
      GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(new DisplayPresetEvent());
    };
  }
}

@addField(PlayerPuppet)
private let m_inputListener_CHL: ref<CHLGlobalInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.m_inputListener_CHL = new CHLGlobalInputListener();
    this.m_inputListener_CHL.SetPlayerInstance(this);
    this.RegisterInputListener(this.m_inputListener_CHL);
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    wrappedMethod();
    this.UnregisterInputListener(this.m_inputListener_CHL);
    this.m_inputListener_CHL = null;
}

// -- Show stubs

@addMethod(inkGameController)
protected cb func OnDisplayPresetEvent(evt: ref<DisplayPresetEvent>) -> Bool {

  /* Showcase 1 */
  // this.ShowWantedBar();
  // this.ShowVehicleSummonNotification();
  // this.ShowActivityLog();
  // this.ShowWarningMessage("Warning message here");
  // this.ShowBossHealthbar();
  // this.ShowHUDProgressBar();
  // this.ShowOxygenBar();
  // this.ShowCarHUD();
  // this.ShowStaminaBar();
  // this.ShowItemsNotification();

  /* Showcase 2 */
  this.ShowLevelUpNotification();
  this.ShowIncomingPhoneCall(n"panam");
  this.ShowJournalNotification();

  /* All */
  // this.ShowWantedBar();
  // this.ShowVehicleSummonNotification();
  // this.ShowActivityLog();
  // this.ShowWarningMessage("Warning message here");
  // this.ShowBossHealthbar();
  // this.ShowHUDProgressBar();
  // this.ShowOxygenBar();
  // this.ShowCarHUD();
  // this.ShowZoneAlertNotification();
  // this.ShowStaminaBar();
  // this.ShowIncomingPhoneCall(n"panam");
  // this.ShowJournalNotification();
  // this.ShowItemsNotification();
  // this.ShowLevelUpNotification();
  // this.ShowMilitechWarning();
}

@addMethod(inkGameController)
private func ShowWantedBar() -> Void {
  if this.IsA(n"WantedBarGameController") {
    let controller = this as WantedBarGameController;
    controller.OnWantedDataChange(5);
  };
}

@addMethod(inkGameController)
private func ShowVehicleSummonNotification() -> Void {
  if this.IsA(n"VehicleSummonWidgetGameController") {
    let controller = this as VehicleSummonWidgetGameController;
    controller.OnVehicleSummonStateChanged(1u);
  };
}

@addMethod(inkGameController)
private func ShowActivityLog() -> Void {
  if this.IsA(n"activityLogGameController") {
    let controller = this as activityLogGameController;
    controller.AddNewEntry("Activity Log entry 1");
    controller.AddNewEntry("Activity Log entry 2");
    controller.AddNewEntry("Activity Log entry 3");
    controller.AddNewEntry("Activity Log entry 4");
  };
}

@addMethod(inkGameController)
private func ShowWarningMessage(message: String) -> Void {
  if this.IsA(n"WarningMessageGameController") {
    let controller = this as WarningMessageGameController;
    controller.m_simpleMessage = new SimpleScreenMessage(true, 15.0, message, false);
    controller.SetTimeout(15.0);
    controller.UpdateWidgets();
  };
}

@addMethod(inkGameController)
private func ShowBossHealthbar() -> Void {
  if this.IsA(n"BossHealthBarGameController") {
    let controller = this as BossHealthBarGameController;
    controller.m_root.SetVisible(true);
    inkTextRef.SetText(controller.m_bossName, "Boss name");
    controller.UpdateHealthValue(13);
    if IsDefined(controller.m_foldAnimation) {
      controller.m_foldAnimation.Stop();
    };
    controller.m_foldAnimation = this.PlayLibraryAnimation(n"unfold");
  };
}

@addMethod(inkGameController)
private func ShowHUDProgressBar() -> Void {
  if this.IsA(n"HUDProgressBarController") {
    let controller = this as HUDProgressBarController;
    controller.OnActivated(true);
    controller.OnProgressChanged(0.35);
    controller.OnHeaderChanged("Progress header");
  };
}

@addMethod(inkGameController)
private func ShowOxygenBar() -> Void {
  if this.IsA(n"OxygenbarWidgetGameController") {
    let controller = this as OxygenbarWidgetGameController;
    controller.m_RootWidget.SetVisible(true);
    controller.UpdateOxygenValue(75.0, 70.0, 1.0);
  };
}

@addMethod(inkGameController)
private func ShowCarHUD() -> Void {
  if this.IsA(n"hudCarController") {
    let controller = this as hudCarController;
    controller.GetRootWidget().SetVisible(true);
    controller.RegisterToVehicle(true);
    controller.OnSpeedValueChanged(45.0);
    controller.OnRpmValueChanged(2500.0);
    inkTextRef.SetText(controller.m_SpeedValue, ToString(45));
  };
}

@addMethod(inkGameController)
private func ShowZoneAlertNotification() -> Void {
  if this.IsA(n"ZoneAlertNotificationQueue") {
    let controller = this as ZoneAlertNotificationQueue;
    controller.OnFact(2);
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
private func ShowIncomingPhoneCall(name: CName) -> Void {
  if this.IsA(n"HudPhoneGameController") {
    let phoneSystem: ref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame()).Get(n"PhoneSystem") as PhoneSystem;
    phoneSystem.TriggerCall(questPhoneCallMode.Video, false, name, false, questPhoneCallPhase.IncomingCall, true);
  };
}

@addMethod(inkGameController)
private func ShowJournalNotification() -> Void {
  if this.IsA(n"JournalNotificationQueue") {
    let controller = this as JournalNotificationQueue;
    controller.m_showDuration = 10.0;
    let evt = new NCPDJobDoneEvent();
    evt.levelXPAwarded = 100;
    evt.streetCredXPAwarded = 100;
    controller.OnNCPDJobDoneEvent(evt);
  };
}

@addMethod(inkGameController)
private func ShowItemsNotification() -> Void {
  if this.IsA(n"ItemsNotificationQueue") {
    let controller = this as ItemsNotificationQueue;
    controller.m_showDuration = 10.0;
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_03"), n"epic");
    controller.PushXPNotification(100, 500, 400, n"XP", "LocKey#40364", gamedataProficiencyType.Level, 35, false);
    controller.PushCurrencyNotification(100, 1000u);
  };
}

@addMethod(inkGameController)
private func ShowLevelUpNotification() -> Void {
  if this.IsA(n"LevelUpNotificationQueue") {
    let controller = this as LevelUpNotificationQueue;
    let action: ref<OpenPerksNotificationAction>;
    let mapAction: ref<OpenWorldMapNotificationAction>;
    let notificationData: gameuiGenericNotificationData;
    let levelUpData: LevelUpData = new LevelUpData(50, gamedataProficiencyType.Level, 2, 2, false);
    let profString: String = EnumValueToString("gamedataProficiencyType", Cast(EnumInt(levelUpData.type)));
    let proficiencyRecord: ref<Proficiency_Record> = TweakDBInterface.GetProficiencyRecord(TDBID.Create("Proficiencies." + profString));
    let unlockedActivites: Int32 = TweakDBInterface.GetInt(TDBID.Create("Constants.StreetCredActivityUnlocks.level" + levelUpData.lvl), 0);
    let userData: ref<LevelUpNotificationViewData> = new LevelUpNotificationViewData();
    userData.canBeMerged = false;
    userData.levelupdata = levelUpData;
    userData.profString = proficiencyRecord.Loc_name_key();
    userData.proficiencyRecord = proficiencyRecord;
    notificationData.time = 10.0;
    if Equals(levelUpData.type, gamedataProficiencyType.Level) {
      notificationData.widgetLibraryItemName = n"LevelUp_";
      userData.soundEvent = n"PlayerLevelUpPopup";
      userData.soundAction = n"OnOpen";
      if !levelUpData.disableAction {
        action = new OpenPerksNotificationAction();
        action.m_eventDispatcher = controller;
        userData.action = action;
      };
    } else {
      if Equals(levelUpData.type, gamedataProficiencyType.StreetCred) {
        notificationData.widgetLibraryItemName = n"StreetCredUp_";
        userData.soundEvent = n"PlayerLevelUpPopup";
        userData.soundAction = n"OnOpen";
        if !levelUpData.disableAction {
          if unlockedActivites > 0 {
            mapAction = new OpenWorldMapNotificationAction();
            mapAction.m_eventDispatcher = controller;
            userData.action = mapAction;
          } else {
            action = null;
            action.m_eventDispatcher = controller;
            userData.action = action;
          };
        };
      } else {
        notificationData.widgetLibraryItemName = n"SkillUp_";
        userData.soundEvent = n"SkillLevelUpPopup";
        userData.soundAction = n"OnOpen";
        if !levelUpData.disableAction {
          action = new OpenPerksNotificationAction();
          action.m_eventDispatcher = this;
          userData.action = action;
        };
      };
    };
    notificationData.notificationData = userData;
    controller.AddNewNotificationData(notificationData);
  };
}

@addMethod(inkGameController)
private func ShowMilitechWarning() -> Void {
  if this.IsA(n"hudMilitechWarningGameController") {
    let controller = this as hudMilitechWarningGameController;
    controller.OnFact(1);
  };
}

@replaceMethod(activityLogEntryLogicController)
protected cb func OnInitialize() -> Bool {
  let size: Vector2;
  this.m_available = true;
  this.m_root = this.GetRootWidget() as inkText;
  this.m_root.SetLetterCase(textLetterCase.UpperCase);
  size = this.m_root.GetSize();
  this.m_appearingAnim = new inkAnimController();
  this.m_appearingAnim.Select(this.m_root).Interpolate(n"size", ToVariant(new Vector2(0.00, 0.00)), ToVariant(size)).Duration(1.0).Type(inkanimInterpolationType.Linear).Mode(inkanimInterpolationMode.EasyIn);
  this.m_typingAnim = new inkAnimController();
  this.m_typingAnim.Select(this.m_root).Interpolate(n"transparency", ToVariant(1.00), ToVariant(1.00)).Duration(0.00).Type(inkanimInterpolationType.Linear).Mode(inkanimInterpolationMode.EasyIn);
  this.m_disappearingAnim = new inkAnimController();
  this.m_disappearingAnim.Select(this.m_root).Interpolate(n"transparency", ToVariant(1.00), ToVariant(0.00)).Delay(10.00).Duration(1.0).Type(inkanimInterpolationType.Linear).Mode(inkanimInterpolationMode.EasyOut);
}
