@addMethod(HubTimeSkipController)
public cb func SetCustomMenuDispatcher(dispatcher: wref<inkMenuEventDispatcher>) -> Bool {
  this.itsMenuEventDispatcher = dispatcher;
}

@addMethod(HubTimeSkipController)
public cb func SetPlayerInstance(player: wref<PlayerPuppet>) -> Bool {
  this.itsPlayerInstance = player;
}
