import Edgerunning.System.EdgerunningSystem

// Refresh on player visible
@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  EdgerunningSystem.GetInstance(this.GetGame()).RefreshConfig();
}

// Refresh on pause menu exit
@wrapMethod(PauseMenuBackgroundGameController)
protected cb func OnUninitialize() -> Bool {
  EdgerunningSystem.GetInstance(this.GetPlayerControlledObject().GetGame()).RefreshConfig();
  wrappedMethod();
}

// Is Johnny
@addMethod(PlayerPuppet)
public func IsPossessedE() -> Bool {
  let posessed: Bool = Cast<Bool>(GameInstance.GetQuestsSystem(this.GetGame()).GetFactStr("isPlayerPossessedByJohnny"));
  return this.IsJohnnyReplacer() || posessed;
}

// CET command to stop FX effects
public static exec func EdgerunnerClear(gi: GameInstance) -> Void {
  EdgerunningSystem.GetInstance(gi).StopFX();
}
