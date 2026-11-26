import HUDrag.HUDWidgetsManager.*
import HUDrag.HUDitorConfig

@if(ModuleExists("FpsCounter"))
import FpsCounter.FPSCounterChangeStateEvent

public class HUDitorSurface {
  public let owner: wref<inkGameController>;
  public let source: wref<inkCompoundWidget>;
  public let presentation: wref<inkWidget>;
  public let content: ref<inkCanvas>;
  private let window: wref<inkCompoundWidget>;

  public static func Create(owner: ref<inkGameController>, presentation: ref<inkWidget>, host: ref<inkCompoundWidget>) -> ref<HUDitorSurface> {
    let source: ref<inkCanvas> = owner.GetRootWidget() as inkCanvas;
    if !IsDefined(source) || !IsDefined(presentation) || !IsDefined(host) { return null; };
    let self: ref<HUDitorSurface> = new HUDitorSurface();
    self.owner = owner;
    self.source = source;
    self.presentation = presentation;
    self.window = host.parentWidget as inkCompoundWidget;
    self.content = new inkCanvas();
    self.content.SetName(n"HUDitorSurface");
    self.content.SetInteractive(false);
    self.content.SetAffectsLayoutWhenHidden(false);
    self.content.SetRenderTransformPivot(Vector2(0.0, 0.0));
    self.content.SetSize(source.GetSize());
    self.content.SetPadding(source.GetPadding());
    self.content.SetChildMargin(source.GetChildMargin());
    self.content.SetChildOrder(source.GetChildOrder());
    self.content.SetStyle(source.GetStylePath());
    self.content.SetTintColor(source.GetTintColor());
    self.content.Reparent(host);
    self.Adopt();
    self.Sync();
    return self;
  }

  public func IsValid() -> Bool {
    return IsDefined(this.owner) && IsDefined(this.source) && IsDefined(this.presentation) && IsDefined(this.presentation.parentWidget) && IsDefined(this.window) && this.owner.GetRootWidget() == this.source;
  }

  public func Adopt() -> Void {
    let children: array<wref<inkWidget>>;
    let i: Int32 = 0;
    while i < this.source.GetNumChildren() {
      ArrayPush(children, this.source.GetWidgetByIndex(i));
      i += 1;
    };
    for child in children { child.Reparent(this.content); };
  }

  private static func Opacity(widget: ref<inkWidget>, stop: ref<inkWidget>) -> Float {
    let opacity: Float = 1.0;
    while IsDefined(widget) && widget != stop {
      if !widget.IsVisible() { return 0.0; };
      opacity *= widget.GetOpacity();
      widget = widget.parentWidget;
    };
    return opacity;
  }

  public func Sync() -> Void {
    if !this.IsValid() { this.content.SetVisible(false); return; };
    let opacity: Float = HUDitorSurface.Opacity(this.source, null) * HUDitorSurface.Opacity(this.presentation.parentWidget, this.window) * this.presentation.GetOpacity();
    let visible: Bool = opacity > 0.0;
    if NotEquals(this.content.IsVisible(), visible) { this.content.SetVisible(visible); };
    if !visible { return; };
    if this.content.GetOpacity() != opacity { this.content.SetOpacity(opacity); };
    let origin: Vector2 = HUDitorGeometry.PresentationOrigin(this.presentation);
    let local: RectF = GetScreenPosition(this.source);
    let screen: RectF = GetScreenPosition(this.window);
    let imageScale: Vector2 = HUDitorGeometry.Scale(this.presentation);
    let scale: Vector2 = HUDitorGeometry.Scale(this.source);
    let screenScale: Vector2 = HUDitorGeometry.Scale(this.window);
    if screenScale.X <= 0.0 || screenScale.Y <= 0.0 { return; };
    let position: Vector2 = Vector2((origin.X + local.Left * imageScale.X - screen.Left) / screenScale.X, (origin.Y + local.Top * imageScale.Y - screen.Top) / screenScale.Y);
    let current: Vector2 = this.content.GetTranslation();
    if current.X != position.X || current.Y != position.Y { this.content.SetTranslation(position); };
    scale.X *= imageScale.X / screenScale.X;
    scale.Y *= imageScale.Y / screenScale.Y;
    current = this.content.GetScale();
    if current.X != scale.X || current.Y != scale.Y { this.content.SetScale(scale); };
    let size: Vector2 = this.source.GetSize();
    current = this.content.GetSize();
    if current.X != size.X || current.Y != size.Y { this.content.SetSize(size); };
    if NotEquals(this.content.GetState(), this.source.GetState()) { this.content.SetState(this.source.GetState()); };
  }

