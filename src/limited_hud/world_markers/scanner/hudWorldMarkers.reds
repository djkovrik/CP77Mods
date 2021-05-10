///////////////////////////////////////////////
// Show world mappins when scanner is active //
///////////////////////////////////////////////

@addField(WorldMappinsContainerController)
public let m_scannerTrackingBlackboard: ref<IBlackboard>;

@addField(WorldMappinsContainerController)
public let m_scannerTrackingCallback: Uint32;

@addMethod(WorldMappinsContainerController)
public func OnScannerStateChanged(value: Bool) -> Void {
  this.GetRootWidget().SetVisible(value);
}

@addMethod(WorldMappinsContainerController)
public func DetermineCurrentVisibility() -> Void {
  let scannerEnabled: Bool = this.m_scannerTrackingBlackboard.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  this.GetRootWidget().SetVisible(scannerEnabled);
}

@addMethod(WorldMappinsContainerController)
protected cb func OnInitialize() -> Bool {
  this.m_scannerTrackingBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
  this.m_scannerTrackingCallback = this.m_scannerTrackingBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnScannerStateChanged"); 
  this.DetermineCurrentVisibility();
}

@addMethod(WorldMappinsContainerController)
protected cb func OnUnitialize() -> Bool {
  this.m_scannerTrackingBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback);
}
