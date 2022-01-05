private class RemoveCrouchEvent extends Event {}

@wrapMethod(CrouchIndicatorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(new RemoveCrouchEvent());
}

@addMethod(inkGameController)
protected cb func OnRemoveCrouchEvent(evt: ref<RemoveCrouchEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let BottomRightHorizontalSlot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal")) as inkCompoundWidget;
    let crouchIndicatorRef: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal", n"crouch_indicator")) as inkWidget;
    BottomRightHorizontalSlot.RemoveChild(crouchIndicatorRef);
  };
}
