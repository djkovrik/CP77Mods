module CustomMarkers.Localization

import Codeware.Localization.*

public class Spanish extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("CustomMarkers-MarkerTitle", "Marcador personalizado");
    this.Text("CustomMarkers-DescriptionLabel", "Descripción del marcador:");
    this.Text("CustomMarkers-PickIconLabel", "Icono del marcador:");
    this.Text("CustomMarkers-ButtonLabelDelete", "Quitar");
    this.Text("CustomMarkers-AddedMessage", "Nuevo marcador añadido");
    this.Text("CustomMarkers-AlreadyExists", "Ya existe un marcador aquí");
  }
}