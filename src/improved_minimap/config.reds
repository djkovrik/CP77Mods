module ImprovedMinimapMain

// -- Here you can configure minimap zooom values and
//    enable or disable the mod features

// -- Please keep in mind that values above 150-160 will cause the minimap 
//    flickering, you can try to reduce it with minimap patch from CET

public class ZoomConfig {

  // -- BASE MINIMAP CONFIG --

  // -- Default in-game zoom values for reference:
  //    Vehicle = 80.0
  //    Combat = 40.0
  //    QuestArea = 25.0
  //    SecurityArea = 40.0
  //    Interior = 25.0
  //    Exterior = 35.0

  // Zoom value for active combat mode
  public static func Combat() -> Int32 = 40
  
  // Zoom value for quest areas
  public static func QuestArea() -> Int32 = 35
  
  // Zoom value for restricted and dangerous areas
  public static func SecurityArea() -> Int32 = 40
  
  // Zoom value for interiors
  public static func Interior() -> Int32 = 35

  // Zoom value for remained cases:
  // not in interior, not in vehicle, not in security area, no active combat
  public static func Exterior() -> Int32 = 50

  
  // -- VEHICLE MINIMAP CONFIG --

  // This option enables vehicle minimap dynamic zoom based on speed
  // If set to false then minimap will always use value from MinZoom option
  public static func IsEnabled() -> Bool = true

  // MinSpeed and MaxSpeed values determine at which speeds dynamic zoom
  // starts and stops, and MinZoom and MaxZoom values define zoom range itself

  // Minimal zoom value
  public static func MinZoom() -> Int32 = 80

  // Maximal zoom value
  public static func MaxZoom() -> Int32 = 160

  // Speed threshold when zoom will start increasing from MinZoom
  public static func MinSpeed() -> Int32 = 10

  // Speed threshold when zoom will reach the value from MaxZoom
  public static func MaxSpeed() -> Int32 = 100
}
