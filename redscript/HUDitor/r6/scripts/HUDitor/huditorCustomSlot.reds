import Codeware.UI.inkCustomController
import HUDrag.HUDWidgetsManager.*

public class HUDitorCustomSlot extends inkCustomController {
  private let name: CName;
  private let manager: wref<HUDWidgetsManager>;
  private let bindings: array<ref<HUDitorBinding>>;
  private let translation: Vector2;
  private let zoom: Vector2;
  private let selected: Bool;
  private let isMouseDown: Bool;
  private let listening: Bool;
  private let loaded: Bool;
  private let preview: ref<HUDitorPreview>;

  public static func Create(name: CName, manager: ref<HUDWidgetsManager>) -> ref<HUDitorCustomSlot> {
    let self: ref<HUDitorCustomSlot> = new HUDitorCustomSlot();
    self.name = name;
    self.manager = manager;
    self.zoom = Vector2(1.0, 1.0);
    self.CreateInstance();
    self.Reparent(manager.overlay.GetSamplesRoot());
    return self;
  }

  protected cb func OnCreate() -> Void {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(this.name);
    root.SetInteractive(false);
    root.SetAffectsLayoutWhenHidden(false);
    root.SetVisible(false);
    this.SetRootWidget(root);
    this.SetContainerWidget(root);
  }

  public func GetName() -> CName { return this.name; }
  public func GetScale() -> Vector2 { return this.zoom; }
  public func GetTranslation() -> Vector2 { return this.translation; }
  public func GetBindings() -> array<ref<HUDitorBinding>> { return this.bindings; }
  public func FindBinding(opt owner: ref<inkGameController>) -> ref<HUDitorBinding> {
    for binding in this.bindings {
      if binding.committed && IsDefined(binding.source) && IsDefined(binding.owner) && (!IsDefined(owner) || binding.owner == owner) { return binding; };
    };
    return null;
  }
  public func GetPreview() -> ref<HUDitorPreview> { return this.preview; }

  public func IsReady() -> Bool {
    for binding in this.bindings { if binding.committed && IsDefined(binding.source) && IsDefined(binding.owner) { return true; }; };
    return false;
  }

  public func Prune() -> Void {
    let i: Int32 = ArraySize(this.bindings) - 1;
    while i >= 0 {
      let binding: ref<HUDitorBinding> = this.bindings[i];
      if !IsDefined(binding.source) || !IsDefined(binding.owner) || !IsDefined(binding.parent) {
        binding.Dispose();
        ArrayErase(this.bindings, i);
      };
      i -= 1;
    };
  }

  public func Stage(source: ref<inkWidget>, owner: ref<inkGameController>, presentation: ref<inkWidget>) -> Void {
    let i: Int32 = ArraySize(this.bindings) - 1;
    while i >= 0 {
      let binding: ref<HUDitorBinding> = this.bindings[i];
      if binding.source == source {
        if binding.presentation == presentation && ((!binding.ownsCarrier && binding.presentationTransform) || source.parentWidget == binding.carrier || !binding.committed) { return; };
        binding.Dispose();
        ArrayErase(this.bindings, i);
      } else {
        if !IsDefined(binding.source) || !IsDefined(binding.owner) || binding.owner == owner {
          binding.Dispose();
          ArrayErase(this.bindings, i);
        };
      };
      i -= 1;
    };
    let binding: ref<HUDitorBinding> = HUDitorBinding.Capture(source, owner);
    if IsDefined(binding) { binding.presentation = presentation; ArrayPush(this.bindings, binding); };
  }

  public func ReleaseOwner(owner: ref<inkGameController>) -> Void {
    let i: Int32 = ArraySize(this.bindings) - 1;
    while i >= 0 {
      if this.bindings[i].owner == owner {
        this.bindings[i].Dispose();
        ArrayErase(this.bindings, i);
      };
      i -= 1;
    };
  }

  public func Commit() -> Void {
    for binding in this.bindings { binding.Commit(); };
    if !this.loaded && this.IsReady() {
      this.loaded = true;
      this.LoadPersistedState();
    };
    this.ApplyTransform();
  }

  private func ApplyTransform() -> Void {
    for binding in this.bindings { binding.Apply(this.translation, this.zoom); };
    if IsDefined(this.preview) { this.preview.UpdateTransform(this.translation, this.zoom); };
  }

  private func LoadPersistedState() -> Void {}
  private func UpdatePersistedState(translation: Vector2, scale: Vector2) -> Void {}
  private func SetPersistedState(locationX: Float, locationY: Float, scaleX: Float, scaleY: Float) -> Void {
    this.translation = Vector2(locationX, locationY);
    this.zoom = Vector2(ClampF(scaleX, 0.1, 5.0), ClampF(scaleY, 0.1, 5.0));
    this.ApplyTransform();
  }

