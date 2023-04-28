@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.SpawnAtelierButtonHints();
}

@addMethod(gameuiInGameMenuGameController)
private func SpawnAtelierButtonHints() -> Void {
  let inkSystem: ref<inkSystem> = GameInstance.GetInkSystem();
  let hudRoot: ref<inkCompoundWidget> = inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  hudRoot.RemoveChildByName(n"AtelierButtonHints");

  let container: ref<inkCanvas> = new inkCanvas();
  container.SetName(n"AtelierButtonHints");
  container.SetAnchor(inkEAnchor.BottomCenter);
  container.SetAnchorPoint(0.0, 1.0);
  container.SetSize(400.0, 100.0);
  container.SetScale(new Vector2(0.666, 0.666));
  container.SetMargin(new inkMargin(160.0, 0.0, 0.0, 20.0));
  container.Reparent(hudRoot);
  this.SpawnFromExternal(container, r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
}
