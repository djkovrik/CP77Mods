module AtelierDelivery

public class MessengerSystemNotifyCallback extends DelayCallback {
  private let system: wref<DeliveryMessengerSystem>;
  private let message: ref<DeliveryHistoryItem>;

  public static func Create(system: ref<DeliveryMessengerSystem>, message: ref<DeliveryHistoryItem>) -> ref<MessengerSystemNotifyCallback> {
    let instance: ref<MessengerSystemNotifyCallback> = new MessengerSystemNotifyCallback();
    instance.system = system;
    instance.message = message;
    return instance;
  }

	public func Call() -> Void {
    this.system.PushNewNotificationItem(this.message);
	}
}
