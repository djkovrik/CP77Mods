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
  public let instantBuy: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Danger-Zone-Checker")
  @runtimeProperty("ModSettings.description", "VA-Danger-Zone-Checker-Desc")
  public let enableDangerZoneChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Duplicate-Checker")
  @runtimeProperty("ModSettings.description", "VA-Duplicate-Checker-Desc")
  public let enableDuplicatesChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Store-Pagination")
  @runtimeProperty("ModSettings.description", "VA-Store-Pagination-Desc")
  public let enableStorePagination: Bool = true;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Store-Page-Size")
  @runtimeProperty("ModSettings.description", "VA-Store-Page-Size-Desc")
  @runtimeProperty("ModSettings.dependency", "enableStorePagination")
  @runtimeProperty("ModSettings.step", "25")
  @runtimeProperty("ModSettings.min", "50")
  @runtimeProperty("ModSettings.max", "500")
  public let paginationPageSize: Int32 = 200;
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
  public let enableDangerZoneChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Duplicate-Checker")
  @runtimeProperty("ModSettings.description", "VA-Duplicate-Checker-Desc")
  public let enableDuplicatesChecker: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Store-Pagination")
  @runtimeProperty("ModSettings.description", "VA-Store-Pagination-Desc")
  public let enableStorePagination: Bool = true;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "VA-Store-Page-Size")
  @runtimeProperty("ModSettings.description", "VA-Store-Page-Size-Desc")
  @runtimeProperty("ModSettings.dependency", "enableStorePagination")
  @runtimeProperty("ModSettings.step", "25")
  @runtimeProperty("ModSettings.min", "50")
  @runtimeProperty("ModSettings.max", "500")
  public let paginationPageSize: Int32 = 200;
}
