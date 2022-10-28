module EnhancedCraft.Config
import EnhancedCraft.Common.*

public class ECraftConfig {

  public static func Get() -> ref<ECraftConfig> {
    let self: ref<ECraftConfig> = new ECraftConfig();
    return self;
  }

  // Enables weapon damage type selection
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-UI-Damage-Type")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-UI-Damage-Type-Enable")
  @runtimeProperty("ModSettings.description", "Mod-Craft-UI-Damage-Type-Enable-Desc")
  let customizedDamageEnabled: Bool = true;

  // Required perk to unlock weapon damage type selection
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-UI-Damage-Type")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-UI-Damage-Perk")
  @runtimeProperty("ModSettings.description", "Mod-Craft-UI-Damage-Perk-Desc")
  let perkToUnlockDamageTypes: ECraftPerkToUnlockDamageTypes = ECraftPerkToUnlockDamageTypes.TrueCraftsman;

  // Required perk to unlock standard weapon variants
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Base")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Basic")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Basic-Desc")
  let perkToUnlockStandard: ECraftPerkToUnlockStandard = ECraftPerkToUnlockStandard.GreaseMonkey;

  // Required perk to unlock iconic weapon variants
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Iconic")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Iconic-Unlock")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Iconic-Unlock-Desc")
  let perkToUnlockIconics: ECraftPerkToUnlockIconics = ECraftPerkToUnlockIconics.EdgerunnerArtisan;

  // Quality requirement for iconic variants craft
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Iconic")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Iconic-Condition")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Iconic-Condition-Desc")
  let iconicRecipeCondition: ECraftIconicRecipeCondition = ECraftIconicRecipeCondition.Epic;

  // Ingredients quantity multiplier for Iconic variants
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Iconic")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Iconic-Ingredients")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Iconic-Ingredients-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "25")
  let iconicIngredientsMultiplier: Int32 = 5;

  // Required perk to unlock clothes variants
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Clothes")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-UI-Damage-Perk")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Clothes-Unlock-Desc")
  let perkToUnlockClothes: ECraftPerkToUnlockClothes = ECraftPerkToUnlockClothes.TrueCraftsman;

  // If enabled then adds jacket variants from DLC
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Clothes")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Jackets")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Jackets-Desc")
  let includeJacketsFromDLC: Bool = false;

  // If enabled then random weapon skin will be applied for crafted item
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Misc")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Randomizer")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Randomizer-Desc")
  let randomizerEnabled: Bool = false;

  // If enabled then you can rename your crafted weapons and clothes
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Misc")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Naming")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Naming-Desc")
  let customNamesEnabled: Bool = true;

  // Enables controller support
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Misc")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-UI-Controller")
  @runtimeProperty("ModSettings.description", "Mod-Craft-UI-Controller-Desc")
  let controllerSupportEnabled: Bool = false;
}

public class HotkeyActions {
  // Get Prev button action name (IK_A + IK_Pad_X_SQUARE)
  public static func EnhancedCraftPrevAction(config: ref<ECraftConfig>) -> CName {
    if config.controllerSupportEnabled {
      return n"transfer_save";
    } else {
      return n"option_switch_prev";
    };
  }

  // Get Next button action name (IK_D + IK_Pad_Y_TRIANGLE)
  public static func EnhancedCraftNextAction(config: ref<ECraftConfig>) -> CName {
    if config.controllerSupportEnabled {
      return n"delete_save";
    } else {
      return n"option_switch_next";
    };
  }
}
