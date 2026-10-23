@wrapMethod(SingleplayerMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  CheckForLimitedHudDepot();
}

@if(ModuleExists("Codeware"))
public func CheckForLimitedHudDepot() -> Void {
  let depot: ref<ResourceDepot> = GameInstance.GetResourceDepot();
  if !depot.ArchiveExists("LimitedHUD.archive") {
    FTLog("Warning: LimitedHUD.archive file not found! Check your Cyberpunk 2077\\archive\\pc\\mod folder.");
  };
}

@if(!ModuleExists("Codeware"))
public final func CheckForLimitedHudDepot() -> Void {}
