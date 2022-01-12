module CustomMarkers.Common

public class Colors {
  // Base colors
  public static func BaseYellow() -> HDRColor = new HDRColor(1.0, 1.0, 0.0, 1.0)
  public static func BaseGreen() -> HDRColor = new HDRColor(0.0, 1.0, 0.0, 1.0)
  public static func BaseDarkGreen() -> HDRColor = new HDRColor(0.1, 0.5, 0.1, 1.0)
  public static func BaseOrange() -> HDRColor = new HDRColor(1.0, 0.5, 0.0, 1.0)
  public static func BaseWhite() -> HDRColor = new HDRColor(1.0, 1.0, 1.0, 1.0)
  public static func BaseBlack() -> HDRColor = new HDRColor(0.0, 0.0, 0.0, 1.0)
  public static func BaseGray() -> HDRColor = new HDRColor(0.5, 0.5, 0.5, 0.5)
  // Colors from the default in game theme
  public static func MainRed() -> HDRColor = new HDRColor(1.1761, 0.3809, 0.3476, 1.0)
  public static func MainBlue() -> HDRColor = new HDRColor(0.368627, 0.964706, 1.0, 1.0)
  public static func MainGreen() -> HDRColor = new HDRColor(0.113725, 0.929412, 0.513726, 1.0)
  public static func MainYellow() -> HDRColor = new HDRColor(1.1192, 0.8441, 0.2565, 1.0)
  public static func MainGold() -> HDRColor = new HDRColor(1.1192, 0.8441, 0.2565, 1.0)
  // Custom color (HDR RGBA)
  public static func Custom() -> HDRColor = new HDRColor(1.0, 1.0, 1.0, 1.0)
}
