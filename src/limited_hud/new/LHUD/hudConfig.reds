module LimitedHudConfig

// -- Limited HUD config v2.0

// -- Here you can configure base Limited HUD modules

// -- If you want to restore default widget behavior 
//    then set IsEnabled to false for chosen module

// -- When BindToGlobalHotkey set to true it means that
//    you will be able to toggle the module visibility 
//    with the mod global hotkey if you configured it
//    as described in the how-to guide

// -- For visibility conditions true means visible, false means hidden


// -- ACTION BUTTONS
public class ActionButtonsModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = true
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// -- CROUCH INDICATOR
//    Keep in mind that the mod logic just makes indicator invisible when hidden, 
//    if you want to completely remove it from HUD slot then just use
//    Remove Crouch Indicator addon from optional files download section
public class CrouchIndicatorModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// -- WEAPON ROSTER
public class WeaponRosterModuleConfig {
  // public static func IsEnabled() -> Bool = true
  // public static func BindToGlobalHotkey() -> Bool = false

  // public static func ShowInCombat() -> Bool = false
  // public static func ShowOutOfCombat() -> Bool = false
  // public static func ShowInStealth() -> Bool = false
  // public static func ShowWithWeapon() -> Bool = false
  // public static func ShowWithZoom() -> Bool = true
}



// // -- HOTKEY HINTS

// public class HintsModuleConfig {
//   public static func IsEnabled() -> Bool = true
//   public static func BindToGlobalHotkey() -> Bool = false

//   public static func ShowInCombat() -> Bool = false
//   public static func ShowOutOfCombat() -> Bool = false
//   public static func ShowInStealth() -> Bool = false
//   public static func ShowInVehicle() -> Bool = false
//   public static func ShowWithWeapon() -> Bool = false
//   public static func ShowWithZoom() -> Bool = false
// }


// // -- MINIMAP

// public class MinimapModuleConfig {
//   public static func Opacity() -> Float = 0.9

//   public static func IsEnabled() -> Bool = true
//   public static func BindToGlobalHotkey() -> Bool = true

//   public static func ShowInCombat() -> Bool = false
//   public static func ShowOutOfCombat() -> Bool = false
//   public static func ShowInStealth() -> Bool = false
//   public static func ShowInVehicle() -> Bool = true
//   public static func ShowWithScanner() -> Bool = false
//   public static func ShowWithWeapon() -> Bool = false
//   public static func ShowWithZoom() -> Bool = true
// }


// // -- HEALTHBAR

// public class PlayerHealthbarModuleConfig {
//   public static func IsEnabled() -> Bool = true
//   public static func BindToGlobalHotkey() -> Bool = false
//   // Default in-game visibility conditions
//   public static func ShowWhenHealthNotFull() -> Bool = true
//   public static func ShowWhenMemoryNotFull() -> Bool = true
//   public static func ShowWhenBuffsActive() -> Bool = true
//   public static func ShowWhenQuickhacksActive() -> Bool = true
//   public static func ShowInCombat() -> Bool = true
//   public static func ShowOutOfCombat() -> Bool = false
//   // Additional visibility conditions
//   public static func ShowInStealth() -> Bool = false
//   public static func ShowWithWeapon() -> Bool = true
//   public static func ShowWithZoom() -> Bool = false
// }

// // -- QUEST TRACKER

// public class QuestTrackerModuleConfig {
//   public static func IsEnabled() -> Bool = true
//   public static func BindToGlobalHotkey() -> Bool = true

//   public static func ShowInCombat() -> Bool = false
//   public static func ShowOutOfCombat() -> Bool = false
//   public static func ShowInStealth() -> Bool = false
//   public static func ShowInVehicle() -> Bool = true
//   public static func ShowWithScanner() -> Bool = false
//   public static func ShowWithWeapon() -> Bool = false
//   public static func ShowWithZoom() -> Bool = true
// }


// // -- WORLD MARKERS
// //    Here you can configure different world markers behavior

// // -- Loot markers behavior
// public class WorldMarkersModuleConfigLoot {

// }

// // -- Quest markers
// public class WorldMarkersModuleConfigQuest {

// }

// // --Place Of Interest markers behavior 
// //   (vendors, fast travel points and other kinds of place related markers)
// public class WorldMarkersModuleConfigPOI {

// }

// // --Combat related enemy markers
// //   (alert icon, healthbar, enemy type and other markers above enemy head)
// public class WorldMarkersModuleConfigCombat {

// }

// For compatibility with my Muted Markers mod set IsEnabled option to false
// public static func IsEnabled() -> Bool = true
// public static func BindToGlobalHotkey() -> Bool = true

// public static func ShowInCombat() -> Bool = true
// public static func ShowOutOfCombat() -> Bool = false
// public static func ShowInStealth() -> Bool = false
// public static func ShowInVehicle() -> Bool = false
// public static func ShowWithScanner() -> Bool = true
// public static func ShowWithWeapon() -> Bool = false
// public static func ShowWithZoom() -> Bool = true