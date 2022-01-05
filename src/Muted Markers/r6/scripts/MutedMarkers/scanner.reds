@addMethod(HUDManager)
public func IsScannerActive_MM() -> Bool {
  return Equals(this.m_activeMode, ActiveMode.FOCUS);
}

@addField(GameplayRoleComponent)
let m_hudManager_MM: ref<HUDManager>;

@addMethod(GameplayRoleComponent)
public func IsScannerActive_MM() -> Bool {
  return this.m_hudManager_MM.IsScannerActive_MM();
}

@wrapMethod(GameplayRoleComponent)
protected final func OnGameAttach() -> Void {
  wrappedMethod();
  this.m_hudManager_MM = (GameInstance.GetScriptableSystemsContainer(this.GetOwner().GetGame()).Get(n"HUDManager") as HUDManager);
}
