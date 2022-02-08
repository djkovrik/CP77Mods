module CustomMarkers.UI

import CustomMapMarkers.Codeware.UI.*

public class IconPreviewItem extends inkCustomController {

  protected let m_root: wref<inkCompoundWidget>;

  protected let m_icon: wref<inkImage>;

  protected let m_texturePart: CName;

  protected let m_atlasResource: ResRef;

  protected let m_margin: inkMargin;

  protected let m_tintActive: HDRColor;

  protected let m_tintInactive: HDRColor;

  protected let m_useSounds: Bool;

  protected let m_isHovered: Bool;

  protected let m_isPressed: Bool;

  public static func Create(atlasResource: ResRef, texturePart: CName, margin: inkMargin, active: HDRColor, inactive: HDRColor) -> ref<IconPreviewItem> {
    let self: ref<IconPreviewItem> = new IconPreviewItem();
    self.SetName(texturePart);
    self.SetAtlasResource(atlasResource);
    self.SetTexturePart(texturePart);
    self.SetMargin(margin);
    self.SetActiveTint(active);
    self.SetInactiveTint(inactive);
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
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(this.m_texturePart);
    root.SetSize(70.0, 70.0);
    root.SetAnchorPoint(new Vector2(0.5, 0.5));
    root.SetInteractive(true);

    let icon: ref<inkImage> = new inkImage();
    icon.SetName(this.m_texturePart);
    icon.SetInteractive(true);
    icon.SetAtlasResource(this.m_atlasResource);
    icon.SetTexturePart(this.m_texturePart);
    icon.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    icon.SetBrushTileType(inkBrushTileType.NoTile);
    icon.SetContentHAlign(inkEHorizontalAlign.Center);
    icon.SetContentVAlign(inkEVerticalAlign.Center);
    icon.SetTileHAlign(inkEHorizontalAlign.Center);
    icon.SetTileVAlign(inkEVerticalAlign.Center);
    icon.SetMargin(this.m_margin);
    icon.SetTintColor(this.m_tintInactive);
    icon.SetScale(new Vector2(1.1, 1.1));
    icon.Reparent(root);

    this.m_root = root;
    this.m_icon = icon;

    this.SetRootWidget(root);
  }

  protected func RegisterListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnPress", this, n"OnPress");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }

  public func Tint() -> Void {
    this.m_icon.SetTintColor(this.m_tintActive);
  }

  public func Dim() -> Void {
    this.m_icon.SetTintColor(this.m_tintInactive);
  }

  protected func SetHoveredState(isHovered: Bool) -> Void {
    if !Equals(this.m_isHovered, isHovered) {
      this.m_isHovered = isHovered;
      if !this.m_isHovered {
        this.m_isPressed = false;
      }
    }
  }

  protected func SetPressedState(isPressed: Bool) -> Void {
    if !Equals(this.m_isPressed, isPressed) {
      this.m_isPressed = isPressed;
    }
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.SetHoveredState(true);
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.SetHoveredState(false);
  }

  protected cb func OnPress(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.SetPressedState(true);
    }
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      if this.m_isPressed {
        if this.m_useSounds {
          this.PlaySound(n"Button", n"OnPress");
        }

        this.CallCustomCallback(n"OnClick");

        this.SetPressedState(false);
      }
    }
  }

  public func GetName() -> CName {
    return this.m_root.GetName();
  }

  public func GetState() -> inkEButtonState {
    if this.m_isPressed {
      return inkEButtonState.Press;
    }

    if this.m_isHovered {
      return inkEButtonState.Hover;
    }

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

  public func SetAtlasResource(atlasResource: ResRef) -> Void {
    this.m_atlasResource = atlasResource;
  }

  public func SetTexturePart(texturePart: CName) -> Void {
    this.m_texturePart = texturePart;
  }

  public func SetMargin(margin: inkMargin) -> Void {
    this.m_margin = margin;
  }

  public func SetActiveTint(tint: HDRColor) -> Void {
    this.m_tintActive = tint;
  }

  public func SetInactiveTint(tint: HDRColor) -> Void {
    this.m_tintInactive = tint;
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
}
