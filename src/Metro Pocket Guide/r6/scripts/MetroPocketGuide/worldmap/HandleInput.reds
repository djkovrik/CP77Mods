import MetroPocketGuide.Navigator.PocketMetroNavigator

// Marker clicks
@wrapMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  let controller: ref<BaseWorldMapMappinController> = this.currentHoveredController;
  let departureSelected: Bool;
  let destinationSelected: Bool;
  let selectionIsCorrect: Bool;
  let stationName: ENcartStations;
  let selectedTitle: String;
  if e.IsAction(n"click") && IsDefined(controller) && this.routeSelectionEnabled {
    stationName = controller.GetMetroStationName();
    selectedTitle = MetroDataHelper.GetStationTitle(stationName);
    departureSelected = NotEquals(this.navigator.GetDeparture(), ENcartStations.NONE);
    destinationSelected = NotEquals(this.navigator.GetDestination(), ENcartStations.NONE);
    selectionIsCorrect = NotEquals(stationName, ENcartStations.NONE);
    
    MetroLog(s"Has departure selected \(departureSelected), new click for \(stationName), is correct \(selectionIsCorrect)");

    if selectionIsCorrect && controller.IsNotSelectedForRoute() {
      this.PlaySound(n"Button", n"OnPress");

      if !departureSelected && !destinationSelected {
        // nothing selected yet
        this.navigator.SaveDeparture(stationName);
        this.SetDepartureSelected(selectedTitle);
        this.DepartureSelected();
        this.SetDestinationAwaitSelection();
        this.ShowSelectDestinationLabel();
        controller.SelectForRoute();

      } else if departureSelected && !destinationSelected {
        // departure selected but destination is not
        this.navigator.SaveDestination(stationName);
        this.SetDestinationSelected(selectedTitle);
        this.DestinationSelected();
        controller.SelectForRoute();
        this.metroButtonCancel.SetVisible(false);
        this.metroButtonConfirm.SetVisible(true);

      } else if departureSelected && destinationSelected {
        // departure selected and destination selected as well - reset prev destination and set to new
        let prevDestination: ENcartStations = this.navigator.GetDestination();
        this.mpgUiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(prevDestination));
        this.navigator.SaveDestination(stationName);
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

// Button clicks
@addMethod(WorldMapMenuGameController)
protected cb func OnNavigateButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.PlaySound(n"Button", n"OnPress");
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonCancel.SetVisible(true);
    this.routeSelectionEnabled = true;
    this.RefreshFiltersVisibility();
    this.SwitchToCustomFiltersForStations();
    this.SetDepartureAwaitSelection();
    this.ShowSelectDepartureLabel();

    this.mpgUiSystem.QueueEvent(PocketMetroRouteSelectionEnabledEvent.Create());
    this.mpgUiSystem.QueueEvent(PocketMetroPlayerMarkerVisibilityEvent.Create(false));
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnCancelButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.PlaySound(n"Button", n"OnPress");
    this.metroButtonCancel.SetVisible(false);
    this.metroButtonNavigate.SetVisible(true);
    this.routeSelectionEnabled = false;
    this.RefreshFiltersVisibility();
    this.RestorePreviousFiltersState();
    this.SelectionCanceled();

    this.mpgUiSystem.QueueEvent(PocketMetroRouteSelectionDisabledEvent.Create());
    this.mpgUiSystem.QueueEvent(PocketMetroPlayerMarkerVisibilityEvent.Create(true));
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnStopButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    MetroLog("Stop");
    this.PlaySound(n"Button", n"OnPress");
    if this.navigator.HasActiveRoute() {
      this.SelectionCanceled();
      this.navigator.Reset();
      this.metroButtonStop.SetVisible(false);
      this.metroButtonNavigate.SetVisible(true);
    };
  }
}

@addMethod(WorldMapMenuGameController)
protected cb func OnConfirmButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    MetroLog("Confirm");
    this.PlaySound(n"Button", n"OnPress");
    if this.navigator.BuildRoute() {
      this.routeSelectionEnabled = false;
      this.RefreshFiltersVisibility();
      this.RestorePreviousFiltersState();
      this.metroButtonConfirm.SetVisible(false);
      this.metroButtonStop.SetVisible(true);
    } else {
      // Should not happen but just in case
      this.metroButtonConfirm.SetVisible(false);
      this.metroButtonNavigate.SetVisible(true);
      this.SelectionCanceled();
      this.navigator.Reset();
    };
  }
}


// Other worldmap menu input
@wrapMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  if this.ShouldSkipEventHandle(e) {
    e.Handle();
  } else {
    wrappedMethod(e);
  };
}

@wrapMethod(WorldMapMenuGameController)
private final func HandleReleaseInput(e: ref<inkPointerEvent>) -> Void {
  if this.ShouldSkipEventHandle(e) {
    e.Handle();
  } else {
    wrappedMethod(e);
  };
}

// Check if event reated to any custom button
@addMethod(WorldMapMenuGameController)
private final func ShouldSkipEventHandle(e: ref<inkPointerEvent>) -> Bool {
  let targetName: CName = e.GetTarget().GetName();
  let customButtons: array<CName> = [ n"buttonNavigate", n"buttonCancel", n"buttonStop", n"buttonConfirm" ];
  return ArrayContains(customButtons, targetName);
}

// Remember hovered controller
@wrapMethod(WorldMapMenuGameController)
protected cb func OnHoverOverMappin(e: ref<inkPointerEvent>) -> Bool {
  this.currentHoveredController = e.GetTarget().GetController() as BaseWorldMapMappinController;
  wrappedMethod(e);
}

// Clear hovered controller
@wrapMethod(WorldMapMenuGameController)
protected cb func OnHoverOutMappin(e: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(e);
  this.currentHoveredController = null;
}
