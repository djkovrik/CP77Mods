import Edgerunning.System.EdgerunningSystem

// Check prologue
@addMethod(PlayerPuppet)
public func IsPrologueFinishedE() -> Bool {
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  let prologueFact: Int32 = questsSystem.GetFact(n"watson_prolog_unlock");
  return Equals(prologueFact, 1);
}

// Get discrict name
@addMethod(PreventionSystem)
public func GetDistrictE() -> gamedataDistrict {
  return this.m_districtManager.GetCurrentDistrict().CreateDistrictRecord().Type();
}

// Cancel scheduled teleport on player death
@wrapMethod(ScriptedPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
  wrappedMethod(evt);
  if this.IsPlayer() {
    EdgerunningSystem.GetInstance(this.GetGame()).RemoveAllEffects();
    EdgerunningSystem.GetInstance(this.GetGame()).ClearTeleportDelays();
  };
}
