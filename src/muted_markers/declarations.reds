public class ScannerStateChangedEvent extends Event {
  public let isEnabled: Bool;
}

enum MarkerVisibility { 
  ThroughWalls = 0, 
  Default = 1, 
  Scanner = 2, 
  Hidden = 3, 
}
