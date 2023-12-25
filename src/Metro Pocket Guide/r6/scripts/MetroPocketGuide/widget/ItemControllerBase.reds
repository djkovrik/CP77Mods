module MetroPocketGuide.UI

public class TrackedRouteBaseItemController extends inkVirtualCompoundItemController {
  protected let visitedBlinkAnimDef: ref<inkAnimDef>;
  protected let visitedBlinkAnimProxy: ref<inkAnimProxy>;

  protected let visitedHideAnimDef: ref<inkAnimDef>;
  protected let visitedHideAnimProxy: ref<inkAnimProxy>;

  protected let singleAnimDuration: Float = 0.75;

  protected cb func OnInitialize() -> Bool {
    this.InitializeVisitedAnims();
  }

  protected cb func OnUninitialize() -> Bool {
    this.visitedBlinkAnimProxy.Stop();
    this.visitedBlinkAnimProxy = null;
    this.visitedBlinkAnimDef = null;
    this.visitedHideAnimProxy.Stop();
    this.visitedHideAnimProxy = null;
    this.visitedHideAnimDef = null;
  }

  protected func AnimateVisited() -> Void {
    let options: inkAnimOptions;
    options.loopCounter = 3u;
    options.loopType = inkanimLoopType.Cycle;

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.visitedBlinkAnimProxy.Stop();
    this.visitedBlinkAnimProxy = root.PlayAnimationWithOptions(this.visitedBlinkAnimDef, options);
    this.visitedBlinkAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnVisitedAnimFinished");
  }

  protected cb func OnVisitedAnimFinished(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnVisitedAnimFinished");

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.visitedHideAnimProxy.Stop();
    this.visitedBlinkAnimProxy = root.PlayAnimation(this.visitedHideAnimDef);
  }

  protected func Dim() -> Void {
    this.GetRootCompoundWidget().SetOpacity(0.2);
  }

  private final func InitializeVisitedAnims() -> Void {
    this.visitedBlinkAnimDef = new inkAnimDef();
    let firstInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, 0.1, this.singleAnimDuration, 0.0);
    let secondInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(0.1, 1.0, this.singleAnimDuration, this.singleAnimDuration);
    this.visitedBlinkAnimDef.AddInterpolator(firstInterpolator);
    this.visitedBlinkAnimDef.AddInterpolator(secondInterpolator);

    this.visitedHideAnimDef = new inkAnimDef();
    let hideInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, 0.2, this.singleAnimDuration, 0.0);
    this.visitedHideAnimDef.AddInterpolator(hideInterpolator);
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
