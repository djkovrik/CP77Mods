module LimitedHudConfig

// -- Limited HUD v2.5 config

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

// ---- Quest markers
public class WorldMarkersModuleConfigQuest {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = true

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = true
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// ---- Loot and shards markers
//      Keep in mind that each option here just enables vanilla visibility
//      behavior for loot markers and does not make it always visible
//      You can use my Muted Markers mod for more precise tweaks
public class WorldMarkersModuleConfigLoot {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = true
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// ---- Place Of Interest markers
//      Contains Fast Travel points, fixers, vendors and all kinds of services
public class WorldMarkersModuleConfigPOI {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = false
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = true
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true

  public static func AlwaysShowTrackedMarker() -> Bool = false
}

// ---- Combat markers
//      Contains all combat and enemy related markers 
//      (grenades, enemy combat type, healthbar, arrow and alert markers)
public class WorldMarkersModuleConfigCombat {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInCombat() -> Bool = true
  public static func ShowOutOfCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = true
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// ---- Owned vehicle markers
public class WorldMarkersModuleConfigVehicles {
  public static func IsEnabled() -> Bool = true
  public static func BindToGlobalHotkey() -> Bool = false

  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// ---- Devices and interactions
//      Contains network devices, hide body containers, distractions and explosives
public class WorldMarkersModuleConfigDevices{
  public static func IsEnabled() -> Bool = true
  public static func ShowWithScanner() -> Bool = true
}


// ---- LIMITED HUD ADDONS
public class LHUDAddonsConfig {
  // Allows to scale dialog widget size, by default scale value set to 1.0 so tweak it as you like
  // You may want to try something like 0.9 or 0.8
  public static func DialogResizerScale() -> Float = 1.0
  // Fixes wrong icons for Power and Tech weapons used in info popups
  public static func FixEvolutionIcons() -> Bool = true
  // Hides speedometer widget for TPP camera view
  public static func HideSpeedometer() -> Bool = false
  // Adjusts journal notification widget opacity
  public static func JournalNotificationOpacity() -> Float = 1.0
  // Adjusts journal notification widget scale
  public static func JournalNotificationScale() -> Float = 0.7
  // Adjusts item notification widget opacity
  public static func ItemNotificationOpacity() -> Float = 1.0
  // Disables item notification widget scale
  public static func ItemNotificationScale() -> Float = 0.7
  // Removes current HP and max HP text labels from player healthbar widget
  public static func RemoveHealthbarTexts() -> Bool = false
  // Removes pulse animation for tracked markers
  public static func RemoveMarkerPulse() -> Bool = false
  // Enables simple HUD toggle with F1 hotkey
  public static func EnableHUDToggle() -> Bool = false
  // Hides crouch indicator from HUD
  public static func HideCrouchIndicator() -> Bool = false
  // Enables hostile enemy highlighting only if they have Ping effect
  public static func HighlightUnderPingOnly() -> Bool = false
  // Mutes quest update notifications
  public static func MuteQuestNotifications() -> Bool = false
  // Mutes skill levelup notifications
  public static func MuteLevelUpNotifications() -> Bool = false
  // Hides Get in input prompt for your vehicles
  public static func HidePromptGetIn() -> Bool = false
  // Hides Pick Up Body input prompt for NPC bodies
  public static func HidePromptPickUpBody() -> Bool = false
  // Hides Talk input prompt for NPCs
  public static func HidePromptTalk() -> Bool = false
}

// Objects Coloring config
public class LHUDAddonsColoringConfig {
  public static func FillInteraction() -> Int32 = 2
  public static func FillImportantInteraction() -> Int32 = 5
  public static func FillWeakspot() -> Int32 = 6
  public static func FillQuest() -> Int32 = 1
  public static func FillDistraction() -> Int32 = 3
  public static func FillClue() -> Int32 = 4
  public static func FillNPC() -> Int32 = 0
  public static func FillAOE() -> Int32 = 7
  public static func FillItem() -> Int32 = 5
  public static func FillHostile() -> Int32 = 7
  public static func FillFriendly() -> Int32 = 4
  public static func FillNeutral() -> Int32 = 2
  public static func FillHackable() -> Int32 = 4
  public static func FillEnemyNetrunner() -> Int32 = 6
  public static func FillBackdoor() -> Int32 = 5

  public static func OutlineInteraction() -> Int32 = 3
  public static func OutlineImportantInteraction() -> Int32 = 6
  public static func OutlineWeakspot() -> Int32 = 4
  public static func OutlineQuest() -> Int32 = 5
  public static func OutlineDistraction() -> Int32 = 7
  public static func OutlineClue() -> Int32 = 1
  public static func OutlineAOE() -> Int32 = 2
  public static func OutlineItem() -> Int32 = 6
  public static func OutlineHostile() -> Int32 = 2
  public static func OutlineFriendly() -> Int32 = 1
  public static func OutlineNeutral() -> Int32 = 3
  public static func OutlineHackable() -> Int32 = 1
  public static func OutlineEnemyNetrunner() -> Int32 = 4
  public static func OutlineBackdoor() -> Int32 = 6

  public static func RicochetColor() -> Int32 = 1
}
