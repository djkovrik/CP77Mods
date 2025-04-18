module AtelierDelivery

enum AtelierDeliveryType {
  None = 0,
  Standard = 1,
  Priority = 2,
}

enum AtelierDeliveryDropPoint {
  None = 0,
  MegabuildingH10 = 1,
  KabukiMarket = 2,
  MartinSt = 3,
  EisenhowerSt = 4,
  CharterHill = 5,
  CherryBlossomMarket = 6,
  NorthOakSign = 7,
  SarastiAndRepublic = 8,
  CorporationSt = 9,
  MegabuildingH3 = 10,
  CongressMlk = 11,
  CanneryPlaza = 12,
  WollesenSt = 13,
  MegabuildingH7 = 14,
  PacificaStadium = 15,
  WestWindEstate = 16,
  SunsetMotel = 17,
  LongshoreStacks = 18,
}

enum AtelierDeliveryStatus {
  Created = 0,
  Shipped = 1,
  Arrived = 2,
  Delivered = 3,
}

enum HistoryItemType {
  Welcome = 0,
  Shipped = 1,
  Arrived = 2, 
  NewDropPoint = 3,
}

public class AtelierDeliveryPopupParams {
  let store: String;
  let orderId: Int32;
  let price: Int32;
  let weight: Float;
  let quantity: Int32;
  let items: array<ref<WrappedVirtualCartItem>>;
  let enoughForStandard: Bool;
  let enoughForPriority: Bool;
}

public class WrappedVirtualStockItem {
  persistent let id: TweakDBID;
  persistent let price: Float;
  persistent let weight: Float;
  persistent let quality: CName;
  persistent let quantity: Int32;
}

public class WrappedVirtualCartItem {
  persistent let stockItem: ref<WrappedVirtualStockItem>;
  persistent let purchaseAmount: Int32;
}

public class PurchasedAtelierBundle {
  persistent let storeName: CName;
  persistent let orderId: Int32;
  persistent let purchasedItems: array<ref<WrappedVirtualCartItem>>;
  persistent let purchaseTimestamp: Float;
  persistent let shipmentTimestamp: Float;
  persistent let deliveryTimestamp: Float;
  persistent let receivedTimestamp: Float;
  persistent let nextStatusUpdateDiff: Float;
  persistent let totalPrice: Int32;
  persistent let totalWeight: Float;
  persistent let deliveryType: AtelierDeliveryType;
  persistent let deliveryPoint: AtelierDeliveryDropPoint;
  persistent let deliveryStatus: AtelierDeliveryStatus;
  persistent let shipmentNotified: Bool;
  persistent let arrivalNotified: Bool;

  public final static func Create(params: ref<AtelierDeliveryPopupParams>, totalPrice: Int32, deliveryType: AtelierDeliveryType, dropPoint: AtelierDeliveryDropPoint) -> ref<PurchasedAtelierBundle> {
    let instance: ref<PurchasedAtelierBundle> = new PurchasedAtelierBundle();
    instance.storeName = StringToName(params.store);
    instance.orderId = params.orderId;
    instance.purchasedItems = params.items;
    instance.totalPrice = totalPrice;
    instance.totalWeight = params.weight;
    instance.deliveryType = deliveryType;
    instance.deliveryPoint = dropPoint;
    instance.deliveryStatus = AtelierDeliveryStatus.Created;
    instance.shipmentNotified = false;
    instance.arrivalNotified = false;
    return instance;
  }

  public final func GetStoreName() -> CName {
    return this.storeName;
  }

  public final func GetOrderId() -> Int32 {
    return this.orderId;
  }

  public final func GetDeliveryPoint() -> AtelierDeliveryDropPoint {
    return this.deliveryPoint;
  }

  public final func GetDeliveryStatus() -> AtelierDeliveryStatus {
    return this.deliveryStatus;
  }

  public final func SetDeliveryStatus(status: AtelierDeliveryStatus) -> Void {
    this.deliveryStatus = status;
  }

