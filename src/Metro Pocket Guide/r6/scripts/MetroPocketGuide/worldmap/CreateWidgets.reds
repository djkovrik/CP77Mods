import MetroPocketGuide.Navigator.PocketMetroNavigator
import Codeware.UI.*

// Selection labels
@addMethod(WorldMapMenuGameController)
private final func AddMetroPocketGuideLabels() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let parent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Content") as inkCompoundWidget;

  let selectionContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
  selectionContainer.SetName(n"selectionLabels");
  selectionContainer.SetAnchor(inkEAnchor.BottomCenter);
  selectionContainer.SetFitToContent(true);
  selectionContainer.SetInteractive(false);
  selectionContainer.SetAnchorPoint(0.5, 0.5);
  selectionContainer.SetMargin(0.0, 0.0, 0.0, 248.0);
  selectionContainer.Reparent(parent);

  let from: ref<inkText> = new inkText();
  from.SetName(n"labelFrom");
  from.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  from.SetFontStyle(n"Medium");
  from.SetFontSize(44);
  from.SetLetterCase(textLetterCase.OriginalCase);
  from.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  from.BindProperty(n"tintColor", n"MainColors.Blue");
  from.SetAnchor(inkEAnchor.Fill);
  from.SetHorizontalAlignment(textHorizontalAlignment.Center);
  from.SetVerticalAlignment(textVerticalAlignment.Top);
  from.Reparent(selectionContainer);

  let to: ref<inkText> = new inkText();
  to.SetName(n"labelFrom");
  to.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  to.SetFontStyle(n"Medium");
  to.SetFontSize(44);
  to.SetLetterCase(textLetterCase.OriginalCase);
  to.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  to.BindProperty(n"tintColor", n"MainColors.Blue");
  to.SetAnchor(inkEAnchor.Fill);
  to.SetHorizontalAlignment(textHorizontalAlignment.Center);
  to.SetVerticalAlignment(textVerticalAlignment.Center);
  to.Reparent(selectionContainer);

  this.departureLabel = from;
  this.destinationLabel = to;

  this.SetDepartureInitial();
  this.SetDestinationInitial();
}

// Selection controls
@addMethod(WorldMapMenuGameController)
private final func AddMetroPocketGuideControls() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let parent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Content") as inkCompoundWidget;
  let buttonsContainer: ref<inkCompoundWidget> = new inkCanvas();
  buttonsContainer.SetName(n"buttonsContainer");
  buttonsContainer.SetAnchor(inkEAnchor.BottomCenter);
  buttonsContainer.SetFitToContent(true);
  buttonsContainer.SetInteractive(false);
  buttonsContainer.SetAnchorPoint(0.5, 1.0);
  buttonsContainer.SetMargin(0.0, 0.0, 0.0, 120.0);
  buttonsContainer.Reparent(parent);

  this.metroButtonNavigate = PocketMetroNavButton.Create();
  this.metroButtonNavigate.SetName(n"buttonNavigate");
  this.metroButtonNavigate.SetText(GetLocalizedTextByKey(n"PMG-Button-Navigate"));
  this.metroButtonNavigate.RegisterToCallback(n"OnClick", this, n"OnNavigateButtonClick");
  this.metroButtonNavigate.Reparent(buttonsContainer);

  this.metroButtonCancel = PocketMetroNavButton.Create();
  this.metroButtonCancel.SetName(n"buttonCancel");
  this.metroButtonCancel.SetText(GetLocalizedTextByKey(n"PMG-Button-Cancel"));
  this.metroButtonCancel.SetVisible(false);
  this.metroButtonCancel.RegisterToCallback(n"OnClick", this, n"OnCancelButtonClick");
  this.metroButtonCancel.Reparent(buttonsContainer);

  this.metroButtonStop = PocketMetroNavButton.Create();
  this.metroButtonStop.SetText(GetLocalizedTextByKey(n"PMG-Button-Stop"));
  this.metroButtonStop.SetName(n"buttonStop");
  this.metroButtonStop.SetVisible(false);
  this.metroButtonStop.RegisterToCallback(n"OnClick", this, n"OnStopButtonClick");
  this.metroButtonStop.Reparent(buttonsContainer);

  this.metroButtonConfirm = PocketMetroNavButton.Create();
  this.metroButtonConfirm.SetText(GetLocalizedTextByKey(n"PMG-Button-Confirm"));
  this.metroButtonConfirm.SetName(n"buttonConfirm");
  this.metroButtonConfirm.SetVisible(false);
  this.metroButtonConfirm.RegisterToCallback(n"OnClick", this, n"OnConfirmButtonClick");
  this.metroButtonConfirm.Reparent(buttonsContainer);
}

// Selected mappin fluff
@addMethod(BaseWorldMapMappinController)
private final func CreateSelectedMappinGlow() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let glow: ref<inkImage> = new inkImage();
  glow.SetName(n"hover");
  glow.SetAtlasResource(r"base\\gameplay\\gui\\metro_pocket_guide_icons.inkatlas");
  glow.SetTexturePart(n"selection");
  glow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  glow.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  glow.SetAnchor(inkEAnchor.Fill);
  glow.SetVisible(false);
  glow.Reparent(root);
  this.selectionGlow = glow;
}