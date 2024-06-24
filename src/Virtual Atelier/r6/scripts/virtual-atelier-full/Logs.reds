module VirtualAtelier.Logs
import VendorPreview.Config.VirtualAtelierConfig

public static func AtelierLog(str: String) -> Void {
  ModLog(n"Atelier", str);
}

public static func AtelierDebug(str: String) -> Void {
  // ModLog(n"AtelierDebug", str);
}
