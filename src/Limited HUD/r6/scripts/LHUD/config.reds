module LimitedHudConfig
import LimitedHudCommon.*

public class LimitedHudHotkeys {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "UI-Settings-KeyBindings")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Hotkey")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let lhudGlobalToggle: EInputKey = EInputKey.IK_F8;
  
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "UI-Settings-KeyBindings")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Minimap-Hotkey")
  @runtimeProperty("ModSettings.description", "UI-Settings-Bind")
  public let lhudMinimapToggle: EInputKey = EInputKey.IK_F6;
}

public class ActionButtonsModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot-Del")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Del-Desc")
  public let ShowWithAutoDriveDelamain: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Cooldown")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Cooldown-Desc")
  public let ShowAtCooldown: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Action-Buttons")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 1.0;
}

public class CrouchIndicatorModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Crouch-Indicator")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 1.0;
}

public class WeaponRosterModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Weapon-Roster")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 1.0;
}

public class HintsModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot-Del")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Del-Desc")
  public let ShowWithAutoDriveDelamain: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Metro")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Metro-Desc")
  public let ShowInMetro: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Hotkey-Hints")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 1.0;
}

public class MinimapModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Wanted")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Wanted-Desc")
  public let ShowWhenWanted: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 0.9;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Minimap")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Minimap-District")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Minimap-District-Desc")
  public let ShowCurrentDistrict: Bool = true;
}

public class QuestTrackerModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Quest-Tracker-Updates")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Quest-Tracker-Updates-Desc")
  public let DisplayForQuestUpdates: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Quest-Tracker-Time")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Quest-Tracker-Time-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0")
  public let QuestUpdateDisplayingTime: Float = 5.0;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Quest-Tracker")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 1.0;
}

public class PlayerHealthbarModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-No-Health")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-No-Health-Desc")
  public let ShowWhenHealthNotFull: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-No-Memory")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-No-Memory-Desc")
  public let ShowWhenMemoryNotFull: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-Buffs")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-Buffs-Desc")
  public let ShowWhenBuffsActive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Healthbar-Hacks")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Healthbar-Hacks-Desc")
  public let ShowWhenQuickhacksActive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Healthbar")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 1.0;
}

public class PlayerStaminabarModuleConfig {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Player-Stamina-Not-Full")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Player-Stamina-Not-Full-Desc")
  public let ShowNotFull: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Stats-Stamina")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Opacity")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Opacity-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "1.0")
  public let Opacity: Float = 0.7;
}

public class WorldMarkersModuleConfigQuest {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Quest")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigLoot {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Loot")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigPOI {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-POI")
  @runtimeProperty("ModSettings.category.order", "11")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-POI-Tracked")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-POI-Tracked-Desc")
  public let AlwaysShowTrackedMarker: Bool = false;
}

public class WorldMarkersModuleConfigCombat {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Combat-Desc")
  public let ShowInCombat: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Out-Combat")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Out-Combat-Desc")
  public let ShowOutOfCombat: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Stealth")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Stealth-Desc")
  public let ShowInStealth: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Weapon")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Weapon-Desc")
  public let ShowWithWeapon: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Combat")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigVehicles {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Global-Key")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Global-Key-Desc")
  public let BindToGlobalHotkey: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Vehicle")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Vehicle-Desc")
  public let ShowInVehicle: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-AutoPilot")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-AutoPilot-Desc")
  public let ShowWithAutoDrive: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Zoom")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Zoom-Desc")
  public let ShowWithZoom: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Vehicles")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Area")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Area-Desc")
  public let ShowInDangerArea: Bool = false;
}

public class WorldMarkersModuleConfigDevices {
  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Devices")
  @runtimeProperty("ModSettings.category.order", "14")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Is-Enabled")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Is-Enabled-Desc")
  public let IsEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "LHUD")
  @runtimeProperty("ModSettings.category", "Mod-LHUD-Player-Markers-Devices")
  @runtimeProperty("ModSettings.category.order", "14")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Show-Scanner")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Show-Scanner-Desc")
  public let ShowWithScanner: Bool = true;
}

