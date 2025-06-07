module CustomMarkers.Config

import CustomMarkers.Common.*

public class CustomMarkersConfig {
  // Primary marker color
  public static func IconColorActive() -> HDRColor = Colors.BaseOrange()
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
