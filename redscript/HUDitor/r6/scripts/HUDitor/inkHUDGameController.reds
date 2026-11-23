import Codeware.UI.ScreenHelper
import HUDrag.HUDitorWatcher
import HUDrag.HUDWidgetsManager.*
import HUDrag.HUDitorConfig

public class HUDitorInputListener {
  private let systemRequestsHandler: wref<inkISystemRequestsHandler>;
  private let hudWidgetsManager: wref<HUDWidgetsManager>;
  private let ownsPause: Bool;
  private let uiController: wref<inkHUDGameController>;
  private let requestId: Uint32;
  private let requestPending: Bool;
  private let requestedOpen: Bool;

  public func Initialize(parent: ref<inkHUDGameController>, manager: ref<HUDWidgetsManager>) -> Void {
    this.systemRequestsHandler = parent.GetSystemRequestsHandler();
    this.uiController = parent;
    this.hudWidgetsManager = manager;
    manager.listener = this;
  }

  public func ResetCursor() -> Void {
    if IsDefined(this.hudWidgetsManager.overlay) { this.hudWidgetsManager.overlay.PressCursor(false); };
  }

  public func GetManager() -> wref<HUDWidgetsManager> { return this.hudWidgetsManager; }

  public func Close() -> Void {
    this.requestId += 1u;
    this.requestPending = false;
    this.requestedOpen = false;
    let manager: ref<HUDWidgetsManager> = this.hudWidgetsManager;
    if !IsDefined(manager) { return; };
    let wasActive: Bool = manager.IsActive();
    manager.End();
    this.ResetCursor();
    if this.ownsPause {
      this.ownsPause = false;
      let uiBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(manager.gameInstance).Get(GetAllBlackboardDefs().UI_System);
      if IsDefined(this.systemRequestsHandler) && (!IsDefined(uiBlackboard) || !uiBlackboard.GetBool(GetAllBlackboardDefs().UI_System.IsInMenu)) {
        this.systemRequestsHandler.UnpauseGame();
      };
    };
    if wasActive { this.PersistHUDWidgetsState(); };
  }

  private func RequestEditorState(open: Bool) -> Void {
    if !IsDefined(this.uiController) { return; };
    this.requestId += 1u;
    this.requestPending = true;
    this.requestedOpen = open;
    let evt: ref<HUDitorEditorStateEvent> = new HUDitorEditorStateEvent();
    evt.listener = this;
    evt.requestId = this.requestId;
    evt.open = open;
    this.uiController.QueueEvent(evt);
  }

  public func ApplyEditorState(evt: ref<HUDitorEditorStateEvent>) -> Void {
    if !this.requestPending || evt.requestId != this.requestId { return; };
    this.requestPending = false;
    let manager: ref<HUDWidgetsManager> = this.hudWidgetsManager;
    if !IsDefined(manager) || manager.disposed || manager != HUDWidgetsManager.GetInstance() { return; };
    if !evt.open { this.Close(); return; };
    if manager.IsActive() || !IsDefined(this.systemRequestsHandler) || this.systemRequestsHandler.IsGamePaused() { return; };
    if GameInstance.GetQuestsSystem(manager.gameInstance).GetFact(n"unlock_car_hud_dpad") <= 0 {
      this.ShowHuditorBlockedCustomMessage();
      return;
    };
    let opened: Bool = manager.Begin();
    if opened {
      this.systemRequestsHandler.PauseGame();
      this.ownsPause = true;
    };
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let manager: ref<HUDWidgetsManager> = this.hudWidgetsManager;
    if !IsDefined(manager) || manager.disposed { return false; };
    let name: CName = ListenerAction.GetName(action);
    let pressed: Bool = ListenerAction.IsButtonJustPressed(action);
    if Equals(name, n"HUDitor_Editor") {
      let config: ref<HUDitorConfig> = new HUDitorConfig();
      let accepted: Bool = config.hold ? Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE) : Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED);
      if !accepted { return false; };
      let open: Bool = this.requestPending ? this.requestedOpen : manager.IsActive();
      this.RequestEditorState(!open);
      return true;
    };
    if pressed && (Equals(name, n"cancel") || Equals(name, n"back")) && (manager.IsActive() || this.requestPending) {
      this.RequestEditorState(false);
      return true;
    };
    if !manager.IsActive() { return false; };
    if pressed && Equals(name, n"right_button") { manager.SwitchToNextWidget(); return true; };
    if pressed && Equals(name, n"left_button") { manager.SwitchToPrevWidget(); return true; };
    if pressed && Equals(name, n"world_map_filter_navigation_down") { manager.Reset(); return true; };
    if Equals(name, n"CameraMouseX") { manager.overlay.MoveCursor(Vector2(ListenerAction.GetValue(action), 0.0)); };
    if Equals(name, n"CameraMouseY") { manager.overlay.MoveCursor(Vector2(0.0, -ListenerAction.GetValue(action))); };
    if Equals(name, n"click") {
      if pressed { manager.overlay.PressCursor(true); };
      if ListenerAction.IsButtonJustReleased(action) { manager.overlay.PressCursor(false); };
    };
    return false;
  }

  private func ShowHuditorBlockedCustomMessage() -> Void {
    let onScreenMessage: SimpleScreenMessage;
    onScreenMessage.isShown = true;
    onScreenMessage.message = GetLocalizedTextByKey(n"UI-Notifications-CombatRestriction");
    onScreenMessage.duration = 2.0;
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.hudWidgetsManager.gameInstance).Get(GetAllBlackboardDefs().UI_Notifications);
    blackboard.SetVariant(GetAllBlackboardDefs().UI_Notifications.OnscreenMessage, ToVariant(onScreenMessage), true);
  }

  private func PersistHUDWidgetsState() -> Void {}
}

