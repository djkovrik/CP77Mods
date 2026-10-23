import Codeware.UI.inkCustomController
import HUDrag.HUDWidgetsManager.*

public class HUDitorCustomSlot extends inkCustomController {
  private let name: CName;
  private let isMouseDown: Bool;

  public static func Create(name: CName) -> ref<HUDitorCustomSlot> {
    let self: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    self.SetName(name);
    self.CreateInstance();
    return self;
  }

  protected cb func OnCreate() -> Void {
    super.OnCreate();

    let root: ref<inkCanvas> = new inkCanvas();
    this.SetRootWidget(root);
    this.SetContainerWidget(root);
    this.GetRootWidget().SetName(this.name);
  }

  public final func GetName() -> CName {
    return this.name;
  }

  public final func SetName(widgetName: CName) -> Void {
    this.name = widgetName;
  }

  public final func GetScale() -> Vector2 {
    return this.GetRootWidget().GetScale();
  }

  public final func SetScale(scale: Vector2) -> Void {
    this.GetRootWidget().SetScale(scale);
  }

  public final func GetTranslation() -> Vector2 {
    return this.GetRootWidget().GetTranslation();
  }

  public final func SetTranslation(translationVector: Vector2) -> Void {
    this.GetRootWidget().SetTranslation(translationVector);
  }

  public final func IsVisible() -> Bool {
    return this.GetRootWidget().IsVisible();
  }

  public final func SetVisible(visible: Bool) -> Void {
    this.GetRootWidget().SetVisible(visible);
  }

  public final func ChangeTranslation(translationVector: Vector2) -> Void {
    this.GetRootWidget().ChangeTranslation(translationVector);
  }

  public final func GetOpacity() -> Float {
    return this.GetRootWidget().GetOpacity();
  }

  public final func SetOpacity(opacity: Float) -> Void {
    this.GetRootWidget().SetOpacity(opacity);
  }

  public final func SetFitToContent(fitToContent: Bool) -> Void {
    this.GetRootWidget().SetFitToContent(fitToContent);
  }

  public final func SetInteractive(value: Bool) -> Void {
    this.GetRootWidget().SetInteractive(value);
  }

  public final func SetAffectsLayoutWhenHidden(affectsLayoutWhenHidden: Bool) -> Void {
    this.GetRootWidget().SetAffectsLayoutWhenHidden(affectsLayoutWhenHidden);
  }

  public final func SetAnchor(anchor: inkEAnchor) -> Void {
    this.GetRootWidget().SetAnchor(anchor);
  }

  public final func SetAnchorPoint(anchorPoint: Vector2) -> Void {
    this.GetRootWidget().SetAnchorPoint(anchorPoint);
  }

  public final func SetMargin(margin: inkMargin) -> Void {
    this.GetRootWidget().SetMargin(margin);
  }

  // Called from Lua
  private func LoadPersistedState() {}

  // Called from Lua
  private func UpdatePersistedState(translation: Vector2, scale: Vector2) {}

  // Call for a method that's observed in Lua, which then loads widgets' persisted state
  protected cb func OnGameSessionInitialized(evt: ref<GameSessionInitializedEvent>) -> Bool {
    this.LoadPersistedState();
  }

  // Used in Lua
  private func SetPersistedState(locationX: Float, locationY: Float, scaleX: Float, scaleY: Float) {
    let persistedTranslation: Vector2 = Vector2(locationX, locationY);
    let persistedScale: Vector2 = Vector2(scaleX, scaleY);
    this.SetTranslation(persistedTranslation);
    this.SetScale(persistedScale);
  }

  protected cb func OnSetActiveHUDEditorWidgetEvent(event: ref<SetActiveHUDEditorWidgetEvent>) -> Bool {
    let widgetName: CName = this.GetName();
    let hudEditorWidgetName: CName = event.activeWidget;

    if Equals(widgetName, hudEditorWidgetName) {
      this.SetOpacity(1);
      this.SetVisible(true);
      this.RegisterInputListeners();
    } else {
      this.SetOpacity(0.15);
      this.UnregisterInputListeners();
    };
  }

  public func OnScannerDetailsAppearedEvent(event: ref<ScannerDetailsAppearedEvent>) -> Void {
    if event.isVisible && !event.isHackable {
      this.SetOpacity(0.0);
    } else {
      this.SetOpacity(1.0);
    };
  }

  protected cb func OnDisableHUDEditorEvent(event: ref<DisableHUDEditorEvent>) -> Bool {
    this.SetOpacity(1.0);
    this.UnregisterInputListeners();
  }

  protected cb func OnResetAllHUDWidgetsEvent(event: ref<ResetAllHUDWidgetsEvent>) -> Bool {
    let scale: Vector2 = Vector2(0.666667, 0.666667);
    this.SetTranslation(Vector2(0.0, 0.0));
    this.SetScale(scale);
    this.UpdatePersistedState(Vector2(0.0, 0.0), scale);
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
        this.ChangeTranslation(Vector2(currentInput * 0.6, 0));
        this.UpdatePersistedState(currentTranslation, this.GetScale());
      };

      if Equals(ListenerAction.GetName(action), n"CameraMouseY") {
        currentInput = -ListenerAction.GetValue(action);
        currentTranslation = this.GetTranslation();
        currentTranslation.Y += currentInput * 0.6;
        this.ChangeTranslation(Vector2(0, currentInput * 0.6));
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
          
      this.SetScale(Vector2(finalXScale, finalYScale));
      this.UpdatePersistedState(this.GetTranslation(), Vector2(finalXScale, finalYScale));
    };
  }

  private final func RegisterInputListeners() -> Void {
    let player: wref<PlayerPuppet> = GetPlayer(GetGameInstance());
    player.RegisterInputListener(this, n"mouse_wheel");
    player.RegisterInputListener(this, n"CameraMouseX");
    player.RegisterInputListener(this, n"CameraMouseY");
    player.RegisterInputListener(this, n"click");
    player.RegisterInputListener(this, n"Forward");
    player.RegisterInputListener(this, n"Right");
    player.RegisterInputListener(this, n"Back");
    player.RegisterInputListener(this, n"Left");
  }

  private final func UnregisterInputListeners() -> Void {
    let player: wref<PlayerPuppet> = GetPlayer(GetGameInstance());
    player.UnregisterInputListener(this, n"CameraMouseX");
    player.UnregisterInputListener(this, n"CameraMouseY");
    player.UnregisterInputListener(this, n"mouse_wheel");
    player.UnregisterInputListener(this, n"click");
    player.UnregisterInputListener(this, n"Forward");
    player.UnregisterInputListener(this, n"Right");
    player.UnregisterInputListener(this, n"Back");
    player.UnregisterInputListener(this, n"Left");
}

  private final func Log(str: String) -> Void {
    // ModLog(n"Slot", str);
  }
}

// -- Track states to hide some reparented slots
@wrapMethod(PlayerPuppet)
protected cb func OnSceneTierChange(newState: Int32) -> Bool {
  wrappedMethod(newState);
  let evt: ref<HuditorSlotEvent> = new HuditorSlotEvent();
  evt.isVisible = newState <= 2;
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
  // ModLog(n"DEBUG", s"OnSceneTierChange \(newState)");
}

@wrapMethod(PlayerPuppet)
protected cb func OnVisionStateChange(newState: Int32) -> Bool {
  wrappedMethod(newState);
  let evt: ref<HuditorSlotEvent> = new HuditorSlotEvent();
  evt.isVisible = newState < 1;
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
}
