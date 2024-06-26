import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@wrapMethod(ScriptedPuppet)
protected func RewardKiller(killer: wref<GameObject>, killType: gameKillType, isAnyDamageNonlethal: Bool) -> Void {
  wrappedMethod(killer, killType, isAnyDamageNonlethal);

  let record: ref<Character_Record> = this.GetRecord();
  let affiliation: gamedataAffiliation = record.Affiliation().Type();
  let type: ENeutralizeType;

  if IsDefined(killer as PlayerPuppet) {
    if Equals(killType, gameKillType.Defeat) || this.m_forceDefeatReward {
      if isAnyDamageNonlethal {
        type = ENeutralizeType.Unconscious;
      } else {
        type = ENeutralizeType.Defeated;
      };
    } else {
      type = ENeutralizeType.Killed;
    };

    E(s"Reward killer: target - \(affiliation), killType: \(killType), neutralizeType: \(type), NPC type: \(this.GetNPCType())");
    if Equals(type, ENeutralizeType.Killed) && Equals(this.GetNPCType(), gamedataNPCType.Human) {
      EdgerunningSystem.GetInstance(this.GetGame()).OnEnemyKilled(affiliation);
    };
  };
}

@wrapMethod(PlayerSystem)
protected final cb func OnLocalPlayerPossesionChanged(playerPossesion: gamedataPlayerPossesion) -> Bool {
  wrappedMethod(playerPossesion);
  E(s"Player possession changed: \(playerPossesion)");
  EdgerunningSystem.GetInstance(this.GetGameInstance()).OnPossessionChanged(playerPossesion);
}
