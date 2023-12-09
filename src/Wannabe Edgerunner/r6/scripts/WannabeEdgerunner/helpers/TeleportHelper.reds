import Edgerunning.Common.E
import Edgerunning.System.EdgerunningSystem

/**
  public func Init(player: ref<PlayerPuppet>) -> Void
  public func ScheduleTeleport(delay: Float) -> Void
  public func CancelScheduledTeleportEvents() -> Void

*/
public class TeleportHelper {

  private let player: wref<PlayerPuppet>;
  private let delaySystem: ref<DelaySystem>;
  private let destinationHelper: ref<TeleportDestinationHelper>;
  private let victimsHelper: ref<TeleportVictimsHelper>;
  private let effectsHelper: ref<PsychosisEffectsHelper>;

  private let prepareTeleportDelayId: DelayID; 
  private let teleportDelayId: DelayID; 
  private let postTeleportEffectsDelayId: DelayID; 

  public func Init(player: ref<PlayerPuppet>, effectsHelper: ref<PsychosisEffectsHelper>) -> Void {
    this.player = player;
    this.delaySystem = GameInstance.GetDelaySystem(player.GetGame());
    this.destinationHelper = new TeleportDestinationHelper();
    this.victimsHelper = new TeleportVictimsHelper();
    this.effectsHelper = effectsHelper;
    this.destinationHelper.Init();
    this.victimsHelper.Init(player);
  }

  public func ScheduleTeleport(delay: Float) -> Void {
    E(s"Teleport - Schedule teleport after \(delay)");
    this.CancelScheduledTeleportEvents();
    this.prepareTeleportDelayId = this.delaySystem.DelayCallback(PrepareTeleportCallback.Create(this), delay, true);
  }

  public func CancelScheduledTeleportEvents() -> Void {
    this.delaySystem.CancelDelay(this.prepareTeleportDelayId);
    this.delaySystem.CancelDelay(this.teleportDelayId);
    this.delaySystem.CancelDelay(this.postTeleportEffectsDelayId);
    this.victimsHelper.CancelScheduledVictimSpawns();
  }

  private func OnPrepareTeleportCallback() -> Void {
    let currentDistrict: gamedataDistrict = this.player.GetPreventionSystem().GetCurrentDistrictForEdgerunner();
    let isPrologDone: Bool = this.player.IsPrologueFinished();
    let destination: ref<TeleportData>;
    if isPrologDone {
      destination = this.destinationHelper.GetRandomTeleportData(currentDistrict);
    } else {
      destination = this.destinationHelper.GetRandomTeleportDataPrologue();
    };

    if !IsDefined(destination) { 
      return ; 
    };

    let position: Vector4 = TeleportData.GetRandomCoordinates(destination);
    E(s"Teleport - Selected destination: \(position) at \(destination.district)");
    this.victimsHelper.ScheduleVictimsSpawn(destination);
    this.effectsHelper.PlayFastTravelFx();

    let teleportCallback: ref<PlayerTeleportCallback> = PlayerTeleportCallback.Create(this, position);
    this.teleportDelayId = this.delaySystem.DelayCallback(teleportCallback, 0.9, true);
  }

  private func OnPlayerTeleportCallback(position: Vector4) -> Void {
    if !this.CanBeTeleported() {
      return ;
    };
    E(s"Teleport - Target position: \(position)");
    this.RequestLoadingScreen();
    let rotation: EulerAngles;
    GameInstance.GetTeleportationFacility(this.player.GetGame()).Teleport(this.player, position, rotation);
    this.postTeleportEffectsDelayId = this.delaySystem.DelayCallback(PostTeleportEffectsCallback.Create(this), 1.5, true);
  }

