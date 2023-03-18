import Codeware.Localization.*
import CustomMarkers.System.*
import CustomMarkers.Common.*
import CustomMarkers.UI.*

@addField(WorldMapMenuGameController)
protected let m_customMarkerSystem: ref<CustomMarkerSystem>;

@addField(WorldMapMenuGameController)
protected let m_translator: ref<LocalizationSystem>;

@addField(WorldMapMenuGameController)
protected let m_cycleMappinPosition: Int32;

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let container: ref<ScriptableSystemsContainer> = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame());
  this.m_customMarkerSystem = container.Get(n"CustomMarkers.System.CustomMarkerSystem") as CustomMarkerSystem;
  this.m_translator = LocalizationSystem.GetInstance(this.m_player.GetGame());
  this.m_cycleMappinPosition = 0;
}

// Catch marker creation requests
@addMethod(WorldMapMenuGameController)
protected cb func OnRequestMarkerCreationEvent(evt: ref<RequestMarkerCreationEvent>) -> Bool {
  this.m_customMarkerSystem.AddCustomMappin(this.m_translator.GetText("CustomMarkers-MarkerTitle"), evt.m_description, evt.m_texturePart, true);
  this.m_menuEventDispatcher.SpawnEvent(n"OnNewMarkerAdded");
}

// Move-to-player hotkey now cycles custom mappins as well
@addMethod(WorldMapMenuGameController)
private func CycleBetweenMappins() -> Void {
  let customMappins: array<ref<CustomMappinData>> = this.m_customMarkerSystem.GetCustomMappins();
  let customMappinPosition: Vector4;
  let movePosition: Vector3;
  if this.m_cycleMappinPosition + 1 <= ArraySize(customMappins) {
    customMappinPosition = customMappins[this.m_cycleMappinPosition].position;
    movePosition = new Vector3(customMappinPosition.X, customMappinPosition.Y, customMappinPosition.Z);
    this.GetEntityPreview().MoveTo(movePosition);
    this.m_cycleMappinPosition = this.m_cycleMappinPosition + 1;
  } else {
    this.m_cycleMappinPosition = 0;
    this.MoveFromCustomToPlayer();
  };
}

@addMethod(WorldMapMenuGameController)
private func MoveFromCustomToPlayer() -> Void {
  if (this.selectedMappin as WorldMapPlayerMappinController) == null {
    this.MoveToPlayer();
  } else {
    if ArraySize(this.m_mappinsPositions) > 0 {
      this.GetEntityPreview().MoveTo(this.m_mappinsPositions[0]);
    };
  };
}

// Attach to mouse middle button clicks
@replaceMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  let customMappin: ref<IMappin>;
  let customMappinData: ref<GameplayRoleMappinData>;
  if e.IsAction(n"world_map_menu_track_waypoint") {
    this.TryTrackQuestOrSetWaypoint();
  } else {
    if e.IsAction(n"world_map_menu_jump_to_player") {
      if !this.m_justOpenedQuestJournal {
        this.PlaySound(n"Button", n"OnPress");
        // Cycle through mappins list instead of just moving to player
        this.CycleBetweenMappins();
        // if (this.selectedMappin as WorldMapPlayerMappinController) == null {
        //   this.MoveToPlayer();
        // } else {
        //   if ArraySize(this.m_mappinsPositions) > 0 {
        //     this.GetEntityPreview().MoveTo(this.m_mappinsPositions[0]);
        //   };
        // };
      };
    } else {
      if e.IsAction(n"world_map_menu_open_quest") {
        this.PlaySound(n"Button", n"OnPress");
        this.OpenSelectedQuest();
      } else {
        if e.IsAction(n"world_map_menu_zoom_to_mappin") {
          // Default logic
          if this.HasSelectedMappin() && this.CanZoomToMappin(this.selectedMappin) {
            this.PlaySound(n"Button", n"OnPress");
            this.ZoomToMappin(this.selectedMappin);
          };
          // Open popup when clicked on free space
          if !this.HasSelectedMappin() {
            this.PlaySound(n"Button", n"OnPress");
            CustomMarkerPopup.Show(this, this.m_player);
          } else {
            // Delete mappin if clicked on custom
            customMappin = this.selectedMappin.GetMappin();
            customMappinData = customMappin.GetScriptData() as GameplayRoleMappinData;
            if IsDefined(customMappinData) && customMappinData.m_isMappinCustom {
              this.m_customMarkerSystem.DeleteCustomMappin(customMappin.GetWorldPosition());
              this.PlaySound(n"MapPin", n"OnDelete");
            };
          };
        } else {
          if e.IsAction(n"world_map_menu_zoom_in_mouse") {
            this.ZoomWithMouse(true);
          } else {
            if e.IsAction(n"world_map_menu_zoom_out_mouse") {
              this.ZoomWithMouse(false);
            };
          };
        };
      };
    };
  };
  if e.IsAction(n"world_map_menu_move_mouse") {
    this.SetMousePanEnabled(true);
  };
}

// Disable click-to-zoom for custom mappins
@wrapMethod(WorldMapMenuGameController)
public final func CanZoomToMappin(controller: wref<BaseWorldMapMappinController>) -> Bool {
  let mappinData: ref<GameplayRoleMappinData> = this.selectedMappin.GetMappin().GetScriptData() as GameplayRoleMappinData;
  if IsDefined(mappinData) && mappinData.m_isMappinCustom {
    return false;
  };

  return wrappedMethod(controller);
}
