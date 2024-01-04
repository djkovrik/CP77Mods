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

  // Handle mappin clicks
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
        this.ShowButtonConfirm();

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

  let isNCARTHovered: Bool = Equals(this.selectedMappin.GetMappinVariant(), gamedataMappinVariant.Zzz17_NCARTVariant);
  let shouldHandlePadInput: Bool = !this.HasSelectedMappin() || (this.routeSelectionEnabled && isNCARTHovered);

  // Handle pad input
  if e.IsAction(n"world_map_menu_zoom_to_mappin") && this.IsLastUsedPad() && shouldHandlePadInput {
    switch this.controlMode {
      case MpgControlMode.NAVIGATE:
        this.HandleNavigateClick();
        break;
      case MpgControlMode.CANCEL:
        this.HandleCancelClick();
        break;
      case MpgControlMode.CONFIRM:
        this.HandleConfirmClick();
        break;
      case MpgControlMode.STOP:
        this.HandleStopClick();
        break;
    };

    e.Handle();
    return ;
  };

  wrappedMethod(e);
}

// Button clicks events
@addMethod(WorldMapMenuGameController)
protected cb func OnNavigateButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.HandleNavigateClick();
  };
}

@addMethod(WorldMapMenuGameController)
protected cb func OnCancelButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.HandleCancelClick();
  };
}

@addMethod(WorldMapMenuGameController)
protected cb func OnStopButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.HandleStopClick();
  };
}

@addMethod(WorldMapMenuGameController)
protected cb func OnConfirmButtonClick(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"click") {
    this.HandleConfirmClick();
  };
}

// Button clicks logic
@addMethod(WorldMapMenuGameController)
private final func HandleNavigateClick() -> Void {
  this.PlaySound(n"Button", n"OnPress");
  this.ShowButtonCancel();
  this.routeSelectionEnabled = true;
  this.RefreshFiltersVisibility();
  this.SwitchToCustomFiltersForStations();
  this.SetDepartureAwaitSelection();
  this.ShowSelectDepartureLabel();

  this.mpgUiSystem.QueueEvent(PocketMetroRouteSelectionEnabledEvent.Create());
  this.mpgUiSystem.QueueEvent(PocketMetroPlayerMarkerVisibilityEvent.Create(false));
}

@addMethod(WorldMapMenuGameController)
private final func HandleCancelClick() -> Void {
  this.PlaySound(n"Button", n"OnPress");
  this.ShowButtonNavigate();
  this.routeSelectionEnabled = false;
  this.RefreshFiltersVisibility();
  this.RestorePreviousFiltersState();
  this.SelectionCanceled();

  this.mpgUiSystem.QueueEvent(PocketMetroRouteSelectionDisabledEvent.Create());
  this.mpgUiSystem.QueueEvent(PocketMetroPlayerMarkerVisibilityEvent.Create(true));
}

@addMethod(WorldMapMenuGameController)
private final func HandleStopClick() -> Void {
  this.PlaySound(n"Button", n"OnPress");
  if this.navigator.HasActiveRoute() {
    this.SelectionCanceled();
    this.navigator.Reset();
    this.ShowButtonNavigate();

    this.mpgUiSystem.QueueEvent(PocketMetroRouteSelectionDisabledEvent.Create());
  };
}

@addMethod(WorldMapMenuGameController)
private final func HandleConfirmClick() -> Void {
  this.PlaySound(n"Button", n"OnPress");
  if this.navigator.BuildRoute() {
    this.routeSelectionEnabled = false;
    this.RefreshFiltersVisibility();
    this.RestorePreviousFiltersState();
    this.ShowButtonStop();
    this.mpgUiSystem.QueueEvent(new InjectPocketGuideToHudEvent());
  } else {
    // Should not happen but just in case
    this.ShowButtonNavigate();
    this.SelectionCanceled();
    this.navigator.Reset();
  };
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


// Button controls

@addMethod(WorldMapMenuGameController)
private final func ShowButtonNavigate() -> Void {
  if this.IsLastUsedKBM() {
    this.metroButtonNavigate.SetVisible(true);
    this.metroButtonCancel.SetVisible(false);
    this.metroButtonStop.SetVisible(false);
    this.metroButtonConfirm.SetVisible(false);
  } else {
    this.ShowNavigationHint(n"PMG-Button-Navigate");
    this.controlMode = MpgControlMode.NAVIGATE;
  };
}

@addMethod(WorldMapMenuGameController)
private final func ShowButtonCancel() -> Void {
  if this.IsLastUsedKBM() {
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonCancel.SetVisible(true);
    this.metroButtonStop.SetVisible(false);
    this.metroButtonConfirm.SetVisible(false);
  } else {
    this.ShowNavigationHint(n"PMG-Button-Cancel");
    this.controlMode = MpgControlMode.CANCEL;
  };
}

@addMethod(WorldMapMenuGameController)
private final func ShowButtonStop() -> Void {
  if this.IsLastUsedKBM() {
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonCancel.SetVisible(false);
    this.metroButtonStop.SetVisible(true);
    this.metroButtonConfirm.SetVisible(false);
  } else {
    this.ShowNavigationHint(n"PMG-Button-Stop");
    this.controlMode = MpgControlMode.STOP;
  };
}

@addMethod(WorldMapMenuGameController)
private final func ShowButtonConfirm() -> Void {
  if this.IsLastUsedKBM() {
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonCancel.SetVisible(false);
    this.metroButtonStop.SetVisible(false);
    this.metroButtonConfirm.SetVisible(true);
  } else {
    this.ShowNavigationHint(n"PMG-Button-Confirm");
    this.controlMode = MpgControlMode.CONFIRM;
  };
}

@addMethod(WorldMapMenuGameController)
private final func ShowNavigationHint(locKey: CName) -> Void {
  let priority: Int32 = 10;
  let evt: ref<UpdateInputHintMultipleEvent> = new UpdateInputHintMultipleEvent();
  evt.targetHintContainer = n"WorldMapInputHints";
  this.AddInputHintUpdate(evt, true, n"world_map_menu_zoom_to_mappin", GetLocalizedTextByKey(locKey), priority);
  this.QueueEvent(evt);
}

@wrapMethod(WorldMapMenuGameController)
private final func TryTrackQuestOrSetWaypoint() -> Void {
  if !this.routeSelectionEnabled {
    wrappedMethod();
  };
}
