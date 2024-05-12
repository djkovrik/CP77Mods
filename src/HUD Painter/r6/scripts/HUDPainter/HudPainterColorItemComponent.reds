module HudPainter

public class HudPainterColorItemComponent extends inkComponent {
  private let data: ref<HudPainterColorItem>;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetSize(860.0, 90.0);
    root.SetMargin(0.0, 6.0, 0.0, 6.0);
    root.SetInteractive(true);

    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetNineSliceScale(true);
    frame.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    frame.SetBrushTileType(inkBrushTileType.NoTile);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"cell_fg");
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.Red");
    frame.SetContentHAlign(inkEHorizontalAlign.Fill);
    frame.SetContentVAlign(inkEVerticalAlign.Fill);
    frame.SetTileHAlign(inkEHorizontalAlign.Left);
    frame.SetTileVAlign(inkEVerticalAlign.Top);
    frame.SetSize(860.0, 90.0);
    frame.SetOpacity(0.0);
    frame.Reparent(root);

    let panel: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    panel.SetName(n"panel");
    panel.SetMargin(20.0, 20.0, 0.0, 0.0);
    panel.Reparent(root);

    let colorName: ref<inkText> = new inkText();
    colorName = new inkText();
    colorName.SetName(n"colorName");
    colorName.SetText("KEK");
    colorName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    colorName.SetLetterCase(textLetterCase.OriginalCase);
    colorName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    colorName.BindProperty(n"tintColor", n"MainColors.Red");
    colorName.BindProperty(n"fontSize", n"MainColors.ReadableMedium");
    colorName.SetFitToContent(false);
    colorName.SetSize(700.0, 54.0);
    colorName.SetWrapping(false, 680, textWrappingPolicy.PerCharacter);
    colorName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    colorName.Reparent(panel);

    let previewDefault: ref<inkRectangle> = new inkRectangle();
    previewDefault.SetName(n"previewDefault");
    previewDefault.SetHAlign(inkEHorizontalAlign.Center);
    previewDefault.SetVAlign(inkEVerticalAlign.Center);
    previewDefault.SetAnchor(inkEAnchor.Centered);
    previewDefault.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
    previewDefault.SetSize(new Vector2(40.0, 40.0));
    previewDefault.SetMargin(16.0, 0.0, 0.0, 0.0);
    previewDefault.Reparent(panel);

    let previewCustom: ref<inkRectangle> = new inkRectangle();
    previewCustom.SetName(n"previewCustom");
    previewCustom.SetHAlign(inkEHorizontalAlign.Center);
    previewCustom.SetVAlign(inkEVerticalAlign.Center);
    previewCustom.SetAnchor(inkEAnchor.Centered);
    previewCustom.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
    previewCustom.SetSize(new Vector2(40.0, 40.0));
    previewCustom.SetMargin(4.0, 0.0, 0.0, 0.0);
    previewCustom.Reparent(panel);

    return root;
  }

  protected cb func OnInitialize() {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnUninitialize() {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    this.SetHovered(true);
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    this.SetHovered(false);
  }

  protected cb func OnRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") {
      this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_onpress"));
      this.QueueEvent(HudPainterColorSelected.Create(this.data));
    };
  }

  protected cb func OnHudPainterColorChanged(evt: ref<HudPainterColorChanged>) -> Bool {
    if Equals(this.data.type, evt.type) && Equals(this.data.name, evt.name) {
      this.UpdateCustomColor(evt.color);
    };
  }

  protected cb func OnHudPainterColorSelected(evt: ref<HudPainterColorSelected>) -> Bool {
    let toggle: Bool = Equals(this.data.type, evt.data.type) && Equals(this.data.name, evt.data.name);
    this.SetSelected(toggle);
  }

  public final func SetData(data: ref<HudPainterColorItem>) -> Void {
    this.data = data;
    this.Refresh();
  }

  public final func UpdateCustomColor(color: HDRColor) -> Void {
    this.data.customColor = color;
    this.Refresh();
  }

  public final func Refresh() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    root.SetName(StringToName(this.data.name));
    let name: ref<inkText> = root.GetWidgetByPathName(n"panel/colorName") as inkText;
    let defaultColorWidget: ref<inkWidget> = root.GetWidgetByPathName(n"panel/previewDefault");
    let customColorWidget: ref<inkWidget> = root.GetWidgetByPathName(n"panel/previewCustom");
    name.SetText(this.data.name);
    defaultColorWidget.SetTintColor(this.data.defaultColor);
    customColorWidget.SetTintColor(this.data.customColor);
  }

  private final func SetHovered(hovered: Bool) -> Void {
    if hovered {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"panel/colorName").BindProperty(n"tintColor", n"MainColors.Blue");
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"panel/colorName").BindProperty(n"tintColor", n"MainColors.Red");
    };
  }

  private final func SetSelected(selected: Bool) -> Void {
    if selected {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"frame").SetOpacity(0.25);
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"frame").SetOpacity(0.0);
    };
  }
}
