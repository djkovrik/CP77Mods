import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E


public class TeleportingPreventionHelper {
  public func GetPlayer() -> wref<PlayerPuppet> { return this.player; }


  private let player: wref<PlayerPuppet>;
  private let config: ref<EdgerunningConfig>;
  private let delaySystem: ref<DelaySystem>;

  private let policeActivityDelayId: DelayID;

  public func Init(player: ref<PlayerPuppet>, config: ref<EdgerunningConfig>) -> Void {
    this.player = player;
    this.config = config;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
  }

  public func RefreshConfig(config: ref<EdgerunningConfig>) -> Void {
    this.config = config;
  }

  public func SchedulePoliceActivity(delay: Float) -> Void {
    E("Prevention - Schedule police flow");
    this.policeActivityDelayId = this.delaySystem.DelayCallback(LaunchPoliceActivityCallback.Create(this), delay, true);
  }

  public func CancelScheduledPreventionActivity() -> Void {
    E("Prevention - Cancel everything");
    this.delaySystem.CancelCallback(this.policeActivityDelayId);
    this.policeActivityDelayId = GetInvalidDelayID();
  }

  public func OnLaunchPoliceActivityCallback() -> Void {
    if !IsDefined(this.player) || !EdgerunningSystem.GetInstance(this.player.GetGame()).CanRequestPoliceActivity() {
      return;
    };

    E("Prevention - Launch police flow");
    this.player.GetPreventionSystem().SpawnPoliceForPsychosis(this.config);
  }

}

public class LaunchPoliceActivityCallback extends EdgerunningEpisodeCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<LaunchPoliceActivityCallback> {
    let self: ref<LaunchPoliceActivityCallback> = new LaunchPoliceActivityCallback();
    self.helper = helper;
    self.BindEpisode(helper.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.helper) {
      this.helper.OnLaunchPoliceActivityCallback();
    };
  }
}


