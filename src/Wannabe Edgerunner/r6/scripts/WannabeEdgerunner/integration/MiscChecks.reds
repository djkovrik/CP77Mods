import Edgerunning.System.EdgerunningSystem

// Check prologue
@addMethod(PlayerPuppet)
public func IsPrologueFinished() -> Bool {
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  let prologueFact: Int32 = questsSystem.GetFact(n"watson_prolog_unlock");
  return Equals(prologueFact, 1);
}

// Get discrict name
@addMethod(PreventionSystem)
public func GetCurrentDistrictForEdgerunner() -> gamedataDistrict {
  return this.m_districtManager.GetCurrentDistrict().CreateDistrictRecord().Type();
}

// Not used - kept for Humanity Recovery compatibility
@addMethod(PlayerPuppet)
public func IsPossessedE() -> Bool {
  let playerSystem: ref<PlayerSystem> = GameInstance.GetPlayerSystem(this.GetGame());
  let puppet: ref<PlayerPuppet> = playerSystem.GetLocalPlayerMainGameObject() as PlayerPuppet;
  let factName: String = playerSystem.GetPossessedByJohnnyFactName();
  let posessed: Bool = GameInstance.GetQuestsSystem(this.GetGame()).GetFactStr(factName) == 1;
  let isReplacer: Bool = puppet.IsJohnnyReplacer();
  return isReplacer || posessed;
}
