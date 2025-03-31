module AtelierDelivery

@addMethod(UIMenuNotificationQueue)
protected cb func OnAtelierDeliveryOrderCreatedEvent(evt: ref<AtelierDeliveryOrderCreatedEvent>) -> Bool {
  let message: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Created-Nofitication");
  let messageToDisplay: String = StrReplace(message, "{id}", IntToString(evt.id));
  let userData: ref<UIMenuNotificationViewData> = new UIMenuNotificationViewData();
  let notificationData: gameuiGenericNotificationData;
  userData.title = messageToDisplay;
  userData.soundEvent = n"QuestSuccessPopup";
  userData.soundAction = n"OnOpen";
  notificationData.time = this.m_duration;
  notificationData.widgetLibraryItemName = n"popups_side";
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}