module ImprovedMinimapMain

// -- Here you can configure minimap zooom values and enable or disable the mod features

public class ZoomConfig {

  // -- BASE MINIMAP CONFIG --

  // -- Default in-game zoom values for reference:
  //    Combat = 40
  //    QuestArea = 25
  //    SecurityArea = 40
  //    Interior = 25
  //    Exterior = 35
  //    Vehicle = 100

  // Zoom value for active combat mode
  public static func Combat() -> Int32 = 60
  
  // Zoom value for quest areas
  public static func QuestArea() -> Int32 = 40
  
  // Zoom value for restricted and dangerous areas
  public static func SecurityArea() -> Int32 = 60
  
  // Zoom value for interiors
  public static func Interior() -> Int32 = 40

  // Zoom value for remained cases:
  // not in interior, not in vehicle, not in security area, no active combat
  public static func Exterior() -> Int32 = 60

  // -- VEHICLE MINIMAP CONFIG --

  // This option enables vehicle minimap dynamic zoom based on speed
  // If set to false then minimap will always use value from MinZoom option
  public static func IsDynamicZoomEnabled() -> Bool = true

  // MinSpeed and MaxSpeed values determine at which speeds dynamic zoom
  // starts and stops, and MinZoom and MaxZoom values define zoom range itself

  // Minimal zoom value
  public static func MinZoom() -> Int32 = 80

  // Maximal zoom value
  public static func MaxZoom() -> Int32 = 140

  // Speed threshold when zoom will start increasing from MinZoom
  public static func MinSpeed() -> Int32 = 20

  // Speed threshold when zoom will reach the value from MaxZoom
  public static func MaxSpeed() -> Int32 = 120

  // -- MINIMAP PEEK HOTKEY CONFIG

  // -- Check included how-to guide and add hotkey definition to the game 
  //    config files if you wan to use it

  // Non-vehicle zoom increment value for peek mode
  public static func Peek() -> Int32 = 40

  // By default hotkey zooms minimap while you hold it and 
  // resets zoom when you release it, replace false with true here
  // if you want to replace hold to zoom behavior with toggle by keypress
  public static func ReplaceHoldWithToggle() -> Bool = false
}