@addField(inkHUDGameController)
private let huditorListener: ref<HUDitorInputListener>;

@addMethod(inkHUDGameController)
protected cb func OnHUDitorEditorStateEvent(evt: ref<HUDitorEditorStateEvent>) -> Bool {
  if IsDefined(evt.listener) && evt.listener == this.huditorListener {
    evt.listener.ApplyEditorState(evt);
  };
}

@addMethod(inkHUDGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  if !this.IsA(n"gameuiWorldMappinsContainerController") { return false; };
  let player: wref<PlayerPuppet> = playerPuppet as PlayerPuppet;
  if !IsDefined(player) { return false; };
  if IsDefined(this.huditorListener) {
    let previous: ref<HUDWidgetsManager> = this.huditorListener.GetManager();
    if IsDefined(previous) { previous.Dispose(); } else {
      this.huditorListener.Close();
      player.UnregisterInputListener(this.huditorListener);
    };
  };
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.CreateInstance(player, this);
  this.huditorListener = new HUDitorInputListener();
  this.huditorListener.Initialize(this, manager);
  player.RegisterInputListener(this.huditorListener);
}

@addMethod(inkHUDGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  if !this.IsA(n"gameuiWorldMappinsContainerController") { return false; };
  let player: wref<PlayerPuppet> = playerPuppet as PlayerPuppet;
  let manager: ref<HUDWidgetsManager>;
  if IsDefined(this.huditorListener) {
    manager = this.huditorListener.GetManager();
  };
  if IsDefined(manager) { manager.Dispose(); } else {
    if IsDefined(this.huditorListener) {
      this.huditorListener.Close();
      if IsDefined(player) { player.UnregisterInputListener(this.huditorListener); };
    };
  };
  this.huditorListener = null;
}


public class HUDitorLayoutCallback {
  public let overlay: wref<HUDitorOverlay>;
  public let generation: Uint32;

  protected cb func OnLoop(proxy: ref<inkAnimProxy>) -> Bool {
    if IsDefined(this.overlay) { this.overlay.OnLayoutTick(this.generation); };
  }
}

public class HUDitorOverlay {
  private let manager: wref<HUDWidgetsManager>;
  private let root: ref<inkCanvas>;
  private let samples: ref<inkCanvas>;
  private let label: ref<inkText>;
  private let cursor: ref<inkImage>;
  private let selected: wref<HUDitorCustomSlot>;
  private let updateProxy: ref<inkAnimProxy>;
  private let updateTarget: ref<HUDitorLayoutCallback>;
  private let baseRefreshFrames: Int32;

