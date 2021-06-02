module LimitedHudConfig

// -- Here you can configure base Limited HUD modules

// -- If you want to restore default widget behavior 
//    then set IsEnabled to false for chosen module

// -- When BindToGlobalHotkey set to true it means that
//    you will be able to toggle the module visibility 
//    with the mod global hotkey if you configured it
//    as described in the how-to guide

// -- For visibility conditions true means visible, false means hidden

// -- Action Buttons module
public class ActionButtonsModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false
  // Visibility conditions
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- Crouch indicator and weapon roster module
// -- By default LHUD shows it only when player has weapon unsheathed,
//    here you can enable displaying while in stealth
public class CrouchAndWeaponRosterModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false
  // Visibility conditions
  public static func ShowInStealth() -> Bool = true
}

// -- Vanilla hotkey hints module
public class HintsModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false
  // Visibility conditions
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// -- Minimap module
public class MinimapModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true
  // Use value in range from 0.0 to 1.0
  public static func Opacity() -> Float = 0.75
  // Visibility conditions
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// -- Player healthbar module
public class PlayerHealthbarModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false
  // Default in-game visibility conditions
  public static func ShowWhenHealthNotFull() -> Bool = true
  public static func ShowWhenMemoryNotFull() -> Bool = true
  public static func ShowWhenBuffsActive() -> Bool = true
  public static func ShowWhenQuickhacksActive() -> Bool = true
  public static func ShowInCombat() -> Bool = true
  // Additional visibility conditions
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- Quest Tracker module
public class QuestTrackerModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true
  // Visibility conditions
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// -- World Markers module
public class WorldMarkersModuleConfig {
  // Main config
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true
  // Visibility conditions
  public static func ShowInCombat() -> Bool = true
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = true
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}
