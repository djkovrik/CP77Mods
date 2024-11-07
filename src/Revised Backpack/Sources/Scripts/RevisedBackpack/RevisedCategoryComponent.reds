module RevisedBackpack

public class RevisedCategoryComponent extends inkComponent {
  private let data: ref<RevisedBackpackCategory>;
  private let hovered: Bool;
  private let selected: Bool;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetSize(76.0, 76.0);
    root.SetMargin(12.0, 0.0, 12.0, 0.0);
    root.SetInteractive(true);

    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"icon");
    icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
    icon.SetTexturePart(n"resource");
    icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    icon.BindProperty(n"tintColor", n"MainColors.Red");
    icon.SetContentHAlign(inkEHorizontalAlign.Fill);
    icon.SetContentVAlign(inkEVerticalAlign.Fill);
    icon.SetTileHAlign(inkEHorizontalAlign.Fill);
    icon.SetTileVAlign(inkEVerticalAlign.Fill);
    icon.SetAnchor(inkEAnchor.Centered);
    icon.SetAnchorPoint(new Vector2(0.5, 0.5));
    icon.SetSize(64.0, 64.0);
    icon.Reparent(root);

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

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.PlaySound(n"ui_menu_hover");
    this.hovered = true;
    this.RefreshItemState();
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.hovered = false;
    this.RefreshItemState();
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"ui_menu_onpress");
      this.QueueEvent(RevisedCategorySelectedEvent.Create(this.data));
    };
  }

  protected cb func OnRevisedCategorySelectedEvent(evt: ref<RevisedCategorySelectedEvent>) -> Bool {
    let selected: Bool = Equals(this.data.id, evt.category.id);
    this.selected = selected;
    this.RefreshItemState();
  }

  public final func SetData(data: ref<RevisedBackpackCategory>) -> Void {
    this.data = data;
    this.RefreshItemData();
    this.RefreshItemState();
  }

  public final func RefreshItemData() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let icon: ref<inkImage> = root.GetWidgetByPathName(n"icon") as inkImage;
    icon.SetAtlasResource(this.data.atlasResource);
    icon.SetTexturePart(this.data.texturePart);
  }

  private final func RefreshItemState() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let icon: ref<inkWidget> = root.GetWidgetByPathName(n"icon");

    let iconColor: CName;
    if this.hovered || this.selected {
      iconColor = n"MainColors.Blue";
    } else {
      iconColor = n"MainColors.MildRed";
    };

    let scale: Float;
    if this.hovered {
      scale = 1.1;
    } else {
      scale = 1.0;
    };

    icon.BindProperty(n"tintColor", iconColor);
    this.AnimateScale(icon, scale);
  }

  private final func AnimateScale(target: ref<inkWidget>, endScale: Float) -> Void {
    let scaleAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    scaleInterpolator.SetStartScale(target.GetScale());
    scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
    scaleInterpolator.SetDuration(0.1);
    scaleAnimDef.AddInterpolator(scaleInterpolator);
    target.PlayAnimation(scaleAnimDef);
  }

  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(GetPlayer(GetGameInstance()), evt);
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedCategory", str);
    };
  }
}
