module AtelierDelivery

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
