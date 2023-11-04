import Edgerunning.System.EdgerunningSystem

@wrapMethod(RipperDocGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.edgerunningSystem = EdgerunningSystem.GetInstance(this.m_player.GetGame());

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let outerContainer = new inkCanvas();
  outerContainer.SetName(n"OuterContainer");
  outerContainer.SetHAlign(inkEHorizontalAlign.Center);
  outerContainer.SetVAlign(inkEVerticalAlign.Bottom);
  outerContainer.SetAnchor(inkEAnchor.BottomCenter);
  outerContainer.SetInteractive(true);
  outerContainer.SetAnchorPoint(new Vector2(0.5, 0.5));
  outerContainer.SetMargin(new inkMargin(0.0, 0.0, 434.0, 140.0));
  outerContainer.Reparent(root, 5);

  this.SpawnFromExternal(
    outerContainer, 
    r"base\\gameplay\\gui\\fullscreen\\wannabe_edgerunner_bars.inkwidget", 
    n"Root:Edgerunning.Controller.NewHumanityBarController"
  );
}

@wrapMethod(RipperdocMetersCapacity)
protected cb func OnLastBarIntroFinished(animProxy: ref<inkAnimProxy>) -> Bool {
  wrappedMethod(animProxy);
  this.QueueEvent(new CyberwareMenuBarAppeared());
}

/*
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
  outerContainer.Reparent(root, 5);

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
  let description: String = GetLocalizedTextByKey(n"Mod-Edg-Humanity-Desc");
  let additionalDescription = this.edgerunningSystem.GetAdditionalPenaltiesDescription();
  data.Title = s"\(GetLocalizedTextByKey(n"Mod-Edg-Humanity")): \(current) / \(total)";
  if NotEquals(additionalDescription, "") {
    data.Description = description + additionalDescription;
  } else {
    data.Description = description;
  };
  this.m_TooltipsManager.ShowTooltip(data);
}

@addMethod(RipperDocGameController)
protected cb func OnHumanityIconHoverOut(evt: ref<inkPointerEvent>) -> Bool {
  this.m_TooltipsManager.HideTooltips();
  this.humanityIcon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityIcon.BindProperty(n"tintColor", n"MainColors.Blue");
}

@addMethod(RipperDocGameController)
public func RefreshHumanityHUD() -> Void {
  let current: Int32 = this.edgerunningSystem.GetHumanityCurrent();
  let total: Int32 = this.edgerunningSystem.GetHumanityTotal();
  this.RefreshHumanityBars(current, total);
}

@addMethod(RipperDocGameController)
protected cb func OnUpdateHumanityCounterEvent(evt: ref<UpdateHumanityCounterEvent>) -> Bool {
  this.RefreshHumanityBars(evt.current, evt.total);
}
*/

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
  this.RefreshHumanityBars(evt.current, evt.total, evt.color);
}
