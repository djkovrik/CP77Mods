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
  private let config: ref<VirtualAtelierDeliveryConfig>;
  private let purchasedItems: array<ItemID>;

  private persistent let orders: array<ref<PurchasedAtelierBundle>>;
  private persistent let nextOrderId: Int32;
  private persistent let lastSelectedDropPoint: AtelierDeliveryDropPoint;

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
    this.config = new VirtualAtelierDeliveryConfig();
    this.receivedClearPeriod = 3600.0 * 12.0; // 12 hrs

    if Equals(this.nextOrderId, 0) {
      this.nextOrderId = 1;
    };

    this.Log(s"OrderProcessingSystem attached: player=\(IsDefined(this.player)), timeSystem=\(IsDefined(this.timeSystem)), transactionSystem=\(IsDefined(this.transactionSystem)), inventoryManager=\(IsDefined(this.inventoryManager)), persistedOrders=\(ArraySize(this.orders)), nextOrderId=\(this.nextOrderId)");
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

  public final func GetLastSelectedDropPoint() -> AtelierDeliveryDropPoint {
    return this.lastSelectedDropPoint;
  }

  public final func AddNewOrder(order: ref<PurchasedAtelierBundle>) -> Int32 {
    if !IsDefined(order) {
      return -1;
    };

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
    this.SetLastSelectedDropPoint(order.GetDeliveryPoint());

    this.RefreshOrdersState();

    let createdOrderId: Int32 = this.nextOrderId;
    this.nextOrderId = this.nextOrderId + 1;
    return createdOrderId;
  }

  private final func SetLastSelectedDropPoint(dropPoint: AtelierDeliveryDropPoint) -> Void {
    if NotEquals(dropPoint, AtelierDeliveryDropPoint.None) {
      this.lastSelectedDropPoint = dropPoint;
    };
  }

  public final func TryCreatePaidOrder(order: ref<PurchasedAtelierBundle>) -> Int32 {
    if !IsDefined(order) {
      this.Log("Order creation rejected: bundle is not defined");
      return -1;
    };

    if !this.IsReady() {
      this.Log(s"Order #\(order.GetOrderId()) creation rejected: OrderProcessingSystem is not ready");
      this.LogReadinessState("order creation");
      return -1;
    };

    let price: Int32 = order.GetTotalPrice();
    if price <= 0 {
      this.Log(s"Order #\(order.GetOrderId()) creation rejected: invalid total price \(price)");
      return -1;
    };

    let playerMoney: Int32 = this.transactionSystem.GetItemQuantity(this.player, MarketSystem.Money());
    if playerMoney < price {
      this.Log(s"Order #\(order.GetOrderId()) creation rejected: not enough money, required=\(price), available=\(playerMoney)");
      return -1;
    };

    this.transactionSystem.RemoveItemByTDBID(this.player, t"Items.money", price);
    return this.AddNewOrder(order);
  }

  public final func GetArrivedItems(tag: CName) -> Void {
    let dropPoint: AtelierDeliveryDropPoint = AtelierDeliveryUtils.GetDropPointByTag(tag);
    let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let arrivedOrders: array<ref<PurchasedAtelierBundle>>;
    let orderIndex: Int32 = 0;

    this.Log(s"=== Pickup request started: terminalTag=\(tag), resolvedDropPoint=\(dropPoint), storedOrders=\(ArraySize(orders)) ===");
    if Equals(tag, n"") {
      this.Log("Pickup request warning: terminal unique tag is empty");
    };
    if Equals(dropPoint, AtelierDeliveryDropPoint.None) {
      this.Log(s"Pickup request warning: terminal tag \(tag) does not map to a delivery point");
    };

    for order in orders {
      if !IsDefined(order) {
        this.Log(s"Pickup scan: order at index \(orderIndex) is not defined, skipped");
      } else {
        this.Log(s"Pickup scan: order #\(order.orderId) from \(order.storeName), status=\(order.deliveryStatus), target=\(order.deliveryPoint), items=\(ArraySize(order.purchasedItems))");
        if Equals(order.deliveryPoint, dropPoint) && Equals(order.deliveryStatus, AtelierDeliveryStatus.Arrived) {
          this.Log(s"Pickup scan: order #\(order.orderId) matched this terminal and is ready for pickup");
          ArrayPush(arrivedOrders, order);
        } else {
          if NotEquals(order.deliveryPoint, dropPoint) {
            this.Log(s"Pickup scan: order #\(order.orderId) skipped because it belongs to \(order.deliveryPoint), current terminal is \(dropPoint)");
          };
          if NotEquals(order.deliveryStatus, AtelierDeliveryStatus.Arrived) {
            this.Log(s"Pickup scan: order #\(order.orderId) skipped because status is \(order.deliveryStatus), expected Arrived");
          };
        };
      };
      orderIndex += 1;
    };

    this.Log(s"Pickup scan completed for \(dropPoint): matchedOrders=\(ArraySize(arrivedOrders))");

    let receivedAnything: Bool = false;
    let deliveredIds: array<Int32>;
    for arrivedOrder in arrivedOrders {
      this.Log(s"Pickup delivery: trying order #\(arrivedOrder.orderId) from \(arrivedOrder.storeName), items=\(ArraySize(arrivedOrder.purchasedItems))");
      if this.GiveBundleItemsToPlayer(arrivedOrder) {
        let markedAsReceived: Bool = this.MarkOrderAsReceived(arrivedOrder);
        this.Log(s"Pickup delivery: order #\(arrivedOrder.orderId) gave at least one item; markedAsReceived=\(markedAsReceived), grantedItemInstances=\(ArraySize(this.purchasedItems))");
        if !markedAsReceived {
          this.Log(s"Pickup delivery ERROR: order #\(arrivedOrder.orderId) items were granted, but the order could not be marked as received");
        };
        ArrayPush(deliveredIds, arrivedOrder.orderId);
        receivedAnything = true;
      } else {
        this.Log(s"Pickup delivery FAILED: order #\(arrivedOrder.orderId) was not issued because no bundle item could be granted");
      };
    };

    if receivedAnything {
      this.Log(s"Pickup request succeeded at \(dropPoint): deliveredOrders=\(ArraySize(deliveredIds))");
      GameObject.PlaySound(this.player, n"ui_menu_item_bought");
      if Equals(ArraySize(deliveredIds), 1) {
        this.NotifyAboutOrderDelivery(deliveredIds[0]);
      } else {
        this.NotifyAboutOrdersDelivery(deliveredIds);
      };
    } else {
      this.Log(s"Pickup request FAILED at \(dropPoint): no order was issued; matchedOrders=\(ArraySize(arrivedOrders))");
      GameObject.PlaySound(this.player, n"ui_menu_attributes_fail");
    };

    this.RefreshOrdersState();
    this.Log(s"=== Pickup request finished: terminalTag=\(tag), resolvedDropPoint=\(dropPoint) ===");
  }

  public final func MarkOrderAsReceived(bundle: ref<PurchasedAtelierBundle>) -> Bool {
    if !IsDefined(bundle) {
      this.Log("MarkOrderAsReceived failed: bundle is not defined");
      return false;
    };

    let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let refreshedOrders: array<ref<PurchasedAtelierBundle>>;
    let orderWasFound: Bool = false;
    let now: Float;
    for order in orders {
      if IsDefined(order) {
        if Equals(order.GetOrderId(), bundle.GetOrderId()) && Equals(order.GetStoreName(), bundle.GetStoreName()) {
          now = this.timeSystem.GetGameTimeStamp();
          order.SetReceivedTimestamp(now);
          orderWasFound = true;
          this.Log(s"Order #\(bundle.GetOrderId()) marked as received at timestamp \(now)");
        };
        ArrayPush(refreshedOrders, order);
      } else {
        this.Log("MarkOrderAsReceived: encountered an undefined persisted order, skipped");
      };
    };

    if orderWasFound {
      this.orders = refreshedOrders;
    } else {
      this.Log(s"MarkOrderAsReceived failed: order #\(bundle.GetOrderId()) from \(bundle.GetStoreName()) was not found in \(ArraySize(orders)) stored orders");
    };

    return orderWasFound;
  }

  @if(!ModuleExists("VendorPreview.Config"))
  private final func GiveBundleItemsToPlayer(bundle: ref<PurchasedAtelierBundle>) -> Bool {
    this.Log("Pickup delivery FAILED: VendorPreview.Config module is not available, item delivery integration is disabled");
    return false;
  }

  @if(ModuleExists("VendorPreview.Config"))
  private final func GiveBundleItemsToPlayer(bundle: ref<PurchasedAtelierBundle>) -> Bool {
    if !IsDefined(bundle) {
      this.Log("Pickup delivery FAILED: bundle is not defined");
      return false;
    };

    if !this.IsReady() {
      this.Log(s"Pickup delivery FAILED for order #\(bundle.GetOrderId()): OrderProcessingSystem is not ready");
      this.LogReadinessState("pickup delivery");
      return false;
    };

    let cartItems: array<ref<WrappedVirtualCartItem>> = bundle.purchasedItems;
    let gaveAnything: Bool = false;
    let cartItemIndex: Int32 = 0;

    this.Log(s"Bundle validation started for order #\(bundle.GetOrderId()): cartItems=\(ArraySize(cartItems))");
    if Equals(ArraySize(cartItems), 0) {
      this.Log(s"Pickup delivery FAILED for order #\(bundle.GetOrderId()): bundle contains no cart items");
    };

    ArrayClear(this.purchasedItems);
    for cartItem in cartItems {
      this.Log(s"Bundle item \(cartItemIndex + 1)/\(ArraySize(cartItems)): validation and grant started");
      if this.TryGiveCartItemToPlayer(cartItem) {
        gaveAnything = true;
        this.Log(s"Bundle item \(cartItemIndex + 1)/\(ArraySize(cartItems)): granted successfully");
      } else {
        this.Log(s"Bundle item \(cartItemIndex + 1)/\(ArraySize(cartItems)): FAILED to grant");
      };
      cartItemIndex += 1;
    };

    this.Log(s"Bundle delivery completed for order #\(bundle.GetOrderId()): gaveAnything=\(gaveAnything), grantedItemInstances=\(ArraySize(this.purchasedItems))");
    return gaveAnything;
  }

  private final func TryGiveCartItemToPlayer(cartItem: ref<WrappedVirtualCartItem>) -> Bool {
    if !IsDefined(cartItem) {
      this.Log("Cart item validation FAILED: cart item is not defined");
      return false;
    };

    if cartItem.purchaseAmount <= 0 {
      this.Log(s"Cart item validation FAILED: purchaseAmount=\(cartItem.purchaseAmount), expected a positive value");
      return false;
    };

    let stockItem: ref<WrappedVirtualStockItem> = cartItem.stockItem;
    if !this.IsStockItemValid(stockItem) {
      this.Log(s"Cart item validation FAILED: stock item is invalid, purchaseAmount=\(cartItem.purchaseAmount)");
      return false;
    };

    let itemTDBID: String = TDBID.ToStringDEBUG(stockItem.id);
    let effectiveQuantity: Int32 = stockItem.quantity;
    if Equals(effectiveQuantity, 0) {
      effectiveQuantity = 1;
      this.Log(s"Cart item compatibility fallback for \(itemTDBID): persisted legacy quantity 0 will be granted as 1");
    };
    this.Log(s"Cart item validated: id=\(itemTDBID), purchaseAmount=\(cartItem.purchaseAmount), storedQuantity=\(stockItem.quantity), effectiveQuantity=\(effectiveQuantity), quality=\(stockItem.quality)");

    let gaveAnything: Bool = false;
    let itemID: ItemID;
    let itemData: ref<gameItemData>;
    let i: Int32 = 0;
    while i < cartItem.purchaseAmount {
      itemID = ItemID.FromTDBID(stockItem.id);
      if !ItemID.IsValid(itemID) {
        this.Log(s"Cart item grant FAILED for \(itemTDBID): ItemID.FromTDBID returned an invalid ItemID at purchase iteration \(i + 1)/\(cartItem.purchaseAmount)");
        return gaveAnything;
      };
      itemData = this.inventoryManager.CreateBasicItemData(itemID, this.player);
      if IsDefined(itemData) {
        itemData.isVirtualItem = true;
        this.ScaleItem(this.player, itemData, stockItem.quality);
        if this.transactionSystem.GiveItem(this.player, itemID, effectiveQuantity) {
          ArrayPush(this.purchasedItems, itemID);
          gaveAnything = true;
          this.Log(s"Cart item grant succeeded for \(itemTDBID): quantity=\(effectiveQuantity), purchase iteration \(i + 1)/\(cartItem.purchaseAmount)");
        } else {
          this.Log(s"Cart item grant FAILED for \(itemTDBID): TransactionSystem.GiveItem returned false for quantity=\(effectiveQuantity), purchase iteration \(i + 1)/\(cartItem.purchaseAmount)");
        };
      } else {
        this.Log(s"Cart item grant FAILED for \(itemTDBID): InventoryManager.CreateBasicItemData returned null at purchase iteration \(i + 1)/\(cartItem.purchaseAmount)");
      };
      i += 1;
    };

    if !gaveAnything {
      this.Log(s"Cart item grant FAILED for \(itemTDBID): no item instance was granted");
    };
    return gaveAnything;
  }

  private final func IsStockItemValid(stockItem: ref<WrappedVirtualStockItem>) -> Bool {
    if !IsDefined(stockItem) {
      this.Log("Stock item validation FAILED: stock item is not defined");
      return false;
    };

    let itemTDBID: String = TDBID.ToStringDEBUG(stockItem.id);
    if stockItem.quantity < 0 {
      this.Log(s"Stock item validation FAILED for \(itemTDBID): quantity=\(stockItem.quantity), expected zero (legacy default) or a positive value");
      return false;
    };

    if Equals(stockItem.quantity, 0) {
      this.Log(s"Stock item validation compatibility warning for \(itemTDBID): persisted legacy quantity 0 will be normalized during grant");
    };

    if !TDBID.IsValid(stockItem.id) {
      this.Log(s"Stock item validation FAILED: invalid TweakDBID \(itemTDBID)");
      return false;
    };

    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(stockItem.id);
    if !IsDefined(itemRecord) {
      this.Log(s"Stock item validation FAILED for \(itemTDBID): Item_Record was not found; the source item mod may be missing, disabled, or updated");
      return false;
    };

    return true;
  }

  public final func RefreshOrdersState() -> Void {
    let orders: array<ref<PurchasedAtelierBundle>> = this.orders;
    let refreshedOrders: array<ref<PurchasedAtelierBundle>>;
    let now: Float = this.timeSystem.GetGameTimeStamp();
    let shipmentTimestamp: Float;
    let deliveryTimestamp: Float;   
    let receivedTimestamp: Float;   
    let diff: Float;
    let previousStatus: AtelierDeliveryStatus;

    this.Log(s"=== RefreshOrdersState started: now=\(now), storedOrders=\(ArraySize(orders)) ===");

    for order in orders {
      if IsDefined(order) {
        shipmentTimestamp = order.GetShipmentTimestamp();
        deliveryTimestamp = order.GetDeliveryTimestamp();
        receivedTimestamp = order.GetReceivedTimestamp();
        previousStatus = order.GetDeliveryStatus();

        this.Log(s"Status check order #\(order.GetOrderId()) from \(order.GetStoreName()): status=\(previousStatus), point=\(order.GetDeliveryPoint()), shipment=\(shipmentTimestamp), delivery=\(deliveryTimestamp), received=\(receivedTimestamp)");

        if now < shipmentTimestamp {
          // not shipped yet
          diff = shipmentTimestamp - now;
          order.SetNextStatusUpdateDiff(diff);
          this.Log(s"Status result order #\(order.GetOrderId()): remains \(order.GetDeliveryStatus()), shipment in \(diff) sec");
          ArrayPush(refreshedOrders, order);
        } else if now >= shipmentTimestamp && now < deliveryTimestamp {
          // already shipped, delivering in progress
          diff = deliveryTimestamp - now;
          order.SetNextStatusUpdateDiff(diff);
          order.SetDeliveryStatus(AtelierDeliveryStatus.Shipped);
          this.Log(s"Status result order #\(order.GetOrderId()): \(previousStatus) -> \(order.GetDeliveryStatus()), arrival in \(diff) sec");
          if !order.IsShipmentNotified() && !this.IsJohnny() && this.IsPhoneAvailable() {
            order.SetShipmentNotified();
            this.NotifyAboutOrderShipment(order);
          };
          ArrayPush(refreshedOrders, order);
        } else if now >= deliveryTimestamp && Equals(receivedTimestamp, 0.0) {
          // ready for pickup
          order.SetNextStatusUpdateDiff(0.0);
          order.SetDeliveryStatus(AtelierDeliveryStatus.Arrived);
          this.Log(s"Status result order #\(order.GetOrderId()): \(previousStatus) -> \(order.GetDeliveryStatus()), ready for pickup at \(order.GetDeliveryPoint())");
          if !order.IsArrivalNotified() && !this.IsJohnny() && this.IsPhoneAvailable() {
            order.SetArrivalNotified();
            this.NotifyAboutOrderArrival(order);
          };
          ArrayPush(refreshedOrders, order);
        } else if receivedTimestamp > 0.0 && now - receivedTimestamp < this.receivedClearPeriod {
          // received already, check if order should be deleted from the list
          order.SetDeliveryStatus(AtelierDeliveryStatus.Delivered);
          this.Log(s"Status result order #\(order.GetOrderId()): \(previousStatus) -> \(order.GetDeliveryStatus()), retained for \(this.receivedClearPeriod - (now - receivedTimestamp)) sec");
          ArrayPush(refreshedOrders, order);
        } else {
          this.Log(s"Status result order #\(order.GetOrderId()): removed from active orders, status=\(previousStatus), receivedAge=\(now - receivedTimestamp) sec");
        };
      } else {
        this.Log("Status check skipped an undefined persisted order; it will be removed from active orders");
      };
    };

    this.orders = refreshedOrders;
    this.PrintCurrentOrders();
    this.Log(s"=== RefreshOrdersState finished: retainedOrders=\(ArraySize(this.orders)) ===");

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
    if IsDefined(this.config) && this.config.debug {
      ModLog(n"DeliveryOrders", str);
    };
  }

  private final func LogReadinessState(context: String) -> Void {
    this.Log(s"Readiness failure during \(context): player=\(IsDefined(this.player)), timeSystem=\(IsDefined(this.timeSystem)), transactionSystem=\(IsDefined(this.transactionSystem)), inventoryManager=\(IsDefined(this.inventoryManager))");
  }

  private final func IsReady() -> Bool {
    return IsDefined(this.player) && IsDefined(this.timeSystem) && IsDefined(this.transactionSystem) && IsDefined(this.inventoryManager);
  }
}
