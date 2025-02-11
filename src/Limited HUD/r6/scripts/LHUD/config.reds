module LimitedHudConfig
import LimitedHudCommon.*

public class ActionButtonsModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Cooldown")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Cooldown-Desc")
  let ShowAtCooldown: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 1.0;
}

public class CrouchIndicatorModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 1.0;
}

public class WeaponRosterModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 1.0;
}

public class HintsModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Metro")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Metro-Desc")
  let ShowInMetro: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 1.0;
}

public class MinimapModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Wanted")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Wanted-Desc")
  let ShowWhenWanted: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 0.9;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Minimap-District")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Minimap-District-Desc")
  let ShowCurrentDistrict: Bool = true;
}

public class QuestTrackerModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Quest-Tracker-Updates")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Quest-Tracker-Updates-Desc")
  let DisplayForQuestUpdates: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Quest-Tracker-Time")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Quest-Tracker-Time-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0")
  let QuestUpdateDisplayingTime: Float = 5.0;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 1.0;
}

public class PlayerHealthbarModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-No-Health")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-No-Health-Desc")
  let ShowWhenHealthNotFull: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-No-Memory")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-No-Memory-Desc")
  let ShowWhenMemoryNotFull: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-Buffs")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-Buffs-Desc")
  let ShowWhenBuffsActive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-Hacks")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-Hacks-Desc")
  let ShowWhenQuickhacksActive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 1.0;
}

public class PlayerStaminabarModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Stamina-Not-Full")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Stamina-Not-Full-Desc")
  let ShowNotFull: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  let Opacity: Float = 0.7;
}

public class WorldMarkersModuleConfigQuest {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigLoot {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigPOI {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-POI-Tracked")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-POI-Tracked-Desc")
  let AlwaysShowTrackedMarker: Bool = false;
}

public class WorldMarkersModuleConfigCombat {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigVehicles {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigDevices {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Devices")
  @runtimeProperty("ModSettings.category.order", "14")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Devices")
  @runtimeProperty("ModSettings.category.order", "14")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  let ShowWithScanner: Bool = true;
}

public class LHUDAddonsConfig {
  
  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Notification-Sounds")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Notification-Mute-Quest")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Notification-Mute-Quest-Desc")
  let MuteQuestNotifications: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Notification-Sounds")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Notification-Mute-Level")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Notification-Mute-Level-Desc")
  let MuteLevelUpNotifications: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Hide-Prompt")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#23295")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Hide-Prompt-Vehicle")
  let HidePromptGetIn: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Hide-Prompt")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#238")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Hide-Prompt-Pick-Up")
  let HidePromptPickUpBody: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Hide-Prompt")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#312")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Hide-Prompt-Talk")
  let HidePromptTalk: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Speedometer")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Speedometer-Hide-Desc")
  let HideSpeedometer: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Crouch")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Crouch-Remove-Desc")
  let HideCrouchIndicator: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Healthbar-Texts")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Healthbar-Texts-Remove-Desc")
  let RemoveHealthbarTexts: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Remover-Overhead")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Remover-Overhead-Desc")
  let RemoveOverheadSubtitles: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-New-Area")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-New-Area-Desc")
  let RemoveNewAreaNotification: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Dialog-Resizer")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Scale")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Scale-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.1")
  @runtimeProperty("ModSettings.max", "2.0")
  let DialogResizerScale: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Pulse")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Pulse-Disable")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Pulse-Disable-Desc")
  let RemoveMarkerPulse: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Highlighting")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Highlight-Pinged")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Highlight-Pinged-Desc")
  let HighlightUnderPingOnly: Bool = false;
}

