module MutedMarkersConfig

// Visibility types:
//   * MarkerVisibility.ThroughWallsScanner - visible through walls when scanner active
//   * MarkerVisibility.ThroughWalls - visible through walls
//   * MarkerVisibility.LineOfSight - visible when V sees it (very similar to default in-game behavior)
//   * MarkerVisibility.Scanner - visible only when scanner is active 
//   * MarkerVisibility.Hidden - not visible at all

public class LootConfig {
  // Visibility for Iconic items
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Iconic")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Iconic-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let iconic: MarkerVisibility = MarkerVisibility.ThroughWalls;
  
  // Visibility for Legendary items (gold)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Legendary-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let legendary: MarkerVisibility = MarkerVisibility.ThroughWallsScanner;

  // Visibility for Epic items (purple)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Epic")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Epic-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let epic: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Raкe items (blue)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Rare-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let rare: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Uncommon items (green)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Uncommon-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let uncommon: MarkerVisibility = MarkerVisibility.Scanner;

  // Visibility for Common items (white)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Common")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Common-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let common: MarkerVisibility = MarkerVisibility.Scanner;

  // Visibility for Shards
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Shards")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Shards-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let shards: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Ammo
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Types-Con_Ammo")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Ammo-Desc")
  @runtimeProperty("ModSettings.displayValues.Default", "UI-Sorting-Default")
  @runtimeProperty("ModSettings.displayValues.Hidden", "Mod-Markers-Visibility-Hidden")
  @runtimeProperty("ModSettings.displayValues.Scanner", "Mod-Markers-Visibility-Scanner")
  @runtimeProperty("ModSettings.displayValues.LineOfSight", "Mod-Markers-Visibility-LineOfSight")
  @runtimeProperty("ModSettings.displayValues.ThroughWalls", "Mod-Markers-Visibility-ThroughWalls")
  @runtimeProperty("ModSettings.displayValues.ThroughWallsScanner", "Mod-Markers-Visibility-ThroughWallsScanner")
  public let ammo: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Hide delay after scaner disabled
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Delay")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Delay-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "30.0")
  public let hideDelay: Float = 5.0;
}

public class MiniMapConfig {
  // Replace false with true for loot quality markers which you want to hide from minimap

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Legendary-Desc")
  public let hideLegendary: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Epic")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Epic-Desc")
  public let hideEpic: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Rare-Desc")
  public let hideRare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Uncommon-Desc")
  public let hideUncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Common")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Common-Desc")
  public let hideCommon: Bool = false;

  // Replace false with true if you want to hide enemies on minimap
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Enemies")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Enemies-Desc")
  public let hideEnemies: Bool = false;

  // Replace false with true if you want to hide shards on minimap
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Shards")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Shards-Desc")
  public let hideShards: Bool = false;
}


public class WorldConfig {
  // Replace false with true if you want to hide icons for access points
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Access")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Access-Desc")
  public let hideAccessPoints: Bool = false;

  // Replace false with true if you want to hide icons for containers where you can hide bodies
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Body")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Body-Desc")
  public let hideBodyContainers: Bool = false;

  // Replace false with true if you want to hide icons for cameras
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Cameras")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Cameras-Desc")
  public let hideCameras: Bool = false;

  // Replace false with true if you want to hide icons for doors
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Doors")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Doors-Desc")
  public let hideDoors: Bool = false;

  // Replace false with true if you want to hide icons for distraction objects
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Distractions")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Distractions-Desc")
  public let hideDistractions: Bool = false;

  // Replace false with true if you want to hide icons for explosive objects
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Explosives")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Explosives-Desc")
  public let hideExplosives: Bool = false;

  // Replace false with true if you want to hide icons for misc network devices (computers, smart screens etc.)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Networking")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Networking-Desc")
  public let hideNetworking: Bool = false;
}
