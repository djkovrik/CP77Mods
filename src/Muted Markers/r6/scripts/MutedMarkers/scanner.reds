import MutedMarkersConfig.LootConfig

@addField(scannerGameController)
private let mm_lootConfig: ref<LootConfig>;

@wrapMethod(scannerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.mm_lootConfig = new LootConfig();
}

@wrapMethod(scannerGameController)
private final func ShowScanner(show: Bool) -> Void {
  wrappedMethod(show);

  let bb: ref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
  let delay: Float = this.mm_lootConfig.hideDelay;
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.m_gameInstance);
  let callback: ref<EvaluateMutedMarkersCallback> = new EvaluateMutedMarkersCallback();

  if show {
    bb.SetBool(GetAllBlackboardDefs().UI_Scanner.IsEnabled_mm, true, true);
  } else {
    callback.blackboard = bb;
    delaySystem.CancelCallback(this.mutedMarkersCallback);
    this.mutedMarkersCallback = delaySystem.DelayCallback(callback, delay);
  };
}


// Watch for scanner state

@wrapMethod(GameplayRoleComponent)
protected final func OnGameAttach() -> Void {
  wrappedMethod();
  this.scannerBlackboard_mm = GameInstance.GetBlackboardSystem(this.GetOwner().GetGame()).Get(GetAllBlackboardDefs().UI_Scanner);
  this.scannerCallback_mm = this.scannerBlackboard_mm.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.IsEnabled_mm, this, n"OnScannerToggled");
}

@wrapMethod(GameplayRoleComponent)
protected final func OnGameDetach() -> Void {
  wrappedMethod();
  this.scannerBlackboard_mm.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.IsEnabled_mm, this.scannerCallback_mm);
}

@addMethod(GameplayRoleComponent)
protected cb func OnScannerToggled(value: Bool) -> Bool {
  this.isScannerActive_mm = value;
  this.EvaluateVisibilityMM();
}
