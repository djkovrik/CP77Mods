module CustomMarkers.Localization

import Codeware.Localization.*

public class English extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "Custom marker");
    this.Text("CustomMarkers-DescriptionLabel", "Enter new marker description:");
    this.Text("CustomMarkers-PickIconLabel", "Select marker icon:");
    this.Text("CustomMarkers-ButtonLabelDelete", "Delete");
    this.Text("CustomMarkers-AddedMessage", "New marker added");
    this.Text("CustomMarkers-AlreadyExists", "Marker at this position already exists");
  }
}