  public func ResolvePreviewBase(binding: ref<HUDitorBinding>, out position: Vector2, out scale: Vector2) -> Bool {
    if binding.owner != this.owner || binding.parent != this.content || !this.IsValid() { return false; };
    let layout: ref<HUDitorLayout> = binding.layout;
    if NotEquals(layout.anchor, inkEAnchor.TopLeft) || NotEquals(layout.sizeRule, inkESizeRule.Fixed) || layout.point.X != 0.0 || layout.point.Y != 0.0 { return false; };
    let origin: Vector2 = HUDitorGeometry.PresentationOrigin(this.presentation);
    let local: RectF = GetScreenPosition(this.source);
    let imageScale: Vector2 = HUDitorGeometry.Scale(this.presentation);
    scale = HUDitorGeometry.Scale(this.source);
    scale.X *= imageScale.X;
    scale.Y *= imageScale.Y;
    let padding: inkMargin = this.content.GetPadding();
    let childMargin: inkMargin = this.content.GetChildMargin();
    let translation: Vector2 = binding.source.GetTranslation();
    let zoom: Vector2 = binding.carrier.GetScale();
    position = Vector2(origin.X + local.Left * imageScale.X + (layout.margin.left + padding.left + childMargin.left + translation.X * zoom.X) * scale.X, origin.Y + local.Top * imageScale.Y + (layout.margin.top + padding.top + childMargin.top + translation.Y * zoom.Y) * scale.Y);
    return true;
  }

  public func Dispose() -> Void {
    if !IsDefined(this.content) { return; };
    if IsDefined(this.source) && IsDefined(this.owner) {
      let children: array<wref<inkWidget>>;
      let i: Int32 = 0;
      while i < this.content.GetNumChildren() {
        ArrayPush(children, this.content.GetWidgetByIndex(i));
        i += 1;
      };
      i = 0;
      for child in children { child.Reparent(this.source, i); i += 1; };
    };
    let parent: ref<inkCompoundWidget> = this.content.parentWidget as inkCompoundWidget;
    if IsDefined(parent) { parent.RemoveChild(this.content); };
    this.content = null;
  }
}

public class HUDitorSurfaces {
  public let states: array<ref<HUDitorSurface>>;
  private let root: ref<inkCanvas>;
  private let updateProxy: ref<inkAnimProxy>;
  private let disposed: Bool;

  public static func Create(window: ref<inkCompoundWidget>) -> ref<HUDitorSurfaces> {
    let self: ref<HUDitorSurfaces> = new HUDitorSurfaces();
    self.root = new inkCanvas();
    self.root.SetName(n"HUDitorSurfaces");
    self.root.SetInteractive(false);
    self.root.SetAffectsLayoutWhenHidden(false);
    self.root.Reparent(window, 0);
    let animation: ref<inkAnimDef> = new inkAnimDef();
    let tick: ref<inkAnimTransparency> = new inkAnimTransparency();
    tick.SetStartTransparency(1.0);
    tick.SetEndTransparency(1.0);
    tick.SetDuration(0.016);
    animation.AddInterpolator(tick);
    let options: inkAnimOptions;
    options.loopType = inkanimLoopType.Cycle;
    options.loopInfinite = true;
    options.dependsOnTimeDilation = false;
    self.updateProxy = self.root.PlayAnimationWithOptions(animation, options);
    self.updateProxy.RegisterToCallback(inkanimEventType.OnEndLoop, self, n"OnLoop");
    return self;
  }

  public func Attach(owner: ref<inkGameController>, presentation: ref<inkWidget>) -> Void {
    for state in this.states {
      if state.owner == owner && state.presentation == presentation { state.Adopt(); state.Sync(); return; };
    };
    let state: ref<HUDitorSurface> = HUDitorSurface.Create(owner, presentation, this.root);
    if IsDefined(state) { ArrayPush(this.states, state); };
  }

  public func ResolvePreviewBase(binding: ref<HUDitorBinding>, out position: Vector2, out scale: Vector2) -> Bool {
    for state in this.states {
      if state.ResolvePreviewBase(binding, position, scale) { return true; };
    };
    return false;
  }

  public func Prune(manager: ref<HUDWidgetsManager>) -> Void {
    let i: Int32 = ArraySize(this.states) - 1;
    while i >= 0 {
      if !this.states[i].IsValid() {
        for slot in manager.controllers { slot.ReleaseOwner(this.states[i].owner); };
        this.states[i].Dispose();
        ArrayErase(this.states, i);
      };
      i -= 1;
    };
  }

