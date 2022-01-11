module CustomMarkers.Config
import CustomMarkers.Core.*

public class CustomMarkersConfig {
  
  public static func Title() -> String = "Custom mappin"

  public static func DescriptionLabel() -> String = "Enter new marker description:"

  public static func TypeLabel() -> String = "Select marker icon:"

  public static func DeleteLabel() -> String = "Delete"

  public static func IconColorActive() -> HDRColor = Colors.BaseGreen()

  public static func IconColorInactive() -> HDRColor = Colors.BaseGray()
}

// TODO:
// - localization (codeware)?
// - persist created markers
