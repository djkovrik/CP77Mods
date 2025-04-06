module AtelierDelivery

public class VirtualAtelierDeliveryConfig {
  
  public final static func Debug() -> Bool = false

  @runtimeProperty("ModSettings.mod", "Atelier Delivery")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Standard-Time-Min")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Min-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  let standardDeliveryMin: Int32 = 24;

  @runtimeProperty("ModSettings.mod", "Atelier Delivery")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Standard-Time-Max")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Max-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  let standardDeliveryMax: Int32 = 72;

  @runtimeProperty("ModSettings.mod", "Atelier Delivery")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Standard-Price")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Standard-Price-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  let standardDeliveryPrice: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Atelier Delivery")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Priority-Time-Min")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Min-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  let priorityDeliveryMin: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Atelier Delivery")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Priority-Time-Max")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Time-Max-Desc")
  @runtimeProperty("ModSettings.step", "2")
  @runtimeProperty("ModSettings.min", "2")
  @runtimeProperty("ModSettings.max", "120")
  let priorityDeliveryMax: Int32 = 24;

  @runtimeProperty("ModSettings.mod", "Atelier Delivery")
  @runtimeProperty("ModSettings.category", "Mod-VAD-Delivery-Settings")
  @runtimeProperty("ModSettings.displayName", "Mod-VAD-Delivery-Priority-Price")
  @runtimeProperty("ModSettings.description", "Mod-VAD-Delivery-Priority-Price-Desc")
  @runtimeProperty("ModSettings.step", "25")
  @runtimeProperty("ModSettings.min", "25")
  @runtimeProperty("ModSettings.max", "1000")
  let priorityDeliveryPrice: Int32 = 50;
}
