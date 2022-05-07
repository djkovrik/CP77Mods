import CarDealer.Codeware.UI.*
import CarDealer.Classes.PurchasableVehicleBundle
import CarDealer.Classes.PurchasableVehicleVariant
import CarDealer.System.PurchasableVehicleSystem
import CarDealer.Utils.DealerTexts
import CarDealer.Utils.P

// Show core dealer page
@addMethod(WebPage)
private func PopulateDealerView(owner: ref<GameObject>) {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  this.dealerPanelRoot = root.GetWidget(n"page") as inkVerticalPanel;
  let player: ref<PlayerPuppet> = owner as PlayerPuppet;
  let stockSize: Int32;
  if IsDefined(player) {
    this.playerPuppet = player;
    this.purchaseSystem = PurchasableVehicleSystem.GetInstance(player.GetGame());
    this.vehiclesStock = this.purchaseSystem.m_storeVehicles;
    stockSize = ArraySize(this.vehiclesStock);
    P(s"Stock size: \(stockSize)");
    if Equals(stockSize, 0) {
      this.ShowDealerEmptyScreen();
    } else {
      this.vehicleIndex = 0;
      this.vehicleLastIndex = stockSize - 1;
      this.vehicleVariantIndex = 0;
      this.vehicleVariantLastIndex = ArraySize(this.vehiclesStock[this.vehicleIndex].variants) - 1;
      this.ShowDealerCommonElements();
      this.ShowDealerCurrentPage();
    };
  };
}

// Show empty screen
@addMethod(WebPage)
private func ShowDealerEmptyScreen() -> Void {
  this.dealerPanelRoot.RemoveAllChildren();
  let emptyMessage1: ref<inkText> = new inkText();
  emptyMessage1.SetName(n"FirstLabel");
  emptyMessage1.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  emptyMessage1.SetFontStyle(n"Semi-Bold");
  emptyMessage1.SetFontSize(62);
  emptyMessage1.SetLetterCase(textLetterCase.OriginalCase);
  emptyMessage1.SetText(DealerTexts.NoDeals1());
  emptyMessage1.SetFitToContent(true);
  emptyMessage1.SetHAlign(inkEHorizontalAlign.Center);
  emptyMessage1.SetVAlign(inkEVerticalAlign.Center);
  emptyMessage1.SetAnchor(inkEAnchor.Centered);
  emptyMessage1.SetAnchorPoint(new Vector2(0.5, 0.5));
  emptyMessage1.SetMargin(new inkMargin(0.0, 200.0, 0.0, 0.0));
  emptyMessage1.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  emptyMessage1.BindProperty(n"tintColor", n"MainColors.White");
  emptyMessage1.Reparent(this.dealerPanelRoot);

  let emptyMessage2: ref<inkText> = new inkText();
  emptyMessage2.SetName(n"SecondLabel");
  emptyMessage2.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  emptyMessage2.SetFontStyle(n"Semi-Bold");
  emptyMessage2.SetFontSize(58);
  emptyMessage2.SetLetterCase(textLetterCase.OriginalCase);
  emptyMessage2.SetText(DealerTexts.NoDeals2());
  emptyMessage2.SetFitToContent(true);
  emptyMessage2.SetHAlign(inkEHorizontalAlign.Center);
  emptyMessage2.SetVAlign(inkEVerticalAlign.Center);
  emptyMessage2.SetAnchor(inkEAnchor.Centered);
  emptyMessage2.SetAnchorPoint(new Vector2(0.5, 1.0));
  emptyMessage2.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  emptyMessage2.BindProperty(n"tintColor", n"MainColors.White");
  emptyMessage2.Reparent(this.dealerPanelRoot);

  let sponsored: ref<inkText> = new inkText();
  sponsored.SetName(n"SponsoredLabel");
  sponsored.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  sponsored.SetFontStyle(n"Regular");
  sponsored.SetFontSize(48);
  sponsored.SetLetterCase(textLetterCase.OriginalCase);
  sponsored.SetText(DealerTexts.SponsoredBy());
  sponsored.SetFitToContent(true);
  sponsored.SetHAlign(inkEHorizontalAlign.Center);
  sponsored.SetVAlign(inkEVerticalAlign.Center);
  sponsored.SetAnchor(inkEAnchor.Centered);
  sponsored.SetAnchorPoint(new Vector2(0.5, 0.5));
  sponsored.SetMargin(new inkMargin(0.0, 600.0, 0.0, 0.0));
  sponsored.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  sponsored.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  sponsored.Reparent(this.dealerPanelRoot);

  let emptyImage: ref<inkImage> = new inkImage();
  emptyImage.SetName(n"SponsoredImage");
  emptyImage.SetAtlasResource(r"base\\gameplay\\gui\\world\\adverts\\rayfield\\rayfield.inkatlas");
  emptyImage.SetTexturePart(n"logo");
  emptyImage.SetInteractive(false);
  emptyImage.SetAnchorPoint(new Vector2(0.5, 0.5));
  emptyImage.SetFitToContent(true);
  emptyImage.SetHAlign(inkEHorizontalAlign.Center);
  emptyImage.SetVAlign(inkEVerticalAlign.Center);
  emptyImage.SetAnchor(inkEAnchor.Centered);
  emptyImage.SetAnchorPoint(new Vector2(0.5, 0.5));
  emptyImage.Reparent(this.dealerPanelRoot);
}

