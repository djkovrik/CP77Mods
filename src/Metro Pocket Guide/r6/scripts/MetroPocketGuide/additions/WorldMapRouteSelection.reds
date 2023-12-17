import MetroPocketGuide.Navigator.PocketMetroNavigator
import Codeware.Localization.*

@addMethod(WorldMapMenuGameController)
private final func AddMetroPocketGuideLabels() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let parent: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"Content") as inkCompoundWidget;

  let selectionContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
  selectionContainer.SetName(n"selectionLabels");
  selectionContainer.SetAnchor(inkEAnchor.TopCenter);
  selectionContainer.SetFitToContent(true);
  selectionContainer.SetInteractive(false);
  selectionContainer.SetAnchorPoint(0.5, 0.5);
  selectionContainer.SetMargin(0.0, 240.0, 0.0, 0.0);
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

  let routeDetails: ref<inkText> = new inkText();
  routeDetails.SetName(n"routeDetails");
  routeDetails.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
  routeDetails.SetFontStyle(n"Medium");
  routeDetails.SetFontSize(44);
  routeDetails.SetLetterCase(textLetterCase.OriginalCase);
  routeDetails.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  routeDetails.BindProperty(n"tintColor", n"MainColors.Blue");
  routeDetails.SetAnchor(inkEAnchor.TopCenter);
  routeDetails.SetAnchorPoint(0.5, 0.5);
  routeDetails.SetMargin(0.0, 240.0, 0.0, 0.0);
  routeDetails.SetHorizontalAlignment(textHorizontalAlignment.Center);
  routeDetails.SetVerticalAlignment(textVerticalAlignment.Center);
  routeDetails.SetContentHAlign(inkEHorizontalAlign.Center);
  routeDetails.SetContentVAlign(inkEVerticalAlign.Center);
  routeDetails.SetJustificationType(textJustificationType.Center);
  routeDetails.SetText("From: xxxxxxxxxxxxxxxxxxxxxx\nTo: xxxxxxxxxxxxxxxxxxxxxx");
  routeDetails.SetVisible(false);
  routeDetails.Reparent(parent);

  this.departureLabel = from;
  this.destinationLabel = to;
  this.activeRouteDetails = routeDetails;

  this.SetDepartureInitial();
  this.SetDestinationInitial();
}

// Control labels - departure

@addMethod(WorldMapMenuGameController)
private final func SetDepartureInitial() -> Void {
  this.departureLabel.SetText(" ");
}

@addMethod(WorldMapMenuGameController)
private final func SetDepartureAwaitSelection() -> Void {
  this.departureLabel.SetText(this.GetLocalizedTextCustom("PMG-Select-Departure"));
}

@addMethod(WorldMapMenuGameController)
private final func ShowSelectDepartureLabel() -> Void {
  this.departureLabel.SetVisible(true);
  this.pulseDeparture.Start();
}

@addMethod(WorldMapMenuGameController)
private final func DepartureSelected() -> Void {
  this.pulseDeparture.Stop();
}

@addMethod(WorldMapMenuGameController)
private final func SetDepartureSelected(selectedTitle: String) -> Void {
  this.departureLabel.SetText(s"\(this.GetLocalizedTextCustom("PMG-From")) \(GetLocalizedText(selectedTitle))");
}

// Destination

@addMethod(WorldMapMenuGameController)
private final func SetDestinationInitial() -> Void {
  this.destinationLabel.SetText(" ");
}

@addMethod(WorldMapMenuGameController)
private final func SetDestinationAwaitSelection() -> Void {
  this.destinationLabel.SetText(this.GetLocalizedTextCustom("PMG-Select-Destination"));
}

@addMethod(WorldMapMenuGameController)
private final func ShowSelectDestinationLabel() -> Void {
  this.destinationLabel.SetVisible(true);
  this.pulseDestination.Start();
}

@addMethod(WorldMapMenuGameController)
private final func DestinationSelected() -> Void {
  this.destinationLabel.SetVisible(true);
  this.pulseDestination.Stop();
}

@addMethod(WorldMapMenuGameController)
private final func SetDestinationSelected(selectedTitle: String) -> Void {
  this.destinationLabel.SetText(s"\(this.GetLocalizedTextCustom("PMG-To")) \(GetLocalizedText(selectedTitle))");
}

// Cancel

@addMethod(WorldMapMenuGameController)
private final func SelectionCanceled() -> Void {
  this.mpgUiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(PocketMetroNavigator.GetDeparture()));
  this.mpgUiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(PocketMetroNavigator.GetDestination()));
  this.departureLabel.SetVisible(false);
  this.destinationLabel.SetVisible(false);
  this.SetDepartureInitial();
  this.SetDestinationInitial();
  this.pulseDeparture.Stop();
  this.pulseDestination.Stop();
  PocketMetroNavigator.SaveDeparture(ENcartStations.NONE);
  PocketMetroNavigator.SaveDestination(ENcartStations.NONE);
}


// Rememver hovered
@wrapMethod(WorldMapMenuGameController)
protected cb func OnHoverOverMappin(e: ref<inkPointerEvent>) -> Bool {
  this.currentHoveredController = e.GetTarget().GetController() as BaseWorldMapMappinController;
  wrappedMethod(e);
}

// Clear hovered
@wrapMethod(WorldMapMenuGameController)
protected cb func OnHoverOutMappin(e: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(e);
  this.currentHoveredController = null;
}

@wrapMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  let controller: ref<BaseWorldMapMappinController> = this.currentHoveredController;
  let departureSelected: Bool;
  let destinationSelected: Bool;
  let selectionIsCorrect: Bool;
  let stationName: ENcartStations;
  let selectedTitle: String;
  if e.IsAction(n"click") && IsDefined(controller) {
    stationName = controller.GetMetroStationName();
    selectedTitle = MetroDataHelper.GetStationTitle(stationName);
    departureSelected = NotEquals(PocketMetroNavigator.GetDeparture(), ENcartStations.NONE);
    destinationSelected = NotEquals(PocketMetroNavigator.GetDestination(), ENcartStations.NONE);
    selectionIsCorrect = NotEquals(stationName, ENcartStations.NONE);
    
    MetroLog(s"Has departure selected \(departureSelected), new click for \(stationName), is correct \(selectionIsCorrect)");

    if selectionIsCorrect && controller.IsNotSelectedForRoute() {
      this.PlaySound(n"Button", n"OnPress");

      if !departureSelected && !destinationSelected {
        // nothing selected yet
        PocketMetroNavigator.SaveDeparture(stationName);
        this.SetDepartureSelected(selectedTitle);
        this.DepartureSelected();
        this.SetDestinationAwaitSelection();
        this.ShowSelectDestinationLabel();
        controller.SelectForRoute();

      } else if departureSelected && !destinationSelected {
        // departure selected but destination is not
        PocketMetroNavigator.SaveDestination(stationName);
        this.SetDestinationSelected(selectedTitle);
        this.DestinationSelected();
        controller.SelectForRoute();
        this.metroButtonCancel.SetVisible(false);
        this.metroButtonConfirm.SetVisible(true);

      } else if departureSelected && destinationSelected {
        // departure selected and destination selected as well - reset prev destination and set to new
        let prevDestination: ENcartStations = PocketMetroNavigator.GetDestination();
        this.mpgUiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(prevDestination));
        PocketMetroNavigator.SaveDestination(stationName);
        this.SetDestinationSelected(selectedTitle);
        this.DestinationSelected();
        controller.SelectForRoute();
      };

      e.Handle();
      return ;
    };
  };

  wrappedMethod(e);
}

@wrapMethod(WorldMapMenuGameController)
protected cb func OnUninitialize() -> Bool {
  if !PocketMetroNavigator.HasActiveRoute() {
    this.SelectionCanceled();
    PocketMetroNavigator.OnCanceled();
  };

  return wrappedMethod();
}

// Mappins stuff

@addMethod(BaseWorldMapMappinController)
protected cb func OnPocketMetroResetPreviousDestinationEvent(evt: ref<PocketMetroResetPreviousDestinationEvent>) -> Bool {
  let destination: ENcartStations = this.GetMetroStationName();
  if Equals(destination, evt.destination) {
    this.DeselectFromRoute();
  };
}

@addMethod(BaseWorldMapMappinController)
public final func SelectForRoute() -> Void {
  this.selectionGlow.SetVisible(true);
}

@addMethod(BaseWorldMapMappinController)
public final func DeselectFromRoute() -> Void {
  this.selectionGlow.SetVisible(false);
}

@addMethod(BaseWorldMapMappinController)
public final func IsNotSelectedForRoute() -> Bool {
  return !this.selectionGlow.IsVisible();
}

@addMethod(BaseWorldMapMappinController)
public final func GetMetroStationName() -> ENcartStations {
  let mappin: ref<FastTravelMappin> = this.GetMappin() as FastTravelMappin;
  let stationName: String = "";
  if IsDefined(mappin) {
    stationName = mappin.GetPointData().GetPointDisplayName();
  } else {
    stationName = "";
  };

  return MetroDataHelper.GetStationNameByLocKey(stationName);
}

@wrapMethod(BaseWorldMapMappinController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let glow: ref<inkImage> = new inkImage();
  glow.SetName(n"hover");
  glow.SetAtlasResource(r"base\\gameplay\\gui\\metro_pocket_guide_icons.inkatlas");
  glow.SetTexturePart(n"selection");
  glow.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  glow.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  glow.SetAnchor(inkEAnchor.Fill);
  glow.SetVisible(false);
  glow.Reparent(this.GetRootCompoundWidget());
  this.selectionGlow = glow;
}

@wrapMethod(BaseWorldMapMappinController)
protected final func Update() -> Void {
  wrappedMethod();

  let hasActiveRoute: Bool = PocketMetroNavigator.IsSelectedAsRoute(this.GetMetroStationName());
  this.selectionGlow.SetVisible(hasActiveRoute);
}

@addMethod(WorldMapMenuGameController)
private final func BuildShortRouteString() -> String {
  let str: String = "";
  str += this.GetLocalizedTextCustom("PMG-From");
  str += " ";
  str += GetLocalizedText(MetroDataHelper.GetStationTitle(PocketMetroNavigator.GetDeparture()));
  str += "\n";
  str += this.GetLocalizedTextCustom("PMG-To");
  str += " ";
  str += GetLocalizedText(MetroDataHelper.GetStationTitle(PocketMetroNavigator.GetDestination()));
  return str;
}

@addMethod(WorldMapMenuGameController)
private final func GetLocalizedTextCustom(key: String) -> String {
  if !IsDefined(this.mpgTranslator) {
    this.mpgTranslator = LocalizationSystem.GetInstance(GetGameInstance());
  };
  return this.mpgTranslator.GetText(key);
}
