module MetroPocketGuide.UI

public class TrackedRouteBaseItemController extends inkVirtualCompoundItemController {
  protected let visitedBlinkAnimDef: ref<inkAnimDef>;
  protected let visitedBlinkAnimProxy: ref<inkAnimProxy>;

  protected let visitedHideAnimDef: ref<inkAnimDef>;
  protected let visitedHideAnimProxy: ref<inkAnimProxy>;

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

  protected final func GetLineHDRColor(line: ModNCartLine) -> HDRColor {
    switch line {
      case ModNCartLine.A_RED: return new HDRColor(1.0, 0.266250998, 0.266250014, 1.0);
      case ModNCartLine.B_YELLOW: return new HDRColor(1.0, 0.981656015, 0.266250014, 1.0);
      case ModNCartLine.C_CYAN: return new HDRColor(0.0, 0.999997973, 1.0, 1.0);
      case ModNCartLine.D_GREEN: return new HDRColor(0.0974999964, 1.0, 0.187749997, 1.0);
      case ModNCartLine.E_ORANGE: return new HDRColor(0.917500019, 0.410138994, 0.0539029986, 1.0);
    };

    return new HDRColor(1.0, 1.0, 1.0, 1.0);
  }

  protected final func GetLinePartName(line: ModNCartLine) -> CName {
    switch line {
      case ModNCartLine.A_RED: return n"line-a";
      case ModNCartLine.B_YELLOW: return n"line-b";
      case ModNCartLine.C_CYAN: return n"line-c";
      case ModNCartLine.D_GREEN: return n"line-d";
      case ModNCartLine.E_ORANGE: return n"line-e";
    };

    return n"line-a";
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
    let singleAnimDuration: Float = 0.75;
    this.visitedBlinkAnimDef = new inkAnimDef();
    let firstInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, 0.1, singleAnimDuration, 0.0);
    let secondInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(0.1, 1.0, singleAnimDuration, singleAnimDuration);
    this.visitedBlinkAnimDef.AddInterpolator(firstInterpolator);
    this.visitedBlinkAnimDef.AddInterpolator(secondInterpolator);

    this.visitedHideAnimDef = new inkAnimDef();
    let hideInterpolator: ref<inkAnimInterpolator> = this.GetTransparencyInterpolator(1.0, 0.2, singleAnimDuration, 0.0);
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
