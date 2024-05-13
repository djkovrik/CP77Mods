module HudPainter

public class HudPainterColorItemComponent extends inkComponent {
  private let data: ref<HudPainterColorItem>;
  private let hovered: Bool;
  private let selected: Bool;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetSize(880.0, 90.0);
    root.SetMargin(0.0, 6.0, 0.0, 6.0);
    root.SetInteractive(true);

    let shadow: ref<inkImage> = new inkImage();
    shadow.SetName(n"shadow");
    shadow.SetNineSliceScale(true);
    shadow.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    shadow.SetBrushTileType(inkBrushTileType.NoTile);
    shadow.SetAtlasResource(r"base\\gameplay\\gui\\common\\shadow_blobs.inkatlas");
    shadow.SetTexturePart(n"shadowBlobSquare_small");
    shadow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    shadow.BindProperty(n"tintColor", n"MainColors.Red");
    shadow.SetContentHAlign(inkEHorizontalAlign.Left);
    shadow.SetContentVAlign(inkEVerticalAlign.Fill);
    shadow.SetTileHAlign(inkEHorizontalAlign.Left);
    shadow.SetTileVAlign(inkEVerticalAlign.Top);
    shadow.SetMargin(-8.0, 12.0, 0.0, 0.0);
    shadow.SetSize(880.0, 70.0);
    shadow.SetOpacity(0.0);
    shadow.Reparent(root);

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
    frame.SetSize(880.0, 90.0);
    frame.SetOpacity(0.0);
    frame.Reparent(root);

    let modified: ref<inkText> = new inkText();
    modified.SetName(n"modified");
    modified.SetText("*");
    modified.SetMargin(16.0, 20.0, 0.0, 0.0);
    modified.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    modified.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    modified.BindProperty(n"tintColor", n"MainColors.Red");
    modified.BindProperty(n"fontSize", n"MainColors.SubtitleHeader");
    modified.SetVisible(false);
    modified.Reparent(root);

    let panel: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    panel.SetName(n"panel");
    panel.SetMargin(40.0, 20.0, 0.0, 0.0);
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
    this.QueueEvent(HudPainterSoundEmitted.Create(n"ui_menu_hover"));
    this.hovered = true;
    this.RefreshItemState();
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    this.hovered = false;
    this.RefreshItemState();
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
    let selected: Bool = Equals(this.data.type, evt.data.type) && Equals(this.data.name, evt.data.name);
    this.selected = selected;
    this.RefreshItemState();
  }

  public final func SetData(data: ref<HudPainterColorItem>) -> Void {
    this.data = data;
    this.RefreshItemData();
  }

  public final func UpdateCustomColor(color: HDRColor) -> Void {
    this.data.customColor = color;
    this.RefreshItemData();
  }

  public final func RefreshItemData() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    root.SetName(StringToName(this.data.name));

    let name: ref<inkText> = root.GetWidgetByPathName(n"panel/colorName") as inkText;
    let shadow: ref<inkWidget> = root.GetWidgetByPathName(n"shadow");
    let modified: ref<inkWidget> = root.GetWidgetByPathName(n"modified");
    let defaultColorWidget: ref<inkWidget> = root.GetWidgetByPathName(n"panel/previewDefault");
    let customColorWidget: ref<inkWidget> = root.GetWidgetByPathName(n"panel/previewCustom");
    name.SetText(this.data.name);
    defaultColorWidget.SetTintColor(this.data.defaultColor);
    customColorWidget.SetTintColor(this.data.customColor);

    if Equals(this.data.type, HudPainterColorType.Johnny) {
      name.BindProperty(n"tintColor", n"MainColors.Green");
      shadow.BindProperty(n"tintColor", n"MainColors.Green");
      modified.BindProperty(n"tintColor", n"MainColors.Green");
      name.SetFontStyle(n"Semi-Bold");
    } else {
      name.BindProperty(n"tintColor", n"MainColors.Red");
      shadow.BindProperty(n"tintColor", n"MainColors.Red");
      modified.BindProperty(n"tintColor", n"MainColors.Red");
    };

    modified.SetVisible(NotEquals(this.GetColorHashInt(this.data.presetColor), this.GetColorHashInt(this.data.customColor)));
  }

  private final func RefreshItemState() -> Void {
    if this.selected {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"frame").SetOpacity(0.2);
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"frame").SetOpacity(0.0);
    };

    if this.hovered {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"shadow").SetOpacity(0.04);
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"shadow").SetOpacity(0.0);
    };
  }

  private final func GetColorHashInt(color: HDRColor) -> Int32 {
    return Cast<Int32>(color.Red * 255.0) + Cast<Int32>(color.Green* 255.0) + Cast<Int32>(color.Blue * 255.0);
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"ColorItem", str);
    }
  }
}
