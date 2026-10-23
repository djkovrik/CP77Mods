import CustomMarkers.System.*

// Restore persisted mappins after minimap initialized
@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let player: wref<GameObject> = this.GetPlayerControlledObject();
  if !IsDefined(player) {
    return false;
  };

  let container: ref<ScriptableSystemsContainer> = GameInstance.GetScriptableSystemsContainer(player.GetGame());
  if !IsDefined(container) {
    return false;
  };

  let markerSystem: ref<CustomMarkerSystem> = container.Get(n"CustomMarkers.System.CustomMarkerSystem") as CustomMarkerSystem;
  if IsDefined(markerSystem) {
    markerSystem.RestorePersistedMappins();
  };
}
