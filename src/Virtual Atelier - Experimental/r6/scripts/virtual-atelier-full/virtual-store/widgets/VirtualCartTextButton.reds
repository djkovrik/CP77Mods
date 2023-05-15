module VirtualAtelier.UI

public class VirtualCartTextButton extends inkComponent {
  private let label: wref<inkText>;

  public static func Create(text: String) -> ref<VirtualCartTextButton> {
    let instance: ref<VirtualCartTextButton> = new VirtualCartTextButton();
    instance.Init();
    instance.SetText(text);
    return instance;
  }

  protected cb func OnCreate() -> ref<inkWidget> {
    let color: CName = n"MainColors.Red";
    let fontSize: CName = n"MainColors.ReadableMedium";
    let fontStyle: CName = n"MainColors.BodyFontWeight";

    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", color);
    label.BindProperty(n"fontSize", fontSize);
    label.BindProperty(n"fontStyle", fontStyle);
    label.SetAnchor(inkEAnchor.Centered);
    label.SetHAlign(inkEHorizontalAlign.Center);
    label.SetVAlign(inkEVerticalAlign.Center);
    label.SetAnchorPoint(new Vector2(0.5, 0.5));
    label.SetMargin(new inkMargin(40.0, 0.0, 0.0, 0.0));
    label.SetText("Button text");
    label.SetLetterCase(textLetterCase.UpperCase);

    return label;
  }

  public final func SetText(text: String) -> Void {
    this.label.SetText(text);
  }

  private final func Init() -> Void {
    this.label = this.GetRootWidget() as inkText;
  }
}
