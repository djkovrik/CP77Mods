module VendorPreview.UI
import Codeware.UI.*

public class AtelierTextButton extends inkCustomController {

  private let m_root: wref<inkCompoundWidget>;
  private let m_text: ref<inkText>;
  private let m_name: CName;
  private let m_label: String;
  private let m_fontSize: Int32;
  private let m_tintColor: CName;
  private let m_tintHoveredColor: CName;
  private let m_margin: inkMargin;
  private let m_clickable: Bool;
  private let m_enabled: Bool;
  private let m_useSounds: Bool;
  private let m_isHovered: Bool;
  private let m_isPressed: Bool;

  public static func Create(name: CName, label: String, fontSize: Int32, tint: CName, tintHovered: CName, margin: inkMargin, clickable: Bool) -> ref<AtelierTextButton> {
    let self: ref<AtelierTextButton> = new AtelierTextButton();
    self.SetName(name);
    self.SetBaseName(name);
    self.SetLabel(label);
    self.SetFontSize(fontSize);
    self.SetTint(tint);
    self.SetTintHovered(tintHovered);
    self.SetMargin(margin);
    self.SetClickable(clickable);
    self.SetEnabled(true);
    self.CreateInstance();
    return self;
  }

  protected cb func OnCreate() -> Void {
    super.OnCreate();
    this.CreateWidgets();
  }

  protected cb func OnInitialize() -> Void {
    super.OnInitialize();
    this.RegisterListeners();
  }

  protected func CreateWidgets() -> Void {
    let root: ref<inkVerticalPanel> = new inkVerticalPanel();
    root.SetName(this.m_name);
    root.SetFitToContent(true);
    root.SetInteractive(true);

    let text: ref<inkText> = new inkText();
    text.SetName(this.m_name);
    text.SetText(this.m_label);
    text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    text.SetFontStyle(n"Medium");
    text.SetFontSize(this.m_fontSize);
    text.SetAnchor(inkEAnchor.Fill);
    text.SetAnchorPoint(0.0, 0.0);
    text.SetHAlign(inkEHorizontalAlign.Fill);
    text.SetVAlign(inkEVerticalAlign.Fill);
    text.SetMargin(this.m_margin);
    text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    text.BindProperty(n"tintColor", this.m_tintColor);
    text.Reparent(root);

    this.m_root = root;
    this.m_text = text;

    this.SetRootWidget(root);
  }

  protected func RegisterListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnPress", this, n"OnPress");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }

  public func SetName(name: CName) -> Void {
    this.m_root.SetName(name);
  }

  public func SetFontSize(size: Int32) -> Void {
    this.m_fontSize = size;
  }

  public func SetBaseName(name: CName) -> Void {
    this.m_name = name;
  }

  public func SetMargin(margin: inkMargin) -> Void {
    this.m_margin = margin;
  }

  public func SetTint(tint: CName) -> Void {
    this.m_tintColor = tint;
  }

  public func SetTintHovered(tint: CName) -> Void {
    this.m_tintHoveredColor = tint;
  }

  public func SetLabel(label: String) -> Void {
    this.m_label = label;
  }

  public func UpdateText(text: String) -> Void {
    this.m_text.SetText(text);
  }

  protected func SetHoveredState(isHovered: Bool) -> Void {
    if !Equals(this.m_isHovered, isHovered) {
      this.m_isHovered = isHovered;
      if !this.m_isHovered {
        this.m_isPressed = false;
      };
    };
  }

  protected func SetPressedState(isPressed: Bool) -> Void {
    if !Equals(this.m_isPressed, isPressed) {
      this.m_isPressed = isPressed;
    };
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    if !this.m_clickable {
      return false;
    };
    this.SetHoveredState(true);
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    if !this.m_clickable {
      return false;
    };
    this.SetHoveredState(false);
  }

  protected cb func OnPress(evt: ref<inkPointerEvent>) -> Bool {
    if this.m_clickable && evt.IsAction(n"click") {
      this.SetPressedState(true);
    };
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if this.m_clickable && evt.IsAction(n"click") {
      if this.m_isPressed {
        if this.m_useSounds {
          this.PlaySound(n"Button", n"OnPress");
        };

        this.CallCustomCallback(n"OnClick");
        this.SetPressedState(false);
      };
    };
  }

  public func SetEnabled(enabled: Bool) {
    if !this.m_clickable {
      return ;
    };

    this.m_enabled = enabled;
    if enabled {
      this.m_text.SetOpacity(1.0);
    } else {
      this.m_text.SetOpacity(0.25);
    };
  }

  public func IsEnabled() -> Bool {
    return this.m_enabled;
  }

  public func GetName() -> CName {
    return this.m_root.GetName();
  }

  public func GetState() -> inkEButtonState {
    if this.m_isPressed {
      return inkEButtonState.Press;
    };

    if this.m_isHovered {
      return inkEButtonState.Hover;
    };

    return inkEButtonState.Normal;
  }

  public func IsHovered() -> Bool {
    return this.m_isHovered;
  }

  public func IsPressed() -> Bool {
    return this.m_isPressed;
  }

  public func SetName(name: CName) -> Void {
    this.m_root.SetName(name);
  }

  public func SetMargin(margin: inkMargin) -> Void {
    this.m_margin = margin;
  }

  public func SetClickable(clickable: Bool) -> Void {
    this.m_clickable = clickable;
  }

  public func SetPosition(x: Float, y: Float) -> Void {
    this.m_root.SetMargin(x, y, 0, 0);
  }

  public func SetWidth(width: Float) -> Void {
    this.m_root.SetWidth(width);
  }

  public func ToggleSounds(useSounds: Bool) -> Void {
    this.m_useSounds = useSounds;
  }

  public func SetHighlighted(highlighted: Bool) -> Void {
    this.m_text.UnbindProperty(n"tintColor");
    if highlighted {
      this.m_text.BindProperty(n"tintColor", this.m_tintHoveredColor);
    } else {
      this.m_text.BindProperty(n"tintColor", this.m_tintColor);
    };
  }
}
