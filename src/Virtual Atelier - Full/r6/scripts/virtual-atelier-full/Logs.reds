module VirtualAtelier.Logs
import VendorPreview.Config.VirtualAtelierConfig

public static func AtelierLog(str: String) -> Void {
  // LogChannel(n"DEBUG", s"Atelier: \(str)");
}

public static func AtelierDebug(str: String, config: ref<VirtualAtelierConfig>) -> Void {
  if config.showDebugLogs {
    // LogChannel(n"DEBUG", s"Atelier DEBUG: \(str)");
  };
}