  public func Reset() -> Void {
    this.translation = Vector2(0.0, 0.0);
    this.zoom = Vector2(1.0, 1.0);
    this.ApplyTransform();
    this.UpdatePersistedState(this.translation, this.zoom);
  }

  public func BeginPreview(generation: Uint32) -> Void {
    if IsDefined(this.preview) || !this.IsReady() { return; };
    this.RefreshQuickslots();
    this.preview = HUDitorPreview.Create(this, this.manager, generation);
    if IsDefined(this.preview) { this.preview.UpdateTransform(this.translation, this.zoom); };
    this.SetSelected(false);
  }

  public func EndPreview() -> Void {
    this.SetSelected(false);
    if IsDefined(this.preview) { this.preview.Dispose(); this.preview = null; this.RefreshQuickslots(); };
    this.RefreshContext();
  }

  private func RefreshQuickslots() -> Void {
    if NotEquals(this.name, n"NewDpad") { return; };
    for binding in this.bindings {
      let hotkeys: ref<HotkeysWidgetController> = binding.owner as HotkeysWidgetController;
      if IsDefined(hotkeys) { hotkeys.RefreshHUDitor(); };
    };
  }

  public func SetSelected(selected: Bool) -> Void {
    this.UnregisterInputListeners();
    this.selected = selected;
    if IsDefined(this.preview) { this.preview.SetOpacity(selected ? 1.0 : 0.15); };
    if selected && this.manager.IsActive() { this.RegisterInputListeners(); };
  }

  public func RefreshContext() -> Void {
    if this.manager.IsActive() && IsDefined(this.preview) { return; };
    let allowed: Bool = true;
    if Equals(this.name, n"NewMinimap") || Equals(this.name, n"NewTracker") { allowed = !this.manager.scannerBlocked; };
    if Equals(this.name, n"NewPhoneHotkey") || Equals(this.name, n"NewPhoneAvatar") || Equals(this.name, n"NewPhoneControl") || Equals(this.name, n"NewAutoDrive") || Equals(this.name, n"NewCrystalCoat") || Equals(this.name, n"NewVehicleRadio") || Equals(this.name, n"NewVehicleHotkey") {
      allowed = this.manager.sceneTier <= 2 && this.manager.visionState < 1;
    };
    for binding in this.bindings {
      binding.SetContextVisible(allowed);
    };
  }

  public func Dispose() -> Void {
    this.EndPreview();
    for binding in this.bindings { binding.Dispose(); };
    ArrayClear(this.bindings);
    let root: ref<inkWidget> = this.GetRootWidget();
    if IsDefined(root.parentWidget) { (root.parentWidget as inkCompoundWidget).RemoveChild(root); };
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if !this.selected || !this.manager.IsActive() { this.isMouseDown = false; return false; };
    let name: CName = ListenerAction.GetName(action);
    let pressed: Bool = ListenerAction.IsButtonJustPressed(action);
    let changed: Bool = false;
    if Equals(name, n"click") {
      if pressed { this.isMouseDown = true; };
      if ListenerAction.IsButtonJustReleased(action) { this.isMouseDown = false; };
    };
    if this.isMouseDown && Equals(name, n"CameraMouseX") { this.translation.X += ListenerAction.GetValue(action) * 0.6; changed = true; };
    if this.isMouseDown && Equals(name, n"CameraMouseY") { this.translation.Y -= ListenerAction.GetValue(action) * 0.6; changed = true; };
    if pressed && Equals(name, n"Forward") { this.translation.Y -= 1.0; changed = true; };
    if pressed && Equals(name, n"Back") { this.translation.Y += 1.0; changed = true; };
    if pressed && Equals(name, n"Left") { this.translation.X -= 1.0; changed = true; };
    if pressed && Equals(name, n"Right") { this.translation.X += 1.0; changed = true; };
    if Equals(name, n"mouse_wheel") {
      let amount: Float = ListenerAction.GetValue(action) * 0.1;
      this.zoom.X = ClampF(this.zoom.X + amount, 0.1, 5.0);
      this.zoom.Y = ClampF(this.zoom.Y + amount, 0.1, 5.0);
      changed = true;
    };
    if changed { this.ApplyTransform(); this.UpdatePersistedState(this.translation, this.zoom); };
    return changed;
  }

  private func RegisterInputListeners() -> Void {
    if this.listening || !IsDefined(this.manager.player) { return; };
    this.manager.player.RegisterInputListener(this);
    this.listening = true;
  }

  private func UnregisterInputListeners() -> Void {
    this.isMouseDown = false;
    if this.listening && IsDefined(this.manager.player) { this.manager.player.UnregisterInputListener(this); };
    this.listening = false;
  }
}
