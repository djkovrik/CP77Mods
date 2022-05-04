import CarDealer.Codeware.UI.*
import CarDealer.Classes.PurchasableVehicle
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
      this.ShowCommonElements();
      this.ShowCurrentPage();
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
private func ShowCommonElements() {  
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
  rootCanvas.SetMargin(new inkMargin(0.0, 120.0, 0.0, 0.0));
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

  let buttons: ref<inkHorizontalPanel> = this.GetButtonsContainer();
  buttons.Reparent(horizontalPanel);
}

// Show info for current selected car
@addMethod(WebPage)
public func ShowCurrentPage() {
  let vehicle: ref<PurchasableVehicle> = this.vehiclesStock[this.vehicleIndex];
  let info: ref<inkFlex> = this.GetInfoPanel(vehicle);
  let currentChild: ref<inkWidget> = this.dealerPanelInfoContainer.GetWidgetByIndex(0);
  P(s"ShowCurrentPage call: index \(this.vehicleIndex), last index: \(this.vehicleLastIndex), vehicle: \(GetLocalizedTextByKey(vehicle.record.DisplayName())) \(vehicle.price) \(vehicle.dealerPartName)");
  info.Reparent(this.dealerPanelInfoContainer);
  this.dealerPanelInfoContainer.RemoveChild(currentChild);
  this.RefreshControls(vehicle);
}

// Refresh buttons state
@addMethod(WebPage)
public func RefreshControls(vehicle: ref<PurchasableVehicle>) {
  let id: TweakDBID = vehicle.record.GetID();
  let price: Int32 = vehicle.price;
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  let enoughMoney: Bool = this.HasEnoughMoney(price);
  let disableButton: Bool = isPurchased || !enoughMoney;
  this.buttonBuy.SetDisabled(disableButton);
}

// Create buttons
@addMethod(WebPage)
private func GetButtonsContainer() -> ref<inkHorizontalPanel> {
  let column: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  column.SetName(n"Buttons");
  column.SetFitToContent(true);
  column.SetAnchor(inkEAnchor.Centered);
  column.SetAnchorPoint(new Vector2(0.5, 0.5));
  column.SetMargin(new inkMargin(0.0, 180.0, 0.0, 0.0));
  column.SetChildMargin(new inkMargin(20.0, 0.0, 20.0, 0.0));

  this.buttonPrev = CustomHubButton.Create();
  this.buttonPrev.SetName(n"ButtonPrev");
  this.buttonPrev.SetText(DealerTexts.Previous());
  this.buttonPrev.ToggleAnimations(true);
  this.buttonPrev.ToggleSounds(true);
  this.buttonPrev.SetTextColor(n"MainColors.MediumBlue");
  this.buttonPrev.SetHoverColor(n"MainColors.MediumBlue");
  this.buttonPrev.SetFluffColor(n"MainColors.Blue");
  this.buttonPrev.Reparent(column);

  this.buttonNext = CustomHubButton.Create();
  this.buttonNext.SetName(n"ButtonNext");
  this.buttonNext.SetText(DealerTexts.Next());
  this.buttonNext.ToggleAnimations(true);
  this.buttonNext.ToggleSounds(true);
  this.buttonNext.SetTextColor(n"MainColors.MediumBlue");
  this.buttonNext.SetHoverColor(n"MainColors.MediumBlue");
  this.buttonNext.SetFluffColor(n"MainColors.Blue");
  this.buttonNext.Reparent(column);

  let buyContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
  buyContainer.SetName(n"ButtonBuyContainer");
  buyContainer.SetFitToContent(true);
  buyContainer.SetHAlign(inkEHorizontalAlign.Center);
  buyContainer.SetChildMargin(new inkMargin(240.0, 0.0, 0.0, 0.0));
  buyContainer.Reparent(column);
  this.buttonBuy = CustomHubButton.Create();
  this.buttonBuy.SetName(n"ButtonBuy");
  this.buttonBuy.SetText(DealerTexts.Buy());
  this.buttonBuy.ToggleAnimations(true);
  this.buttonBuy.ToggleSounds(true);
  this.buttonBuy.SetTextColor(n"MainColors.Yellow");
  this.buttonBuy.SetHoverColor(n"MainColors.Yellow");
  this.buttonBuy.SetFluffColor(n"MainColors.Yellow");
  this.buttonBuy.SetLeftSideColor(n"MainColors.Yellow");

  this.buttonBuy.Reparent(buyContainer);

  this.RegisterListeners();

  return column;
}

// Register buttons listeners
@addMethod(WebPage)
protected func RegisterListeners() -> Void {
  P("RegisterListeners...");
  this.buttonPrev.RegisterToCallback(n"OnClick", this, n"OnClick");
  this.buttonPrev.RegisterToCallback(n"OnEnter", this, n"OnEnter");
  this.buttonPrev.RegisterToCallback(n"OnLeave", this, n"OnLeave");

  this.buttonNext.RegisterToCallback(n"OnClick", this, n"OnClick");
  this.buttonNext.RegisterToCallback(n"OnEnter", this, n"OnEnter");
  this.buttonNext.RegisterToCallback(n"OnLeave", this, n"OnLeave");

  this.buttonBuy.RegisterToCallback(n"OnClick", this, n"OnClick");
  this.buttonBuy.RegisterToCallback(n"OnEnter", this, n"OnEnter");
  this.buttonBuy.RegisterToCallback(n"OnLeave", this, n"OnLeave");
}

