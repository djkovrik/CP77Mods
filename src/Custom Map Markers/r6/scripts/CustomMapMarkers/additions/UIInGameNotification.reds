// Customize warning notificaiton text

@addField(UIInGameNotificationEvent)
public let m_isCustom: Bool;

@addField(UIInGameNotificationEvent)
public let m_text: String;

@wrapMethod(UIInGameNotificationQueue)
protected cb func OnUINotification(evt: ref<UIInGameNotificationEvent>) -> Bool {
  let newNotificationData: gameuiGenericNotificationData;
  let newUserData: ref<UIInGameNotificationViewData>;

  if evt.m_isCustom {
    newUserData = new UIInGameNotificationViewData();
    newUserData.title = evt.m_text;
    newUserData.soundEvent = n"QuestSuccessPopup";
    newUserData.soundAction = n"OnOpen";
    newNotificationData.time = this.m_duration;
    newNotificationData.widgetLibraryItemName = n"popups_side";
    newNotificationData.notificationData = newUserData;
    this.AddNewNotificationData(newNotificationData);
    return true;
  };

  wrappedMethod(evt);
}
