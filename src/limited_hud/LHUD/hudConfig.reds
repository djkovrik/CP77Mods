module LimitedHudConfig

// -- Here you can configure widget visibility conditions (true means visible, false means hidden)

// -- Action Buttons module
public class ActionButtonsModuleConfig {
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- Minimap module
public class MinimapModuleConfig {
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true

  // Minimap widget opacity
  // Use value in range from 0.0 to 1.0
  public static func Opacity() -> Float = 0.75
}

// -- Player healthbar module
// -- Default healthbar visibility conditions: HP or memory not full, player has active quickhacks or buffs, combat mode activated
// -- This config enables additional conditions but does not replace the default ones
public class PlayerHealthbarModuleConfig {
  public static func ShowInStealth() -> Bool = false
  public static func ShowWithWeapon() -> Bool = true
  public static func ShowWithZoom() -> Bool = false
}

// -- Quest Tracker module
public class QuestTrackerModuleConfig {
  public static func ShowInCombat() -> Bool = false
  public static func ShowInStealth() -> Bool = false
  public static func ShowInVehicle() -> Bool = true
  public static func ShowWithScanner() -> Bool = false
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}

// -- World Markers module
public class WorldMarkersModuleConfig {
  public static func ShowInCombat() -> Bool = true
  public static func ShowInStealth() -> Bool = true
  public static func ShowInVehicle() -> Bool = false
  public static func ShowWithScanner() -> Bool = true
  public static func ShowWithWeapon() -> Bool = false
  public static func ShowWithZoom() -> Bool = true
}
