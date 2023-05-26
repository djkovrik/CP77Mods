module VendorPreview.Config

public class VirtualAtelierConfig {
  public static func DisableDuplicatesChecker() -> Bool = true
  public static func DisableDangerZoneChecker() -> Bool = false
}

public class VirtualAtelierInternals {
  public static func NumOfVirtualStoresPerRow() -> Int32 = 5
  public static func NumOfRowsTotal() -> Int32  = 2
  public static func StoresPerPage() -> Int32 = VirtualAtelierInternals.NumOfVirtualStoresPerRow() * VirtualAtelierInternals.NumOfRowsTotal()
}
