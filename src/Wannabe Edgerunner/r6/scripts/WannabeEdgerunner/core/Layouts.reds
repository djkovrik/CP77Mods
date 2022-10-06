import Edgerunning.System.EdgerunningSystem

@addField(inkGameController)
let humanityCounter: ref<inkText>;  

@addField(InventoryTooltipData)
public let humanity: Int32;


// -- Cyberware screen

@addField(RipperDocGameController)
public let edgerunningSystem: wref<EdgerunningSystem>;

@addField(RipperDocGameController)
public let humanityIcon: ref<inkImage>;

@addField(RipperDocGameController)
public let humanityLabel: ref<inkText>;

@addField(RipperDocGameController)
public let humanityBarFull: ref<inkRectangle>;

@addField(RipperDocGameController)
public let humanityBarProgress: ref<inkRectangle>;

@addMethod(RipperDocGameController)
public func CreateHumanityIcon() -> ref<inkImage> {
  let icon: ref<inkImage> = new inkImage();
  icon.SetName(n"HumanityImage");
  icon.SetInteractive(true);
  icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
  icon.SetTexturePart(n"hunt_for_psycho");
  icon.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
  icon.SetBrushTileType(inkBrushTileType.NoTile);
  icon.SetContentHAlign(inkEHorizontalAlign.Center);
  icon.SetContentVAlign(inkEVerticalAlign.Center);
  icon.SetMargin(new inkMargin(20.0, 20.0, 20.0, 20.0));
  icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  icon.BindProperty(n"tintColor", n"MainColors.Blue");
  return icon;
}

@addMethod(RipperDocGameController)
public func CreateHumanityLabel() -> ref<inkText> {
  let label: ref<inkText> = new inkText();
  label.SetName(n"HumanityLabel");
  label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  label.SetFontSize(44);
  label.SetText(GetLocalizedTextByKey(n"Mod-Edg-Humanity"));
  label.SetHAlign(inkEHorizontalAlign.Left);
  label.SetVAlign(inkEVerticalAlign.Top);
  label.SetAnchor(inkEAnchor.TopLeft);
  label.SetAnchorPoint(0.0, 0.0);
  label.SetOpacity(0.4);
  label.SetLetterCase(textLetterCase.UpperCase);
  label.SetMargin(new inkMargin(80.0, 50.0, 0.0, 0.0));
  label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  label.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  return label;
}

@addMethod(RipperDocGameController)
public func RefreshHumanityBars(current: Int32, total: Int32) -> Void {
  let fullWidth: Float = this.humanityBarFull.GetWidth();
  let step: Float = fullWidth / Cast<Float>(total);
  let newWidth: Float = Cast<Float>(current) * step;
  this.humanityBarProgress.SetWidth(newWidth);
  this.humanityBarProgress.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityBarProgress.BindProperty(n"tintColor", this.edgerunningSystem.GetHumanityColor());
}

