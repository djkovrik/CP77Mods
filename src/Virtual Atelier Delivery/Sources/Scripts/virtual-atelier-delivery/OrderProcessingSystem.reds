module AtelierDelivery

@if(ModuleExists("VirtualAtelier.Helpers"))
import VirtualAtelier.Helpers.AtelierItemsHelper

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
    for arrivedOrder in arrivedOrders {
      this.GiveBundleItemsToPlayer(arrivedOrder);
      this.MarkOrderAsReceived(arrivedOrder);
      this.NotifyAboutOrderDelivery(arrivedOrder.orderId);
      receivedAnything = true;
    };

    if receivedAnything {
      GameObject.PlaySound(this.player, n"ui_menu_item_bought");
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

    OrderTrackingTicker.Get(this.player.GetGame()).ScheduleCallbackNormal();
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
    onScreenMessage.duration = 2.0;
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
    let info: String = s"- id #\(order.GetOrderId()) from \(order.GetStoreName()): \(order.GetDeliveryStatus())";
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
