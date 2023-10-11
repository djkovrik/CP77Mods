module Edgerunning.System
import Edgerunning.Common.E

/**
  public static func GetInstance(gameInstance: GameInstance) -> ref<EdgerunningSystem>

  public func RunLowHumanityFlow() -> Void
  public func RunPrePsychosisFlow() -> Void
  public func RunPsychosisFlow() -> Void
  public func ScheduleNextPsychoCheck() -> Void
  public func StopPsychoChecks() -> Void
  public func StopEverything() -> Void

  public func OnPossessionChanged(playerPossesion: gamedataPlayerPossesion) -> Void
  public func OnSettingsChanged() -> Void
  public func OnEnemyKilled(affiliation: gamedataAffiliation) -> Void
  public func OnBuff() -> Void
  public func OnBuffEnded() -> Void
  public func OnSleep() -> Void
  public func OnBerserkActivation(item: ItemID) -> Void
  public func OnSandevistanActivation(item: ItemID) -> Void
  public func OnKerenzikovActivation() -> Void
  public func OnOpticalCamoActivation() -> Void
  public func OnArmsCyberwareActivation(type: gamedataItemType) -> Void

  public func AddHumanityDamage(cost: Int32) -> Void
  public func ResetHumanityDamage() -> Void
  public func AddHumanityPenalty(key: String, value: Int32) -> Void
  public func RemoveHumanityPenalty(key: String) -> Void
  public func GetPenaltyByKey(key: String) -> Int32
  public func GetTotalPenalty() -> Int32
  public func GetAdditionalPenaltiesDescription() -> String
  public func GetHumanityCurrent() -> Int32
  public func GetHumanityTotal() -> Int32
  public func GetHumanityColor() -> CName
  private func InvalidateCurrentState(opt onLoad: Bool) -> Void

  private func IsPoliceSpawnAvailable() -> Bool
  private func IsHumanityRestored() -> Bool
  private func IsPsychosisBlocked() -> Bool
  public func OnLaunchCycledPsychosisCheckCallback() -> Void
*/
public class EdgerunningSystem extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;
  private let psmBB: ref<IBlackboard>;
  private let delaySystem: ref<DelaySystem>;
  private let questsSystem: ref<QuestsSystem>;
  private let config: ref<EdgerunningConfig>;
  private let teleportHelper: ref<TeleportHelper>;
  private let preventionHelper: ref<TeleportingPreventionHelper>;
  private let cyberwareHelper: ref<CyberwareHelper>;
  private let effectsHelper: ref<PsychosisEffectsHelper>;
  private let effectsChecker: ref<PsychosisEffectsChecker>;

  private let additionalPenalties: ref<inkIntHashMap>;
  private let additionalPenaltiesKeys: array<String>;

  private let currentHumanityPool: Int32;
  private let upperThreshold: Int32;
  private let lowerThreshold: Int32;
  private let psychosisCheckDelayId: DelayID;

  private persistent let currentHumanityDamage: Int32 = 0;

  public static func GetInstance(gameInstance: GameInstance) -> ref<EdgerunningSystem> {
    let system: ref<EdgerunningSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"Edgerunning.System.EdgerunningSystem") as EdgerunningSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if GameInstance.GetSystemRequestsHandler().IsPreGame() {
      E("Game not loaded yet, skip EdgerunningSystem init");
      return ;
    };

    E("EdgerunningSystem init");

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.player = player;
      this.psmBB = this.player.GetPlayerStateMachineBlackboard();
      this.delaySystem = GameInstance.GetDelaySystem(this.player.GetGame());
      this.questsSystem = GameInstance.GetQuestsSystem(this.player.GetGame());

      this.config = new EdgerunningConfig();
      this.effectsHelper = new PsychosisEffectsHelper();
      this.effectsHelper.Init(player);
      this.preventionHelper = new TeleportingPreventionHelper();
      this.preventionHelper.Init(this.player, this.config);
      this.teleportHelper = new TeleportHelper();
      this.teleportHelper.Init(this.player, this.effectsHelper);
      this.cyberwareHelper = new CyberwareHelper();
      this.cyberwareHelper.Init(this.player, this.config);
      this.effectsChecker = new PsychosisEffectsChecker();
      this.effectsChecker.Init(this.player);
      this.additionalPenalties = new inkIntHashMap();

      this.InvalidateCurrentState(true);
    };

    // EdgerunnerStats.Print(this, this.config);
  }

  // -- Control effects flows

  public func RunLowHumanityFlow() -> Void {
    if this.effectsChecker.IsGlitchesActive() && !this.effectsChecker.IsPrePsychosisActive() {
      E("? Glitches already active - do nothing");
      return ;
    };

    this.StopEverything();
    this.effectsHelper.RunLowHumanityEffects();
  }

  public func RunPrePsychosisFlow() -> Void {
    if this.effectsChecker.IsPrePsychosisActive() {
      E("? Pre-Psychosis already active - do nothing");
      return ;
    };

    this.StopEverything();
    this.effectsHelper.RunPrePsychosisEffects();
    this.ScheduleNextPsychoCheck();
  }

  public func RunPsychosisFlow() -> Void {
    if this.effectsChecker.IsPsychosisActive() {
      E("? Psychosis already active - do nothing");
      return ;
    };
    
    this.StopEverything();
    this.effectsHelper.RunPsychosisEffects();
    this.preventionHelper.ScheduleRandomWeaponActions(4.5);

    if this.IsPoliceSpawnAvailable() {
      this.preventionHelper.SchedulePoliceActivity(6.0);
    };

    this.effectsHelper.ScheduleCycledSfx(7.0);

    if this.config.teleportOnEnd {
      this.teleportHelper.ScheduleTeleport(66.0);
    };
  }

  public func ScheduleNextPsychoCheck() -> Void {
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    E(s"? Psycho check - scheduled after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayCallback(LaunchCycledPsychosisCheckCallback.Create(this), nextRun, false);
  }

  public func StopPsychoChecks() -> Void {
    E(s"? Psycho check - stopped");
    this.delaySystem.CancelDelay(this.psychosisCheckDelayId);
  }

  public func StopEverything() -> Void {
    E(s"? Stop everything...");
    this.effectsHelper.StopLowHumanityEffects();
    this.effectsHelper.StopPrePsychosisEffects();
    this.effectsHelper.StopPsychosisEffects();
    this.effectsHelper.CancelCycledFx();
    this.effectsHelper.CancelOtherFxes();
    this.preventionHelper.CancelScheduledPreventionActivity();
    this.teleportHelper.CancelScheduledTeleportEvents();
    this.StopPsychoChecks();
    E(s"? Everything stopped");
  }


  // -- React to outer events

  public func OnPossessionChanged(playerPossesion: gamedataPlayerPossesion) -> Void {
    this.effectsChecker.OnPossessionChanged(playerPossesion);
  }

  public func OnSettingsChanged() -> Void {
    this.config = new EdgerunningConfig();
  }

  public func OnEnemyKilled(affiliation: gamedataAffiliation) -> Void {
    if this.effectsChecker.IsPossessed() {
      this.StopEverything();
      E(s"! Playing as Johnny - all effects removed");
      return ;
    };

    let cost: Int32;
    if !this.effectsChecker.IsRipperdocBuffActive() {
      cost = EnemyCostHelper.GetEnemyCost(affiliation, this.config);
      this.AddHumanityDamage(cost);
      this.InvalidateCurrentState();
      E(s"! Killed \(affiliation), humanity -\(cost)");
    } else {
      E(s"! Humanity freezed, kill costs no humanity | current humanity: \(this.GetHumanityCurrent())");
    };
  }

  public func OnBuff() -> Void {
    this.StopEverything();
  }

  public func OnBuffEnded() -> Void {
    this.InvalidateCurrentState();
  }

  public func OnEdgerunnerPerkActivated() -> Void {
    this.effectsHelper.CancelCycledFx();
  }

  public func OnSleep() -> Void {
    this.StopEverything();
    this.ResetHumanityDamage();
    E("! Rested, humanity value restored.");
    this.InvalidateCurrentState();
  }

  public func OnBerserkActivation(item: ItemID) -> Void {
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(item);
    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
    };

    let cost: Int32 = this.config.berserkUsageCost * Cast<Int32>(qualityMult);
    if !this.effectsChecker.IsRipperdocBuffActive() {
      this.AddHumanityDamage(cost);
      E(s"! Berserk activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, berserk costs no humanity");
    };
  }

  public func OnSandevistanActivation(item: ItemID) -> Void {
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(item);
    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
    };

    let cost: Int32 = this.config.sandevistanUsageCost * Cast<Int32>(qualityMult);
    if !this.effectsChecker.IsRipperdocBuffActive() {
      this.AddHumanityDamage(cost);
      E(s"! Sandevistan activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, sandevistan costs no humanity");
    };
  }

  public func OnKerenzikovActivation() -> Void {
    let itemRecord: ref<Item_Record> = this.cyberwareHelper.GetCurrentKerenzikov();
    if !IsDefined(itemRecord) {
      return;
    };

    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
    };

    let cost: Int32 = this.config.kerenzikovUsageCost * Cast<Int32>(qualityMult);

    if !this.effectsChecker.IsRipperdocBuffActive() {
      this.AddHumanityDamage(cost);
      E(s"! Kerenzikov activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, kerenzikov costs no humanity");
    };
  }

  public func OnOpticalCamoActivation() -> Void {
    let itemRecord: ref<Item_Record> = this.cyberwareHelper.GetCurrentOpticalCamo();
    if !IsDefined(itemRecord) {
      return;
    };

    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
    };

    let cost: Int32 = this.config.opticalCamoUsageCost * Cast<Int32>(qualityMult);

    if !this.effectsChecker.IsRipperdocBuffActive() {
      this.AddHumanityDamage(cost);
      E(s"! Optical camo activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, optical camo costs no humanity");
    };
  }

  public func OnArmsCyberwareActivation(type: gamedataItemType) -> Void {
    let itemId: ItemID = EquipmentSystem.GetInstance(this.player).GetActiveItem(this.player, gamedataEquipmentArea.ArmsCW);
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    let itemType: gamedataItemType = RPGManager.GetItemType(itemId);
    
    if !IsDefined(itemRecord) {
      return;
    };

    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
    };

    let cost: Int32;
    switch itemType {
      case gamedataItemType.Cyb_Launcher:
        cost = this.config.launcherUsageCost * Cast<Int32>(qualityMult);
        break;
      case gamedataItemType.Cyb_MantisBlades:
        cost = this.config.mantisBladesUsageCost * Cast<Int32>(qualityMult);
        break;
      case gamedataItemType.Cyb_NanoWires:
        cost = this.config.monowireUsageCost * Cast<Int32>(qualityMult);
        break;
      default:
        cost = 0;
        break;
    };

    if !this.effectsChecker.IsRipperdocBuffActive() {
      this.AddHumanityDamage(cost);
      E(s"! Arms cyberware activated: \(itemType) \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, arms cyberware costs no humanity");
    };
  }


  // -- Handle Humanity

  public func AddHumanityDamage(cost: Int32) -> Void {
    this.currentHumanityDamage += cost;
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, this.currentHumanityDamage, true);
  }

  public func ResetHumanityDamage() -> Void {
    this.currentHumanityDamage = 0;
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, 0, true);
  }

  public func PostTeleportHumanityReset() -> Void {
    let newDamage: Int32 = this.currentHumanityDamage - 5;
    this.currentHumanityDamage = newDamage;
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, newDamage, true);
    this.InvalidateCurrentState(false);
  }

  public func AddHumanityPenalty(key: String, value: Int32) -> Void {
    if !ArrayContains(this.additionalPenaltiesKeys, key) {
      ArrayPush(this.additionalPenaltiesKeys, key);
    };

    let hash: Uint64 = this.Hash(key);
    if this.additionalPenalties.KeyExist(hash) {
      this.additionalPenalties.Set(hash, value);
    } else {
      this.additionalPenalties.Insert(hash, value);
    };
    this.InvalidateCurrentState();
  }

  public func RemoveHumanityPenalty(key: String) -> Void {
    ArrayRemove(this.additionalPenaltiesKeys, key);
    let hash: Uint64 = this.Hash(key);
    if this.additionalPenalties.Remove(hash) {
      this.InvalidateCurrentState();
    };
  }

  public func GetPenaltyByKey(key: String) -> Int32 {
    let hash: Uint64 = this.Hash(key);
    if !this.additionalPenalties.KeyExist(hash) {
      return -1;
    };

    return this.additionalPenalties.Get(hash);
  }

  public func GetTotalPenalty() -> Int32 {
    let penalties: array<Int32>;
    let sum: Int32 = 0;
    this.additionalPenalties.GetValues(penalties);
    for penalty in penalties {
      sum += penalty;
    };

    return sum;
  }

  public func GetAdditionalPenaltiesDescription() -> String {
    if Equals(ArraySize(this.additionalPenaltiesKeys), 0) {
      return "";
    };

    let desc: String = "\n\n**********";
    let hash: Uint64;
    let value: Int32;
    let presentation: String;
    let localized: String;
    for key in this.additionalPenaltiesKeys {
      hash = this.Hash(key);
      value = this.additionalPenalties.Get(hash);
      localized = GetLocalizedTextByKey(StringToName(key));
      // Swap signs for displaying penalty as negative and boost as positive
      if value > 0 {
        presentation = s"-\(value)";
      } else {
        presentation = s"+\(Abs(value))";
      };
      // Check localized
      if NotEquals(localized, key) && NotEquals(localized, "") {
        desc += s"\n\(localized): \(presentation)";
      } else {
        desc += s"\n\(key): \(presentation)";
      };
    };

    return desc;
  }

  public func GetHumanityCurrent() -> Int32 {
    return this.currentHumanityPool;
  }

  public func GetHumanityTotal() -> Int32 {
    let basePool: Int32 = this.config.baseHumanityPool;
    let playerLevel: Float = GameInstance.GetStatsSystem(this.player.GetGame()).GetStatValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatType.Level);
    let additionalPool: Int32 = Cast<Int32>(this.config.humanityBonusPerLevel * playerLevel);
    E(s"basePool: \(basePool), playerLevel: \(playerLevel), additionalPool: \(additionalPool)");
    return basePool + additionalPool;
  }

  public func GetHumanityColor() -> CName {
    let color: CName = n"MainColors.White";
    if this.currentHumanityPool < this.upperThreshold && this.currentHumanityPool > this.lowerThreshold {
      color = n"MainColors.Orange"; 
    } else {
      if this.currentHumanityPool <= this.lowerThreshold {
        color = n"MainColors.ActiveRed"; 
      } else {
        color = n"MainColors.MildGreen"; 
      };
    };

    return color;
  }

  private func InvalidateCurrentState(opt firstLoad: Bool) -> Void {
    let penalty: Int32 = this.GetTotalPenalty();
    let evt: ref<UpdateHumanityCounterEvent> = new UpdateHumanityCounterEvent();
    let basePool: Int32 = this.GetHumanityTotal();
    this.currentHumanityPool = basePool - this.currentHumanityDamage - penalty;
    if this.currentHumanityPool < 0 { this.currentHumanityPool = 0; };
    this.upperThreshold = this.config.glitchesThreshold;
    this.lowerThreshold = this.config.psychosisThreshold;
    E("Current humanity points state:");
    E(s" - total: \(basePool) humanity, points left: \(this.currentHumanityPool), can be recovered: \(this.currentHumanityDamage)");
    E(s" - debuffs for \(this.upperThreshold) and lower, cyberpsychosis for \(this.lowerThreshold) and lower");
    E(s"Total penalty from mods: \(penalty)");

    evt.current = this.GetHumanityCurrent();
    evt.total = this.GetHumanityTotal();
    evt.color = this.GetHumanityColor();
    GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(evt);

    if this.effectsChecker.IsRipperdocBuffActive() { return; };
    if this.effectsChecker.IsPsychosisActive() { return; };

    if this.effectsChecker.IsPossessed() {
      this.StopEverything();
      return ;
    };

    if this.currentHumanityPool > this.upperThreshold {
      this.StopEverything();
      return ;
    };

    if this.currentHumanityPool < this.upperThreshold && this.currentHumanityPool >= this.lowerThreshold {
      this.RunLowHumanityFlow();
    } else {
      if this.currentHumanityPool < this.lowerThreshold && this.currentHumanityPool > 0 {
        this.RunPrePsychosisFlow();
      } else {
        if Equals(this.currentHumanityPool, 0) {
          this.RunPrePsychosisFlow();
          if this.config.alwaysRunAtZero {
            this.RunPsychosisFlow();
          };
        };
      };
    };
  }


  // -- Internal checkers

  private func IsPoliceSpawnAvailable() -> Bool {
    let zone: Int32 = this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let zoneEnum: gamePSMZones = IntEnum(zone);
    let isInInterior: Bool = IsEntityInInteriorArea(this.player);
    let result: Bool = zone < 3 && !isInInterior;
    E(s"CanSpawnPolice - zone: \(zoneEnum) \(zone), is in interior: \(isInInterior) -> can spawn: \(result)");
    return result;
  }

  private func IsHumanityRestored() -> Bool {
    return this.currentHumanityPool > this.lowerThreshold;
  }

  private func IsPsychosisBlocked() -> Bool {
    let tier: Int32 = this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    E("? Check if psychosis available...");
    
    if this.IsHumanityRestored() {
      E("- Humanity value restored");
      return true;
    };

    if this.psmBB.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) {
      E("- carrying");
      return true;
    };

    if this.psmBB.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInLoreAnimationScene)  {
      E("- animation scene");
      return true;
    };

    if this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Swimming) == EnumInt(gamePSMSwimming.Diving) {
      E("- diving");
      return true;
    };

    if GameInstance.GetPhoneManager(this.player.GetGame()).IsPhoneCallActive() {
      E("- active phone call");
      return true;
    };

    if VehicleComponent.IsMountedToVehicle(this.player.GetGame(), this.player) {
      E("- mounted to vehicle");
      return true;
    };

    if this.player.GetHudManager().IsBraindanceActive() {
      E("- braindance is active");
      return true;
    };

    if this.effectsChecker.IsRipperdocBuffActive() {
      E("- has buff");
      return true;
    };

    if this.effectsChecker.IsPossessed() {
      E("- Johnny");
      return true;
    };

    if tier >= EnumInt(gamePSMHighLevel.SceneTier3) && tier <= EnumInt(gamePSMHighLevel.SceneTier5) {
      E("- has blocking scene active");
      return true;
    };

    return false;
  }


  // -- Misc

  private func Hash(str: String) -> Uint64 {
    return TDBID.ToNumber(TDBID.Create(str));
  }


  // -- Callback reaction

  public func OnLaunchCycledPsychosisCheckCallback() -> Void {
    let random: Int32 = RandRange(0, 100);
    let threshold: Int32 = this.config.psychoChance;
    let triggered: Bool = random <= threshold;
    let forcedRun: Bool = Equals(this.currentHumanityPool, 0) && this.config.alwaysRunAtZero;
    E(s"? Run psychosis trigger check: roll \(random) against \(threshold), triggered: \(triggered), forced run: \(forcedRun)");
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    if triggered || forcedRun {
      this.RunPsychosisFlow();
    } else {
      if !this.IsHumanityRestored() {
        E(s"? Rescheduled next psycho check after \(nextRun) seconds");
        this.psychosisCheckDelayId = this.delaySystem.DelayCallback(LaunchCycledPsychosisCheckCallback.Create(this), nextRun, false);
      };
    };
  }

  public static func Debug(player: ref<PlayerPuppet>) -> Void {
    let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(player.GetGame());
    // system.AddHumanityDamage(10);
    // system.InvalidateCurrentState(false);
    system.RunPsychosisFlow();
  }
}

public class LaunchCycledPsychosisCheckCallback extends DelayCallback {
  let system: wref<EdgerunningSystem>;

  public static func Create(system: ref<EdgerunningSystem>) -> ref<LaunchCycledPsychosisCheckCallback> {
    let self: ref<LaunchCycledPsychosisCheckCallback> = new LaunchCycledPsychosisCheckCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnLaunchCycledPsychosisCheckCallback();
  }
}
