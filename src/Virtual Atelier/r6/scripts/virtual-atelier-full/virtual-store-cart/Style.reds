module VirtualAtelier.UI

public abstract class VirtualAtelierControlStyle {
  public static func ColorTextButton() -> CName = n"MainColors.Red"
  public static func ColorTextButtonHovered() -> CName = n"MainColors.ActiveBlue"
  public static func ColorImageButtonIcon() -> CName = n"MainColors.Red"
  public static func ColorImageButtonIconHovered() -> CName = n"MainColors.ActiveBlue"
  public static func ColorImageButtonLabel() -> CName = n"MainColors.Red"
  public static func ColorImageButtonLabelHovered() -> CName = n"MainColors.ActiveBlue"
  public static func ColorImageButtonCircle() -> CName = n"MainColors.MildGreen"
  public static func ColorImageButtonCircleHovered() -> CName = n"MainColors.ActiveBlue"
  public static func ColorImageButtonCounter() -> CName = n"MainColors.FaintBlue"
  public static func ColorImageButtonCounterHovered() -> CName = n"MainColors.FaintBlue"
  public static func FontSizeTextButton() -> CName = n"MainColors.ReadableMedium"
  public static func FontStyleTextButton() -> CName = n"MainColors.BodyFontWeight";
  public static func FontSizeImageButtonLabel() -> CName = n"MainColors.ReadableMedium"
  public static func FontStyleImageButtonLabel() -> CName = n"MainColors.BodyFontWeight";
  public static func FontSizeImageButtonCounter() -> CName = n"MainColors.ReadableXSmall"
  public static func FontStyleImageButtonCounter() -> CName = n"MainColors.BodyFontWeight";
  public static func CartItemBackground() -> CName = n"MainColors.ActiveGreen";
  public static func QuantityTextColor() -> CName = n"MainColors.ActiveGreen";
}
