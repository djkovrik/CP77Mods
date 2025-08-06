import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>) -> Void
  public func ScheduleVictimsSpawn(destination: ref<TeleportData>) -> Void
  public func CancelScheduledVictimSpawns() -> Void
*/
public class TeleportVictimsHelper {

  private let player: wref<PlayerPuppet>;
  private let delaySystem: ref<DelaySystem>;
  private let preventionSystem: ref<PreventionSpawnSystem>;

  private let victimSpawnDelayId1: DelayID;
  private let victimSpawnDelayId2: DelayID;
  private let victimSpawnDelayId3: DelayID;
  private let victimSpawnDelayId4: DelayID;

  public func Init(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
    this.preventionSystem = GameInstance.GetPreventionSpawnSystem(player.GetGame());
  }

  public func ScheduleVictimsSpawn(destination: ref<TeleportData>) -> Void {
    let position: Vector4 = TeleportData.GetRandomCoordinates(destination);
    E(s"Victims - selected destination: \(position) at \(destination.district)");
    this.victimSpawnDelayId1 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.maleVictim), 0.1, true);
    this.victimSpawnDelayId2 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.femaleVictim), 0.2, true);
    this.victimSpawnDelayId3 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.maleVictim), 0.3, true);
    this.victimSpawnDelayId4 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.femaleVictim), 0.4, true);
  }

  public func CancelScheduledVictimSpawns() -> Void {
    E(s"Victims - Cancel spawns");
    this.delaySystem.CancelDelay(this.victimSpawnDelayId1);
    this.delaySystem.CancelDelay(this.victimSpawnDelayId2);
    this.delaySystem.CancelDelay(this.victimSpawnDelayId3);
    this.delaySystem.CancelDelay(this.victimSpawnDelayId4);
  }

  public func OnVictimSpawnCallback(position: Vector4, characterId: TweakDBID) -> Void {
    let randX: Float = RandRangeF(-2.5, 2.5);
    let randY: Float = RandRangeF(-2.5, 2.5);
    let newPosition: Vector4 = new Vector4(position.X + randX, position.Y + randY, position.Z, position.W);
    let worldTransform: WorldTransform;
    WorldTransform.SetPosition(worldTransform, newPosition);
    let requestId: Uint32 = this.preventionSystem.RequestUnitSpawn(characterId, worldTransform);
    this.preventionSystem.SaveSpawned(requestId);
    E(s"Victims - spawned \(requestId)");
  }
}

public class VictimsSpawnCallback extends DelayCallback {
  let position: Vector4;
  let characterId: TweakDBID;
  let helper: wref<TeleportVictimsHelper>;

  public static func Create(helper: ref<TeleportVictimsHelper>, position: Vector4, id: TweakDBID) -> ref<VictimsSpawnCallback> {
    let self: ref<VictimsSpawnCallback> = new VictimsSpawnCallback();
    self.helper = helper;
    self.position = position;
    self.characterId = id;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnVictimSpawnCallback(this.position, this.characterId);
  }
}
