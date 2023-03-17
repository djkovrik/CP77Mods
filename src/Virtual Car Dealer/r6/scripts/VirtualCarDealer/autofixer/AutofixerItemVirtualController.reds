module CarDealer
import CarDealer.Classes.AutofixerSellEvent
import CarDealer.Classes.AutofixerItemData
import Codeware.UI.*

class AutofixerItemVirtualController extends inkVirtualCompoundItemController {
  private let m_root: ref<inkCompoundWidget>;
  private let m_title: ref<inkText>;
  private let m_icon: ref<inkImage>;
  private let m_price: ref<inkText>;
  private let m_button: ref<SimpleButton>;
  private let m_data: ref<AutofixerItemData>;

  protected cb func OnInitialize() -> Bool {
    this.m_root = this.GetRootCompoundWidget();
    this.InitializeWidgets();
    this.RegisterToCallback(n"OnPress", this, n"OnButtonClick");
  }

  protected cb func OnButtonClick(evt: ref<inkPointerEvent>) -> Bool {
    let sellEvent: ref<AutofixerSellEvent>;
    if evt.IsAction(n"click") && Equals(evt.GetTarget().GetName(), n"ButtonSell") && !this.m_data.sold {
      this.m_data.sold = true;
      this.RefreshView();
      sellEvent = new AutofixerSellEvent();
      sellEvent.data = this.m_data;
      this.QueueEvent(sellEvent);
    };
  }

  protected cb func OnDataChanged(value: Variant) {
    this.m_data = FromVariant<ref<IScriptable>>(value) as AutofixerItemData;

    if IsDefined(this.m_data) {
      this.RefreshView();
    };
  }

  private func RefreshView() -> Void {
    this.m_title.SetText(this.m_data.title);
    this.m_price.SetText(s"\(this.m_data.price) \(GetLocalizedText("Common-Characters-EuroDollar"))");
    this.m_icon.SetAtlasResource(this.m_data.atlasResource);
    this.m_icon.SetTexturePart(this.m_data.textureName);

    this.m_button.SetDisabledState(this.m_data.sold);
    if this.m_data.sold {
      this.m_button.SetText(GetLocalizedText("LocKey#8028"));
    } else {
      this.m_button.SetText(GetLocalizedText("LocKey#17848"));
    };
  }