  protected cb func OnLoop(proxy: ref<inkAnimProxy>) -> Bool {
    if this.disposed { return false; };
    for state in this.states { state.Sync(); };
    return true;
  }

  public func Dispose() -> Void {
    if this.disposed { return; };
    this.disposed = true;
    if IsDefined(this.updateProxy) {
      this.updateProxy.UnregisterFromCallback(inkanimEventType.OnEndLoop, this, n"OnLoop");
      this.updateProxy.Stop(true);
      this.updateProxy = null;
    };
    for state in this.states { state.Dispose(); };
    ArrayClear(this.states);
    let parent: ref<inkCompoundWidget> = this.root.parentWidget as inkCompoundWidget;
    if IsDefined(parent) { parent.RemoveChild(this.root); };
    this.root = null;
  }
}

public class HUDitorLayout {
  public let anchor: inkEAnchor;
  public let point: Vector2;
  public let margin: inkMargin;
  public let hAlign: inkEHorizontalAlign;
  public let vAlign: inkEVerticalAlign;
  public let size: Vector2;
  public let sizeRule: inkESizeRule;
  public let coefficient: Float;
  public let fit: Bool;
  public let affectsLayout: Bool;

  public static func Capture(widget: ref<inkWidget>) -> ref<HUDitorLayout> {
    let state: ref<HUDitorLayout> = new HUDitorLayout();
    state.anchor = widget.GetAnchor();
    state.point = widget.GetAnchorPoint();
    state.margin = widget.GetMargin();
    state.hAlign = widget.GetHAlign();
    state.vAlign = widget.GetVAlign();
    state.size = widget.GetSize();
    state.sizeRule = widget.GetSizeRule();
    state.coefficient = widget.GetSizeCoefficient();
    state.fit = widget.GetFitToContent();
    state.affectsLayout = widget.GetAffectsLayoutWhenHidden();
    return state;
  }

  public func Apply(widget: ref<inkWidget>) -> Void {
    widget.SetAnchor(this.anchor);
    widget.SetAnchorPoint(this.point);
    widget.SetMargin(this.margin);
    widget.SetHAlign(this.hAlign);
    widget.SetVAlign(this.vAlign);
    widget.SetSize(this.size);
    widget.SetSizeRule(this.sizeRule);
    widget.SetSizeCoefficient(this.coefficient);
    widget.SetFitToContent(this.fit);
    widget.SetAffectsLayoutWhenHidden(this.affectsLayout);
  }
}

public class HUDitorBinding {
  public let source: wref<inkWidget>;
  public let owner: wref<inkGameController>;
  public let parent: wref<inkCompoundWidget>;
  public let carrier: ref<inkWidget>;
  public let ownsCarrier: Bool;
  public let presentation: wref<inkWidget>;
  public let presentationTransform: Bool;
  public let minimapPresentation: Bool;
  private let contextHidden: Bool;
  private let contextVisible: Bool;
  public let layout: ref<HUDitorLayout>;
  public let index: Int32;
  public let committed: Bool;
  private let contentAnchor: inkEAnchor;
  private let baseTranslation: Vector2;
  private let appliedTranslation: Vector2;
  private let baseScale: Vector2;
  private let appliedScale: Vector2;
  private let basePivot: Vector2;
  private let phoneTransform: Bool;
  private let phoneIndicatorTransform: Bool;

  public static func Capture(source: ref<inkWidget>, owner: ref<inkGameController>) -> ref<HUDitorBinding> {
    if !IsDefined(source) || !IsDefined(owner) || !IsDefined(source.parentWidget) { return null; };
    let binding: ref<HUDitorBinding> = new HUDitorBinding();
    binding.source = source;
    binding.owner = owner;
    binding.parent = source.parentWidget as inkCompoundWidget;
    if !IsDefined(binding.parent) { return null; };
    binding.layout = HUDitorLayout.Capture(source);
    let i: Int32 = 0;
    while i < binding.parent.GetNumChildren() {
      if binding.parent.GetWidgetByIndex(i) == source { binding.index = i; break; };
      i += 1;
    };
    return binding;
  }

