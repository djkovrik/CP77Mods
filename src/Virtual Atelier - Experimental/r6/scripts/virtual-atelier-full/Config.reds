module VirtualAtelier.Config

public class VirtualAtelierConfig {
  
  public static func Get() -> ref<VirtualAtelierConfig> {
    let instance: ref<VirtualAtelierConfig> = new VirtualAtelierConfig();
    return instance;
  }

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Misc")
  @runtimeProperty("ModSettings.displayName", "Disable duplicates checker")
  let disableDuplicatesChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Misc")
  @runtimeProperty("ModSettings.displayName", "Disable danger zone checker")
  let disableDangerZoneChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Debug")
  @runtimeProperty("ModSettings.displayName", "Display debug logs for CET console")
  let showDebugLogs: Bool = false;
}