  public final func GetTotalPrice() -> Int32 {
    return this.totalPrice;
  }

  public final func SetPurchaseTimestamp(timestamp: Float) -> Void {
    let estimatedShipment: Float = this.RandomizeEstimatedShipment(this.deliveryType);
    let estimatedDelivery: Float = this.RandomizeEstimatedDelivery(this.deliveryType);
    this.purchaseTimestamp = timestamp;
    this.shipmentTimestamp = timestamp + estimatedShipment;
    this.deliveryTimestamp = timestamp + estimatedShipment + estimatedDelivery;
    this.receivedTimestamp = 0.0;
  }

  public final func GetPurchaseTimestamp() -> Float {
    return this.purchaseTimestamp;
  }

  public final func SetReceivedTimestamp(timestamp: Float) -> Void {
    this.receivedTimestamp = timestamp;
  }

  public final func GetReceivedTimestamp() -> Float {
    return this.receivedTimestamp;
  }

  public final func GetShipmentTimestamp() -> Float {
    return this.shipmentTimestamp;
  }

  public final func GetDeliveryTimestamp() -> Float {
    return this.deliveryTimestamp;
  }

  public final func SetNextStatusUpdateDiff(diff: Float) -> Void {
    this.nextStatusUpdateDiff = diff;
  }

  public final func GetNextStatusUpdateDiff() -> Float {
    return this.nextStatusUpdateDiff;
  }

  public final func IsShipmentNotified() -> Bool {
    return this.shipmentNotified;
  }

  public final func SetShipmentNotified() -> Void {
    this.shipmentNotified = true;
  }

  public final func IsArrivalNotified() -> Bool {
    return this.arrivalNotified;
  }

  public final func SetArrivalNotified() -> Void {
    this.arrivalNotified = true;
  }

  private final func RandomizeEstimatedShipment(type: AtelierDeliveryType) -> Float {
    let secondsPerHour: Float = 3600.0;
    let rangeMin: Float;
    let rangeMax: Float;

    if Equals(type, AtelierDeliveryType.Standard) {
      rangeMin = 4.0 * secondsPerHour;
      rangeMax = 8.0 * secondsPerHour;
    } else {
      rangeMin = 0.5 * secondsPerHour;
      rangeMax = 4.0 * secondsPerHour;
    };

    return RandRangeF(rangeMin, rangeMax);
  }

  private final func RandomizeEstimatedDelivery(type: AtelierDeliveryType) -> Float {
    let cfg: ref<VirtualAtelierDeliveryConfig> = new VirtualAtelierDeliveryConfig();
    let secondsPerHour: Float = 3600.0;
    let rangeMin: Float;
    let rangeMax: Float;

    if Equals(type, AtelierDeliveryType.Standard) {
      rangeMin = Cast<Float>(cfg.standardDeliveryMin) * secondsPerHour;
      rangeMax = Cast<Float>(cfg.standardDeliveryMax) * secondsPerHour;
    } else {
      rangeMin = Cast<Float>(cfg.priorityDeliveryMin) * secondsPerHour;
      rangeMax = Cast<Float>(cfg.priorityDeliveryMax) * secondsPerHour;
    };

    if rangeMin >= rangeMax {
      return RandRangeF(rangeMax, rangeMin + 10.0);
    };

    return RandRangeF(rangeMin, rangeMax);
  }
}

public class AtelierDropPointInstance {
  let locKey: String;
  let parentDistrict: TweakDBID;
  let actualDistrict: TweakDBID;
  let type: AtelierDeliveryDropPoint;
  let position: Vector4; 
  let orientation: Quaternion;
  let iterationTag: CName;
  let uniqueTag: CName;
  let indexTag: CName;
  let inkAtlas: ResRef;

