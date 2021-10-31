module LimitedHudConfig

// -- Limited HUD v2.0 config

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

  public static func ShowInCombat() -> Bool = true
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = true
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- CROUCH INDICATOR
//    Keep in mind that the mod logic just makes indicator invisible, if you want 
//    to completely remove it from HUD slot (and move weapon roster to bottom right corner) 
//    then just use Remove Crouch Indicator addon from optional files download section
public class CrouchIndicatorModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = true
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = true
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- WEAPON ROSTER
public class WeaponRosterModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = true
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = true
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- HOTKEY HINTS
public class HintsModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// -- MINIMAP
public class MinimapModuleConfig {
  // You can use values from 0.0 to 1.0 here
  public static func Opacity() -> Float = 0.9

  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// -- QUEST TRACKER
public class QuestTrackerModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// -- PLAYER HEALTHBAR
public class PlayerHealthbarModuleConfig {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false
  // Default in-game visibility conditions
  public static func ShowWhenHealthNotFull() -> Bool = true
  public static func ShowWhenMemoryNotFull() -> Bool = true
  public static func ShowWhenBuffsActive() -> Bool = true
  public static func ShowWhenQuickhacksActive() -> Bool = true
  public static func ShowInCombat() -> Bool = true
  // Additional visibility conditions
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}


// -- WORLD MARKERS
//    Here you can configure visibility behavior for different world marker types

// ---- Quest markers -check
public class WorldMarkersModuleConfigQuest {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = true
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// ---- Loot and shards markers -check
public class WorldMarkersModuleConfigLoot {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// ---- Place Of Interest markers  -check
//      Contains Fast Travel points, fixers, vendors and all kinds of services
public class WorldMarkersModuleConfigPOI {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// ---- Combat markers -check
//      Contains all combat and enemy related markers (grenades, enemy combat type, healthbar, arrow and alert markers)
public class WorldMarkersModuleConfigCombat {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}

// ---- Owned vehicle markers -check
public class WorldMarkersModuleConfigVehicles {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithZoom() -> Bool = false
}