@wrapMethod(RipperDocGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.edgerunningSystem = EdgerunningSystem.GetInstance(this.m_player.GetGame());

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer = new inkCanvas();
  outerContainer.SetName(n"OuterContainer");
  outerContainer.SetHAlign(inkEHorizontalAlign.Left);
  outerContainer.SetVAlign(inkEVerticalAlign.Top);
  outerContainer.SetAnchor(inkEAnchor.TopLeft);
  outerContainer.SetInteractive(true);
  outerContainer.SetAnchorPoint(new Vector2(0.0, 0.0));
  outerContainer.SetSize(new Vector2(940.0, 100.0));
  outerContainer.SetMargin(new inkMargin(180.0, 140.0, 0.0, 0.0));
  outerContainer.Reparent(root, 2);

  let vertical: ref<inkVerticalPanel> = new inkVerticalPanel();
  vertical.SetName(n"VerticalPanel");
  vertical.SetFitToContent(true);
  vertical.SetHAlign(inkEHorizontalAlign.Fill);
  vertical.SetVAlign(inkEVerticalAlign.Fill);
  vertical.SetAnchor(inkEAnchor.Fill);
  vertical.SetInteractive(true);
  vertical.Reparent(outerContainer);

  let label: ref<inkText> = this.CreateHumanityLabel();
  label.Reparent(vertical);

  let horizontal: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  horizontal.SetName(n"HorizontalPanel");
  horizontal.SetFitToContent(true);
  horizontal.SetHAlign(inkEHorizontalAlign.Fill);
  horizontal.SetVAlign(inkEVerticalAlign.Fill);
  horizontal.SetAnchor(inkEAnchor.Fill);
  horizontal.SetInteractive(true);
  horizontal.Reparent(vertical);

  this.humanityIcon = this.CreateHumanityIcon();
  this.humanityIcon.Reparent(horizontal);

  vertical.RegisterToCallback(n"OnHoverOver", this, n"OnHumanityIconHoverOver");
  vertical.RegisterToCallback(n"OnHoverOut", this, n"OnHumanityIconHoverOut");

  let progressContainer: ref<inkCanvas> = new inkCanvas();
  progressContainer.SetSize(new Vector2(640.0, 12.0));
  progressContainer.SetMargin(40.0, 0.0, 0.0, 0.0);
  progressContainer.Reparent(horizontal);

  this.humanityBarFull = new inkRectangle();
  this.humanityBarFull.SetName(n"ProgressFull");
  this.humanityBarFull.SetAnchor(inkEAnchor.CenterLeft);
  this.humanityBarFull.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarFull.SetVAlign(inkEVerticalAlign.Center);
  this.humanityBarFull.SetSize(new Vector2(640.0, 12.0));
  this.humanityBarFull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityBarFull.BindProperty(n"tintColor", n"MainColors.FaintRed");
  this.humanityBarFull.Reparent(progressContainer);

  this.humanityBarProgress = new inkRectangle();
  this.humanityBarProgress.SetName(n"ProgressCurrent");
  this.humanityBarProgress.SetAnchor(inkEAnchor.CenterLeft);
  this.humanityBarProgress.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarProgress.SetVAlign(inkEVerticalAlign.Center);
  this.humanityBarProgress.SetSize(new Vector2(640.0, 12.0));
  this.humanityBarProgress.Reparent(progressContainer);

  this.RefreshHumanityHUD();
}

@addMethod(RipperDocGameController)
protected cb func OnHumanityIconHoverOver(evt: ref<inkPointerEvent>) -> Bool {
  this.humanityIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityIcon.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  let data: ref<MessageTooltipData> = new MessageTooltipData();
  let current: Int32 = this.edgerunningSystem.GetHumanityCurrent();
  let total: Int32 = this.edgerunningSystem.GetHumanityTotal();
  data.Title = s"\(GetLocalizedTextByKey(n"Mod-Edg-Humanity")): \(current) / \(total)";
  data.Description = GetLocalizedTextByKey(n"Mod-Edg-Humanity-Desc");
  this.m_TooltipsManager.ShowTooltip(data);
}

@addMethod(RipperDocGameController)
protected cb func OnHumanityIconHoverOut(evt: ref<inkPointerEvent>) -> Bool {
  this.m_TooltipsManager.HideTooltips();
  this.humanityIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityIcon.BindProperty(n"tintColor", n"MainColors.Blue");
}

@wrapMethod(RipperDocGameController)
private final func UpdateCWAreaGrid(selectedArea: gamedataEquipmentArea) -> Void {
  wrappedMethod(selectedArea);
  this.RefreshHumanityHUD();
}

@wrapMethod(RipperDocGameController)
private final func SetInventoryCWList() -> Void {
  wrappedMethod();
  this.RefreshHumanityHUD();
}

@addMethod(RipperDocGameController)
public func RefreshHumanityHUD() -> Void {
  let current: Int32 = this.edgerunningSystem.GetHumanityCurrent();
  let total: Int32 = this.edgerunningSystem.GetHumanityTotal();
  this.RefreshHumanityBars(current, total);
}

