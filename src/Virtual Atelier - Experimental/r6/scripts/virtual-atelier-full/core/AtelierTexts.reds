module VirtualAtelier.Core

public class AtelierTexts {
  public static func TabName() -> String = GetLocalizedTextByKey(n"VA-Tab-Name")
  public static func EmptyPlaceholder() -> String = GetLocalizedTextByKey(n"VA-No-Stores")
  public static func PreviewEnable() -> String = GetLocalizedTextByKey(n"VA-Preview-Enable")
  public static func PreviewDisable() -> String = GetLocalizedTextByKey(n"VA-Preview-Disable")
  public static func PreviewReset() -> String = GetLocalizedTextByKey(n"VA-Preview-Reset")
  public static func PreviewRemoveAllGarment() -> String = GetLocalizedTextByKey(n"VA-Garment-Remove-All")
  public static func PreviewRemovePreviewGarment() -> String = GetLocalizedTextByKey(n"VA-Garment-Remove-Preview")
  public static func PreviewItem() -> String = GetLocalizedTextByKey(n"VA-Preview-Item")
  public static func AddToFavorites() -> String = GetLocalizedTextByKey(n"VA-Favorites-Add")
  public static func RemoveFromFavorites() -> String = GetLocalizedTextByKey(n"VA-Favorites-Remove")
  public static func Zoom() -> String = GetLocalizedTextByKey(n"UI-ResourceExports-OpticalZoom")
  public static func Move() -> String = GetLocalizedTextByKey(n"UI-ScriptExports-Move0")
  public static func ButtonBuy() -> String = "Buy"
  public static func ButtonClear() -> String = "Clear"
  public static func ButtonAddAll() -> String = "Add all"
  public static func ConfirmationAddAll() -> String = "Add all items from this store to cart?"
  public static func ConfirmationRemoveAll() -> String = "Remove all added items from cart?"
  public static func PlayerMoney() -> String = "Player's money"
  public static func Cart() -> String = "Checkout price"
}
