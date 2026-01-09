module CustomMarkers.Config

import CustomMarkers.Common.*

public class CustomMarkersConfig {
  @runtimeProperty("ModSettings.mod", "Custom Map Markers")
  @runtimeProperty("ModSettings.category", "UI-Settings-ButtonMappings-Categories-General")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "CustomMarkers-ActiveMarker")
  @runtimeProperty("ModSettings.description", "")
  @runtimeProperty("ModSettings.displayValues.Yellow", "CustomMarkers-Yellow")
  @runtimeProperty("ModSettings.displayValues.Green", "CustomMarkers-Green")
  @runtimeProperty("ModSettings.displayValues.DarkGreen", "CustomMarkers-DarkGreen")
  @runtimeProperty("ModSettings.displayValues.Orange", "CustomMarkers-Orange")
  @runtimeProperty("ModSettings.displayValues.White", "CustomMarkers-White")
  @runtimeProperty("ModSettings.displayValues.Grey", "CustomMarkers-Grey")
  @runtimeProperty("ModSettings.displayValues.Red", "CustomMarkers-Red")
  @runtimeProperty("ModSettings.displayValues.DarkRed", "CustomMarkers-DarkRed")
  @runtimeProperty("ModSettings.displayValues.Blue", "CustomMarkers-Blue")
  @runtimeProperty("ModSettings.displayValues.DarkBlue", "CustomMarkers-DarkBlue")
  @runtimeProperty("ModSettings.displayValues.Gold", "CustomMarkers-Gold")
  public let markerColorActive: CmmColors = CmmColors.Orange;

  @runtimeProperty("ModSettings.mod", "Custom Map Markers")
  @runtimeProperty("ModSettings.category", "UI-Settings-ButtonMappings-Categories-General")
  @runtimeProperty("ModSettings.category.order", "0")
  @runtimeProperty("ModSettings.displayName", "CustomMarkers-InactiveMarker")
  @runtimeProperty("ModSettings.description", "")
  @runtimeProperty("ModSettings.displayValues.Yellow", "CustomMarkers-Yellow")
  @runtimeProperty("ModSettings.displayValues.Green", "CustomMarkers-Green")
  @runtimeProperty("ModSettings.displayValues.DarkGreen", "CustomMarkers-DarkGreen")
  @runtimeProperty("ModSettings.displayValues.Orange", "CustomMarkers-Orange")
  @runtimeProperty("ModSettings.displayValues.White", "CustomMarkers-White")
  @runtimeProperty("ModSettings.displayValues.Grey", "CustomMarkers-Grey")
  @runtimeProperty("ModSettings.displayValues.Red", "CustomMarkers-Red")
  @runtimeProperty("ModSettings.displayValues.DarkRed", "CustomMarkers-DarkRed")
  @runtimeProperty("ModSettings.displayValues.Blue", "CustomMarkers-Blue")
  @runtimeProperty("ModSettings.displayValues.DarkBlue", "CustomMarkers-DarkBlue")
  @runtimeProperty("ModSettings.displayValues.Gold", "CustomMarkers-Gold")
  public let markerColorInactive: CmmColors = CmmColors.Grey;

  public static func GetColorStyleName(color: CmmColors) -> CName {
    switch color {
      case CmmColors.Yellow: return n"MainColors.Yellow";
      case CmmColors.Green: return n"MainColors.Green";
      case CmmColors.DarkGreen: return n"MainColors.DarkGreen";
      case CmmColors.Orange: return n"MainColors.Orange";
      case CmmColors.White: return n"MainColors.White";
      case CmmColors.Grey: return n"MainColors.Grey";
      case CmmColors.Red: return n"MainColors.Red";
      case CmmColors.DarkRed: return n"MainColors.DarkRed";
      case CmmColors.Blue: return n"MainColors.Blue";
      case CmmColors.DarkBlue: return n"MainColors.DarkBlue";
      case CmmColors.Gold: return n"MainColors.Gold";
    };

    return n"MainColors.White";
  }
}
