import HUDrag.HUDWidgetsManager.*

@addField(inkLogicController)
let isMouseDown: Bool;

public class GameSessionInitializedEvent extends Event {}

// Called when gameplay actually starts & widgets are loaded
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.QueueEvent(new GameSessionInitializedEvent());
}

// Call for a method that's observed in Lua, which then loads widgets' persisted state
@addMethod(inkLogicController)
protected cb func OnGameSessionInitialized(evt: ref<GameSessionInitializedEvent>) -> Bool {
  if this.IsHUDWidget() {
    this.LoadPersistedState();
  }
}

// Used in Lua
@addMethod(inkLogicController)
private func LoadPersistedState() {}

// Used in Lua
@addMethod(inkLogicController)
private func UpdatePersistedState(translation: Vector2, scale: Vector2) {}

// Called from Lua
@addMethod(inkLogicController)
private func SetPersistedState(locationX: Float, locationY: Float, scaleX: Float, scaleY: Float) {
  let persistedTranslation = new Vector2(locationX, locationY);
  let persistedScale = new Vector2(scaleX, scaleY);

  this.GetRootWidget().SetTranslation(persistedTranslation);
  this.GetRootWidget().SetScale(persistedScale);
}

@addMethod(inkLogicController)
private func IsHUDWidget() -> Bool {
  let widgetName = this.GetRootWidget().GetName();

  if !Equals(widgetName, n"") {
    let hudWidgets = [n"BottomLeft", n"TopRight", n"TopLeft", n"TopLeftPhone", n"TopRightWanted", n"InputHint", n"BottomRight"];

    return ArrayContains(hudWidgets, widgetName);
  } else {
    return false;
  }
}

@addMethod(inkLogicController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidget>) -> Bool {
  let widgetName = this.GetRootWidget().GetName();
  let hudEditorWidgetName = event.activeWidget;

  if (this.IsHUDWidget()) {
    if Equals(widgetName, hudEditorWidgetName) {
      this.GetRootWidget().SetOpacity(1);
      this.GetRootWidget().SetVisible(true);
      HUDWidgetsManager.GetInstance().AssignHUDWidgetListeners(this);
    } else {
      this.GetRootWidget().SetOpacity(0.15);
      HUDWidgetsManager.GetInstance().RemoveHUDWidgetListeners(this);
    }
  }
}

@addMethod(inkLogicController)
protected cb func OnDisableHUDEditorWidgets(event: ref<DisableHUDEditor>) -> Bool {
  if this.IsHUDWidget() {
    this.GetRootWidget().SetOpacity(1);
    HUDWidgetsManager.GetInstance().RemoveHUDWidgetListeners(this);
  }
}

@addMethod(inkLogicController)
protected cb func OnResetHUDWidgets(event: ref<ResetAllHUDWidgets>) {
  if this.IsHUDWidget() {
    let widget = this.GetRootWidget();

    widget.SetTranslation(new Vector2(0, 0));
    widget.SetScale(new Vector2(1, 1));
    this.UpdatePersistedState(new Vector2(0, 0), new Vector2(1, 1));
  }
}

@addMethod(inkLogicController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  let currentInput: Float;

  if Equals(ListenerAction.GetName(action), n"click") {
    if (ListenerAction.IsButtonJustPressed(action)) {
      this.isMouseDown = true;
    }

    if (ListenerAction.IsButtonJustReleased(action)) {
      this.isMouseDown = false;
    }
  }

  if (this.isMouseDown) {
    if Equals(ListenerAction.GetName(action), n"CameraMouseX") {
      currentInput = ListenerAction.GetValue(action);
      
      let currentTranslation = this.GetRootWidget().GetTranslation();
      currentTranslation.X += currentInput * 0.6;
      
      this.GetRootWidget().ChangeTranslation(new Vector2(currentInput * 0.6, 0));
      this.UpdatePersistedState(currentTranslation, this.GetRootWidget().GetScale());
    };

    if Equals(ListenerAction.GetName(action), n"CameraMouseY") {
      currentInput = -ListenerAction.GetValue(action);
      
      let currentTranslation = this.GetRootWidget().GetTranslation();
      currentTranslation.Y += currentInput * 0.6;

      this.GetRootWidget().ChangeTranslation(new Vector2(0, currentInput * 0.6));
      this.UpdatePersistedState(currentTranslation, this.GetRootWidget().GetScale());
    };
  }

  if Equals(ListenerAction.GetName(action), n"mouse_wheel") {
    let widgetName = this.GetRootWidget().GetName();

    if Equals(widgetName, n"TopLeftPhone") {
      return true;
    }

    let amount = ListenerAction.GetValue(action);
    let currentScale = this.GetRootWidget().GetScale();
    let zoomRatio: Float = 0.1;

    let finalXScale = currentScale.X + (amount * zoomRatio);
    let finalYScale = currentScale.Y + (amount * zoomRatio);

    if (finalXScale < 0.1) {
      finalXScale = 0.1;
    }

    if (finalYScale > 5.0) {
      finalYScale = 5.0;
    }

    if (finalYScale < 0.1) {
      finalYScale = 0.1;
    }

    if (finalXScale > 5.0) {
      finalXScale = 5.0;
    }
        
    this.GetRootWidget().SetScale(new Vector2(finalXScale, finalYScale));
    this.UpdatePersistedState(this.GetRootWidget().GetTranslation(), new Vector2(finalXScale, finalYScale));
  };
}