@wrapMethod(RipperDocGameController)
private final func ShowCWTooltip(itemData: InventoryItemData, itemTooltipData: ref<InventoryTooltipData>) -> Void {
  let record: ref<Item_Record> = RPGManager.GetItemRecord(InventoryItemData.GetID(itemData));
  let cost: Int32 = this.edgerunningSystem.GetCyberwareCost(record);
  itemTooltipData.humanity = cost;
  wrappedMethod(itemData, itemTooltipData);
}

@addMethod(RipperDocGameController)
protected cb func OnUpdateHumanityCounterEvent(evt: ref<UpdateHumanityCounterEvent>) -> Bool {
  this.RefreshHumanityBars(evt.current, evt.total);
}


// -- Cyberdeck popup

@addField(CyberdeckTooltip)
public let humanityLabel: ref<inkText>;

@wrapMethod(CyberdeckTooltip)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.humanityLabel = new inkText();
  this.humanityLabel.SetName(n"HumanityLabel");
  this.humanityLabel.SetText("-10 Humanity");
  this.humanityLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  this.humanityLabel.SetFontSize(42);
  this.humanityLabel.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityLabel.SetVAlign(inkEVerticalAlign.Top);
  this.humanityLabel.SetAnchor(inkEAnchor.TopLeft);
  this.humanityLabel.SetAnchorPoint(1.0, 1.0);
  this.humanityLabel.SetVisible(true);
  this.humanityLabel.SetLetterCase(textLetterCase.OriginalCase);
  this.humanityLabel.SetMargin(new inkMargin(0.0, -30.0, 0.0, 0.0));
  this.humanityLabel.SetVisible(false);
  this.humanityLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityLabel.BindProperty(n"tintColor", n"MainColors.White");
  
  inkCompoundRef.AddChildWidget(this.m_headerContainer, this.humanityLabel);
}

@wrapMethod(CyberdeckTooltip)
public func SetData(tooltipData: ref<ATooltipData>) -> Void {
  wrappedMethod(tooltipData);

  let text: String;
  if this.m_data.humanity > 0 {
    text = s"\(GetLocalizedTextByKey(n"Mod-Edg-Humanity-Cost")) \(this.m_data.humanity)";
    this.humanityLabel.SetText(text);
    this.humanityLabel.SetVisible(true);
  } else {
    this.humanityLabel.SetVisible(false);
  }
}


// -- Cyberware popup

@addField(ItemTooltipCommonController)
public let humanityLabel: ref<inkText>;

@wrapMethod(ItemTooltipCommonController)
public func SetData(tooltipData: ref<ATooltipData>) -> Void {
  wrappedMethod(tooltipData);
}

@wrapMethod(ItemTooltipCommonController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_itemHeaderContainer) as inkCompoundWidget;

  this.humanityLabel = new inkText();
  this.humanityLabel.SetName(n"HumanityLabel");
  this.humanityLabel.SetText("TTTT");
  this.humanityLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  this.humanityLabel.SetFontSize(30);
  this.humanityLabel.SetHAlign(inkEHorizontalAlign.Right);
  this.humanityLabel.SetVAlign(inkEVerticalAlign.Bottom);
  this.humanityLabel.SetAnchor(inkEAnchor.BottomRight);
  this.humanityLabel.SetAnchorPoint(1.0, 0.0);
  this.humanityLabel.SetLetterCase(textLetterCase.OriginalCase);
  this.humanityLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 12.0));
  this.humanityLabel.SetVisible(false);
  this.humanityLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityLabel.BindProperty(n"tintColor", n"MainColors.Blue");
  
  this.humanityLabel.Reparent(container);
}

