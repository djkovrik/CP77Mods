module CustomMarkers.Config

import CustomMarkers.Common.*

public class CustomMarkersConfig {
  // Markers amount threshold
  public static func MaximumAvailableMarkers() -> Int32 = 20
  // Primary marker color
  public static func IconColorActive() -> HDRColor = Colors.BaseGreen()
  // Secondary marker color, used for icon picker inactive markers
  public static func IconColorInactive() -> HDRColor = Colors.BaseGrey()
}

/**
  Available colors:

    Colors.BaseYellow()
    Colors.BaseGreen()
    Colors.BaseDarkGreen()
    Colors.BaseOrange()
    Colors.BaseWhite()
    Colors.BaseBlack()
    Colors.BaseGrey()
    Colors.MainRed()
    Colors.MainBlue()
    Colors.MainGreen()
    Colors.MainYellow()
    Colors.MainGold()

  * Main prefix means that color related to the game default color theme.

  ** You can use custom color as well, just adjust values for Custom color inside 
     CustomMapMarkers\common\Colors.reds and use Colors.Custom() as an option.

*/
