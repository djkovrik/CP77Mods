module RevisedBackpack

public class RevisedBackpackSettings {

  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "Mod-Revised-Additional-Options")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Settings-Favorite")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Settings-Favorite-Desc")
  public let favoriteOnTop: Bool = true;

  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "Mod-Revised-Additional-Options")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Settings-New")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Settings-New-Desc")
  public let newOnTop: Bool = false;

  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "UI-Settings-Audio-Misc-MiscSectionTitle")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Replace-Button")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Replace-Button-Desc")
  public let replaceInventoryButton: Bool = false;
}
