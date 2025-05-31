// kept old module name for compat reasons
module VendorPreview.Config

@if(!ModuleExists("AtelierDelivery"))
public class VirtualAtelierConfig {
  
  public static func Get() -> ref<VirtualAtelierConfig> {
    let instance: ref<VirtualAtelierConfig> = new VirtualAtelierConfig();
    return instance;
  }

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Instant-Buy")
  @runtimeProperty("ModSettings.description", "VA-Instant-Buy-Desc")
  let instantBuy: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Danger-Zone-Checker")
  @runtimeProperty("ModSettings.description", "VA-Danger-Zone-Checker-Desc")
  let enableDangerZoneChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Duplicate-Checker")
  @runtimeProperty("ModSettings.description", "VA-Duplicate-Checker-Desc")
  let enableDuplicatesChecker: Bool = false;
}

@if(ModuleExists("AtelierDelivery"))
public class VirtualAtelierConfig {
  
  public static func Get() -> ref<VirtualAtelierConfig> {
    let instance: ref<VirtualAtelierConfig> = new VirtualAtelierConfig();
    return instance;
  }

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Danger-Zone-Checker")
  @runtimeProperty("ModSettings.description", "VA-Danger-Zone-Checker-Desc")
  let enableDangerZoneChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Duplicate-Checker")
  @runtimeProperty("ModSettings.description", "VA-Duplicate-Checker-Desc")
  let enableDuplicatesChecker: Bool = false;
}
