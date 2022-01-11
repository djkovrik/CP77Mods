import CustomMarkers.Config.*
import CustomMarkers.Core.*
import CustomMarkers.UI.*

@addMethod(WorldMapMenuGameController)
protected cb func OnRequestMarkerCreationEvent(evt: ref<RequestMarkerCreationEvent>) -> Bool {
  this.m_player.AddCustomMappin(CustomMarkersConfig.Title(), evt.m_description, evt.m_texturePart);
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
        this.m_player.DeleteCustomMappin(mappin.GetWorldPosition());
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