  private func InitializeWidgets() -> Void {
    let container = new inkCanvas();
    container.SetName(n"container");
    container.SetFitToContent(true);
    container.SetSize(new Vector2(940.0, 480.0));
    container.SetMargin(new inkMargin(40.0, 40.0, 40.0, 40.0));
    container.SetHAlign(inkEHorizontalAlign.Left);
    container.SetVAlign(inkEVerticalAlign.Bottom);
    container.SetAnchor(inkEAnchor.BottomLeft);
    container.SetAnchorPoint(new Vector2(0.0, 1.0));
    container.Reparent(this.m_root);

    let horizontalPanel = new inkHorizontalPanel();
    horizontalPanel.SetMargin(new inkMargin(20.0, 20.0, 20.0, 20.0));
    horizontalPanel.SetName(n"Horizontal");
    horizontalPanel.Reparent(container);

    let nameImagePanel = new inkVerticalPanel();
    nameImagePanel.SetName(n"LabelAndImage");
    nameImagePanel.SetFitToContent(true);
    nameImagePanel.SetHAlign(inkEHorizontalAlign.Left);
    nameImagePanel.SetVAlign(inkEVerticalAlign.Bottom);
    nameImagePanel.SetAnchor(inkEAnchor.BottomLeft);
    nameImagePanel.SetMargin(new inkMargin(0.0, 70.0, 0.0, 0.0));
    nameImagePanel.Reparent(horizontalPanel);

    let carName = new inkText();
    carName.SetName(n"CarName");
    carName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    carName.SetFontStyle(n"Semi-Bold");
    carName.SetFontSize(50);
    carName.SetLetterCase(textLetterCase.UpperCase);
    carName.SetText("Kusanagi CTX-3X CTX-3X CTX-3X");
    carName.SetFitToContent(true);
    carName.SetHAlign(inkEHorizontalAlign.Left);
    carName.SetVAlign(inkEVerticalAlign.Top);
    carName.SetAnchor(inkEAnchor.TopLeft);
    carName.SetAnchorPoint(new Vector2(0.0, 0.0));
    carName.SetMargin(new inkMargin(24.0, 24.0, 0.0, 24.0));
    carName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    carName.BindProperty(n"tintColor", n"MainColors.Blue");
    carName.Reparent(container);
    this.m_title = carName;

    let imageContainer: ref<inkCanvas> = new inkCanvas();
    imageContainer.SetName(n"ImageContainer");
    imageContainer.SetSize(new Vector2(490.0, 340.0));
    imageContainer.SetInteractive(false);
    imageContainer.SetFitToContent(true);
    imageContainer.SetHAlign(inkEHorizontalAlign.Left);
    imageContainer.SetVAlign(inkEVerticalAlign.Bottom);
    imageContainer.SetAnchor(inkEAnchor.BottomLeft);
    imageContainer.SetAnchorPoint(new Vector2(0.5, 0.5));
    imageContainer.SetMargin(new inkMargin(8.0, 8.0, 0.0, 8.0));
    imageContainer.Reparent(nameImagePanel);

    let background: ref<inkRectangle> = new inkRectangle();
    background.SetName(n"ImageBackground");
    background.SetFitToContent(true);
    background.SetAnchor(inkEAnchor.Fill);
    background.SetAnchorPoint(new Vector2(0.5, 0.5));
    background.SetHAlign(inkEHorizontalAlign.Fill);
    background.SetVAlign(inkEVerticalAlign.Fill);
    background.SetTintColor(new HDRColor(0.0, 0.0, 0.0, 1.0));
    background.SetOpacity(0.8);
    background.Reparent(imageContainer);

    let carImage = new inkImage();
    carImage.SetName(n"CarImage");
    carImage.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\vehicles_icons.inkatlas");
    carImage.SetTexturePart(n"archer_quartz_bandit");
    carImage.SetInteractive(false);
    carImage.SetFitToContent(true);
    carImage.SetSize(new Vector2(480.0, 330.0));
    carImage.SetHAlign(inkEHorizontalAlign.Center);
    carImage.SetVAlign(inkEVerticalAlign.Center);
    carImage.SetContentHAlign(inkEHorizontalAlign.Center);
    carImage.SetContentVAlign(inkEVerticalAlign.Center);
    carImage.SetTileHAlign(inkEHorizontalAlign.Center);
    carImage.SetTileVAlign(inkEVerticalAlign.Center);
    carImage.SetAnchor(inkEAnchor.Centered);
    carImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    carImage.Reparent(imageContainer);
    this.m_icon = carImage;

    let frame2: ref<inkImage> = new inkImage();
    frame2.SetName(n"frame2");
    frame2.SetNineSliceScale(true);
    frame2.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    frame2.SetBrushTileType(inkBrushTileType.NoTile);
    frame2.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame2.SetTexturePart(n"rect_shape_fg");
    frame2.SetContentHAlign(inkEHorizontalAlign.Fill);
    frame2.SetContentVAlign(inkEVerticalAlign.Fill);
    frame2.SetTileHAlign(inkEHorizontalAlign.Left);
    frame2.SetTileVAlign(inkEVerticalAlign.Top);
    frame2.SetSize(new Vector2(490.0, 340.0));
    frame2.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame2.BindProperty(n"tintColor", n"MainColors.Red");
    frame2.SetOpacity(0.35);
    frame2.Reparent(imageContainer);

    let buttonPricePanel = new inkVerticalPanel();
    buttonPricePanel.SetName(n"SellAndPrice");
    buttonPricePanel.SetHAlign(inkEHorizontalAlign.Right);
    buttonPricePanel.SetVAlign(inkEVerticalAlign.Bottom);
    buttonPricePanel.SetAnchor(inkEAnchor.BottomRight);
    buttonPricePanel.SetMargin(new inkMargin(36.0, 0.0, 8.0, 8.0));
    buttonPricePanel.Reparent(horizontalPanel);

    let carPrice = new inkText();
    carPrice.SetName(n"carPrice");
    carPrice.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    carPrice.SetFontStyle(n"Regular");
    carPrice.SetFontSize(50);
    carPrice.SetLetterCase(textLetterCase.UpperCase);
    carPrice.SetText(s"1234567 \(GetLocalizedText("Common-Characters-EuroDollar"))");
    carPrice.SetFitToContent(true);
    carPrice.SetHAlign(inkEHorizontalAlign.Left);
    carPrice.SetVAlign(inkEVerticalAlign.Bottom);
    carPrice.SetAnchor(inkEAnchor.BottomLeft);
    carPrice.SetAnchorPoint(new Vector2(0.5, 0.5));
    carPrice.SetMargin(new inkMargin(0.0, 16.0, 0.0, 16.0));
    carPrice.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    carPrice.BindProperty(n"tintColor", n"MainColors.Green");
    carPrice.Reparent(buttonPricePanel);
    this.m_price = carPrice;

    this.m_button = SimpleButton.Create();
    this.m_button.SetName(n"ButtonSell");
    this.m_button.SetText(GetLocalizedText("LocKey#17848"));
    this.m_button.ToggleAnimations(true);
    this.m_button.ToggleSounds(true);
    this.m_button.SetWidth(360.0);
    this.m_button.Reparent(buttonPricePanel);

    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetNineSliceScale(true);
    frame.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    frame.SetBrushTileType(inkBrushTileType.NoTile);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"cell_fg");
    frame.SetContentHAlign(inkEHorizontalAlign.Fill);
    frame.SetContentVAlign(inkEVerticalAlign.Fill);
    frame.SetTileHAlign(inkEHorizontalAlign.Left);
    frame.SetTileVAlign(inkEVerticalAlign.Bottom);
    frame.SetSize(new Vector2(940.0, 480.0));
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.Red");
    frame.SetOpacity(0.75);
    frame.Reparent(container);
  }
}
