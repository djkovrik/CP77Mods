import CustomMarkers.Config.CustomMarkersConfig

public static func CMM(str: String) -> Void {
  if !CustomMarkersConfig.DisableLogsCET() {
    LogChannel(n"DEBUG", s"Custom Map Markers: \(str)");
  };
}
