import CarDealer.Transactions.VehicleTradeResult
import CarDealer.Utils.DealerTexts

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

public class VirtualCarDealerTradePopup {
  public static func Show(controller: ref<worlduiIGameController>, result: VehicleTradeResult, id: TweakDBID) -> Void {
    let message: String = DealerTexts.TradeFailed();
    if Equals(result, VehicleTradeResult.CompensationPending) {
      message = DealerTexts.TradePending();
    } else {
      if Equals(result, VehicleTradeResult.ReviewRequired) {
        message = DealerTexts.TradeReview();
      };
    };
    GenericMessageNotification.Show(controller, GetLocalizedText("LocKey#11447"), s"\(message)\n\(TDBID.ToStringDEBUG(id))", GenericMessageNotificationType.OK);
  }
}
