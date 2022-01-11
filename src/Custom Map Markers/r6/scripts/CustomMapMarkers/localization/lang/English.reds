module CustomMarkers.Localization
import Codeware.Localization.*

public class English extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "Custom mappin");
    this.Text("CustomMarkers-DescriptionLabel", "Enter new marker description:");
    this.Text("CustomMarkers-PickIconLabel", "Select marker icon:");
    this.Text("CustomMarkers-ButtonLabelDelete", "Delete");
    this.Text("CustomMarkers-MappinAddedMessage", "New mappin added");
  }
}
