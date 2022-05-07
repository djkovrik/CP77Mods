module CarDealer.Classes

public class PurchasableVehicleBundle {
  public let cred: Int32;
  public let price: Int32;
  public let variants: array<ref<PurchasableVehicleVariant>>;
}

public class PurchasableVehicleVariant {
  public let record: ref<Vehicle_Record>;
  public let dealerAtlasPath: ResRef;
  public let dealerPartName: CName;
}
