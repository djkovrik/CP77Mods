module LimitedHudConfig
import LimitedHudCommon.*

public class ActionButtonsModuleConfig {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = true;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = true;
  let ShowWithWeapon: Bool = true;
  let ShowWithZoom: Bool = false;
}

public class CrouchIndicatorModuleConfig {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = true;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = true;
  let ShowWithWeapon: Bool = true;
  let ShowWithZoom: Bool = false;
}

public class WeaponRosterModuleConfig {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = true;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = true;
  let ShowWithWeapon: Bool = true;
  let ShowWithZoom: Bool = false;
}

public class HintsModuleConfig {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = false;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowInVehicle: Bool = false;
  let ShowWithWeapon: Bool = false;
  let ShowWithZoom: Bool = false;
}

public class MinimapModuleConfig {
  let Opacity: Float = 0.9;

  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = true;

  let ShowInCombat: Bool = false;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowInVehicle: Bool = true;
  let ShowWithScanner: Bool = false;
  let ShowWithWeapon: Bool = false;
  let ShowWithZoom: Bool = true;
}

public class QuestTrackerModuleConfig {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = true;

  let ShowInCombat: Bool = false;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowInVehicle: Bool = true;
  let ShowWithScanner: Bool = false;
  let ShowWithWeapon: Bool = false;
  let ShowWithZoom: Bool = true;
  let DisplayForQuestUpdates: Bool = true;
  let QuestUpdateDisplayingTime: Float = 5.0;
}

public class PlayerHealthbarModuleConfig {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;
  let ShowWhenHealthNotFull: Bool = true;
  let ShowWhenMemoryNotFull: Bool = true;
  let ShowWhenBuffsActive: Bool = true;
  let ShowWhenQuickhacksActive: Bool = true;
  let ShowInCombat: Bool = true;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowWithWeapon: Bool = true;
  let ShowWithZoom: Bool = false;
}

public class WorldMarkersModuleConfigQuest {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = true;

  let ShowInCombat: Bool = false;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowInVehicle: Bool = false;
  let ShowWithScanner: Bool = true;
  let ShowWithWeapon: Bool = false;
  let ShowWithZoom: Bool = true;
}

public class WorldMarkersModuleConfigLoot {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = false;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowInVehicle: Bool = false;
  let ShowWithScanner: Bool = true;
  let ShowWithWeapon: Bool = false;
  let ShowWithZoom: Bool = true;
}

public class WorldMarkersModuleConfigPOI {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = false;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = false;
  let ShowInVehicle: Bool = true;
  let ShowWithScanner: Bool = true;
  let ShowWithWeapon: Bool = false;
  let ShowWithZoom: Bool = true;

  let AlwaysShowTrackedMarker: Bool = false;
}

public class WorldMarkersModuleConfigCombat {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInCombat: Bool = true;
  let ShowOutOfCombat: Bool = false;
  let ShowInStealth: Bool = true;
  let ShowInVehicle: Bool = false;
  let ShowWithScanner: Bool = false;
  let ShowWithWeapon: Bool = true;
  let ShowWithZoom: Bool = false;
}

public class WorldMarkersModuleConfigVehicles {
  let IsEnabled: Bool = true;
  let BindToGlobalHotkey: Bool = false;

  let ShowInVehicle: Bool = false;
  let ShowWithScanner: Bool = false;
  let ShowWithZoom: Bool = true;
}

public class WorldMarkersModuleConfigDevices{
  let IsEnabled: Bool = true;
  let ShowWithScanner: Bool = true;
}

public class LHUDAddonsConfig {
  let JournalNotificationOpacity: Float = 1.0;
  let JournalNotificationScale: Float = 0.7;
  let ItemNotificationOpacity: Float = 1.0;
  let ItemNotificationScale: Float = 0.7;
  let MuteQuestNotifications: Bool = false;
  let MuteLevelUpNotifications: Bool = false;
  let HidePromptGetIn: Bool = false;
  let HidePromptPickUpBody: Bool = false;
  let HidePromptTalk: Bool = false;
  let HideSpeedometer: Bool = false;
  let HideCrouchIndicator: Bool = false;
  let RemoveHealthbarTexts: Bool = false;
  let RemoveOverheadSubtitles: Bool = false;
  let RemoveNewAreaNotification: Bool = false;
  let DialogResizerScale: Float = 1.0;
  let FixEvolutionIcons: Bool = true;
  let RemoveMarkerPulse: Bool = false;
  let EnableHUDToggle: Bool = false;
  let HighlightUnderPingOnly: Bool = false;
}

public class LHUDAddonsColoringConfig {
  let FillInteraction: LHUDFillColors = LHUDFillColors.LightBlue;
  let FillImportantInteraction: LHUDFillColors = LHUDFillColors.Blue;
  let FillWeakspot: LHUDFillColors = LHUDFillColors.Orange;
  let FillQuest: LHUDFillColors = LHUDFillColors.LightYellow;
  let FillDistraction: LHUDFillColors = LHUDFillColors.White;
  let FillClue: LHUDFillColors = LHUDFillColors.LightGreen;
  let FillNPC: LHUDFillColors = LHUDFillColors.Transparent;
  let FillAOE: LHUDFillColors = LHUDFillColors.Red;
  let FillItem: LHUDFillColors = LHUDFillColors.Blue;
  let FillHostile: LHUDFillColors = LHUDFillColors.Red;
  let FillFriendly: LHUDFillColors = LHUDFillColors.LightGreen;
  let FillNeutral: LHUDFillColors = LHUDFillColors.LightBlue;
  let FillHackable: LHUDFillColors = LHUDFillColors.LightGreen;
  let FillEnemyNetrunner: LHUDFillColors = LHUDFillColors.Orange;
  let FillBackdoor: LHUDFillColors = LHUDFillColors.Blue;

  let OutlineInteraction: LHUDOutlineColors = LHUDOutlineColors.LightBlue;
  let OutlineImportantInteraction: LHUDOutlineColors = LHUDOutlineColors.Blue;
  let OutlineWeakspot: LHUDOutlineColors = LHUDOutlineColors.LightRed;
  let OutlineQuest: LHUDOutlineColors = LHUDOutlineColors.LightYellow;
  let OutlineDistraction: LHUDOutlineColors = LHUDOutlineColors.White;
  let OutlineClue: LHUDOutlineColors = LHUDOutlineColors.LightGreen;
  let OutlineAOE: LHUDOutlineColors = LHUDOutlineColors.Red;
  let OutlineItem: LHUDOutlineColors = LHUDOutlineColors.Blue;
  let OutlineHostile: LHUDOutlineColors = LHUDOutlineColors.Red;
  let OutlineFriendly: LHUDOutlineColors = LHUDOutlineColors.LightGreen;
  let OutlineNeutral: LHUDOutlineColors = LHUDOutlineColors.LightBlue;
  let OutlineHackable: LHUDOutlineColors = LHUDOutlineColors.LightGreen;
  let OutlineEnemyNetrunner: LHUDOutlineColors = LHUDOutlineColors.LightRed;
  let OutlineBackdoor: LHUDOutlineColors = LHUDOutlineColors.Blue;

  let RicochetColor: LHUDRicochetColors = LHUDRicochetColors.Green;
}
