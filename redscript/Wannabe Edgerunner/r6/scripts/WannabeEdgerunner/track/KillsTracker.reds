import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@addField(ScriptedPuppetPS)
public persistent let weHumanityKillProcessed: Bool;

@wrapMethod(ScriptedPuppet)
protected func RewardKiller(killer: wref<GameObject>, killType: gameKillType, isAnyDamageNonlethal: Bool) -> Void {
  let processKill: Bool = false;
  if !this.m_killRewardDisabled && IsDefined(killer as PlayerPuppet)
    && NotEquals(killType, gameKillType.Defeat) && !this.m_forceDefeatReward
    && Equals(this.GetNPCType(), gamedataNPCType.Human) {
    let state: ref<ScriptedPuppetPS> = this.GetPuppetPS();
    if IsDefined(state) && !state.weHumanityKillProcessed {
      // Claim before the wrapper chain can reenter; keep the claim across streaming/load.
      state.weHumanityKillProcessed = true;
      processKill = true;
    };
  };
  wrappedMethod(killer, killType, isAnyDamageNonlethal);
  if processKill {
    EdgerunningSystem.GetInstance(this.GetGame()).OnEnemyKilled(this.GetRecord().Affiliation().Type());
  };
}

@wrapMethod(PlayerSystem)
protected final cb func OnLocalPlayerPossesionChanged(playerPossesion: gamedataPlayerPossesion) -> Bool {
  wrappedMethod(playerPossesion);
  E(s"Player possession changed: \(playerPossesion)");
  EdgerunningSystem.GetInstance(this.GetGameInstance()).OnPossessionChanged(playerPossesion);
}
