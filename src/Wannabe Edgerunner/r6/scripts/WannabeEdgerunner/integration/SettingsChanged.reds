import Edgerunning.System.EdgerunningSystem

@wrapMethod(PauseMenuGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).OnSettingsChanged();
}
