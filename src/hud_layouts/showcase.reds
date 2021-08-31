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
  // this.ShowWantedBar();
  // this.ShowVehicleSummonNotification();
  // this.ShowActivityLog();
  // this.ShowWarningMessage("Warning message here");
  // this.ShowBossHealthbar();
  // this.ShowHUDProgressBar();
  // this.ShowOxygenBar();
  // this.ShowZoneAlertNotification();
  // this.ShowStaminaBar();
  // this.ShowIncomingPhoneCall(n"unknown");
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
    controller.UpdateHealthValue(75);
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
    controller.m_currentStamina = 77.7;
    controller.m_staminaPoolListener.OnStatPoolValueChanged(70.0, 77.7, 1.0);
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
    controller.OnNewLocationDiscovered(true);
  };
}

@addMethod(inkGameController)
private func ShowItemsNotification() -> Void {
  if this.IsA(n"ItemsNotificationQueue") {
    let controller = this as ItemsNotificationQueue;
    controller.PushXPNotification(100, 500, 400, n"XP", "LocKey#40364", gamedataProficiencyType.Level, 35, false);
    controller.PushCurrencyNotification(100, 1000u);
    controller.PushItemNotification(ItemID.FromTDBID(t"Items.Pants_03_rich_03"), n"epic");
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