  public func Commit() -> Void {
    if this.committed || !IsDefined(this.source) || !IsDefined(this.parent) || !IsDefined(this.owner) { return; };
    this.minimapPresentation = this.owner.IsA(n"gameuiMinimapContainerController");
    if (this.owner.IsA(n"hudCarController") || this.minimapPresentation) && !IsDefined(this.presentation) { return; };
    if this.minimapPresentation && this.source != this.owner.GetRootWidget() { return; };
    if IsDefined(this.presentation) && this.source == this.owner.GetRootWidget() {
      this.presentationTransform = true;
      this.baseTranslation = this.presentation.GetTranslation();
      this.baseScale = this.presentation.GetScale();
      this.basePivot = this.presentation.GetRenderTransformPivot();
      this.appliedTranslation = this.baseTranslation;
      this.appliedScale = this.baseScale;
      let scale: Vector2 = HUDitorGeometry.Scale(this.parent);
      let translation: Vector2 = this.source.GetTranslation();
      let size: Vector2 = this.presentation.GetSize();
      if size.X > 0.0 && size.Y > 0.0 {
        this.presentation.SetRenderTransformPivot(Vector2(translation.X * scale.X / size.X, translation.Y * scale.Y / size.Y));
      };

      if this.owner.IsA(n"hudCarController") || this.minimapPresentation {
        this.carrier = this.presentation;
        this.committed = true;
        return;
      };
    };
    let phone: ref<NewHudPhoneGameController> = this.owner as NewHudPhoneGameController;
    this.phoneTransform = IsDefined(phone);
    this.phoneIndicatorTransform = IsDefined(phone) && this.source == inkWidgetRef.Get(phone.phoneIconElement.slot);
    let phonePaused: Bool;
    let resumePhone: Bool = this.SuspendPhoneAnimation(phonePaused);
    if this.owner.IsA(n"dialogWidgetGameController") && this.source.IsA(n"inkVerticalPanelWidget") {
      this.carrier = new inkVerticalPanel();
    } else {
      this.carrier = new inkCanvas();
    };
    this.ownsCarrier = true;
    this.carrier.SetName(n"HUDitorTransform");
    this.layout.Apply(this.carrier);
    this.carrier.SetInteractive(false);
    this.carrier.SetRenderTransformPivot(Vector2(0.0, 0.0));
    this.carrier.Reparent(this.parent, this.index);
    let anchor: inkEAnchor = this.layout.anchor;
    let horizontal: Bool = Equals(anchor, inkEAnchor.TopFillHorizontaly) || Equals(anchor, inkEAnchor.CenterFillHorizontaly) || Equals(anchor, inkEAnchor.BottomFillHorizontaly) || Equals(anchor, inkEAnchor.Fill);
    let vertical: Bool = Equals(anchor, inkEAnchor.LeftFillVerticaly) || Equals(anchor, inkEAnchor.CenterFillVerticaly) || Equals(anchor, inkEAnchor.RightFillVerticaly) || Equals(anchor, inkEAnchor.Fill);
    this.contentAnchor = horizontal ? (vertical ? inkEAnchor.Fill : inkEAnchor.TopFillHorizontaly) : (vertical ? inkEAnchor.LeftFillVerticaly : inkEAnchor.TopLeft);
    this.source.SetAnchor(this.contentAnchor);
    this.source.SetAnchorPoint(Vector2(0.0, 0.0));
    this.source.SetMargin(inkMargin(0.0, 0.0, 0.0, 0.0));
    this.source.SetHAlign(inkEHorizontalAlign.Left);
    this.source.SetVAlign(inkEVerticalAlign.Top);
    this.source.SetSizeRule(inkESizeRule.Fixed);
    if this.phoneTransform {
      this.baseTranslation = this.source.GetTranslation();
      this.source.SetTranslation(Vector2(0.0, 0.0));
      this.carrier.SetTranslation(this.baseTranslation);
      this.appliedTranslation = this.baseTranslation;
    };
    if this.phoneIndicatorTransform {
      this.baseScale = this.source.GetScale();
      this.appliedScale = this.baseScale;
      this.basePivot = this.source.GetRenderTransformPivot();
      this.source.SetRenderTransformPivot(Vector2(0.0, 0.0));
      this.appliedTranslation = Vector2(0.0, 0.0);
    };
    this.source.Reparent(this.carrier as inkCompoundWidget);
    this.committed = true;
    if resumePhone { phone.ResumeHUDitorPhoneIconAnim(phonePaused); };
  }

