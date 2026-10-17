import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

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
  return this.m_districtManager.GetCurrentDistrict().GetDistrictRecord().Type();
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

// Check for cutscene starting
@wrapMethod(PlayerPuppet)
protected cb func OnSceneTierChange(newState: Int32) -> Bool {
  wrappedMethod(newState);
  if EdgerunningSystem.GetInstance(this.GetGame()).GetPlayer() != this { return false; };
  E(s"-> Scene tier \(this.m_sceneTier)");
  if newState >= 3 && newState <= 5 {
    EdgerunningSystem.GetInstance(this.GetGame()).StopEverythingNew();
  } else {
    EdgerunningSystem.GetInstance(this.GetGame()).InvalidateCurrentState();
  };
}
