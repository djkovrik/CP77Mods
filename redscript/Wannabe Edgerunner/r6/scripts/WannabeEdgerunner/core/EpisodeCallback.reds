import Edgerunning.System.EdgerunningSystem

public enum EdgerunningPhase {
  Idle = 0,
  PrePsychosis = 1,
  Psychosis = 2,
  Blackout = 3,
  Recovery = 4,
}

public class EdgerunningEpisodeCallback extends DelayCallback {
  private let episodeSystem: wref<EdgerunningSystem>;
  private let episodePlayer: wref<PlayerPuppet>;
  private let episodeGeneration: Uint32;

  public func BindEpisode(player: wref<PlayerPuppet>) -> Void {
    this.episodePlayer = player;
    if IsDefined(player) {
      this.episodeSystem = EdgerunningSystem.GetInstance(player.GetGame());
      this.episodeGeneration = this.episodeSystem.GetGeneration();
    };
  }

  public func IsCurrentEpisode() -> Bool {
    return IsDefined(this.episodeSystem) && this.episodeSystem.IsCallbackCurrent(this.episodeGeneration, this.episodePlayer);
  }
}