// Show basic UI elements
@addMethod(WebPage)
private func ShowDealerCommonElements() {  
  this.dealerPanelRoot.RemoveAllChildren();
  this.GetRootCompoundWidget().SetInteractive(true);
  this.dealerPanelRoot.SetInteractive(true);

  let rootCanvas: ref<inkCanvas> = new inkCanvas();
  rootCanvas.SetName(n"RootCanvas");
  rootCanvas.SetFitToContent(true);
  rootCanvas.SetInteractive(true);
  rootCanvas.SetSize(new Vector2(2600.0, 1000.0));
  rootCanvas.SetHAlign(inkEHorizontalAlign.Center);
  rootCanvas.SetVAlign(inkEVerticalAlign.Center);
  rootCanvas.SetAnchor(inkEAnchor.Centered);
  rootCanvas.SetAnchorPoint(new Vector2(0.5, 0.5));
  rootCanvas.SetMargin(new inkMargin(0.0, 140.0, 0.0, 0.0));
  rootCanvas.Reparent(this.dealerPanelRoot);

  let horizontalPanel: ref<inkVerticalPanel> = new inkVerticalPanel();
  horizontalPanel.SetName(n"HorizontalRoot");
  horizontalPanel.SetFitToContent(true);
  horizontalPanel.SetInteractive(true);
  horizontalPanel.SetSize(new Vector2(2600.0, 1000.0));
  horizontalPanel.SetHAlign(inkEHorizontalAlign.Center);
  horizontalPanel.SetVAlign(inkEVerticalAlign.Center);
  horizontalPanel.SetAnchor(inkEAnchor.Centered);
  horizontalPanel.SetAnchorPoint(new Vector2(0.5, 0.5));
  horizontalPanel.Reparent(rootCanvas);

  this.dealerPanelInfoContainer = new inkVerticalPanel();
  this.dealerPanelInfoContainer.SetName(n"DynamicContentContainer");
  this.dealerPanelInfoContainer.SetFitToContent(true);
  this.dealerPanelInfoContainer.Reparent(horizontalPanel);

  let buttons: ref<inkVerticalPanel> = this.GetDealerButtonsContainer();
  buttons.Reparent(horizontalPanel);
}

// Show info for current selected car
@addMethod(WebPage)
public func ShowDealerCurrentPage() {
  let bundle: ref<PurchasableVehicleBundle> = this.vehiclesStock[this.vehicleIndex];
  let variant: ref<PurchasableVehicleVariant> = bundle.variants[this.vehicleVariantIndex];
  let info: ref<inkFlex> = this.GetDealerInfoPanel(bundle, variant);
  let currentChild: ref<inkWidget> = this.dealerPanelInfoContainer.GetWidgetByIndex(0);
  info.Reparent(this.dealerPanelInfoContainer);
  this.dealerPanelInfoContainer.RemoveChild(currentChild);
  this.RefreshDealerControls(variant.record.GetID(), bundle.cred, bundle.price);
}

