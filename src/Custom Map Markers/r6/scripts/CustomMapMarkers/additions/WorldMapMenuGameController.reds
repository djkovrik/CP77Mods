import CustomMarkers.System.*
import CustomMarkers.Common.*
import CustomMarkers.UI.*

@addField(WorldMapMenuGameController)
protected let m_customMarkerSystem: ref<CustomMarkerSystem>;

@addField(WorldMapMenuGameController)
protected let m_cycleMappinPosition: Int32;

@addField(WorldMapMenuGameController)
protected let m_suppressCustomMarkerPopup: Bool;

@addField(WorldMapMenuGameController)
protected let m_customMarkerMapInputActive: Bool;

@wrapMethod(WorldMapMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let container: ref<ScriptableSystemsContainer>;
  if IsDefined(this.m_player) {
    container = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame());
    if IsDefined(container) {
      this.m_customMarkerSystem = container.Get(n"CustomMarkers.System.CustomMarkerSystem") as CustomMarkerSystem;
    };
  };
  this.m_cycleMappinPosition = 0;
  this.m_suppressCustomMarkerPopup = false;
  this.m_customMarkerMapInputActive = false;
}

@wrapMethod(WorldMapMenuGameController)
protected cb func OnUninitialize() -> Bool {
  this.m_customMarkerMapInputActive = false;
  wrappedMethod();
}

@wrapMethod(WorldMapMenuGameController)
protected cb func OnEntityAttached() -> Bool {
  wrappedMethod();
  this.m_customMarkerMapInputActive = true;
}

@wrapMethod(WorldMapMenuGameController)
protected cb func OnEntityDetached() -> Bool {
  this.m_customMarkerMapInputActive = false;
  wrappedMethod();
}

// Catch marker creation requests
@addMethod(WorldMapMenuGameController)
protected cb func OnRequestMarkerCreationEvent(evt: ref<RequestMarkerCreationEvent>) -> Bool {
  if !IsDefined(evt) || !IsDefined(this.m_customMarkerSystem) {
    return false;
  };

  this.m_customMarkerSystem.AddCustomMappin(GetLocalizedTextByKey(n"CustomMarkers-MarkerTitle"), evt.m_description, evt.m_texturePart, true);
  if IsDefined(this.m_menuEventDispatcher) {
    this.m_menuEventDispatcher.SpawnEvent(n"OnNewMarkerAdded");
  };
}

// Move-to-player hotkey now cycles custom mappins as well
@addMethod(WorldMapMenuGameController)
private func CycleBetweenMappins() -> Void {
  if !IsDefined(this.m_customMarkerSystem) {
    return ;
  };

  let customMappins: array<ref<CustomMappinData>> = this.m_customMarkerSystem.GetCustomMappins();
  let customMappinPosition: Vector4;
  let movePosition: Vector3;
  if this.m_cycleMappinPosition + 1 <= ArraySize(customMappins) {
    if !IsDefined(customMappins[this.m_cycleMappinPosition]) {
      this.m_cycleMappinPosition = this.m_cycleMappinPosition + 1;
      return ;
    };

    customMappinPosition = customMappins[this.m_cycleMappinPosition].position;
    movePosition = Vector3(customMappinPosition.X, customMappinPosition.Y, customMappinPosition.Z);
    if IsDefined(this.GetEntityPreview()) {
      this.GetEntityPreview().MoveTo(movePosition);
    };
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
    if ArraySize(this.m_mappinsPositions) > 0 && IsDefined(this.GetEntityPreview()) {
      this.GetEntityPreview().MoveTo(this.m_mappinsPositions[0]);
    };
  };
}

@addMethod(WorldMapMenuGameController)
private func CanOpenCustomMarkerPopup(e: ref<inkPointerEvent>, targetWidget: wref<inkWidget>, targetMappinController: ref<BaseWorldMapMappinController>) -> Bool {
  if !IsDefined(e) || e.IsHandled() || e.IsConsumed() {
    return false;
  };

  if !this.IsCustomMarkerMapInputActive() {
    return false;
  };

  if !IsDefined(this.m_player) || !IsDefined(this.m_customMarkerSystem) {
    return false;
  };

  if this.HasSelectedMappin() || !this.m_player.PlayerLastUsedKBM() || IsDefined(targetMappinController) {
    return false;
  };

  return true;
}

@addMethod(WorldMapMenuGameController)
private func IsCustomMarkerMapInputActive() -> Bool {
  if !this.m_customMarkerMapInputActive {
    return false;
  };

  if !this.IsEntityAttachedAndSetup() {
    return false;
  };

  if !IsDefined(this.GetRootWidget()) || !this.GetRootWidget().IsVisible() {
    return false;
  };

  return true;
}