// Handle click
@addMethod(WebPage)
protected cb func OnClick(evt: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = evt.GetTarget().GetName();
  if evt.IsAction(n"click") {
    switch targetName {
      case n"ButtonPrev":
        this.PreviousLot();
        this.PlayCustomSound(n"ui_menu_onpress");
        break;
      case n"ButtonNext":
        this.NextLot();
        this.PlayCustomSound(n"ui_menu_onpress");
        break;
      case n"ButtonBuy":
        this.BuyCurrentVehicle();
        break;
    };
  };
}

// Handle hover in
@addMethod(WebPage)
protected cb func OnEnter(evt: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = evt.GetTarget().GetName();
  switch targetName {
    case n"ButtonPrev":
      this.buttonPrev.SetHoveredState(true);
      this.PlayCustomSound(n"ui_menu_hover");
      break;
    case n"ButtonNext":
      this.buttonNext.SetHoveredState(true);
      this.PlayCustomSound(n"ui_menu_hover");
      break;
    case n"ButtonBuy":
      this.buttonBuy.SetHoveredState(true);
      this.PlayCustomSound(n"ui_menu_hover");
      break;
  };
}

// Handle hover out
@addMethod(WebPage)
protected cb func OnLeave(evt: ref<inkPointerEvent>) -> Bool {
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
  };
}

// Go to the previous lot
@addMethod(WebPage)
private func PreviousLot() -> Void {
  this.vehicleIndex = this.vehicleIndex - 1;
  P(s"PreviousLot click: new index \(this.vehicleIndex )");
  if this.vehicleIndex < 0 {
    this.vehicleIndex = this.vehicleLastIndex;
    P(s"PreviousLot: index switched to \(this.vehicleIndex )");
  };
  this.ShowCurrentPage();
}

// Go to the next lot
@addMethod(WebPage)
private func NextLot() -> Void {
  this.vehicleIndex = this.vehicleIndex + 1;
  P(s"NextLot click: new index \(this.vehicleIndex )");
  if this.vehicleIndex > this.vehicleLastIndex {
    this.vehicleIndex = 0;
    P(s"NextLot: index switched to \(this.vehicleIndex )");
  };
  this.ShowCurrentPage();
}

// Build info panel for the current selected car
@addMethod(WebPage)
private func GetInfoPanel(vehicle: ref<PurchasableVehicle>) -> ref<inkFlex> {
  let id: TweakDBID = vehicle.record.GetID();
  let name: CName = vehicle.record.DisplayName();
  let price: Int32 = vehicle.price;
  let isPurchasable: Bool = this.purchaseSystem.IsPurchasable(id);
  let isPurchased: Bool = this.purchaseSystem.IsPurchased(id);
  let enoughMoney: Bool = this.HasEnoughMoney(price);

  let infoPanel: ref<inkFlex>;
  let carName: ref<inkText>;
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
  carImage.SetAtlasResource(vehicle.dealerAtlasPath);
  carImage.SetTexturePart(vehicle.dealerPartName);
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

  // Car price
  carPrice = new inkText();
  carPrice.SetName(n"CarPrice");
  carPrice.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  carPrice.SetFontStyle(n"Regular");
  carPrice.SetFontSize(56);
  carPrice.SetLetterCase(textLetterCase.UpperCase);
  carPrice.SetText(s"\(price) \(GetLocalizedTextByKey(n"Common-Characters-EuroDollar"))");
  carPrice.SetFitToContent(true);
  carPrice.SetHAlign(inkEHorizontalAlign.Right);
  carPrice.SetVAlign(inkEVerticalAlign.Top);
  carPrice.SetAnchor(inkEAnchor.TopRight);
  carPrice.SetAnchorPoint(new Vector2(0.5, 0.5));
  carPrice.SetMargin(new inkMargin(0.0, -80.0, 0.0, 0.0));
  carPrice.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  carPrice.BindProperty(n"tintColor", n"MainColors.Yellow");
  carPrice.Reparent(infoPanel);

  // Status text: Lot x of xx available / purchased / no eddies
  carStatus = new inkText();
  carStatus.SetName(n"CarStatus");
  carStatus.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  carStatus.SetFontStyle(n"Semi-Bold");
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

  if isPurchased {
    carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.Purchased())");
    carStatus.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    carStatus.BindProperty(n"tintColor", n"MainColors.Yellow");
  } else {
    if !enoughMoney {
      carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.NoMoni())");
      carStatus.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
      carStatus.BindProperty(n"tintColor", n"MainColors.Red");
    } else {
      if isPurchasable {
        carStatus.SetText(s"\(DealerTexts.Lot()) \(lotNumber) \(DealerTexts.Of()) \(totalLots): \(DealerTexts.Available())");
        carStatus.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        carStatus.BindProperty(n"tintColor", n"MainColors.Green");
      };
    };
  };

  carStatus.Reparent(infoPanel);

  return infoPanel;
}
