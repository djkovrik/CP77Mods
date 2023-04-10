import MutedMarkersConfig.LootConfig

// Toggle new bb value on scanner state change

@wrapMethod(scannerGameController)
private final func ShowScanner(show: Bool) -> Void {
  wrappedMethod(show);

  let config: ref<LootConfig> = new LootConfig();
  let blackboard: ref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.m_gameInstance);
  let callback: ref<EvaluateMutedMarkersCallback> = new EvaluateMutedMarkersCallback();

  if show {
    blackboard.SetBool(GetAllBlackboardDefs().UI_Scanner.MutedMarkerEnabled, true, true);
  } else {
    callback.blackboard = blackboard;
    delaySystem.CancelCallback(this.hideCallbackId);
    this.hideCallbackId = delaySystem.DelayCallback(callback, config.hideDelay);
  };
}

public class EvaluateMutedMarkersCallback extends DelayCallback {
  let blackboard: wref<IBlackboard>;

  public func Call() -> Void {
    this.blackboard.SetBool(GetAllBlackboardDefs().UI_Scanner.MutedMarkerEnabled, false, true);
  }
}


// Watch for MutedMarkerEnabled value

@wrapMethod(GameplayRoleComponent)
protected final func OnGameAttach() -> Void {
  wrappedMethod();
  this.scannerStateBlackboard = GameInstance.GetBlackboardSystem(this.GetOwner().GetGame()).Get(GetAllBlackboardDefs().UI_Scanner);
  this.scannerStateCallback = this.scannerStateBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.MutedMarkerEnabled, this, n"OnScannerToggled");
}

@wrapMethod(GameplayRoleComponent)
protected final func OnGameDetach() -> Void {
  wrappedMethod();
  this.scannerStateBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.MutedMarkerEnabled, this.scannerStateCallback);
}

@addMethod(GameplayRoleComponent)
protected cb func OnScannerToggled(value: Bool) -> Bool {
  this.isScannerActive = value;
  this.GetOwner().QueueEvent(new EvaluateVisibilitiesEvent());
}
