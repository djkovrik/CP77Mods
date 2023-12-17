module MetroPocketGuide.Localization
import Codeware.Localization.*

public class MPGLocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      case n"en-us": return new English();
      default: return null;
    };
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}
