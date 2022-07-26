module MutedMarkersConfig

// Visibility types:
//   * MarkerVisibility.ThroughWalls - visible through walls
//   * MarkerVisibility.LineOfSight - visible when V sees it (very similar to default in-game behavior)
//   * MarkerVisibility.Scanner - visible only when scanner is active 
//   * MarkerVisibility.Hidden - not visible at all

public class LootConfig {
  // Visibility for Iconic items
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Iconic")
  @runtimeProperty("ModSettings.description", "Visibility for iconic items")
  let iconic: MarkerVisibility = MarkerVisibility.ThroughWalls;
  
  // Visibility for Legendary items (gold)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Legendary")
  @runtimeProperty("ModSettings.description", "Visibility for legendary items")
  let legendary: MarkerVisibility = MarkerVisibility.ThroughWalls;

  // Visibility for Epic items (purple)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Epic")
  @runtimeProperty("ModSettings.description", "Visibility for epic items")
  let epic: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Rate items (blue)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Rare")
  @runtimeProperty("ModSettings.description", "Visibility for rare items")
  let rare: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Uncommon items (green)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Uncommon")
  @runtimeProperty("ModSettings.description", "Visibility for uncommon items")
  let uncommon: MarkerVisibility = MarkerVisibility.Scanner;

  // Visibility for Common items (white)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Common")
  @runtimeProperty("ModSettings.description", "Visibility for common items")
  let common: MarkerVisibility = MarkerVisibility.Scanner;

  // Hide delay after scaner disabled
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Markers hide delay")
  @runtimeProperty("ModSettings.description", "Delay in seconds between scanner disabling and markers hiding")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "30.0")
  let hideDelay: Float = 5.0;

  // Visibility for Shards
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Loot markers")
  @runtimeProperty("ModSettings.displayName", "Shards")
  @runtimeProperty("ModSettings.description", "Visibility for shards")
  let shards: MarkerVisibility = MarkerVisibility.LineOfSight;
}

public class WorldConfig {
  // Replace false with true if you want to hide icons for access points
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide access points")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for access points")
  let hideAccessPoints: Bool = false;

  // Replace false with true if you want to hide icons for containers where you can hide bodies
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide body containers")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for access points")
  let hideBodyContainers: Bool = false;

  // Replace false with true if you want to hide icons for cameras
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide cameras")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for cameras")
  let hideCameras: Bool = false;

  // Replace false with true if you want to hide icons for doors
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide doors")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for doors")
  let hideDoors: Bool = false;

  // Replace false with true if you want to hide icons for distraction objects
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide distractions")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for distraction objects")
  let hideDistractions: Bool = false;

  // Replace false with true if you want to hide icons for explosive objects
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide explosives")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for explosive objects")
  let hideExplosives: Bool = false;

  // Replace false with true if you want to hide icons for misc network devices (computers, smart screens etc.)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "World markers")
  @runtimeProperty("ModSettings.displayName", "Hide networking")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide icons for misc network devices (computers, smart screens etc.)")
  let hideNetworking: Bool = false;
}

public class MiniMapConfig {
  // Replace false with true for loot quality markers which you want to hide from minimap

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide Legendary loot")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide legendary loot markers from minimap")
  let hideLegendary: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide Epic loot")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide epic loot markers from minimap")
  let hideEpic: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide Rare loot")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide rare loot markers from minimap")
  let hideRare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide Uncommon loot")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide uncommon loot markers from minimap")
  let hideUncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide Common loot")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide common loot markers from minimap")
  let hideCommon: Bool = false;

  // Replace false with true if you want to hide enemies on minimap
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide enemies")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide enemy markers from minimap")
  let hideEnemies: Bool = false;

  // Replace false with true if you want to hide shards on minimap
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Minimap markers")
  @runtimeProperty("ModSettings.displayName", "Hide shards")
  @runtimeProperty("ModSettings.description", "Enable if you want to hide shard markers from minimap")
  let hideShards: Bool = false;
}
