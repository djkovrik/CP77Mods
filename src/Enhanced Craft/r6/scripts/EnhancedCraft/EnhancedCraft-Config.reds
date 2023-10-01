module EnhancedCraft.Config
import EnhancedCraft.Common.*

public class ECraftConfig {

  public static func Get() -> ref<ECraftConfig> {
    let self: ref<ECraftConfig> = new ECraftConfig();
    return self;
  }

  // Quality requirement for iconic variants craft
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Iconic")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Iconic-Condition")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Iconic-Condition-Desc")
  @runtimeProperty("ModSettings.displayValues.Rare", "Mod-Craft-Settings-Quality-Rare")
  @runtimeProperty("ModSettings.displayValues.Epic", "Mod-Craft-Settings-Quality-Epic")
  @runtimeProperty("ModSettings.displayValues.Legendary", "Mod-Craft-Settings-Quality-Legendary")
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

  // If enabled then random weapon skin will be applied for crafted item
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Misc")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Randomizer")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Randomizer-Desc")
  let randomizerEnabled: Bool = false;

  // If enabled then you can rename your crafted weapons
  @runtimeProperty("ModSettings.mod", "ECraft")
  @runtimeProperty("ModSettings.category", "Mod-Craft-Settings-Misc")
  @runtimeProperty("ModSettings.displayName", "Mod-Craft-Settings-Naming")
  @runtimeProperty("ModSettings.description", "Mod-Craft-Settings-Naming-Desc")
  let customNamesEnabled: Bool = true;
}