  public func Apply(translation: Vector2, zoom: Vector2) -> Void {
    if !this.committed || !IsDefined(this.source) { return; };
    if this.phoneIndicatorTransform {
      this.appliedTranslation = translation;
      this.appliedScale = Vector2(this.baseScale.X * zoom.X, this.baseScale.Y * zoom.Y);
      this.source.SetTranslation(this.appliedTranslation);
      this.source.SetScale(this.appliedScale);
      return;
    };
    if this.presentationTransform || this.phoneTransform {
      let target: ref<inkWidget> = this.carrier;
      if this.presentationTransform { target = this.presentation; };
      if !IsDefined(target) { return; };
      let current: Vector2 = target.GetTranslation();
      if current.X != this.appliedTranslation.X || current.Y != this.appliedTranslation.Y { this.baseTranslation = current; };
      let factor: Vector2 = Vector2(1.0, 1.0);
      if this.presentationTransform {
        let sourceScale: Vector2 = HUDitorGeometry.Scale(this.parent);
        let imageScale: Vector2 = HUDitorGeometry.Scale(target.parentWidget);
        factor = Vector2(sourceScale.X / imageScale.X, sourceScale.Y / imageScale.Y);
      };
      this.appliedTranslation = Vector2(this.baseTranslation.X + translation.X * factor.X, this.baseTranslation.Y + translation.Y * factor.Y);
      target.SetTranslation(this.appliedTranslation);
      if this.presentationTransform {
        this.appliedScale = Vector2(this.baseScale.X * zoom.X, this.baseScale.Y * zoom.Y);
        target.SetScale(this.appliedScale);
      } else { target.SetScale(zoom); };
      return;
    };
    this.carrier.SetTranslation(translation);
    this.carrier.SetScale(zoom);
  }

  public func SetContextVisible(visible: Bool) -> Void {
    if !this.committed || !IsDefined(this.carrier) { return; };
    if this.ownsCarrier {
      this.carrier.SetVisible(visible);
    } else {
      if this.minimapPresentation {
        if !visible {
          if !this.contextHidden { 
            this.contextVisible = this.carrier.IsVisible(); 
          };
          this.contextHidden = true;
          this.carrier.SetVisible(false);
        } else {
          if this.contextHidden {
            if !this.carrier.IsVisible() { 
              this.carrier.SetVisible(this.contextVisible); 
            };
            this.contextHidden = false;
          };
        };
      };
    };
  }

  private func SuspendPhoneAnimation(out paused: Bool) -> Bool {
    paused = false;
    if !this.phoneIndicatorTransform { return false; };
    let phone: ref<NewHudPhoneGameController> = this.owner as NewHudPhoneGameController;
    if !IsDefined(phone) || !IsDefined(phone.m_phoneIconAnimProxy) { return false; };
    paused = phone.m_phoneIconAnimProxy.IsPaused();
    if !paused && !phone.m_phoneIconAnimProxy.IsPlaying() && !phone.m_phoneIconAnimProxy.IsLoading() { return false; };
    phone.m_phoneIconAnimProxy.Stop(true);
    phone.m_phoneIconAnimProxy = null;
    return true;
  }

  public func Dispose() -> Void {
    if !this.committed { return; };
    if this.minimapPresentation { this.SetContextVisible(true); };
    if this.presentationTransform && IsDefined(this.presentation) {
      let current: Vector2 = this.presentation.GetTranslation();
      if current.X == this.appliedTranslation.X && current.Y == this.appliedTranslation.Y { this.presentation.SetTranslation(this.baseTranslation); };
      current = this.presentation.GetScale();
      if current.X == this.appliedScale.X && current.Y == this.appliedScale.Y { this.presentation.SetScale(this.baseScale); };
      this.presentation.SetRenderTransformPivot(this.basePivot);
    };
    if !this.ownsCarrier {
      this.carrier = null;
      this.committed = false;
      return;
    };
    let phonePaused: Bool;
    let resumePhone: Bool;
    let ownsPhoneSource: Bool = this.phoneIndicatorTransform && IsDefined(this.source) && IsDefined(this.carrier) && IsDefined(this.parent) && this.source.parentWidget == this.carrier && this.carrier.parentWidget == this.parent;
    if ownsPhoneSource { resumePhone = this.SuspendPhoneAnimation(phonePaused); };
    if IsDefined(this.source) && IsDefined(this.owner) {
      if Equals(this.source.GetAnchor(), this.contentAnchor) { this.source.SetAnchor(this.layout.anchor); };
      let point: Vector2 = this.source.GetAnchorPoint();
      if point.X == 0.0 && point.Y == 0.0 { this.source.SetAnchorPoint(this.layout.point); };
      let margin: inkMargin = this.source.GetMargin();
      if margin.left == 0.0 && margin.top == 0.0 && margin.right == 0.0 && margin.bottom == 0.0 { this.source.SetMargin(this.layout.margin); };
      if Equals(this.source.GetHAlign(), inkEHorizontalAlign.Left) { this.source.SetHAlign(this.layout.hAlign); };
      if Equals(this.source.GetVAlign(), inkEVerticalAlign.Top) { this.source.SetVAlign(this.layout.vAlign); };
      if Equals(this.source.GetSizeRule(), inkESizeRule.Fixed) { this.source.SetSizeRule(this.layout.sizeRule); };
      if ownsPhoneSource {
        let translation: Vector2 = this.source.GetTranslation();
        if translation.X == this.appliedTranslation.X && translation.Y == this.appliedTranslation.Y { this.source.SetTranslation(this.carrier.GetTranslation()); };
        let scale: Vector2 = this.source.GetScale();
        if scale.X == this.appliedScale.X && scale.Y == this.appliedScale.Y { this.source.SetScale(this.baseScale); };
        let pivot: Vector2 = this.source.GetRenderTransformPivot();
        if pivot.X == 0.0 && pivot.Y == 0.0 { this.source.SetRenderTransformPivot(this.basePivot); };
      };
      if this.phoneTransform && !this.phoneIndicatorTransform {
        let translation: Vector2 = this.source.GetTranslation();
        if translation.X == 0.0 && translation.Y == 0.0 { this.source.SetTranslation(this.baseTranslation); };
      };
      if IsDefined(this.parent) && this.source.parentWidget == this.carrier { this.source.Reparent(this.parent, this.index); };
    };
    if IsDefined(this.parent) { this.parent.RemoveChild(this.carrier); };
    if resumePhone {
      let phone: ref<NewHudPhoneGameController> = this.owner as NewHudPhoneGameController;
      if IsDefined(phone) { phone.ResumeHUDitorPhoneIconAnim(phonePaused); };
    };
    this.carrier = null;
    this.ownsCarrier = false;
    this.committed = false;
  }
}

