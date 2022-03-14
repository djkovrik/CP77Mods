import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(JournalNotification)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let scale: Float = LHUDAddonsConfig.JournalNotificationScale();
  let opacity: Float = LHUDAddonsConfig.JournalNotificationOpacity();
  this.GetRootWidget().SetScale(new Vector2(scale, scale)); // Scale
  this.GetRootWidget().SetOpacity(opacity);                 // Opacity
}

// SOUNDS

@replaceMethod(JournalNotificationQueue)
protected cb func OnTrackedMappinUpdated(value: Variant) -> Bool {
  let mappinText: String;
  let notificationData: gameuiGenericNotificationData;
  let objectiveText: String;
  let userData: ref<QuestUpdateNotificationViewData>;
  let mappin: wref<IMappin> = FromVariant<ref<IScriptable>>(value) as IMappin;
  if IsDefined(mappin) {
    mappinText = NameToString(MappinUIUtils.MappinToString(mappin.GetVariant()));
    objectiveText = NameToString(MappinUIUtils.MappinToObjectiveString(mappin.GetVariant()));
    userData = new QuestUpdateNotificationViewData();
    userData.title = mappinText;
    userData.text = objectiveText;
    if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
      userData.soundEvent = n"QuestNewPopup";
    };
    userData.soundAction = n"OnOpen";
    userData.animation = n"notification_new_activity";
    userData.canBeMerged = false;
    userData.priority = EGenericNotificationPriority.Height;
    notificationData.widgetLibraryItemName = n"notification_new_activity";
    notificationData.notificationData = userData;
    notificationData.time = this.m_showDuration;
    this.AddNewNotificationData(notificationData);
  };
}

@replaceMethod(JournalNotificationQueue)
protected cb func OnCustomQuestNotificationUpdate(value: Variant) -> Bool {
  let notificationData: gameuiGenericNotificationData;
  let data: CustomQuestNotificationData = FromVariant<CustomQuestNotificationData>(value);
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.text = GetLocalizedText(data.desc);
  userData.title = GetLocalizedText(data.header);
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"QuestUpdatePopup";
  };
  userData.soundAction = n"OnOpen";
  userData.animation = n"notification_quest_completed";
  userData.canBeMerged = true;
  notificationData.time = this.m_showDuration;
  notificationData.widgetLibraryItemName = this.m_questNotification;
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}

@replaceMethod(JournalNotificationQueue)
protected cb func OnNCPDJobDoneEvent(evt: ref<NCPDJobDoneEvent>) -> Bool {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.title = "UI-Notifications-QuestCompleted";
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"OwCompletePopup";
  };
  userData.soundAction = n"OnOpen";
  userData.animation = n"notification_ma_completed";
  userData.canBeMerged = false;
  userData.rewardXP = evt.levelXPAwarded;
  userData.rewardSC = evt.streetCredXPAwarded;
  notificationData.widgetLibraryItemName = n"notification_ma_completed";
  notificationData.notificationData = userData;
  notificationData.time = this.m_showDuration;
  this.AddNewNotificationData(notificationData);
}


@replaceMethod(JournalNotificationQueue)
protected cb func OnNewLocationDiscovered(newLocation: Bool) -> Bool {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<QuestUpdateNotificationViewData>;
  if newLocation {
    userData = new QuestUpdateNotificationViewData();
    userData.title = this.m_newAreablackboard.GetString(this.m_newAreaDef.currentLocation);
    userData.text = this.m_newAreablackboard.GetString(this.m_newAreaDef.currentLocationEnumName);
    userData.animation = n"notification_LocationAdded";
    if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
      userData.soundEvent = n"ui_phone_sms";
    };
    userData.soundAction = n"OnOpen";
    notificationData.time = this.m_showDuration;
    notificationData.widgetLibraryItemName = n"notification_LocationAdded";
    notificationData.notificationData = userData;
    this.AddNewNotificationData(notificationData);
  };
}

@replaceMethod(JournalNotificationQueue)
private final func PushQuestNotification(questEntry: wref<JournalQuest>, state: gameJournalEntryState) -> Void {
  let notificationData: gameuiGenericNotificationData;
  let questAction: ref<TrackQuestNotificationAction>;
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.entryHash = this.m_journalMgr.GetEntryHash(questEntry);
  userData.questEntryId = questEntry.GetId();
  userData.text = questEntry.GetTitle(this.m_journalMgr);
  userData.canBeMerged = false;
  switch state {
    case gameJournalEntryState.Active:
      userData.title = "UI-Notifications-NewQuest";
      questAction = new TrackQuestNotificationAction();
      questAction.m_questEntry = questEntry;
      questAction.m_journalMgr = this.m_journalMgr;
      userData.action = questAction;
      if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
        userData.soundEvent = n"QuestNewPopup";
      };
      userData.soundAction = n"OnOpen";
      userData.animation = n"notification_new_quest_added";
      notificationData.time = this.m_showDuration;
      notificationData.widgetLibraryItemName = n"notification_new_quest_added";
      notificationData.notificationData = userData;
      this.AddNewNotificationData(notificationData);
      break;
    case gameJournalEntryState.Succeeded:
      userData.title = "UI-Notifications-QuestCompleted";
      if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
        userData.soundEvent = n"QuestSuccessPopup";
      };
      userData.soundAction = n"OnOpen";
      userData.animation = n"notification_quest_completed";
      userData.dontRemoveOnRequest = true;
      notificationData.time = 12.00;
      notificationData.widgetLibraryItemName = n"notification_quest_completed";
      notificationData.notificationData = userData;
      this.AddNewNotificationData(notificationData);
      break;
    case gameJournalEntryState.Failed:
      userData.title = "LocKey#27566";
      if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
        userData.soundEvent = n"QuestFailedPopup";
      };
      userData.soundAction = n"OnOpen";
      userData.animation = n"notification_quest_failed";
      userData.dontRemoveOnRequest = true;
      notificationData.time = this.m_showDuration;
      notificationData.widgetLibraryItemName = n"notification_quest_failed";
      notificationData.notificationData = userData;
      this.AddNewNotificationData(notificationData);
      break;
    default:
      return;
  };
}


