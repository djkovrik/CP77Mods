import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>) -> Void
  public func ScheduleVictimsSpawn(destination: ref<TeleportData>) -> Void
  public func CancelScheduledVictimSpawns() -> Void
  public func CancelScheduledVictimKills() -> Void
*/
public class TeleportVictimsHelper {

  private let player: wref<PlayerPuppet>;
  private let delaySystem: ref<DelaySystem>;

  private let victimSpawnDelayId1: DelayID;
  private let victimSpawnDelayId2: DelayID;
  private let victimSpawnDelayId3: DelayID;
  private let victimSpawnDelayId4: DelayID;

  private let killRequests: array<DelayID>;

  public func Init(player: ref<PlayerPuppet>) -> Void {
    this.player = player;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
  }

  public func ScheduleVictimsSpawn(destination: ref<TeleportData>) -> Void {
    let position: Vector4 = TeleportData.GetRandomCoordinates(destination);
    E(s"Victims - selected destination: \(position) at \(destination.district)");
    this.victimSpawnDelayId1 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.maleVictim), 0.1, false);
    this.victimSpawnDelayId2 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.femaleVictim), 0.2, false);
    this.victimSpawnDelayId3 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.maleVictim), 0.3, false);
    this.victimSpawnDelayId4 = this.delaySystem.DelayCallback(VictimsSpawnCallback.Create(this, position, destination.femaleVictim), 0.4, false);
  }

  public func CancelScheduledVictimSpawns() -> Void {
    E(s"Victims - Cancel spawns");
    this.delaySystem.CancelDelay(this.victimSpawnDelayId1);
    this.delaySystem.CancelDelay(this.victimSpawnDelayId2);
    this.delaySystem.CancelDelay(this.victimSpawnDelayId3);
    this.delaySystem.CancelDelay(this.victimSpawnDelayId4);
  }

  public func CancelScheduledVictimKills() -> Void{
    E(s"Victims - Cancel kills");
    for request in this.killRequests {
      this.delaySystem.CancelDelay(request);
    };
    ArrayClear(this.killRequests);
  }

  private func OnVictimSpawnCallback(position: Vector4, characterId: TweakDBID) -> Void {
    let randX: Float = RandRangeF(-2.5, 2.5);
    let randY: Float = RandRangeF(-2.5, 2.5);
    let newPosition: Vector4 = new Vector4(position.X + randX, position.Y + randY, position.Z, position.W);
    let worldTransform: WorldTransform;
    WorldTransform.SetPosition(worldTransform, newPosition);
    let entityId: EntityID = GameInstance.GetPreventionSpawnSystem(this.player.GetGame()).RequestSpawn(characterId, 5u, worldTransform);
    let killCallback: ref<VictimKillCallback> = VictimKillCallback.Create(this, entityId);
    E(s"Victims - spawn \(TDBID.ToStringDEBUG(characterId)) at position \(newPosition)");

    let delayId: DelayID = this.delaySystem.DelayCallback(killCallback, 0.05, false);
    ArrayPush(this.killRequests, delayId);
  }

  private func OnVictimKillCallback(entityId: EntityID) -> Void {
    let npc: ref<NPCPuppet> = GameInstance.FindEntityByID(this.player.GetGame(), entityId) as NPCPuppet;
    if IsDefined(npc) {
      npc.Kill(null, true, true);
      this.SpawnBloodPuddle(npc);
      E("Victim - spawned - kill");
    } else {
      let delayId: DelayID = this.delaySystem.DelayCallback(VictimKillCallback.Create(this, entityId),  0.05, false);
      ArrayPush(this.killRequests, delayId);
    };
  }

  private func SpawnBloodPuddle(puppet: wref<ScriptedPuppet>) -> Void {
    let evt: ref<BloodPuddleEvent> = new BloodPuddleEvent();
    if !IsDefined(puppet) || VehicleComponent.IsMountedToVehicle(puppet.GetGame(), puppet) {
      return;
    };
    evt = new BloodPuddleEvent();
    evt.m_slotName = n"Chest";
    evt.cyberBlood = NPCManager.HasVisualTag(puppet, n"CyberTorso");
    GameInstance.GetDelaySystem(puppet.GetGame()).DelayEventNextFrame(puppet, evt);
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

public class VictimKillCallback extends DelayCallback {
  let entityId: EntityID;
  let helper: wref<TeleportVictimsHelper>;

  public static func Create(helper: ref<TeleportVictimsHelper>, entityId: EntityID) -> ref<VictimKillCallback> {
    let self: ref<VictimKillCallback> = new VictimKillCallback();
    self.helper = helper;
    self.entityId = entityId;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnVictimKillCallback(this.entityId);
  }
}
