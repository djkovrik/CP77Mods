import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudConfig.LHUDAddonsConfig

@addField(JournalNotificationQueue)
private let lhudAddonsConfig: ref<LHUDAddonsConfig>;

@wrapMethod(JournalNotificationQueue)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudAddonsConfig = new LHUDAddonsConfig();
}

@addMethod(JournalNotificationQueue)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudAddonsConfig = new LHUDAddonsConfig();
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
      if this.lhudAddonsConfig.MuteQuestNotifications {
        userData.soundEvent = n"";
      } else {
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
      if this.lhudAddonsConfig.MuteQuestNotifications {
        userData.soundEvent = n"";
      } else {
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
      if this.lhudAddonsConfig.MuteQuestNotifications {
        userData.soundEvent = n"";
      } else {
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
protected cb func OnCustomQuestNotificationUpdate(value: Variant) -> Bool {
  let notificationData: gameuiGenericNotificationData;
  let data: CustomQuestNotificationData = FromVariant<CustomQuestNotificationData>(value);
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.text = GetLocalizedText(data.desc);
  userData.title = GetLocalizedText(data.header);
  if this.lhudAddonsConfig.MuteQuestNotifications {
    userData.soundEvent = n"";
  } else {
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
  if this.lhudAddonsConfig.MuteQuestNotifications {
    userData.soundEvent = n"";
  } else {
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
    if this.lhudAddonsConfig.MuteQuestNotifications {
      userData.soundEvent = n"";
    } else {
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
protected cb func OnNCPDJobDoneEvent(evt: ref<NCPDJobDoneEvent>) -> Bool {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
  userData.title = "UI-Notifications-QuestCompleted";
  if this.lhudAddonsConfig.MuteQuestNotifications {
    userData.soundEvent = n"";
  } else {
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

@replaceMethod(LevelUpNotificationQueue)
private final func OnCharacterLevelUpdated(value: Variant) -> Void {
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let action: ref<OpenPerksNotificationAction>;
  let notificationData: gameuiGenericNotificationData;
  let skillAction: ref<OpenSkillsNotificationAction>;
  let levelUpData: LevelUpData = FromVariant<LevelUpData>(value);
  let profString: String = EnumValueToString("gamedataProficiencyType", Cast<Int64>(EnumInt(levelUpData.type)));
  let proficiencyRecord: ref<Proficiency_Record> = TweakDBInterface.GetProficiencyRecord(TDBID.Create("Proficiencies." + profString));
  let userData: ref<LevelUpNotificationViewData> = new LevelUpNotificationViewData();
  userData.canBeMerged = false;
  userData.levelupdata = levelUpData;
  userData.profString = proficiencyRecord.Loc_name_key();
  userData.proficiencyRecord = proficiencyRecord;
  notificationData.time = this.m_duration;
  if Equals(levelUpData.type, gamedataProficiencyType.Espionage) {
    notificationData.widgetLibraryItemName = n"RelicUp";
    if config.MuteLevelUpNotifications {
      userData.soundEvent = n"";
    } else {
      userData.soundEvent = n"RelicPopup";
    };
    userData.soundAction = n"OnLevelUp";
    userData.levelupdata.lvl = levelUpData.lvl - this.m_lastEspionageLevel;
    this.m_lastEspionageLevel = levelUpData.lvl;
    if !levelUpData.disableAction {
      action = new OpenPerksNotificationAction();
      action.m_eventDispatcher = this;
      userData.action = action;
    };
  } else {
    if Equals(levelUpData.type, gamedataProficiencyType.Level) {
      notificationData.widgetLibraryItemName = n"LevelUp_";
      if config.MuteLevelUpNotifications {
        userData.soundEvent = n"";
      } else {
        userData.soundEvent = n"PlayerLevelUpPopup";
      };
      userData.soundAction = n"OnOpen";
      if !levelUpData.disableAction {
        action = new OpenPerksNotificationAction();
        action.m_eventDispatcher = this;
        userData.action = action;
      };
    } else {
      if Equals(levelUpData.type, gamedataProficiencyType.StreetCred) {
        notificationData.widgetLibraryItemName = n"StreetCredUp_";
        if config.MuteLevelUpNotifications {
          userData.soundEvent = n"";
        } else {
          userData.soundEvent = n"PlayerLevelUpPopup";
        };
        userData.soundAction = n"OnOpen";
        if !levelUpData.disableAction {
          action = null;
          action.m_eventDispatcher = this;
          userData.action = action;
        };
      } else {
        notificationData.widgetLibraryItemName = n"SkillUp_";
        if config.MuteLevelUpNotifications {
          userData.soundEvent = n"";
        } else {
          userData.soundEvent = n"SkillLevelUpPopup";
        };
        userData.soundAction = n"OnOpen";
        if !levelUpData.disableAction {
          skillAction = new OpenSkillsNotificationAction();
          skillAction.m_eventDispatcher = this;
          userData.action = skillAction;
        };
      };
    };
  };
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}

@replaceMethod(GenericNotificationController)
public cb func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  this.m_data = notificationData;

  if config.MuteQuestNotifications {
    if Equals(this.m_data.soundEvent, n"QuestUpdatePopup") || Equals(this.m_data.soundEvent, n"QuestNewPopup") {
      this.m_data.soundEvent = n"None";
    };
  };

  if this.m_data.action != null {
    inkWidgetRef.SetVisible(this.m_actionRef, true);
    inkTextRef.SetText(this.m_actionLabelRef, this.m_data.action.GetLabel());
    this.m_isInteractive = true;
    this.GetPlayerControlledObject().RegisterInputListener(this, this.GetInputActionName());
  } else {
    inkWidgetRef.SetVisible(this.m_actionRef, false);
    this.m_isInteractive = false;
  };
  if inkWidgetRef.IsValid(this.m_titleRef) {
    inkTextRef.SetText(this.m_titleRef, this.m_data.title);
  };
  if inkWidgetRef.IsValid(this.m_textRef) {
    this.translationAnimationCtrl = inkWidgetRef.GetController(this.m_textRef) as inkTextReplaceController;
    if IsDefined(this.translationAnimationCtrl) {
      this.translationAnimationCtrl.SetTargetText(this.m_data.text);
      this.translationAnimationCtrl.PlaySetAnimation();
    } else {
      inkTextRef.SetText(this.m_textRef, this.m_data.text);
    };
  };
  if NotEquals(this.m_data.soundEvent, n"None") && NotEquals(this.m_data.soundAction, n"None") {
    this.PlaySound(this.m_data.soundEvent, this.m_data.soundAction);
  };
}