  private func OnPostTeleportEffectsCallback() -> Void {
    E("Teleport - Apply post-effects");
    let timeSystem: ref<TimeSystem> = GameInstance.GetTimeSystem(this.player.GetGame());
    let sps: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(this.player.GetGame());
    let currentHealth: Float = sps.GetStatPoolValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatPoolType.Health, false);
    let targetHealth: Float = 20.0;
    let diff: Float = AbsF(currentHealth - targetHealth);
    // Damage health
    E(s"Teleport - damage health from \(currentHealth) to \(targetHealth) (diff \(diff))");
    sps.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatPoolType.Health, -diff, null, false, false);
    // Skip time
    let currentTimestamp: Float = timeSystem.GetGameTimeStamp();
    let diff: Float = 4.0 * 3600.0;
    let newTimeStamp: Float = currentTimestamp + diff;
    timeSystem.SetGameTimeBySeconds(Cast<Int32>(newTimeStamp));
    GameTimeUtils.FastForwardPlayerState(this.player);
    // Equip weapon
    PlayerGameplayRestrictions.RequestLastUsedWeapon(this.player, gameEquipAnimationType.Instant);
    // Clear wanted level
    this.player.GetPreventionSystem().ClearWantedLevel();
    // Stop cycled effects
    this.effectsHelper.CancelCycledFx();
    // Apply post psychosis
    this.effectsHelper.RunNewPostPsychosisEffect();
  }

  private func RequestLoadingScreen() {
    E(s"Teleport - Show loading screen");
    let controller = GameInstance.GetInkSystem().GetLayer(n"inkHUDLayer").GetGameController() as inkGameController;
    if IsDefined(controller) {
      let nextLoadingTypeEvt: ref<inkSetNextLoadingScreenEvent> = new inkSetNextLoadingScreenEvent();
      nextLoadingTypeEvt.SetNextLoadingScreenType(inkLoadingScreenType.FastTravel);
      controller.QueueBroadcastEvent(nextLoadingTypeEvt);
    };
  }

  private final func CanBeTeleported() -> Bool {
    let bb: ref<IBlackboard> = this.player.GetPlayerStateMachineBlackboard();
    let dogtown: Bool = GameInstance.GetPreventionSpawnSystem(this.player.GetGame()).IsPlayerInDogTown();
    let paused: Bool = GameInstance.GetTimeSystem(this.player.GetGame()).IsPausedState();
    let blocked: Bool = StatusEffectSystem.ObjectHasStatusEffectWithTag(this.player, n"NoTimeSkip");
    let tier: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    let scene: Bool = tier >= EnumInt(gamePSMHighLevel.SceneTier3) && tier <= EnumInt(gamePSMHighLevel.SceneTier5);
    let mounted: Bool = VehicleComponent.IsMountedToVehicle(this.player.GetGame(), this.player);
    let condition: Bool = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Swimming) == EnumInt(gamePSMSwimming.Diving)
      || bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying)
      || bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInLoreAnimationScene);

    if dogtown || paused || blocked || scene || mounted || condition {
      E(s"Teleport canceled: Dogtown \(dogtown), paused: \(paused), blocked: \(blocked), scene: \(scene), mounted: \(mounted), condition: \(condition)");
      return false;
    };

    return true;
  }
}

public class PrepareTeleportCallback extends DelayCallback {
  let helper: wref<TeleportHelper>;

  public static func Create(helper: ref<TeleportHelper>) -> ref<PrepareTeleportCallback> {
    let self: ref<PrepareTeleportCallback> = new PrepareTeleportCallback();
    self.helper = helper;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnPrepareTeleportCallback();
  }
}

public class PlayerTeleportCallback extends DelayCallback {
  let position: Vector4;
  let helper: wref<TeleportHelper>;

  public static func Create(helper: ref<TeleportHelper>, position: Vector4) -> ref<PlayerTeleportCallback> {
    let self: ref<PlayerTeleportCallback> = new PlayerTeleportCallback();
    self.helper = helper;
    self.position = position;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnPlayerTeleportCallback(this.position);
  }
}


public class PostTeleportEffectsCallback extends DelayCallback {
  let helper: wref<TeleportHelper>;

  public static func Create(helper: ref<TeleportHelper>) -> ref<PostTeleportEffectsCallback> {
    let self: ref<PostTeleportEffectsCallback> = new PostTeleportEffectsCallback();
    self.helper = helper;
    return self;
  }

  public func Call() -> Void {
    this.helper.OnPostTeleportEffectsCallback();
  }
}
