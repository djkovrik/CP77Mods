module AtelierDelivery
import Codeware.UI.*

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
    this.customerName.SetText("{name} ***", customerNameParams);
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
    subtotalParams.AddNumber("price", this.params.price);
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
    shippingCostParams.AddNumber("cost", shippingPrice);
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
    totalParams.AddNumber("price", this.totalOrderPrice);
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
