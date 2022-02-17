@addMethod(gameuiCrosshairContainerController)
protected cb func OnPSMCrosshairStateChanged(value: Int32) -> Bool {
  this.UpdateRootVisibility();
}

@replaceMethod(gameuiCrosshairContainerController)
private final func UpdateRootVisibility() -> Void {
  if this.m_isUnarmed {
    this.GetRootWidget().SetVisible(false);
  } else {
    this.GetRootWidget().SetVisible(!this.m_isUnarmed || !this.m_isMounted);
  }
}
