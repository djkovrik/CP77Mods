import MetroPocketGuide.Navigator.PocketMetroNavigator
import Codeware.UI.*

// Show route details if active
@addMethod(WorldMapMenuGameController)
private final func InvalidateActiveRouteState() -> Void {
  if this.navigator.HasActiveRoute() {
    this.metroButtonNavigate.SetVisible(false);
    this.metroButtonStop.SetVisible(true);
    this.SetDepartureSelected(MetroDataHelper.GetStationTitle(this.navigator.GetDeparture()));
    this.SetDestinationSelected(MetroDataHelper.GetStationTitle(this.navigator.GetDestination()));
  };
}

// Cancel
@addMethod(WorldMapMenuGameController)
private final func SelectionCanceled() -> Void {
  this.mpgUiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(this.navigator.GetDeparture()));
  this.mpgUiSystem.QueueEvent(PocketMetroResetPreviousDestinationEvent.Create(this.navigator.GetDestination()));
  this.departureLabel.SetVisible(false);
  this.destinationLabel.SetVisible(false);
  this.SetDepartureInitial();
  this.SetDestinationInitial();
  this.pulseDeparture.Stop();
  this.pulseDestination.Stop();
  this.navigator.SaveDeparture(ENcartStations.NONE);
  this.navigator.SaveDestination(ENcartStations.NONE);
}