public abstract class HUDitorBindings {
  public static func Stage(manager: ref<HUDWidgetsManager>, name: CName, source: ref<inkWidget>, owner: ref<inkGameController>) -> Void {
    if !manager.IsEnabled(name) || !IsDefined(source) { return; };
    let slot: ref<HUDitorCustomSlot> = manager.FindSlot(name);
    if !IsDefined(slot) {
      slot = HUDitorCustomSlot.Create(name, manager);
      manager.RegisterSlot(slot);
    };
    slot.Stage(source, owner, HUDitorBindings.FindPresentation(manager, owner, source));
  }

  public static func Discover(manager: ref<HUDWidgetsManager>) -> Void {
    for slot in manager.controllers { slot.Prune(); };
    let layer: ref<inkLayerWrapper> = GameInstance.GetInkSystem().GetLayer(n"inkHUDLayer");
    if !IsDefined(layer) || !IsDefined(layer.GetVirtualWindow()) { return; };
    manager.window = layer.GetVirtualWindow();
    if IsDefined(manager.surfaces) { manager.surfaces.Prune(manager); };
    let controllers: array<wref<inkIGameController>> = layer.GetGameControllers();
    for controller in controllers {
      if controller.IsA(n"gameuiRootHudGameController") { manager.host = controller as inkGameController; };
    };
    if !IsDefined(manager.host) { return; };
    ArrayClear(manager.presentations);
    HUDitorBindings.CollectPresentations(layer.GetVirtualWindow(), manager.presentations);
    if !IsDefined(manager.overlay) {
      manager.overlay = new HUDitorOverlay();
      manager.overlay.Initialize(layer.GetVirtualWindow(), manager);
    };
    for controller in controllers {
      let gameController: ref<inkGameController> = controller as inkGameController;
      if IsDefined(gameController) { HUDitorBindings.DiscoverController(manager, gameController); };
    };
    for slot in manager.controllers { slot.Commit(); };
    let psm: ref<IBlackboard> = GameInstance.GetBlackboardSystem(manager.gameInstance).GetLocalInstanced(manager.player.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if IsDefined(psm) {
      manager.sceneTier = psm.GetInt(GetAllBlackboardDefs().PlayerStateMachine.SceneTier);
      manager.visionState = psm.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision);
    };
    manager.UpdateContext();
  }

