import Edgerunning.System.EdgerunningSystem

@wrapMethod(ScriptedPuppet)
protected func RewardKiller(killer: wref<GameObject>, killType: gameKillType, isAnyDamageNonlethal: Bool) -> Void {
  wrappedMethod(killer, killType, isAnyDamageNonlethal);
  let record: ref<Character_Record>;
  let affiliation: gamedataAffiliation;
  if !isAnyDamageNonlethal {
    record = this.GetRecord();
    affiliation = record.Affiliation().Type();
    EdgerunningSystem.GetInstance(this.GetGame()).OnEnemyKilled(affiliation);
  };
}
