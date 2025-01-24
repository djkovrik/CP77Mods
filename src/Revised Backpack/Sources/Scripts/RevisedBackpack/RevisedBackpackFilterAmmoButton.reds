module RevisedBackpack

public class RevisedBackpackFilterAmmoButton extends inkComponent {
  private let count: Int32;
  private let ammoId: TweakDBID;
  private let hovered: Bool;
  private let selected: Bool;

  private let buttonFrame: wref<inkWidget>;
  private let buttonIcon: wref<inkWidget>;
  private let counterBg: wref<inkWidget>;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetInteractive(true);
    root.SetSize(112.0, 112.0);

    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAnchorPoint(0.5, 0.5);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.MildRed");
    frame.SetSize(112.0, 112.0);
    frame.SetOpacity(0.25);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"color_fg");
    frame.SetNineSliceScale(true);
    frame.Reparent(root);

    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"icon");
    icon.SetFitToContent(false);
    icon.SetAnchor(inkEAnchor.Centered);
    icon.SetAnchorPoint(0.5, 0.5);
    icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    icon.BindProperty(n"tintColor", n"MainColors.MildRed");
    icon.SetSize(54.0, 54.0);
    icon.SetHAlign(inkEHorizontalAlign.Fill);
    icon.SetVAlign(inkEVerticalAlign.Fill);
    icon.SetContentHAlign(inkEHorizontalAlign.Fill);
    icon.SetContentVAlign(inkEVerticalAlign.Fill);
    icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
    icon.SetTexturePart(n"ammo_handgun");
    icon.Reparent(root);

    let counterContainer: ref<inkCanvas> = new inkCanvas();
    counterContainer.SetName(n"counterContainer");
    counterContainer.SetSize(44.0, 44.0);
    counterContainer.SetAnchor(inkEAnchor.BottomRight);
    counterContainer.SetAnchorPoint(0.5, 0.5);
    counterContainer.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    counterContainer.Reparent(root);

    let counterFrame: ref<inkImage> = new inkImage();
    counterFrame.SetName(n"counterFrame");
    counterFrame.SetAnchor(inkEAnchor.Fill);
    counterFrame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    counterFrame.BindProperty(n"tintColor", n"MainColors.FaintRed");
    counterFrame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    counterFrame.SetTexturePart(n"label_frame");
    counterFrame.SetNineSliceScale(true);
    counterFrame.Reparent(counterContainer);

    let counterText: ref<inkText> = new inkText();
    counterText.SetName(n"counterText");
    counterText.SetText("0");
    counterText.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    counterText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    counterText.SetFontSize(34);
    counterText.SetOpacity(0.5);
    counterText.SetFitToContent(true);
    counterText.SetLetterCase(textLetterCase.OriginalCase);
    counterText.SetAnchor(inkEAnchor.Centered);
    counterText.SetAnchorPoint(0.5, 0.5);
    counterText.SetHAlign(inkEHorizontalAlign.Center);
    counterText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    counterText.BindProperty(n"tintColor", n"MainColors.White");
    counterText.Reparent(counterContainer);

    return root;
  }

  protected cb func OnInitialize() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.buttonFrame = root.GetWidgetByPathName(n"frame");
    this.buttonIcon = root.GetWidgetByPathName(n"icon");
    this.counterBg = root.GetWidgetByPathName(n"counterContainer");

    this.RegisterInputListeners();
  }

  protected cb func OnUninitialize() -> Void {
    this.UnregisterInputListeners();
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.PlaySound(n"Button", n"OnHover");
    this.hovered = true;
    this.RefreshItemState();
    
    let target: ref<inkWidget> = evt.GetTarget();
    let tooltip: String = GetLocalizedTextByKey(this.GetTooltipLocKey());
    this.QueueEvent(RevisedBackpackAmmoButtonHoverOverEvent.Create(target, tooltip));
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.hovered = false;
    this.RefreshItemState();
    this.QueueEvent(RevisedBackpackAmmoHoverOutEvent.Create());
  }

  protected cb func OnClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      this.QueueEvent(RevisedAmmoFilterSelectedEvent.Create(this.ammoId));
    };
  }

  protected cb func OnRevisedAmmoFilterSelectedEvent(evt: ref<RevisedAmmoFilterSelectedEvent>) -> Bool {
    this.selected = Equals(evt.ammoId, this.ammoId);
    this.RefreshItemState();
  }

  protected cb func OnRevisedAmmoFilterResetEvent(evt: ref<RevisedAmmoFilterResetEvent>) -> Bool {
      this.selected = false;
      this.Log(s"Reset \(TDBID.ToStringDEBUG(this.ammoId)), selected: \(this.IsSelected())");
      this.RefreshItemState();
  }

  public final func SetName(name: CName) -> Void {
    this.GetRootCompoundWidget().SetName(name);
  }

  public final func SetCount(count: Int32) -> Void {
    this.count = count;
    this.RefreshCounter();
  }

  public final func SetAmmoId(ammoId: TweakDBID) -> Void {
    this.ammoId = ammoId;
    this.RefreshIcon();
  }

  public final func SetSelected(selected: Bool) -> Void {
    this.selected = selected;
  }

  public final func IsSelected() -> Bool {
    return this.selected;
  }

  private final func RefreshItemState() -> Void {
    this.Log(s"RefreshItemState for \(TDBID.ToStringDEBUG(this.ammoId)), selected: \(this.IsSelected())");
    let frameColor: CName;
    if this.hovered || this.selected {
      frameColor = n"MainColors.ActiveBlue";
    } else {
      frameColor = n"MainColors.MildRed";
    };

    let iconColor: CName;
    if this.hovered || this.selected {
      iconColor = n"MainColors.Blue";
    } else {
      iconColor = n"MainColors.MildRed";
    };

    let counterBgColor: CName;
    if this.hovered || this.selected {
      counterBgColor = n"MainColors.FaintBlue";
    } else {
      counterBgColor = n"MainColors.FaintRed";
    };

    this.buttonFrame.BindProperty(n"tintColor", frameColor);
    this.buttonIcon.BindProperty(n"tintColor", iconColor);
    this.counterBg.BindProperty(n"tintColor", counterBgColor);
  }

  private final func RefreshCounter() -> Void {
    let container: ref<inkCanvas> = this.GetRootCompoundWidget().GetWidgetByPathName(n"counterContainer") as inkCanvas;
    let counter: ref<inkText> = this.GetRootCompoundWidget().GetWidgetByPathName(n"counterContainer/counterText") as inkText;
    let width: Float;
    if this.count < 10 {
      width = 44.0;
    } else if this.count >= 10 && this.count < 99 {
      width = 55.0;
    } else if this.count >= 99 && this.count < 999 {
      width = 66.0;
    } else {
      width = 88.0;
    };
    container.SetWidth(width);
    
    if this.count <= 999 {
      counter.SetText(s"\(this.count)");
    } else {
      counter.SetText("999+");
    };
  }

  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }

  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnEnter", this, n"OnRelease");
    this.UnregisterFromCallback(n"OnLeave", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }

  private final func RefreshIcon() -> Void {
    let icon: ref<inkImage> = this.GetRootCompoundWidget().GetWidgetByPathName(n"icon") as inkImage;
    icon.SetTexturePart(this.GetIconPartName());
  }

  private final func GetIconPartName() -> CName {
    switch this.ammoId {
      case t"Ammo.HandgunAmmo": return n"ammo_handgun";
      case t"Ammo.ShotgunAmmo": return n"ammo_shotgun";
      case t"Ammo.RifleAmmo": return n"ammo_rifle";
      case t"Ammo.SniperRifleAmmo": return n"ammo_sniper";
    };

    return n"ammo_handgun";
  }

  private final func GetTooltipLocKey() -> CName {
    switch this.ammoId {
      case t"Ammo.HandgunAmmo": return n"Story-base-gameplay-static_data-database-items-ammo-ammo-HandgunAmmo_displayName";
      case t"Ammo.ShotgunAmmo": return n"Story-base-gameplay-static_data-database-items-ammo-ammo-ShotgunAmmo_displayName";
      case t"Ammo.RifleAmmo": return n"Story-base-gameplay-static_data-database-items-ammo-ammo-RifleAmmo_displayName";
      case t"Ammo.SniperRifleAmmo": return n"Story-base-gameplay-static_data-database-items-ammo-ammo-SniperRifleAmmo_displayName";
    };

    return n"Story-base-gameplay-static_data-database-items-ammo-ammo-HandgunAmmo_displayName";
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedAmmoButton", str);
    };
  }
}
