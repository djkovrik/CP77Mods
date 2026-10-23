@if(!ModuleExists("Codeware"))
public native class SplashScreenLoadingScreenLogicController extends ILoadingLogicController {
  public native let logosTrainAnimation: CName;
  public native let localizedMessageAnimation: CName;
  public native let gameIntroAnimation: CName;
  public native let longLogosTrainAnimation: CName;

  protected cb func OnInitialize() -> Bool {
    this.logosTrainAnimation = n"after_skip_pressed";
    this.localizedMessageAnimation = n"after_skip_pressed";
    this.gameIntroAnimation = n"after_skip_pressed";
    this.longLogosTrainAnimation = n"after_skip_pressed";
  }
}

@if(ModuleExists("Codeware"))
@addMethod(ILoadingLogicController)
protected cb func OnInitialize() -> Bool {
  if this.IsA(n"inkSplashScreenLoadingScreenLogicController") {
    let controller: ref<SplashScreenLoadingScreenLogicController> = this as SplashScreenLoadingScreenLogicController;
    controller.logosTrainAnimation = n"after_skip_pressed";
    controller.localizedMessageAnimation = n"after_skip_pressed";
    controller.gameIntroAnimation = n"after_skip_pressed";
    controller.longLogosTrainAnimation = n"after_skip_pressed";
  };
}