  public final static func Create(
      locKey: String, 
      parentDistrict: TweakDBID,
      actualDistrict: TweakDBID,
      type: AtelierDeliveryDropPoint, 
      uniqueTag: CName, 
      indexTag: CName, 
      iterationTag: CName, 
      position: Vector4, 
      orientation: Quaternion,
      inkAtlas: ResRef
    ) -> ref<AtelierDropPointInstance> {

    let instance: ref<AtelierDropPointInstance> = new AtelierDropPointInstance();

    instance.locKey = locKey;
    instance.parentDistrict = parentDistrict;
    instance.actualDistrict = actualDistrict;
    instance.type = type;
    instance.uniqueTag = uniqueTag;
    instance.indexTag = indexTag;
    instance.iterationTag = iterationTag;
    instance.position = position;
    instance.orientation = orientation;
    instance.inkAtlas = inkAtlas;

    return instance;
  }
}

public class AtelierDropPointsList {
  let points: array<ref<AtelierDropPointInstance>>;

  public final static func Create(points: array<ref<AtelierDropPointInstance>>) -> ref<AtelierDropPointsList> {
    let instance: ref<AtelierDropPointsList> = new AtelierDropPointsList();
    instance.points = points;
    return instance;
  }
}

public class MappinIdWrapper {
  let id: NewMappinID;
  let tag: CName;

  public final static func Create(id: NewMappinID, tag: CName) -> ref<MappinIdWrapper> {
    let instance: ref<MappinIdWrapper> = new MappinIdWrapper();
    instance.id = id;
    instance.tag = tag;
    return instance;
  }
}

public class inkBorderCustom extends inkBorder {}

public class AtelierDestinationSelectedEvent extends Event {
  let data: ref<AtelierDropPointInstance>;

  public final static func Create(data: ref<AtelierDropPointInstance>) -> ref<AtelierDestinationSelectedEvent> {
    let instance: ref<AtelierDestinationSelectedEvent> = new AtelierDestinationSelectedEvent();
    instance.data = data;
    return instance;
  }
}

public class AtelierDeliveryOrderCreatedEvent extends Event {
  let id: Int32;
  let price: Int32;

  public final static func Create(id: Int32, price: Int32) -> ref<AtelierDeliveryOrderCreatedEvent> {
    let instance: ref<AtelierDeliveryOrderCreatedEvent> = new AtelierDeliveryOrderCreatedEvent();
    instance.id = id;
    instance.price = price;
    return instance;
  }
}

public class OrderSoundEvent extends Event {
  let name: CName;

  public final static func Create(name: CName) -> ref<OrderSoundEvent> {
    let evt: ref<OrderSoundEvent> = new OrderSoundEvent();
    evt.name = name;
    return evt;
  }
}

public class OrderTrackRequestedEvent extends Event {
  let order: ref<PurchasedAtelierBundle>;

  public final static func Create(order: ref<PurchasedAtelierBundle>) -> ref<OrderTrackRequestedEvent> {
    let evt: ref<OrderTrackRequestedEvent> = new OrderTrackRequestedEvent();
    evt.order = order;
    return evt;
  } 
}

public class DropPointImageInfo {
  let atlas: ResRef;
  let texturePart: CName;

  public final static func Create(atlas: ResRef, texturePart: CName) -> ref<DropPointImageInfo> {
    let evt: ref<DropPointImageInfo> = new DropPointImageInfo();
    evt.atlas = atlas;
    evt.texturePart = texturePart;
    return evt;
  } 
}

public class DeliveryHistoryItem {
  persistent let uniqueIndex: Int32;
  persistent let type: HistoryItemType;
  persistent let orderId: Int32;
  persistent let store: CName;
  persistent let dropPoint: AtelierDeliveryDropPoint;
  persistent let timestamp: Float;
  persistent let district: TweakDBID;
  
  public final static func Welcome() -> ref<DeliveryHistoryItem> {
    let instance: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Create(HistoryItemType.Welcome, 0, n"", AtelierDeliveryDropPoint.None, 1.1, t"");
    return instance;
  }

  public final static func Shipped(orderId: Int32, store: CName, dropPoint: AtelierDeliveryDropPoint, timestamp: Float) -> ref<DeliveryHistoryItem> {
    let instance: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Create(HistoryItemType.Shipped, orderId, store, dropPoint, timestamp, t"");
    return instance;
  }

