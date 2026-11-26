module CombatAwareness

class ScannerObservation extends DelayCallback {
  public let hud: wref<scannerDetailsGameController>;
  public func Call() -> Void {
    if IsDefined(this.hud) { 
      this.hud.CAObserve(); 
    };
  }
}
