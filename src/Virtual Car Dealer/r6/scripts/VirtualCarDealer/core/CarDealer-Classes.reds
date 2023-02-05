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

public class AutofixerItemData {
  public let title: String;
  public let price: Int32;
  public let atlasResource: ResRef;
  public let textureName: CName;
  public let vehicleID: TweakDBID;
  public let sold: Bool;
}

public class AutofixerSellEvent extends Event {
  public let data: ref<AutofixerItemData>;
}

public class VehiclesListTemplateClassifier extends inkVirtualItemTemplateClassifier {

}
