module CustomMarkers.Config

import CustomMarkers.Common.*

public class CustomMarkersConfig {
  public static func IconColorActive() -> HDRColor = Colors.BaseGreen()
  public static func IconColorInactive() -> HDRColor = Colors.BaseGray()
}

// TODO:
// - return to game after marker creation
// - persist created markers