  public func Initialize(parent: ref<inkCompoundWidget>, manager: ref<HUDWidgetsManager>) -> Void {
    this.manager = manager;
    this.root = new inkCanvas();
    this.root.SetName(n"HUDitorOverlay");
    this.root.SetAnchor(inkEAnchor.Fill);
    this.root.SetInteractive(false);
    this.root.SetAffectsLayoutWhenHidden(false);
    this.root.Reparent(parent);
    this.samples = new inkCanvas();
    this.samples.SetName(n"HUDitorSamples");
    this.samples.SetAnchor(inkEAnchor.Fill);
    this.samples.SetInteractive(false);
    this.samples.SetAffectsLayoutWhenHidden(false);
    this.samples.Reparent(this.root);
    this.label = new inkText();
    this.label.SetName(n"huditorLabel");
    this.label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    this.label.SetFontSize(38);
    this.label.SetAnchor(inkEAnchor.BottomCenter);
    this.label.SetAnchorPoint(Vector2(0.5, 1.0));
    this.label.SetMargin(inkMargin(0.0, 0.0, 0.0, 20.0));
    this.label.SetTintColor(HDRColor(1.1192, 0.8441, 0.2565, 1.0));
    this.label.SetInteractive(false);
    this.label.Reparent(this.root);
    this.cursor = new inkImage();
    this.cursor.SetAtlasResource(r"base\\gameplay\\gui\\widgets\\cursors\\cursor_inventory.inkatlas");
    this.cursor.SetTexturePart(n"mouse_frame");
    this.cursor.SetAnchorPoint(Vector2(0.5, 0.5));
    this.cursor.SetFitToContent(true);
    this.cursor.SetTranslation(Vector2(600.0, 600.0));
    this.cursor.SetInteractive(false);
    this.cursor.Reparent(this.root);
    this.root.SetVisible(false);
    HUDitorWatcher.Get(manager.gameInstance).Start(manager);
  }

  public func GetSamplesRoot() -> ref<inkCompoundWidget> { return this.samples; }
  public func MoveCursor(delta: Vector2) -> Void { this.cursor.ChangeTranslation(delta); }
  public func PressCursor(pressed: Bool) -> Void { this.cursor.SetTexturePart(pressed ? n"mouse_fill" : n"mouse_frame"); }

  public func Show(show: Bool) -> Void {
    this.root.SetVisible(show);
    if IsDefined(this.updateProxy) {
      this.updateProxy.UnregisterFromCallback(inkanimEventType.OnEndLoop, this.updateTarget, n"OnLoop");
      this.updateProxy.Stop(true);
      this.updateProxy = null;
      this.updateTarget = null;
    };
    if show {
      this.baseRefreshFrames = 2;
      let animation: ref<inkAnimDef> = new inkAnimDef();
      let tick: ref<inkAnimTransparency> = new inkAnimTransparency();
      tick.SetStartTransparency(1.0);
      tick.SetEndTransparency(1.0);
      tick.SetDuration(0.033);
      animation.AddInterpolator(tick);
      let options: inkAnimOptions;
      options.loopType = inkanimLoopType.Cycle;
      options.loopCounter = 3u;
      options.dependsOnTimeDilation = false;
      this.updateProxy = this.root.PlayAnimationWithOptions(animation, options);
      this.updateTarget = new HUDitorLayoutCallback();
      this.updateTarget.overlay = this;
      this.updateTarget.generation = this.manager.generation;
      this.updateProxy.RegisterToCallback(inkanimEventType.OnEndLoop, this.updateTarget, n"OnLoop");
    } else {
      this.selected = null;
    };
  }

  public func Select(slot: ref<HUDitorCustomSlot>) -> Void {
    this.selected = slot;
    this.label.SetText(HUDitorTexts.GetWidgetName(slot.GetName()));
  }

  public func OnLayoutTick(generation: Uint32) -> Void {
    if generation != this.manager.generation || !this.manager.IsActive() { return; };
    if this.baseRefreshFrames > 0 {
      this.RefreshBase();
      this.baseRefreshFrames -= 1;
    };
  }

  public func RefreshBase() -> Void {
    let scale: Vector2 = ScreenHelper.GetScreenSize(this.manager.gameInstance);
    let factor: Float = MinF(scale.X / 3840.0, scale.Y / 2160.0);
    if factor <= 0.0 { factor = 1.0; };
    this.label.SetScale(Vector2(factor, factor));
    this.cursor.SetScale(Vector2(factor, factor));
    for slot in this.manager.controllers {
      let preview: ref<HUDitorPreview> = slot.GetPreview();
      if IsDefined(preview) { preview.RefreshBase(); preview.UpdateTransform(slot.GetTranslation(), slot.GetScale()); };
    };
  }

  public func RequestBaseRefresh() -> Void {
    this.RefreshBase();
    if this.manager.IsActive() { this.Show(true); };
  }

  public func Dispose() -> Void {
    this.Show(false);
    HUDitorWatcher.Get(this.manager.gameInstance).Stop(this.manager);
    if IsDefined(this.root.parentWidget) { (this.root.parentWidget as inkCompoundWidget).RemoveChild(this.root); };
  }
}
