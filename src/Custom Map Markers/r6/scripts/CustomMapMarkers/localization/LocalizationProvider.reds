module CustomMarkers.Localization

import Codeware.Localization.*

public class LocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      case n"en-us": return new English();
      case n"fr-fr": return new French();
      case n"ru-ru": return new Russian();
      case n"zh-cn": return new SimplifiedChinese();
      case n"zh-tw": return new TraditionalChinese();
      case n"es-es": return new Spanish();
      case n"de-de": return new German();
      default: return null;
    }
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}
