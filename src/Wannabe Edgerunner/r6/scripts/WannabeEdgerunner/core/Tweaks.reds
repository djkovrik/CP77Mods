import Edgerunning.System.EdgerunningSystem

// Refresh on player visible
// @wrapMethod(PlayerPuppet)
// protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
//   wrappedMethod(evt);
//   EdgerunningSystem.GetInstance(this.GetGame()).InvalidateCurrentState();
// }

// Is Johnny
@addMethod(PlayerPuppet)
public func IsPossessedE() -> Bool {
  let posessed: Bool = Cast<Bool>(GameInstance.GetQuestsSystem(this.GetGame()).GetFactStr("isPlayerPossessedByJohnny"));
  return this.IsJohnnyReplacer() || posessed;
}

// Check prologue
@addMethod(PlayerPuppet)
public func IsPrologFinishedE() -> Bool {
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  let prologueFact: Int32 = questsSystem.GetFact(n"watson_prolog_unlock");
  return Equals(prologueFact, 1);
}

@addMethod(PreventionSystem)
public func GetDistrictE() -> gamedataDistrict {
  return this.m_districtManager.GetCurrentDistrict().CreateDistrictRecord().Type();
}
