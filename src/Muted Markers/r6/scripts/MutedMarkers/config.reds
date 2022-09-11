module MutedMarkersConfig

// Visibility types:
//   * MarkerVisibility.ThroughWalls - visible through walls
//   * MarkerVisibility.LineOfSight - visible when V sees it (very similar to default in-game behavior)
//   * MarkerVisibility.Scanner - visible only when scanner is active 
//   * MarkerVisibility.Hidden - not visible at all

public class LootConfig {
  // Visibility for Iconic items
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Iconic")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Iconic-Desc")
  let iconic: MarkerVisibility = MarkerVisibility.ThroughWalls;
  
  // Visibility for Legendary items (gold)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Legendary-Desc")
  let legendary: MarkerVisibility = MarkerVisibility.ThroughWalls;

  // Visibility for Epic items (purple)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Epic")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Epic-Desc")
  let epic: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Rate items (blue)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Rare-Desc")
  let rare: MarkerVisibility = MarkerVisibility.LineOfSight;

  // Visibility for Uncommon items (green)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Uncommon-Desc")
  let uncommon: MarkerVisibility = MarkerVisibility.Scanner;

  // Visibility for Common items (white)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Common")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Common-Desc")
  let common: MarkerVisibility = MarkerVisibility.Scanner;

  // Hide delay after scaner disabled
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Delay")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Delay-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "30.0")
  let hideDelay: Float = 5.0;

  // Visibility for Shards
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Loot-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Shards")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Shards-Desc")
  let shards: MarkerVisibility = MarkerVisibility.LineOfSight;
}

public class MiniMapConfig {
  // Replace false with true for loot quality markers which you want to hide from minimap

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Legendary-Desc")
  let hideLegendary: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Epic")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Epic-Desc")
  let hideEpic: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Rare-Desc")
  let hideRare: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Uncommon-Desc")
  let hideUncommon: Bool = false;

  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Loot-Common")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Loot-Common-Desc")
  let hideCommon: Bool = false;

  // Replace false with true if you want to hide enemies on minimap
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Enemies")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Enemies-Desc")
  let hideEnemies: Bool = false;

  // Replace false with true if you want to hide shards on minimap
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-Minimap-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-Hide-Shards")
  @runtimeProperty("ModSettings.description", "Mod-Markers-Hide-Shards-Desc")
  let hideShards: Bool = false;
}


public class WorldConfig {
  // Replace false with true if you want to hide icons for access points
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Access")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Access-Desc")
  let hideAccessPoints: Bool = false;

  // Replace false with true if you want to hide icons for containers where you can hide bodies
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Body")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Body-Desc")
  let hideBodyContainers: Bool = false;

  // Replace false with true if you want to hide icons for cameras
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Cameras")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Cameras-Desc")
  let hideCameras: Bool = false;

  // Replace false with true if you want to hide icons for doors
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Doors")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Doors-Desc")
  let hideDoors: Bool = false;

  // Replace false with true if you want to hide icons for distraction objects
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Distractions")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Distractions-Desc")
  let hideDistractions: Bool = false;

  // Replace false with true if you want to hide icons for explosive objects
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Explosives")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Explosives-Desc")
  let hideExplosives: Bool = false;

  // Replace false with true if you want to hide icons for misc network devices (computers, smart screens etc.)
  @runtimeProperty("ModSettings.mod", "Muted Markers")
  @runtimeProperty("ModSettings.category", "Mod-Markers-World-Markers")
  @runtimeProperty("ModSettings.displayName", "Mod-Markers-World-Networking")
  @runtimeProperty("ModSettings.description", "Mod-Markers-World-Networking-Desc")
  let hideNetworking: Bool = false;
}