  public final static func Arrived(orderId: Int32, store: CName, dropPoint: AtelierDeliveryDropPoint) -> ref<DeliveryHistoryItem> {
    let instance: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Create(HistoryItemType.Arrived, orderId, store, dropPoint, 2.2, t"");
    return instance;
  }

  public final static func NewDropPoint(dropPoint: AtelierDeliveryDropPoint, district: TweakDBID) -> ref<DeliveryHistoryItem> {
    let instance: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Create(HistoryItemType.NewDropPoint, -1, n"", dropPoint, 3.3, district);
    return instance;
  }

  public final static func Create(type: HistoryItemType, orderId: Int32, store: CName, dropPoint: AtelierDeliveryDropPoint, timestamp: Float, district: TweakDBID) -> ref<DeliveryHistoryItem> {
    let instance: ref<DeliveryHistoryItem> = new DeliveryHistoryItem();
    instance.type = type;
    instance.orderId = orderId;
    instance.store = store;
    instance.dropPoint = dropPoint;
    instance.timestamp = timestamp;
    instance.district = district;
    return instance;
  }

  public final static func WrapWithIndex(item: ref<DeliveryHistoryItem>, index: Int32) -> ref<DeliveryHistoryItem> {
    let instance: ref<DeliveryHistoryItem> = item;
    instance.uniqueIndex = index;
    return instance;
  } 

  public final func LocalizedString() -> String {
    switch this.type {
      case HistoryItemType.Welcome: return this.LocalizedStringWelcome();
      case HistoryItemType.Shipped: return this.LocalizedStringShipped();
      case HistoryItemType.Arrived: return this.LocalizedStringArrived();
      case HistoryItemType.NewDropPoint: return this.LocalizedStringNewDropPoint();
    };

    return "";
  }

  private final func LocalizedStringWelcome() -> String {
    return GetLocalizedTextByKey(n"Mod-VAD-Journal-Welcome");
  }

  private final func LocalizedStringShipped() -> String {
    let localized: String = GetLocalizedTextByKey(n"Mod-VAD-Journal-Order-Shipped");
    let withId: String = StrReplace(localized, "{id}", IntToString(this.orderId));
    let withStore: String = StrReplace(withId, "{store}", NameToString(this.store));
    let dropPointName: String = GetLocalizedText(AtelierDeliveryUtils.GetDeliveryPointLocKey(this.dropPoint));
    let withDropPoint: String = StrReplace(withStore, "{drop_point}", dropPointName);
    let timestampPrettified: String = AtelierDeliveryUtils.PrettifyTimestampValue(this.timestamp);
    return StrReplace(withDropPoint, "{time}", timestampPrettified);
  }

  private final func LocalizedStringArrived() -> String {
    let localized: String = GetLocalizedTextByKey(n"Mod-VAD-Journal-Order-Delivered");
    let withId: String = StrReplace(localized, "{id}", IntToString(this.orderId));
    let withStore: String = StrReplace(withId, "{store}", NameToString(this.store));
    let dropPointName: String = GetLocalizedText(AtelierDeliveryUtils.GetDeliveryPointLocKey(this.dropPoint));
    return StrReplace(withStore, "{drop_point}", dropPointName);
  }

  private final func LocalizedStringNewDropPoint() -> String {
    let localized: String = GetLocalizedTextByKey(n"Mod-VAD-Journal-New-Drop-Point");
    let district: ref<District_Record> = TweakDBInterface.GetRecord(this.district) as District_Record;
    let districtName: String = GetLocalizedText(district.LocalizedName());
    let withDistrict: String = StrReplace(localized, "{district}", districtName);
    let dropPointName: String = GetLocalizedText(AtelierDeliveryUtils.GetDeliveryPointLocKey(this.dropPoint));
    return StrReplace(withDistrict, "{drop_point}", dropPointName);
  }
}