public class LHUDAddonsColoringConfig {
  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Interaction")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Interaction-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillInteraction: LHUDFillColors = LHUDFillColors.LightBlue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Imp-Interaction")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Imp-Interaction-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillImportantInteraction: LHUDFillColors = LHUDFillColors.Blue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Weakspot")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Weakspot-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillWeakspot: LHUDFillColors = LHUDFillColors.Orange;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Quest")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Quest-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillQuest: LHUDFillColors = LHUDFillColors.LightYellow;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Distraction")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Distraction-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillDistraction: LHUDFillColors = LHUDFillColors.White;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Clue")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Clue-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillClue: LHUDFillColors = LHUDFillColors.LightGreen;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-NPC")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-NPC-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillNPC: LHUDFillColors = LHUDFillColors.Transparent;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-AOE")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-AOE-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillAOE: LHUDFillColors = LHUDFillColors.Red;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Item")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Item-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillItem: LHUDFillColors = LHUDFillColors.Blue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Hostile")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Hostile-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillHostile: LHUDFillColors = LHUDFillColors.Red;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Friendly")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Friendly-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillFriendly: LHUDFillColors = LHUDFillColors.LightGreen;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Neutral")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Neutral-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillNeutral: LHUDFillColors = LHUDFillColors.LightBlue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Hackable")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Hackable-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillHackable: LHUDFillColors = LHUDFillColors.LightGreen;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Netrunner")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Netrunner-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillEnemyNetrunner: LHUDFillColors = LHUDFillColors.Orange;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Fill")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Backdoor")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Backdoor-Fill")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let FillBackdoor: LHUDFillColors = LHUDFillColors.Blue;


  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Interaction")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Interaction-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineInteraction: LHUDOutlineColors = LHUDOutlineColors.LightBlue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Imp-Interaction")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Imp-Interaction-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineImportantInteraction: LHUDOutlineColors = LHUDOutlineColors.Blue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Weakspot")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Weakspot-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineWeakspot: LHUDOutlineColors = LHUDOutlineColors.LightRed;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Quest")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Quest-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineQuest: LHUDOutlineColors = LHUDOutlineColors.LightYellow;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Distraction")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Distraction-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineDistraction: LHUDOutlineColors = LHUDOutlineColors.White;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Clue")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Clue-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineClue: LHUDOutlineColors = LHUDOutlineColors.LightGreen;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-AOE")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-AOE-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineAOE: LHUDOutlineColors = LHUDOutlineColors.Red;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Item")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Item-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineItem: LHUDOutlineColors = LHUDOutlineColors.Blue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Hostile")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Hostile-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineHostile: LHUDOutlineColors = LHUDOutlineColors.Red;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Friendly")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Friendly-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineFriendly: LHUDOutlineColors = LHUDOutlineColors.LightGreen;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Neutral")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Neutral-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineNeutral: LHUDOutlineColors = LHUDOutlineColors.LightBlue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Hackable")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Hackable-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineHackable: LHUDOutlineColors = LHUDOutlineColors.LightGreen;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Netrunner")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Netrunner-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineEnemyNetrunner: LHUDOutlineColors = LHUDOutlineColors.LightRed;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Outline")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Backdoor")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Backdoor-Outline")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.LightGreen", "Mod-LHUD-Light-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.LightBlue", "Mod-LHUD-Light-Blue")
  @runtimeProperty("ModSettings.displayValues.LightRed", "Mod-LHUD-Light-Red")
  @runtimeProperty("ModSettings.displayValues.LightYellow", "Mod-LHUD-Light-Yellow")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let OutlineBackdoor: LHUDOutlineColors = LHUDOutlineColors.Blue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Ricochet")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Ricochet-NPC")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Ricochet-NPC-Desc")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.Green", "Mod-LHUD-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  let RicochetColor: LHUDRicochetColors = LHUDRicochetColors.Green;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "UI-Settings-Interface-HUD-Nameplates")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Custom-Colors")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Custom-Colors-Desc")
  let EnableCustomColors: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "UI-Settings-Interface-HUD-Nameplates")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-HP-Arrow-Color")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-HP-Arrow-Color-Desc")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Green", "Mod-LHUD-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  let NameplateHpAndArrowAppearance: LHUDArrowAndHpAppearance = LHUDArrowAndHpAppearance.Orange;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "UI-Settings-Interface-HUD-Nameplates")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Damage-Preview-Color")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Damage-Preview-Color-Desc")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.Orange", "Mod-LHUD-Orange")
  @runtimeProperty("ModSettings.displayValues.Green", "Mod-LHUD-Green")
  @runtimeProperty("ModSettings.displayValues.Blue", "Mod-LHUD-Blue")
  @runtimeProperty("ModSettings.displayValues.Black", "Mod-LHUD-Black")
  @runtimeProperty("ModSettings.displayValues.White", "Mod-LHUD-White")
  let DamagePreviewColor: LHUDDamagePreviewColors = LHUDDamagePreviewColors.Blue;
}
