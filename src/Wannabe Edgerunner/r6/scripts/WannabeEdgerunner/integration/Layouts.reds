import Edgerunning.System.EdgerunningSystem

// -- CYBERWARE MENU --

@addField(RipperDocGameController)
private let edgerunnerHumanityBar: wref<inkWidget>;

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
  outerContainer.SetMargin(new inkMargin(0.0, 0.0, 434.0, 160.0));
  outerContainer.Reparent(root, 5);

  this.edgerunnerHumanityBar = this.SpawnFromExternal(
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

@addMethod(RipperDocGameController)
protected cb func OnCustomBarHover(evt: ref<CustomBarHoverOverEvent>) -> Bool {
  let tooltipData: ref<RipperdocBarTooltipTooltipData> = new RipperdocBarTooltipTooltipData();
  tooltipData.isHumanityTooltip = true;
  tooltipData.humanityCurrent = evt.humanityCurrent;
  tooltipData.humanityTotal = evt.humanityTotal;
  tooltipData.humanityAdditionalDesc = evt.humanityAdditionalDesc;

  this.m_TooltipsManager.AttachToCursor();
  this.m_TooltipsManager.ShowTooltip(n"RipperdocBarTooltip", tooltipData, this.m_defaultTooltipsMargin);
}

@addMethod(RipperDocGameController)
protected cb func OnHumanityThresholdHoverOverEvent(evt: ref<HumanityThresholdHoverOverEvent>) -> Bool {
  let tooltipData: ref<RipperdocBarTooltipTooltipData> = new RipperdocBarTooltipTooltipData();
  tooltipData.isThresholdTooltip = true;
  tooltipData.psychosisChance = evt.chance;
  tooltipData.humanityThreshold = evt.humanityThreshold;
  tooltipData.humanityTotal = evt.humanityTotal;

  this.m_TooltipsManager.AttachToCursor();
  this.m_TooltipsManager.ShowTooltip(n"RipperdocBarTooltip", tooltipData, this.m_defaultTooltipsMargin);
}

@addMethod(RipperDocGameController)
protected cb func OnCustomBarHoverOutEvent(evt: ref<CustomBarHoverOutEvent>) -> Bool {
  this.m_TooltipsManager.HideTooltips();
}

@wrapMethod(RipperdocBarTooltip)
public func SetData(tooltipData: ref<ATooltipData>) -> Void {
  let alternateTooltipData: ref<RipperdocBarTooltipTooltipData> = tooltipData as RipperdocBarTooltipTooltipData;
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  root.GetWidgetByPathName(n"main/content/categories/stats").SetVisible(true);
  root.GetWidgetByPathName(n"main/content/categories/perks").SetVisible(true);

  if alternateTooltipData.isHumanityTooltip {
    // Title
    inkTextRef.SetLocalizedText(this.m_titleName, n"Mod-Edg-Humanity");
    // Top right numbers
    inkTextRef.SetText(this.m_titleTotalValue, IntToString(alternateTooltipData.humanityCurrent));
    inkTextRef.SetText(this.m_titleMaxValue, IntToString(alternateTooltipData.humanityTotal));
    // Description visibility
    inkWidgetRef.SetVisible(this.m_armorDescription, true);
    inkWidgetRef.SetVisible(this.m_armorReductionDescription, false);
    inkWidgetRef.SetVisible(this.m_capacityDescription, false);
    inkWidgetRef.SetVisible(this.m_statsHolder, false);
    inkWidgetRef.SetVisible(this.m_perk1, false);
    inkWidgetRef.SetVisible(this.m_perk2, false);
    inkWidgetRef.SetVisible(this.m_perkTreeInput, false);
    inkWidgetRef.SetVisible(this.m_perkTreeIcon, false);
    // Custom text
    let description: String = GetLocalizedTextByKey(n"Mod-Edg-Humanity-Desc");
    if NotEquals(alternateTooltipData.humanityAdditionalDesc, "") {
      description = description + alternateTooltipData.humanityAdditionalDesc;
    };
    let descText: ref<inkText> = inkWidgetRef.Get(this.m_armorDescription) as inkText;
    descText.SetText(description);
    // Hide other stuff
    root.GetWidgetByPathName(n"main/content/categories/stats").SetVisible(false);
    root.GetWidgetByPathName(n"main/content/categories/perks").SetVisible(false);

    return ;
  };

  if alternateTooltipData.isThresholdTooltip {
    // Title
    inkTextRef.SetLocalizedText(this.m_titleName, n"Mod-Edg-Pre-Psychosis");
    // Top right numbers
    inkTextRef.SetText(this.m_titleTotalValue, IntToString(alternateTooltipData.humanityThreshold));
    inkTextRef.SetText(this.m_titleMaxValue, IntToString(alternateTooltipData.humanityTotal));
    // Description visibility
    inkWidgetRef.SetVisible(this.m_armorDescription, true);
    inkWidgetRef.SetVisible(this.m_armorReductionDescription, false);
    inkWidgetRef.SetVisible(this.m_capacityDescription, false);
    inkWidgetRef.SetVisible(this.m_statsHolder, false);
    inkWidgetRef.SetVisible(this.m_perk1, false);
    inkWidgetRef.SetVisible(this.m_perk2, false);
    inkWidgetRef.SetVisible(this.m_perkTreeInput, false);
    inkWidgetRef.SetVisible(this.m_perkTreeIcon, false);
    // Custom text
    let description: String = GetLocalizedTextByKey(n"Mod-Edg-Humanity-Threshold-Popup");
    let params: ref<inkTextParams> = new inkTextParams();
    params.AddString("chance", IntToString(alternateTooltipData.psychosisChance));
    let descText: ref<inkText> = inkWidgetRef.Get(this.m_armorDescription) as inkText;
    descText.SetText(description, params);
    // Hide other stuff
    root.GetWidgetByPathName(n"main/content/categories/stats").SetVisible(false);
    root.GetWidgetByPathName(n"main/content/categories/perks").SetVisible(false);

    return ;
  };

  wrappedMethod(tooltipData);
}

@wrapMethod(RipperDocGameController)
protected cb func OnPreviewCyberwareClick(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  this.edgerunnerHumanityBar.SetVisible(false);
}

@wrapMethod(RipperDocGameController)
protected cb func OnSelectorChange(evt: ref<RipperdocSelectorChangeEvent>) -> Bool {
  wrappedMethod(evt);
  this.edgerunnerHumanityBar.SetVisible(false);
}

@wrapMethod(RipperDocGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
  wrappedMethod(userData);
  this.edgerunnerHumanityBar.SetVisible(true);
}


// -- HEALTHBAR --

@addMethod(healthbarWidgetGameController)
public func RefreshHumanityBars(current: Int32, total: Int32, color: CName) -> Void {
  if this.IsPlayingAsJohnny() {return ; };

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

  if this.IsPlayingAsJohnny() {return true; };
  
  this.edgerunningSystem = EdgerunningSystem.GetInstance(this.m_playerObject.GetGame());

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkVerticalPanel> = root.GetWidget(n"buffsHolder/barsLayout") as inkVerticalPanel;
  this.humanityBarContainer = new inkCanvas();
  this.humanityBarContainer.SetName(n"OuterContainer");
  this.humanityBarContainer.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarContainer.SetVAlign(inkEVerticalAlign.Top);
  this.humanityBarContainer.SetAnchor(inkEAnchor.TopLeft);
  this.humanityBarContainer.SetAnchorPoint(new Vector2(0.0, 0.0));
  this.humanityBarContainer.SetSize(new Vector2(530.0, 12.0));
  this.humanityBarContainer.Reparent(container, 0);

  let progressContainer: ref<inkCanvas> = new inkCanvas();
  progressContainer.SetSize(new Vector2(530.0, 8.0));
  progressContainer.Reparent(this.humanityBarContainer);

  this.humanityBarFull = new inkRectangle();
  this.humanityBarFull.SetName(n"ProgressFull");
  this.humanityBarFull.SetAnchor(inkEAnchor.TopLeft);
  this.humanityBarFull.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarFull.SetVAlign(inkEVerticalAlign.Top);
  this.humanityBarFull.SetSize(new Vector2(530.0, 10.0));
  this.humanityBarFull.SetOpacity(0.75);
  this.humanityBarFull.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.humanityBarFull.BindProperty(n"tintColor", n"MainColors.FaintRed");
  this.humanityBarFull.Reparent(progressContainer);

  this.humanityBarProgress = new inkRectangle();
  this.humanityBarProgress.SetName(n"ProgressCurrent");
  this.humanityBarProgress.SetAnchor(inkEAnchor.TopLeft);
  this.humanityBarProgress.SetHAlign(inkEHorizontalAlign.Left);
  this.humanityBarProgress.SetVAlign(inkEVerticalAlign.Center);
  this.humanityBarProgress.SetSize(new Vector2(530.0, 10.0));
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

@addMethod(healthbarWidgetGameController)
private func IsPlayingAsJohnny() -> Bool {
  let controlledPuppet: wref<gamePuppetBase> = GetPlayer(this.m_gameInstance);
  let controlledPuppetRecordID: TweakDBID;
  if controlledPuppet != null {
    controlledPuppetRecordID = controlledPuppet.GetRecordID();
    if controlledPuppetRecordID == t"Character.johnny_replacer" {
      return true;
    };
  };

  return false;
}
