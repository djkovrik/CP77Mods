import LimitedHudConfig.LHUDAddonsConfig

private class RemoveCrouchEvent extends Event {}

@wrapMethod(CrouchIndicatorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let callback: ref<LHUDHideCrouchCallback>;
  if config.HideCrouchIndicator {
    callback = new LHUDHideCrouchCallback();
    callback.uiSystem = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
    GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame()).DelayCallback(callback, 0.1);
  };
}

public class LHUDHideCrouchCallback extends DelayCallback {
  public let uiSystem: wref<UISystem>;

  public func Call() -> Void {
    this.uiSystem.QueueEvent(new RemoveCrouchEvent());
  }
}

@addMethod(inkGameController)
protected cb func OnRemoveCrouchEvent(evt: ref<RemoveCrouchEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    RemoveCrouchFromHUD(root);
  };
}

@if(ModuleExists("HUDrag.HUDWidgetsManager"))
func RemoveCrouchFromHUD(root: ref<inkCompoundWidget>) -> Void {
  let bottomRightHorizontalSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"NewWeaponCrouch", n"BottomRightHorizontal")) as inkCompoundWidget;
  let crouchIndicator: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"NewWeaponCrouch", n"BottomRightHorizontal", n"crouch_indicator")) as inkWidget;
  bottomRightHorizontalSlot.RemoveChild(crouchIndicator);
}

@if(!ModuleExists("HUDrag.HUDWidgetsManager"))
func RemoveCrouchFromHUD(root: ref<inkCompoundWidget>) -> Void {
  let BottomRightHorizontalSlot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal")) as inkCompoundWidget;
  let crouchIndicatorRef: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal", n"crouch_indicator")) as inkWidget;
  BottomRightHorizontalSlot.RemoveChild(crouchIndicatorRef);
}
