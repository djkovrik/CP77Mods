module VirtualAtelier.Config

public class VirtualAtelierConfig {
  
  public static func Get() -> ref<VirtualAtelierConfig> {
    let instance: ref<VirtualAtelierConfig> = new VirtualAtelierConfig();
    return instance;
  }

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "VA-Category-Misc")
  @runtimeProperty("ModSettings.displayName", "VA-Duplicate-Checker")
  @runtimeProperty("ModSettings.description", "VA-Duplicate-Checker-Desc")
  let disableDuplicatesChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "VA-Category-Misc")
  @runtimeProperty("ModSettings.displayName", "VA-Danger-Zone-Checker")
  @runtimeProperty("ModSettings.description", "VA-Danger-Zone-Checker-Desc")
  let disableDangerZoneChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "VA-Category-Debug")
  @runtimeProperty("ModSettings.displayName", "VA-Logs")
  @runtimeProperty("ModSettings.description", "VA-Logs-Desc")
  let showDebugLogs: Bool = false;
}
