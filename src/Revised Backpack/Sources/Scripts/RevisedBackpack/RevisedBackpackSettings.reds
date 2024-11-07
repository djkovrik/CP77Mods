module RevisedBackpack

public class RevisedBackpackSettings {

  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "Mod-Revised-Additional-Options")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Settings-Favorite")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Settings-Favorite-Desc")
  let favoriteOnTop: Bool = true;

  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "Mod-Revised-Additional-Options")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Settings-New")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Settings-New-Desc")
  let newOnTop: Bool = false;
}
