import CustomMarkers.System.*

// Restore persisted mappins after minimap initialized
@wrapMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let container: ref<ScriptableSystemsContainer> = GameInstance.GetScriptableSystemsContainer(this.GetPlayerControlledObject().GetGame());
  let markerSystem: ref<CustomMarkerSystem> = container.Get(n"CustomMarkers.System.CustomMarkerSystem") as CustomMarkerSystem;
  markerSystem.RestorePersistedMappins();
}