  private static func DiscoverController(manager: ref<HUDWidgetsManager>, controller: ref<inkGameController>) -> Void {
    let source: ref<inkWidget> = controller.GetRootWidget();
    if !IsDefined(source) || HUDitorPreview.IsSample(source) { return; };
    let scanner: ref<scannerDetailsGameController> = controller as scannerDetailsGameController;
    if IsDefined(scanner) {
      let scannerBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(manager.gameInstance).Get(GetAllBlackboardDefs().UI_Scanner);
      manager.scannerBlocked = EntityID.IsDefined(scannerBB.GetEntityID(GetAllBlackboardDefs().UI_Scanner.ScannedObject)) && !scanner.m_isQuickHackAble;
    };
    HUDitorBindings.PrepareSurface(manager, controller);
    let name: CName = n"";
    switch controller.GetClassName() {
      case n"QuestTrackerGameController": name = n"NewTracker"; break;
      case n"gameuiMinimapContainerController": name = n"NewMinimap"; break;
      case n"WantedBarGameController": name = n"NewWanted"; break;
      case n"JournalNotificationQueue": name = n"NewQuestNotifications"; break;
      case n"ItemsNotificationQueue": name = n"NewItemNotifications"; break;
      case n"VehicleSummonWidgetGameController": name = n"NewVehicleSummon"; break;
      case n"gameuiWeaponRosterGameController": name = n"NewWeaponRoster"; break;
      case n"CrouchIndicatorGameController": name = n"NewCrouchIndicator"; break;
      case n"gameuiHudHealthbarGameController": name = n"NewHealthBar"; break;
      case n"StaminabarWidgetGameController": name = n"NewStaminaBar"; break;
      case n"hudCarController": name = n"NewCarHud"; break;
      case n"BossHealthBarGameController": name = n"NewBossHealthbar"; break;
      case n"dialogWidgetGameController": name = n"NewDialogChoices"; break;
      case n"SubtitlesGameController": name = n"NewDialogSubtitles"; break;
      case n"HUDProgressBarController": name = n"NewProgressBar"; break;
      case n"gameuiFPSCounterGameController": name = n"NewFpsCounter"; break;
      case n"gameuiInputHintManagerGameController":
        let hints: ref<InputHintManagerGameController> = controller as InputHintManagerGameController;
        if IsDefined(hints) && Equals(hints.hintContainerId, n"GameplayInputHelper") { name = n"NewInputHint"; };
        break;
      case n"NewHudPhoneGameController":
        let phone: ref<NewHudPhoneGameController> = controller as NewHudPhoneGameController;
        HUDitorBindings.Stage(manager, n"NewPhoneAvatar", inkWidgetRef.Get(phone.holoAudioCallElement.slot), controller);
        HUDitorBindings.Stage(manager, n"NewPhoneControl", inkWidgetRef.Get(phone.incomingCallElement.slot), controller);
        HUDitorBindings.Stage(manager, n"NewPhoneHotkey", inkWidgetRef.Get(phone.phoneIconElement.slot), controller);
        break;
      case n"HotkeysWidgetController":
        let hotkeys: ref<HotkeysWidgetController> = controller as HotkeysWidgetController;
        HUDitorBindings.Stage(manager, n"NewDpad", inkWidgetRef.Get(hotkeys.m_dpadHintsPanel), controller);
        HUDitorBindings.Stage(manager, n"NewVehicleRadio", inkWidgetRef.Get(hotkeys.m_radioSlot), controller);
        HUDitorBindings.Stage(manager, n"NewVehicleHotkey", inkWidgetRef.Get(hotkeys.m_carSlot), controller);
        break;
      case n"HotkeyConsumableWidgetController":
        let vehicle: ref<HotkeyConsumableWidgetController> = controller as HotkeyConsumableWidgetController;
        HUDitorBindings.Stage(manager, n"NewDpad", inkWidgetRef.Get(vehicle.m_container), controller);
        HUDitorBindings.Stage(manager, n"NewVehicleRadio", inkWidgetRef.Get(vehicle.m_radioSlot), controller);
        HUDitorBindings.Stage(manager, n"NewCrystalCoat", inkWidgetRef.Get(vehicle.m_vehicleCustomizationSlot), controller);
        HUDitorBindings.Stage(manager, n"NewAutoDrive", inkWidgetRef.Get(vehicle.m_autodriveSlot), controller);
        break;
      case n"HotkeyCustomRadioWidgetController":
        let radio: ref<HotkeyCustomRadioWidgetController> = controller as HotkeyCustomRadioWidgetController;
        HUDitorBindings.Stage(manager, n"NewVehicleRadio", inkWidgetRef.Get(radio.m_radioSlot), controller);
        break;
    };
    if NotEquals(name, n"") { HUDitorBindings.Stage(manager, name, source, controller); };
  }

