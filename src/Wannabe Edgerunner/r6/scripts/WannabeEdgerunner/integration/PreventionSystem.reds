import Edgerunning.Common.E

@addField(PreventionSpawnSystem)
private let spawnedVictims: array<Uint32>;

@addMethod(PreventionSpawnSystem)
public final func SaveSpawned(id: Uint32) -> Void {
  ArrayPush(this.spawnedVictims, id);
}

@addMethod(PreventionSpawnSystem)
public final func DeleteSpawned(id: Uint32) -> Void {
  ArrayRemove(this.spawnedVictims, id);
}

@addMethod(PreventionSpawnSystem)
public final func ClearSpawned() -> Void {
  ArrayClear(this.spawnedVictims);
}

@wrapMethod(PreventionSpawnSystem)
protected final func SpawnRequestFinished(requestResult: SpawnRequestResult) -> Void {
  wrappedMethod(requestResult);

  let id: Uint32 = requestResult.requestID;
  if ArrayContains(this.spawnedVictims, id) && requestResult.success {
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
  let evt: ref<BloodPuddleEvent> = new BloodPuddleEvent();
  if !IsDefined(puppet) || VehicleComponent.IsMountedToVehicle(puppet.GetGame(), puppet) {
    return;
  };
  evt = new BloodPuddleEvent();
  evt.m_slotName = n"Chest";
  evt.cyberBlood = NPCManager.HasVisualTag(puppet, n"CyberTorso");
  GameInstance.GetDelaySystem(puppet.GetGame()).DelayEventNextFrame(puppet, evt);
}