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

// Skip Breaching (instead of -skipStartScreen)
@wrapMethod(EngagementScreenGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  let evt: ref<inkMenuLayer_SetCursorVisibility>;
  let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
  uiSystem.PushGameContext(UIGameContext.Default);
  uiSystem.RequestNewVisualState(n"inkPauseMenuState");
  evt = new inkMenuLayer_SetCursorVisibility();
  evt.Init(true);
  this.QueueEvent(evt);

  this.m_menuEventDispatcher.SpawnEvent(n"OnBreachingSkip");
}

@addMethod(MenuScenario_PreGameSubMenu)
protected cb func OnBreachingSkip() -> Bool {
  let evt: ref<ShowEngagementScreen> = new ShowEngagementScreen();
  evt.show = false;
  this.OnHandleEngagementScreen(evt);
}
