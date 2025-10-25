// VirtualAtelierDelivery v1.0.9
module AtelierDelivery

import Codeware.UI.*
@if(ModuleExists("NumeralsGetCommas.Functions"))
import NumeralsGetCommas.Functions.*
@if(ModuleExists("VirtualAtelier.Compat"))
import VirtualAtelier.Compat.VersionManager
@if(ModuleExists("VirtualAtelier.Helpers"))
import VirtualAtelier.Helpers.AtelierItemsHelper

public enum AtelierDeliveryType {
  None = 0,
  Standard = 1,
  Priority = 2,
}
public enum AtelierDeliveryDropPoint {
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
  LittleChina = 19,
}
public enum AtelierDeliveryStatus {
  Created = 0,
  Shipped = 1,
  Arrived = 2,
  Delivered = 3,
}
public enum HistoryItemType {
  Welcome = 0,
  Shipped = 1,
  Arrived = 2, 
  NewDropPoint = 3,
}
public class AtelierDeliveryPopupParams {
  public let store: String;
  public let orderId: Int32;
  public let price: Int32;
  public let weight: Float;
  public let quantity: Int32;
  public let items: array<ref<WrappedVirtualCartItem>>;
  public let enoughForStandard: Bool;
  public let enoughForPriority: Bool;
}
public class WrappedVirtualStockItem {
  public persistent let id: TweakDBID;
  public persistent let price: Float;
  public persistent let weight: Float;
  public persistent let quality: CName;
  public persistent let quantity: Int32;
}
public class WrappedVirtualCartItem {
  public persistent let stockItem: ref<WrappedVirtualStockItem>;
  public persistent let purchaseAmount: Int32;
}
public class PurchasedAtelierBundle {
  public persistent let storeName: CName;
  public persistent let orderId: Int32;
  public persistent let purchasedItems: array<ref<WrappedVirtualCartItem>>;
  public persistent let purchaseTimestamp: Float;
  public persistent let shipmentTimestamp: Float;
  public persistent let deliveryTimestamp: Float;
  public persistent let receivedTimestamp: Float;
  public persistent let nextStatusUpdateDiff: Float;
  public persistent let totalPrice: Int32;
  public persistent let totalWeight: Float;
  public persistent let deliveryType: AtelierDeliveryType;
  public persistent let deliveryPoint: AtelierDeliveryDropPoint;
  public persistent let deliveryStatus: AtelierDeliveryStatus;
  public persistent let shipmentNotified: Bool;
  public persistent let arrivalNotified: Bool;
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
  public let locKey: String;
  public let parentDistrict: TweakDBID;
  public let actualDistrict: TweakDBID;
  public let type: AtelierDeliveryDropPoint;
  public let position: Vector4; 
  public let orientation: Quaternion;
  public let iterationTag: CName;
  public let uniqueTag: CName;
  public let indexTag: CName;
  public let inkAtlas: ResRef;
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
  public let points: array<ref<AtelierDropPointInstance>>;
  public final static func Create(points: array<ref<AtelierDropPointInstance>>) -> ref<AtelierDropPointsList> {
    let instance: ref<AtelierDropPointsList> = new AtelierDropPointsList();
    instance.points = points;
    return instance;
  }
}
public class MappinIdWrapper {
  public let id: NewMappinID;
  public let tag: CName;
  public final static func Create(id: NewMappinID, tag: CName) -> ref<MappinIdWrapper> {
    let instance: ref<MappinIdWrapper> = new MappinIdWrapper();
    instance.id = id;
    instance.tag = tag;
    return instance;
  }
}
public class inkBorderCustom extends inkBorder {}
public class AtelierDestinationSelectedEvent extends Event {
  public let data: ref<AtelierDropPointInstance>;
  public final static func Create(data: ref<AtelierDropPointInstance>) -> ref<AtelierDestinationSelectedEvent> {
    let instance: ref<AtelierDestinationSelectedEvent> = new AtelierDestinationSelectedEvent();
    instance.data = data;
    return instance;
  }
}
public class AtelierDeliveryOrderCreatedEvent extends Event {
  public let id: Int32;
  public let price: Int32;
  public final static func Create(id: Int32, price: Int32) -> ref<AtelierDeliveryOrderCreatedEvent> {
    let instance: ref<AtelierDeliveryOrderCreatedEvent> = new AtelierDeliveryOrderCreatedEvent();
    instance.id = id;
    instance.price = price;
    return instance;
  }
}
public class OrderSoundEvent extends Event {
  public let name: CName;
  public final static func Create(name: CName) -> ref<OrderSoundEvent> {
    let evt: ref<OrderSoundEvent> = new OrderSoundEvent();
    evt.name = name;
    return evt;
  }
}
public class OrderTrackRequestedEvent extends Event {
  public let order: ref<PurchasedAtelierBundle>;
  public final static func Create(order: ref<PurchasedAtelierBundle>) -> ref<OrderTrackRequestedEvent> {
    let evt: ref<OrderTrackRequestedEvent> = new OrderTrackRequestedEvent();
    evt.order = order;
    return evt;
  } 
}
public class DropPointImageInfo {
  public let atlas: ResRef;
  public let texturePart: CName;
  public final static func Create(atlas: ResRef, texturePart: CName) -> ref<DropPointImageInfo> {
    let evt: ref<DropPointImageInfo> = new DropPointImageInfo();
    evt.atlas = atlas;
    evt.texturePart = texturePart;
    return evt;
  } 
}
public class DeliveryHistoryItem {
  public persistent let uniqueIndex: Int32;
  public persistent let type: HistoryItemType;
  public persistent let orderId: Int32;
  public persistent let store: CName;
  public persistent let dropPoint: AtelierDeliveryDropPoint;
  public persistent let timestamp: Float;
  public persistent let district: TweakDBID;
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
public abstract class CompatManager {
  public final static func RequiredAtelierVersionCode() -> Int32 = 1407
  public final static func RequiredAtelierVersionName() -> String = "1.4.7"
}
@if(ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionCode() -> Int32 {
  return VersionManager.VersionCode();
}
@if(!ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionCode() -> Int32 {
  return 0;
}
@if(ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionName() -> String {
  return VersionManager.VersionName();
}
@if(!ModuleExists("VirtualAtelier.Compat"))
@addMethod(SingleplayerMenuGameController)
private final func GetCurrentAtelierVersionName() -> String {
  return "<= 1.2.10";
}
@if(ModuleExists("VendorPreview.Config"))
@addMethod(SingleplayerMenuGameController)
private final func IsAtelierMissing() -> Bool {
  return false;
}
@if(!ModuleExists("VendorPreview.Config"))
@addMethod(SingleplayerMenuGameController)
private final func IsAtelierMissing() -> Bool {
  return true;
}
@addField(SingleplayerMenuGameController)
protected let atelierDetectionPopup: ref<inkGameNotificationToken>;
@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let message: String = "";
  let hasNoAtelierInstalled: Bool = this.IsAtelierMissing();
  let hasIncompatibleAtelierVersion: Bool = this.GetCurrentAtelierVersionCode() < CompatManager.RequiredAtelierVersionCode();
  if hasNoAtelierInstalled {
    message = GetLocalizedTextByKey(n"Mod-VAD-Error-No-VA");
  } else if hasIncompatibleAtelierVersion {
    message = s"\(GetLocalizedTextByKey(n"Mod-VAD-Error-VA-Required")) \(CompatManager.RequiredAtelierVersionName())+.\n" + 
      s"\(GetLocalizedTextByKey(n"Mod-VAD-Error-VA-Current")): \(this.GetCurrentAtelierVersionName())";
  };
  if hasNoAtelierInstalled || hasIncompatibleAtelierVersion {
    this.atelierDetectionPopup = GenericMessageNotification.Show(
      this, 
      GetLocalizedText("LocKey#11447"), 
      message,
      GenericMessageNotificationType.OK
    );
    this.atelierDetectionPopup.RegisterListener(this, n"OnAtelierDetectionPopupClosed");
  };
}
@addMethod(SingleplayerMenuGameController)
protected cb func OnAtelierDetectionPopupClosed(data: ref<inkGameNotificationData>) {
  this.atelierDetectionPopup = null;
}
@if(!ModuleExists("NumeralsGetCommas.Functions"))
public func GetFormattedMoneyVAD(money: Int32) -> String {
  return IntToString(money);
}
@if(ModuleExists("NumeralsGetCommas.Functions"))
public func GetFormattedMoneyVAD(money: Int32) -> String {
  return CommaDelineateInt32(money);
}
public class VirtualAtelierDeliveryConfig {
  public final static func Debug() -> Bool = false;
  // kept for backward compatibility
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
public class AtelierDeliveryDebugHotkey {
  private let player: wref<PlayerPuppet>;
  private let timeSystem: wref<TimeSystem>;
  private let messengerSystem: wref<DeliveryMessengerSystem>;
  public func SetPlayer(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.timeSystem = GameInstance.GetTimeSystem(this.player.GetGame());
    this.messengerSystem = DeliveryMessengerSystem.Get(this.player.GetGame());
  }
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsAction(action, n"restore_default_settings") && ListenerAction.IsButtonJustReleased(action) {
      // this.DumpCurrentPlayerPosition();
      // this.ShowRandomSmsMessage();
    }
  }
  private final func DumpCurrentPlayerPosition() -> Void {
    let position: Vector4 = this.player.GetWorldPosition();
    let orientation: Quaternion = this.player.GetWorldOrientation();
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(this.player.GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let district: ref<District> = ps.GetCurrentDistrict();
    let districtRecord: ref<District_Record> = district.GetDistrictRecord();
    let parentDistrictRecord: ref<District_Record> = districtRecord.ParentDistrict();
    ModLog(n"Delivery", s"Position: \(position)");
    ModLog(n"Delivery", s"Orientation: \(orientation)");
    ModLog(n"Delivery", s"\(TDBID.ToStringDEBUG(parentDistrictRecord.GetID())), \(TDBID.ToStringDEBUG(districtRecord.GetID()))");
  }
  private final func ShowRandomSmsMessage() -> Void {
    let item: ref<DeliveryHistoryItem> = this.CreateRandomMessage();
    this.messengerSystem.PushNewNotificationItem(item);
  }
  private func CreateRandomMessage() -> ref<DeliveryHistoryItem> {
    let testStore: CName = n"Testing store";
    let randType: Int32 = RandRange(0, 3);
    let randomId: Int32 = RandRange(1000, 9999);
    let randomTimestamp: Float = RandRangeF(36000.0, 96000.0);
    let randomDropPointInt: Int32 = RandRange(1, 18);
    let randomDropPoint: AtelierDeliveryDropPoint = IntEnum<AtelierDeliveryDropPoint>(randomDropPointInt);
    let districts: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"District");
    let districtsSize: Int32 = ArraySize(districts);
    let randomDistrictInt: Int32 = RandRange(0, districtsSize - 1);
    let randomDistrict: TweakDBID = districts[randomDistrictInt].GetID();
    if Equals(randType, 0) {
      return DeliveryHistoryItem.Shipped(randomId, testStore, randomDropPoint, randomTimestamp);
    } else if Equals(randType, 1) {
      return DeliveryHistoryItem.Arrived(randomId, testStore, randomDropPoint);
    };
    return DeliveryHistoryItem.NewDropPoint(randomDropPoint, randomDistrict);
  }
}
@addField(PlayerPuppet)
private let atelierDeliveryDebugHotkey: ref<AtelierDeliveryDebugHotkey>;
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  if VirtualAtelierDeliveryConfig.Debug() {
    this.atelierDeliveryDebugHotkey = new AtelierDeliveryDebugHotkey();
    this.atelierDeliveryDebugHotkey.SetPlayer(this);
    this.RegisterInputListener(this.atelierDeliveryDebugHotkey);
  };
}
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  wrappedMethod();
  if VirtualAtelierDeliveryConfig.Debug() {
    this.UnregisterInputListener(this.atelierDeliveryDebugHotkey);
    this.atelierDeliveryDebugHotkey = null;
  };
}
// Timeskip menu
@wrapMethod(TimeskipGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  OrderTrackingTicker.Get(this.m_player.GetGame()).CancelScheduledCallback();
}
@wrapMethod(TimeskipGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  OrderTrackingTicker.Get(this.m_player.GetGame()).ScheduleCallbackShortened();
}
// Braindance
@wrapMethod(HUDManager)
protected cb func OnBraindanceToggle(value: Bool) -> Bool {
  wrappedMethod(value);
  if this.m_isBraindanceActive {
    OrderTrackingTicker.Get(this.GetGameInstance()).CancelScheduledCallback();
  } else {
    OrderTrackingTicker.Get(this.GetGameInstance()).ScheduleCallbackNormal();
  };
}
// Johnny
@wrapMethod(PlayerSystem)
protected final cb func OnLocalPlayerPossesionChanged(playerPossesion: gamedataPlayerPossesion) -> Bool {
  if Equals(playerPossesion, gamedataPlayerPossesion.Johnny) {
    OrderTrackingTicker.Get(this.GetGameInstance()).CancelScheduledCallback();
  } else {
    OrderTrackingTicker.Get(this.GetGameInstance()).ScheduleCallbackNormal();
  };
  return wrappedMethod(playerPossesion);
}
public class AtelierDropPointsSpawner extends ScriptableSystem {
  private let entitySystem: wref<DynamicEntitySystem>;
  private let delaySystem: wref<DelaySystem>;
  private let handled: Bool;
  private let spawnConfig: ref<AtelierDropPointsSpawnerConfig>;
  private let initialCallbackId: DelayID;
  private let dropPointsCallbackId: DelayID;
  private let nightCityUnlocked: Bool = false;
  private let dogtownUnlocked: Bool = false;
  private let typeTag: CName = n"VirtualAtelierDropPoint";
  private let spawnedMappins: ref<inkHashMap>;
  public static func Get(gi: GameInstance) -> ref<AtelierDropPointsSpawner> {
    let system: ref<AtelierDropPointsSpawner> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.AtelierDropPointsSpawner") as AtelierDropPointsSpawner;
    return system;
  }
  private func OnAttach() -> Void {
    this.entitySystem = GameInstance.GetDynamicEntitySystem();
    this.delaySystem = GameInstance.GetDelaySystem(this.GetGameInstance());
    this.handled = false;
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };
    this.spawnedMappins = new inkHashMap();
    this.spawnConfig = new AtelierDropPointsSpawnerConfig();
    this.spawnConfig.Init();
    this.spawnConfig.BuildPrologueList();
    this.spawnConfig.BuildNightCityList();
    this.spawnConfig.BuildDogtownList();
  }
  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.Log("OnRestored");
    if !this.handled {
      this.HandleSpawning();
    };
  }
  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.Log("OnPlayerAttach");
    if !this.handled {
      this.HandleSpawning();
    };
  }
  public final func IsNightCityUnlocked() -> Bool {
    return this.nightCityUnlocked;
  }
  public final func IsDogtownUnlocked() -> Bool {
    return this.dogtownUnlocked;
  }
  public final func IsCustomDropPoint(id: EntityID) -> Bool {
    return this.entitySystem.IsTagged(id, this.typeTag);
  }
  public final func IsCustomDropPoint(targetId: NewMappinID) -> Bool {
    let values: array<wref<IScriptable>>;
    this.spawnedMappins.GetValues(values);
    let entry: ref<MappinIdWrapper>;
    for value in values {
      entry = value as MappinIdWrapper;
      let id: NewMappinID = entry.id;
      if Equals(id, targetId) {
        return true;
      };
    };
    return false;
  }
  public final func SaveSpawnedMappinId(entityId: EntityID, mappinId: NewMappinID) -> Void {
    let tags: array<CName> = this.entitySystem.GetTags(entityId);
    let uniqueTag: CName = tags[0];
    let key: Uint64 = NameToHash(uniqueTag);
    if !this.spawnedMappins.KeyExist(key) {
      this.spawnedMappins.Insert(key, MappinIdWrapper.Create(mappinId, uniqueTag));
      this.Log(s"Saved mappinId \(mappinId.value) with key \(key)");
    };
  }
  public final func GetUniqueTagByEntityId(entityId: EntityID) -> CName {
    let tags: array<CName> = this.entitySystem.GetTags(entityId);
    if Equals(ArraySize(tags), 0) {
      return n"";
    };
    return tags[0];
  }
  public final func FindInstanceByMappinId(mappinId: NewMappinID) -> ref<AtelierDropPointInstance> {
    let values: array<wref<IScriptable>>;
    this.spawnedMappins.GetValues(values);
    let entry: ref<MappinIdWrapper>;
    let target: ref<MappinIdWrapper>;
    for value in values {
      entry = value as MappinIdWrapper;
      if Equals(entry.id, mappinId) {
        target = entry;
      };
    };
    if !IsDefined(target) {
      return null;
    };
    let dropPoints: array<ref<AtelierDropPointInstance>> = this.GetAvailableDropPoints();
    for dropPoint in dropPoints {
      if Equals(target.tag, dropPoint.uniqueTag) {
        return dropPoint;
      };
    };
    return null;
  }
  public final func GetAvailableDropPoints() -> array<ref<AtelierDropPointInstance>> {
    let result: array<ref<AtelierDropPointInstance>>;
    let chunk: array<ref<AtelierDropPointInstance>>;
    let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    for entityTag in supportedTags {
      chunk = this.spawnConfig.GetSpawnPointsByTag(entityTag);
      for item in chunk {
        ArrayPush(result, item);
      };
    };
    if this.IsNightCityUnlocked() {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
      for entityTag in supportedTags {
        chunk = this.spawnConfig.GetSpawnPointsByTag(entityTag);
        for item in chunk {
          ArrayPush(result, item);
        };
      };
    };
    if this.IsDogtownUnlocked() {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsDogtown();
      for entityTag in supportedTags {
        chunk = this.spawnConfig.GetSpawnPointsByTag(entityTag);
        for item in chunk {
          ArrayPush(result, item);
        };
      };
    };
    return result;
  }
  private final func CheckForQuestFacts() -> Void {
    this.Log(s"CheckForQuestFacts");
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let watsonFact: Int32 = questsSystem.GetFact(n"watson_prolog_lock");
    let unlockFact: Int32 = questsSystem.GetFact(n"unlock_car_hud_dpad");
    let dogtownFact: Int32 = questsSystem.GetFact(n"q302_done");
    this.nightCityUnlocked = NotEquals(watsonFact, 1) && NotEquals(unlockFact, 0);
    this.dogtownUnlocked = Equals(dogtownFact, 1); 
  }
  public final func CheckAndHandleSpawning() -> Void {
    this.Log(s"CheckAndHandleSpawning");
    if this.HasPendingEntities() {
      this.HandleSpawning();
    };
  }
  public final func HandleSpawning() -> Void {
    this.Log(s"HandleSpawning");
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };
    this.CheckForQuestFacts();
    this.ScheduleInitialNotification();
    this.handled = true;
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };
    let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    this.Log(s"! Prologue, supported tags: \(ArraySize(supportedTags))");
    for entityTag in supportedTags {
      this.Log(s"> Check tag \(entityTag):");
      if !this.entitySystem.IsPopulated(entityTag) {
        this.Log(s"-> Call for spawn entities");
        this.SpawnInstancesByTag(entityTag);
      } else {
        this.Log(s"-> Entities already spawned");
      };
    };
    if this.nightCityUnlocked {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
      this.Log(s"! Night City, supported tags: \(ArraySize(supportedTags))");
      for entityTag in supportedTags {
        this.Log(s"> Check tag \(entityTag):");
        if !this.entitySystem.IsPopulated(entityTag) {
          this.Log(s"-> Call for spawn entities");
          this.SpawnInstancesByTag(entityTag);
        } else {
          this.Log(s"-> Entities already spawned");
        };
      };
    } else {
      this.Log("Night City locked, skip spawning");
    };
    let playerInDogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInDogTown();
    if this.dogtownUnlocked && playerInDogtown {
      let supportedTags: array<CName> = this.spawnConfig.GetIterationTagsDogtown();
      this.Log(s"! Dogtown, supported tags: \(ArraySize(supportedTags))");
      for entityTag in supportedTags {
        this.Log(s"> Check tag \(entityTag):");
        if !this.entitySystem.IsPopulated(entityTag) {
          this.Log(s"-> Call for spawn entities");
          this.SpawnInstancesByTag(entityTag);
        } else {
          this.Log(s"-> Entities already spawned");
        };
      };
    } else {
      this.Log("Player not in Dogtown, skip spawning");
    };
  }
  public final func ScheduleInitialNotification() -> Void {
    this.Log(s"ScheduleInitialNotification...");
    this.delaySystem.CancelCallback(this.initialCallbackId);
    let callback: ref<DropPointsSpawnerCallbackInitial> = DropPointsSpawnerCallbackInitial.Create(this);
    this.initialCallbackId = this.delaySystem.DelayCallback(callback, 7.0, true);
  }
  public final func HandleInitialNotification() -> Void {
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let messenger: ref<DeliveryMessengerSystem>;
    let factName: CName = n"vad_welcome_displayed";
    let welcomeFact: Int32 = questsSystem.GetFact(factName);
    let welcomeDisplayed: Bool = Equals(welcomeFact, 1);
    this.Log(s"HandleInitialNotification, welcomeDisplayed = \(welcomeDisplayed)");
    if !welcomeDisplayed && this.IsPhoneAvailable() {
      messenger = DeliveryMessengerSystem.Get(this.GetGameInstance());
      messenger.PushWelcomeNotificationItem();
      questsSystem.SetFact(factName, 1);
    };
    this.ScheduleNewDropPointsNotification();
  }
  public final func ScheduleNewDropPointsNotification() -> Void {
    this.Log(s"ScheduleNewDropPointsNotification...");
    this.delaySystem.CancelCallback(this.dropPointsCallbackId);
    let callback: ref<DropPointsSpawnerCallbackNewDropPoint> = DropPointsSpawnerCallbackNewDropPoint.Create(this);
    this.dropPointsCallbackId = this.delaySystem.DelayCallback(callback, 7.0, true);
  }
  public final func HandleNewDropPointsNotification() -> Void {
    this.Log(s"HandleNewDropPointsNotification");
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let playerInDogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInDogTown();
    let messenger: ref<DeliveryMessengerSystem>;
    // LongshoreStacks
    let longshoreStacksFactName: CName = n"vad_longshore_sacks_displayed";
    let longshoreStacksFact: Int32 = questsSystem.GetFact(longshoreStacksFactName);
    let longshoreStacksDisplayed: Bool = Equals(longshoreStacksFact, 1);
    this.Log(s" - LongshoreStacks displayed: \(longshoreStacksDisplayed)");
    if playerInDogtown && !longshoreStacksDisplayed && this.IsPhoneAvailable() {
      messenger = DeliveryMessengerSystem.Get(this.GetGameInstance());
      messenger.PushNewDropPointNotificationItem(AtelierDeliveryDropPoint.LongshoreStacks, t"Districts.Dogtown");
      questsSystem.SetFact(longshoreStacksFactName, 1);
    };
  }
  public final func DespawnAll() -> Void {
    let supportedTagsPrologue: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    let supportedTagsNightCity: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
    let supportedTagsDogtown: array<CName> = this.spawnConfig.GetIterationTagsDogtown();
    for tag in supportedTagsPrologue {
      this.entitySystem.DeleteTagged(tag);
    };
    for tag in supportedTagsNightCity {
      this.entitySystem.DeleteTagged(tag);
    };
    for tag in supportedTagsDogtown {
      this.entitySystem.DeleteTagged(tag);
    };
  }
  private final func SpawnInstancesByTag(entityTag: CName) -> Void {
    let instances: array<ref<AtelierDropPointInstance>> = this.spawnConfig.GetSpawnPointsByTag(entityTag);
    let deviceSpec: ref<DynamicEntitySpec>;
    for instance in instances {
      deviceSpec = new DynamicEntitySpec();
      deviceSpec.templatePath = r"djkovrik\\gameplay\\devices\\drop_points\\drop_point_va.ent";
      deviceSpec.appearanceName = n"default";
      deviceSpec.position = instance.position;
      deviceSpec.orientation = instance.orientation;
      deviceSpec.persistSpawn = true;
      deviceSpec.alwaysSpawned = true;
      deviceSpec.tags = [ instance.uniqueTag, instance.indexTag, instance.iterationTag, this.typeTag ];
      this.Log(s"--> spawning entity with tags [ \(instance.uniqueTag), \(instance.iterationTag), \(this.typeTag) ] at position \(instance.position)");
      this.entitySystem.CreateEntity(deviceSpec);
    };
  }
  private final func HasPendingEntities() -> Bool {
    let prologueUpdateRequired: Bool = false;
    let nightCityUpdateRequired: Bool = false;
    let dogtownUpdateRequired: Bool = false;
    let supportedTagsPrologue: array<CName> = this.spawnConfig.GetIterationTagsPrologue();
    let supportedTagsNightCity: array<CName> = this.spawnConfig.GetIterationTagsNightCity();
    let supportedTagsDogtown: array<CName> = this.spawnConfig.GetIterationTagsDogtown();
    for tag in supportedTagsPrologue {
      if !this.entitySystem.IsPopulated(tag) {
        prologueUpdateRequired = true;
      };
    };
    for tag in supportedTagsNightCity {
      if !this.entitySystem.IsPopulated(tag) {
        nightCityUpdateRequired = true;
      };
    };
    for tag in supportedTagsDogtown {
      if !this.entitySystem.IsPopulated(tag) {
        dogtownUpdateRequired = true;
      };
    };
    return prologueUpdateRequired || nightCityUpdateRequired || dogtownUpdateRequired;
  }
  private final func IsPhoneAvailable() -> Bool {
    let phoneSystem: wref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"PhoneSystem") as PhoneSystem;
    if IsDefined(phoneSystem) {
      return phoneSystem.IsPhoneEnabled();
    };
    return false;
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliverySpawner", str);
    };
  }
}
public class DropPointsSpawnerCallbackInitial extends DelayCallback {
  private let system: wref<AtelierDropPointsSpawner>;
  public static func Create(system: ref<AtelierDropPointsSpawner>) -> ref<DropPointsSpawnerCallbackInitial> {
    let instance: ref<DropPointsSpawnerCallbackInitial> = new DropPointsSpawnerCallbackInitial();
    instance.system = system;
    return instance;
  }
	public func Call() -> Void {
    this.system.HandleInitialNotification();
	}
}
public class DropPointsSpawnerCallbackNewDropPoint extends DelayCallback {
  private let system: wref<AtelierDropPointsSpawner>;
  public static func Create(system: ref<AtelierDropPointsSpawner>) -> ref<DropPointsSpawnerCallbackNewDropPoint> {
    let instance: ref<DropPointsSpawnerCallbackNewDropPoint> = new DropPointsSpawnerCallbackNewDropPoint();
    instance.system = system;
    return instance;
  }
	public func Call() -> Void {
    this.system.HandleNewDropPointsNotification();
	}
}
/**
  Creating new drop point instance:
  - add new entry to AtelierDeliveryDropPoint enum (Classes.reds)
  - add new entry to enum->locKey mapper in GetDeliveryPointLocKey (Utils.reds)
  - add new entry to Init below
  inkatlas texturePart name should match uniqueTag
**/
public class AtelierDropPointsSpawnerConfig {
  private let spawnPoints: ref<inkHashMap>;
  private let iterationTagsPrologue: array<CName>;
  private let iterationTagsNightCity: array<CName>;
  private let iterationTagsDogtown: array<CName>;
  public final func Init() -> Void {
    this.spawnPoints = new inkHashMap();
  }
  public final func BuildPrologueList() -> Void {
    // PROLOGUE ITERATION: 
    let iterationTagPrologue: CName = n"NightCity_Prologue1";
    let iterationSpawnsPrologue: array<ref<AtelierDropPointInstance>>;
    ArrayPush(this.iterationTagsPrologue, iterationTagPrologue);
    // Watson, Little China
    ArrayPush(
      iterationSpawnsPrologue,
      AtelierDropPointInstance.Create(
        "LocKey#10963",
        t"Districts.Watson",
        t"Districts.LittleChina",
        AtelierDeliveryDropPoint.LittleChina,
        n"LittleChina",
        n"droppoint19",
        iterationTagPrologue,
        this.CreatePosition(-1450.845215, 1221.096802, 23.061127, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.928518, 0.371288),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints2.inkatlas"
      )
    );
    let iterationListPrologue: ref<AtelierDropPointsList> = AtelierDropPointsList.Create(iterationSpawnsPrologue);
    this.spawnPoints.Insert(this.Key(iterationTagPrologue), iterationListPrologue);
    this.Log(s"Stored \(ArraySize(iterationListPrologue.points)) points for key \(this.Key(iterationTagPrologue))");
  }
  // When any new version adds more drop points then new iteration tag must be used
  public final func BuildNightCityList() -> Void {
    // ITERATION #1:
    let iterationTag1: CName = n"NightCity_Iteration1";
    let iterationSpawns1: array<ref<AtelierDropPointInstance>>;
    ArrayPush(this.iterationTagsNightCity, iterationTag1);
    // Watson, Little China
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44450",
        t"Districts.Watson",
        t"Districts.LittleChina",
        AtelierDeliveryDropPoint.MegabuildingH10,
        n"MegabuildingH10",
        n"droppoint1",
        iterationTag1,
        this.CreatePosition(-1443.939209, 1339.663208, 119.082382, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.728089, -0.663599),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Watson, Kabuki
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44430",
        t"Districts.Watson",
        t"Districts.Kabuki",
        AtelierDeliveryDropPoint.KabukiMarket,
        n"KabukiMarket",
        n"droppoint2",
        iterationTag1,
        this.CreatePosition(-1242.697614, 2021.161367, 11.915947, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.469456, 0.844077),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Watson, Northside
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44415",
        t"Districts.Watson",
        t"Districts.Northside",
        AtelierDeliveryDropPoint.MartinSt,
        n"MartinSt",
        n"droppoint3",
        iterationTag1,
        this.CreatePosition(-1475.607837, 2192.650830, 18.200005, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.490099, 0.892979),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Watson, Arasaka Waterfront
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95277",
        t"Districts.Watson",
        t"Districts.ArasakaWaterfront",
        AtelierDeliveryDropPoint.EisenhowerSt,
        n"EisenhowerSt",
        n"droppoint4",
        iterationTag1,
        this.CreatePosition(-1767.295410, 1869.108765, 18.257347, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.258819, 0.965926),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Westbrook, Charter Hill
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#21266",
        t"Districts.Westbrook",
        t"Districts.CharterHill",
        AtelierDeliveryDropPoint.CharterHill,
        n"CharterHill",
        n"droppoint5",
        iterationTag1,
        this.CreatePosition(-124.690515, 156.954523, 14.669594, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.891798, -0.452434),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Westbrook, Japantown
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#21233",
        t"Districts.Westbrook",
        t"Districts.JapanTown",
        AtelierDeliveryDropPoint.CherryBlossomMarket,
        n"CherryBlossomMarket",
        n"droppoint6",
        iterationTag1,
        this.CreatePosition(-693.016819, 912.408923, 12.0, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.078458, 0.996917),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Westbrook, North Oak
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44579",
        t"Districts.Westbrook",
        t"Districts.NorthOaks",
        AtelierDeliveryDropPoint.NorthOakSign,
        n"NorthOakSign",
        n"droppoint7",
        iterationTag1,
        this.CreatePosition(294.980853, 817.504370, 146.618530, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.998797, 0.049033),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // City Center, Corpo Plaza
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95266",
        t"Districts.CityCenter",
        t"Districts.CorpoPlaza",
        AtelierDeliveryDropPoint.SarastiAndRepublic,
        n"SarastiAndRepublic",
        n"droppoint8",
        iterationTag1,
        this.CreatePosition(-1487.291138, 449.454785, 7.739998, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.999962, -0.008727),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // City Center, Downtown
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44500",
        t"Districts.CityCenter",
        t"Districts.Downtown",
        AtelierDeliveryDropPoint.CorporationSt,
        n"CorporationSt",
        n"droppoint9",
        iterationTag1,
        this.CreatePosition(-2394.930420, -59.059253, 9.682861, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.686005, 0.665941),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Heywood, The Glen
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44519",
        t"Districts.Heywood",
        t"Districts.Glen",
        AtelierDeliveryDropPoint.MegabuildingH3,
        n"MegabuildingH3",
        n"droppoint10",
        iterationTag1,
        this.CreatePosition(-1196.130127, -930.899170, 12.044189, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.078459, 0.996917),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Heywood, Vista del Rey
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95271",
        t"Districts.Heywood",
        t"Districts.VistaDelRey",
        AtelierDeliveryDropPoint.CongressMlk,
        n"CongressMlk",
        n"droppoint11",
        iterationTag1,
        this.CreatePosition(-1074.648804, -399.022583, 8.066277, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.455593, 0.890188),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Heywood, Wellsprings
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#44501",
        t"Districts.Heywood",
        t"Districts.Wellsprings",
        AtelierDeliveryDropPoint.CanneryPlaza,
        n"CanneryPlaza",
        n"droppoint12",
        iterationTag1,
        this.CreatePosition(-2390.791504, -573.703809, 7.000175, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.009234, 0.999957),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Santo Domingo, Arroyo
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95265",
        t"Districts.SantoDomingo",
        t"Districts.Arroyo",
        AtelierDeliveryDropPoint.WollesenSt,
        n"WollesenSt",
        n"droppoint13",
        iterationTag1,
        this.CreatePosition(-1074.211060, -1424.782959, 30.799721, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.898061, 0.439872),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Santo Domingo, Rancho Coronado
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95272",
        t"Districts.SantoDomingo",
        t"Districts.RanchoCoronado",
        AtelierDeliveryDropPoint.MegabuildingH7,
        n"MegabuildingH7",
        n"droppoint14",
        iterationTag1,
        this.CreatePosition(152.273178, -1177.103882, 31.511642, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.956156, -0.292857),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Pacifica, Coastview
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#95276",
        t"Districts.Pacifica",
        t"Districts.Coastview",
        AtelierDeliveryDropPoint.PacificaStadium,
        n"PacificaStadium",
        n"droppoint15",
        iterationTag1,
        this.CreatePosition(-1563.313354, -1956.801025, 72.923096, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.549048, 0.835791),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Pacifica, West Wind Estate
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#10958",
        t"Districts.Pacifica",
        t"Districts.WestWindEstate",
        AtelierDeliveryDropPoint.WestWindEstate,
        n"WestWindEstate",
        n"droppoint16",
        iterationTag1,
        this.CreatePosition(-2605.829834, -2477.411621, 17.262611, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.206258, 0.978498),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    // Badlands, Red Peaks
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#37971",
        t"Districts.Badlands",
        t"Districts.RedPeaks",
        AtelierDeliveryDropPoint.SunsetMotel,
        n"SunsetMotel",
        n"droppoint17",
        iterationTag1,
        this.CreatePosition(1607.783374, -799.309924, 49.814171, 1.0),
        this.CreateOrientation(0.0, 0.0, -0.199249, 0.979949),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    let iterationList1: ref<AtelierDropPointsList> = AtelierDropPointsList.Create(iterationSpawns1);
    this.spawnPoints.Insert(this.Key(iterationTag1), iterationList1);
    this.Log(s"Stored \(ArraySize(iterationList1.points)) points for key \(this.Key(iterationTag1))");
  }
  // When any new version adds more drop points then new iteration tag must be used
  public final func BuildDogtownList() -> Void {
    // ITERATION #1:
    let iterationTag1: CName = n"Dogtown_Iteration1";
    let iterationSpawns1: array<ref<AtelierDropPointInstance>>;
    ArrayPush(this.iterationTagsDogtown, iterationTag1);
    // Pacifica, Dogtown
    ArrayPush(
      iterationSpawns1,
      AtelierDropPointInstance.Create(
        "LocKey#93789",
        t"Districts.Pacifica",
        t"Districts.Dogtown",
        AtelierDeliveryDropPoint.LongshoreStacks,
        n"LongshoreStacks",
        n"droppoint18",
        iterationTag1,
        this.CreatePosition(-2427.495068, -2709.809326, 23.894119, 1.0),
        this.CreateOrientation(0.0, 0.0, 0.693709, 0.720255),
        r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_droppoints1.inkatlas"
      )
    );
    let iterationList1: ref<AtelierDropPointsList> = AtelierDropPointsList.Create(iterationSpawns1);
    this.spawnPoints.Insert(this.Key(iterationTag1), iterationList1);
    this.Log(s"Stored \(ArraySize(iterationList1.points)) points for key \(this.Key(iterationTag1))");
  }
  public final func GetSpawnPointsByTag(tag: CName) -> array<ref<AtelierDropPointInstance>> {
    let key: Uint64 = this.Key(tag);
    let pointsList: ref<AtelierDropPointsList>;
    let emptyArray: array<ref<AtelierDropPointInstance>>;
    if this.spawnPoints.KeyExist(key) {
      pointsList = this.spawnPoints.Get(key) as AtelierDropPointsList;
      return pointsList.points;
    };
    return emptyArray;
  }
  public final func GetIterationTagsPrologue() -> array<CName> {
    return this.iterationTagsPrologue;
  }
  public final func GetIterationTagsNightCity() -> array<CName> {
    return this.iterationTagsNightCity;
  }
  public final func GetIterationTagsDogtown() -> array<CName> {
    return this.iterationTagsDogtown;
  }
  private final func CreatePosition(x: Float, y: Float, z: Float, w: Float) -> Vector4 {
    let instance: Vector4 = new Vector4(x, y, z, w);
    return instance;
  }
  private final func CreateOrientation(i: Float, j: Float, k: Float, r: Float) -> Quaternion {
    let instance: Quaternion;
    instance.i = i;
    instance.j = j;
    instance.k = k;
    instance.r = r;
    return instance;
  }
  private final func Key(tag: CName) -> Uint64 {
    return NameToHash(tag);
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliverySpawnerConfig", str);
    };
  }
}
// Track live fact updates
@addField(PlayerPuppet)
private let vaFactListenerWatson: Uint32;
@addField(PlayerPuppet)
private let vaFactListenerDogtown: Uint32;
@wrapMethod(PlayerPuppet)
private final func PlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
  wrappedMethod(playerPuppet);
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  this.vaFactListenerWatson = questsSystem.RegisterListener(n"watson_prolog_lock", this, n"OnFactChangedWatson");
  this.vaFactListenerDogtown = questsSystem.RegisterListener(n"q302_done", this, n"OnFactChangedDogtown");
}
@wrapMethod(PlayerPuppet)
private final func PlayerDetachedCallback(playerPuppet: ref<GameObject>) -> Void {
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  questsSystem.UnregisterListener(n"watson_prolog_lock", this.vaFactListenerWatson);
  questsSystem.UnregisterListener(n"q302_done", this.vaFactListenerDogtown);
  wrappedMethod(playerPuppet);
}
@addMethod(PlayerPuppet)
public final func OnFactChangedWatson(val: Int32) -> Void {
  if Equals(val, 0) {
    AtelierDropPointsSpawner.Get(this.GetGame()).HandleSpawning();
  };
}
@addMethod(PlayerPuppet)
public final func OnFactChangedDogtown(val: Int32) -> Void {
  if Equals(val, 1) {
    AtelierDropPointsSpawner.Get(this.GetGame()).HandleSpawning();
  };
}
// Run check on ft to Dogtown
@wrapMethod(FastTravelSystem)
protected cb func OnLoadingScreenFinished(value: Bool) -> Bool {
  let playerInDogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInDogTown();
  if value && playerInDogtown {
    AtelierDropPointsSpawner.Get(this.GetGameInstance()).CheckAndHandleSpawning();
  };
  wrappedMethod(value);
}
@wrapMethod(VendingMachine)
protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
  wrappedMethod(ri);
  let hash: Uint32 = EntityID.GetHash(this.GetEntityID());
  if Equals(hash, 3852533768u) // Megabuilding H10
  || Equals(hash, 555307173u)  // Kabuki Market
  || Equals(hash, 900418829u)  // Martin St
  || Equals(hash, 3180019791u) // Cherry Blossom Market
  || Equals(hash, 2960900634u) // Sarasti&Republic
  || Equals(hash, 672384566u)  // Megabuilding H3
  || Equals(hash, 936522229u)  // Congress&MLK
  || Equals(hash, 2864649619u) // Cannery Plaza
  || Equals(hash, 2223155765u) // Wollesen St
  || Equals(hash, 1818591582u) // Megabuilding H7
  || Equals(hash, 4230006327u) // Pacifica Stadium
  || Equals(hash, 3081670176u) // West Wind Estate
  || Equals(hash, 3145583149u) // Sunset Motel
  || Equals(hash, 2444101793u) // Longshore Stacks
  || Equals(hash, 900254894u)  // Little China
  { 
    EntityGameInterface.Destroy(this.GetEntity());
  };
}
@wrapMethod(DropPoint)
protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
  wrappedMethod(ri);
  let hash: Uint32 = EntityID.GetHash(this.GetEntityID());
  if Equals(hash, 2080424202u) // Eisenhower St
  { 
    EntityGameInterface.Destroy(this.GetEntity());
  };
}
@wrapMethod(InteractiveDevice)
protected cb func OnPerformedAction(evt: ref<PerformedAction>) -> Bool {
  if VirtualAtelierDeliveryConfig.Debug() {
    ModLog(n"EntityHash", s"\(this.GetClassName()): \(EntityID.GetHash(this.GetEntityID())) at \(this.GetWorldPosition()) with \(this.GetWorldOrientation())");
  };
  return wrappedMethod(evt);
}
public abstract class LayoutsBuilder {
  public final static func CheckoutContainer() -> ref<inkWidget> {
    let orderInfo: ref<inkWidget> = LayoutsBuilder.BuildOrderInfo();
    let customerInfo: ref<inkWidget> = LayoutsBuilder.BuildCustomerInfo();
    let deliverySelector: ref<inkWidget> = LayoutsBuilder.BuildDeliverySelector();
    let destinationSelector: ref<inkWidget> = LayoutsBuilder.BuildDestinationSelector();
    let rootCanvas: ref<inkCanvas> = new inkCanvas();
    rootCanvas.SetName(n"RootCanvas");
    rootCanvas.SetSize(1400.0, 1060.0);
    let leftPart: ref<inkVerticalPanel> = new inkVerticalPanel();
    leftPart.SetName(n"leftColumn");
    leftPart.SetAnchor(inkEAnchor.TopLeft);
    leftPart.SetAnchorPoint(0.0, 0.0);
    leftPart.Reparent(rootCanvas);
    customerInfo.SetMargin(new inkMargin(16.0, 32.0, 0.0, 0.0));
    customerInfo.Reparent(leftPart);
    orderInfo.SetMargin(new inkMargin(16.0, 32.0, 0.0, 0.0));
    orderInfo.Reparent(leftPart);
    deliverySelector.SetMargin(new inkMargin(16.0, 32.0, 0.0, 0.0));
    deliverySelector.Reparent(leftPart);
    let total: ref<inkText> = new inkText();
    total.SetName(n"total");
    total.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    total.SetFontSize(48);
    total.SetFontStyle(n"Medium");
    total.SetAnchor(inkEAnchor.CenterLeft);
    total.SetAnchorPoint(new Vector2(0.0, 0.5));
    total.SetMargin(new inkMargin(16.0, 32.0, 0.0, 8.0));
    total.SetLetterCase(textLetterCase.OriginalCase);
    total.SetText("Total: 1234567890$");
    total.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    total.BindProperty(n"tintColor", n"MainColors.Red");
    total.Reparent(leftPart);
    destinationSelector.SetAnchor(inkEAnchor.TopRight);
    destinationSelector.SetAnchorPoint(1.0, 0.0);
    destinationSelector.SetMargin(new inkMargin(0.0, 16.0, 48.0, 0.0));
    destinationSelector.Reparent(rootCanvas);
    let dropPointPreview: ref<inkCompoundWidget> = LayoutsBuilder.BuildDropPointPreviewContainer();
    dropPointPreview.Reparent(rootCanvas);
    return rootCanvas;
  }
  public final static func BuildOrderInfo() -> ref<inkVerticalPanel> {
    let orderInfo: ref<inkVerticalPanel> = new inkVerticalPanel();
    orderInfo.SetName(n"orderInfo");
    let orderInfoHeader: ref<inkText> = new inkText();
    orderInfoHeader.SetName(n"orderInfoHeader");
    orderInfoHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    orderInfoHeader.SetFontSize(50);
    orderInfoHeader.SetFontStyle(n"Regular");
    orderInfoHeader.SetAnchor(inkEAnchor.CenterLeft);
    orderInfoHeader.SetAnchorPoint(new Vector2(0.0, 0.5));
    orderInfoHeader.SetMargin(new inkMargin(0.0, 0.0, 0.0, 16.0));
    orderInfoHeader.SetLetterCase(textLetterCase.OriginalCase);
    orderInfoHeader.SetText(GetLocalizedTextByKey(n"Mod-VAD-Order-Info"));
    orderInfoHeader.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    orderInfoHeader.BindProperty(n"tintColor", n"MainColors.Blue");
    orderInfoHeader.Reparent(orderInfo);
    let storeName: ref<inkText> = new inkText();
    storeName.SetName(n"storeName");
    storeName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    storeName.SetFontSize(42);
    storeName.SetFontStyle(n"Regular");
    storeName.SetWidth(600.0);
    storeName.SetWrapping(true, 580, textWrappingPolicy.PerCharacter);
    storeName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    storeName.SetAnchor(inkEAnchor.CenterLeft);
    storeName.SetAnchorPoint(new Vector2(0.0, 0.5));
    storeName.SetMargin(new inkMargin(0.0, 0.0, 0.0, 8.0));
    storeName.SetLetterCase(textLetterCase.OriginalCase);
    storeName.SetText("All Foods Online");
    storeName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    storeName.BindProperty(n"tintColor", n"MainColors.White");
    storeName.Reparent(orderInfo);
    let totalItems: ref<inkText> = new inkText();
    totalItems.SetName(n"totalItems");
    totalItems.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    totalItems.SetFontSize(42);
    totalItems.SetFontStyle(n"Regular");
    totalItems.SetAnchor(inkEAnchor.CenterLeft);
    totalItems.SetAnchorPoint(new Vector2(0.0, 0.5));
    totalItems.SetMargin(new inkMargin(0.0, 0.0, 0.0, 8.0));
    totalItems.SetLetterCase(textLetterCase.OriginalCase);
    totalItems.SetText("Items quantity: 1234567890");
    totalItems.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    totalItems.BindProperty(n"tintColor", n"MainColors.White");
    totalItems.Reparent(orderInfo);
    let actualWeight: ref<inkText> = new inkText();
    actualWeight.SetName(n"actualWeight");
    actualWeight.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    actualWeight.SetFontSize(42);
    actualWeight.SetFontStyle(n"Regular");
    actualWeight.SetAnchor(inkEAnchor.CenterLeft);
    actualWeight.SetAnchorPoint(new Vector2(0.0, 0.5));
    actualWeight.SetMargin(new inkMargin(0.0, 0.0, 0.0, 16.0));
    actualWeight.SetLetterCase(textLetterCase.OriginalCase);
    actualWeight.SetText("Items weight: 1234567890");
    actualWeight.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    actualWeight.BindProperty(n"tintColor", n"MainColors.White");
    actualWeight.Reparent(orderInfo);
    let subtotal: ref<inkText> = new inkText();
    subtotal.SetName(n"subtotal");
    subtotal.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    subtotal.SetFontSize(42);
    subtotal.SetFontStyle(n"Regular");
    subtotal.SetAnchor(inkEAnchor.CenterLeft);
    subtotal.SetAnchorPoint(new Vector2(0.0, 0.5));
    subtotal.SetMargin(new inkMargin(0.0, 0.0, 0.0, 8.0));
    subtotal.SetLetterCase(textLetterCase.OriginalCase);
    subtotal.SetText("Subtotal: 1234567890$");
    subtotal.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    subtotal.BindProperty(n"tintColor", n"MainColors.White");
    subtotal.Reparent(orderInfo);
    return orderInfo;
  }
  public static final func BuildCustomerInfo() -> ref<inkCompoundWidget> {
    let customerInfo: ref<inkFlex> = new inkFlex();
    customerInfo.SetName(n"customerInfo");
    customerInfo.SetHAlign(inkEHorizontalAlign.Left);
    customerInfo.SetChildOrder(inkEChildOrder.Backward);
    customerInfo.SetFitToContent(true);
    let outline: ref<inkImage> = new inkImage();
    outline.SetName(n"outline");
    outline.SetFitToContent(true);
    outline.SetAnchor(inkEAnchor.Fill);
    outline.SetAnchorPoint(0.5, 0.5);
    outline.SetHAlign(inkEHorizontalAlign.Fill);
    outline.SetVAlign(inkEVerticalAlign.Fill);
    outline.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    outline.BindProperty(n"tintColor", n"MainColors.ActiveRed");
    outline.SetOpacity(0.1);
    outline.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    outline.SetTexturePart(n"cell_fg");
    outline.SetNineSliceScale(true);
    outline.useExternalDynamicTexture = true;
    outline.Reparent(customerInfo);
    let content: ref<inkVerticalPanel> = new inkVerticalPanel();
    content.SetName(n"content");
    content.SetFitToContent(true);
    content.SetAnchor(inkEAnchor.CenterLeft);
    content.SetHAlign(inkEHorizontalAlign.Left);
    content.SetVAlign(inkEVerticalAlign.Center);
    content.SetMargin(new inkMargin(32.0, 16.0, 32.0, 16.0));
    content.SetAnchorPoint(0.5, 0.5);
    content.Reparent(customerInfo);
    let firstRow: ref<inkVerticalPanel> = new inkVerticalPanel();
    firstRow.SetName(n"firstRow");
    firstRow.Reparent(content);
    let header: ref<inkText> = new inkText();
    header.SetName(n"header");
    header.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    header.SetFontSize(40);
    header.SetFontStyle(n"Medium");
    header.SetAnchor(inkEAnchor.CenterLeft);
    header.SetAnchorPoint(new Vector2(0.0, 0.5));
    header.SetMargin(new inkMargin(0.0, 0.0, 16.0, 0.0));
    header.SetLetterCase(textLetterCase.OriginalCase);
    header.SetText(GetLocalizedTextByKey(n"Mod-VAD-Customer-Info"));
    header.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    header.BindProperty(n"tintColor", n"MainColors.Red");
    header.Reparent(firstRow);
    let clientName: ref<inkText> = new inkText();
    clientName.SetName(n"clientName");
    clientName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    clientName.SetFontSize(40);
    clientName.SetFontStyle(n"Regular");
    clientName.SetAnchor(inkEAnchor.CenterLeft);
    clientName.SetAnchorPoint(new Vector2(0.0, 0.5));
    clientName.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    clientName.SetLetterCase(textLetterCase.OriginalCase);
    clientName.SetText("Valerie ******");
    clientName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    clientName.BindProperty(n"tintColor", n"MainColors.Red");
    clientName.Reparent(firstRow);
    let secondRow: ref<inkVerticalPanel> = new inkVerticalPanel();
    secondRow.SetName(n"secondRow");
    secondRow.Reparent(content);
    let contactInfo: ref<inkText> = new inkText();
    contactInfo.SetName(n"contactInfo");
    contactInfo.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    contactInfo.SetFontSize(40);
    contactInfo.SetFontStyle(n"Medium");
    contactInfo.SetAnchor(inkEAnchor.CenterLeft);
    contactInfo.SetAnchorPoint(new Vector2(0.0, 0.5));
    contactInfo.SetMargin(new inkMargin(0.0, 0.0, 16.0, 0.0));
    contactInfo.SetLetterCase(textLetterCase.OriginalCase);
    contactInfo.SetText(GetLocalizedTextByKey(n"Mod-VAD-Contact-Info"));
    contactInfo.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    contactInfo.BindProperty(n"tintColor", n"MainColors.Red");
    contactInfo.Reparent(secondRow);
    let notProvided: ref<inkText> = new inkText();
    notProvided.SetName(n"notProvided");
    notProvided.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    notProvided.SetFontSize(40);
    notProvided.SetFontStyle(n"Regular");
    notProvided.SetAnchor(inkEAnchor.CenterLeft);
    notProvided.SetAnchorPoint(new Vector2(0.0, 0.5));
    notProvided.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    notProvided.SetLetterCase(textLetterCase.OriginalCase);
    notProvided.SetText(GetLocalizedTextByKey(n"Mod-VAD-Contact-Info-Not-Provided"));
    notProvided.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    notProvided.BindProperty(n"tintColor", n"MainColors.Red");
    notProvided.Reparent(secondRow);
    let minWidth: ref<inkCanvas> = new inkCanvas();
    minWidth.SetName(n"minWidth");
    minWidth.SetFitToContent(true);
    minWidth.SetAnchor(inkEAnchor.CenterLeft);
    minWidth.SetHAlign(inkEHorizontalAlign.Left);
    minWidth.SetVAlign(inkEVerticalAlign.Center);
    minWidth.SetAnchorPoint(0.5, 0.5);
    minWidth.SetSize(460.00, 10.0);
    minWidth.SetVisible(false);
    minWidth.SetAffectsLayoutWhenHidden(true);
    minWidth.Reparent(customerInfo);
    return customerInfo;
  }
  public final static func BuildDeliverySelector() -> ref<inkCompoundWidget> {
    let deliverySelector: ref<inkVerticalPanel> = new inkVerticalPanel();
    deliverySelector.SetName(n"deliverySelector");
    let deliveryHeader: ref<inkText> = new inkText();
    deliveryHeader.SetName(n"deliveryHeader");
    deliveryHeader.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    deliveryHeader.SetFontSize(50);
    deliveryHeader.SetFontStyle(n"Regular");
    deliveryHeader.SetAnchor(inkEAnchor.CenterLeft);
    deliveryHeader.SetAnchorPoint(new Vector2(0.0, 0.5));
    deliveryHeader.SetLetterCase(textLetterCase.OriginalCase);
    deliveryHeader.SetText(GetLocalizedTextByKey(n"Mod-VAD-Shipment-Method"));
    deliveryHeader.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    deliveryHeader.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    deliveryHeader.BindProperty(n"tintColor", n"MainColors.Blue");
    deliveryHeader.Reparent(deliverySelector);
    let deliveryCheckboxes: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    deliveryCheckboxes.SetName(n"deliveryCheckboxes");
    deliveryCheckboxes.SetMargin(new inkMargin(0.0, 20.0, 0.0, 20.0));
    deliveryCheckboxes.Reparent(deliverySelector);
    let checkboxStandard: ref<inkHorizontalPanel> = LayoutsBuilder.BuildCheckbox(n"checkboxStandard", n"Mod-VAD-Shipment-Standard");
    let checkboxPriority: ref<inkHorizontalPanel> = LayoutsBuilder.BuildCheckbox(n"checkboxPriority", n"Mod-VAD-Shipment-Priority");
    checkboxStandard.Reparent(deliveryCheckboxes);
    checkboxPriority.Reparent(deliveryCheckboxes);
    let shippingCost: ref<inkText> = new inkText();
    shippingCost.SetName(n"shippingCost");
    shippingCost.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    shippingCost.SetFontSize(38);
    shippingCost.SetFontStyle(n"Regular");
    shippingCost.SetAnchor(inkEAnchor.CenterLeft);
    shippingCost.SetAnchorPoint(new Vector2(0.0, 0.5));
    shippingCost.SetMargin(new inkMargin(4.0, 0.0, 0.0, 0.0));
    shippingCost.SetLetterCase(textLetterCase.OriginalCase);
    shippingCost.SetText("Shipping cost: 123$");
    shippingCost.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    shippingCost.BindProperty(n"tintColor", n"MainColors.White");
    shippingCost.SetOpacity(0.5);
    shippingCost.Reparent(deliverySelector);
    let estimatedDelivery: ref<inkText> = new inkText();
    estimatedDelivery.SetName(n"estimatedDelivery");
    estimatedDelivery.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    estimatedDelivery.SetFontSize(38);
    estimatedDelivery.SetFontStyle(n"Regular");
    estimatedDelivery.SetMargin(new inkMargin(4.0, 4.0, 0.0, 8.0));
    estimatedDelivery.SetLetterCase(textLetterCase.OriginalCase);
    estimatedDelivery.SetText("Delivery time: 1-2 days");
    estimatedDelivery.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    estimatedDelivery.BindProperty(n"tintColor", n"MainColors.White");
    estimatedDelivery.SetOpacity(0.5);
    estimatedDelivery.Reparent(deliverySelector);
    return deliverySelector;
  }
  public final static func BuildCheckbox(name: CName, locKey: CName) -> ref<inkHorizontalPanel> {
    let checkboxWrapper: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    checkboxWrapper.SetName(name);
    checkboxWrapper.SetInteractive(true);
    checkboxWrapper.SetAnchor(inkEAnchor.CenterLeft);
    checkboxWrapper.SetAnchorPoint(0.0, 0.5);
    checkboxWrapper.SetMargin(0.0, 0.0, 0.0, 0.0);
    checkboxWrapper.SetSize(300.0, 0.0);
    let flexbox: ref<inkFlex> = new inkFlex();
    flexbox.SetName(n"flexbox");
    flexbox.SetInteractive(true);
    flexbox.SetAnchor(inkEAnchor.Fill);
    flexbox.SetAnchorPoint(0.5, 0.5);
    flexbox.SetVAlign(inkEVerticalAlign.Center);
    flexbox.SetMargin(6.0, 0.0, 6.0, 0.0);
    flexbox.SetSize(100.0, 100.0);
    flexbox.Reparent(checkboxWrapper);
    let foreground1: ref<inkRectangle> = new inkRectangle();
    foreground1.SetName(n"foreground1");
    foreground1.SetInteractive(true);
    foreground1.SetAnchor(inkEAnchor.Centered);
    foreground1.SetAnchorPoint(0.5, 0.5);
    foreground1.SetHAlign(inkEHorizontalAlign.Right);
    foreground1.SetVAlign(inkEVerticalAlign.Top);
    foreground1.SetSize(40.0, 40.0);
    foreground1.SetOpacity(0.5);
    foreground1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    foreground1.BindProperty(n"tintColor", n"MainColors.Fullscreen_PrimaryBackgroundDarkest");
    foreground1.Reparent(flexbox);
    let foreground: ref<inkRectangle> = new inkRectangle();
    foreground.SetName(n"foreground");
    foreground.SetInteractive(true);
    foreground.SetAnchor(inkEAnchor.Centered);
    foreground.SetAnchorPoint(0.5, 0.5);
    foreground.SetHAlign(inkEHorizontalAlign.Right);
    foreground.SetVAlign(inkEVerticalAlign.Top);
    foreground.SetMargin(new inkMargin(0.0, 8.0, 8.0, 0.0));
    foreground.SetSize(25.0, 25.0);
    foreground.SetVisible(false);
    foreground.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    foreground.BindProperty(n"tintColor", n"MainColors.MildRed");
    foreground.Reparent(flexbox);
    let border: ref<inkBorderCustom> = new inkBorderCustom();
    border.SetName(n"border");
    border.SetSize(40.0, 40.0);
    border.SetOpacity(0.3);
    border.SetAnchor(inkEAnchor.Centered);
    border.SetAnchorPoint(0.5, 0.5);
    border.SetHAlign(inkEHorizontalAlign.Right);
    border.SetVAlign(inkEVerticalAlign.Top);
    border.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    border.BindProperty(n"tintColor", n"MainColors.MildRed");
    border.SetThickness(4.0);
    border.Reparent(flexbox);
    let checkboxLabel: ref<inkText> = new inkText();
    checkboxLabel.SetName(n"checkboxLabel");
    checkboxLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    checkboxLabel.SetFontSize(42);
    checkboxLabel.SetFontStyle(n"Regular");
    checkboxLabel.SetMargin(new inkMargin(12.0, 0.0, 32.0, 0.0));
    checkboxLabel.SetLetterCase(textLetterCase.OriginalCase);
    checkboxLabel.SetVerticalAlignment(textVerticalAlignment.Center);
    checkboxLabel.SetText(GetLocalizedTextByKey(locKey));
    checkboxLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    checkboxLabel.BindProperty(n"tintColor", n"MainColors.White");
    checkboxLabel.Reparent(checkboxWrapper);
    return checkboxWrapper;
  }
  public static final func BuildDestinationSelector() -> ref<inkWidget> {
    let destinationPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
    destinationPanel.SetName(n"destinationPanel");
    let header: ref<inkText> = new inkText();
    header.SetName(n"destinationSelectHeader");
    header.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    header.SetFontSize(50);
    header.SetFontStyle(n"Regular");
    header.SetAnchor(inkEAnchor.CenterLeft);
    header.SetAnchorPoint(new Vector2(0.0, 0.5));
    header.SetMargin(new inkMargin(0.0, 0.0, 0.0, 8.0));
    header.SetLetterCase(textLetterCase.OriginalCase);
    header.SetText(GetLocalizedTextByKey(n"Mod-VAD-Shipment-Destination"));
    header.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    header.BindProperty(n"tintColor", n"MainColors.Blue");
    header.Reparent(destinationPanel);
    let scrollWrapper: ref<inkCanvas> = new inkCanvas();
    scrollWrapper.SetName(n"scrollWrapper");
    scrollWrapper.SetHAlign(inkEHorizontalAlign.Fill);
    scrollWrapper.SetVAlign(inkEVerticalAlign.Top);
    scrollWrapper.SetMargin(new inkMargin(0.0, 12.0, 0.0, 12.0));
    scrollWrapper.SetSize(660.0, 560.0);
    scrollWrapper.SetInteractive(true);
    let scrollArea: ref<inkScrollArea> = new inkScrollArea();
    scrollArea.SetName(n"scrollArea");
    scrollArea.SetAnchor(inkEAnchor.Fill);
    scrollArea.SetMargin(new inkMargin(0, 0, 16.0, 0));
    scrollArea.fitToContentDirection = inkFitToContentDirection.Horizontal;
    scrollArea.useInternalMask = true;
    scrollArea.Reparent(scrollWrapper, -1);
    let sliderArea: ref<inkCanvas> = new inkCanvas();
    sliderArea.SetName(n"sliderArea");
    sliderArea.SetAnchor(inkEAnchor.RightFillVerticaly);
    sliderArea.SetSize(15.0, 0.0);
    sliderArea.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));
    sliderArea.SetInteractive(true);
    sliderArea.Reparent(scrollWrapper, -1);
    let sliderFill: ref<inkRectangle> = new inkRectangle();
    sliderFill.SetName(n"sliderFill");
    sliderFill.SetAnchor(inkEAnchor.Fill);
    sliderFill.SetOpacity(0.05);
    sliderFill.Reparent(sliderArea, -1);
    let sliderHandle: ref<inkRectangle> = new inkRectangle();
    sliderHandle.SetName(n"sliderHandle");
    sliderHandle.SetAnchor(inkEAnchor.TopFillHorizontaly);
    sliderHandle.SetSize(15.0, 40.0);
    sliderHandle.SetInteractive(true);
    sliderHandle.Reparent(sliderArea, -1);
    let sliderController: ref<inkSliderController> = new inkSliderController();
    sliderController.slidingAreaRef = inkWidgetRef.Create(sliderArea);
    sliderController.handleRef = inkWidgetRef.Create(sliderHandle);
    sliderController.direction = inkESliderDirection.Vertical;
    sliderController.autoSizeHandle = true;
    sliderController.percentHandleSize = 0.4;
    sliderController.minHandleSize = 40.0;
    sliderController.Setup(0, 1, 0, 0);
    let scrollController: ref<inkScrollController> = new inkScrollController();
    scrollController.ScrollArea = inkScrollAreaRef.Create(scrollArea);
    scrollController.VerticalScrollBarRef = inkWidgetRef.Create(sliderArea);
    scrollController.autoHideVertical = true;
    scrollWrapper.Reparent(destinationPanel);
    let components: ref<inkVerticalPanel> = new inkVerticalPanel();
    components.SetName(n"components");
    components.Reparent(scrollArea);
    sliderFill.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    sliderFill.BindProperty(n"tintColor", n"MainColors.Red");
    sliderHandle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    sliderHandle.BindProperty(n"tintColor", n"MainColors.Red");
    sliderArea.AttachController(sliderController);
    scrollWrapper.AttachController(scrollController);
    let spawnSystem: ref<AtelierDropPointsSpawner> = AtelierDropPointsSpawner.Get(GetGameInstance());
    let dropPoints: array<ref<AtelierDropPointInstance>> = spawnSystem.GetAvailableDropPoints();
    let component: ref<OrderCheckoutDestinationItem>;
    for dropPoint in dropPoints {
      component = OrderCheckoutDestinationItem.Create(dropPoint);
      component.Reparent(components);
    };
    // Auto select first drop point
    if NotEquals(ArraySize(dropPoints), 0) {
      GameInstance.GetUISystem(GetGameInstance()).QueueEvent(AtelierDestinationSelectedEvent.Create(dropPoints[0]));
    };
    return destinationPanel;
  }
  public static final func BuildDropPointPreviewContainer() -> ref<inkCompoundWidget> {
    let dropPointPreview: ref<inkCanvas> = new inkCanvas();
    dropPointPreview.SetName(n"dropPointPreview");
    dropPointPreview.SetSize(680.0, 300.0);
    dropPointPreview.SetAnchor(inkEAnchor.BottomRight);
    dropPointPreview.SetAnchorPoint(1.0, 1.0);
    dropPointPreview.SetMargin(new inkMargin(0.0, 0.0, 32.0, 16.0));
    let dropPointPreviewImage: ref<inkImage> = new inkImage();
    dropPointPreviewImage.SetName(n"image");
    dropPointPreviewImage.SetSize(680.0, 300.0);
    dropPointPreviewImage.Reparent(dropPointPreview);
    let dropPointPreviewFrame: ref<inkImage> = new inkImage();
    dropPointPreviewFrame.SetName(n"frame");
    dropPointPreviewFrame.SetNineSliceScale(true);
    dropPointPreviewFrame.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    dropPointPreviewFrame.SetBrushTileType(inkBrushTileType.NoTile);
    dropPointPreviewFrame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    dropPointPreviewFrame.SetTexturePart(n"item_grid_frame");
    dropPointPreviewFrame.SetAnchor(inkEAnchor.Fill);
    dropPointPreviewFrame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    dropPointPreviewFrame.BindProperty(n"tintColor", n"MainColors.Red");
    dropPointPreviewFrame.SetOpacity(0.5);
    dropPointPreviewFrame.Reparent(dropPointPreview);
    return dropPointPreview;
  }
}
// Fix message preview displaying
@wrapMethod(MessengerUtils)
private final static func SetTitle(out contactData: ref<ContactData>, conversationEntry: wref<JournalPhoneConversation>) -> Void {
  wrappedMethod(contactData, conversationEntry);
  if Equals(contactData.id, "virtual_atelier_delivery") {
    contactData.hasValidTitle = false;
  };
}
// Forcefully add last entry hash if unreadMessages does not have it,
// for cases when all custom journal entries are visited already
@wrapMethod(MessengerUtils)
public final static func GetContactMessageData(out contactData: ref<ContactData>, journal: ref<JournalManager>, const messagesReceived: script_ref<[wref<JournalEntry>]>, const playerReplies: script_ref<[wref<JournalEntry>]>) -> Void {
  wrappedMethod(contactData, journal, messagesReceived, playerReplies);
  let deliveryMessenger: ref<DeliveryMessengerSystem>;
  let entryHash: Int32;
  if Equals(contactData.contactId, "virtual_atelier_delivery") {
    deliveryMessenger = DeliveryMessengerSystem.Get(GetGameInstance());
    entryHash = deliveryMessenger.GetLastEntryHash();
    if deliveryMessenger.HasUnreadMessage() && !ArrayContains(contactData.unreadMessages, entryHash) {
      ArrayPush(contactData.unreadMessages, entryHash);
    };
  };
}
// Reset persisted unread state on chat opening
@wrapMethod(PhoneContactItemVirtualController)
public final func OpenInChat() -> Void {
  wrappedMethod();
  if Equals(this.m_contactData.contactId, "virtual_atelier_delivery") {
    DeliveryMessengerSystem.Get(GetGameInstance()).ResetUnreadMessage();
  };
}
public class DeliveryMessengerSystem extends ScriptableSystem {
  persistent let history: array<ref<DeliveryHistoryItem>>;
  persistent let uniqueIndex: Int32 = 0;
  persistent let hasUnreadMessage: Bool = false;
  private let conversation: wref<JournalPhoneConversation>;
  public static func Get(gi: GameInstance) -> ref<DeliveryMessengerSystem> {
    let system: ref<DeliveryMessengerSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.DeliveryMessengerSystem") as DeliveryMessengerSystem;
    return system;
  }
  private func OnAttach() -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };
    let token: ref<ResourceToken> = GameInstance.GetResourceDepot().LoadResource(r"djkovrik\\atelier\\delivery.journal");
    token.RegisterCallback(this, n"OnJournalLoaded");
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Session/Ready", this, n"OnSessionReady")
      .SetLifetime(CallbackLifetime.Session);
  }
  private cb func OnJournalLoaded(token: ref<ResourceToken>) {
    this.Log("OnJournalLoaded");
    let journal: ref<gameJournalResource> = token.GetResource() as gameJournalResource;
    let journalRoot: ref<gameJournalRootFolderEntry> = journal.entry as gameJournalRootFolderEntry;
    let primaryFolder: ref<gameJournalPrimaryFolderEntry> = journalRoot.entries[0] as gameJournalPrimaryFolderEntry;
    let contact: ref<JournalContact> = primaryFolder.entries[0] as JournalContact;
    this.conversation = contact.entries[0] as JournalPhoneConversation;
  }
  private cb func OnSessionReady(event: ref<GameSessionEvent>) {
    this.ApplyPersistedTextsToConversation();
  }
  private final func UnlockNewContact() -> Void {
    this.Log("UnlockNewContact");
    let journalManager: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGameInstance());
    journalManager.ChangeEntryState("contacts/virtual_atelier_delivery", "gameJournalContact", gameJournalEntryState.Active, JournalNotifyOption.Notify);
    journalManager.ChangeEntryState("contacts/virtual_atelier_delivery/notifications", "gameJournalPhoneConversation", gameJournalEntryState.Active, JournalNotifyOption.Notify);
  }
  public final func HasUnreadMessage() -> Bool {
    return this.hasUnreadMessage;
  }
  public final func ResetUnreadMessage() -> Void {
    this.hasUnreadMessage = false;
  }
  public final func GetLastEntryHash() -> Int32 {
    let journalManager: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGameInstance());
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    let currentConversationMessages: array<ref<JournalEntry>> = this.conversation.entries;
    let lastIndex: Int32 = ArraySize(currentHistory) - 1;
    return journalManager.GetEntryHash(currentConversationMessages[lastIndex]);
  }
  public final func PushWelcomeNotificationItem() -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Welcome();
    this.PushNewNotificationItem(item);
  }
  public final func PushNewDropPointNotificationItem(dropPoint: AtelierDeliveryDropPoint, district: TweakDBID) -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.NewDropPoint(dropPoint, district);
    this.PushNewNotificationItem(item);
  }
  public final func PushShippedNotificationItem(bundle: ref<PurchasedAtelierBundle>) -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Shipped(bundle.GetOrderId(), bundle.GetStoreName(), bundle.GetDeliveryPoint(), bundle.GetNextStatusUpdateDiff());
    this.PushNewNotificationItem(item);
  }
  public final func PushArrivedNotificationItem(bundle: ref<PurchasedAtelierBundle>) -> Void {
    let item: ref<DeliveryHistoryItem> = DeliveryHistoryItem.Arrived(bundle.GetOrderId(), bundle.GetStoreName(), bundle.GetDeliveryPoint());
    this.PushNewNotificationItem(item);
  }
  public final func PushNewNotificationItem(item: ref<DeliveryHistoryItem>) -> Void {
    this.Log(s"PushNewNotificationItem \(item.LocalizedString())");
    let relatedEntriesCount: Int32 = ArraySize(this.conversation.entries);
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    this.uniqueIndex = this.uniqueIndex + 1;
    item = DeliveryHistoryItem.WrapWithIndex(item, this.uniqueIndex);
    ArrayPush(currentHistory, item);
    let updatedHistory: array<ref<DeliveryHistoryItem>> = this.TakeLast(currentHistory, relatedEntriesCount);
    this.history = updatedHistory;
    this.ApplyPersistedTextsToConversation();
    this.NotifyAboutLastHistoryItem();
  }
  private final func ApplyPersistedTextsToConversation() -> Void {
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    this.Log(s"ApplyPersistedTextsToConversation, persistend history size: \(ArraySize(currentHistory))");
    let message: ref<JournalPhoneMessage>;
    let messageText: String;
    let historyItem: ref<DeliveryHistoryItem>;
    let lastIndex: Int32 = ArraySize(currentHistory) - 1;
    let index: Int32 = 0;
    let path: String;
    while index <= lastIndex {
      message = this.conversation.entries[index] as JournalPhoneMessage;
      path = s"contacts/virtual_atelier_delivery/notifications/\(message.GetId())";
      historyItem = currentHistory[index];
      messageText = historyItem.LocalizedString();
      message.text = CreateLocalizationString(messageText);
      index += 1;
      this.Log(s" - updated \(path) text");
    };
  }
  private final func NotifyAboutLastHistoryItem() -> Void {
    this.Log("NotifyAboutLastHistoryItem");
    let journalManager: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGameInstance());
    let currentHistory: array<ref<DeliveryHistoryItem>> = this.history;
    let currentConversationMessages: array<ref<JournalEntry>> = this.conversation.entries;
    let lastIndex: Int32 = ArraySize(currentHistory) - 1;
    let lastMessage: ref<JournalPhoneMessage> = currentConversationMessages[lastIndex] as JournalPhoneMessage;
    let path: String = s"contacts/virtual_atelier_delivery/notifications/\(lastMessage.GetId())";
    this.Log(s" - notify about \(path)");
    this.hasUnreadMessage = true;
    journalManager.ChangeEntryState(path, s"gameJournalPhoneMessage", gameJournalEntryState.Inactive, JournalNotifyOption.DoNotNotify);
    journalManager.ChangeEntryState(path, s"gameJournalPhoneMessage", gameJournalEntryState.Active, JournalNotifyOption.Notify);
  }
  private final func TakeLast(items: array<ref<DeliveryHistoryItem>>, n: Int32) -> array<ref<DeliveryHistoryItem>> {
    this.Log(s"TakeLast \(ArraySize(items)) items, n = \(n)");
    let size: Int32 = ArraySize(items);
    if size <= n {
      this.Log(s"TakeLast input and output size \(ArraySize(items))");
      return items;
    };
    let result: array<ref<DeliveryHistoryItem>>;
    let lastIndex: Int32 = size - 1;
    let firstIndex: Int32 = lastIndex - n + 1;
    let i: Int32 = firstIndex;
    while i <= lastIndex {
      ArrayPush(result, items[i]);
      i += 1;
    };
    this.Log(s"TakeLast input size \(ArraySize(items)), output size \(ArraySize(result))");
    return result;
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryMessenger", str);
    };
  }
}
public class OpenVaDeliveryUI extends ActionBool {
  public final func SetProperties() -> Void {
    this.actionName = n"OpenVaDeliveryUI";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#8783", n"LocKey#8783");
  }
}
@addMethod(DropPointControllerPS)
protected final func ActionOpenVaDeliveryUI(executor: ref<GameObject>) -> ref<OpenVaDeliveryUI> {
  let action: ref<OpenVaDeliveryUI> = new OpenVaDeliveryUI();
  action.clearanceLevel = 2;
  action.SetUp(this);
  action.SetProperties();
  action.SetExecutor(executor);
  action.AddDeviceName(this.m_deviceName);
  action.CreateInteraction();
  action.CreateActionWidgetPackage();
  return action;
}
@addField(DropPointControllerPS)
private let dropPointsSpawner: wref<AtelierDropPointsSpawner>;
@addField(DropPointControllerPS)
private let ordersSystem: wref<OrderProcessingSystem>;
@addMethod(DropPointControllerPS)
protected cb func OnInstantiated() -> Bool {
  super.OnInstantiated();
  this.dropPointsSpawner = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  this.ordersSystem = OrderProcessingSystem.Get(this.GetGameInstance());
}
@addMethod(DropPointControllerPS)
protected final func OnOpenVaDeliveryUI(evt: ref<OpenVaDeliveryUI>) -> EntityNotificationType {
  let entityId: EntityID = this.GetMyEntityID();
  let dropPointTag: CName = this.dropPointsSpawner.GetUniqueTagByEntityId(entityId);
  this.ordersSystem.GetArrivedItems(dropPointTag);
  return EntityNotificationType.DoNotNotifyEntity;
}
@wrapMethod(DropPointControllerPS)
public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
  let dps: ref<DropPointSystem>;
  if !super.GetActions(outActions, context) {
    return false;
  };
  dps = this.GetDropPointSystem();
  if !dps.IsEnabled() {
    return false;
  };
  let entityId: EntityID = this.GetMyEntityID();
  if this.dropPointsSpawner.IsCustomDropPoint(entityId) {
    ArrayPush(outActions, this.ActionOpenVaDeliveryUI(context.processInitiatorObject));
    this.SetActionIllegality(outActions, this.m_illegalActions.regularActions);
    return true;
  }
  return wrappedMethod(outActions, context);
}
@addMethod(UIMenuNotificationQueue)
protected cb func OnAtelierDeliveryOrderCreatedEvent(evt: ref<AtelierDeliveryOrderCreatedEvent>) -> Bool {
  let message: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Created-Nofitication");
  let messageToDisplay: String = StrReplace(message, "{id}", IntToString(evt.id));
  let userData: ref<UIMenuNotificationViewData> = new UIMenuNotificationViewData();
  let notificationData: gameuiGenericNotificationData;
  userData.title = messageToDisplay;
  userData.soundEvent = n"QuestSuccessPopup";
  userData.soundAction = n"OnOpen";
  notificationData.time = this.m_duration;
  notificationData.widgetLibraryResource = r"djkovrik\\gameplay\\gui\\fullscreen\\hub_menu\\va_notification.inkwidget";
  notificationData.widgetLibraryItemName = n"popups_side";
  notificationData.notificationData = userData;
  this.AddNewNotificationData(notificationData);
}
public class OrderCheckoutDestinationItem extends inkComponent {
  private let data: ref<AtelierDropPointInstance>;
  private let title: ref<inkText>;
  private let subtitle: ref<inkText>;
  private let selection: ref<inkWidget>;
  private let hovered: Bool;
  private let selected: Bool;
  public final static func Create(item: ref<AtelierDropPointInstance>) -> ref<OrderCheckoutDestinationItem> {
    let instance: ref<OrderCheckoutDestinationItem> = new OrderCheckoutDestinationItem();
    instance.data = item;
    return instance;
  }
  protected cb func OnCreate() -> ref<inkWidget> {
    let wrapper: ref<inkCanvas> = new inkCanvas();
    wrapper.SetName(n"wrapper");
    wrapper.SetInteractive(true);
    wrapper.SetSize(640.0, 100.0);
    let selection: ref<inkImage> = new inkImage();
    selection.SetName(n"selection");
    selection.SetFitToContent(true);
    selection.SetAnchor(inkEAnchor.Fill);
    selection.SetAnchorPoint(0.5, 0.5);
    selection.SetHAlign(inkEHorizontalAlign.Fill);
    selection.SetVAlign(inkEVerticalAlign.Fill);
    selection.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    selection.BindProperty(n"tintColor", n"MainColors.Red");
    selection.SetOpacity(0.2);
    selection.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    selection.SetTexturePart(n"cell_fg");
    selection.SetNineSliceScale(true);
    selection.useExternalDynamicTexture = true;
    selection.SetVisible(false);
    selection.Reparent(wrapper);
    let panel: ref<inkVerticalPanel> = new inkVerticalPanel();
    panel.SetName(n"panel");
    panel.SetAnchor(inkEAnchor.CenterLeft);
    panel.SetAnchorPoint(0.0, 0.5);
    panel.Reparent(wrapper);
    let title: ref<inkText> = new inkText();
    title.SetName(n"title");
    title.SetFitToContent(true);
    title.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    title.SetFontSize(34);
    title.SetFontStyle(n"Regular");
    title.SetAnchor(inkEAnchor.CenterLeft);
    title.SetAnchorPoint(new Vector2(0.0, 0.5));
    title.SetMargin(new inkMargin(16.0, 0.0, 16.0, 0.0));
    title.SetLetterCase(textLetterCase.OriginalCase);
    title.SetText("Drop point name");
    title.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    title.BindProperty(n"tintColor", n"MainColors.White");
    title.Reparent(panel);
    let subtitle: ref<inkText> = new inkText();
    subtitle.SetName(n"subtitle");
    subtitle.SetFitToContent(false);
    subtitle.SetSize(600.0, 40.0);
    subtitle.SetWrapping(false, 580, textWrappingPolicy.PerCharacter);
    subtitle.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    subtitle.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    subtitle.SetFontSize(32);
    subtitle.SetFontStyle(n"Regular");
    subtitle.SetAnchor(inkEAnchor.CenterLeft);
    subtitle.SetAnchorPoint(new Vector2(0.0, 0.5));
    subtitle.SetMargin(new inkMargin(16.0, 0.0, 16.0, 0.0));
    subtitle.SetLetterCase(textLetterCase.OriginalCase);
    subtitle.SetText("District, subdistrict");
    subtitle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    subtitle.BindProperty(n"tintColor", n"MainColors.White");
    subtitle.SetOpacity(0.25);
    subtitle.Reparent(panel);
    return wrapper;
  }
  protected cb func OnInitialize() {
    this.InitializeWidgets();
    this.RegisterInputListeners();
    this.RefreshData();
  }
  protected cb func OnUninitialize() {
    this.UnregisterInputListeners();
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.PlaySound(n"Button", n"OnHover");
    this.hovered = true;
    this.UpdateState();
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.hovered = false;
    this.UpdateState();
  }
  protected cb func OnClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      this.QueueEvent(AtelierDestinationSelectedEvent.Create(this.data));
    };
  }
  protected cb func OnAtelierDestinationSelectedEvent(evt: ref<AtelierDestinationSelectedEvent>) -> Bool {
    this.selected = Equals(this.data.type, evt.data.type);
    this.UpdateState();
  }
  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.title = root.GetWidgetByPathName(n"panel/title") as inkText;
    this.subtitle = root.GetWidgetByPathName(n"panel/subtitle") as inkText;
    this.selection = root.GetWidgetByPathName(n"selection");
  }
  private final func RefreshData() -> Void {
    this.title.SetText(GetLocalizedText(this.data.locKey));
    this.subtitle.SetText(this.GetDistrictLabel());
  }
  private final func UpdateState() -> Void {
    this.selection.SetVisible(this.selected);
    let textColor: CName;
    let outlineColor: CName;
    if !this.hovered && !this.selected {
      textColor = n"MainColors.White";
      outlineColor = n"MainColors.Red";
    } else if !this.hovered && this.selected {
      textColor = n"MainColors.Red";
      outlineColor = n"MainColors.Red";
    } else if this.hovered && !this.selected {
      textColor = n"MainColors.Red";
      outlineColor = n"MainColors.Red";
    } else if this.hovered && this.selected {
      textColor = n"MainColors.ActiveRed";
      outlineColor = n"MainColors.ActiveRed";
    };
    this.title.BindProperty(n"tintColor", textColor);
    this.selection.BindProperty(n"tintColor", outlineColor);
  }
  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }
  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }
  private final func GetDistrictLabel() -> String {
    let parentDistrict: ref<District_Record> = TweakDBInterface.GetRecord(this.data.parentDistrict) as District_Record;
    let district: ref<District_Record> = TweakDBInterface.GetRecord(this.data.actualDistrict) as District_Record;
    let parentDistrictName: String = GetLocalizedText(parentDistrict.LocalizedName());
    let districtName: String = GetLocalizedText(district.LocalizedName());
    if NotEquals(parentDistrictName, districtName) {
      return s"\(parentDistrictName), \(districtName)";
    };
    return districtName;
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryItem", str);
    };
  }
}
public class OrderCheckoutPopup extends InMenuPopup {
  let params: ref<AtelierDeliveryPopupParams>;
  let timeSystem: wref<TimeSystem>;
  let ordersSystem: wref<OrderProcessingSystem>;
  let uiSystem: wref<UISystem>;
  let buttonCancel: wref<PopupButton>;
  let buttonConfirm: wref<PopupButton>;
  let component: wref<OrderCheckoutPopupComponent>;
  public final static func Show(requester: ref<inkGameController>, params: ref<AtelierDeliveryPopupParams>, timeSystem: ref<TimeSystem>, ordersSystem: ref<OrderProcessingSystem>, uiSystem: ref<UISystem>) -> Void {
    let popup: ref<OrderCheckoutPopup> = new OrderCheckoutPopup();
    popup.params = params;
    popup.timeSystem = timeSystem;
    popup.ordersSystem = ordersSystem;
    popup.uiSystem = uiSystem;
    popup.Open(requester);
  }
  protected cb func OnCreate() -> Void {
    super.OnCreate();
    let content: ref<InMenuPopupContent> = InMenuPopupContent.Create();
    content.SetTitle(s"\(GetLocalizedTextByKey(n"Mod-VAD-Order-Secure-Payment")) - \(GetLocalizedTextByKey(n"Mod-VAD-Order")) #\(this.params.orderId)");
    content.Reparent(this);
    let component: ref<OrderCheckoutPopupComponent> = OrderCheckoutPopupComponent.Create(this.params);
    component.Reparent(content.GetContainerWidget());
    this.component = component;
    let footer: ref<InMenuPopupFooter> = InMenuPopupFooter.Create();
    footer.Reparent(this);
    let buttonCancel: ref<PopupButton> = PopupButton.Create();
    buttonCancel.SetName(n"buttonCancel");
    buttonCancel.SetText(GetLocalizedText("LocKey#22175"));
    buttonCancel.SetInputAction(n"cancel");
    buttonCancel.Reparent(footer);
    this.buttonCancel = buttonCancel;
    let buttonConfirm: ref<PopupButton> = PopupButton.Create();
    buttonConfirm.SetName(n"buttonConfirm");
    buttonConfirm.SetText(GetLocalizedTextByKey(n"UI-ResourceExports-Confirm"));
    buttonConfirm.SetInputAction(n"one_click_confirm");
    buttonConfirm.Reparent(footer);
    this.buttonConfirm = buttonConfirm;
  }
  public func UseCursor() -> Bool {
    return true;
  }
  protected cb func OnConfirm() -> Void {
    let newOrder: ref<PurchasedAtelierBundle> = this.component.GetOrderBundle();
    let currentTimestamp: Float = this.timeSystem.GetGameTimeStamp();
    newOrder.SetPurchaseTimestamp(currentTimestamp);
    let id: Int32 = this.ordersSystem.AddNewOrder(newOrder);
    this.uiSystem.QueueEvent(AtelierDeliveryOrderCreatedEvent.Create(id, newOrder.GetTotalPrice()));
  }
  protected cb func OnCancel() -> Void {
    this.PlaySound(n"Button", n"OnPress");
  }
  protected cb func OnShown() {}
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryPopup", str);
    };
  }
}
public class OrderCheckoutPopupComponent extends inkComponent {
  let params: ref<AtelierDeliveryPopupParams>;
  let config: ref<VirtualAtelierDeliveryConfig>;
  let customerName: wref<inkText>;
  let storeName: wref<inkText>;
  let itemsQuantity: wref<inkText>;
  let itemsWeight: wref<inkText>;
  let itemsSubtotal: wref<inkText>;
  let checkboxStandard: wref<inkWidget>;
  let checkboxStandardFrame: wref<inkWidget>;
  let checkboxStandardThumb: wref<inkWidget>;
  let checkboxPriority: wref<inkWidget>;
  let checkboxPriorityFrame: wref<inkWidget>;
  let checkboxPriorityThumb: wref<inkWidget>;
  let shippingCost: wref<inkText>;
  let shippingTime: wref<inkText>;
  let orderTotal: wref<inkText>;
  let dropPointPreview: wref<inkImage>;
  let selectedDeliveryType: AtelierDeliveryType;
  let selectedDropPoint: AtelierDeliveryDropPoint;
  let totalOrderPrice: Int32;
  public final static func Create(params: ref<AtelierDeliveryPopupParams>) -> ref<OrderCheckoutPopupComponent> {
    let instance: ref<OrderCheckoutPopupComponent> = new OrderCheckoutPopupComponent();
    instance.params = params;
    instance.config = new VirtualAtelierDeliveryConfig();
    return instance;
  }
  public final func GetOrderBundle() -> ref<PurchasedAtelierBundle> {
    let bundle: ref<PurchasedAtelierBundle> = PurchasedAtelierBundle.Create(this.params, this.totalOrderPrice, this.selectedDeliveryType, this.selectedDropPoint);
    return bundle;
  }
  protected cb func OnCreate() -> ref<inkWidget> {
    return LayoutsBuilder.CheckoutContainer();
  }
  protected cb func OnInitialize() -> Void {
    this.InitializeWidgets();
    this.RegisterInputListeners();
    this.PopulateOrderData();
    this.StandardDeliveryClicked();
  }
  protected cb func OnUninitialize() -> Void {
    this.UnregisterInputListeners();
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let name: CName = target.GetName();
    if Equals(name, n"checkboxStandard") && this.params.enoughForStandard {
      this.checkboxStandardFrame.BindProperty(n"tintColor", n"MainColors.Blue");
      this.checkboxStandardThumb.BindProperty(n"tintColor", n"MainColors.Blue");
    } else if Equals(name, n"checkboxPriority") && this.params.enoughForPriority {
      this.checkboxPriorityFrame.BindProperty(n"tintColor", n"MainColors.Blue");
      this.checkboxPriorityThumb.BindProperty(n"tintColor", n"MainColors.Blue");
    };
    this.PlaySound(n"Button", n"OnHover");
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let name: CName = target.GetName();
    if Equals(name, n"checkboxStandard") && this.params.enoughForStandard {
      this.checkboxStandardFrame.BindProperty(n"tintColor", n"MainColors.MildRed");
      this.checkboxStandardThumb.BindProperty(n"tintColor", n"MainColors.MildRed");
    } else if Equals(name, n"checkboxPriority") && this.params.enoughForPriority {
      this.checkboxPriorityFrame.BindProperty(n"tintColor", n"MainColors.MildRed");
      this.checkboxPriorityThumb.BindProperty(n"tintColor", n"MainColors.MildRed");
    };
  }
  protected cb func OnStandardClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") && this.params.enoughForStandard {
      this.StandardDeliveryClicked();
      this.PlaySound(n"Button", n"OnPress");
    };
  }
  protected cb func OnPriorityClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") && this.params.enoughForPriority {
      this.PriorityDeliveryClicked();
      this.PlaySound(n"Button", n"OnPress");
    };
  }
  protected cb func OnAtelierDestinationSelectedEvent(evt: ref<AtelierDestinationSelectedEvent>) -> Bool {
    this.selectedDropPoint = evt.data.type;
    this.dropPointPreview.SetAtlasResource(evt.data.inkAtlas);
    this.dropPointPreview.SetTexturePart(evt.data.uniqueTag);
  }
  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.customerName = root.GetWidgetByPathName(n"leftColumn/customerInfo/content/firstRow/clientName") as inkText;
    this.storeName = root.GetWidgetByPathName(n"leftColumn/orderInfo/storeName") as inkText;
    this.itemsQuantity = root.GetWidgetByPathName(n"leftColumn/orderInfo/totalItems") as inkText;
    this.itemsWeight = root.GetWidgetByPathName(n"leftColumn/orderInfo/actualWeight") as inkText;
    this.itemsSubtotal = root.GetWidgetByPathName(n"leftColumn/orderInfo/subtotal") as inkText;
    this.checkboxStandard = root.GetWidgetByPathName(n"leftColumn/deliverySelector/deliveryCheckboxes/checkboxStandard");
    this.checkboxStandardFrame = root.GetWidgetByPathName(n"leftColumn/deliverySelector/deliveryCheckboxes/checkboxStandard/flexbox/border");
    this.checkboxStandardThumb = root.GetWidgetByPathName(n"leftColumn/deliverySelector/deliveryCheckboxes/checkboxStandard/flexbox/foreground");
    this.checkboxPriority = root.GetWidgetByPathName(n"leftColumn/deliverySelector/deliveryCheckboxes/checkboxPriority");
    this.checkboxPriorityFrame = root.GetWidgetByPathName(n"leftColumn/deliverySelector/deliveryCheckboxes/checkboxPriority/flexbox/border");
    this.checkboxPriorityThumb = root.GetWidgetByPathName(n"leftColumn/deliverySelector/deliveryCheckboxes/checkboxPriority/flexbox/foreground");
    this.shippingCost = root.GetWidgetByPathName(n"leftColumn/deliverySelector/shippingCost") as inkText;
    this.shippingTime = root.GetWidgetByPathName(n"leftColumn/deliverySelector/estimatedDelivery") as inkText;
    this.orderTotal = root.GetWidgetByPathName(n"leftColumn/total") as inkText;
    this.dropPointPreview = root.GetWidgetByPathName(n"dropPointPreview/image") as inkImage;
  }
  private final func RegisterInputListeners() -> Void {
    this.checkboxStandard.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.checkboxStandard.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.checkboxStandard.RegisterToCallback(n"OnRelease", this, n"OnStandardClick");
    this.checkboxPriority.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.checkboxPriority.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.checkboxPriority.RegisterToCallback(n"OnRelease", this, n"OnPriorityClick");
  }
  private final func UnregisterInputListeners() -> Void {
    this.checkboxStandard.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.checkboxStandard.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.checkboxStandard.UnregisterFromCallback(n"OnRelease", this, n"OnStandardClick");
    this.checkboxPriority.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.checkboxPriority.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.checkboxPriority.UnregisterFromCallback(n"OnRelease", this, n"OnPriorityClick");
  }
  private final func PopulateOrderData() -> Void {
    // Name
    let customerNameParams: ref<inkTextParams> = new inkTextParams();
    customerNameParams.AddLocalizedString("name", this.GetLocalizedCharacterName());
    this.customerName.SetText("{name} ******", customerNameParams);
    // Store
    this.storeName.SetText(this.params.store);
    // Quantity
    let quantityParams: ref<inkTextParams> = new inkTextParams();
    let quantityLabel: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Quantity");
    quantityParams.AddString("label", quantityLabel);
    quantityParams.AddNumber("quantity", this.params.quantity);
    this.itemsQuantity.SetText("{label} {quantity}", quantityParams);
    // Weight
    let weightParams: ref<inkTextParams> = new inkTextParams();
    let weightLabel: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Weight");
    weightParams.AddString("label", weightLabel);
    weightParams.AddNumber("weight", this.params.weight);
    this.itemsWeight.SetText("{label} {weight}", weightParams);
    // Subtotal
    let subtotalParams: ref<inkTextParams> = new inkTextParams();
    let subtotalLabel: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Subtotal");
    subtotalParams.AddString("label", subtotalLabel);
    subtotalParams.AddString("price", GetFormattedMoneyVAD(this.params.price));
    subtotalParams.AddLocalizedString("dollar", "Common-Characters-EuroDollar");
    this.itemsSubtotal.SetText("{label} {price}{dollar}", subtotalParams);
    // Checkbox
    if !this.params.enoughForPriority {
      this.checkboxPriority.SetOpacity(0.25);
    } else {
      this.checkboxPriority.SetOpacity(1);
    };
  }
  private final func RefreshShippingAndTotal() -> Void {
    let shippingPrice: Int32;
    let hoursMin: Int32;
    let hoursMax: Int32;
    if Equals(this.selectedDeliveryType, AtelierDeliveryType.Priority) {
      // Priority values
      shippingPrice = Cast<Int32>(this.params.weight * Cast<Float>(this.config.priorityDeliveryPrice));
      hoursMin = this.config.priorityDeliveryMin;
      hoursMax = this.config.priorityDeliveryMax;
      if hoursMin == hoursMax {
        hoursMax += 1;
      } else if hoursMin > hoursMax {
        hoursMin = this.config.priorityDeliveryMax;
        hoursMax = this.config.priorityDeliveryMin;
      };
    } else {
      // Standard values
      shippingPrice = this.config.standardDeliveryPrice;
      hoursMin = this.config.standardDeliveryMin;
      hoursMax = this.config.standardDeliveryMax;
      if hoursMin == hoursMax {
        hoursMax += 1;
      } else if hoursMin > hoursMax {
        hoursMin = this.config.standardDeliveryMax;
        hoursMax = this.config.standardDeliveryMin;
      };
    };
    this.totalOrderPrice = this.params.price + shippingPrice;
    this.Log(s"Refresh: shipping \(shippingPrice), \(hoursMax)-\(hoursMax) hrs, total \(this.totalOrderPrice)");
    // Shipping cost
    let shippingCostParams: ref<inkTextParams> = new inkTextParams();
    let shippingCostLabel: String = GetLocalizedTextByKey(n"Mod-VAD-Shipment-Cost");
    shippingCostParams.AddString("label", shippingCostLabel);
    shippingCostParams.AddString("cost", GetFormattedMoneyVAD(shippingPrice));
    shippingCostParams.AddLocalizedString("dollar", "Common-Characters-EuroDollar");
    this.shippingCost.SetText("{label} {cost}{dollar}", shippingCostParams);
    // Delivery time
    let deliveryTimeParams: ref<inkTextParams> = new inkTextParams();
    let deliveryTimeLabel: String = GetLocalizedTextByKey(n"Mod-VAD-Shipment-Time");
    let deliveryTimeLabelSuffix: String = GetLocalizedTextByKey(n"Mod-VAD-Time-Suffix-Hours");
    deliveryTimeParams.AddString("label", deliveryTimeLabel);
    deliveryTimeParams.AddNumber("min", hoursMin);
    deliveryTimeParams.AddNumber("max", hoursMax);
    deliveryTimeParams.AddString("suffix", deliveryTimeLabelSuffix);
    this.shippingTime.SetText("{label} {min}-{max}{suffix}", deliveryTimeParams);
    // Total
    let totalParams: ref<inkTextParams> = new inkTextParams();
    let totalLabel: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Total");
    totalParams.AddString("label", totalLabel);
    totalParams.AddString("price", GetFormattedMoneyVAD(this.totalOrderPrice));
    totalParams.AddLocalizedString("dollar", "Common-Characters-EuroDollar");
    this.orderTotal.SetText("{label} {price}{dollar}", totalParams);
  }
  private final func StandardDeliveryClicked() -> Void {
    this.selectedDeliveryType = AtelierDeliveryType.Standard;
    this.checkboxStandardThumb.SetVisible(true);
    this.checkboxPriorityThumb.SetVisible(false);
    this.RefreshShippingAndTotal();
  }
  private final func PriorityDeliveryClicked() -> Void {
    this.selectedDeliveryType = AtelierDeliveryType.Priority;
    this.checkboxStandardThumb.SetVisible(false);
    this.checkboxPriorityThumb.SetVisible(true);
    this.RefreshShippingAndTotal();
  }
  private final func GetLocalizedCharacterName() -> String {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    let gender: CName = player.GetResolvedGenderName();
    if Equals(gender, n"Male") {
      return "Gameplay-NPC-EthnicNames-AmericanEnglish-Male-Names-Vincent";
    };
    return "Gameplay-NPC-EthnicNames-AmericanEnglish-Female-Names-Valerie";
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryCheckout", str);
    };
  }
}
public class OrderManagerButton extends CustomButton {
    protected let m_bg: wref<inkImage>;
    protected let m_frame: wref<inkImage>;
    public final func SetVisible(visible: Bool) -> Void {
      this.m_root.SetVisible(visible);
    }
    protected func CreateWidgets() -> Void {
        let root: ref<inkFlex> = new inkFlex();
        root.SetName(n"button");
        root.SetInteractive(true);
        root.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
        root.SetAnchor(inkEAnchor.CenterRight);
        root.SetHAlign(inkEHorizontalAlign.Right);
        root.SetVAlign(inkEVerticalAlign.Center);
        root.SetSize(new Vector2(100.0, 100.0));
        let minSize: ref<inkRectangle> = new inkRectangle();
        minSize.SetName(n"minSize");
        minSize.SetVisible(false);
        minSize.SetAffectsLayoutWhenHidden(true);
        minSize.SetHAlign(inkEHorizontalAlign.Left);
        minSize.SetVAlign(inkEVerticalAlign.Top);
        minSize.SetSize(new Vector2(280.0, 80.0));
        minSize.Reparent(root);
        let frame: ref<inkImage> = new inkImage();
        frame.SetName(n"frame");
        frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        frame.SetTexturePart(n"cell_fg");
        frame.SetNineSliceScale(true);
        frame.SetVAlign(inkEVerticalAlign.Top);
        frame.SetAnchorPoint(new Vector2(0.5, 0.5));
        frame.SetSize(new Vector2(280.0, 80.0));
        frame.SetStyle(r"base\\gameplay\\gui\\common\\dialogs_popups.inkstyle");
        frame.BindProperty(n"tintColor", n"PopupButton.frameColor");
        frame.BindProperty(n"opacity", n"PopupButton.frameOpacity");
        frame.Reparent(root);
        let label: ref<inkText> = new inkText();
        label.SetName(n"label");
        label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        label.SetLetterCase(textLetterCase.UpperCase);
        label.SetHorizontalAlignment(textHorizontalAlignment.Center);
        label.SetVerticalAlignment(textVerticalAlignment.Center);
        label.SetContentHAlign(inkEHorizontalAlign.Center);
        label.SetContentVAlign(inkEVerticalAlign.Center);
        label.SetOverflowPolicy(textOverflowPolicy.AdjustToSize);
        label.SetFitToContent(true);
        label.SetVAlign(inkEVerticalAlign.Center);
        label.SetSize(new Vector2(100.0, 32.0));
        label.SetStyle(r"base\\gameplay\\gui\\common\\dialogs_popups.inkstyle");
        label.BindProperty(n"fontStyle", n"MainColors.BodyFontWeight");
        label.BindProperty(n"fontSize", n"MainColors.ReadableMedium");
        label.BindProperty(n"tintColor", n"PopupButton.textColor");
        label.BindProperty(n"opacity", n"PopupButton.textOpacity");
        label.Reparent(root);
        this.m_root = root;
        this.m_label = label;
        this.m_frame = frame;
        this.SetRootWidget(root);
    }
    protected func ApplyHoveredState() {
        this.m_root.SetState(this.m_isHovered ? n"Hover" : n"Default");
    }
    public func SetHoveredState(isHovered: Bool) -> Void {
      super.SetHoveredState(isHovered);
    }
    public static func Create() -> ref<OrderManagerButton> {
        let self: ref<OrderManagerButton> = new OrderManagerButton();
        self.CreateInstance();
        return self;
    }
}
public class OrderProcessingSystem extends ScriptableSystem {
  private let player: wref<PlayerPuppet>;
  private let timeSystem: wref<TimeSystem>;
  private let delaySystem: wref<DelaySystem>;
  private let questsSystem: wref<QuestsSystem>;
  private let transactionSystem: wref<TransactionSystem>;
  private let inventoryManager: wref<InventoryManager>;
  private let purchasedItems: array<ItemID>;
  private persistent let orders: array<ref<PurchasedAtelierBundle>>;
  private persistent let nextOrderId: Int32;
  private let receivedClearPeriod: Float;
  public static func Get(gi: GameInstance) -> ref<OrderProcessingSystem> {
    let system: ref<OrderProcessingSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.OrderProcessingSystem") as OrderProcessingSystem;
    return system;
  }
  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
    this.player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.timeSystem = GameInstance.GetTimeSystem(this.player.GetGame());
    this.delaySystem = GameInstance.GetDelaySystem(this.player.GetGame());
    this.questsSystem = GameInstance.GetQuestsSystem(this.player.GetGame());
    this.transactionSystem = GameInstance.GetTransactionSystem(this.player.GetGame());
    this.inventoryManager = GameInstance.GetInventoryManager(this.player.GetGame());
    this.receivedClearPeriod = 3600.0 * 12.0; // 12 hrs
    if Equals(this.nextOrderId, 0) {
      this.nextOrderId = 1;
    };
  }
  public final func GetNextOrderId() -> Int32 {
    return this.nextOrderId;
  }
  public final func HasActiveOrders() -> Bool {
    let currentOrders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let hasOrderToTrack: Bool = false;
    let status: AtelierDeliveryStatus;
    for order in currentOrders {
      status = order.GetDeliveryStatus();
      if Equals(status, AtelierDeliveryStatus.Created) || Equals(status, AtelierDeliveryStatus.Shipped) {
        hasOrderToTrack = true;
      };
    };
    return hasOrderToTrack;
  }
  public final func GetOrders() -> array<ref<PurchasedAtelierBundle>> {
    return this.orders;
  }
  public final func AddNewOrder(order: ref<PurchasedAtelierBundle>) -> Int32 {
    this.Log("New order saved: ");
    this.Log(s"- storeName: \(order.storeName)");
    this.Log(s"- orderId: \(order.orderId)");
    this.Log(s"- items count: \(ArraySize(order.purchasedItems))");
    this.Log(s"- totalPrice: \(order.totalPrice)");
    this.Log(s"- totalWeight: \(order.totalWeight)");
    this.Log(s"- deliveryType: \(order.deliveryType)");
    this.Log(s"- deliveryPoint: \(order.deliveryPoint)");
    this.Log(s"- deliveryStatus: \(order.deliveryStatus)");
    this.Log(s"- purchaseTimestamp: \(order.purchaseTimestamp)");
    this.Log(s"- shipmentTimestamp: \(order.shipmentTimestamp)");
    this.Log(s"- deliveryTimestamp: \(order.deliveryTimestamp)");
    this.Log(s"- receivedTimestamp: \(order.receivedTimestamp)");
    this.Log(s"- nextStatusUpdateDiff: \(order.nextStatusUpdateDiff)");
    ArrayPush(this.orders, order);
    this.RefreshOrdersState();
    let createdOrderId: Int32 = this.nextOrderId;
    this.nextOrderId = this.nextOrderId + 1;
    return createdOrderId;
  }
  public final func GetArrivedItems(tag: CName) -> Void {
    let dropPoint: AtelierDeliveryDropPoint = AtelierDeliveryUtils.GetDropPointByTag(tag);
    let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let arrivedOrders: array<ref<PurchasedAtelierBundle>>;
    for order in orders {
      if Equals(order.deliveryPoint, dropPoint) && Equals(order.deliveryStatus, AtelierDeliveryStatus.Arrived) {
        ArrayPush(arrivedOrders, order);
      };
    };
    this.Log(s"Trying to receive orders from \(dropPoint), detected: \(ArraySize(arrivedOrders))");
    let receivedAnything: Bool = false;
    let deliveredIds: array<Int32>;
    for arrivedOrder in arrivedOrders {
      this.GiveBundleItemsToPlayer(arrivedOrder);
      this.MarkOrderAsReceived(arrivedOrder);
      ArrayPush(deliveredIds, arrivedOrder.orderId);
      receivedAnything = true;
    };
    if receivedAnything {
      GameObject.PlaySound(this.player, n"ui_menu_item_bought");
      if Equals(ArraySize(deliveredIds), 1) {
        this.NotifyAboutOrderDelivery(deliveredIds[0]);
      } else {
        this.NotifyAboutOrdersDelivery(deliveredIds);
      };
    } else {
      GameObject.PlaySound(this.player, n"ui_menu_attributes_fail");
    };
    this.RefreshOrdersState();
  }
  public final func MarkOrderAsReceived(bundle: ref<PurchasedAtelierBundle>) -> Bool {
    let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let refreshedOrders: array<ref<PurchasedAtelierBundle>>;
    let orderWasFound: Bool = false;
    let now: Float;
    for order in orders {
      if Equals(order.GetOrderId(), bundle.GetOrderId()) && Equals(order.GetStoreName(), bundle.GetStoreName()) {
        now = this.timeSystem.GetGameTimeStamp();
        order.SetReceivedTimestamp(now);
        orderWasFound = true;
      };
      ArrayPush(refreshedOrders, order);
    };
    if orderWasFound {
      this.orders = refreshedOrders;
    };
    return orderWasFound;
  }
  @if(!ModuleExists("VendorPreview.Config"))
  private final func GiveBundleItemsToPlayer(bundle: ref<PurchasedAtelierBundle>) -> Void {
    // do nothing
  }
  @if(ModuleExists("VendorPreview.Config"))
  private final func GiveBundleItemsToPlayer(bundle: ref<PurchasedAtelierBundle>) -> Void {
    let cartItems: array<ref<WrappedVirtualCartItem>> = bundle.purchasedItems;
    let itemID: ItemID;
    let itemData: ref<gameItemData>;
    let stockItem: ref<WrappedVirtualStockItem>;
    // Add items
    ArrayClear(this.purchasedItems);
    for cartItem in cartItems {
      let i: Int32 = 0;
      while i < cartItem.purchaseAmount {
        stockItem = cartItem.stockItem;
        itemID = ItemID.FromTDBID(stockItem.id);
        ArrayPush(this.purchasedItems, itemID);
        itemData = this.inventoryManager.CreateBasicItemData(itemID, this.player);
        itemData.isVirtualItem = true;
        this.transactionSystem.GiveItem(this.player, itemID, stockItem.quantity);
        this.ScaleItem(this.player, itemData, stockItem.quality);
        i += 1;
      };
    };
  }
  public final func RefreshOrdersState() -> Void {
    let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let refreshedOrders: array<ref<PurchasedAtelierBundle>>;
    let now: Float = this.timeSystem.GetGameTimeStamp();
    let shipmentTimestamp: Float;
    let deliveryTimestamp: Float;   
    let receivedTimestamp: Float;   
    let diff: Float;
    for order in orders {
      shipmentTimestamp = order.GetShipmentTimestamp();
      deliveryTimestamp = order.GetDeliveryTimestamp();
      receivedTimestamp = order.GetReceivedTimestamp();
      if now < shipmentTimestamp {
        // not shipped yet
        diff = shipmentTimestamp - now;
        order.SetNextStatusUpdateDiff(diff);
        ArrayPush(refreshedOrders, order);
      } else if now > shipmentTimestamp && now < deliveryTimestamp {
        // already shipped, delivering in progress
        diff = deliveryTimestamp - now;
        order.SetNextStatusUpdateDiff(diff);
        order.SetDeliveryStatus(AtelierDeliveryStatus.Shipped);
        if !order.IsShipmentNotified() && !this.IsJohnny() && this.IsPhoneAvailable() {
          order.SetShipmentNotified();
          this.NotifyAboutOrderShipment(order);
        };
        ArrayPush(refreshedOrders, order);
      } else if now > deliveryTimestamp && Equals(receivedTimestamp, 0.0) {
        // ready for pickup
        order.SetNextStatusUpdateDiff(0.0);
        order.SetDeliveryStatus(AtelierDeliveryStatus.Arrived);
        if !order.IsArrivalNotified() && !this.IsJohnny() && this.IsPhoneAvailable() {
          order.SetArrivalNotified();
          this.NotifyAboutOrderArrival(order);
        };
        ArrayPush(refreshedOrders, order);
      } else if now - receivedTimestamp < this.receivedClearPeriod {
        // received already, check if order should be deleted from the list
        order.SetDeliveryStatus(AtelierDeliveryStatus.Delivered);
        ArrayPush(refreshedOrders, order);
      };
    };
    this.orders = refreshedOrders;
    this.PrintCurrentOrders();
    OrderTrackingTicker.Get(this.player.GetGame()).ScheduleCallbackLong();
  }
  public final func IsItemPurchased(itemID: ItemID) -> Bool {
    return ArrayContains(this.purchasedItems, itemID);
  }
  private final func IsJohnny() -> Bool {
    let playerSystem: ref<PlayerSystem> = GameInstance.GetPlayerSystem(this.GetGameInstance());
    let factName: String = playerSystem.GetPossessedByJohnnyFactName();
    let posessed: Bool = GameInstance.GetQuestsSystem(this.GetGameInstance()).GetFactStr(factName) == 1;
    let puppet: ref<PlayerPuppet> = playerSystem.GetLocalPlayerMainGameObject() as PlayerPuppet;
    let isReplacer: Bool = puppet.IsJohnnyReplacer();
    return posessed || isReplacer;
  }
  private final func IsPhoneAvailable() -> Bool {
    let phoneSystem: wref<PhoneSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"PhoneSystem") as PhoneSystem;
    if IsDefined(phoneSystem) {
      return phoneSystem.IsPhoneEnabled();
    };
    return false;
  }
  private final func NotifyAboutOrderShipment(bundle: ref<PurchasedAtelierBundle>) -> Void {
    this.Log(s"! Order \(bundle.GetOrderId()) from \(bundle.GetStoreName()) is shipped");
    DeliveryMessengerSystem.Get(this.player.GetGame()).PushShippedNotificationItem(bundle);
  }
  private final func NotifyAboutOrderArrival(bundle: ref<PurchasedAtelierBundle>) -> Void {
    this.Log(s"! Order \(bundle.GetOrderId()) from \(bundle.GetStoreName()) is ready for pickup at \(bundle.GetDeliveryPoint())");
    DeliveryMessengerSystem.Get(this.player.GetGame()).PushArrivedNotificationItem(bundle);
  }
  private final func NotifyAboutOrderDelivery(id: Int32) -> Void {
    let onScreenMessage: SimpleScreenMessage;
    let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.player.GetGame()).Get(blackboardDef);
    let message: String = GetLocalizedTextByKey(n"Mod-VAD-Order-Delivered-Nofitication");
    let messageToDisplay: String = StrReplace(message, "{id}", IntToString(id));
    onScreenMessage.message = messageToDisplay;
    onScreenMessage.isShown = true;
    onScreenMessage.duration = 3.0;
    blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
  }
  private final func NotifyAboutOrdersDelivery(ids: array<Int32>) -> Void {
    let onScreenMessage: SimpleScreenMessage;
    let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.player.GetGame()).Get(blackboardDef);
    let messageToDisplay: String = s"\(GetLocalizedTextByKey(n"Mod-VAD-Orders-Delivered-Nofitication")) ";
    let count: Int32 = ArraySize(ids);
    let lastIndex: Int32 = count - 1;
    let i: Int32 = 0;
    while i < count {
      if NotEquals(i, lastIndex) {
        messageToDisplay += s"#\(ids[i]), ";
      } else {
        messageToDisplay += s"#\(ids[i])";
      };
      i += 1;
    };
    onScreenMessage.message = messageToDisplay;
    onScreenMessage.isShown = true;
    onScreenMessage.duration = 3.0;
    blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
  }
  private final func PrintCurrentOrders() -> Void {
     let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
     this.Log("Active orders: ");
     for order in orders {
      this.PrintOrderStatus(order);
     }
  }
  private final func PrintOrderStatus(order: ref<PurchasedAtelierBundle>) -> Void {
    let info: String = s"- id #\(order.GetOrderId()) from \(order.GetStoreName()): \(order.GetDeliveryStatus()) [\(order.GetDeliveryPoint())]";
    let diff: Float = order.GetNextStatusUpdateDiff();
    if diff > 0.0 {
      info += s" [next status change: \(AtelierDeliveryUtils.PrettifyTimestampValue(diff))]";
    }
    this.Log(info);
  }
  @if(!ModuleExists("VirtualAtelier.Helpers"))
  private final func ScaleItem(player: ref<PlayerPuppet>, itemData: ref<gameItemData>, quality: CName) {
    // atelier not installed
  }
  @if(ModuleExists("VirtualAtelier.Helpers"))
  private final func ScaleItem(player: ref<PlayerPuppet>, itemData: ref<gameItemData>, quality: CName) {
    AtelierItemsHelper.ScaleItem(this.player, itemData, quality);
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryOrders", str);
    };
  }
}
public class OrdersManagerComponent extends inkComponent {
  let player: wref<GameObject>;
  let system: wref<OrderProcessingSystem>;
  let ticker: wref<OrderTrackingTicker>;
  let orders: array<ref<PurchasedAtelierBundle>>;
  let components: wref<inkCompoundWidget>;
  let scrollWrapper: wref<inkWidget>;
  let emptyPlaceholder: wref<inkText>;
  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetAnchor(inkEAnchor.Fill);
    root.SetAnchorPoint(0.5, 0.5);
    let scrollWrapper: ref<inkCanvas> = new inkCanvas();
    scrollWrapper.SetName(n"scrollWrapper");
    scrollWrapper.SetAnchor(inkEAnchor.TopCenter);
    scrollWrapper.SetAnchorPoint(0.5, 0.0);
    scrollWrapper.SetHAlign(inkEHorizontalAlign.Fill);
    scrollWrapper.SetVAlign(inkEVerticalAlign.Top);
    scrollWrapper.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    scrollWrapper.SetSize(2600.0, 960.0);
    scrollWrapper.SetInteractive(true);
    let scrollArea: ref<inkScrollArea> = new inkScrollArea();
    scrollArea.SetName(n"scrollArea");
    scrollArea.SetAnchor(inkEAnchor.Fill);
    scrollArea.SetMargin(new inkMargin(0, 0, 16.0, 0));
    scrollArea.fitToContentDirection = inkFitToContentDirection.Horizontal;
    scrollArea.useInternalMask = true;
    scrollArea.Reparent(scrollWrapper, -1);
    let sliderArea: ref<inkCanvas> = new inkCanvas();
    sliderArea.SetName(n"sliderArea");
    sliderArea.SetAnchor(inkEAnchor.RightFillVerticaly);
    sliderArea.SetSize(15.0, 0.0);
    sliderArea.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));
    sliderArea.SetInteractive(true);
    sliderArea.Reparent(scrollWrapper, -1);
    let sliderFill: ref<inkRectangle> = new inkRectangle();
    sliderFill.SetName(n"sliderFill");
    sliderFill.SetAnchor(inkEAnchor.Fill);
    sliderFill.SetOpacity(0.05);
    sliderFill.Reparent(sliderArea, -1);
    let sliderHandle: ref<inkRectangle> = new inkRectangle();
    sliderHandle.SetName(n"sliderHandle");
    sliderHandle.SetAnchor(inkEAnchor.TopFillHorizontaly);
    sliderHandle.SetSize(15.0, 40.0);
    sliderHandle.SetInteractive(true);
    sliderHandle.Reparent(sliderArea, -1);
    let sliderController: ref<inkSliderController> = new inkSliderController();
    sliderController.slidingAreaRef = inkWidgetRef.Create(sliderArea);
    sliderController.handleRef = inkWidgetRef.Create(sliderHandle);
    sliderController.direction = inkESliderDirection.Vertical;
    sliderController.autoSizeHandle = true;
    sliderController.percentHandleSize = 0.4;
    sliderController.minHandleSize = 40.0;
    sliderController.Setup(0, 1, 0, 0);
    let scrollController: ref<inkScrollController> = new inkScrollController();
    scrollController.ScrollArea = inkScrollAreaRef.Create(scrollArea);
    scrollController.VerticalScrollBarRef = inkWidgetRef.Create(sliderArea);
    scrollController.autoHideVertical = true;
    scrollWrapper.Reparent(root);
    let components: ref<inkVerticalPanel> = new inkVerticalPanel();
    components.SetName(n"components");
    components.SetChildMargin(new inkMargin(0.0, 24.0, 0.0, 24.0));
    components.Reparent(scrollArea);
    sliderFill.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    sliderFill.BindProperty(n"tintColor", n"MainColors.Gold");
    sliderHandle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    sliderHandle.BindProperty(n"tintColor", n"MainColors.Gold");
    sliderArea.AttachController(sliderController);
    scrollWrapper.AttachController(scrollController);
    let empty: ref<inkText> = new inkText();
    empty.SetName(n"empty");
    empty.SetText(GetLocalizedTextByKey(n"Mod-VAD-No-Orders"));
    empty.SetFitToContent(true);
    empty.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    empty.SetFontStyle(n"Regular");
    empty.SetFontSize(64);
    empty.SetAnchor(inkEAnchor.Centered);
    empty.SetAnchorPoint(new Vector2(0.5, 0.5));
    empty.SetLetterCase(textLetterCase.OriginalCase);
    empty.SetMargin(new inkMargin(48.0, 48.0, 48.0, 48.0));
    empty.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    empty.BindProperty(n"tintColor", n"MainColors.Gold");
    empty.SetVisible(false);
    empty.Reparent(root);
    return root;
  }
  protected cb func OnInitialize() -> Void {
    this.player = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerControlledGameObject();
    this.system = OrderProcessingSystem.Get(this.player.GetGame());
    this.ticker = OrderTrackingTicker.Get(this.player.GetGame());
    this.ticker.CancelScheduledCallback();
    this.InitializeWidgets();
    this.RefreshComponentsList();
  }
  protected cb func OnUninitialize() -> Void {
    this.ticker.ScheduleCallbackShortened();
    this.player = null;
  }
  protected cb func OnAtelierDeliveryOrderCreatedEvent(evt: ref<AtelierDeliveryOrderCreatedEvent>) -> Bool {
    this.RefreshComponentsList();
  }
  protected cb func OnOrderTrackRequestedEvent(evt: ref<OrderTrackRequestedEvent>) -> Bool {
    this.ShowWorldMap(evt.order.deliveryPoint);
  }
  protected cb func OnOrderSoundEvent(evt: ref<OrderSoundEvent>) -> Bool {
    GameObject.PlaySoundEvent(this.player, evt.name);
  }
  private final func ShowWorldMap(deliveryPoint: AtelierDeliveryDropPoint) -> Void {
    let evt: ref<StartHubMenuEvent> = new StartHubMenuEvent();
    let userData: ref<MapMenuUserData> = new MapMenuUserData();
    userData.deliveryPoint = deliveryPoint;
    evt.SetStartMenu(n"world_map", n"", userData);
    GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(evt);
  }
  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.components = root.GetWidgetByPathName(n"scrollWrapper/scrollArea/components") as inkCompoundWidget;
    this.scrollWrapper = root.GetWidgetByPathName(n"scrollWrapper");
    this.emptyPlaceholder = root.GetWidgetByPathName(n"empty") as inkText;
  }
  private final func RefreshComponentsList() -> Void {
    this.system.RefreshOrdersState();
    this.orders = this.system.GetOrders();
    let isEmpty: Bool = Equals(ArraySize(this.orders), 0);
    this.scrollWrapper.SetVisible(!isEmpty);
    this.emptyPlaceholder.SetVisible(isEmpty);
    if isEmpty {
      return ;
    };
    this.components.RemoveAllChildren();
    let component: ref<OrdersManagerItemComponent>;
    for order in this.orders {
      component = OrdersManagerItemComponent.Create(order);
      component.Reparent(this.components);
    };
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryOrder", str);
    };
  }
}
public class OrdersManagerItemComponent extends inkComponent {
  let order: ref<PurchasedAtelierBundle>;
  let storeName: wref<inkText>;
  let statusUpdateInfo: wref<inkText>;
  let currentStatus: wref<inkText>;
  let currentStatusBg: wref<inkImage>;
  let price: wref<inkText>;
  let location: wref<inkText>;
  let trackButton: wref<OrderManagerButton>;
  public final static func Create(order: ref<PurchasedAtelierBundle>) -> ref<OrdersManagerItemComponent> {
    let instance: ref<OrdersManagerItemComponent> = new OrdersManagerItemComponent();
    instance.order = order;
    return instance;
  }
  protected cb func OnCreate() -> ref<inkWidget> {
    let mainRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    mainRow.SetName(n"Root");
    mainRow.SetAnchor(inkEAnchor.Centered);
    mainRow.SetAnchorPoint(0.5, 0.5);
    // Icon
    let genericIcon: ref<inkCanvas> = new inkCanvas();
    genericIcon.SetName(n"genericIcon");
    genericIcon.SetSize(140.0, 140.0);
    genericIcon.Reparent(mainRow);
    let circle: ref<inkCircle> = new inkCircle();
    circle.SetName(n"circle");
    circle.SetSize(140.0, 140.0);
    circle.SetOpacity(0.25);
    circle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    circle.BindProperty(n"tintColor", n"MainColors.DarkGold");
    circle.Reparent(genericIcon);
    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"icon");
    icon.SetSize(90.0, 90.0);
    icon.SetAnchor(inkEAnchor.Centered);
    icon.SetAnchorPoint(new Vector2(0.5, 0.5));
    icon.SetHAlign(inkEHorizontalAlign.Center);
    icon.SetVAlign(inkEVerticalAlign.Center);
    icon.SetContentHAlign(inkEHorizontalAlign.Fill);
    icon.SetContentVAlign(inkEVerticalAlign.Fill);
    icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
    icon.SetTexturePart(n"resource_single");
    icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    icon.BindProperty(n"tintColor", n"MainColors.White");
    icon.SetOpacity(0.25);
    icon.Reparent(genericIcon);
    // Store name and status
    let storeAndStatus: ref<inkVerticalPanel> = new inkVerticalPanel();
    storeAndStatus.SetName(n"storeAndStatus");
    storeAndStatus.SetMargin(new inkMargin(48.0, 0.0, 0.0, 0.0));
    storeAndStatus.Reparent(mainRow);
    let storeName: ref<inkText> = new inkText();
    storeName.SetName(n"storeName");
    storeName.SetText("#123: All Foods Online");
    storeName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    storeName.SetFontSize(56);
    storeName.SetFitToContent(false);
    storeName.SetSize(640.0, 74.0);
    storeName.SetWrapping(false, 630, textWrappingPolicy.PerCharacter);
    storeName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    storeName.SetLetterCase(textLetterCase.OriginalCase);
    storeName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    storeName.BindProperty(n"tintColor", n"MainColors.White");
    storeName.Reparent(storeAndStatus);
    let status: ref<inkText> = new inkText();
    status.SetName(n"statusUpdate");
    status.SetFitToContent(false);
    status.SetSize(640.0, 64.0);
    status.SetWrapping(false, 630, textWrappingPolicy.PerCharacter);
    status.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    status.SetText("Next status update: 2 days");
    status.SetAnchor(inkEAnchor.CenterLeft);
    status.SetAnchorPoint(0.5, 0.5);
    status.SetHAlign(inkEHorizontalAlign.Left);
    status.SetVAlign(inkEVerticalAlign.Center);
    status.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    status.SetFontSize(46);
    status.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    status.BindProperty(n"tintColor", n"MainColors.White");
    status.SetOpacity(0.5);
    status.Reparent(storeAndStatus);
    // Badge wrapper
    let badgeWrapper: ref<inkCanvas> = new inkCanvas();
    badgeWrapper.SetName(n"badgeWrapper");
    badgeWrapper.SetFitToContent(false);
    badgeWrapper.SetSize(300.0, 60.0);
    badgeWrapper.SetMargin(new inkMargin(64.0, 0.0, 0.0, 0.0));
    badgeWrapper.Reparent(mainRow);
    // Badge
    let badge: ref<inkFlex> = new inkFlex();
    badge.SetName(n"badge");
    badge.SetChildOrder(inkEChildOrder.Forward);
    badge.SetAnchor(inkEAnchor.Centered);
    badge.SetAnchorPoint(0.5, 0.5);
    badge.SetHAlign(inkEHorizontalAlign.Center);
    badge.SetVAlign(inkEVerticalAlign.Center);
    badge.SetFitToContent(true);
    badge.Reparent(badgeWrapper);
    let badgeBg: ref<inkImage> = new inkImage();
    badgeBg.SetName(n"badgeBg");
    badgeBg.SetFitToContent(true);
    badgeBg.SetAnchor(inkEAnchor.Fill);
    badgeBg.SetAnchorPoint(0.5, 0.5);
    badgeBg.SetHAlign(inkEHorizontalAlign.Fill);
    badgeBg.SetVAlign(inkEVerticalAlign.Fill);
    badgeBg.SetOpacity(1);
    badgeBg.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\atlas_common.inkatlas");
    badgeBg.SetTexturePart(n"frame_bg");
    badgeBg.SetNineSliceScale(true);
    badgeBg.useExternalDynamicTexture = true;
    badgeBg.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    badgeBg.BindProperty(n"tintColor", n"MainColors.Green");
    badgeBg.Reparent(badge);
    let badgeText: ref<inkText> = new inkText();
    badgeText.SetName(n"badgeText");
    badgeText.SetFitToContent(true);
    badgeText.SetText("Created");
    badgeText.SetAnchor(inkEAnchor.CenterLeft);
    badgeText.SetAnchorPoint(0.5, 0.5);
    badgeText.SetHAlign(inkEHorizontalAlign.Left);
    badgeText.SetVAlign(inkEVerticalAlign.Center);
    badgeText.SetMargin(new inkMargin(16.0, 2.0, 16.0, 2.0));
    badgeText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    badgeText.SetFontSize(44);
    badgeText.SetLetterCase(textLetterCase.UpperCase);
    badgeText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    badgeText.BindProperty(n"tintColor", n"MainColors.Black");
    badgeText.Reparent(badge);
    // Price
    let price: ref<inkText> = new inkText();
    price.SetName(n"price");
    price.SetFitToContent(false);
    price.SetSize(300.0, 80.0);
    price.SetText("1234567890$");
    price.SetAnchor(inkEAnchor.CenterLeft);
    price.SetAnchorPoint(0.5, 0.5);
    price.SetHAlign(inkEHorizontalAlign.Left);
    price.SetVAlign(inkEVerticalAlign.Center);
    price.SetMargin(new inkMargin(32.0, 0.0, 0.0, 0.0));
    price.SetHorizontalAlignment(textHorizontalAlignment.Center);
    price.SetVerticalAlignment(textVerticalAlignment.Center);
    price.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    price.SetFontSize(56);
    price.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    price.BindProperty(n"tintColor", n"MainColors.Gold");
    price.Reparent(mainRow);
    let locationWrapper: ref<inkCanvas> = new inkCanvas();
    locationWrapper.SetName(n"locationWrapper");
    locationWrapper.SetSize(680.0, 80.0);
    locationWrapper.SetAnchor(inkEAnchor.CenterLeft);
    locationWrapper.SetAnchorPoint(0.5, 0.5);
    locationWrapper.SetMargin(new inkMargin(32.0, 0.0, 32.0, 0.0));
    locationWrapper.Reparent(mainRow);
    // Location
    let location: ref<inkText> = new inkText();
    location.SetName(n"location");
    location.SetFitToContent(true);
    location.SetAnchor(inkEAnchor.CenterLeft);
    location.SetAnchorPoint(0.0, 0.5);
    location.SetWrapping(true, 660, textWrappingPolicy.PerCharacter);
    location.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    location.SetText("Megabuilding H10, Atrium");
    location.SetHAlign(inkEHorizontalAlign.Left);
    location.SetVAlign(inkEVerticalAlign.Center);
    location.SetHorizontalAlignment(textHorizontalAlignment.Left);
    location.SetVerticalAlignment(textVerticalAlignment.Center);
    location.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    location.SetFontSize(50);
    location.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    location.BindProperty(n"tintColor", n"MainColors.Blue");
    location.Reparent(locationWrapper);
    // Button
    let button: ref<OrderManagerButton> = OrderManagerButton.Create();
    button.SetName(n"track");
    button.SetText(GetLocalizedText("LocKey#17834"));
    button.Reparent(mainRow);
    return mainRow;
  }
  protected cb func OnInitialize() -> Void {
    this.InitializeWidgets();
    this.RegisterListeners();
    this.RefreshData();
  }
  protected cb func OnUninitialize() -> Void {
    this.UnregisterListeners();
  }
  protected cb func OnTrackClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.QueueEvent(OrderSoundEvent.Create(n"ui_menu_map_pin_created"));
      this.QueueEvent(OrderTrackRequestedEvent.Create(this.order));
    };
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.trackButton.SetHoveredState(true);
    this.QueueEvent(OrderSoundEvent.Create(n"ui_menu_hover"));
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.trackButton.SetHoveredState(false);
  }
  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.storeName = root.GetWidgetByPathName(n"storeAndStatus/storeName") as inkText;
    this.statusUpdateInfo = root.GetWidgetByPathName(n"storeAndStatus/statusUpdate") as inkText;
    this.currentStatus = root.GetWidgetByPathName(n"badgeWrapper/badge/badgeText") as inkText;
    this.currentStatusBg = root.GetWidgetByPathName(n"badgeWrapper/badge/badgeBg") as inkImage;
    this.price = root.GetWidgetByPathName(n"price") as inkText;
    this.location = root.GetWidgetByPathName(n"locationWrapper/location") as inkText;
    this.trackButton = root.GetWidgetByPathName(n"track").GetController() as OrderManagerButton;
  }
  private final func RegisterListeners() -> Void {
    this.trackButton.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.trackButton.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.trackButton.RegisterToCallback(n"OnPress", this, n"OnTrackClick");
  }
  private final func UnregisterListeners() -> Void {
    this.trackButton.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.trackButton.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.trackButton.UnregisterFromCallback(n"OnPress", this, n"OnTrackClick");
  }
  private final func RefreshData() -> Void {
    let storeNameParams: ref<inkTextParams> = new inkTextParams();
    storeNameParams.AddNumber("id", this.order.orderId);
    storeNameParams.AddString("name", NameToString(this.order.storeName));
    this.storeName.SetText("#{id}: {name}", storeNameParams);
    let statusUpdateParams: ref<inkTextParams> = new inkTextParams();
    statusUpdateParams.AddString("prefix", GetLocalizedTextByKey(n"Mod-VAD-Order-Status-Update"));
    statusUpdateParams.AddString("value", AtelierDeliveryUtils.PrettifyTimestampValue(this.order.nextStatusUpdateDiff));
    this.statusUpdateInfo.SetText("{prefix} {value}", statusUpdateParams);
    this.currentStatus.SetText(GetLocalizedTextByKey(AtelierDeliveryUtils.GetDeliveryBadgeLocKey(this.order.deliveryStatus)));
    this.currentStatus.BindProperty(n"tintColor", AtelierDeliveryUtils.GetDeliveryBadgeTextColor(this.order.deliveryStatus));
    this.currentStatusBg.BindProperty(n"tintColor", AtelierDeliveryUtils.GetDeliveryBadgeColor(this.order.deliveryStatus));
    let priceParams: ref<inkTextParams> = new inkTextParams();
    priceParams.AddString("price", GetFormattedMoneyVAD(this.order.totalPrice));
    priceParams.AddLocalizedString("dollar", "Common-Characters-EuroDollar");
    this.price.SetText("{price} {dollar}", priceParams);
    this.location.SetText(GetLocalizedText(AtelierDeliveryUtils.GetDeliveryPointLocKey(this.order.deliveryPoint)));
    this.trackButton.SetVisible(Equals(this.order.deliveryStatus, AtelierDeliveryStatus.Arrived));
  }
}
public class OrderTrackingTicker extends ScriptableSystem {
  private let delaySystem: wref<DelaySystem>;
  private let delayId: DelayID;
  private let checkingPeriodShort: Float = 5.0;
  private let checkingPeriodNormal: Float = 20.0;
  private let checkingPeriodLong: Float = 60.0;
  public static func Get(gi: GameInstance) -> ref<OrderTrackingTicker> {
    let system: ref<OrderTrackingTicker> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"AtelierDelivery.OrderTrackingTicker") as OrderTrackingTicker;
    return system;
  }
  private func OnAttach() -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      return;
    };
    let callbackSystem: ref<CallbackSystem> = GameInstance.GetCallbackSystem();
    callbackSystem
      .RegisterCallback(n"Session/Ready", this, n"OnSessionReady")
      .SetLifetime(CallbackLifetime.Session);
    callbackSystem
      .RegisterCallback(n"Session/BeforeEnd", this, n"OnSessionEnd")
      .SetLifetime(CallbackLifetime.Session);
    this.delaySystem = GameInstance.GetDelaySystem(this.GetGameInstance());
  }
  public final func ScheduleCallbackNormal() -> Void {
    this.ScheduleNextTickCallback(this.checkingPeriodNormal);
  }
  public final func ScheduleCallbackShortened() -> Void {
    this.ScheduleNextTickCallback(this.checkingPeriodShort);
  }
  public final func ScheduleCallbackLong() -> Void {
    this.ScheduleNextTickCallback(this.checkingPeriodLong);
  }
  public final func CancelScheduledCallback() -> Void {
    this.Log("- CancelScheduledCallback");
    this.delaySystem.CancelCallback(this.delayId);
  }
  private final func ScheduleNextTickCallback(delay: Float) -> Void {
    this.Log(s"+ ScheduleNextTickCallback after \(delay) sec");
    let orderProcessingSystem: ref<OrderProcessingSystem> = OrderProcessingSystem.Get(this.GetGameInstance());
    let delayCallback: ref<OrderTrackingTickerCallback>;
    if orderProcessingSystem.HasActiveOrders() {
      delayCallback = OrderTrackingTickerCallback.Create(orderProcessingSystem);
      this.delaySystem.CancelCallback(this.delayId);
      this.delayId = this.delaySystem.DelayCallback(delayCallback, delay, true);
    } else {
      this.CancelScheduledCallback();
    };
  }
  private cb func OnSessionReady(event: ref<GameSessionEvent>) {
    this.ScheduleCallbackNormal();
  }
  private cb func OnSessionEnd(event: ref<GameSessionEvent>) {
    this.CancelScheduledCallback();
  }
  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryOrders", str);
    };
  }
}
public class OrderTrackingTickerCallback extends DelayCallback {
  private let ordersSystem: wref<OrderProcessingSystem>;
  public static func Create(ordersSystem: ref<OrderProcessingSystem>) -> ref<OrderTrackingTickerCallback> {
    let instance: ref<OrderTrackingTickerCallback> = new OrderTrackingTickerCallback();
    instance.ordersSystem = ordersSystem;
    return instance;
  }
	public func Call() -> Void {
    this.ordersSystem.RefreshOrdersState();
	}
}
public abstract class AtelierDeliveryUtils {
  public final static func BuildShortLabel(baseLabel: String, maxLength: Int32) -> String {
    let currentLength: Int32 = StrLen(baseLabel);
    if currentLength <= maxLength {
      return baseLabel;
    }
    let shortened: String = UTF8StrLeft(baseLabel, maxLength);
    let suffix: String = "(...)";
    return s"\(shortened) \(suffix)";
  }
  public final static func PrettifyTimestampValue(timestamp: Float) -> String {
    let asMinutes: Float = timestamp / 60.0;
    let asHours: Float = asMinutes / 60.0;
    let asDays: Float = asHours / 24.0;
    let result: String;
    if asDays > 1.0 {
      result = s"\(Cast<Int32>(asDays))\(GetLocalizedTextByKey(n"Mod-VAD-Time-Suffix-Days"))";
    } else if asDays <= 1.0 && asHours > 1.0 {
      result = s"\(Cast<Int32>(asHours))\(GetLocalizedTextByKey(n"Mod-VAD-Time-Suffix-Hours"))";
    } else if NotEquals(timestamp, 0.0) {
      result = GetLocalizedTextByKey(n"Mod-VAD-Time-Less-Than-Hour");
    } else {
      result = GetLocalizedTextByKey(n"Mod-VAD-Shipment-Suffix-None");
    };
    return result;
  }
  public final static func GetDeliveryPointLocKey(deliveryPoint: AtelierDeliveryDropPoint) -> String {
    switch deliveryPoint {
      case AtelierDeliveryDropPoint.MegabuildingH10: return "LocKey#44450";
      case AtelierDeliveryDropPoint.KabukiMarket: return "LocKey#44430";
      case AtelierDeliveryDropPoint.MartinSt: return "LocKey#44415";
      case AtelierDeliveryDropPoint.EisenhowerSt: return "LocKey#95277";
      case AtelierDeliveryDropPoint.CharterHill: return "LocKey#21266";
      case AtelierDeliveryDropPoint.CherryBlossomMarket: return "LocKey#21233";
      case AtelierDeliveryDropPoint.NorthOakSign: return "LocKey#44579";
      case AtelierDeliveryDropPoint.SarastiAndRepublic: return "LocKey#95266";
      case AtelierDeliveryDropPoint.CorporationSt: return "LocKey#44500";
      case AtelierDeliveryDropPoint.MegabuildingH3: return "LocKey#44519";
      case AtelierDeliveryDropPoint.CongressMlk: return "LocKey#95271";
      case AtelierDeliveryDropPoint.CanneryPlaza: return "LocKey#44501";
      case AtelierDeliveryDropPoint.WollesenSt: return "LocKey#95265";
      case AtelierDeliveryDropPoint.MegabuildingH7: return "LocKey#95272";
      case AtelierDeliveryDropPoint.PacificaStadium: return "LocKey#95276";
      case AtelierDeliveryDropPoint.WestWindEstate: return "LocKey#10958";
      case AtelierDeliveryDropPoint.SunsetMotel: return "LocKey#37971";
      case AtelierDeliveryDropPoint.LongshoreStacks: return "LocKey#93789";
      case AtelierDeliveryDropPoint.LittleChina: return "LocKey#10963";
      default: return "";
    };
  }
  public final static func GetDeliveryBadgeLocKey(status: AtelierDeliveryStatus) -> CName {
    switch status {
      case AtelierDeliveryStatus.Created: return n"Mod-VAD-Status-Created";
      case AtelierDeliveryStatus.Shipped: return n"Mod-VAD-Status-Shipped";
      case AtelierDeliveryStatus.Arrived: return n"Mod-VAD-Status-Arrived";
      case AtelierDeliveryStatus.Delivered: return n"Mod-VAD-Status-Delivered";
      default: return n"";
    };
  }
  public final static func GetDeliveryBadgeColor(status: AtelierDeliveryStatus) -> CName {
    switch status {
      case AtelierDeliveryStatus.Created: return n"MainColors.Neutral";
      case AtelierDeliveryStatus.Shipped: return n"MainColors.DarkGold";
      case AtelierDeliveryStatus.Arrived: return n"MainColors.DarkBlue";
      case AtelierDeliveryStatus.Delivered: return n"MainColors.DarkGreen";
      default: return n"MainColors.White";
    };
  }
  public final static func GetDeliveryBadgeTextColor(status: AtelierDeliveryStatus) -> CName {
    switch status {
      case AtelierDeliveryStatus.Created: return n"MainColors.Black";
      case AtelierDeliveryStatus.Shipped: return n"MainColors.Black";
      case AtelierDeliveryStatus.Arrived: return n"MainColors.Black";
      case AtelierDeliveryStatus.Delivered: return n"MainColors.Black";
      default: return n"MainColors.Black";
    };
  }
  public final static func GetDropPointByTag(tag: CName) -> AtelierDeliveryDropPoint {
    switch tag {
      case n"MegabuildingH10": return AtelierDeliveryDropPoint.MegabuildingH10;
      case n"KabukiMarket": return AtelierDeliveryDropPoint.KabukiMarket;
      case n"MartinSt": return AtelierDeliveryDropPoint.MartinSt;
      case n"EisenhowerSt": return AtelierDeliveryDropPoint.EisenhowerSt;
      case n"CharterHill": return AtelierDeliveryDropPoint.CharterHill;
      case n"CherryBlossomMarket": return AtelierDeliveryDropPoint.CherryBlossomMarket;
      case n"NorthOakSign": return AtelierDeliveryDropPoint.NorthOakSign;
      case n"SarastiAndRepublic": return AtelierDeliveryDropPoint.SarastiAndRepublic;
      case n"CorporationSt": return AtelierDeliveryDropPoint.CorporationSt;
      case n"MegabuildingH3": return AtelierDeliveryDropPoint.MegabuildingH3;
      case n"CongressMlk": return AtelierDeliveryDropPoint.CongressMlk;
      case n"CanneryPlaza": return AtelierDeliveryDropPoint.CanneryPlaza;
      case n"WollesenSt": return AtelierDeliveryDropPoint.WollesenSt;
      case n"MegabuildingH7": return AtelierDeliveryDropPoint.MegabuildingH7;
      case n"PacificaStadium": return AtelierDeliveryDropPoint.PacificaStadium;
      case n"WestWindEstate": return AtelierDeliveryDropPoint.WestWindEstate;
      case n"SunsetMotel": return AtelierDeliveryDropPoint.SunsetMotel;
      case n"LongshoreStacks": return AtelierDeliveryDropPoint.LongshoreStacks;
      case n"LittleChina": return AtelierDeliveryDropPoint.LittleChina;
    };
    return AtelierDeliveryDropPoint.None;
  }
}
@addField(MapMenuUserData)
public let deliveryPoint: AtelierDeliveryDropPoint;
@addField(WorldMapMenuGameController)
public let spawner: wref<AtelierDropPointsSpawner>;
@addField(WorldMapTooltipBaseController)
public let isCustomMappin: Bool;
@addField(WorldMapTooltipBaseController)
public let previewImageInfo: ref<DropPointImageInfo>;
@addField(WorldMapTooltipController)
public let dropPointImageContainer: wref<inkCompoundWidget>;
@addMethod(WorldMapTooltipContainer)
public final func SetIsCustomMappin(custom: Bool, imageInfo: ref<DropPointImageInfo>) -> Void {
  this.m_defaultTooltipController.SetIsCustomMappin(custom, imageInfo);
}
@addMethod(WorldMapTooltipBaseController)
public final func SetIsCustomMappin(custom: Bool, imageInfo: ref<DropPointImageInfo>) -> Void {
  this.isCustomMappin = custom;
  this.previewImageInfo = imageInfo;
}
@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.spawner = AtelierDropPointsSpawner.Get(this.m_player.GetGame());
}
// Save spawned mappins
@wrapMethod(DropPointSystem)
private final func RegisterDropPointMappin(data: ref<DropPointMappinRegistrationData>) -> Void {
  wrappedMethod(data);
  let spawner: ref<AtelierDropPointsSpawner> = AtelierDropPointsSpawner.Get(this.GetGameInstance());
  let entityId: EntityID = data.GetOwnerID();
  let mappinData: ref<DropPointMappinRegistrationData> = this.GetMappinData(entityId);
  let mappinId: NewMappinID;
  if IsDefined(mappinData) {
    mappinId = mappinData.GetMappinID();
    if NotEquals(mappinId.value, Cast<Uint64>(0)) && spawner.IsCustomDropPoint(entityId) {
      spawner.SaveSpawnedMappinId(entityId, mappinId);
    };
  };
}
// Show VA tooltip
@wrapMethod(WorldMapTooltipController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"tooltip/tooltipFlex/mainLayout/content/mainContent") as inkCompoundWidget;
  let dropPointPreview: ref<inkCompoundWidget> = LayoutsBuilder.BuildDropPointPreviewContainer();
  dropPointPreview.SetAffectsLayoutWhenHidden(false);
  dropPointPreview.SetVisible(false);
  dropPointPreview.Reparent(container);
  this.dropPointImageContainer = dropPointPreview;
}
@wrapMethod(WorldMapTooltipController)
protected final func Reset() -> Void {
  wrappedMethod();
  this.dropPointImageContainer.SetVisible(false);
}
@wrapMethod(WorldMapMenuGameController)
private final func UpdateTooltip(tooltipType: WorldMapTooltipType, controller: wref<BaseWorldMapMappinController>) -> Void {
  let mappin: ref<RuntimeMappin> = controller.GetMappin() as RuntimeMappin;
  let mappinId: NewMappinID = mappin.GetNewMappinID();
  let isCustomMappin: Bool = this.spawner.IsCustomDropPoint(mappinId);
  let dropPointInstance: ref<AtelierDropPointInstance>;
  let imageInfo: ref<DropPointImageInfo>;
  if isCustomMappin {
    dropPointInstance = this.spawner.FindInstanceByMappinId(mappinId);
    if IsDefined(dropPointInstance) {
      imageInfo = DropPointImageInfo.Create(dropPointInstance.inkAtlas, dropPointInstance.uniqueTag);
    };
  };
  this.m_tooltipController.SetIsCustomMappin(isCustomMappin, imageInfo);
  wrappedMethod(tooltipType, controller);
}
@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);
  let deliveryPoint: AtelierDeliveryDropPoint;
  let deliveryPointLocKey: String;
  this.dropPointImageContainer.SetVisible(this.isCustomMappin);
  let image: ref<inkImage> = this.dropPointImageContainer.GetWidgetByPathName(n"image") as inkImage;
  if this.isCustomMappin {
    deliveryPoint = AtelierDeliveryUtils.GetDropPointByTag(this.previewImageInfo.texturePart);
    deliveryPointLocKey = AtelierDeliveryUtils.GetDeliveryPointLocKey(deliveryPoint);
    inkTextRef.SetText(this.m_titleText, GetLocalizedTextByKey(n"Mod-VAD-Marker"));
    inkTextRef.SetText(this.m_descText, GetLocalizedText(deliveryPointLocKey));
    inkWidgetRef.Get(this.m_descText).BindProperty(n"tintColor", n"MainColors.Blue");
    inkTextRef.SetText(this.m_additionalDescText, GetLocalizedTextByKey(n"Mod-VAD-Marker-Description"));
    inkWidgetRef.SetVisible(this.m_additionalDescText, true);
    inkWidgetRef.SetOpacity(this.m_additionalDescText, 0.4);
    image.SetAtlasResource(this.previewImageInfo.atlas);
    image.SetTexturePart(this.previewImageInfo.texturePart);
  };
}
// Update icons
@addMethod(BaseMappinBaseController)
protected final func IsCustomMappinVA() -> Bool {
  let spawner: ref<AtelierDropPointsSpawner> = AtelierDropPointsSpawner.Get(GetGameInstance());
  let entityId: EntityID = this.GetMappin().GetEntityID();
  let mappinId: NewMappinID = this.GetMappin().GetNewMappinID();
  let isCustomMappin: Bool = spawner.IsCustomDropPoint(entityId) || spawner.IsCustomDropPoint(mappinId);
  return isCustomMappin;
}
@addMethod(BaseMappinBaseController)
protected final func UpdateIconVA(opt forMinimap: Bool) -> Void {
  let texturePart: CName = n"icon";
  if forMinimap {
    texturePart = n"mappin";
  };
  if this.IsCustomMappinVA() {
    inkImageRef.SetAtlasResource(this.iconWidget, r"djkovrik\\gameplay\\gui\\virtual_atelier_delivery_pins.inkatlas");
    inkImageRef.SetTexturePart(this.iconWidget, texturePart);
  };
}
@wrapMethod(BaseWorldMapMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.ServicePointDropPointVariant) {
    this.UpdateIconVA();
  };
}
@wrapMethod(QuestMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.ServicePointDropPointVariant) {
    this.UpdateIconVA();
  };
}
@wrapMethod(MinimapPOIMappinController)
protected final func UpdateIcon() -> Void {
  wrappedMethod();
  if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.ServicePointDropPointVariant) {
    this.UpdateIconVA(true);
  };
}
// Move to custom mappin
@wrapMethod(WorldMapMenuGameController)
protected cb func OnMapNavigationDelay(evt: ref<MapNavigationDelay>) -> Bool {
  if NotEquals(this.m_initMappinFocus.deliveryPoint, AtelierDeliveryDropPoint.None) {
    this.MoveToCustomDeliveryPoint(this.m_initMappinFocus.deliveryPoint);
    return true;
  };
  wrappedMethod(evt);
}
@addMethod(WorldMapMenuGameController)
private final func MoveToCustomDeliveryPoint(target: AtelierDeliveryDropPoint) -> Void {
  let target: ref<AtelierDropPointInstance> = this.FindDropPointInstance(target);
  let direction: Vector3;
  if IsDefined(target) {
    direction = Cast<Vector3>(target.position);
    this.GetEntityPreview().MoveTo(direction);
  };
}
@addMethod(WorldMapMenuGameController)
private final func FindDropPointInstance(target: AtelierDeliveryDropPoint) -> ref<AtelierDropPointInstance> {
  let dropPoints: array<ref<AtelierDropPointInstance>> = this.spawner.GetAvailableDropPoints();
  for dropPoint in dropPoints {
    if Equals(dropPoint.type, target) {
      return dropPoint;
    };
  };
  return null;
}
