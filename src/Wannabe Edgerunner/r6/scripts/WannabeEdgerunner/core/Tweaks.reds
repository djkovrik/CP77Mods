import Edgerunning.System.EdgerunningSystem

// Is Johnny
@addMethod(ScriptedPuppet)
public func IsPossessedE() -> Bool {
  let posessed: Bool = Cast<Bool>(GameInstance.GetQuestsSystem(this.GetGame()).GetFactStr("isPlayerPossessedByJohnny"));
  let isReplacer: Bool = this.GetRecord().GetID() == t"Character.johnny_replacer";
  return isReplacer || posessed;
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