// Refresh buttons state
@addMethod(WebPage)
public func RefreshDealerControls(id: TweakDBID, cred: Int32, price: Int32) {
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  let enoughCred: Bool = this.HasEnoughStreetCredDealer(cred);
  let enoughMoney: Bool = this.HasEnoughMoneyDealer(price);
  let disableBuy: Bool = isPurchased || !enoughMoney || !enoughCred;
  let disableColor: Bool = Equals(this.vehicleVariantLastIndex, 0);
  this.buttonBuy.SetDisabled(disableBuy);
  this.buttonColor.SetDisabled(disableColor);
}

// Create buttons
@addMethod(WebPage)
private func GetDealerButtonsContainer() -> ref<inkVerticalPanel> {
  let rowTop: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  rowTop.SetName(n"ButtonsTop");
  rowTop.SetFitToContent(true);
  rowTop.SetAnchor(inkEAnchor.Centered);
  rowTop.SetAnchorPoint(new Vector2(0.5, 0.5));
  rowTop.SetMargin(new inkMargin(0.0, 140.0, 0.0, 0.0));
  rowTop.SetChildMargin(new inkMargin(20.0, 0.0, 20.0, 0.0));

  this.buttonPrev = CustomHubButton.Create();
  this.buttonPrev.SetName(n"ButtonPrev");
  this.buttonPrev.SetText(DealerTexts.Previous());
  this.buttonPrev.ToggleAnimations(true);
  this.buttonPrev.ToggleSounds(true);
  this.buttonPrev.SetTextColor(n"MainColors.MediumBlue");
  this.buttonPrev.SetHoverColor(n"MainColors.MediumBlue");
  this.buttonPrev.SetFluffColor(n"MainColors.Blue");
  this.buttonPrev.Reparent(rowTop);

  this.buttonNext = CustomHubButton.Create();
  this.buttonNext.SetName(n"ButtonNext");
  this.buttonNext.SetText(DealerTexts.Next());
  this.buttonNext.ToggleAnimations(true);
  this.buttonNext.ToggleSounds(true);
  this.buttonNext.SetTextColor(n"MainColors.MediumBlue");
  this.buttonNext.SetHoverColor(n"MainColors.MediumBlue");
  this.buttonNext.SetFluffColor(n"MainColors.Blue");
  this.buttonNext.Reparent(rowTop);

  let colorContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
  colorContainer.SetName(n"ButtonBuyContainer");
  colorContainer.SetFitToContent(true);
  colorContainer.SetHAlign(inkEHorizontalAlign.Center);
  colorContainer.SetChildMargin(new inkMargin(240.0, 0.0, 0.0, 0.0));
  colorContainer.Reparent(rowTop);
  this.buttonColor = CustomHubButton.Create();
  this.buttonColor.SetName(n"ButtonColor");
  this.buttonColor.SetText(DealerTexts.ChangeColor());
  this.buttonColor.ToggleAnimations(true);
  this.buttonColor.ToggleSounds(true);
  this.buttonColor.SetTextColor(n"MainColors.MediumBlue");
  this.buttonColor.SetHoverColor(n"MainColors.MediumBlue");
  this.buttonColor.SetFluffColor(n"MainColors.Blue");
  this.buttonColor.Reparent(colorContainer);

  let rowBottom: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  rowBottom.SetName(n"ButtonsBottom");
  rowBottom.SetFitToContent(true);
  rowBottom.SetHAlign(inkEHorizontalAlign.Right);
  rowBottom.SetAnchor(inkEAnchor.CenterRight);
  rowBottom.SetAnchorPoint(new Vector2(0.5, 0.5));
  rowBottom.SetMargin(new inkMargin(0.0, 40.0, 0.0, 0.0));
  rowBottom.SetChildMargin(new inkMargin(20.0, 0.0, 20.0, 0.0));

  this.buttonBuy = CustomHubButton.Create();
  this.buttonBuy.SetName(n"ButtonBuy");
  this.buttonBuy.SetText(DealerTexts.Buy());
  this.buttonBuy.ToggleAnimations(true);
  this.buttonBuy.ToggleSounds(true);
  this.buttonBuy.SetTextColor(n"MainColors.Yellow");
  this.buttonBuy.SetHoverColor(n"MainColors.Yellow");
  this.buttonBuy.SetFluffColor(n"MainColors.Yellow");
  this.buttonBuy.SetLeftSideColor(n"MainColors.Yellow");
  this.buttonBuy.Reparent(rowBottom);


  this.RegisterDealerListeners();

  let result: ref<inkVerticalPanel> = new inkVerticalPanel();
  rowTop.Reparent(result);
  rowBottom.Reparent(result);
  return result;
}

