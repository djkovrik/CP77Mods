@addMethod(HubTimeSkipController)
protected cb func SetCustomMenuDispatcher(dispatcher: wref<inkMenuEventDispatcher>) -> Bool {
  this.itsMenuEventDispatcher = dispatcher;
}

@addMethod(HubTimeSkipController)
protected cb func SetPlayerInstance(player: wref<PlayerPuppet>) -> Bool {
  this.itsPlayerInstance = player;
}
