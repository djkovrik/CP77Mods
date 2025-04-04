module AtelierDelivery
import Codeware.UI.*

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
    storeName.SetSize(620.0, 74.0);
    storeName.SetWrapping(false, 600, textWrappingPolicy.PerCharacter);
    storeName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    storeName.SetLetterCase(textLetterCase.OriginalCase);
    storeName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    storeName.BindProperty(n"tintColor", n"MainColors.White");
    storeName.Reparent(storeAndStatus);

    let status: ref<inkText> = new inkText();
    status.SetName(n"statusUpdate");
    status.SetFitToContent(false);
    status.SetSize(620.0, 64.0);
    status.SetWrapping(false, 600, textWrappingPolicy.PerCharacter);
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
    locationWrapper.SetMargin(new inkMargin(48.0, 0.0, 64.0, 0.0));
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