// Register buttons listeners
@addMethod(WebPage)
protected func RegisterDealerListeners() -> Void {
  P("RegisterDealerListeners...");
  this.buttonPrev.RegisterToCallback(n"OnClick", this, n"OnDealerButtonClick");
  this.buttonPrev.RegisterToCallback(n"OnEnter", this, n"OnDealerButtonEnter");
  this.buttonPrev.RegisterToCallback(n"OnLeave", this, n"OnDealerButtonLeave");

  this.buttonNext.RegisterToCallback(n"OnClick", this, n"OnDealerButtonClick");
  this.buttonNext.RegisterToCallback(n"OnEnter", this, n"OnDealerButtonEnter");
  this.buttonNext.RegisterToCallback(n"OnLeave", this, n"OnDealerButtonLeave");

  this.buttonBuy.RegisterToCallback(n"OnClick", this, n"OnDealerButtonClick");
  this.buttonBuy.RegisterToCallback(n"OnEnter", this, n"OnDealerButtonEnter");
  this.buttonBuy.RegisterToCallback(n"OnLeave", this, n"OnDealerButtonLeave");

  this.buttonColor.RegisterToCallback(n"OnClick", this, n"OnDealerButtonClick");
  this.buttonColor.RegisterToCallback(n"OnEnter", this, n"OnDealerButtonEnter");
  this.buttonColor.RegisterToCallback(n"OnLeave", this, n"OnDealerButtonLeave");
}

// Handle click
@addMethod(WebPage)
protected cb func OnDealerButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = evt.GetTarget().GetName();
  if evt.IsAction(n"click") {
    switch targetName {
      case n"ButtonPrev":
        this.PreviousDealerLot();
        this.PlayCustomSoundDealer(n"ui_menu_onpress");
        break;
      case n"ButtonNext":
        this.NextDealerLot();
        this.PlayCustomSoundDealer(n"ui_menu_onpress");
        break;
      case n"ButtonColor":
        if NotEquals(this.vehicleVariantLastIndex, 0) {
          this.NextDealerColor();
          this.PlayCustomSoundDealer(n"ui_menu_onpress");
        };
        break;
      case n"ButtonBuy":
        this.DealerBuyCurrentVehicle();
        break;
    };
  };
}

// Handle hover in
@addMethod(WebPage)
protected cb func OnDealerButtonEnter(evt: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = evt.GetTarget().GetName();
  switch targetName {
    case n"ButtonPrev":
      this.buttonPrev.SetHoveredState(true);
      this.PlayCustomSoundDealer(n"ui_menu_hover");
      break;
    case n"ButtonNext":
      this.buttonNext.SetHoveredState(true);
      this.PlayCustomSoundDealer(n"ui_menu_hover");
      break;
    case n"ButtonBuy":
      this.buttonBuy.SetHoveredState(true);
      this.PlayCustomSoundDealer(n"ui_menu_hover");
      break;
    case n"ButtonColor":
      this.buttonColor.SetHoveredState(true);
      this.PlayCustomSoundDealer(n"ui_menu_hover");
      break;
  };
}

// Handle hover out
@addMethod(WebPage)
protected cb func OnDealerButtonLeave(evt: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = evt.GetTarget().GetName();
  switch targetName {
    case n"ButtonPrev":
      this.buttonPrev.SetHoveredState(false);
      break;
    case n"ButtonNext":
      this.buttonNext.SetHoveredState(false);
      break;
    case n"ButtonBuy":
      this.buttonBuy.SetHoveredState(false);
      break;
    case n"ButtonColor":
      this.buttonColor.SetHoveredState(false);
      break;
  };
}

// Go to the previous lot
@addMethod(WebPage)
private func PreviousDealerLot() -> Void {
  this.vehicleIndex = this.vehicleIndex - 1;
  P(s"PreviousDealerLot click: new index \(this.vehicleIndex )");
  if this.vehicleIndex < 0 {
    this.vehicleIndex = this.vehicleLastIndex;
    P(s"PreviousDealerLot: index switched to \(this.vehicleIndex )");
  };
  this.vehicleVariantIndex = 0;
  this.vehicleVariantLastIndex = ArraySize(this.vehiclesStock[this.vehicleIndex].variants) - 1;
  this.ShowDealerCurrentPage();
}

