module VirtualAtelier.Helpers
import VirtualAtelier.Config.VirtualAtelierConfig

public abstract class CurrentPlayerZoneHelper {

  public static func IsInSafeZone(player: ref<PlayerPuppet>, config: ref<VirtualAtelierConfig>) -> Bool {
    if config.disableDangerZoneChecker { return false; };
    let bb: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let safeZone: Bool = zone < 3;
    return safeZone;
  }
}
