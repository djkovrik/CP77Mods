public class SleevesButtonController extends inkGameController {
  private let enabled: Bool;
  private let active: Bool;

  private let borderHovered: wref<inkWidget>;

  private let appearAnimDuration: Float = 0.2;
  private let appearAnimDelay: Float = 0.4;

  protected cb func OnInitialize() {
    this.InitializeWidgets();
    this.RegisterInputListeners();
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterInputListeners();
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    if this.enabled {
      this.SetHoveredState(true);
      this.PlaySound(n"Button", n"OnHover");
    };
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    if this.enabled {
      this.SetHoveredState(false);
    };
  }

  protected cb func OnClick(e: ref<inkPointerEvent>) -> Bool {
    if this.enabled && e.IsAction(n"click") {
      this.PlaySound(n"Button", n"OnPress");
      GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(new ShowSleevesPopupEvent());
    };
  }

  protected cb func OnRefreshSleevesButtonEvent(evt: ref<RefreshSleevesButtonEvent>) -> Bool {
    this.enabled = evt.enabled;
    this.active = evt.active;
    this.RefreshButtonState(evt.enabled, evt.active);
  }

  protected cb func OnShowSleevesButtonEvent(evt: ref<ShowSleevesButtonEvent>) -> Bool {
    let root: ref<inkWidget> = this.GetRootCompoundWidget();
    if evt.show {
      this.AnimateAppearance(root, this.appearAnimDuration, this.appearAnimDelay);
    } else {
      this.AnimateDisappearance(root, this.appearAnimDuration, 0.0);
    };
  }

  private final func InitializeWidgets() -> Void {
    this.borderHovered = this.GetRootCompoundWidget().GetWidgetByPathName(n"container/frameHovered");
  }

  private final func RegisterInputListeners() -> Void {
    this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnClick");
  }

  private final func UnregisterInputListeners() -> Void {
    this.UnregisterFromCallback(n"OnEnter", this, n"OnRelease");
    this.UnregisterFromCallback(n"OnLeave", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnClick");
  }

  private final func RefreshButtonState(enabled: Bool, active: Bool) -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let sleevesIconInactive: ref<inkWidget> = root.GetWidgetByPathName(n"container/iconInactive");
    let sleevesIconActive: ref<inkWidget> = root.GetWidgetByPathName(n"container/iconActive");
    let sleevesIconNotAvailable: ref<inkWidget> = root.GetWidgetByPathName(n"container/iconNotAvailable");

    if !enabled {
      // Not available
      sleevesIconNotAvailable.SetVisible(true);
      sleevesIconInactive.SetVisible(false);
      sleevesIconActive.SetVisible(false);
    } else if enabled && !active {
      // Available but not active
      sleevesIconInactive.SetVisible(true);
      sleevesIconActive.SetVisible(false);
      sleevesIconNotAvailable.SetVisible(false);
    } else if enabled && active {
      // Active
      sleevesIconActive.SetVisible(true);
      sleevesIconInactive.SetVisible(false);
      sleevesIconNotAvailable.SetVisible(false);
    };
  }

  private final func SetHoveredState(hovered: Bool) -> Void {
    this.borderHovered.SetVisible(hovered);
  }

  private final func AnimateAppearance(targetWidget: wref<inkWidget>, duration: Float, delay: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);

    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(Vector2(60.0, 0.0));
    translationInterpolator.SetEndTranslation(Vector2(0.0, 0.0));

    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    moveElementsAnimDef.AddInterpolator(translationInterpolator);
    proxy = targetWidget.PlayAnimation(moveElementsAnimDef);

    return proxy;
  }

  private final func AnimateDisappearance(targetWidget: wref<inkWidget>, duration: Float, delay: Float) -> ref<inkAnimProxy> {
    let proxy: ref<inkAnimProxy>;
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(1.0);
    transparencyInterpolator.SetEndTransparency(0.0);

    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(Vector2(0.0, 0.0));
    translationInterpolator.SetEndTranslation(Vector2(60.0, 0.0));

    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    moveElementsAnimDef.AddInterpolator(translationInterpolator);
    proxy = targetWidget.PlayAnimation(moveElementsAnimDef);

    return proxy;
  }
}
