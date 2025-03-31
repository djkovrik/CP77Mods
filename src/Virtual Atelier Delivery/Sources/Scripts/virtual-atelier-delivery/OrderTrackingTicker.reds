module AtelierDelivery

public class OrderTrackingTicker extends ScriptableSystem {
  private let delaySystem: wref<DelaySystem>;
  private let delayId: DelayID;
  private let checkingPeriodShort: Float = 5.0;
  private let checkingPeriodNormal: Float = 20.0;

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
