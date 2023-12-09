import Edgerunning.Common.E

/**
  public func Init(player: ref<PlayerPuppet>) -> Void
  public func SchedulePoliceActivity(delay: Float) -> Void
  public func ScheduleRandomWeaponActions(delay: Float) -> Void
  public func CancelScheduledPreventionActivity() -> Void
*/
public class TeleportingPreventionHelper {

  private let player: wref<PlayerPuppet>;
  private let config: ref<EdgerunningConfig>;
  private let delaySystem: ref<DelaySystem>;

  private let policeActivityDelayId: DelayID;
  private let drawWeaponDelayId: DelayID;
  private let randomShotsDelayId: DelayID;

  public func Init(player: ref<PlayerPuppet>, config: ref<EdgerunningConfig>) -> Void {
    this.player = player;
    this.config = config;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
  }

  public func SchedulePoliceActivity(delay: Float) -> Void {
    E("Prevention - Schedule police flow");
    this.policeActivityDelayId = this.delaySystem.DelayCallback(LaunchPoliceActivityCallback.Create(this), delay, true);
  }

  public func ScheduleRandomWeaponActions(delay: Float) -> Void {
    E("Prevention - Schedule random shot");
    this.drawWeaponDelayId = this.delaySystem.DelayCallback(TriggerDrawWeaponCallback.Create(this), delay, true);
    this.randomShotsDelayId = this.delaySystem.DelayCallback(TriggerRandomShotCallback.Create(this), delay + 2.0, true);
  }

  public func CancelScheduledPreventionActivity() -> Void {
    E("Prevention - Cancel everything");
    this.delaySystem.CancelDelay(this.policeActivityDelayId);
    this.delaySystem.CancelDelay(this.drawWeaponDelayId);
    this.delaySystem.CancelDelay(this.randomShotsDelayId);
  }

  private func OnLaunchPoliceActivityCallback() -> Void {
    E("Prevention - Launch police flow");
    this.player.GetPreventionSystem().SpawnPoliceForPsychosis(this.config);
  }

  private func OnTriggerDrawWeaponCallback() -> Void {
    E("Prevention - Draw weapon");
    let equipmentSystem: wref<EquipmentSystem> = this.player.GetEquipmentSystem();
    let drawItemRequest: ref<DrawItemRequest> = new DrawItemRequest();
    drawItemRequest.itemID = EquipmentSystem.GetData(this.player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, 0);
    drawItemRequest.owner = this.player;
    equipmentSystem.QueueRequest(drawItemRequest);
  }

  private func OnTriggerRandomShotCallback() -> Void {
    E("Prevention - Shot");
    let weaponObject: ref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
    let simTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.player.GetGame()));
    AIWeapon.Fire(this.player, weaponObject, simTime, 1.0, weaponObject.GetWeaponRecord().PrimaryTriggerMode().Type());
  }
}

public class LaunchPoliceActivityCallback extends DelayCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<LaunchPoliceActivityCallback> {
    let self: ref<LaunchPoliceActivityCallback> = new LaunchPoliceActivityCallback();
    self.helper = helper;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnLaunchPoliceActivityCallback();
  }
}

public class TriggerDrawWeaponCallback extends DelayCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<TriggerDrawWeaponCallback> {
    let self: ref<TriggerDrawWeaponCallback> = new TriggerDrawWeaponCallback();
    self.helper = helper;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnTriggerDrawWeaponCallback();
  }
}

public class TriggerRandomShotCallback extends DelayCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<TriggerRandomShotCallback> {
    let self: ref<TriggerRandomShotCallback> = new TriggerRandomShotCallback();
    self.helper = helper;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnTriggerRandomShotCallback();
  }
}
