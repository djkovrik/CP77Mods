module RevisedBackpack

public class RevisedBackpackConfirmationPopup {
  public static func Show(controller: ref<worlduiIGameController>, message: String, type: GenericMessageNotificationType) -> ref<inkGameNotificationToken> {
    return GenericMessageNotification.Show(
      controller, 
      GetLocalizedText("LocKey#11447"), 
      message,
      type
    );
  }
}
