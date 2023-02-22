import Edgerunning.System.EdgerunningSystem

private abstract class EdgerunningSystemCallback extends DelayCallback {
  let system: wref<EdgerunningSystem>;
}

public class TriggerDrawWeaponCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<TriggerDrawWeaponCallback> {
    let self: ref<TriggerDrawWeaponCallback> = new TriggerDrawWeaponCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnTriggerDrawWeaponCallback();
  }
}

public class TriggerRandomShotCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<TriggerRandomShotCallback> {
    let self: ref<TriggerRandomShotCallback> = new TriggerRandomShotCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnTriggerRandomShotCallback();
  }
}

public class LaunchPoliceActivityCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<LaunchPoliceActivityCallback> {
    let self: ref<LaunchPoliceActivityCallback> = new LaunchPoliceActivityCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnLaunchPoliceActivityCallback();
  }
}

public class LaunchCycledSFXCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<LaunchCycledSFXCallback> {
    let self: ref<LaunchCycledSFXCallback> = new LaunchCycledSFXCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnLaunchCycledSFXCallback();
  }

}
public class LaunchCycledPsychosisCheckCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<LaunchCycledPsychosisCheckCallback> {
    let self: ref<LaunchCycledPsychosisCheckCallback> = new LaunchCycledPsychosisCheckCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnLaunchCycledPsychosisCheckCallback();
  }
}

public class PrepareTeleportCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<PrepareTeleportCallback> {
    let self: ref<PrepareTeleportCallback> = new PrepareTeleportCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnPrepareTeleportCallback();
  }
}

public class PostTeleportEffectsCallback extends EdgerunningSystemCallback {

  public static func Create(system: wref<EdgerunningSystem>) -> ref<PostTeleportEffectsCallback> {
    let self: ref<PostTeleportEffectsCallback> = new PostTeleportEffectsCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnPostTeleportEffectsCallback();
  }
}

public class PlayerTeleportCallback extends EdgerunningSystemCallback {
  let position: Vector4;

  public static func Create(system: wref<EdgerunningSystem>, position: Vector4) -> ref<PlayerTeleportCallback> {
    let self: ref<PlayerTeleportCallback> = new PlayerTeleportCallback();
    self.system = system;
    self.position = position;
    return self;
  }

  public func Call() -> Void {
    this.system.OnPlayerTeleportCallback(this.position);
  }
}

public class VictimsSpawnCallback extends EdgerunningSystemCallback {
  let position: Vector4;
  let characterId: TweakDBID;

  public static func Create(system: wref<EdgerunningSystem>, position: Vector4, id: TweakDBID) -> ref<VictimsSpawnCallback> {
    let self: ref<VictimsSpawnCallback> = new VictimsSpawnCallback();
    self.system = system;
    self.position = position;
    self.characterId = id;
    return self;
  }

  public func Call() -> Void {
    this.system.OnVictimsSpawnCallback(this.position, this.characterId);
  }
}

public class VictimKillCallback extends EdgerunningSystemCallback {
  let entityId: EntityID;

  public static func Create(system: wref<EdgerunningSystem>, entityId: EntityID) -> ref<VictimKillCallback> {
    let self: ref<VictimKillCallback> = new VictimKillCallback();
    self.system = system;
    self.entityId = entityId;
    return self;
  }

  public func Call() -> Void {
    this.system.OnVictimKillCallback(this.entityId);
  }
}
