import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E


public class TeleportingPreventionHelper {
  public func GetPlayer() -> wref<PlayerPuppet> { return this.player; }


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

  public func RefreshConfig(config: ref<EdgerunningConfig>) -> Void {
    this.config = config;
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
    this.delaySystem.CancelCallback(this.policeActivityDelayId);
    this.policeActivityDelayId = GetInvalidDelayID();
    this.delaySystem.CancelCallback(this.drawWeaponDelayId);
    this.drawWeaponDelayId = GetInvalidDelayID();
    this.delaySystem.CancelCallback(this.randomShotsDelayId);
    this.randomShotsDelayId = GetInvalidDelayID();
  }

  public func OnLaunchPoliceActivityCallback() -> Void {
    if !IsDefined(this.player) || !EdgerunningSystem.GetInstance(this.player.GetGame()).CanRequestPoliceActivity() {
      return;
    };

    E("Prevention - Launch police flow");
    this.player.GetPreventionSystem().SpawnPoliceForPsychosis(this.config);
  }

  public func OnTriggerDrawWeaponCallback() -> Void {
    if !IsDefined(this.player) || !EdgerunningSystem.GetInstance(this.player.GetGame()).CanForceWeaponAction() {
      return;
    };

    E("Prevention - Draw weapon");
    let equipmentSystem: wref<EquipmentSystem> = this.player.GetEquipmentSystem();
    let drawItemRequest: ref<DrawItemRequest> = new DrawItemRequest();
    drawItemRequest.itemID = EquipmentSystem.GetData(this.player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, 0);
    if !ItemID.IsValid(drawItemRequest.itemID) { return; };
    drawItemRequest.owner = this.player;
    equipmentSystem.QueueRequest(drawItemRequest);
  }

  public func OnTriggerRandomShotCallback() -> Void {
    if !IsDefined(this.player) || !EdgerunningSystem.GetInstance(this.player.GetGame()).CanForceWeaponAction() {
      return;
    };

    if this.player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.Weapon) != EnumInt(gamePSMWeaponStates.Ready) { return; };
    E("Prevention - Shot");
    let weaponObject: ref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
    if !IsDefined(weaponObject) {
      E("Prevention - no active weapon, skip shot");
      return;
    };

    let weaponRecord: ref<WeaponItem_Record> = weaponObject.GetWeaponRecord();
    if !IsDefined(weaponRecord) {
      E("Prevention - active weapon has no record, skip shot");
      return;
    };

    if !IsDefined(weaponRecord.PrimaryTriggerMode()) { return; };
    let simTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.player.GetGame()));
    AIWeapon.Fire(this.player, weaponObject, simTime, 1.0, weaponRecord.PrimaryTriggerMode().Type());
  }
}

public class LaunchPoliceActivityCallback extends EdgerunningEpisodeCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<LaunchPoliceActivityCallback> {
    let self: ref<LaunchPoliceActivityCallback> = new LaunchPoliceActivityCallback();
    self.helper = helper;
    self.BindEpisode(helper.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.helper) {
      this.helper.OnLaunchPoliceActivityCallback();
    };
  }
}

public class TriggerDrawWeaponCallback extends EdgerunningEpisodeCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<TriggerDrawWeaponCallback> {
    let self: ref<TriggerDrawWeaponCallback> = new TriggerDrawWeaponCallback();
    self.helper = helper;
    self.BindEpisode(helper.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.helper) {
      this.helper.OnTriggerDrawWeaponCallback();
    };
  }
}

public class TriggerRandomShotCallback extends EdgerunningEpisodeCallback {
  let helper: wref<TeleportingPreventionHelper>;

  public static func Create(helper: ref<TeleportingPreventionHelper>) -> ref<TriggerRandomShotCallback> {
    let self: ref<TriggerRandomShotCallback> = new TriggerRandomShotCallback();
    self.helper = helper;
    self.BindEpisode(helper.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.helper) {
      this.helper.OnTriggerRandomShotCallback();
    };
  }
}
