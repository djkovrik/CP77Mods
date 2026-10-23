public class HudPainterMissingArchivePopup {
  public static func Show(controller: ref<worlduiIGameController>) -> ref<inkGameNotificationToken> {
    return GenericMessageNotification.Show(
      controller, 
      GetLocalizedText("LocKey#11447"), 
        "HUDPainter.archive file not found!\nMake sure that the mod .archive and .xl files are installed " + 
        "to Cyberpunk 2077/archive/pc/mod folder. If you are using Vortex then disable REDMod Autoconvert " + 
        "option and reinstall the mod.",
      GenericMessageNotificationType.OK
    );
  }
}

public class HudPainterWarningPopup {
  public static func Show(controller: ref<worlduiIGameController>, message: String, type: GenericMessageNotificationType) -> ref<inkGameNotificationToken> {
    return GenericMessageNotification.Show(
      controller, 
      GetLocalizedText("LocKey#11447"), 
      message,
      type
    );
  }
}
