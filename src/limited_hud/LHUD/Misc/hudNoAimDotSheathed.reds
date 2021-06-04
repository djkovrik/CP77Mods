@replaceMethod(gameuiCrosshairContainerController)
protected cb func OnPSMCrosshairStateChanged(value: Int32) -> Bool {
  let newState: gamePSMCrosshairStates = IntEnum(value);
  inkWidgetRef.SetVisible(this.m_sprintWidget, NotEquals(newState, gamePSMCrosshairStates.Aim) && NotEquals(newState, gamePSMCrosshairStates.Scanning) && NotEquals(newState, gamePSMCrosshairStates.LeftHandCyberware) && NotEquals(newState, gamePSMCrosshairStates.QuickHack));
  this.GetRootWidget().SetVisible(!this.m_isUnarmed);
}
