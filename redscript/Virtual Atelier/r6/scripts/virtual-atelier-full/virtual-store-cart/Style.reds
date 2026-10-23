module VirtualAtelier.UI

public abstract class VirtualAtelierControlStyle {
  public static func ColorTextButton() -> CName = n"MainColors.Red"
  public static func ColorTextButtonHovered() -> CName = n"MainColors.Yellow"
  public static func ColorImageButtonIcon() -> CName = n"MainColors.Red"
  public static func ColorImageButtonIconHovered() -> CName = n"MainColors.Yellow"
  public static func ColorImageButtonLabel() -> CName = n"MainColors.Red"
  public static func ColorImageButtonLabelHovered() -> CName = n"MainColors.Yellow"
  public static func ColorImageButtonCircle() -> CName = n"MainColors.Gold"
  public static func ColorImageButtonCircleHovered() -> CName = n"MainColors.ActiveYellow"
  public static func ColorImageButtonCounter() -> CName = n"MainColors.Black"
  public static func ColorImageButtonCounterHovered() -> CName = n"MainColors.Black"
  public static func FontSizeTextButton() -> CName = n"MainColors.ReadableMedium"
  public static func FontStyleTextButton() -> CName = n"MainColors.BodyFontWeight";
  public static func FontSizeImageButtonLabel() -> CName = n"MainColors.ReadableMedium"
  public static func FontStyleImageButtonLabel() -> CName = n"MainColors.BodyFontWeight";
  public static func FontSizeImageButtonCounter() -> CName = n"MainColors.ReadableXSmall"
  public static func FontStyleImageButtonCounter() -> CName = n"MainColors.BodyFontWeight";
  public static func CartItemBackground() -> CName = n"MainColors.ActiveGreen";
  public static func QuantityTextColor() -> CName = n"MainColors.ActiveGreen";
  public static func OwnedLabelColor() -> CName = n"MainColors.Blue";
}
