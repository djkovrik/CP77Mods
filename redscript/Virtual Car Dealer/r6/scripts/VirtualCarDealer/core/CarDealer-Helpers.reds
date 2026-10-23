public class VirtualCarDealerSellingPopup {
  public static func Show(controller: ref<worlduiIGameController>) -> ref<inkGameNotificationToken> {
    return GenericMessageNotification.Show(
      controller, 
      GetLocalizedText("LocKey#11447"), 
      GetLocalizedTextByKey(n"Mod-Car-Dealer-Confirm-Sell"),
      GenericMessageNotificationType.YesNo
    );
  }
}
