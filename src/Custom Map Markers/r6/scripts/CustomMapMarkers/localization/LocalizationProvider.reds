module CustomMarkers.Localization

import Codeware.Localization.*

public class LocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      case n"en-us": return new English();
      case n"ru-ru": return new Russian();
      case n"zh-cn": return new SimplifiedChinese();
      case n"zh-tw": return new TraditionalChinese();
      default: return null;
    }
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}
