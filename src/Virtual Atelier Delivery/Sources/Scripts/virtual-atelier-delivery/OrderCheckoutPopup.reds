module AtelierDelivery
import Codeware.UI.*

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

  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryPopup", str);
    };
  }
}
