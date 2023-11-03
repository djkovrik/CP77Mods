module Edgerunning.Controller

public class NewHumanityBarItemController extends inkGameController {

  private let bar: ref<inkWidget>;

  private let root: wref<inkWidget>;

  private let sizeAnimation: ref<inkAnimProxy>;

  private let meterWidth: Float;

  private let pulse: ref<PulseAnimation>;

  protected cb func OnInitialize() {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.bar = root.GetWidgetByPathName(n"bar");
    this.root = this.GetRootWidget();
  }

  public final func SetSizeAnimation(size: Float, sizeOffset: Float, delay: Float, duration: Float) -> Void {
    let animation: ref<inkAnimDef>;
    let endScale: Vector2;
    let marginInterpolator: ref<inkAnimScale>;
    let options: inkAnimOptions;
    let startScale: Vector2;
    if this.sizeAnimation != null {
      this.sizeAnimation.Stop();
    };
    startScale = this.bar.GetScale();
    endScale.X = size + sizeOffset;
    endScale.Y = 1.0;
    animation = new inkAnimDef();
    marginInterpolator = new inkAnimScale();
    marginInterpolator.SetType(inkanimInterpolationType.Quintic);
    marginInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    marginInterpolator.SetDuration(duration);
    marginInterpolator.SetUseRelativeDuration(true);
    marginInterpolator.SetStartScale(startScale);
    marginInterpolator.SetEndScale(endScale);
    animation.AddInterpolator(marginInterpolator);
    options.executionDelay = MaxF(delay, 0.0);
    this.sizeAnimation = this.bar.PlayAnimationWithOptions(animation, options);
  }

  public final func SetSize(size: Float) -> Void {
    let endScale: Vector2;
    endScale.X = size;
    endScale.Y = 1.0;
    this.bar.SetScale(endScale);
  }

  public final func StartPulse(params: PulseAnimationParams) -> Void {
    if IsDefined(this.pulse) {
      this.pulse.ForceStop();
    };
    this.pulse = new PulseAnimation();
    this.pulse.Configure(this.bar, params);
    this.pulse.Start(false);
  }

  public final func StopPulse() -> Void {
    this.bar.StopAllAnimations();
  }

  public final func GetHeight() -> Float {
    let size: Vector2 = this.bar.GetSize();
    return size.Y;
  }

  public final func GetMargin(margin: String) -> Float {
    let margins: inkMargin = this.root.GetMargin();
    switch margin {
      case "left":
        return margins.left;
      case "top":
        return margins.top;
      case "right":
        return margins.right;
      case "bottom":
        return margins.bottom;
      default:
        return 0.0;
    };
  }
}
