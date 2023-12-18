import MetroPocketGuide.Navigator.PocketMetroNavigator
import Codeware.UI.*

// Show route details if active
@addMethod(WorldMapMenuGameController)
private final func InvalidateActiveRouteState() -> Void {
  if PocketMetroNavigator.HasActiveRoute() {
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonStop.SetVisible(true);
    this.activeRouteDetails.SetVisible(true);
    this.activeRouteDetails.SetText(this.BuildShortRouteString());
  };
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
