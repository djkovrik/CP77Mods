module MetroPocketGuide.Localization
import Codeware.Localization.*

public class English extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    this.Text("PMG-Select-Departure", "Select departure station");
    this.Text("PMG-Select-Destination", "Select destination station");
    this.Text("PMG-From", "From:");
    this.Text("PMG-To", "To:");
  }
}
