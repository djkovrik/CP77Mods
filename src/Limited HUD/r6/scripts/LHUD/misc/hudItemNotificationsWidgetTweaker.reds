import LimitedHudConfig.LHUDAddonsConfig

@wrapMethod(ItemsNotificationQueue)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  let scale: Float = LHUDAddonsConfig.ItemNotificationScale();
  let opacity: Float = LHUDAddonsConfig.ItemNotificationOpacity();
  this.GetRootWidget().SetScale(new Vector2(scale, scale)); // Scale
  this.GetRootWidget().SetOpacity(opacity);                 // Opacity
}

// SOUNDS

@replaceMethod(ItemsNotificationQueue)
public final func PushCurrencyNotification(diff: Int32, total: Uint32) -> Void {
  let notificationData: gameuiGenericNotificationData;
  let userData: ref<CurrencyUpdateNotificationViewData>;
  if diff == 0 {
    return;
  };
  userData = new CurrencyUpdateNotificationViewData();
  userData.diff = diff;
  userData.total = total;
  if !LHUDAddonsConfig.ItemNotificationDisableSoundCurrency() {
    userData.soundEvent = n"QuestUpdatePopup";
    userData.soundAction = n"OnOpen";
  };
  notificationData.time = 6.10;
  notificationData.widgetLibraryItemName = this.m_currencyNotification;
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}
