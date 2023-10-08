module NamedSaves.Config

public class NamedSavesConfig {
  @runtimeProperty("ModSettings.mod", "Named Saves")
  @runtimeProperty("ModSettings.category", "General")
  @runtimeProperty("ModSettings.displayName", "Remember last used name")
  let rememberLastUsed: Bool = true;

  public static func ShouldRememberLastUsed() -> Bool {
    let config: ref<NamedSavesConfig> = new NamedSavesConfig();
    return config.rememberLastUsed;
  }
}
