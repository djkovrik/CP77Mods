import HUDrag.HUDWidgetsManager.*

public class HUDitorCustomSlot extends inkCanvas {
  
  private let isMouseDown: Bool;

  // Called from Lua
  private func LoadPersistedState() {}

  // Called from Lua
  private func UpdatePersistedState(translation: Vector2, scale: Vector2) {}

  // Call for a method that's observed in Lua, which then loads widgets' persisted state
  protected cb func OnGameSessionInitialized(evt: ref<GameSessionInitializedEvent>) -> Bool {
    if this.IsHUDWidget() {
      this.LoadPersistedState();
    };
  }

  // Used in Lua
  private func SetPersistedState(locationX: Float, locationY: Float, scaleX: Float, scaleY: Float) {
    let persistedTranslation: Vector2 = new Vector2(locationX, locationY);
    let persistedScale: Vector2 = new Vector2(scaleX, scaleY);
    this.SetTranslation(persistedTranslation);
    this.SetScale(persistedScale);
  }

  protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidgetEvent>) -> Bool {
    let widgetName: CName = this.GetName();
    let hudEditorWidgetName: CName = event.activeWidget;

    if (this.IsHUDWidget()) {
      if Equals(widgetName, hudEditorWidgetName) {
        this.SetOpacity(1);
        this.SetVisible(true);
        HUDWidgetsManager.GetInstance().AssignHUDWidgetListeners(this);
      } else {
        this.SetOpacity(0.15);
        HUDWidgetsManager.GetInstance().RemoveHUDWidgetListeners(this);
      };
    };
  }

  protected cb func OnScannerDetailsAppearedEvent(event: ref<ScannerDetailsAppearedEvent>) -> Bool {
    if event.isVisible && !event.isHackable {
      this.SetOpacity(0.0);
    } else {
      this.SetOpacity(1.0);
    };
  }

  private func IsHUDWidget() -> Bool {
    let hudWidgets: array<CName> = HUDWidgetsManager.GetInstance().GetSlots();
    let widgetName: CName = this.GetName();

    if !Equals(widgetName, n"") {
      return ArrayContains(hudWidgets, widgetName);
    } else {
      return false;
    };
  }

  protected cb func OnDisableHUDEditorWidgets(event: ref<DisableHUDEditor>) -> Bool {
    if this.IsHUDWidget() {
      this.SetOpacity(1.0);
      HUDWidgetsManager.GetInstance().RemoveHUDWidgetListeners(this);
    };
  }

  protected cb func OnResetHUDWidgets(event: ref<ResetAllHUDWidgets>) {
    if this.IsHUDWidget() {
      let scale: Vector2 = new Vector2(0.666667, 0.666667);
      this.SetTranslation(new Vector2(0.0, 0.0));
      this.SetScale(scale);
      this.UpdatePersistedState(new Vector2(0.0, 0.0), scale);
    };
  }


  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let currentInput: Float;
    let translationAdjustValue: Float = 1.0;

    if Equals(ListenerAction.GetName(action), n"click") {
      if (ListenerAction.IsButtonJustPressed(action)) {
        this.isMouseDown = true;
      };

      if (ListenerAction.IsButtonJustReleased(action)) {
        this.isMouseDown = false;
      };
    };

    let currentTranslation: Vector2;
    if (this.isMouseDown) {
      if Equals(ListenerAction.GetName(action), n"CameraMouseX") {
        currentInput = ListenerAction.GetValue(action);
        currentTranslation = this.GetTranslation();
        currentTranslation.X += currentInput * 0.6;
        this.ChangeTranslation(new Vector2(currentInput * 0.6, 0));
        this.UpdatePersistedState(currentTranslation, this.GetScale());
      };

      if Equals(ListenerAction.GetName(action), n"CameraMouseY") {
        currentInput = -ListenerAction.GetValue(action);
        currentTranslation = this.GetTranslation();
        currentTranslation.Y += currentInput * 0.6;
        this.ChangeTranslation(new Vector2(0, currentInput * 0.6));
        this.UpdatePersistedState(currentTranslation, this.GetScale());
      };
    };

    if Equals(ListenerAction.GetName(action), n"Forward") && ListenerAction.IsButtonJustPressed(action) {
      currentTranslation = this.GetTranslation();
      currentTranslation.Y -= translationAdjustValue;
      this.SetTranslation(currentTranslation);
      this.UpdatePersistedState(currentTranslation, this.GetScale());
    };

    if Equals(ListenerAction.GetName(action), n"Back") && ListenerAction.IsButtonJustPressed(action) {
      currentTranslation = this.GetTranslation();
      currentTranslation.Y += translationAdjustValue;
      this.SetTranslation(currentTranslation);
      this.UpdatePersistedState(currentTranslation, this.GetScale());
    };

    if Equals(ListenerAction.GetName(action), n"Left") && ListenerAction.IsButtonJustPressed(action) {
      currentTranslation = this.GetTranslation();
      currentTranslation.X -= translationAdjustValue;
      this.SetTranslation(currentTranslation);
      this.UpdatePersistedState(currentTranslation, this.GetScale());
    };

    if Equals(ListenerAction.GetName(action), n"Right") && ListenerAction.IsButtonJustPressed(action) {
      currentTranslation = this.GetTranslation();
      currentTranslation.X += translationAdjustValue;
      this.SetTranslation(currentTranslation);
      this.UpdatePersistedState(currentTranslation, this.GetScale());
    };

    if Equals(ListenerAction.GetName(action), n"mouse_wheel") {
      let amount: Float = ListenerAction.GetValue(action);
      let currentScale: Vector2 = this.GetScale();
      let zoomRatio: Float = 0.1;

      let finalXScale: Float = currentScale.X + (amount * zoomRatio);
      let finalYScale: Float = currentScale.Y + (amount * zoomRatio);

      if (finalXScale < 0.1) {
        finalXScale = 0.1;
      };

      if (finalYScale > 5.0) {
        finalYScale = 5.0;
      };

      if (finalYScale < 0.1) {
        finalYScale = 0.1;
      };

      if (finalXScale > 5.0) {
        finalXScale = 5.0;
      };
          
      this.SetScale(new Vector2(finalXScale, finalYScale));
      this.UpdatePersistedState(this.GetTranslation(), new Vector2(finalXScale, finalYScale));
    };
  }
}
