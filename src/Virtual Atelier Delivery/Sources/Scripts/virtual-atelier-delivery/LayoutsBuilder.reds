module AtelierDelivery
import Codeware.UI.*

public abstract class LayoutsBuilder {

  public final static func CheckoutContainer() -> ref<inkWidget> {
    let orderInfo: ref<inkWidget> = LayoutsBuilder.BuildOrderInfo();
    let customerInfo: ref<inkWidget> = LayoutsBuilder.BuildCustomerInfo();
    let deliverySelector: ref<inkWidget> = LayoutsBuilder.BuildDeliverySelector();
    let destinationSelector: ref<inkWidget> = LayoutsBuilder.BuildDestinationSelector();
    
    let rootCanvas: ref<inkCanvas> = new inkCanvas();
    rootCanvas.SetName(n"RootCanvas");
    rootCanvas.SetSize(1400.0, 1040.0);

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

    let firstRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
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
    clientName.SetText("Valerie ***");
    clientName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    clientName.BindProperty(n"tintColor", n"MainColors.Red");
    clientName.Reparent(firstRow);

    let secondRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
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
    border.SetThickness(4);
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
