@addMethod(HUDManager)
public func IsScannerActive_MM() -> Bool {
  return Equals(this.m_activeMode, ActiveMode.FOCUS);
}

@addMethod(GameplayRoleComponent)
public func IsScannerActive_MM() -> Bool {
  return this.hudManager_mm.IsScannerActive_MM();
}

@wrapMethod(GameplayRoleComponent)
protected final func OnGameAttach() -> Void {
  wrappedMethod();
  this.hudManager_mm = (GameInstance.GetScriptableSystemsContainer(this.GetOwner().GetGame()).Get(n"HUDManager") as HUDManager);
}
