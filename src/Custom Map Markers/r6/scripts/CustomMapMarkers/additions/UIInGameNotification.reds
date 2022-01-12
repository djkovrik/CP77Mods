// Customize warning notificaiton text

@addField(UIInGameNotificationEvent)
public let m_isCustom: Bool;

@addField(UIInGameNotificationEvent)
public let m_text: String;

@replaceMethod(UIInGameNotificationQueue)
protected cb func OnUINotification(evt: ref<UIInGameNotificationEvent>) -> Bool {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<UIInGameNotificationViewData> = new UIInGameNotificationViewData();
  switch evt.m_notificationType {
    case UIInGameNotificationType.CombatRestriction:
      userData.title = "UI-Notifications-CombatRestriction";
      break;
    case UIInGameNotificationType.ActionRestriction:
      userData.title = "UI-Notifications-ActionBlocked";
      break;
    case UIInGameNotificationType.CantSaveActionRestriction:
      userData.title = "UI-Notifications-CantSave-Generic";
      break;
    case UIInGameNotificationType.CantSaveCombatRestriction:
      userData.title = "UI-Notifications-CantSave-Combat";
      break;
    case UIInGameNotificationType.CantSaveQuestRestriction:
      userData.title = "UI-Notifications-CantSave-Generic";
      break;
    case UIInGameNotificationType.CantSaveDeathRestriction:
      userData.title = "UI-Notifications-CantSave-Dead";
      break;
    case UIInGameNotificationType.NotEnoughSlotsSaveResctriction:
      userData.title = "UI-Notifications-SaveNotEnoughSlots";
      break;
    case UIInGameNotificationType.NotEnoughSpaceSaveResctriction:
      userData.title = "UI-Notifications-SaveNotEnoughSpace";
      break;
    case UIInGameNotificationType.PhotoModeDisabledRestriction:
      userData.title = "UI-PhotoMode-NotSupported";
  };
  if evt.m_isCustom {
    userData.title = evt.m_text;
  }
  userData.soundEvent = n"QuestSuccessPopup";
  userData.soundAction = n"OnOpen";
  notificationData.time = this.m_duration;
  notificationData.widgetLibraryItemName = n"popups_side";
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}