  private static func PrepareSurface(manager: ref<HUDWidgetsManager>, owner: ref<inkGameController>) -> Void {
    let enabled: Bool;
    switch owner.GetClassName() {
      case n"HotkeysWidgetController":
        enabled = manager.IsEnabled(n"NewDpad") || manager.IsEnabled(n"NewVehicleRadio") || manager.IsEnabled(n"NewVehicleHotkey");
        break;
      case n"HotkeyConsumableWidgetController":
        enabled = manager.IsEnabled(n"NewDpad") || manager.IsEnabled(n"NewVehicleRadio") || manager.IsEnabled(n"NewCrystalCoat") || manager.IsEnabled(n"NewAutoDrive");
        break;
      case n"HotkeyCustomRadioWidgetController": enabled = manager.IsEnabled(n"NewVehicleRadio"); break;
      default: return;
    };
    if !enabled { return; };
    let presentation: ref<inkWidget> = HUDitorBindings.FindPresentation(manager, owner, owner.GetRootWidget());
    if !IsDefined(presentation) { return; };
    if !IsDefined(manager.surfaces) { manager.surfaces = HUDitorSurfaces.Create(manager.window); };
    manager.surfaces.Attach(owner, presentation);
  }

  private static func CollectPresentations(widget: ref<inkWidget>, out images: array<wref<inkWidget>>) -> Void {
    if Equals(widget.GetName(), n"HUDitorOverlay") || Equals(widget.GetName(), n"HUDitorSurfaces") { return; };
    let image: ref<inkImage> = widget as inkImage;
    if IsDefined(image) {
      ArrayPush(images, image);
      return;
    };
    let compound: ref<inkCompoundWidget> = widget as inkCompoundWidget;
    if IsDefined(compound) {
      let i: Int32 = 0;
      while i < compound.GetNumChildren() {
        HUDitorBindings.CollectPresentations(compound.GetWidgetByIndex(i), images);
        i += 1;
      };
    };
  }

  private static func FindPresentation(manager: ref<HUDWidgetsManager>, owner: ref<inkGameController>, source: ref<inkWidget>) -> ref<inkWidget> {
    let ancestor: ref<inkWidget> = source;
    while IsDefined(ancestor) {
      if ancestor == manager.window { return null; };
      ancestor = ancestor.parentWidget;
    };
    let name: CName;
    switch owner.GetClassName() {
      case n"QuestTrackerGameController": name = n"quest_list"; break;
      case n"gameuiMinimapContainerController": name = n"minimap"; break;
      case n"gameuiHudHealthbarGameController": name = n"player_health_bar"; break;
      case n"gameuiWeaponRosterGameController": name = n"ammo_counter"; break;
      case n"WantedBarGameController": name = n"wanted_bar"; break;
      case n"VehicleSummonWidgetGameController": name = n"vehicle_summon_notification"; break;
      case n"CrouchIndicatorGameController": name = n"crouch_indicator"; break;
      case n"StaminabarWidgetGameController": name = n"staminabar"; break;
      case n"hudCarController": name = n"car hud"; break;
      case n"BossHealthBarGameController": name = n"boss_healthbar"; break;
      case n"HUDProgressBarController": name = n"hud_progress_bar"; break;
      case n"gameuiInputHintManagerGameController": name = n"input_hint"; break;
      case n"HotkeysWidgetController": name = n"dpad_hint"; break;
      case n"HotkeyConsumableWidgetController": name = n"dpad_hint_consumables"; break;
      case n"HotkeyCustomRadioWidgetController": name = n"radio_custom"; break;
      default: return null;
    };
    for image in manager.presentations {
      if Equals(image.GetName(), name) { return image; };
    };
    return null;
  }
}

@addMethod(inkGameController)
protected cb func OnHijackSlotsEvent(evt: ref<HijackSlotsEvent>) -> Bool {
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if this.IsA(n"gameuiRootHudGameController") && IsDefined(manager) { manager.RequestBind(); };
}

@if(ModuleExists("FpsCounter"))
@addMethod(inkHUDGameController)
protected cb func OnReparentFpsCounterEvent(evt: ref<ReparentFpsCounterEvent>) -> Bool {
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) && manager.IsEnabled(n"NewFpsCounter") && this.IsA(n"gameuiFPSCounterGameController") { manager.RequestBind(); };
}

@if(ModuleExists("FpsCounter"))
@addMethod(inkHUDGameController)
protected cb func OnHuditorFpsCounterTrack(evt: ref<FPSCounterChangeStateEvent>) -> Bool {
  let manager: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
  if IsDefined(manager) && manager.IsEnabled(n"NewFpsCounter") && this.IsA(n"gameuiFPSCounterGameController") { manager.RequestBind(); };
}