@replaceMethod(JournalNotificationQueue)
private final func PushObjectiveQuestNotification(entry: wref<JournalEntry>) -> Void {
  let notificationData: gameuiGenericNotificationData;
  let parentQuestEntry: wref<JournalQuest>;
  let questAction: ref<TrackQuestNotificationAction>;
  let userData: ref<QuestUpdateNotificationViewData>;
  let currentEntry: wref<JournalEntry> = entry;
  while parentQuestEntry == null {
    currentEntry = this.m_journalMgr.GetParentEntry(currentEntry);
    if !IsDefined(currentEntry) {
      return;
    };
    parentQuestEntry = currentEntry as JournalQuest;
  };
  userData = new QuestUpdateNotificationViewData();
  userData.questEntryId = parentQuestEntry.GetId();
  userData.entryHash = this.m_journalMgr.GetEntryHash(parentQuestEntry);
  userData.text = parentQuestEntry.GetTitle(this.m_journalMgr);
  userData.title = "UI-Notifications-QuestUpdated";
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"QuestUpdatePopup";
  };
  userData.soundAction = n"OnOpen";
  userData.animation = n"notification_quest_updated";
  userData.canBeMerged = true;
  questAction = new TrackQuestNotificationAction();
  questAction.m_questEntry = parentQuestEntry;
  questAction.m_journalMgr = this.m_journalMgr;
  userData.action = questAction;
  notificationData.time = this.m_showDuration;
  notificationData.widgetLibraryItemName = n"notification_quest_updated";
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}

@replaceMethod(JournalNotificationQueue)
private final func PushNotification(title: String, text: String, widget: CName, animation: CName, opt action: ref<GenericNotificationBaseAction>) -> Void {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.title = title;
  userData.text = text;
  userData.action = action;
  userData.animation = animation;
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"QuestUpdatePopup";
  };
  userData.soundAction = n"OnOpen";
  notificationData.time = this.m_showDuration;
  notificationData.widgetLibraryItemName = widget;
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}

@replaceMethod(JournalNotificationQueue)
private final func PushNewContactNotification(title: String, text: String, widget: CName, animation: CName, opt action: ref<GenericNotificationBaseAction>) -> Void {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.title = title;
  userData.text = text;
  userData.action = action;
  userData.animation = animation;
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"QuestUpdatePopup";
  };
  userData.soundAction = n"OnOpen";
  notificationData.time = this.m_showDuration;
  notificationData.widgetLibraryItemName = widget;
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}

@replaceMethod(JournalNotificationQueue)
private final func PushSMSNotification(msgEntry: wref<JournalPhoneMessage>, opt action: ref<GenericNotificationBaseAction>) -> Void {
  let notificationData: gameuiGenericNotificationData;
  let msgConversation: wref<JournalPhoneConversation> = this.m_journalMgr.GetParentEntry(msgEntry) as JournalPhoneConversation;
  let msgContact: wref<JournalContact> = this.m_journalMgr.GetParentEntry(msgConversation) as JournalContact;
  let userData: ref<PhoneMessageNotificationViewData> = new PhoneMessageNotificationViewData();
  userData.entryHash = this.m_journalMgr.GetEntryHash(msgEntry);
  userData.threadHash = this.m_journalMgr.GetEntryHash(msgConversation);
  userData.contactHash = this.m_journalMgr.GetEntryHash(msgContact);
  userData.title = msgContact.GetLocalizedName(this.m_journalMgr);
  userData.SMSText = GetLocalizedText(msgEntry.GetText());
  userData.action = action;
  userData.animation = n"notification_phone_MSG";
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"PhoneSmsPopup";
  };
  userData.soundAction = n"OnOpen";
  notificationData.time = 6.70;
  notificationData.widgetLibraryItemName = this.m_messageNotification;
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}

@replaceMethod(JournalNotificationQueue)
private final func GetShardNotificationData(entry: ref<JournalOnscreen>) -> ref<ShardCollectedNotificationViewData> {
  let userData: ref<ShardCollectedNotificationViewData> = new ShardCollectedNotificationViewData();
  userData.title = GetLocalizedText("UI-Notifications-ShardCollected") + " " + GetLocalizedText(entry.GetTitle());
  userData.text = entry.GetDescription();
  userData.shardTitle = GetLocalizedText(entry.GetTitle());
  userData.entry = entry;
  let shardOpenAction: ref<OpenShardNotificationAction> = new OpenShardNotificationAction();
  shardOpenAction.m_eventDispatcher = this.m_uiSystem;
  userData.action = shardOpenAction;
  if !LHUDAddonsConfig.JournalNotificationDisableSounds() {
    userData.soundEvent = n"ShardCollectedPopup";
  };
  userData.soundAction = n"OnLoot";
  return userData;
}