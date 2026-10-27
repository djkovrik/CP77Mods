module NamedSaves.Config

public class NamedSavesConfig {
  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.displayName", "NamedSaves-Last-Used")
  @runtimeProperty("ModSettings.description", "NamedSaves-Last-Used-Desc")
  public let rememberLastUsed: Bool = false;

  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.displayName", "NamedSaves-Search-Across")
  @runtimeProperty("ModSettings.description", "NamedSaves-Search-Across-Desc")
  public let searchAllCategories: Bool = false;

  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.displayName", "NamedSaves-Hide-Category")
  @runtimeProperty("ModSettings.description", "NamedSaves-Hide-Category-Desc")
  @runtimeProperty("ModSettings.dependency", "searchAllCategories")
  public let hideCategoryHeaders: Bool = false;

  public static func ShouldRememberLastUsed() -> Bool {
    let config: ref<NamedSavesConfig> = new NamedSavesConfig();
    return config.rememberLastUsed;
  }
}
