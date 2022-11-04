import VendorPreview.utils.*

public class CurrentPlayerZoneManager {

  public static func IsInDangerZone(player: ref<PlayerPuppet>) -> Bool {
    let bb: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let zone: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let inDanger: Bool = zone > 2;
    AtelierDebug(s"Detected zone: \(zone)");
    return inDanger;
  }
}
