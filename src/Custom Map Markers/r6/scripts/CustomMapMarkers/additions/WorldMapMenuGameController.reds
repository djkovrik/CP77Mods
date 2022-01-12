import Codeware.Localization.*
import CustomMarkers.System.*
import CustomMarkers.Common.*
import CustomMarkers.UI.*

@addField(WorldMapMenuGameController)
protected let m_customMarkerSystem: ref<CustomMarkerSystem>;

@addField(WorldMapMenuGameController)
protected let m_translator: ref<LocalizationSystem>;

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let container: ref<ScriptableSystemsContainer> = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame());
  this.m_customMarkerSystem = container.Get(n"CustomMarkers.System.CustomMarkerSystem") as CustomMarkerSystem; // Don't forget the namespace if you're using modules
  this.m_translator = LocalizationSystem.GetInstance(this.m_player.GetGame());
  this.m_customMarkerSystem.RestorePersistedMappins();
}

// Catch marker creation events
@addMethod(WorldMapMenuGameController)
protected cb func OnRequestMarkerCreationEvent(evt: ref<RequestMarkerCreationEvent>) -> Bool {
   this.m_customMarkerSystem.AddCustomMappin(this.m_translator.GetText("CustomMarkers-MarkerTitle"), evt.m_description, evt.m_texturePart, true);
  // TODO does not actually return to game
  this.m_menuEventDispatcher.SpawnEvent(n"OnCloseHubMenu");
}

@wrapMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  wrappedMethod(e);

  let mappin: wref<IMappin>;
  let mappinData: ref<GameplayRoleMappinData>;

  if e.IsAction(n"world_map_menu_zoom_to_mappin") {
    // Open popup when clicked on free space
    if !this.HasSelectedMappin() {
      this.PlaySound(n"Button", n"OnPress");
      CustomMarkerPopup.Show(this, this.m_player);
    } else {
      // Delete mappin if clicked on custom
      mappin = this.selectedMappin.GetMappin();
      mappinData = mappin.GetScriptData() as GameplayRoleMappinData;
      if IsDefined(mappinData) && mappinData.m_isMappinCustom {
        this.m_customMarkerSystem.DeleteCustomMappin(mappin.GetWorldPosition());
        this.PlaySound(n"MapPin", n"OnDelete");
      };
    };
  };
}

// Disable click to zoom for custom mappins
@replaceMethod(WorldMapMenuGameController)
public final func CanZoomToMappin(controller: wref<BaseWorldMapMappinController>) -> Bool {
  let mappinData: ref<GameplayRoleMappinData> = this.selectedMappin.GetMappin().GetScriptData() as GameplayRoleMappinData;
  if IsDefined(mappinData) {
    return this.isZoomToMappinEnabled && !mappinData.m_isMappinCustom;
  } else {
    return this.isZoomToMappinEnabled;
  };
}
