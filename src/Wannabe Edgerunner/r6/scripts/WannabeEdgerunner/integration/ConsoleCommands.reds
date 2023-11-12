import Edgerunning.System.EdgerunningSystem

// CET command to stop FX effects - Game.EdgerunnerClear()
public static exec func EdgerunnerClear(gi: GameInstance) -> Void {
  EdgerunningSystem.GetInstance(gi).StopEverythingNew();
}

// CET command to get current coords - Game.GetDistrict()
public static exec func GetDistrict(gi: GameInstance) -> Void {
  let player: ref<PlayerPuppet> = GetPlayer(gi);
  let district: gamedataDistrict = player.GetPreventionSystem().GetCurrentDistrictForEdgerunner();
  FTLog(s"Position: \(player.GetWorldPosition()) , district: \(district)");
}

// CET commant to teleport player to give x y z coords - Game.TeleportTo(x, y, z)
public static exec func TeleportTo(gi: GameInstance, x: Float, y: Float, z: Float) -> Void {
  let player: ref<PlayerPuppet> = GetPlayer(gi);
  let rotation: EulerAngles;
  let position: Vector4;
  position.X = x;
  position.Y = y;
  position.Z = z;
  GameInstance.GetTeleportationFacility(gi).Teleport(player, position, rotation);
}
