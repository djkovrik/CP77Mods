module EnhancedCraft.Config

/*
  PerkToUnlockStandard:
    1: No perk required
    2: True Craftsman (Rare items craft)
    3: Grease Monkey (Epic items craft)
    4: Edgerunner Artisan (Legendary items craft)

  PerkToUnlockIconics:
    1: No perk required
    2: Disable Iconics
    3: True Craftsman (Rare items craft)
    4: Grease Monkey (Epic items craft)
    5: Edgerunner Artisan (Legendary items craft)

  PerkToUnlockDamageTypes:
    1: No perk required
    2: True Craftsman (Rare items craft)
    3: Grease Monkey (Epic items craft)
    4: Edgerunner Artisan (Legendary items craft)

  IconicRecipeCondition:
    1: Rare
    2: Epic
    3: Legendary
*/

// Controlled by Native Settings UI
public class Config {
  // If enabled then you can rename your crafted weapons
  public static func CustomNamesEnabled() -> Bool = false
  // If enabled then random weapon skin will be applied for crafted item
  public static func RandomizerEnabled() -> Bool = false
  // Required perk to unlock standard weapon variants
  public static func PerkToUnlockStandard() -> Int32 = 3
  // Required perk to unlock iconic weapon variants
  public static func PerkToUnlockIconics() -> Int32 = 5
  // Ingredients quantity multiplier for Iconic variants
  public static func IconicRecipeCondition() -> Int32 = 2
  // Ingredients quantity multiplier for Iconic variants
  public static func IconicIngredientsMultiplier() -> Int32 = 5
  // Enables controller support
  public static func ControllerSupportEnabled() -> Bool = false
  // Enables weapon damage type selection
  public static func CustomizedDamageEnabled() -> Bool = true
  // Required perk to unlock weapon damage type selection
  public static func PerkToUnlockDamageTypes() -> Int32 = 2
}

public class HotkeyActions {
  // Get Prev button action name (IK_A + IK_Pad_X_SQUARE)
  public static func EnhancedCraftPrevAction() -> CName {
    if Config.ControllerSupportEnabled() {
      return n"transfer_save";
    } else {
      return n"option_switch_prev";
    };
  }

  // Get Next button action name (IK_D + IK_Pad_Y_TRIANGLE)
  public static func EnhancedCraftNextAction() -> CName {
    if Config.ControllerSupportEnabled() {
      return n"delete_save";
    } else {
      return n"option_switch_next";
    };
  }
}
