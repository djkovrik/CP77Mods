import MetroPocketGuide.Navigator.PocketMetroNavigator

// Labels control - Departure
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

// Labels control - Destination
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
