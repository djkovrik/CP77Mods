module AtelierDelivery

public class VirtualAtelierDeliveryConfig {
  
  public final static func Debug() -> Bool = false

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "UI-Settings-GenaralInput")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Block-Atelier")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Block-Atelier-Desc")
  public let atelierWatsonLocked: Bool = false;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Standard-Time-Min")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Min-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  public let standardDeliveryMin: Int32 = 24;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Standard-Time-Max")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Max-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  public let standardDeliveryMax: Int32 = 72;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Standard-Price")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Standard-Price-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let standardDeliveryPrice: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Priority-Time-Min")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Min-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  public let priorityDeliveryMin: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Priority-Time-Max")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Max-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  public let priorityDeliveryMax: Int32 = 24;

  @runtimeProperty("ModSettings.mod", "Virtual Atelier")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Priority-Price")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Priority-Price-Desc")
  @runtimeProperty("ModSettings.step", "25")
  @runtimeProperty("ModSettings.min", "25")
  @runtimeProperty("ModSettings.max", "1000")
  public let priorityDeliveryPrice: Int32 = 50;
}
