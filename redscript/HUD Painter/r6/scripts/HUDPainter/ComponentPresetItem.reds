module HudPainter

public class ComponentPresetItem extends inkComponent {
  private let data: ref<HudPainterPresetItem>;
  private let hovered: Bool;
  private let selected: Bool;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetSize(600.0, 90.0);
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
    shadow.SetSize(580.0, 70.0);
    shadow.SetOpacity(0.0);
    shadow.Reparent(root);

    let bg: ref<inkImage> = new inkImage();
    bg.SetName(n"bg");
    bg.SetNineSliceScale(true);
    bg.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    bg.SetBrushTileType(inkBrushTileType.NoTile);
    bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bg.SetTexturePart(n"cell_bg");
    bg.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bg.BindProperty(n"tintColor", n"MainColors.Red");
    bg.SetContentHAlign(inkEHorizontalAlign.Fill);
    bg.SetContentVAlign(inkEVerticalAlign.Fill);
    bg.SetTileHAlign(inkEHorizontalAlign.Left);
    bg.SetTileVAlign(inkEVerticalAlign.Top);
    bg.SetSize(580.0, 90.0);
    bg.SetOpacity(0.0);
    bg.Reparent(root);

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
    frame.SetSize(580.0, 90.0);
    frame.SetOpacity(0.0);
    frame.Reparent(root);

    let panel: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    panel.SetName(n"panel");
    panel.SetMargin(40.0, 20.0, 0.0, 0.0);
    panel.Reparent(root);

    let presetName: ref<inkText> = new inkText();
    presetName = new inkText();
    presetName.SetName(n"presetName");
    presetName.SetText("LOL");
    presetName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    presetName.SetLetterCase(textLetterCase.OriginalCase);
    presetName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    presetName.BindProperty(n"tintColor", n"MainColors.Red");
    presetName.BindProperty(n"fontSize", n"MainColors.ReadableMedium");
    presetName.SetFitToContent(false);
    presetName.SetSize(580.0, 54.0);
    presetName.SetLetterCase(textLetterCase.UpperCase);
    presetName.SetWrapping(false, 570, textWrappingPolicy.PerCharacter);
    presetName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    presetName.Reparent(panel);

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
      this.QueueEvent(HudPainterPresetSelected.Create(this.data));
    };
  }

  protected cb func OnHudPainterPresetSelected(evt: ref<HudPainterPresetSelected>) -> Bool {
    let selected: Bool = Equals(this.data.name, evt.data.name);
    this.selected = selected;
    this.RefreshItemState();
  }

  public final func SetData(data: ref<HudPainterPresetItem>) -> Void {
    this.data = data;
    this.RefreshItemData();
    this.RefreshItemState();
  }

  public final func RefreshItemData() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let name: ref<inkText> = root.GetWidgetByPathName(n"panel/presetName") as inkText;
    root.SetName(StringToName(this.data.name));
    name.SetText(this.data.name);
  }

  private final func RefreshItemState() -> Void {
    if this.selected {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"frame").SetOpacity(0.2);
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"frame").SetOpacity(0.0);
    };

    if this.hovered && !this.data.active {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"shadow").SetOpacity(0.05);
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"shadow").SetOpacity(0.0);
    };

    if this.data.active {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"bg").SetOpacity(0.02);
    } else {
      this.GetRootCompoundWidget().GetWidgetByPathName(n"bg").SetOpacity(0.0);
    };
  }

  private final func Log(str: String) -> Void {
    if EnableHudPainterLogs() {
      ModLog(n"PresetItem", str);
    }
  }
}
