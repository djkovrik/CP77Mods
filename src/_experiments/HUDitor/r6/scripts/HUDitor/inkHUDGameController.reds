import HUDrag.HUDWidgetsManager.*

@addField(inkHUDGameController)
let cursor: ref<inkImage>;

@addField(inkHUDGameController)
let isShiftDown: Bool;

@addMethod(inkHUDGameController)
protected cb func OnInitialize() -> Bool {
  if (this.IsA(n"gameuiDamageIndicatorGameController")) {
    let player: ref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;

    HUDWidgetsManager.CreateInstance(player, this);
    this.AddCursor();
  }
}

// Used in Lua
@addMethod(inkHUDGameController)
private func PersistHUDWidgetsState() -> Void {}

@addMethod(inkHUDGameController)
private func AddCursor() {
  this.cursor = new inkImage();
  this.cursor.SetAtlasResource(r"base\\gameplay\\gui\\widgets\\cursors\\cursor_inventory.inkatlas");
  this.cursor.SetTexturePart(n"mouse_frame");
  this.cursor.SetHAlign(inkEHorizontalAlign.Center);
  this.cursor.SetVAlign(inkEVerticalAlign.Center);
  this.cursor.SetAnchorPoint(new Vector2(0.5, 0.5));
  this.cursor.SetFitToContent(true);
  this.cursor.SetSizeRule(inkESizeRule.Fixed);
  this.cursor.SetVisible(false);
  this.cursor.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
  this.cursor.Reparent(this.GetRootCompoundWidget());
}

@addMethod(inkHUDGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let currentInput: Float;
  let actionName = ListenerAction.GetName(action);

  let isActive = HUDWidgetsManager.GetInstance().isActive;

  if (isActive) {
    if Equals(actionName, n"CameraMouseX") {
      currentInput = ListenerAction.GetValue(action);

      this.cursor.ChangeTranslation(new Vector2(currentInput, 0));
    };

    if Equals(actionName, n"CameraMouseY") {
      currentInput = ListenerAction.GetValue(action);
      
      this.cursor.ChangeTranslation(new Vector2(0, -currentInput));
    };
  }

  if Equals(actionName, n"click") {
    if (ListenerAction.IsButtonJustPressed(action)) {
      this.cursor.SetTexturePart(n"mouse_fill");
    }

    if (ListenerAction.IsButtonJustReleased(action)) {
      this.cursor.SetTexturePart(n"mouse_frame");
    }
  }

  if Equals(actionName, n"ToggleSprint") {
    if (ListenerAction.IsButtonJustPressed(action)) {
      this.isShiftDown = true;
    }

    if (ListenerAction.IsButtonJustReleased(action)) {
      this.isShiftDown = false;
    }
  }

  if ListenerAction.IsButtonJustPressed(action) {
    if Equals(actionName, n"right_button") && isActive {
      let nextActiveWidget = HUDWidgetsManager.GetNextWidget(HUDWidgetsManager.GetInstance().activeWidget);
      
      HUDWidgetsManager.GetInstance().activeWidget = nextActiveWidget;

      let enableHUDEditorEvent = new SetActiveHUDEditorWidget();
      enableHUDEditorEvent.activeWidget = nextActiveWidget;

      this.QueueEvent(enableHUDEditorEvent);
    }

    if Equals(actionName, n"left_button") && isActive {
      let previousActiveWidget = HUDWidgetsManager.GetPreviousWidget(HUDWidgetsManager.GetInstance().activeWidget);
      
      HUDWidgetsManager.GetInstance().activeWidget = previousActiveWidget;

      let enableHUDEditorEvent = new SetActiveHUDEditorWidget();
      enableHUDEditorEvent.activeWidget = previousActiveWidget;

      this.QueueEvent(enableHUDEditorEvent);
    }

    if isActive {
      if Equals(actionName, n"world_map_filter_navigation_down") {
        let resetEvent = new ResetAllHUDWidgets();

        this.QueueEvent(resetEvent);
      }

      if Equals(actionName, n"cancel") || Equals(actionName, n"back") {
        HUDWidgetsManager.GetInstance().isActive = false;

        this.QueueEvent(new DisableHUDEditor());
        this.GetSystemRequestsHandler().UnpauseGame();

        this.cursor.SetVisible(false);
        this.PersistHUDWidgetsState();
      }
    }

    if this.isShiftDown {
      if Equals(actionName, n"world_map_menu_cycle_filter_prev") {
        let playerPuppet = this.GetPlayerControlledObject() as PlayerPuppet;
        
        if !isActive {
          this.GetSystemRequestsHandler().PauseGame();
          let enableHUDEditorEvent = new SetActiveHUDEditorWidget();
          enableHUDEditorEvent.activeWidget = n"TopRight";
          HUDWidgetsManager.GetInstance().isActive = true;
          HUDWidgetsManager.GetInstance().activeWidget = n"TopRight";
          
          this.QueueEvent(enableHUDEditorEvent);

          this.cursor.SetVisible(true);
        } else {
          HUDWidgetsManager.GetInstance().isActive = false;

          this.QueueEvent(new DisableHUDEditor());
          this.GetSystemRequestsHandler().UnpauseGame();

          this.cursor.SetVisible(false);
          this.PersistHUDWidgetsState();
        }
      }
    }
  }
}
