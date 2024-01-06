module CustomMarkers.Localization

import Codeware.Localization.*

public class German extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "Individuelle Markierung");
    this.Text("CustomMarkers-DescriptionLabel", "Neue Marker-Beschreibung eingeben:");
    this.Text("CustomMarkers-PickIconLabel", "Markersymbol auswählen:");
    this.Text("CustomMarkers-ButtonLabelDelete", "Löschen");
    this.Text("CustomMarkers-AddedMessage", "Neuer Marker hinzugefügt");
    this.Text("CustomMarkers-LimitMessage", "Sie haben das Limit für Marker erreicht");
    this.Text("CustomMarkers-AlreadyExists", "Markierung an dieser Stelle existiert bereits");
  }
}
