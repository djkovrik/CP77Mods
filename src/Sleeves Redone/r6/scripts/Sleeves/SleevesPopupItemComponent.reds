public class SleevesPopupItemComponent extends inkComponent {
  private let system: wref<SleevesStateSystem>;
  private let mode: SleevesMode;
  private let data: ref<SleevedSlotInfo>;

  private let itemName: ref<inkText>;
  private let slotName: ref<inkText>;
  private let checkboxFrame: ref<inkImage>;
  private let checkboxFrameNotAvailable: ref<inkImage>;
  private let checkboxBgAvailable: ref<inkImage>;
  private let checkboxBgNotAvailable: ref<inkImage>;
  private let checkboxMarker: ref<inkImage>;

  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    root.SetName(n"Root");
    root.SetSize(820.0, 120.0);
    root.SetMargin(0.0, 8.0, 0.0, 8.0);
    root.SetInteractive(true);
    root.SetAnchor(inkEAnchor.Fill);

    // Checkbox
    let checkboxContainer: ref<inkCanvas> = new inkCanvas();
    checkboxContainer.SetName(n"checkboxContainer");
    checkboxContainer.SetSize(64.0, 64.0);
    checkboxContainer.SetFitToContent(false);
    checkboxContainer.SetInteractive(true);
    checkboxContainer.SetChildOrder(inkEChildOrder.Backward);
    checkboxContainer.SetAnchor(inkEAnchor.CenterLeft);
    checkboxContainer.SetHAlign(inkEHorizontalAlign.Left);
    checkboxContainer.SetVAlign(inkEVerticalAlign.Center);
    checkboxContainer.Reparent(root);

    let checkbox: ref<inkImage> = new inkImage();
    checkbox.SetName(n"checkbox");
    checkbox.SetAnchor(inkEAnchor.Centered);
    checkbox.SetAnchorPoint(0.5, 0.5);
    checkbox.SetMargin(1.0, 1.0, 0.0, 0.0);
    checkbox.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    checkbox.BindProperty(n"tintColor", n"MainColors.Red");
    checkbox.SetSize(38.0, 38.0);
    checkbox.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    checkbox.SetTexturePart(n"color_bg");
    checkbox.SetNineSliceScale(true);
    checkbox.Reparent(checkboxContainer);

    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAnchorPoint(0.5, 0.5);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.MildRed");
    frame.SetSize(64.0, 64.0);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"color_fg");
    frame.SetNineSliceScale(true);
    frame.Reparent(checkboxContainer);

    let frameNotAvailable: ref<inkImage> = new inkImage();
    frameNotAvailable.SetName(n"frameNotAvailable");
    frameNotAvailable.SetAnchor(inkEAnchor.Fill);
    frameNotAvailable.SetAnchorPoint(0.5, 0.5);
    frameNotAvailable.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frameNotAvailable.BindProperty(n"tintColor", n"MainColors.Grey");
    frameNotAvailable.SetSize(64.0, 64.0);
    frameNotAvailable.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frameNotAvailable.SetTexturePart(n"color_fg");
    frameNotAvailable.SetNineSliceScale(true);
    frameNotAvailable.SetVisible(false);
    frameNotAvailable.SetOpacity(0.5);
    frameNotAvailable.Reparent(checkboxContainer);

    let bg: ref<inkImage> = new inkImage();
    bg.SetName(n"bg");
    bg.SetAnchor(inkEAnchor.Fill);
    bg.SetAnchorPoint(0.5, 0.5);
    bg.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bg.BindProperty(n"tintColor", n"MainColors.FaintRed");
    bg.SetSize(64.0, 64.0);
    bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bg.SetTexturePart(n"color_bg");
    bg.SetNineSliceScale(true);
    bg.Reparent(checkboxContainer);

    let bgNotAvailable: ref<inkImage> = new inkImage();
    bgNotAvailable.SetName(n"bgNotAvailable");
    bgNotAvailable.SetAnchor(inkEAnchor.Fill);
    bgNotAvailable.SetAnchorPoint(0.5, 0.5);
    bgNotAvailable.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bgNotAvailable.BindProperty(n"tintColor", n"MainColors.Grey");
    bgNotAvailable.SetSize(64.0, 64.0);
    bgNotAvailable.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bgNotAvailable.SetTexturePart(n"color_bg");
    bgNotAvailable.SetNineSliceScale(true);
    bgNotAvailable.SetVisible(false);
    bgNotAvailable.SetOpacity(0.1);
    bgNotAvailable.Reparent(checkboxContainer);

    // Labels
    let labels: ref<inkVerticalPanel> = new inkVerticalPanel();
    labels.SetName(n"labelsContainer");
    labels.SetFitToContent(false);
    labels.SetInteractive(true);
    labels.SetSize(740.0, 108.0);
    labels.SetAnchor(inkEAnchor.CenterLeft);
    labels.SetHAlign(inkEHorizontalAlign.Left);
    labels.SetVAlign(inkEVerticalAlign.Center);
    labels.SetMargin(32.0, 0.0, 0.0, 0.0);
    labels.Reparent(root);

    let itemName: ref<inkText> = new inkText();
    itemName.SetName(n"itemName");
    itemName.SetText("Test");
    itemName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    itemName.SetFontSize(40);
    itemName.SetFitToContent(false);
    itemName.SetSize(740.0, 54.0);
    itemName.SetLetterCase(textLetterCase.OriginalCase);
    itemName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    itemName.BindProperty(n"tintColor", n"MainColors.Red");
    itemName.SetOverflowPolicy(textOverflowPolicy.DotsEnd);
    itemName.SetWrapping(false, 744, textWrappingPolicy.PerCharacter);
    itemName.Reparent(labels);

    let slotName: ref<inkText> = new inkText();
    slotName.SetName(n"slotName");
    slotName.SetText("Test");
    slotName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    slotName.SetFontSize(36);
    slotName.SetFitToContent(false);
    slotName.SetSize(740.0, 54.0);
    slotName.SetLetterCase(textLetterCase.OriginalCase);
    slotName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    slotName.BindProperty(n"tintColor", n"MainColors.Grey");
    slotName.Reparent(labels);

    return root;
  }

  protected cb func OnInitialize() {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.itemName = root.GetWidgetByPathName(n"labelsContainer/itemName") as inkText;
    this.slotName = root.GetWidgetByPathName(n"labelsContainer/slotName") as inkText;
    this.checkboxFrame = root.GetWidgetByPathName(n"checkboxContainer/frame") as inkImage;
    this.checkboxFrameNotAvailable = root.GetWidgetByPathName(n"checkboxContainer/frameNotAvailable") as inkImage;
    this.checkboxBgAvailable = root.GetWidgetByPathName(n"checkboxContainer/bg") as inkImage;
    this.checkboxBgNotAvailable = root.GetWidgetByPathName(n"checkboxContainer/bgNotAvailable") as inkImage;
    this.checkboxMarker = root.GetWidgetByPathName(n"checkboxContainer/checkbox") as inkImage;

    this.system = SleevesStateSystem.Get(GetGameInstance());

    this.UpdateLabels();
    this.UpdateCheckbox();
    this.RegisterInputListeners();
  }

  protected cb func OnUninitialize() {
    this.UnregisterInputListeners();
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    if this.IsAvailableForSelection() {
      this.PlaySound(n"Button", n"OnHover");

      this.itemName.UnbindProperty(n"tintColor");
      this.itemName.BindProperty(n"tintColor", n"MainColors.ActiveRed");
      this.checkboxFrame.UnbindProperty(n"tintColor");
      this.checkboxFrame.BindProperty(n"tintColor", n"MainColors.Red");
    }
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    if this.IsAvailableForSelection() {
      this.itemName.UnbindProperty(n"tintColor");
      this.itemName.BindProperty(n"tintColor", n"MainColors.Red");
      this.checkboxFrame.UnbindProperty(n"tintColor");
      this.checkboxFrame.BindProperty(n"tintColor", n"MainColors.MildRed");
    }
  }

  protected cb func OnClick(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && this.IsAvailableForSelection() {
      let toggled: Bool = this.data.IsToggled();
      let itemID: ItemID;
      if NotEquals(this.data.mode, SleevesMode.Wardrobe) {
        itemID = this.data.itemID;
      } else {
        itemID = this.data.visualItemID;
      };

      if toggled {
        if this.system.RemoveToggle(itemID) {
          this.data.SetToggled(false);
          this.UpdateCheckbox();
          this.PlaySound(n"Button", n"OnPress");
        }
      } else {
        if this.system.AddToggle(itemID) {
          this.data.SetToggled(true);
          this.UpdateCheckbox();
          this.PlaySound(n"Button", n"OnPress");
        };
      };

      RefreshSleevesButtonEvent.Send(GetPlayer(GetGameInstance()));
    };
  }

  public final func SetMode(mode: SleevesMode) -> Void {
    this.mode = mode;
  }

  public final func SetData(data: ref<SleevedSlotInfo>) -> Void {
    this.data = data;
  }

  private final func UpdateLabels() -> Void {
    this.itemName.SetText(this.data.GetDisplayedItemName());
    this.slotName.SetText(this.data.GetSlotName());
  }

  private final func UpdateCheckbox() -> Void {
    if this.IsAvailableForSelection() {
      this.checkboxMarker.SetVisible(this.data.IsToggled());
    } else {
      this.checkboxFrame.SetVisible(false);
      this.checkboxMarker.SetVisible(false);
      this.checkboxBgAvailable.SetVisible(false);
      this.checkboxBgNotAvailable.SetVisible(true);
      this.checkboxFrameNotAvailable.SetVisible(true);
    }
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

  private final func IsAvailableForSelection() -> Bool {
    return this.data.HasFppSuffix();
  }
}
