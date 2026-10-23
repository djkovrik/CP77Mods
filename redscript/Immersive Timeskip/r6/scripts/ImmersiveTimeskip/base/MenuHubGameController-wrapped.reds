@wrapMethod(MenuHubGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.m_timeCtrl.SetCustomMenuDispatcher(this.m_menuEventDispatcher);
  this.m_timeCtrl.SetPlayerInstance(this.m_player);
}
