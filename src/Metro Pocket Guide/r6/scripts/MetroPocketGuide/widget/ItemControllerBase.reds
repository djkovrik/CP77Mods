module MetroPocketGuide.UI

public class TrackedRouteBaseItemController extends inkVirtualCompoundItemController {
  protected let activeBlinkAnimDef: ref<inkAnimDef>;
  protected let activeBlinkAnimProxy: ref<inkAnimProxy>;

  protected let visitedHideAnimDef: ref<inkAnimDef>;
  protected let visitedHideAnimProxy: ref<inkAnimProxy>;

  protected let singleAnimDuration: Float = 0.75;
  protected let hiddenOpacity: Float = 0.2;

  protected cb func OnInitialize() -> Bool {
    this.InitializeAnimDefs();
  }

  private final func InitializeAnimDefs() -> Void {
    this.activeBlinkAnimDef = new inkAnimDef();
    let firstInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, 0.1, this.singleAnimDuration, 0.0);
    let secondInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(0.1, 1.0, this.singleAnimDuration, this.singleAnimDuration);
    this.activeBlinkAnimDef.AddInterpolator(firstInterpolator);
    this.activeBlinkAnimDef.AddInterpolator(secondInterpolator);

    this.visitedHideAnimDef = new inkAnimDef();
    let hideInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, this.hiddenOpacity, this.singleAnimDuration, 0.0);
    this.visitedHideAnimDef.AddInterpolator(hideInterpolator);
  }

  protected cb func OnUninitialize() -> Bool {
    this.activeBlinkAnimProxy.Stop();
    this.activeBlinkAnimProxy = null;
    this.activeBlinkAnimDef = null;
    this.visitedHideAnimProxy.Stop();
    this.visitedHideAnimProxy = null;
    this.visitedHideAnimDef = null;
  }

  protected func AnimateVisitedTransparency() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.visitedHideAnimProxy.Stop();
    this.visitedHideAnimProxy = root.PlayAnimation(this.visitedHideAnimDef);
  }

  protected func AnimateActivatedBlink() -> Void {
    let options: inkAnimOptions;
    options.loopCounter = 3u;
    options.loopType = inkanimLoopType.Cycle;

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.activeBlinkAnimProxy.Stop();
    this.activeBlinkAnimProxy = root.PlayAnimationWithOptions(this.activeBlinkAnimDef, options);
  }

  protected func Dim() -> Void {
    this.GetRootCompoundWidget().SetOpacity(this.hiddenOpacity);
  }

  private final func GetTransparencyInterpolator(startAlpha: Float, endAlpha: Float, duration: Float, delay: Float) -> ref<inkAnimInterpolator> {
    let interpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    interpolator.SetStartTransparency(startAlpha);
    interpolator.SetEndTransparency(endAlpha);
    interpolator.SetDuration(duration);
    interpolator.SetStartDelay(delay);
    interpolator.SetType(inkanimInterpolationType.Linear);
    interpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    return interpolator;
  }
}
