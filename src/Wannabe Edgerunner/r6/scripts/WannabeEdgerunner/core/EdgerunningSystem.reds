module Edgerunning.System
import Edgerunning.Common.E

/**
  public static func GetInstance(gameInstance: GameInstance) -> ref<EdgerunningSystem>

  public func RunPrePsychosisFlow() -> Void
  public func RunPsychosisFlow() -> Void
  public func RunPostPsychosisFlow() -> Void
  public func ScheduleNextPsychoCheck() -> Void
  public func SchedulePostPsychosisEffect(delay: Float) -> Void
  public func ScheduleHumanityRestoreEffect(delay: Float) -> Void
  public func StopPrePsychosisFlow() -> Void
  public func StopPsychosisFlow() -> Void
  public func StopPostPsychosisFlow() -> Void
  public func StopEverythingNew() -> Void

  public func OnPossessionChanged(playerPossesion: gamedataPlayerPossesion) -> Void
  public func OnSettingsChanged() -> Void
  public func OnEnemyKilled(affiliation: gamedataAffiliation) -> Void
  public func OnBuff() -> Void
  public func OnBuffEnded() -> Void
  public func OnRestoreAction(action: HumanityRestoringAction) -> Void
  public func OnBerserkActivation(item: ItemID) -> Void
  public func OnOverClockActivation(item: ItemID) -> Void
  public func OnSandevistanActivation(item: ItemID) -> Void
  public func OnKerenzikovActivation() -> Void
  public func OnOpticalCamoActivation() -> Void
  public func OnArmsCyberwareActivation(type: gamedataItemType) -> Void

  public func IsWentFullPsycho() -> Bool 
  public func SetWentFullPsycho(value: Bool) -> Void 
  public func AddHumanityDamage(cost: Float) -> Void
  public func RemoveHumanityDamage(cost: Int32) -> Bool
  public func ResetHumanityDamage() -> Void
  public func AddHumanityPenalty(key: String, value: Int32) -> Void
  public func RemoveHumanityPenalty(key: String) -> Void
  public func GetPenaltyByKey(key: String) -> Int32
  public func GetTotalPenalty() -> Int32
  public func GetAdditionalPenaltiesDescription() -> String
  public func GetHumanityCurrent() -> Int32
  public func GetHumanityTotal() -> Int32
  public func GetPsychosisThreshold() -> Int32
  public func GetPsychosisChance() -> Int32
  public func GetHumanityColor() -> CName
  private func InvalidateCurrentState(opt onLoad: Bool) -> Void

  public func IsPsychosisActive() -> Bool
  private func IsPoliceSpawnAvailable() -> Bool
  private func IsHumanityRestored() -> Bool
  private func IsPsychosisBlocked() -> Bool
  public func OnLaunchCycledPsychosisCheckCallback() -> Void
  public func OnLaunchPostPsychosisCallback() -> Void

  private func ShowHumanityRestoredMessage(amount: Int32) -> Void
*/
public class EdgerunningSystem extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;
  private let psmBB: ref<IBlackboard>;
  private let delaySystem: ref<DelaySystem>;
  private let questsSystem: ref<QuestsSystem>;
  private let statsSystem: ref<StatsSystem>;
  private let statsPoolSystem: ref<StatPoolsSystem>;
  private let config: ref<EdgerunningConfig>;
  private let teleportHelper: ref<TeleportHelper>;
  private let preventionHelper: ref<TeleportingPreventionHelper>;
  private let cyberwareHelper: ref<CyberwareHelper>;
  private let effectsHelper: ref<PsychosisEffectsHelper>;
  private let effectsChecker: ref<PsychosisEffectsChecker>;

  private let additionalPenalties: ref<inkIntHashMap>;
  private let additionalPenaltiesKeys: array<String>;

  public let currentHumanityPool: Int32;
  public let psychosisThreshold: Int32;
  public let psychosisCheckDelayId: DelayID;
  public let postPsychosisDelayId: DelayID;
  public let humanityRestoreDelayId: DelayID;

  private persistent let currentHumanityDamage: Int32 = 0;
  private persistent let wentFullPsycho: Bool = false;

  private persistent let humanityRestoringActionTakenLover: Bool = false;
  private persistent let humanityRestoringActionTakenPet: Bool = false;
  private persistent let humanityRestoringActionTakenDonation: Bool = false;
  private persistent let humanityRestoringActionTakenApartment: Bool = false;
  private persistent let humanityRestoringActionTakenSocial: Bool = false;
  private persistent let humanityRestoringActionTakenShower: Bool = false;

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
      this.statsSystem = GameInstance.GetStatsSystem(this.player.GetGame());
      this.statsPoolSystem = GameInstance.GetStatPoolsSystem(this.player.GetGame());

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

  public func RunPrePsychosisFlow() -> Void {
    if this.effectsChecker.IsNewPrePsychosisActive() {
      E("? Pre-Psychosis already active - do nothing");
      return ;
    };

    this.StopEverythingNew();
    this.effectsHelper.RunNewPrePsychosisEffect();
    this.ScheduleNextPsychoCheck();
  }

  public func RunPsychosisFlow() -> Void {
    if this.effectsChecker.IsNewPsychosisActive() {
      E("? Psychosis already active - do nothing");
      return ;
    };
    
    this.StopEverythingNew();
    this.effectsHelper.RunNewPsychosisEffect();
    this.SetWentFullPsycho(true);

    if this.config.lightVisuals {
      this.preventionHelper.ScheduleRandomWeaponActions(0.5);

      if this.IsPoliceSpawnAvailable() {
        this.preventionHelper.SchedulePoliceActivity(2.0);
      };

      this.effectsHelper.ScheduleCycledSfx(3.0);
    } else {
      this.preventionHelper.ScheduleRandomWeaponActions(4.5);

      if this.IsPoliceSpawnAvailable() {
        this.preventionHelper.SchedulePoliceActivity(6.0);
      };

      this.effectsHelper.ScheduleCycledSfx(7.0);
    };

    let psychoDuration: Float = this.config.psychoDuration;
    if this.config.teleportOnEnd {
      this.teleportHelper.ScheduleTeleport(psychoDuration + 1.0);
    } else {
      this.SchedulePostPsychosisEffect(psychoDuration + 2.0);
    };

    this.ScheduleHumanityRestoreEffect(psychoDuration + 3.0);
  }

  public func RunPostPsychosisFlow() -> Void {
    this.StopEverythingNew();
    this.effectsHelper.RunNewPostPsychosisEffect();
  }

  public func ScheduleNextPsychoCheck() -> Void {
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    E(s"? Psycho check - scheduled after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayCallback(LaunchCycledPsychosisCheckCallback.Create(this), nextRun, true);
  }

  public func SchedulePostPsychosisEffect(delay: Float) -> Void {
    E(s"? Post Psycho effect - scheduled after \(delay) seconds");
    this.postPsychosisDelayId = this.delaySystem.DelayCallback(LaunchPostPsychosisEffectCallback.Create(this), delay, true);
  }

  public func ScheduleHumanityRestoreEffect(delay: Float) -> Void {
    E(s"? Post Psycho Humanity restore - scheduled after \(delay) seconds");
    this.humanityRestoreDelayId = this.delaySystem.DelayCallback(LaunchPostPsychosisHumanityRestoreCallback.Create(this), delay, true);
  }


  public func StopPrePsychosisFlow() -> Void {
    E(s"? Stop pre-psychosis");
    this.effectsHelper.StopNewPrePsychosisEffect();
    this.delaySystem.CancelDelay(this.psychosisCheckDelayId);
  }

  public func StopPsychosisFlow() -> Void {
    E(s"? Stop psychosis");
    this.effectsHelper.StopNewPsychosisEffect();
    this.effectsHelper.CancelCycledFx();
    this.effectsHelper.CancelOtherFxes();
    this.preventionHelper.CancelScheduledPreventionActivity();
    this.teleportHelper.CancelScheduledTeleportEvents();
    this.delaySystem.CancelDelay(this.postPsychosisDelayId);
  }

  public func StopPostPsychosisFlow() -> Void {
    E(s"? Stop post-psychosis");
    this.effectsHelper.StopNewPostPsychosisEffect();
  }

  public func StopEverythingNew() -> Void {
    E(s"? Stop everything ");
    this.StopPrePsychosisFlow();
    this.StopPsychosisFlow();
    this.StopPostPsychosisFlow();
  }


  // -- React to outer events

  public func OnPossessionChanged(playerPossesion: gamedataPlayerPossesion) -> Void {
    this.effectsChecker.OnPossessionChanged(playerPossesion);
  }

  public func OnSettingsChanged() -> Void {
    this.config = new EdgerunningConfig();
    this.effectsHelper.RefreshConfig();
  }

  public func OnEnemyKilled(affiliation: gamedataAffiliation) -> Void {
    if this.effectsChecker.IsPossessed() {
      this.StopEverythingNew();
      E(s"! Playing as Johnny - all effects removed");
      return ;
    };

    let cost: Float;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      cost = Cast<Float>(EnemyCostHelper.GetEnemyCost(affiliation, this.config));
      this.AddHumanityDamage(cost);
      this.InvalidateCurrentState();
      E(s"! Killed \(affiliation), humanity -\(cost)");
    } else {
      E(s"! Humanity freezed, kill costs no humanity | current humanity: \(this.GetHumanityCurrent())");
    };
  }

  public func OnBuff() -> Void {
    this.StopPrePsychosisFlow();
    this.StopPsychosisFlow();
  }

  public func OnBuffEnded() -> Void {
    this.InvalidateCurrentState();
  }

  public func OnEdgerunnerPerkActivated() -> Void {
    this.effectsHelper.CancelCycledFx();
  }

  public func OnRestoreAction(action: HumanityRestoringAction) -> Void {
    switch (action) {
      case HumanityRestoringAction.Sleep:
        this.StopEverythingNew();
        this.SetWentFullPsycho(false);
        if !this.config.fullHumanityRestoreOnSleep {
            let currentHumanitySleepMultiplier: Int32 = 0;
            // summing multiplier
            if this.humanityRestoringActionTakenLover { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenPet { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenDonation { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenApartment { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenSocial { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenShower { currentHumanitySleepMultiplier += 1; }
            // gain humanity based on our multiplier
            let amount: Int32 = (15 * currentHumanitySleepMultiplier) + 10;
            this.RemoveHumanityDamage(amount);
            // resetting state
            currentHumanitySleepMultiplier = 0;
            this.humanityRestoringActionTakenLover = false;
            this.humanityRestoringActionTakenPet = false;
            this.humanityRestoringActionTakenDonation = false;
            this.humanityRestoringActionTakenApartment = false;
            this.humanityRestoringActionTakenSocial = false;
            this.humanityRestoringActionTakenShower = false;
        } else {
            this.ResetHumanityDamage();
            this.ShowHumanityRestoredMessage();
        }
        StatusEffectHelper.RemoveStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff");
        E("! Rested, humanity value restored.");
        break;
      case HumanityRestoringAction.Lover:
        if !this.humanityRestoringActionTakenLover { StatusEffectHelper.ApplyStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff", this.player.GetEntityID()); }
        let amount: Int32 = this.config.restoreOnLover;
        this.humanityRestoringActionTakenLover = true;
        this.RemoveHumanityDamage(amount);
        E("! Lover, humanity restored");
        break;
      case HumanityRestoringAction.Social:
        if !this.humanityRestoringActionTakenSocial { StatusEffectHelper.ApplyStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff", this.player.GetEntityID());  }
        let amount: Int32 = this.config.restoreOnSocial;
        this.humanityRestoringActionTakenSocial = true;
        this.RemoveHumanityDamage(amount);
        E("! Social, humanity restored");
        break;
      case HumanityRestoringAction.Pet:
        if !this.humanityRestoringActionTakenPet { StatusEffectHelper.ApplyStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff", this.player.GetEntityID()); }
        let amount: Int32 = this.config.restoreOnPet;
        this.humanityRestoringActionTakenPet = true;
        this.RemoveHumanityDamage(amount);
        E("! Pet, humanity restored");
        break;
      case HumanityRestoringAction.Donation:
        if !this.humanityRestoringActionTakenDonation { StatusEffectHelper.ApplyStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff", this.player.GetEntityID()); }
        let amount: Int32 = this.config.restoreOnDonation;
        this.humanityRestoringActionTakenDonation = true;
        this.RemoveHumanityDamage(amount);
        E("! Donated some money, humanity restored");
        break;
      case HumanityRestoringAction.Apartment:
        if !this.humanityRestoringActionTakenApartment { StatusEffectHelper.ApplyStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff", this.player.GetEntityID()); }
        let amount: Int32 = this.config.restoreOnApartment;
        this.humanityRestoringActionTakenApartment = true;
        this.RemoveHumanityDamage(amount);
        E("! Apartment interaction, humanity restored");
        break;
      case HumanityRestoringAction.Shower:
        if !this.humanityRestoringActionTakenShower { StatusEffectHelper.ApplyStatusEffect(this.player, t"BaseStatusEffect.LifeAffirmedBuff", this.player.GetEntityID()); }
        let amount: Int32 = this.config.restoreOnShower;
        this.humanityRestoringActionTakenShower = true;
        this.RemoveHumanityDamage(amount);
        E("! Took a shower, humanity restored");
        break;
    };

    this.InvalidateCurrentState();
  }

  public func OnBerserkActivation(item: ItemID) -> Void {
    E("BERSERK ACTIVATED");
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(item);
    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.CommonPlus:
        qualityMult = this.config.qualityMultiplierCommonPlus;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.UncommonPlus:
        qualityMult = this.config.qualityMultiplierUncommonPlus;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.RarePlus:
        qualityMult = this.config.qualityMultiplierRarePlus;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.EpicPlus:
        qualityMult = this.config.qualityMultiplierEpicPlus;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
      case gamedataQuality.LegendaryPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlus;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlusPlus;
        break;
    };

    let cost: Float = Cast<Float>(this.config.berserkUsageCost) * qualityMult;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.AddHumanityDamage(cost);
      E(s"! Berserk activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, berserk costs no humanity");
    };

    this.DamageHealthToPercent(this.config.berserkUsageDamage);
  }

  public func OnOverClockActivation(itemRecord: ref<Item_Record>) -> Void {
    E("OVERCLOCK ACTIVATED");
    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.CommonPlus:
        qualityMult = this.config.qualityMultiplierCommonPlus;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.UncommonPlus:
        qualityMult = this.config.qualityMultiplierUncommonPlus;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.RarePlus:
        qualityMult = this.config.qualityMultiplierRarePlus;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.EpicPlus:
        qualityMult = this.config.qualityMultiplierEpicPlus;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
      case gamedataQuality.LegendaryPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlus;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlusPlus;
        break;
    };

    let cost: Float = Cast<Float>(this.config.overclockUsageCost) * qualityMult;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.AddHumanityDamage(cost);
      E(s"! Overclock activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, overclock costs no humanity");
    };

    this.DamageHealthToPercent(this.config.overclockUsageDamage);
  }

  public func OnSandevistanActivation(item: ItemID) -> Void {
    E("SANDEVISTAN ACTIVATED");
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(item);
    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.CommonPlus:
        qualityMult = this.config.qualityMultiplierCommonPlus;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.UncommonPlus:
        qualityMult = this.config.qualityMultiplierUncommonPlus;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.RarePlus:
        qualityMult = this.config.qualityMultiplierRarePlus;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.EpicPlus:
        qualityMult = this.config.qualityMultiplierEpicPlus;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
      case gamedataQuality.LegendaryPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlus;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlusPlus;
        break;
    };

    let cost: Float = Cast<Float>(this.config.sandevistanUsageCost) * qualityMult;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.AddHumanityDamage(cost);
      E(s"! Sandevistan activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, sandevistan costs no humanity");
    };

    this.DamageHealthToPercent(this.config.sandevistanUsageDamage);
  }

  public func OnKerenzikovActivation() -> Void {
    E("KERENZIKOV ACTIVATED");
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
      case gamedataQuality.CommonPlus:
        qualityMult = this.config.qualityMultiplierCommonPlus;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.UncommonPlus:
        qualityMult = this.config.qualityMultiplierUncommonPlus;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.RarePlus:
        qualityMult = this.config.qualityMultiplierRarePlus;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.EpicPlus:
        qualityMult = this.config.qualityMultiplierEpicPlus;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
      case gamedataQuality.LegendaryPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlus;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlusPlus;
        break;
    };

    let cost: Float = Cast<Float>(this.config.kerenzikovUsageCost) * qualityMult;

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.AddHumanityDamage(cost);
      E(s"! Kerenzikov activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, kerenzikov costs no humanity");
    };

    this.DamageHealthToPercent(this.config.kerenzikovUsageDamage);
  }

  public func OnOpticalCamoActivation() -> Void {
    E("OPTICAL CAMO ACTIVATED");
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
      case gamedataQuality.CommonPlus:
        qualityMult = this.config.qualityMultiplierCommonPlus;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.UncommonPlus:
        qualityMult = this.config.qualityMultiplierUncommonPlus;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.RarePlus:
        qualityMult = this.config.qualityMultiplierRarePlus;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.EpicPlus:
        qualityMult = this.config.qualityMultiplierEpicPlus;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
      case gamedataQuality.LegendaryPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlus;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlusPlus;
        break;
    };

    let cost: Float = Cast<Float>(this.config.opticalCamoUsageCost) * qualityMult;

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.AddHumanityDamage(cost);
      E(s"! Optical camo activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, optical camo costs no humanity");
    };

    this.DamageHealthToPercent(this.config.opticalCamoUsageDamage);
  }

  public func OnArmsCyberwareActivation(type: gamedataItemType) -> Void {
    let itemId: ItemID = EquipmentSystem.GetInstance(this.player).GetActiveItem(this.player, gamedataEquipmentArea.ArmsCW);
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    let itemType: gamedataItemType = RPGManager.GetItemType(itemId);
    
    if !IsDefined(itemRecord) {
      return;
    };

    E(s"ARMS CYBERWARE ACTIVATED: \(itemType)");

    let quality: gamedataQuality = itemRecord.Quality().Type();
    let qualityMult: Float;
    switch (quality) {
      case gamedataQuality.Common:
        qualityMult = this.config.qualityMultiplierCommon;
        break;
      case gamedataQuality.CommonPlus:
        qualityMult = this.config.qualityMultiplierCommonPlus;
        break;
      case gamedataQuality.Uncommon:
        qualityMult = this.config.qualityMultiplierUncommon;
        break;
      case gamedataQuality.UncommonPlus:
        qualityMult = this.config.qualityMultiplierUncommonPlus;
        break;
      case gamedataQuality.Rare:
        qualityMult = this.config.qualityMultiplierRare;
        break;
      case gamedataQuality.RarePlus:
        qualityMult = this.config.qualityMultiplierRarePlus;
        break;
      case gamedataQuality.Epic:
        qualityMult = this.config.qualityMultiplierEpic;
        break;
      case gamedataQuality.EpicPlus:
        qualityMult = this.config.qualityMultiplierEpicPlus;
        break;
      case gamedataQuality.Legendary:
        qualityMult = this.config.qualityMultiplierLegendary;
        break;
      case gamedataQuality.LegendaryPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlus;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        qualityMult = this.config.qualityMultiplierLegendaryPlusPlus;
        break;
    };

    let cost: Float;
    switch itemType {
      case gamedataItemType.Cyb_Launcher:
        cost = Cast<Float>(this.config.launcherUsageCost) * qualityMult;
        break;
      case gamedataItemType.Cyb_MantisBlades:
        cost = Cast<Float>(this.config.mantisBladesUsageCost) * qualityMult;
        break;
      case gamedataItemType.Cyb_NanoWires:
        cost = Cast<Float>(this.config.monowireUsageCost) *qualityMult;
        break;
      default:
        cost = 0;
        break;
    };

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.AddHumanityDamage(cost);
      E(s"! Arms cyberware activated: \(itemType) \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, arms cyberware costs no humanity");
    };

    switch itemType {
      case gamedataItemType.Cyb_Launcher:
        this.DamageHealthToPercent(this.config.launcherUsageDamage);
        break;
      case gamedataItemType.Cyb_MantisBlades:
        this.DamageHealthToPercent(this.config.mantisBladesUsageDamage);
        break;
      case gamedataItemType.Cyb_NanoWires:
        this.DamageHealthToPercent(this.config.monowireUsageDamage);
        break;
      default:
        break;
    };
  }


  // -- Handle Humanity

  public func IsWentFullPsycho() -> Bool {
    return this.wentFullPsycho;
  }

  public func SetWentFullPsycho(value: Bool) -> Void {
    this.wentFullPsycho = value;
  }

  public func AddHumanityDamage(cost: Float) -> Void {
    let total: Int32 = this.GetHumanityTotal();
    let damage: Int32 = CeilF(cost);

    // randomly an additional 5 humanity damage; life is cruel
    if this.config.cruelty {
        let random: Int32 = RandRange(0, 100);
        let crueltyThreshold: Int32 = 20;
        let triggered: Bool = random <= crueltyThreshold;
        if triggered {
           damage = CeilF(cost + 5.0);
           E(s"> AddHumanityDamage \(damage); random cruelty modifier applied.");
        };
    };

    this.currentHumanityDamage += damage;
    E(s"> AddHumanityDamage \(damage)");
    if this.currentHumanityDamage > total {
      this.currentHumanityDamage = total;
    };
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, this.currentHumanityDamage, true);
  }

  public func RemoveHumanityDamage(cost: Int32) -> Void {
    if cost > this.currentHumanityDamage {
      cost = this.currentHumanityDamage;
    };

    E(s"> RemoveHumanityDamage: current \(this.currentHumanityDamage), cost  \(cost ), after removal: \(this.currentHumanityDamage - cost)");
    this.currentHumanityDamage -= cost;
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, this.currentHumanityDamage, true);
    if cost > 0 {
      this.ShowHumanityRestoredMessage(cost);
    };
  }

  public func ResetHumanityDamage() -> Void {
    this.currentHumanityDamage = 0;
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, 0, true);
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
    let penalty: Int32 = this.GetTotalPenalty();
    let basePool: Int32 = this.config.baseHumanityPool;
    let playerLevel: Float = GameInstance.GetStatsSystem(this.player.GetGame()).GetStatValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatType.Level);
    let additionalPool: Int32 = Cast<Int32>(this.config.humanityBonusPerLevel * playerLevel);
    return basePool + additionalPool - penalty;
  }

  public func GetHumanityColor() -> CName {
    let color: CName;
    if this.currentHumanityPool > this.psychosisThreshold {
      color = n"MainColors.ActiveGreen"; 
    } else {
      color = n"MainColors.ActiveRed"; 
    };

    return color;
  }

  public func GetPsychosisThreshold() -> Int32 {
    return this.psychosisThreshold;
  }

  public func GetPsychosisChance() -> Int32 {
    return this.config.psychoChance;
  }

  public func InvalidateCurrentState(opt firstLoad: Bool) -> Void {
    let penalty: Int32 = this.GetTotalPenalty();
    let evt: ref<UpdateHumanityCounterEvent> = new UpdateHumanityCounterEvent();
    let basePool: Int32 = this.GetHumanityTotal();
    this.currentHumanityPool = basePool - this.currentHumanityDamage;
    if this.currentHumanityPool < 0 { this.currentHumanityPool = 0; };
    this.psychosisThreshold = this.config.psychosisThreshold;
    // Check if threshold > pool from incorrect mod settings
    if this.psychosisThreshold > basePool {
      this.psychosisThreshold = basePool / 2;
    };
    let log: String = "";
    log += s"total \(basePool), current \(this.currentHumanityPool), damage \(this.currentHumanityDamage) |";
    log += s" threshold \(this.psychosisThreshold) |";
    log += s" from mods \(penalty) |";
    log += s" light visuals \(this.config.lightVisuals)";
    E(s"INVALIDATE: \(log)");

    evt.current = this.GetHumanityCurrent();
    evt.total = this.GetHumanityTotal();
    evt.color = this.GetHumanityColor();
    GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(evt);

    if this.effectsChecker.IsRipperdocBuffActive() && !this.IsWentFullPsycho() { return; };
    if this.effectsChecker.IsNewPsychosisActive() { return; };
    if this.effectsChecker.IsNewPostPsychosisActive() { return; };
    
    // Detect post-psychosis
    if this.IsWentFullPsycho() && !this.effectsChecker.IsNewPostPsychosisActive() {
      this.RunPostPsychosisFlow();
      return ;
    }

    // Playing as Johnny - cancel effects
    if this.effectsChecker.IsPossessed() {
      this.StopEverythingNew();
      return ;
    };

    // Humanity restored - cancel effects
    if this.currentHumanityPool > this.psychosisThreshold {
      this.StopEverythingNew();
      return ;
    };

    // Detect psychosis
    if this.currentHumanityPool <= 0 && this.config.alwaysRunAtZero && !this.effectsChecker.IsNewPsychosisActive() {
      this.RunPsychosisFlow();
    };

    // Detect pre-psychosis
    if this.currentHumanityPool < this.psychosisThreshold && !this.effectsChecker.IsNewPrePsychosisActive() {
      this.RunPrePsychosisFlow();
      return ;
    };

    E("NO EFFECTS APPLIED");
  }

  public func IsPsychosisActive() -> Bool {
    return this.effectsChecker.IsNewPsychosisActive();
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
    return this.currentHumanityPool > this.psychosisThreshold;
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


  // -- Callback reactions

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
        this.psychosisCheckDelayId = this.delaySystem.DelayCallback(LaunchCycledPsychosisCheckCallback.Create(this), nextRun, true);
      };
    };
  }

  public func OnLaunchPostPsychosisCallback() -> Void {
    this.RunPostPsychosisFlow();
  }

  private func ShowHumanityRestoredMessage(opt amount: Int32) -> Void {
    let onScreenMessage: SimpleScreenMessage;
    let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
    let blackboard = GameInstance.GetBlackboardSystem(this.player.GetGame()).Get(blackboardDef);
    if amount > 0 {
      onScreenMessage.message = s"+\(amount) \(GetLocalizedTextByKey(n"Mod-Edg-Humanity"))";
    } else {
      onScreenMessage.message = GetLocalizedTextByKey(n"Mod-Edg-Humanity-Restored-Full");
    };

    onScreenMessage.isShown = true;
    onScreenMessage.duration = 3.00;
    blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
  }

  private func DamageHealthToPercent(value: Int32) -> Void {
    // let totalHealth: Float = this.statsSystem.GetStatPoolValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatPoolType.Health, false);
    let totalHealth: Float = this.statsSystem.GetStatValue(Cast<StatsObjectID>(GetPlayer(this.player.GetGame()).GetEntityID()), gamedataStatType.Health);
    let damageValue: Float = totalHealth * Cast<Float>(value) / 100.0;
    E(s"Damage health: total \(totalHealth), damage to \(damageValue)");
    this.statsPoolSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatPoolType.Health, -damageValue, null, false, false);
  }

  public static func Debug(gi: GameInstance) -> Void {
    let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(gi);
    // system.RunPsychosisFlow();
    // system.AddHumanityDamage(10.0);
    // system.InvalidateCurrentState(false);
    // system.effectsHelper.RunNewPrePsychosisEffect();
    // system.effectsHelper.RunNewPsychosisEffect();
    system.effectsHelper.RunNewPostPsychosisEffect();
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

public class LaunchPostPsychosisEffectCallback extends DelayCallback {
  let system: wref<EdgerunningSystem>;

  public static func Create(system: ref<EdgerunningSystem>) -> ref<LaunchPostPsychosisEffectCallback> {
    let self: ref<LaunchPostPsychosisEffectCallback> = new LaunchPostPsychosisEffectCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.OnLaunchPostPsychosisCallback();
  }
}

public class LaunchPostPsychosisHumanityRestoreCallback extends DelayCallback {
  let system: wref<EdgerunningSystem>;

  public static func Create(system: ref<EdgerunningSystem>) -> ref<LaunchPostPsychosisHumanityRestoreCallback> {
    let self: ref<LaunchPostPsychosisHumanityRestoreCallback> = new LaunchPostPsychosisHumanityRestoreCallback();
    self.system = system;
    return self;
  }

  public func Call() -> Void {
    this.system.RemoveHumanityDamage(10);
    this.system.InvalidateCurrentState();
  }
}
