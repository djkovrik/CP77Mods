public class HUDitorTexts {

  public static func GetWidgetName(name: CName) -> String {
    let nameString: String;
    switch name {
      case n"NewTracker":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Tracker"); 
        break;
      case n"NewMinimap":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Minimap"); 
        break;
      case n"NewWanted":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Wanted"); 
        break;
      case n"NewQuestNotifications":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Quest-Notifs"); 
        break;
      case n"NewItemNotifications":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Item-Notifs"); 
        break;
      case n"NewVehicleSummon":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Vehicle-Summon"); 
        break;
      case n"NewWeaponRoster":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Roster"); 
        break;
      case n"NewCrouchIndicator":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Crouch"); 
        break;
      case n"NewDpad":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Dpad"); 
        break;
      case n"NewPhoneHotkey":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Phone-Controller"); 
        break;
      case n"NewHealthBar":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Player-Healthbar"); 
        break;
      case n"NewStaminaBar":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Stamina"); 
        break;
      case n"NewPhoneAvatar":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Call-Avatar"); 
        break;
      case n"NewPhoneControl":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Call-Button"); 
        break;
      case n"NewInputHint":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Hints"); 
        break;
      case n"NewCarHud":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Speedometer"); 
        break;
      case n"NewBossHealthbar":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Boss-Healthbar"); 
        break;
      case n"NewDialogChoices":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Dialog-Choices"); 
        break;
      case n"NewDialogSubtitles":
        nameString = GetLocalizedTextByKey(n"Mod-HUDitor-Widget-Dialog-Subs"); 
        break;
      case n"NewCompass":
        nameString = "E3 Compass"; 
        break;
      default: 
        nameString = "Unknown"; 
        break;
    };

    return s"HUDitor: \(nameString)";
  }
}