public class LHUDAddonsConfig {
  
  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Notification-Sounds")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Notification-Mute-Quest")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Notification-Mute-Quest-Desc")
  public let MuteQuestNotifications: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Notification-Sounds")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Notification-Mute-Level")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Notification-Mute-Level-Desc")
  public let MuteLevelUpNotifications: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Hide-Prompt")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#23295")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Hide-Prompt-Vehicle")
  public let HidePromptGetIn: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Hide-Prompt")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#238")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Hide-Prompt-Pick-Up")
  public let HidePromptPickUpBody: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Hide-Prompt")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#312")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Hide-Prompt-Talk")
  public let HidePromptTalk: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Speedometer")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Speedometer-Hide-Desc")
  public let HideSpeedometer: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Crouch")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Crouch-Remove-Desc")
  public let HideCrouchIndicator: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Healthbar-Texts")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Healthbar-Texts-Remove-Desc")
  public let RemoveHealthbarTexts: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Remover-Overhead")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Remover-Overhead-Desc")
  public let RemoveOverheadSubtitles: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Widgets-Remover")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-New-Area")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-New-Area-Desc")
  public let RemoveNewAreaNotification: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Dialog-Resizer")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Scale")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Scale-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.1")
  @runtimeProperty("ModSettings.max", "2.0")
  public let DialogResizerScale: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Pulse")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Pulse-Disable")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Pulse-Disable-Desc")
  public let RemoveMarkerPulse: Bool = false;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Highlighting")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Highlight-Pinged")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Highlight-Pinged-Desc")
  public let HighlightUnderPingOnly: Bool = false;
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
  public let FillInteraction: LHUDFillColors = LHUDFillColors.LightBlue;

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
  public let FillImportantInteraction: LHUDFillColors = LHUDFillColors.Blue;

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
  public let FillWeakspot: LHUDFillColors = LHUDFillColors.Orange;

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
  public let FillQuest: LHUDFillColors = LHUDFillColors.LightYellow;

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
  public let FillDistraction: LHUDFillColors = LHUDFillColors.White;

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
  public let FillClue: LHUDFillColors = LHUDFillColors.LightGreen;

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
  public let FillNPC: LHUDFillColors = LHUDFillColors.Transparent;

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
  public let FillAOE: LHUDFillColors = LHUDFillColors.Red;

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
  public let FillItem: LHUDFillColors = LHUDFillColors.Blue;

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
  public let FillHostile: LHUDFillColors = LHUDFillColors.Red;

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
  public let FillFriendly: LHUDFillColors = LHUDFillColors.LightGreen;

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
  public let FillNeutral: LHUDFillColors = LHUDFillColors.LightBlue;

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
  public let FillHackable: LHUDFillColors = LHUDFillColors.LightGreen;

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
  public let FillEnemyNetrunner: LHUDFillColors = LHUDFillColors.Orange;

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
  public let FillBackdoor: LHUDFillColors = LHUDFillColors.Blue;


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
  public let OutlineInteraction: LHUDOutlineColors = LHUDOutlineColors.LightBlue;

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
  public let OutlineImportantInteraction: LHUDOutlineColors = LHUDOutlineColors.Blue;

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
  public let OutlineWeakspot: LHUDOutlineColors = LHUDOutlineColors.LightRed;

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
  public let OutlineQuest: LHUDOutlineColors = LHUDOutlineColors.LightYellow;

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
  public let OutlineDistraction: LHUDOutlineColors = LHUDOutlineColors.White;

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
  public let OutlineClue: LHUDOutlineColors = LHUDOutlineColors.LightGreen;

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
  public let OutlineAOE: LHUDOutlineColors = LHUDOutlineColors.Red;

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
  public let OutlineItem: LHUDOutlineColors = LHUDOutlineColors.Blue;

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
  public let OutlineHostile: LHUDOutlineColors = LHUDOutlineColors.Red;

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
  public let OutlineFriendly: LHUDOutlineColors = LHUDOutlineColors.LightGreen;

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
  public let OutlineNeutral: LHUDOutlineColors = LHUDOutlineColors.LightBlue;

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
  public let OutlineHackable: LHUDOutlineColors = LHUDOutlineColors.LightGreen;

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
  public let OutlineEnemyNetrunner: LHUDOutlineColors = LHUDOutlineColors.LightRed;

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
  public let OutlineBackdoor: LHUDOutlineColors = LHUDOutlineColors.Blue;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "Addons-LHUD-Coloring-Ricochet")
  @runtimeProperty("ModSettings.category.order", "12")
  @runtimeProperty("ModSettings.displayName", "Addons-LHUD-Coloring-Ricochet-NPC")
  @runtimeProperty("ModSettings.description", "Addons-LHUD-Coloring-Ricochet-NPC-Desc")
  @runtimeProperty("ModSettings.displayValues.Transparent", "Mod-LHUD-Transparent")
  @runtimeProperty("ModSettings.displayValues.Green", "Mod-LHUD-Green")
  @runtimeProperty("ModSettings.displayValues.Red", "Mod-LHUD-Red")
  @runtimeProperty("ModSettings.displayValues.Yellow", "Mod-LHUD-Light-Yellow")
  public let RicochetColor: LHUDRicochetColors = LHUDRicochetColors.Green;

  @runtimeProperty("ModSettings.mod", "LHUD Addons")
  @runtimeProperty("ModSettings.category", "UI-Settings-Interface-HUD-Nameplates")
  @runtimeProperty("ModSettings.category.order", "13")
  @runtimeProperty("ModSettings.displayName", "Mod-LHUD-Custom-Colors")
  @runtimeProperty("ModSettings.description", "Mod-LHUD-Custom-Colors-Desc")
  public let EnableCustomColors: Bool = true;

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
  public let NameplateHpAndArrowAppearance: LHUDArrowAndHpAppearance = LHUDArrowAndHpAppearance.Orange;

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
  public let DamagePreviewColor: LHUDDamagePreviewColors = LHUDDamagePreviewColors.Blue;
}
