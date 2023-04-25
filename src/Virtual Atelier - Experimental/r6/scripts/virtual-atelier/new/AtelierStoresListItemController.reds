module VirtualAtelier.UI
import VendorPreview.Utils.AtelierDebug

class AtelierStoresListItemController extends inkVirtualCompoundItemController {
  private let data: ref<VirtualShop>;
  private let itemContainer: wref<inkVerticalPanel>;
  private let storeImage: wref<inkImage>;
  private let storeLabel: wref<inkText>;
  private let animProxy: ref<inkAnimProxy>;

  private let hoverAnimDuration: Float = 0.2;
  private let scaleNormal: Float = 1.0;
  private let scaleHovered: Float = 1.1;

  protected cb func OnInitialize() -> Bool {
    this.InitializeWidgets();
    this.RegisterCallbacks();
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterCallbacks();
    this.StopAnimProxy();
  }

  protected cb func OnShopClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      AtelierDebug(s"OnShopClick: \(this.data.storeName)");
      this.StopAnimProxy();
      this.QueueEvent(AtelierStoreSoundEvent.Create(n"ui_menu_onpress"));
      this.QueueEvent(AtelierStoreClickEvent.Create(this.data.storeID));
    };
  }

  protected cb func OnShopHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    AtelierDebug(s"OnShopHoverOver: \(this.data.storeName)");
    this.QueueEvent(AtelierStoreSoundEvent.Create(n"ui_menu_hover"));
    this.StopAnimProxy();
    this.animProxy = this.AnimateScale(this.itemContainer, this.scaleHovered);
  }

  protected cb func OnShopHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    AtelierDebug(s"OnShopHoverOut: \(this.data.storeName)");
    this.StopAnimProxy();
    this.animProxy = this.AnimateScale(this.itemContainer, this.scaleNormal);
  }

  protected cb func OnDataChanged(value: Variant) {
    this.data = FromVariant<ref<IScriptable>>(value) as VirtualShop;
    if IsDefined(this.data) {
      this.RefreshView();
    };
  }

  private func RefreshView() -> Void {
    this.itemContainer.SetName(this.data.storeID);
    this.storeImage.SetName(this.data.storeID);
    this.storeLabel.SetName(this.data.storeID);
    this.storeImage.SetAtlasResource(this.data.atlasResource);
    this.storeImage.SetTexturePart(this.data.texturePart);
    this.storeLabel.SetText(this.data.storeName);
  }

  private func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();

    let itemContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
    itemContainer.SetSize(new Vector2(360.0, 360.0));
    itemContainer.SetPadding(new inkMargin(40.0, 40.0, 40.0, 40.0));
    itemContainer.Reparent(root);

    let storeImage: ref<inkImage> = new inkImage();
    storeImage.SetInteractive(true);
    storeImage.SetAnchor(inkEAnchor.Centered);
    storeImage.SetHAlign(inkEHorizontalAlign.Center);
    storeImage.SetVAlign(inkEVerticalAlign.Center);
    storeImage.SetAnchorPoint(new Vector2(0.5, 0.5));
    storeImage.SetSize(new Vector2(320.0, 280.0));
    storeImage.SetFitToContent(false);
    storeImage.SetSizeRule(inkESizeRule.Fixed);
    storeImage.Reparent(itemContainer);

    let storeLabel: ref<inkText> = new inkText();
    storeLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    storeLabel.SetFontStyle(n"Semi-Bold");
    storeLabel.SetFontSize(35);
    storeLabel.SetLetterCase(textLetterCase.UpperCase);
    storeLabel.SetFitToContent(true);
    storeLabel.SetAnchor(inkEAnchor.Centered);
    storeLabel.SetHAlign(inkEHorizontalAlign.Center);
    storeLabel.SetVAlign(inkEVerticalAlign.Center);
    storeLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    storeLabel.BindProperty(n"tintColor", n"MainColors.Blue");
    storeLabel.SetSize(new Vector2(320.0, 60.0));
    storeLabel.SetWrapping(true, 320.0, textWrappingPolicy.Default);
    storeLabel.Reparent(itemContainer);
    
    this.itemContainer = itemContainer;
    this.storeImage = storeImage;
    this.storeLabel = storeLabel;
  }

  private func RegisterCallbacks() -> Void {
    this.itemContainer.RegisterToCallback(n"OnPress", this, n"OnShopClick");
    this.itemContainer.RegisterToCallback(n"OnEnter", this, n"OnShopHoverOver");
    this.itemContainer.RegisterToCallback(n"OnLeave", this, n"OnShopHoverOut");
  }

  private func UnregisterCallbacks() -> Void {
    this.itemContainer.UnregisterFromCallback(n"OnPress", this, n"OnShopClick");
    this.itemContainer.UnregisterFromCallback(n"OnEnter", this, n"OnShopHoverOver");
    this.itemContainer.UnregisterFromCallback(n"OnLeave", this, n"OnShopHoverOut");
  }

  private func AnimateScale(targetWidget: ref<inkWidget>, endScale: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    scaleInterpolator.SetStartScale(targetWidget.GetScale());
    scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
    scaleInterpolator.SetDuration(this.hoverAnimDuration);
    moveElementsAnimDef.AddInterpolator(scaleInterpolator);
    proxy = targetWidget.PlayAnimation(moveElementsAnimDef);
    return proxy;
  }

  private func StopAnimProxy() -> Void {
    if IsDefined(this.animProxy) {
      this.animProxy.Stop();
      this.animProxy = null;
    };
  }
}
