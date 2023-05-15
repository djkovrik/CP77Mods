module VirtualAtelier.UI
import VirtualAtelier.Core.AtelierTexts

public class VirtualCartImageButton extends inkComponent {
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
    let colorCartIcon: CName = n"MainColors.Red";
    let colorCircle: CName = n"MainColors.MildRed";
    let colorCounter: CName = n"MainColors.Blue";
    let fontSizeCounter: CName = n"MainColors.ReadableXSmall";
    let fontStyleCounter: CName = n"MainColors.BodyFontWeight";
    let fontSizeLabel: CName = n"MainColors.ReadableMedium";
    let fontStyleLabel: CName = n"MainColors.BodyFontWeight";

    let root: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    root.SetName(n"root");
    root.SetChildOrder(inkEChildOrder.Backward);
    root.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));

    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", colorCartIcon);
    label.BindProperty(n"fontSize", fontSizeLabel);
    label.BindProperty(n"fontStyle", fontStyleLabel);
    label.SetAnchor(inkEAnchor.CenterRight);
    label.SetHAlign(inkEHorizontalAlign.Right);
    label.SetVAlign(inkEVerticalAlign.Center);
    label.SetAnchorPoint(new Vector2(0.5, 0.5));
    label.SetMargin(new inkMargin(24.0, 0.0, .0, 0.0));
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
    icon.BindProperty(n"tintColor", colorCartIcon);
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
    circle.BindProperty(n"tintColor", colorCircle);
    circle.SetAnchor(inkEAnchor.Fill);
    circle.SetSize(new Vector2(sizeCircle, sizeCircle));
    circle.SetAnchorPoint(new Vector2(0.5, 0.5));
    circle.Reparent(circleContainer);

    let counter: ref<inkText> = new inkText();
    counter.SetName(n"counter");
    counter.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    counter.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    counter.BindProperty(n"tintColor", colorCounter);
    counter.BindProperty(n"fontSize", fontSizeCounter);
    counter.BindProperty(n"fontStyle", fontStyleCounter);
    counter.SetAnchor(inkEAnchor.Centered);
    counter.SetAnchorPoint(new Vector2(0.5, 0.5));
    counter.Reparent(root);
    counter.SetText("0");
    counter.Reparent(circleContainer);

    return root;
  }

  private final func Init() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootWidget() as inkCompoundWidget;
    this.label = root.GetWidgetByPathName(n"label") as inkText;
    this.icon = root.GetWidgetByPathName(n"iconWrapper/icon") as inkImage;
    this.circle = root.GetWidgetByPathName(n"iconWrapper/container/circle") as inkCircle;
    this.counter = root.GetWidgetByPathName(n"iconWrapper/container/counter") as inkText;
  }
}
