module CarDealer.Classes

public class PurchasableVehicle {
  public let record: ref<Vehicle_Record>;
  public let price: Int32;
  public let dealerAtlasPath: ResRef;
  public let dealerPartName: CName;
  public let previewAtlasPath: ResRef;
  public let previewPartName: CName;
}
