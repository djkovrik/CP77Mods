module MutedMarkersConfig

// Visibility types:
//   * MarkerVisibility.ThroughWalls - visible through walls
//   * MarkerVisibility.LineOfSight - visible when V sees it (very similar to default in-game behavior)
//   * MarkerVisibility.Scanner - visible only when scanner is active 
//   * MarkerVisibility.Hidden - not visible at all

public class LootConfig {
  // Visibility for Iconic items
  public static func Iconic() -> MarkerVisibility = MarkerVisibility.ThroughWalls
  // Visibility for Legendary items (gold)
  public static func Legendary() -> MarkerVisibility = MarkerVisibility.ThroughWalls
  // Visibility for Epic items (purple)
  public static func Epic() -> MarkerVisibility = MarkerVisibility.LineOfSight
  // Visibility for Rate items (blue)
  public static func Rare() -> MarkerVisibility = MarkerVisibility.LineOfSight
  // Visibility for Uncommon items (green)
  public static func Uncommon() -> MarkerVisibility = MarkerVisibility.Scanner
  // Visibility for Common items (white)
  public static func Common() -> MarkerVisibility = MarkerVisibility.Scanner
  // Visibility for Shards
  public static func Shards() -> MarkerVisibility = MarkerVisibility.LineOfSight
}

public class WorldConfig {
  // Replace false with true if you want to hide icons for access points
  public static func HideAccessPoints() -> Bool = false
  // Replace false with true if you want to hide icons for containers where you can hide bodies
  public static func HideBodyContainers() -> Bool = false
  // Replace false with true if you want to hide icons for cameras
  public static func HideCameras() -> Bool = false
  // Replace false with true if you want to hide icons for doors
  public static func HideDoors() -> Bool = false
  // Replace false with true if you want to hide icons for distraction objects
  public static func HideDistractions() -> Bool = false
  // Replace false with true if you want to hide icons for explosive objects
  public static func HideExplosives() -> Bool = false
  // Replace false with true if you want to hide icons for misc network devices (computers, smart screens etc.)
  public static func HideNetworking() -> Bool = false
}

public class MiniMapConfig {
  // Replace false with true for loot quality markers which you want to hide from minimap
  public static func HideLegendary() -> Bool = false
  public static func HideEpic() -> Bool = false
  public static func HideRare() -> Bool = false
  public static func HideUncommon() -> Bool = false
  public static func HideCommon() -> Bool = false
  // Replace false with true if you want to hide enemies on minimap
  public static func HideEnemies() -> Bool = false
  // Replace false with true if you want to hide shards on minimap
  public static func HideShards() -> Bool = false
}