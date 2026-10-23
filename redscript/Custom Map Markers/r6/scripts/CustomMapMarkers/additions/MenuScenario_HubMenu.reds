// Double call to navigate map -> hub_menu -> back to game
@addMethod(MenuScenario_HubMenu)
protected cb func OnNewMarkerAdded() -> Bool {
  this.GotoIdleState();
  this.GotoIdleState();
}
