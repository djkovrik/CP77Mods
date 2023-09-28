module VirtualAtelier.UI
import VirtualAtelier.Core.AtelierTexts

public class VirtualCartImageButton extends VirtualAtelierControl {
  private let label: wref<inkText>;
  private let icon: wref<inkImage>;
  private let circle: wref<inkCircle>;
  private let counter: wref<inkText>;

  public static func Create() -> ref<VirtualCartImageButton> {
    let instance: ref<VirtualCartImageButton> = new VirtualCartImageButton();
    instance.Init();
    return instance;
  }

  protected cb func OnCreate() -> ref<inkWidget> {
    let sizeTotal: Float = 64.0;
    let sizeCircle: Float = 40.0;

    let root: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    root.SetName(n"root");
    root.SetChildOrder(inkEChildOrder.Backward);
    root.SetInteractive(true);
    root.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));

    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonLabel());
    label.BindProperty(n"fontSize", VirtualAtelierControlStyle.FontSizeImageButtonLabel());
    label.BindProperty(n"fontStyle", VirtualAtelierControlStyle.FontStyleImageButtonLabel());
    label.SetAnchor(inkEAnchor.CenterRight);
    label.SetHAlign(inkEHorizontalAlign.Right);
    label.SetVAlign(inkEVerticalAlign.Center);
    label.SetAnchorPoint(new Vector2(0.5, 0.5));
    label.SetMargin(new inkMargin(30.0, 0.0, 0.0, 0.0));
    label.SetText(AtelierTexts.ButtonBuy());
    label.SetLetterCase(textLetterCase.UpperCase);
    label.Reparent(root);

    let iconWrapper: ref<inkCanvas> = new inkCanvas();
    iconWrapper.SetName(n"iconWrapper");
    iconWrapper.SetSize(new Vector2(sizeTotal, sizeTotal));
    iconWrapper.Reparent(root);

    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"icon");
    icon.SetAtlasResource(r"base\\gameplay\\gui\\virtual_atelier_cart.inkatlas");
    icon.SetTexturePart(n"cart");
    icon.SetAnchor(inkEAnchor.Centered);
    icon.SetAnchorPoint(new Vector2(0.5, 0.5));
    icon.SetSize(new Vector2(sizeTotal, sizeTotal));
    icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    icon.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonIcon());
    icon.Reparent(iconWrapper);

    let circleContainer: ref<inkCanvas> = new inkCanvas();
    circleContainer.SetName(n"container");
    circleContainer.SetAnchor(inkEAnchor.TopRight);
    circleContainer.SetAnchorPoint(new Vector2(0.5, 0.5));
    circleContainer.SetSize(new Vector2(sizeCircle, sizeCircle));
    circleContainer.Reparent(iconWrapper);

    let circle: ref<inkCircle> = new inkCircle();
    circle.SetName(n"circle");
    circle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    circle.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonCircle());
    circle.SetAnchor(inkEAnchor.Fill);
    circle.SetSize(new Vector2(sizeCircle, sizeCircle));
    circle.SetAnchorPoint(new Vector2(0.5, 0.5));
    circle.Reparent(circleContainer);

    let counter: ref<inkText> = new inkText();
    counter.SetName(n"counter");
    counter.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    counter.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    counter.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonCounter());
    counter.BindProperty(n"fontSize", VirtualAtelierControlStyle.FontSizeImageButtonCounter());
    counter.BindProperty(n"fontStyle", VirtualAtelierControlStyle.FontStyleImageButtonCounter());
    counter.SetAnchor(inkEAnchor.Centered);
    counter.SetAnchorPoint(new Vector2(0.5, 0.5));
    counter.Reparent(root);
    counter.SetText("0");
    counter.Reparent(circleContainer);

    return root;
  }

  protected func OnControlHoverOver() -> Void {
    this.label.UnbindProperty(n"tintColor");
    this.icon.UnbindProperty(n"tintColor");
    this.circle.UnbindProperty(n"tintColor");
    this.counter.UnbindProperty(n"tintColor");
    this.label.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonLabelHovered());
    this.icon.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonIconHovered());
    this.circle.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonCircleHovered());
    this.counter.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonCounterHovered());
  }

  protected func OnControlHoverOut() -> Void {
    this.label.UnbindProperty(n"tintColor");
    this.icon.UnbindProperty(n"tintColor");
    this.circle.UnbindProperty(n"tintColor");
    this.counter.UnbindProperty(n"tintColor");
    this.label.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonLabel());
    this.icon.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonIcon());
    this.circle.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonCircle());
    this.counter.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorImageButtonCounter());
  }

  private final func Init() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
    this.label = root.GetWidgetByPathName(n"label") as inkText;
    this.icon = root.GetWidgetByPathName(n"iconWrapper/icon") as inkImage;
    this.circle = root.GetWidgetByPathName(n"iconWrapper/container/circle") as inkCircle;
    this.counter = root.GetWidgetByPathName(n"iconWrapper/container/counter") as inkText;
  }

  public func SetCounter(counter: Int32) -> Void {
    if counter > 99 {
      this.counter.SetText("99+");
    } else {
      this.counter.SetText(s"\(counter)");
    };
  }
}