// Go to the next lot
@addMethod(WebPage)
private func NextDealerLot() -> Void {
  this.vehicleIndex = this.vehicleIndex + 1;
  P(s"NextDealerLot click: new index \(this.vehicleIndex)");
  if this.vehicleIndex > this.vehicleLastIndex {
    this.vehicleIndex = 0;
    P(s"NextDealerLot: index switched to \(this.vehicleIndex)");
  };
  this.vehicleVariantIndex = 0;
  this.vehicleVariantLastIndex = ArraySize(this.vehiclesStock[this.vehicleIndex].variants) - 1;
  this.ShowDealerCurrentPage();
}

@addMethod(WebPage)
private func NextDealerColor() -> Void {
  this.vehicleVariantIndex = this.vehicleVariantIndex + 1;
  P(s"NextDealerColor click: new index \(this.vehicleVariantIndex)");
  if this.vehicleVariantIndex > this.vehicleVariantLastIndex {
    this.vehicleVariantIndex = 0;
    P(s"NextDealerColor: index switched to \(this.vehicleVariantIndex)");
  };
  this.ShowDealerCurrentPage();
}

// Build info panel for the current selected car
@addMethod(WebPage)
private func GetDealerInfoPanel(bundle: ref<PurchasableVehicleBundle>, variant: ref<PurchasableVehicleVariant>) -> ref<inkFlex> {
  let id: TweakDBID = variant.record.GetID();
  let name: CName = variant.record.DisplayName();
  let cred: Int32 = bundle.cred;
  let price: Int32 = bundle.price;
  let isPurchasable: Bool = this.purchaseSystem.IsPurchasable(id);
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  let enoughCred: Bool = this.HasEnoughStreetCredDealer(cred);
  let enoughMoney: Bool = this.HasEnoughMoneyDealer(price);

  let infoPanel: ref<inkFlex>;
  let carName: ref<inkText>;
  let carCred: ref<inkText>;
  let carPrice: ref<inkText>;
  let carImage: ref<inkImage>;
  let carStatus: ref<inkText>;
  
  // Root container
  infoPanel = new inkFlex();
  infoPanel.SetName(StringToName(s"TextInfoPanel_\(this.vehicleIndex)"));
  infoPanel.SetFitToContent(true);
  infoPanel.SetHAlign(inkEHorizontalAlign.Right);
  infoPanel.SetVAlign(inkEVerticalAlign.Center);
  infoPanel.SetAnchor(inkEAnchor.CenterRight);
  infoPanel.SetMargin(new inkMargin(0.0, 100.0, 0.0, 0.0));
  infoPanel.SetAnchorPoint(new Vector2(0.5, 0.5));

  // Image
  carImage = new inkImage();
  carImage.SetName(n"CarImage");
  carImage.SetAtlasResource(variant.dealerAtlasPath);
  carImage.SetTexturePart(variant.dealerPartName);
  carImage.SetInteractive(false);
  carImage.SetFitToContent(true);
  carImage.SetHAlign(inkEHorizontalAlign.Center);
  carImage.SetVAlign(inkEVerticalAlign.Center);
  carImage.SetAnchor(inkEAnchor.Centered);
  carImage.SetAnchorPoint(new Vector2(0.5, 0.5));
  carImage.Reparent(infoPanel);

  // Frame around the image
  let frame: ref<inkImage> = new inkImage();
  frame.SetName(n"frame");
  frame.SetNineSliceScale(true);
  frame.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
  frame.SetBrushTileType(inkBrushTileType.NoTile);
  frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
  frame.SetTexturePart(n"rect_shape_fg");
  frame.SetContentHAlign(inkEHorizontalAlign.Fill);
  frame.SetContentVAlign(inkEVerticalAlign.Fill);
  frame.SetTileHAlign(inkEHorizontalAlign.Left);
  frame.SetTileVAlign(inkEVerticalAlign.Top);
  frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  frame.BindProperty(n"tintColor", n"MainColors.ActiveRed");
  frame.SetOpacity(0.75);
  frame.Reparent(infoPanel);

  // Car label
  carName = new inkText();
  carName.SetName(n"CarName");
  carName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  carName.SetFontStyle(n"Semi-Bold");
  carName.SetFontSize(56);
  carName.SetLetterCase(textLetterCase.UpperCase);
  carName.SetText(GetLocalizedTextByKey(name));
  carName.SetFitToContent(true);
  carName.SetHAlign(inkEHorizontalAlign.Left);
  carName.SetVAlign(inkEVerticalAlign.Top);
  carName.SetAnchor(inkEAnchor.TopLeft);
  carName.SetAnchorPoint(new Vector2(0.5, 0.5));
  carName.SetMargin(new inkMargin(0.0, -80.0, 0.0, 0.0));
  carName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  carName.BindProperty(n"tintColor", n"MainColors.Blue");
  carName.Reparent(infoPanel);

  let priceCredContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  priceCredContainer.SetName(n"PriceCredContainer");
  priceCredContainer.SetMargin(new inkMargin(0.0, -80.0, 0.0, 0.0));
  priceCredContainer.SetHAlign(inkEHorizontalAlign.Right);
  priceCredContainer.SetVAlign(inkEVerticalAlign.Top);
  priceCredContainer.SetAnchor(inkEAnchor.TopRight);
  priceCredContainer.SetAnchorPoint(new Vector2(0.5, 0.5));

  // Car cred
  carCred = new inkText();
  carCred.SetName(n"CarCred");
  carCred.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  carCred.SetFontStyle(n"Regular");
  carCred.SetFontSize(56);
  carCred.SetLetterCase(textLetterCase.OriginalCase);
  carCred.SetText(s"\(cred) SC");
  carCred.SetFitToContent(true);
  carCred.SetMargin(new inkMargin(0.0, 0.0, 60.0, 0.0));
  carCred.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  carCred.BindProperty(n"tintColor", n"MainColors.Green");
  carCred.Reparent(priceCredContainer);

  // Car price
  carPrice = new inkText();
  carPrice.SetName(n"CarPrice");
  carPrice.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  carPrice.SetFontStyle(n"Regular");
  carPrice.SetFontSize(56);
  carPrice.SetLetterCase(textLetterCase.UpperCase);
  carPrice.SetText(s"\(price) \(GetLocalizedTextByKey(n"Common-Characters-EuroDollar"))");
  carPrice.SetFitToContent(true);
  carPrice.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  carPrice.BindProperty(n"tintColor", n"MainColors.Yellow");
  carPrice.Reparent(priceCredContainer);

  priceCredContainer.Reparent(infoPanel);

  // Status text: Lot x of xx available / purchased / no eddies
  carStatus = new inkText();
  carStatus.SetName(n"CarStatus");
  carStatus.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  carStatus.SetFontStyle(n"Regular");
  carStatus.SetFontSize(62);
  carStatus.SetLetterCase(textLetterCase.OriginalCase);
  carStatus.SetFitToContent(true);
  carStatus.SetHAlign(inkEHorizontalAlign.Center);
  carStatus.SetVAlign(inkEVerticalAlign.Bottom);
  carStatus.SetAnchor(inkEAnchor.BottomCenter);
  carStatus.SetAnchorPoint(new Vector2(0.5, 0.5));
  carStatus.SetMargin(new inkMargin(0.0, 0.0, 0.0, -100.0));
  let lotNumber: Int32 = this.vehicleIndex + 1;
  let totalLots: Int32 = this.vehicleLastIndex + 1;
  carStatus.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");

  if isPurchased {
    carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.Purchased())");
    carStatus.BindProperty(n"tintColor", n"MainColors.Yellow");
  } else {
    if !enoughCred {
        carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.NoCred())");
        carStatus.BindProperty(n"tintColor", n"MainColors.Green");
    } else {
      if !enoughMoney {
        carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.NoMoni())");
        carStatus.BindProperty(n"tintColor", n"MainColors.Red");
      } else {
        if isPurchasable {
          carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.Available())");
          carStatus.BindProperty(n"tintColor", n"MainColors.ActiveGreen");
        };
      };
    };
  };

  carStatus.Reparent(infoPanel);

  return infoPanel;
}
