module AtelierDelivery
import Codeware.UI.*

public class OrderCheckoutDestinationItem extends inkComponent {
  private let data: ref<AtelierDropPointInstance>;
  private let title: ref<inkText>;
  private let subtitle: ref<inkText>;
  private let selection: ref<inkWidget>;
  private let hovered: Bool;
  private let selected: Bool;

  public final static func Create(item: ref<AtelierDropPointInstance>) -> ref<OrderCheckoutDestinationItem> {
    let instance: ref<OrderCheckoutDestinationItem> = new OrderCheckoutDestinationItem();
    instance.data = item;
    return instance;
  }

  protected cb func OnCreate() -> ref<inkWidget> {
    let wrapper: ref<inkCanvas> = new inkCanvas();
    wrapper.SetName(n"wrapper");
    wrapper.SetInteractive(true);
    wrapper.SetSize(640.0, 100.0);

    let selection: ref<inkImage> = new inkImage();
    selection.SetName(n"selection");
    selection.SetFitToContent(true);
    selection.SetAnchor(inkEAnchor.Fill);
    selection.SetAnchorPoint(0.5, 0.5);
    selection.SetHAlign(inkEHorizontalAlign.Fill);
    selection.SetVAlign(inkEVerticalAlign.Fill);
    selection.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    selection.BindProperty(n"tintColor", n"MainColors.Red");
    selection.SetOpacity(0.2);
    selection.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    selection.SetTexturePart(n"cell_fg");
    selection.SetNineSliceScale(true);
    selection.useExternalDynamicTexture = true;
    selection.SetVisible(false);
    selection.Reparent(wrapper);

    let panel: ref<inkVerticalPanel> = new inkVerticalPanel();
    panel.SetName(n"panel");
    panel.SetAnchor(inkEAnchor.CenterLeft);
    panel.SetAnchorPoint(0.0, 0.5);
    panel.Reparent(wrapper);

    let title: ref<inkText> = new inkText();
    title.SetName(n"title");
    title.SetFitToContent(true);
    title.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    title.SetFontSize(34);
    title.SetFontStyle(n"Regular");
    title.SetAnchor(inkEAnchor.CenterLeft);
    title.SetAnchorPoint(Vector2(0.0, 0.5));
    title.SetMargin(inkMargin(16.0, 0.0, 16.0, 0.0));
    title.SetLetterCase(textLetterCase.OriginalCase);
    title.SetText("Drop point name");
    title.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    title.BindProperty(n"tintColor", n"MainColors.White");
    title.Reparent(panel);

    let subtitle: ref<inkText> = new inkText();
    subtitle.SetName(n"subtitle");
    subtitle.SetFitToContent(false);
    subtitle.SetSize(600.0, 40.0);
    subtitle.SetWrapping(false, 580, textWrappingPolicy.PerCharacter);
    subtitle.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    subtitle.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    subtitle.SetFontSize(32);
    subtitle.SetFontStyle(n"Regular");
    subtitle.SetAnchor(inkEAnchor.CenterLeft);
    subtitle.SetAnchorPoint(Vector2(0.0, 0.5));
    subtitle.SetMargin(inkMargin(16.0, 0.0, 16.0, 0.0));
    subtitle.SetLetterCase(textLetterCase.OriginalCase);
    subtitle.SetText("District, subdistrict");
    subtitle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    subtitle.BindProperty(n"tintColor", n"MainColors.White");
    subtitle.SetOpacity(0.25);
    subtitle.Reparent(panel);

    return wrapper;
  }

  protected cb func OnInitialize() {
    this.InitializeWidgets();
    this.RegisterInputListeners();
    this.RefreshData();
  }

  protected cb func OnUninitialize() {
    this.UnregisterInputListeners();
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.PlaySound(n"Button", n"OnHover");
    this.hovered = true;
    this.UpdateState();
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.hovered = false;
    this.UpdateState();
  }

  protected cb func OnClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      this.QueueEvent(AtelierDestinationSelectedEvent.Create(this.data));
    };
  }

  protected cb func OnAtelierDestinationSelectedEvent(evt: ref<AtelierDestinationSelectedEvent>) -> Bool {
    this.selected = Equals(this.data.type, evt.data.type);
    this.UpdateState();
  }

  private final func InitializeWidgets() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.title = root.GetWidgetByPathName(n"panel/title") as inkText;
    this.subtitle = root.GetWidgetByPathName(n"panel/subtitle") as inkText;
    this.selection = root.GetWidgetByPathName(n"selection");
  }

  private final func RefreshData() -> Void {
    this.title.SetText(GetLocalizedText(this.data.locKey));
    this.subtitle.SetText(this.GetDistrictLabel());
  }

  private final func UpdateState() -> Void {
    this.selection.SetVisible(this.selected);

    let textColor: CName;
    let outlineColor: CName;
    if !this.hovered && !this.selected {
      textColor = n"MainColors.White";
      outlineColor = n"MainColors.Red";
    } else if !this.hovered && this.selected {
      textColor = n"MainColors.Red";
      outlineColor = n"MainColors.Red";
    } else if this.hovered && !this.selected {
      textColor = n"MainColors.Red";
      outlineColor = n"MainColors.Red";
    } else if this.hovered && this.selected {
      textColor = n"MainColors.ActiveRed";
      outlineColor = n"MainColors.ActiveRed";
    };

    this.title.BindProperty(n"tintColor", textColor);
    this.selection.BindProperty(n"tintColor", outlineColor);
  }

  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }

  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }

  private final func GetDistrictLabel() -> String {
    let parentDistrict: ref<District_Record> = TweakDBInterface.GetRecord(this.data.parentDistrict) as District_Record;
    let district: ref<District_Record> = TweakDBInterface.GetRecord(this.data.actualDistrict) as District_Record;
    let parentDistrictName: String = GetLocalizedText(parentDistrict.LocalizedName());
    let districtName: String = GetLocalizedText(district.LocalizedName());

    if NotEquals(parentDistrictName, districtName) {
      return s"\(parentDistrictName), \(districtName)";
    };

    return districtName;
  }

  private final func Log(str: String) -> Void {
    if VirtualAtelierDeliveryConfig.Debug() {
      ModLog(n"DeliveryItem", str);
    };
  }
}
