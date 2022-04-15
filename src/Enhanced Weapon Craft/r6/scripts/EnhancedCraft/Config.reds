module EnhancedCraft.Config

public class Config {
  // If enabled then you can rename your crafted weapons
  public static func CustomNamesEnabled() -> Bool = false
  // If enabled then random weapon skin will be applied for crafted item
  public static func RandomizerEnabled() -> Bool = false
  // Required perk to unlock standard weapon variants
  public static func PerkToUnlockStandard() -> Int32 = 3
  // Required perk to unlock iconic weapon variants
  public static func PerkToUnlockIconics() -> Int32 = 4
}

// TODO:
// - x10 ingredients for iconics
// - weapon renaming

/*
  Required perks:
  1: None
  2: True Craftsman (Rare items craft)
  3: Grease Monkey (Epic items craft)
  4: Edgerunner Artisan (Legendary items craft)
*/
