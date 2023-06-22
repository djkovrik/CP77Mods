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
  public static func ButtonBuy() -> String =  GetLocalizedTextByKey(n"VA-Cart-Buy")
  public static func Purchase() -> String =  GetLocalizedTextByKey(n"UI-ResourceExports-Buy")
  public static func ButtonClear() -> String = GetLocalizedTextByKey(n"VA-Cart-Clear")
  public static func ButtonAddAll() -> String = GetLocalizedTextByKey(n"VA-Cart-Add-All")
  public static func PlayerMoney() -> String = GetLocalizedTextByKey(n"VA-Cart-Label-V")
  public static func Cart() -> String = GetLocalizedTextByKey(n"VA-Cart-Label-Checkout")
  public static func CartAdd() -> String = GetLocalizedTextByKey(n"VA-Cart-Add")
  public static func CartRemove() -> String = GetLocalizedTextByKey(n"VA-Cart-Remove")
  public static func ConfirmationAddAll() -> String = GetLocalizedTextByKey(n"VA-Cart-Confirm-Add")
  public static func ConfirmationRemoveAll() -> String = GetLocalizedTextByKey(n"VA-Cart-Confirm-Remove")
  public static func ConfirmationPurchase(price: Int32) -> String = s"\(GetLocalizedTextByKey(n"VA-Cart-Confirm-Purchase")) \(price) \(GetLocalizedText("Common-Characters-EuroDollar"))?"
}
