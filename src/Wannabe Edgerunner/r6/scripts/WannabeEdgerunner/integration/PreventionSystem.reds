import Edgerunning.Common.E

@addField(PreventionSpawnSystem)
private let spawnedVictims: array<Uint32>;

@addField(PreventionSpawnSystem)
private let weVictimGeneration: Uint32;

@addMethod(PreventionSpawnSystem)
public final func WEGetVictimGeneration() -> Uint32 {
  return this.weVictimGeneration;
}

@addMethod(PreventionSpawnSystem)
public final func SaveSpawned(id: Uint32) -> Void {
  ArrayPush(this.spawnedVictims, id);
}

@addMethod(PreventionSpawnSystem)
public final func WECancelPendingVictims() -> Void {
  this.weVictimGeneration += 1u;
  let pending: array<Uint32> = this.spawnedVictims;
  // Drop ownership before native cancellation can dispatch a completion callback.
  ArrayClear(this.spawnedVictims);
  for id in pending { this.CancelSpawnRequest(id); };
}

@addMethod(PreventionSpawnSystem)
public final func DeleteSpawned(id: Uint32) -> Void {
  ArrayRemove(this.spawnedVictims, id);
}

@wrapMethod(PreventionSpawnSystem)
protected final func SpawnRequestFinished(requestResult: SpawnRequestResult) -> Void {
  wrappedMethod(requestResult);

  let id: Uint32 = requestResult.requestID;
  if ArrayContains(this.spawnedVictims, id) {
    this.DeleteSpawned(id);
    if !requestResult.success { return; };
    E(s"Victims - found \(id), kill!");
    let npc: ref<NPCPuppet>;
    for object in requestResult.spawnedObjects {
      npc = object as NPCPuppet;
      if IsDefined(npc) {
        npc.Kill(null, true, true);
        this.SpawnBloodPuddle(npc);
      };
    };
  };
}

@addMethod(PreventionSpawnSystem)
private func SpawnBloodPuddle(puppet: wref<ScriptedPuppet>) -> Void {
  if !IsDefined(puppet) || VehicleComponent.IsMountedToVehicle(puppet.GetGame(), puppet) {
    return;
  };
  let callback: ref<WEBloodPuddleCallback> = new WEBloodPuddleCallback();
  callback.owner = this;
  callback.generation = this.weVictimGeneration;
  callback.puppet = puppet;
  GameInstance.GetDelaySystem(puppet.GetGame()).DelayCallbackNextFrame(callback);
}

public class WEBloodPuddleCallback extends DelayCallback {
  public let owner: wref<PreventionSpawnSystem>;
  public let generation: Uint32;
  public let puppet: wref<ScriptedPuppet>;

  public func Call() -> Void {
    if !IsDefined(this.owner) || this.generation != this.owner.WEGetVictimGeneration() || !IsDefined(this.puppet) { return; };
    if VehicleComponent.IsMountedToVehicle(this.puppet.GetGame(), this.puppet) { return; };
    let evt: ref<BloodPuddleEvent> = new BloodPuddleEvent();
    evt.m_slotName = n"Chest";
    evt.cyberBlood = NPCManager.HasVisualTag(this.puppet, n"CyberTorso");
    this.puppet.QueueEvent(evt);
  }
}
