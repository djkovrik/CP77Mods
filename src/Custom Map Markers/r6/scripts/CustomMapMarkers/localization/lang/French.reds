module CustomMarkers.Localization

import Codeware.Localization.*

public class French extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "Marqueur personnalisé");
    this.Text("CustomMarkers-DescriptionLabel", "Entrer description du marqueur:");
    this.Text("CustomMarkers-PickIconLabel", "Choisir icône du marqueur:");
    this.Text("CustomMarkers-ButtonLabelDelete", "Supprimer");
    this.Text("CustomMarkers-AddedMessage", "Nouveau marqueur ajouté");
    this.Text("CustomMarkers-AlreadyExists", "Un marqueur existe déjà à cet endroit");
  }
}
