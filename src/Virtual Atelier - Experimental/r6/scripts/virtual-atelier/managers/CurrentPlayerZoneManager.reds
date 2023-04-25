import VendorPreview.Config.VirtualAtelierConfig

public class CurrentPlayerZoneManager {

  public static func IsInSafeZone(player: ref<PlayerPuppet>) -> Bool {
    if VirtualAtelierConfig.DisableDangerZoneChecker() {
      return false;
    };
    
    let bb: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let safeZone: Bool = zone < 3;
    return safeZone;
  }
}
