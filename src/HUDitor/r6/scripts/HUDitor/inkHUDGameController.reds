import HUDrag.HUDWidgetsManager.*

public class HUDitorInputListener {
  let systemRequestsHandler: wref<inkISystemRequestsHandler>;
  let uiSystem: wref<UISystem>;
  let questSystem: wref<QuestsSystem>;
  let cursor: ref<inkImage>;
  let isShiftDown: Bool;
  let hudWidgetsManager: wref<HUDWidgetsManager>;
  let blackboard: wref<IBlackboard>;

  public func Initialize(parent: ref<inkHUDGameController>) {
    let player: wref<PlayerPuppet> = parent.GetPlayerControlledObject() as PlayerPuppet;
    this.uiSystem = GameInstance.GetUISystem(player.GetGame());
    this.questSystem = GameInstance.GetQuestsSystem(player.GetGame());
    this.systemRequestsHandler = parent.GetSystemRequestsHandler();
    this.AddCursor(parent.GetRootCompoundWidget());
    this.hudWidgetsManager = HUDWidgetsManager.GetInstance();
    this.blackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_Notifications);
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
    let actionName: CName = ListenerAction.GetName(action);
    let isActive: Bool = HUDWidgetsManager.GetInstance().isActive;
    let huditorAvailable: Bool;

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
        this.hudWidgetsManager.SwitchToNextWidget();
        let enableHUDEditorEvent: ref<SetActiveHUDEditorWidgetEvent> = new SetActiveHUDEditorWidgetEvent();
        enableHUDEditorEvent.activeWidget = this.hudWidgetsManager.GetActiveWidget();
        this.uiSystem.QueueEvent(enableHUDEditorEvent);
      };

      if Equals(actionName, n"left_button") && isActive {
        this.hudWidgetsManager.SwitchToPrevWidget();
        let enableHUDEditorEvent: ref<SetActiveHUDEditorWidgetEvent> = new SetActiveHUDEditorWidgetEvent();
        enableHUDEditorEvent.activeWidget = this.hudWidgetsManager.GetActiveWidget();
        this.uiSystem.QueueEvent(enableHUDEditorEvent);
      };

      if isActive {
        if Equals(actionName, n"world_map_filter_navigation_down") {
          let resetEvent: ref<ResetAllHUDWidgets> = new ResetAllHUDWidgets();
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
        huditorAvailable = this.questSystem.GetFact(n"unlock_car_hud_dpad") > 0;
        if !huditorAvailable {
          this.ShowHuditorBlockedCustomMessage();
          return true;
        };

        if Equals(actionName, n"UI_Unequip") || Equals(actionName, n"HUDitor_Editor")  {
          if !isActive {
            let activeWidget: CName = n"";
            let slots: array<CName> = this.hudWidgetsManager.GetSlots();
            if ArraySize(slots) > 0 {
              activeWidget = slots[0];
            };
            this.systemRequestsHandler.PauseGame();
            let enableHUDEditorEvent: ref<SetActiveHUDEditorWidgetEvent> = new SetActiveHUDEditorWidgetEvent();
            enableHUDEditorEvent.activeWidget = activeWidget;
            HUDWidgetsManager.GetInstance().isActive = true;
            HUDWidgetsManager.GetInstance().activeWidget = activeWidget;

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

  private func ShowHuditorBlockedCustomMessage() -> Void {
    let onScreenMessage: SimpleScreenMessage;
    onScreenMessage.isShown = true;
    onScreenMessage.message = GetLocalizedTextByKey(n"UI-Notifications-CombatRestriction");
    onScreenMessage.duration = 2.00;
    this.blackboard.SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(onScreenMessage), true);
  }

  // Used in Lua
  private func PersistHUDWidgetsState() -> Void {}
}

@addField(inkHUDGameController)
private let huditorListener: ref<HUDitorInputListener>;

@addMethod(inkHUDGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  if (this.IsA(n"gameuiWorldMappinsContainerController")) {
    let player: wref<PlayerPuppet> = playerPuppet as PlayerPuppet;
    HUDWidgetsManager.CreateInstance(player, this);
    this.huditorListener = new HUDitorInputListener();
    this.huditorListener.Initialize(this);
    player.RegisterInputListener(this.huditorListener);
  }
}

@addMethod(inkHUDGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  if (this.IsA(n"gameuiWorldMappinsContainerController")) {
    let player: wref<PlayerPuppet> = playerPuppet as PlayerPuppet;
    player.UnregisterInputListener(this.huditorListener);
    this.huditorListener = null;
  }
}
