module VirtualAtelier.UI

public class VirtualCartTextButton extends VirtualAtelierControl {
  private let label: wref<inkText>;

  public static func Create(text: String) -> ref<VirtualCartTextButton> {
    let instance: ref<VirtualCartTextButton> = new VirtualCartTextButton();
    instance.Init();
    instance.SetText(text);
    return instance;
  }

  protected cb func OnCreate() -> ref<inkWidget> {
    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorTextButton());
    label.BindProperty(n"fontSize", VirtualAtelierControlStyle.FontSizeTextButton());
    label.BindProperty(n"fontStyle", VirtualAtelierControlStyle.FontStyleTextButton());
    label.SetAnchor(inkEAnchor.Centered);
    label.SetHAlign(inkEHorizontalAlign.Center);
    label.SetVAlign(inkEVerticalAlign.Center);
    label.SetAnchorPoint(Vector2(0.5, 0.5));
    label.SetMargin(inkMargin(46.0, 0.0, 0.0, 0.0));
    label.SetText("Button text");
    label.SetInteractive(true);
    label.SetLetterCase(textLetterCase.UpperCase);

    return label;
  }

  protected func OnControlHoverOver() -> Void {
    this.label.UnbindProperty(n"tintColor");
    this.label.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorTextButtonHovered());
  }

  protected func OnControlHoverOut() -> Void {
    this.label.UnbindProperty(n"tintColor");
    this.label.BindProperty(n"tintColor", VirtualAtelierControlStyle.ColorTextButton());
  }

  public final func Init() -> Void {
    this.label = this.GetRootWidget() as inkText;
  }

  public final func SetText(text: String) -> Void {
    this.label.SetText(text);
  }
}
