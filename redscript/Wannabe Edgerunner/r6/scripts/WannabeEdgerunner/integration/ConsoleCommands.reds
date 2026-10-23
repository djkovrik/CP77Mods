import Edgerunning.System.EdgerunningSystem

public exec func EdgerunnerPsychosisCombat(gi: GameInstance, shoot: Bool, outline: Bool, opt excludeCivilians: Bool) -> Void {
  EdgerunningSystem.GetInstance(gi).ConfigurePsychosisCombat(shoot, outline, excludeCivilians);
}

public exec func EdgerunnerPsychosisCombatStatus(gi: GameInstance) -> Void {
  EdgerunningSystem.GetInstance(gi).PrintPsychosisCombatStatus();
}

@if(ModuleExists("WannabeEdgerunnerDebug"))
public exec func EdgerunnerPsychosisCombatStart(gi: GameInstance) -> Void {
  EdgerunningSystem.GetInstance(gi).RunPsychosisFlow();
}

// One-shot emergency cleanup: Game.EdgerunnerClear().
public exec func EdgerunnerClear(gi: GameInstance) -> Void {
  let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(gi);
  if !IsDefined(system) {
    FTLog("EdgerunnerClear: system unavailable; load a game with Wannabe Edgerunner enabled.");
    return;
  };
  system.EmergencyClear();
}

// CET command to get current coords - Game.GetDistrict()
public exec func GetDistrict(gi: GameInstance) -> Void {
  let player: ref<PlayerPuppet> = GetPlayer(gi);
  let district: gamedataDistrict = player.GetPreventionSystem().GetCurrentDistrictForEdgerunner();
  FTLog(s"Position: \(player.GetWorldPosition()) , district: \(district)");
}

// CET commant to teleport player to give x y z coords - Game.TeleportTo(x, y, z)
public exec func TeleportTo(gi: GameInstance, x: Float, y: Float, z: Float) -> Void {
  let player: ref<PlayerPuppet> = GetPlayer(gi);
  let rotation: EulerAngles;
  let position: Vector4;
  position.X = x;
  position.Y = y;
  position.Z = z;
  GameInstance.GetTeleportationFacility(gi).Teleport(player, position, rotation);
}
