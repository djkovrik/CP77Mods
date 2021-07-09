module ReducedLootMain

import ReducedLootUtils.RL_Converters
import ReducedLootTypes.*

// -- Reduced Loot - Main config file
//    Here you can edit loot removal probability for all categories
//    Values defined in percents where 0 equals always remove and 100 equals always drop

//    WHILE YOU EDIT THE VALUES BELOW PLEASE PAY ATTENTION TO COMMAS, YOU SHOULD NOT DELETE IT

// -- Reduced Loot Config version 1.0
public class Config {

  // -- Probability settings for weapons drop per quality and loot source
  public static func Weapon(source: RL_LootSource, quality: RL_LootQuality) -> Int32 {
    //    Quality ->  Common    Uncommon    Rare    Epic    Legendary  \  Source:
    let cont =     [    0,         25,       50,     75,       100  ]; // <- Containers
    let wrld =     [    0,         25,       50,     75,       100  ]; // <- World placed loot
    let invt =     [    0,         25,       50,     75,       100  ]; // <- NPCs inventory
    let held =     [    0,         25,       50,     75,       100  ]; // <- NPCs held weapons

    switch source {
      case RL_LootSource.Container: return cont[RL_Converters.QualityToInt(quality)];
      case RL_LootSource.World: return wrld[RL_Converters.QualityToInt(quality)];
      case RL_LootSource.Puppet: return invt[RL_Converters.QualityToInt(quality)];
      case RL_LootSource.Held: return held[RL_Converters.QualityToInt(quality)];
      default: return 0;
    }
  }

  // -- Probability settings for clothes drop per quality and loot source
  public static func Clothes(source: RL_LootSource, quality: RL_LootQuality) -> Int32 {
    //    Quality ->  Common    Uncommon    Rare    Epic    Legendary  \  Source:
    let cont =     [    0,         25,       50,     75,       100  ]; // <- Containers
    let wrld =     [    0,         25,       50,     75,       100  ]; // <- World placed loot
    let invt =     [    0,         25,       50,     75,       100  ]; // <- NPCs inventory

    if Equals(RL_LootSource.Held, source) { return 0; }
    switch source {
      case RL_LootSource.Container: return cont[RL_Converters.QualityToInt(quality)];
      case RL_LootSource.World: return wrld[RL_Converters.QualityToInt(quality)];
      case RL_LootSource.Puppet: return invt[RL_Converters.QualityToInt(quality)];
      default: return 0;
    }
  }

  // -- Probability settings for remained loot categories based on drop source per loot category
  public static func Misc(source: RL_LootSource, type: RL_LootType) -> Int32 {
    //    Source ->   Containers    World placed    NPCs inventory   \  Type:
    let ammo =    [       25,           25,              25       ]; // <- Ammo
    let craf =    [       50,           50,              50       ]; // <- Crafting materials
    let cybr =    [       50,           50,              50       ]; // <- Cyberware
    let edib =    [       50,           50,              50       ]; // <- Edibles
    let grnd =    [       25,           25,              25       ]; // <- Grenades
    let heal =    [       25,           25,              25       ]; // <- Healings
    let junk =    [       50,           50,              50       ]; // <- Junk
    let mods =    [       50,           50,              50       ]; // <- Mods
    let moni =    [       25,           25,              25       ]; // <- Money
    let hack =    [       50,           50,              50       ]; // <- Quickhacks
    let schm =    [       100,          100,             100      ]; // <- Schematics
    let shrd =    [       100,          100,             100      ]; // <- Shards
    let skll =    [       100,          100,             100      ]; // <- Skillbooks

    if Equals(RL_LootSource.Held, source) { return 0; }
    switch type {
      case RL_LootType.Ammo: return ammo[RL_Converters.SourceToInt(source)];
      case RL_LootType.CraftingMaterials: return craf[RL_Converters.SourceToInt(source)];
      case RL_LootType.Cyberware: return cybr[RL_Converters.SourceToInt(source)];
      case RL_LootType.Edibles: return edib[RL_Converters.SourceToInt(source)];
      case RL_LootType.Grenades: return grnd[RL_Converters.SourceToInt(source)];
      case RL_LootType.Healings: return heal[RL_Converters.SourceToInt(source)];
      case RL_LootType.Junk: return heal[RL_Converters.SourceToInt(source)];
      case RL_LootType.Mods: return mods[RL_Converters.SourceToInt(source)];
      case RL_LootType.Money: return moni[RL_Converters.SourceToInt(source)];
      case RL_LootType.Quickhacks: return hack[RL_Converters.SourceToInt(source)];
      case RL_LootType.Schematics: return schm[RL_Converters.SourceToInt(source)];
      case RL_LootType.Shards: return shrd[RL_Converters.SourceToInt(source)];
      case RL_LootType.SkillBooks: return skll[RL_Converters.SourceToInt(source)];
      default: return 0;
    };
  }
}
