@addMethod(GenericMessageNotification)
public final static func ShowInputWithOriginalCase(controller: ref<worlduiIGameController>, title: String, message: String, type: GenericMessageNotificationType) -> ref<inkGameNotificationToken> {
  let data: ref<GenericMessageNotificationData> = GenericMessageNotification.GetBaseData();
  data.title = title;
  data.message = message;
  data.type = type;
  data.isInput = true;
  return controller.ShowGameNotification(data);
}

public final static func EnableHudPainterLogs() -> Bool = true


/**
TODO:
  + Localization
  + Scrollable container for colors
  + Spawn colors list
  + Color preview borders
  + Highlight default/johnny color items
  + Mark colors as changed * on slider activity (add third color to item)
  + Reset color button
  + Presets slot and buttons
  + Spawn preset lists
  + Preset item states: hovered / selected / activated
  + Handle preset manager clicks
  + Handle controls state on preset saving / activation
  + Patch inkstyle_menu
  - Missed .archive popup and logic
  - inkstyle reload? ask psi
  - Widget live previews?
**/
