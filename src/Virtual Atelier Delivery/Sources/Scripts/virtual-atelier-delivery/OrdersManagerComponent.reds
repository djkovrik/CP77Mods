module AtelierDelivery
import Codeware.UI.*

public class OrdersManagerComponent extends inkComponent {
  let player: wref<GameObject>;
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
    OrderTrackingTicker.Get(this.player.GetGame()).CancelScheduledCallback();
    this.InitializeWidgets();
    this.RefreshComponentsList();
  }

  protected cb func OnUninitialize() -> Void {
    OrderTrackingTicker.Get(GetGameInstance()).ScheduleCallbackShortened();
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
    this.orders = OrderProcessingSystem.Get(GetGameInstance()).GetOrders();
    let isEmpty: Bool = Equals(ArraySize(this.orders), 0);
    this.scrollWrapper.SetVisible(!isEmpty);
    this.emptyPlaceholder.SetVisible(isEmpty);

    if isEmpty {
      return ;
    };

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