// Attach to mouse middle button clicks
@replaceMethod(WorldMapMenuGameController)
private final func HandlePressInput(e: ref<inkPointerEvent>) -> Void {
  let customMappin: ref<IMappin>;
  let customMappinData: ref<GameplayRoleMappinData>;
  let customMappinPosition: Vector4;
  let targetWidget: wref<inkWidget>;
  let targetMappinController: ref<BaseWorldMapMappinController>;
  if !IsDefined(e) {
    return ;
  };

  if e.IsAction(n"world_map_menu_track_waypoint") {
    this.m_pressedRMB = true;
    this.TryTrackQuestOrSetWaypoint();
  } else {
    if e.IsAction(n"world_map_menu_jump_to_player") {
      if !this.m_justOpenedQuestJournal {
        // Cycle through mappins list instead of just moving to player
        this.CycleBetweenMappins();
        // this.PlaySound(n"Button", n"OnPress");
        // if (this.selectedMappin as WorldMapPlayerMappinController) == null {
        //   this.MoveToPlayer();
        // } else {
        //   if ArraySize(this.m_mappinsPositions) > 0 {
        //     this.GetEntityPreview().MoveTo(this.m_mappinsPositions[0]);
        //   };
        // };
      };
    } else {
      if e.IsAction(n"world_map_menu_zoom_to_mappin") {
        targetWidget = e.GetTarget();
        if IsDefined(targetWidget) {
          targetMappinController = targetWidget.GetController() as BaseWorldMapMappinController;
        };
        // Default logic
        if this.HasSelectedMappin() && this.CanZoomToMappin(this.selectedMappin) {
          this.PlaySound(n"Button", n"OnPress");
          this.ZoomToMappin(this.selectedMappin);
        };
        // Open popup when clicked on free space
        if this.CanOpenCustomMarkerPopup(e, targetWidget, targetMappinController) {
          if this.m_suppressCustomMarkerPopup {
            this.m_suppressCustomMarkerPopup = false;
            e.Handle();
            e.Consume();
          } else {
            this.PlaySound(n"Button", n"OnPress");
            CustomMarkerPopup.Show(this, this.m_player);
            e.Handle();
            e.Consume();
          };
        } else {
          if this.HasSelectedMappin() {
            // Delete mappin if clicked on custom
            customMappin = this.selectedMappin.GetMappin();
            if IsDefined(customMappin) {
              customMappinData = customMappin.GetScriptData() as GameplayRoleMappinData;
            };
            if IsDefined(customMappinData) && customMappinData.m_isMappinCustom {
              customMappinPosition = customMappin.GetWorldPosition();
              this.m_suppressCustomMarkerPopup = true;
              this.SetSelectedMappin(null);
              if IsDefined(this.m_customMarkerSystem) {
                this.m_customMarkerSystem.DeleteCustomMappin(customMappinPosition);
              };
              this.PlaySound(n"MapPin", n"OnDelete");
              e.Consume();
            };
          };
        };
      } else {
        if e.IsAction(n"world_map_menu_zoom_in_mouse") {
          this.ZoomWithMouse(true);
          if !this.m_isZooming {
            this.m_audioSystem.Play(n"ui_zooming_in_step_change");
            this.m_isZooming = true;
          };
        } else {
          if e.IsAction(n"world_map_menu_zoom_out_mouse") {
            this.ZoomWithMouse(false);
            if !this.m_isZooming {
              this.m_audioSystem.Play(n"ui_zooming_in_exit");
              this.m_isZooming = true;
            };
          } else {
            if e.IsAction(n"world_map_menu_fast_travel") && this.HasSelectedMappin() && (Equals(this.selectedMappin.GetMappinVariant(), gamedataMappinVariant.FastTravelVariant) || Equals(this.selectedMappin.GetMappinVariant(), gamedataMappinVariant.Zzz17_NCARTVariant)) && this.IsFastTravelEnabled() {
              this.m_audioSystem.Play(n"ui_menu_item_crafting_start");
              this.PrepFastTravel();
              SetFactValue(this.GetOwner().GetGame(), n"ue_metro_map_ui_ft_clicked", 1);
              this.m_startedFastTraveling = true;
              this.m_isPanning = true;
            };
          };
        };
      };
    };
  };
  if e.IsAction(n"world_map_menu_move_mouse") && !this.m_isHoveringOverFilters && !this.m_isPanning {
    this.SetMousePanEnabled(true);
    this.SetCursorContext(n"Pan");
    this.m_audioSystem.Play(n"ui_menu_scrolling_start");
    this.m_isPanning = true;
  };
}

// Disable click-to-zoom for custom mappins
@wrapMethod(WorldMapMenuGameController)
public final func CanZoomToMappin(controller: wref<BaseWorldMapMappinController>) -> Bool {
  let mappin: ref<IMappin>;
  let mappinData: ref<GameplayRoleMappinData>;
  if IsDefined(controller) {
    mappin = controller.GetMappin();
  };
  if IsDefined(mappin) {
    mappinData = mappin.GetScriptData() as GameplayRoleMappinData;
  };
  if IsDefined(mappinData) && mappinData.m_isMappinCustom {
    return false;
  };

  return wrappedMethod(controller);
}
