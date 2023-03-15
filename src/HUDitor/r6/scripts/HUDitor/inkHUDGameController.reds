import HUDrag.HUDWidgetsManager.*

public class HUDitorInputListener {
  let systemRequestsHandler: wref<inkISystemRequestsHandler>;
  let uiSystem: wref<UISystem>;
  let cursor: ref<inkImage>;
  let isShiftDown: Bool;
  let compatMode: HUDitorCompatMode = HUDitorCompatMode.Default;

  public func Initialize(parent: ref<inkHUDGameController>) {
    let player: ref<PlayerPuppet> = parent.GetPlayerControlledObject() as PlayerPuppet;
    this.uiSystem = GameInstance.GetUISystem(player.GetGame());
    this.systemRequestsHandler = parent.GetSystemRequestsHandler();
    this.AddCursor(parent.GetRootCompoundWidget());
  }

  public func SetCompatMode(mode: HUDitorCompatMode) -> Void {
    this.compatMode = mode;
    LogChannel(n"DEBUG", s"HUDitor compat mode: \(this.compatMode)");
  }

  private func AddCursor(root: ref<inkCompoundWidget>) {
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
    this.cursor.Reparent(root);
    this.cursor.ChangeTranslation(new Vector2(600.0, 600.0));
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let currentInput: Float;
    let actionName = ListenerAction.GetName(action);

    let isActive = HUDWidgetsManager.GetInstance().isActive;

    if (isActive) {
      if Equals(actionName, n"CameraMouseX") {
        currentInput = ListenerAction.GetValue(action);
        this.cursor.ChangeTranslation(new Vector2(currentInput, 0.0));
      };

      if Equals(actionName, n"CameraMouseY") {
        currentInput = ListenerAction.GetValue(action);
        this.cursor.ChangeTranslation(new Vector2(0.0, -currentInput));
      };
    };

    if Equals(actionName, n"click") {
      if (ListenerAction.IsButtonJustPressed(action)) {
        this.cursor.SetTexturePart(n"mouse_fill");
      };

      if (ListenerAction.IsButtonJustReleased(action)) {
        this.cursor.SetTexturePart(n"mouse_frame");
      };
    };

    if Equals(actionName, n"ToggleSprint") {
      if (ListenerAction.IsButtonJustPressed(action)) {
        this.isShiftDown = true;
      };

      if (ListenerAction.IsButtonJustReleased(action)) {
        this.isShiftDown = false;
      };
    };

    if ListenerAction.IsButtonJustPressed(action) {
      if Equals(actionName, n"right_button") && isActive {
        let nextActiveWidget: CName;
        switch this.compatMode {
          case HUDitorCompatMode.E3CompassFaithful: 
            nextActiveWidget = HUDWidgetsManager.GetNextWidgetCompassFaithful(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          case HUDitorCompatMode.E3CompassFaithfulE3HUD: 
            nextActiveWidget = HUDWidgetsManager.GetNextWidgetCompassFaithful(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          case HUDitorCompatMode.E3CompassMinimap: 
            nextActiveWidget = HUDWidgetsManager.GetNextWidgetCompassMinimap(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          case HUDitorCompatMode.E3CompassMinimapE3HUD: 
            nextActiveWidget = HUDWidgetsManager.GetNextWidgetCompassMinimap(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          default: 
            nextActiveWidget = HUDWidgetsManager.GetNextWidgetDefault(HUDWidgetsManager.GetInstance().activeWidget);
            break;
        };
        
        HUDWidgetsManager.GetInstance().activeWidget = nextActiveWidget;
        let enableHUDEditorEvent = new SetActiveHUDEditorWidget();
        enableHUDEditorEvent.activeWidget = nextActiveWidget;
        this.uiSystem.QueueEvent(enableHUDEditorEvent);
      };

      if Equals(actionName, n"left_button") && isActive {
        let previousActiveWidget: CName;
        switch this.compatMode {
          case HUDitorCompatMode.E3CompassFaithful: 
            previousActiveWidget = HUDWidgetsManager.GetPreviousWidgetCompassFaithful(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          case HUDitorCompatMode.E3CompassFaithfulE3HUD: 
            previousActiveWidget = HUDWidgetsManager.GetPreviousWidgetCompassFaithful(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          case HUDitorCompatMode.E3CompassMinimap: 
            previousActiveWidget = HUDWidgetsManager.GetPreviousWidgetCompassMinimap(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          case HUDitorCompatMode.E3CompassMinimapE3HUD: 
            previousActiveWidget = HUDWidgetsManager.GetPreviousWidgetCompassMinimap(HUDWidgetsManager.GetInstance().activeWidget);
            break;
          default: 
            previousActiveWidget = HUDWidgetsManager.GetPreviousWidgetDefault(HUDWidgetsManager.GetInstance().activeWidget);
            break;
        };
        
        HUDWidgetsManager.GetInstance().activeWidget = previousActiveWidget;
        let enableHUDEditorEvent = new SetActiveHUDEditorWidget();
        enableHUDEditorEvent.activeWidget = previousActiveWidget;
        this.uiSystem.QueueEvent(enableHUDEditorEvent);
      };

      if isActive {
        if Equals(actionName, n"world_map_filter_navigation_down") {
          let resetEvent = new ResetAllHUDWidgets();
          this.uiSystem.QueueEvent(resetEvent);
        };

        if Equals(actionName, n"cancel") || Equals(actionName, n"back") {
          HUDWidgetsManager.GetInstance().isActive = false;

          this.uiSystem.QueueEvent(new HidePreviewEvent());
          this.uiSystem.QueueEvent(new DisableHUDEditor());
          this.systemRequestsHandler.UnpauseGame();

          this.cursor.SetVisible(false);
          this.PersistHUDWidgetsState();
        };
      };

      if this.isShiftDown || Equals(actionName, n"HUDitor_Editor") {
        if Equals(actionName, n"UI_Unequip") || Equals(actionName, n"HUDitor_Editor")  {
          if !isActive {
            this.systemRequestsHandler.PauseGame();
            let enableHUDEditorEvent = new SetActiveHUDEditorWidget();
            enableHUDEditorEvent.activeWidget = n"NewTracker";
            HUDWidgetsManager.GetInstance().isActive = true;
            HUDWidgetsManager.GetInstance().activeWidget = n"NewTracker";

            this.uiSystem.QueueEvent(new DisplayPreviewEvent());
            this.uiSystem.QueueEvent(enableHUDEditorEvent);

            this.cursor.SetVisible(true);
          } else {
            HUDWidgetsManager.GetInstance().isActive = false;

            this.uiSystem.QueueEvent(new HidePreviewEvent());
            this.uiSystem.QueueEvent(new DisableHUDEditor());
            this.systemRequestsHandler.UnpauseGame();

            this.cursor.SetVisible(false);
            this.PersistHUDWidgetsState();
          };
        };
      };
    };
  }

  // Used in Lua
  private func PersistHUDWidgetsState() -> Void {}
}

@addField(inkHUDGameController)
private let huditorListener: ref<HUDitorInputListener>;

@addMethod(inkHUDGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  if (this.IsA(n"gameuiWorldMappinsContainerController")) {
    let player: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
    HUDWidgetsManager.CreateInstance(player, this);
    this.huditorListener = new HUDitorInputListener();
    this.huditorListener.Initialize(this);
    player.RegisterInputListener(this.huditorListener);
  }
}

@addMethod(inkHUDGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  if (this.IsA(n"gameuiWorldMappinsContainerController")) {
    let player: ref<PlayerPuppet> = playerPuppet as PlayerPuppet;
    player.UnregisterInputListener(this.huditorListener);
    this.huditorListener = null;
  }
}

@addMethod(inkHUDGameController)
protected cb func OnCompatModeChanged(evt: ref<SetHUDitorCompatMode>) -> Bool {
  if (this.IsA(n"gameuiWorldMappinsContainerController")) {
     this.huditorListener.SetCompatMode(evt.mode);
  }
}