@wrapMethod(ItemTooltipCommonController)
public final func UpdateData(tooltipData: ref<InventoryTooltipData>) -> Void {
  wrappedMethod(tooltipData);

  let text: String;
  if tooltipData.humanity > 0 {
    text = s"\(GetLocalizedTextByKey(n"Mod-Edg-Humanity-Cost")) \(tooltipData.humanity)";
    this.humanityLabel.SetText(text);
    this.humanityLabel.SetVisible(true);
  } else {
    this.humanityLabel.SetVisible(false);
  }
}

// -- Healthbar indicator

@addField(healthbarWidgetGameController)
public let humanityBarContainer: ref<inkCanvas>;

@addField(healthbarWidgetGameController)
public let humanityBarFull: ref<inkRectangle>;

@addField(healthbarWidgetGameController)
public let humanityBarProgress: ref<inkRectangle>;

@addField(healthbarWidgetGameController)
public let edgerunningSystem: ref<EdgerunningSystem>;

@addMethod(healthbarWidgetGameController)
public func RefreshHumanityBars(current: Int32, total: Int32, color: CName) -> Void {
  let fullWidth: Float = this.humanityBarFull.GetWidth();
  let step: Float = fullWidth / Cast<Float>(total);
  let newWidth: Float = Cast<Float>(current) * step;
  this.humanityBarProgress.SetWidth(newWidth);
  this.humanityBarProgress.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityBarProgress.BindProperty(n"tintColor", color);
}

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.edgerunningSystem = EdgerunningSystem.GetInstance(this.m_playerObject.GetGame());

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkVerticalPanel> = root.GetWidget(n"buffsHolder/barsLayout") as inkVerticalPanel;
  this.humanityBarContainer = new inkCanvas();
  this.humanityBarContainer.SetName(n"OuterContainer");
  this.humanityBarContainer.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarContainer.SetVAlign(inkEVerticalAlign.Top);
  this.humanityBarContainer.SetAnchor(inkEAnchor.TopLeft);
  this.humanityBarContainer.SetAnchorPoint(new Vector2(0.0, 0.0));
  this.humanityBarContainer.SetSize(new Vector2(530.0, 10.0));
  this.humanityBarContainer.SetVisible(false);
  this.humanityBarContainer.Reparent(container, 0);

  let progressContainer: ref<inkCanvas> = new inkCanvas();
  progressContainer.SetSize(new Vector2(530.0, 8.0));
  progressContainer.Reparent(this.humanityBarContainer);

  this.humanityBarFull = new inkRectangle();
  this.humanityBarFull.SetName(n"ProgressFull");
  this.humanityBarFull.SetAnchor(inkEAnchor.TopLeft);
  this.humanityBarFull.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarFull.SetVAlign(inkEVerticalAlign.Top);
  this.humanityBarFull.SetSize(new Vector2(530.0, 8.0));
  this.humanityBarFull.SetOpacity(0.75);
  this.humanityBarFull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityBarFull.BindProperty(n"tintColor", n"MainColors.FaintRed");
  this.humanityBarFull.Reparent(progressContainer);

  this.humanityBarProgress = new inkRectangle();
  this.humanityBarProgress.SetName(n"ProgressCurrent");
  this.humanityBarProgress.SetAnchor(inkEAnchor.TopLeft);
  this.humanityBarProgress.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarProgress.SetVAlign(inkEVerticalAlign.Center);
  this.humanityBarProgress.SetSize(new Vector2(530.0, 8.0));
  this.humanityBarProgress.Reparent(progressContainer);

  let current: Int32 = this.edgerunningSystem.GetHumanityCurrent();
  let total: Int32 = this.edgerunningSystem.GetHumanityTotal();
  let color: CName = this.edgerunningSystem.GetHumanityColor();
  this.RefreshHumanityBars(current, total, color);
}


@addMethod(healthbarWidgetGameController)
protected cb func OnUpdateHumanityCounterEvent(evt: ref<UpdateHumanityCounterEvent>) -> Bool {
  if !this.humanityBarContainer.IsVisible() {
    this.humanityBarContainer.SetVisible(true);
  };

  this.RefreshHumanityBars(evt.current, evt.total, evt.color);
}
