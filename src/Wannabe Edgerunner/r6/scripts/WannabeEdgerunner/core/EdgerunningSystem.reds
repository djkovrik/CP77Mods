module Edgerunning.System
import Edgerunning.Common.E

public class EdgerunningSystem extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;

  private let phase: EdgerunningPhase;
  private let generation: Uint32;
  private let attachedCallback: Uint32;
  private let detachedCallback: Uint32;
  private let transitioning: Bool;
  private let psychosisCombat: ref<WEPsychosisCombat>;
  private let psychosisShooting: Bool = true;
  private let psychosisOutlines: Bool = true;
  private let psychosisExcludeCivilians: Bool;

  public func ConfigurePsychosisCombat(shoot: Bool, outline: Bool, excludeCivilians: Bool) -> Void {
    if IsDefined(this.psychosisCombat) { this.psychosisCombat.Stop(); };
    this.psychosisShooting = shoot;
    this.psychosisOutlines = outline;
    this.psychosisExcludeCivilians = excludeCivilians;
    this.PrintPsychosisCombatStatus();
  }

  public func PrintPsychosisCombatStatus() -> Void {
    FTLog(s"WE psychosisCombat shooting=\(this.psychosisShooting) outline=\(this.psychosisOutlines) excludeCivilians=\(this.psychosisExcludeCivilians) phase=\(this.phase) generation=\(this.generation); settings apply next episode");
    if IsDefined(this.psychosisCombat) { this.psychosisCombat.PrintStatus(); };
  }

  public func GetPlayer() -> wref<PlayerPuppet> { return this.player; }
  public func GetGeneration() -> Uint32 { return this.generation; }

  public func IsCrowdPsychosisCurrent(generation: Uint32, owner: ref<PlayerPuppet>) -> Bool {
    return Equals(this.phase, EdgerunningPhase.Psychosis) && this.generation == generation && this.player == owner && this.IsEpisodeContextSafe();
  }

  public func IsCallbackCurrent(generation: Uint32, owner: wref<PlayerPuppet>) -> Bool {
    if generation != this.generation || !IsDefined(owner) || owner != this.player { return false; };
    if !this.IsEpisodeContextSafe() { this.StopEverythingNew(); return false; };
    return true;
  }

  private func IsEpisodeContextSafe() -> Bool {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) || this.player.IsDead() { return false; };
    let controlled: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject();
    if controlled != this.player || this.effectsChecker.IsPossessed() || this.effectsChecker.IsRipperdocBuffActive() { return false; };
    let tier: Int32 = this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    return !(tier >= EnumInt(gamePSMHighLevel.SceneTier3) && tier <= EnumInt(gamePSMHighLevel.SceneTier5));
  }

  public func CanForceWeaponAction(opt preparingWeapon: Bool) -> Bool {
    if !Equals(this.phase, EdgerunningPhase.Psychosis) || this.IsPsychosisBlocked() { return false; };
    let upperBody: Int32 = this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody);
    return upperBody != EnumInt(gamePSMUpperBodyStates.Reload)
      && (preparingWeapon || upperBody != EnumInt(gamePSMUpperBodyStates.SwitchItems))
      && upperBody != EnumInt(gamePSMUpperBodyStates.SwitchCyberware)
      && (preparingWeapon || upperBody != EnumInt(gamePSMUpperBodyStates.TemporaryUnequip))
      && upperBody != EnumInt(gamePSMUpperBodyStates.ForceEmptyHands)
      && this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones) != EnumInt(gamePSMZones.Safe)
      && !StatusEffectSystem.ObjectHasStatusEffectWithTag(this.player, n"NoCombat")
      && !StatusEffectSystem.ObjectHasStatusEffectWithTag(this.player, n"NoWeapons");
  }

  public func CanRequestPoliceActivity() -> Bool {
    return Equals(this.phase, EdgerunningPhase.Psychosis) && !this.IsPsychosisBlocked() && this.IsPoliceSpawnAvailable();
  }

  public func CanBlackout() -> Bool { return this.IsPsychosisActive() && !this.IsPsychosisBlocked(); }

  public func BeginBlackout() -> Void {
    if IsDefined(this.psychosisCombat) { this.psychosisCombat.Stop(); };
    if Equals(this.phase, EdgerunningPhase.Psychosis) { this.phase = EdgerunningPhase.Blackout; };
  }

  // Only normal completion grants Humanity. Abort and load never replay the reward.
  public func FinishEpisode() -> Void {
    if !this.IsPsychosisActive() { return; };
    this.StopEverythingNew();
    this.RemoveHumanityDamage(10);
    this.RunPostPsychosisFlow();
    this.InvalidateCurrentState();
  }

  private func OnAttach() -> Void {
    let ps: ref<PlayerSystem> = GameInstance.GetPlayerSystem(this.GetGameInstance());
    if this.attachedCallback == 0u { this.attachedCallback = ps.RegisterPlayerPuppetAttachedCallback(this, n"OnEdgerunnerPlayerAttached"); };
    if this.detachedCallback == 0u { this.detachedCallback = ps.RegisterPlayerPuppetDetachedCallback(this, n"OnEdgerunnerPlayerDetached"); };
  }

  private func OnDetach() -> Void {
    this.StopEverythingNew();
    let ps: ref<PlayerSystem> = GameInstance.GetPlayerSystem(this.GetGameInstance());
    ps.UnregisterPlayerPuppetAttachedCallback(this.attachedCallback);
    ps.UnregisterPlayerPuppetDetachedCallback(this.detachedCallback);
    this.attachedCallback = 0u;
    this.detachedCallback = 0u;
    this.player = null;
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.StopEverythingNew();
    if IsDefined(this.player) { this.InvalidateCurrentState(true); };
  }

  private func OnEdgerunnerPlayerDetached(player: ref<GameObject>) -> Void {
    if player == this.player {
      this.StopEverythingNew();
      this.player = null;
      this.psmBB = null;
    };
  }

  private func OnEdgerunnerPlayerAttached(player: ref<GameObject>) -> Void {
    this.InitializePlayer(player as PlayerPuppet);
  }


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
  private let currentHumanityExact: Float;
  public let psychosisThreshold: Int32;
  public let psychosisCheckDelayId: DelayID;
  public let postPsychosisDelayId: DelayID;
  public let humanityRestoreDelayId: DelayID;

  private persistent let currentHumanityDamage: Int32 = 0;
  // Keep the legacy saved integer and its type. Old saves start with no remainder.
  private persistent let fractionalHumanityDamage: Float = 0.0;
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
    this.InitializePlayer(request.owner as PlayerPuppet);
  }

  private func InitializePlayer(player: ref<PlayerPuppet>) -> Void {
    if !IsDefined(player) || player == this.player { return; };
    this.StopEverythingNew();
    if IsDefined(player) {
      this.player = player;
      this.psmBB = this.player.GetPlayerStateMachineBlackboard();
      this.delaySystem = GameInstance.GetDelaySystem(this.player.GetGame());
      this.questsSystem = GameInstance.GetQuestsSystem(this.player.GetGame());
      this.statsSystem = GameInstance.GetStatsSystem(this.player.GetGame());
      this.statsPoolSystem = GameInstance.GetStatPoolsSystem(this.player.GetGame());

      this.config = new EdgerunningConfig();
      let durationModifiers: array<wref<StatModifier_Record>>;
      let durationRecord: ref<StatModifierGroup_Record> = TweakDBInterface.GetStatModifierGroupRecord(t"Items.EdgerunnerPsychosisDuration");
      if IsDefined(durationRecord) {
        durationRecord.StatModifiers(durationModifiers);
        if ArraySize(durationModifiers) > 0 {
          this.config.psychoDuration = TweakDBInterface.GetFloat(durationModifiers[0].GetID() + t".value", this.config.psychoDuration);
        };
      };
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
      if !IsDefined(this.additionalPenalties) {
        this.additionalPenalties = new inkIntHashMap();
        ArrayClear(this.additionalPenaltiesKeys);
      };

      this.InvalidateCurrentState(true);
    };

  }


  public func RunPrePsychosisFlow() -> Void {
    if this.IsPsychosisActive() || Equals(this.phase, EdgerunningPhase.Recovery) || Equals(this.phase, EdgerunningPhase.PrePsychosis) || !this.IsEpisodeContextSafe() {
      E("? Pre-Psychosis already active - do nothing");
      return ;
    };

    this.StopEverythingNew();
    this.phase = EdgerunningPhase.PrePsychosis;
    this.effectsHelper.RunNewPrePsychosisEffect();
    this.ScheduleNextPsychoCheck();
  }

  public func RunPsychosisFlow() -> Void {
    if this.IsPsychosisActive() || this.IsPsychosisBlocked() {
      E("? Psychosis already active - do nothing");
      return ;
    };
    
    this.StopEverythingNew();
    this.phase = EdgerunningPhase.Psychosis;
    this.effectsHelper.RefreshConfig();
    this.preventionHelper.RefreshConfig(this.config);
    this.effectsHelper.RunNewPsychosisEffect();
    this.SetWentFullPsycho(true);

    if this.psychosisShooting || this.psychosisOutlines {
      this.psychosisCombat = new WEPsychosisCombat();
      this.psychosisCombat.Start(this, this.psychosisShooting, this.psychosisOutlines, this.psychosisExcludeCivilians, this.effectsHelper.GetPsychosisOutlineDelay());
    };
    if this.IsPoliceSpawnAvailable() { this.preventionHelper.SchedulePoliceActivity(6.0); };
    this.effectsHelper.ScheduleCycledSfx(this.config.lightVisuals ? 3.0 : 7.0);

    let psychoDuration: Float = this.config.psychoDuration;
    if this.config.teleportOnEnd {
      this.teleportHelper.ScheduleTeleport(psychoDuration + 1.0);
    } else {
      this.SchedulePostPsychosisEffect(psychoDuration + 2.0);
    };

  }

  public func RunPostPsychosisFlow() -> Void {
    if this.IsPsychosisActive() { this.FinishEpisode(); return; };
    if !this.IsEpisodeContextSafe() || Equals(this.phase, EdgerunningPhase.Recovery) { return; };
    this.StopEverythingNew();
    this.phase = EdgerunningPhase.Recovery;
    this.effectsHelper.RefreshConfig();
    this.effectsHelper.RunNewPostPsychosisEffect();
  }

  public func ScheduleNextPsychoCheck() -> Void {
    this.delaySystem.CancelCallback(this.psychosisCheckDelayId);
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    E(s"? Psycho check - scheduled after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayCallback(LaunchCycledPsychosisCheckCallback.Create(this), nextRun, true);
  }

  public func SchedulePostPsychosisEffect(delay: Float) -> Void {
    this.delaySystem.CancelCallback(this.postPsychosisDelayId);
    E(s"? Post Psycho effect - scheduled after \(delay) seconds");
    this.postPsychosisDelayId = this.delaySystem.DelayCallback(LaunchPostPsychosisEffectCallback.Create(this), delay, true);
  }

  public func ScheduleHumanityRestoreEffect(delay: Float) -> Void {
    this.delaySystem.CancelCallback(this.humanityRestoreDelayId);
    E(s"? Post Psycho Humanity restore - scheduled after \(delay) seconds");
    this.humanityRestoreDelayId = this.delaySystem.DelayCallback(LaunchPostPsychosisHumanityRestoreCallback.Create(this), delay, true);
  }


  public func StopPrePsychosisFlow() -> Void {
    if Equals(this.phase, EdgerunningPhase.PrePsychosis) { this.StopEverythingNew(); };
  }

  public func StopPsychosisFlow() -> Void {
    if this.IsPsychosisActive() { this.StopEverythingNew(); };
  }

  public func StopPostPsychosisFlow() -> Void {
    if Equals(this.phase, EdgerunningPhase.Recovery) { this.StopEverythingNew(); };
  }

  public func StopEverythingNew() -> Void {
    if this.transitioning { return; };
    this.transitioning = true;
    this.generation += 1u;
    this.phase = EdgerunningPhase.Idle;
    if IsDefined(this.psychosisCombat) { this.psychosisCombat.Stop(); };
    if IsDefined(this.delaySystem) {
      this.delaySystem.CancelCallback(this.psychosisCheckDelayId);
      this.delaySystem.CancelCallback(this.postPsychosisDelayId);
      this.delaySystem.CancelCallback(this.humanityRestoreDelayId);
      this.psychosisCheckDelayId = GetInvalidDelayID();
      this.postPsychosisDelayId = GetInvalidDelayID();
      this.humanityRestoreDelayId = GetInvalidDelayID();
    };
    if IsDefined(this.effectsHelper) {
      this.effectsHelper.CancelPendingFx();
      this.effectsHelper.CancelCycledFx();
      this.effectsHelper.StopNewPrePsychosisEffect();
      this.effectsHelper.StopNewPsychosisEffect();
      this.effectsHelper.StopNewPostPsychosisEffect();
      this.effectsHelper.CancelOtherFxes();
    };
    if IsDefined(this.preventionHelper) { this.preventionHelper.CancelScheduledPreventionActivity(); };
    if IsDefined(this.teleportHelper) { this.teleportHelper.CancelScheduledTeleportEvents(); };
    this.transitioning = false;
  }


  public func OnPossessionChanged(playerPossesion: gamedataPlayerPossesion) -> Void {
    if !IsDefined(this.effectsChecker) { return; };
    this.StopEverythingNew();
    this.effectsChecker.OnPossessionChanged(playerPossesion);
    this.InvalidateCurrentState();
  }

  public func OnSettingsChanged() -> Void {
    if !IsDefined(this.player) { return; };
    let oldLightVisuals: Bool = this.config.lightVisuals;
    let duration: Float = this.config.psychoDuration;
    this.config = new EdgerunningConfig();
    // This setting is marked restart-required and also controls a TweakDB duration.
    this.config.psychoDuration = duration;
    if !this.IsPsychosisActive() {
      if NotEquals(oldLightVisuals, this.config.lightVisuals) { this.StopEverythingNew(); };
      this.effectsHelper.RefreshConfig();
      this.preventionHelper.RefreshConfig(this.config);
    };
    this.InvalidateCurrentState();
  }

  public func OnEnemyKilled(affiliation: gamedataAffiliation) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
    if this.effectsChecker.IsPossessed() {
      this.StopEverythingNew();
      E(s"! Playing as Johnny - all effects removed");
      return ;
    };

    let cost: Float;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      cost = Cast<Float>(EnemyCostHelper.GetEnemyCost(affiliation, this.config));
      this.AddHumanityDamage(cost);
      this.InvalidateCurrentState();
      E(s"! Killed \(affiliation), humanity -\(cost)");
    } else {
      E(s"! Humanity freezed, kill costs no humanity | current humanity: \(this.GetHumanityCurrent())");
    };
  }

  public func OnBuff() -> Void {
    this.StopEverythingNew();
  }

  public func OnBuffEnded() -> Void {
    this.InvalidateCurrentState();
  }

  public func OnEdgerunnerPerkActivated() -> Void {
    if !IsDefined(this.effectsHelper) { return; };
    this.effectsHelper.CancelCycledFx();
  }

  public func OnRestoreAction(action: HumanityRestoringAction) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.config) || this.effectsChecker.IsPossessed() { return; };
    switch (action) {
      case HumanityRestoringAction.Sleep:
        this.StopEverythingNew();
        this.SetWentFullPsycho(false);
        if !this.config.fullHumanityRestoreOnSleep {
            let currentHumanitySleepMultiplier: Int32 = 0;
            if this.humanityRestoringActionTakenLover { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenPet { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenDonation { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenApartment { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenSocial { currentHumanitySleepMultiplier += 1; }
            if this.humanityRestoringActionTakenShower { currentHumanitySleepMultiplier += 1; }
            let amount: Int32 = (15 * currentHumanitySleepMultiplier) + 10;
            this.RemoveHumanityDamage(amount);
        } else {
            this.ResetHumanityDamage();
            this.ShowHumanityRestoredMessage();
        }
        this.humanityRestoringActionTakenLover = false;
        this.humanityRestoringActionTakenPet = false;
        this.humanityRestoringActionTakenDonation = false;
        this.humanityRestoringActionTakenApartment = false;
        this.humanityRestoringActionTakenSocial = false;
        this.humanityRestoringActionTakenShower = false;
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
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
    E("BERSERK ACTIVATED");
    if !ItemID.IsValid(item) {
      E("Berserk item is not valid, skip");
      return;
    };

    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(item);
    if !IsDefined(itemRecord) {
      E("Berserk item record is not defined, skip");
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

    let cost: Float = Cast<Float>(this.config.berserkUsageCost) * qualityMult;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Berserk activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, berserk costs no humanity");
    };

    this.DamageHealthToPercent(this.config.berserkUsageDamage);
  }

  public func OnOverClockActivation(itemRecord: ref<Item_Record>) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
    E("OVERCLOCK ACTIVATED");
    if !IsDefined(itemRecord) {
      E("Overclock item record is not defined, skip");
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

    let cost: Float = Cast<Float>(this.config.overclockUsageCost) * qualityMult;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Overclock activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, overclock costs no humanity");
    };

    this.DamageHealthToPercent(this.config.overclockUsageDamage);
  }

  public func OnSandevistanActivation(item: ItemID) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
    E("SANDEVISTAN ACTIVATED");
    if !ItemID.IsValid(item) {
      E("Sandevistan item is not valid, skip");
      return;
    };

    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(item);
    if !IsDefined(itemRecord) {
      E("Sandevistan item record is not defined, skip");
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

    let cost: Float = Cast<Float>(this.config.sandevistanUsageCost) * qualityMult;
    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Sandevistan activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, sandevistan costs no humanity");
    };

    this.DamageHealthToPercent(this.config.sandevistanUsageDamage);
  }

  public func OnKerenzikovActivation() -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
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

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Kerenzikov activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, kerenzikov costs no humanity");
    };

    this.DamageHealthToPercent(this.config.kerenzikovUsageDamage);
  }

  public func OnOpticalCamoActivation() -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
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

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Optical camo activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, optical camo costs no humanity");
    };

    this.DamageHealthToPercent(this.config.opticalCamoUsageDamage);
  }


  public func OnBloodPumpActivation() -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
    E("BLOOD PUMP ACTIVATED");
    let itemRecord: ref<Item_Record> = this.cyberwareHelper.GetCurrentBloodPump();
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

    let cost: Float = Cast<Float>(this.config.bloodPumpUsageCost) * qualityMult;

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Blood Pump activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, blood pump costs no humanity");
    };
  }

  public func OnArmsCyberwareActivation(type: gamedataItemType) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) { return; };
    let itemId: ItemID = EquipmentSystem.GetInstance(this.player).GetActiveItem(this.player, gamedataEquipmentArea.ArmsCW);
    if !ItemID.IsValid(itemId) {
      E("Arms cyberware item is not valid, skip");
      return;
    };

    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    if !IsDefined(itemRecord) {
      E("Arms cyberware item record is not defined, skip");
      return;
    };

    this.OnArmsCyberwareAttack(type, itemRecord);
  }

  public func OnArmsCyberwareAttack(type: gamedataItemType, itemRecord: ref<Item_Record>) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.effectsChecker) || !IsDefined(itemRecord) { return; };

    E(s"ARMS CYBERWARE ACTIVATED: \(type)");

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
    switch type {
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

    if !this.effectsChecker.IsRipperdocBuffActive() && !this.IsRecoveryActive() {
      this.AddHumanityDamage(cost);
      E(s"! Arms cyberware activated: \(type) \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, arms cyberware costs no humanity");
    };

    switch type {
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



  public func IsWentFullPsycho() -> Bool {
    return this.wentFullPsycho;
  }

  public func SetWentFullPsycho(value: Bool) -> Void {
    this.wentFullPsycho = value;
  }

  public func AddHumanityDamage(cost: Float) -> Void {
    if cost <= 0.0 || !IsDefined(this.player) || !IsDefined(this.config) { return; };
    if this.effectsChecker.IsPossessed() || this.effectsChecker.IsRipperdocBuffActive() { return; };
    let total: Int32 = this.GetHumanityTotal();
    let exactCost: Float = cost;

    if this.config.cruelty {
        let random: Int32 = RandRange(0, 100);
        let crueltyThreshold: Int32 = 20;
        let triggered: Bool = random < crueltyThreshold;
        if triggered {
           exactCost += 5.0;
        };
    };

    this.currentHumanityDamage = Clamp(this.currentHumanityDamage, 0, total);
    // Split only the incoming cost, avoiding loss of precision in a large saved integer.
    let available: Int32 = total - this.currentHumanityDamage;
    let combined: Float = exactCost + this.fractionalHumanityDamage;
    if combined >= Cast<Float>(available) {
      this.currentHumanityDamage = total;
      this.fractionalHumanityDamage = 0.0;
      this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, total, true);
      return;
    };
    let damage: Int32 = FloorF(combined);
    this.fractionalHumanityDamage = combined - Cast<Float>(damage);
    // Float arithmetic must not leave a phantom point after e.g. ten 1.1 costs.
    if this.fractionalHumanityDamage > 0.99999 {
      damage += 1;
      this.fractionalHumanityDamage = 0.0;
    };
    if this.fractionalHumanityDamage < 0.00001 { this.fractionalHumanityDamage = 0.0; };
    this.currentHumanityDamage += Min(damage, total - this.currentHumanityDamage);
    E(s"> AddHumanityDamage \(damage)");
    if this.currentHumanityDamage > total {
      this.currentHumanityDamage = total;
    };
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, this.currentHumanityDamage, true);
  }

  public func RemoveHumanityDamage(cost: Int32) -> Void {
    if !IsDefined(this.player) { return; };
    cost = Max(0, cost);
    this.currentHumanityDamage = Max(0, this.currentHumanityDamage);
    if cost > this.currentHumanityDamage { this.fractionalHumanityDamage = 0.0; };
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
    this.fractionalHumanityDamage = 0.0;
    if IsDefined(this.psmBB) { this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, 0, true); };
  }

  public func AddHumanityPenalty(key: String, value: Int32) -> Void {
    if !IsDefined(this.additionalPenalties) { this.additionalPenalties = new inkIntHashMap(); };
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
    if !IsDefined(this.additionalPenalties) { return; };
    ArrayRemove(this.additionalPenaltiesKeys, key);
    let hash: Uint64 = this.Hash(key);
    if this.additionalPenalties.Remove(hash) {
      this.InvalidateCurrentState();
    };
  }

  public func GetPenaltyByKey(key: String) -> Int32 {
    if !IsDefined(this.additionalPenalties) { return -1; };
    let hash: Uint64 = this.Hash(key);
    if !this.additionalPenalties.KeyExist(hash) {
      return -1;
    };

    return this.additionalPenalties.Get(hash);
  }

  public func GetTotalPenalty() -> Int32 {
    if !IsDefined(this.additionalPenalties) { return 0; };
    let penalties: array<Int32>;
    let sum: Int64 = 0l;
    this.additionalPenalties.GetValues(penalties);
    for penalty in penalties { sum += Cast<Int64>(penalty); };
    if sum > 2147483647l { return 2147483647; };
    if sum < -2147483647l { return -2147483647; };
    return Cast<Int32>(sum);
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
      if value > 0 {
        presentation = s"-\(value)";
      } else {
        presentation = s"+\(Abs(value))";
      };
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

  public func GetHumanityCurrentExact() -> Float {
    return this.currentHumanityExact;
  }

  public func GetHumanityTotal() -> Int32 {
    if !IsDefined(this.player) || !IsDefined(this.config) { return 1; };
    let penalty: Int32 = this.GetTotalPenalty();
    let basePool: Int32 = this.config.baseHumanityPool;
    let playerLevel: Float = GameInstance.GetStatsSystem(this.player.GetGame()).GetStatValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatType.Level);
    let additionalPool: Int32 = Cast<Int32>(this.config.humanityBonusPerLevel * playerLevel);
    let total: Int64 = Cast<Int64>(basePool) + Cast<Int64>(additionalPool) - Cast<Int64>(penalty);
    if total < 1l { return 1; };
    if total > 2147483647l { return 2147483647; };
    return Cast<Int32>(total);
  }

  public func GetHumanityColor() -> CName {
    let color: CName;
    if this.currentHumanityExact >= Cast<Float>(this.psychosisThreshold) {
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
    if !IsDefined(this.config) || this.psychosisThreshold <= 0 { return 0; };
    if this.currentHumanityExact >= Cast<Float>(this.psychosisThreshold) { return 0; };
    let deficit: Float = ClampF(1.0 - this.currentHumanityExact / Cast<Float>(this.psychosisThreshold), 0.0, 1.0);
    return Clamp(RoundF(Cast<Float>(this.config.psychoChance) * (1.0 + 2.0 * deficit)), 0, 100);
  }

  public func InvalidateCurrentState(opt firstLoad: Bool) -> Void {
    if !IsDefined(this.player) || !IsDefined(this.config) || this.transitioning { return; };
    let evt: ref<UpdateHumanityCounterEvent> = new UpdateHumanityCounterEvent();
    let basePool: Int32 = this.GetHumanityTotal();
    this.currentHumanityDamage = Clamp(this.currentHumanityDamage, 0, basePool);
    this.fractionalHumanityDamage = ClampF(this.fractionalHumanityDamage, 0.0, 0.99999);
    if this.currentHumanityDamage == basePool { this.fractionalHumanityDamage = 0.0; };
    this.psmBB.SetInt(GetAllBlackboardDefs().PlayerStateMachine.HumanityDamage, this.currentHumanityDamage, true);
    this.currentHumanityPool = basePool - this.currentHumanityDamage;
    this.currentHumanityExact = Cast<Float>(this.currentHumanityPool) - this.fractionalHumanityDamage;
    // HUD/public Int32 API rounds the remaining pool up; risk uses the exact value.
    if this.currentHumanityPool < 0 { this.currentHumanityPool = 0; };
    this.psychosisThreshold = Max(0, this.config.psychosisThreshold);
    if this.psychosisThreshold > basePool {
      this.psychosisThreshold = basePool / 2;
    };
    evt.current = this.GetHumanityCurrent();
    evt.total = basePool;
    evt.color = this.GetHumanityColor();
    GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(evt);

    if !this.IsEpisodeContextSafe() { this.StopEverythingNew(); return; };
    if this.IsPsychosisActive() { return; };
    // Preserve the existing until-sleep consequence. Expiry of the presentation
    // effect must not create a window in which cyberware costs change.
    if !this.IsWentFullPsycho() && Equals(this.phase, EdgerunningPhase.Recovery) { this.StopEverythingNew(); };
    if this.IsWentFullPsycho() {
      if !Equals(this.phase, EdgerunningPhase.Recovery) {
        this.RunPostPsychosisFlow();
      } else {
        if !this.effectsChecker.IsNewPostPsychosisActive() { this.effectsHelper.RunNewPostPsychosisEffect(); };
      };
      return;
    };
    if this.currentHumanityExact >= Cast<Float>(this.psychosisThreshold) { this.StopEverythingNew(); return; };
    if this.currentHumanityPool <= 0 && this.config.alwaysRunAtZero && !this.IsPsychosisBlocked() {
      this.RunPsychosisFlow();
      return;
    };
    if this.currentHumanityExact < Cast<Float>(this.psychosisThreshold) || (this.currentHumanityPool == 0 && this.config.alwaysRunAtZero) {
      this.RunPrePsychosisFlow();
      return;
    };

    E("NO EFFECTS APPLIED");
  }

  public func IsPsychosisActive() -> Bool {
    return Equals(this.phase, EdgerunningPhase.Psychosis) || Equals(this.phase, EdgerunningPhase.Blackout);
  }


  public func IsRecoveryActive() -> Bool {
    return Equals(this.phase, EdgerunningPhase.Recovery) && this.IsEpisodeContextSafe();
  }

  public func OnRecoveryEffectRemoved() -> Void {
    if !this.transitioning && Equals(this.phase, EdgerunningPhase.Recovery) {
      this.InvalidateCurrentState();
    };
  }


  private func IsPoliceSpawnAvailable() -> Bool {
    let zone: Int32 = this.psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let zoneEnum: gamePSMZones = IntEnum(zone);
    let isInInterior: Bool = IsEntityInInteriorArea(this.player);
    let result: Bool = zone < 3 && !isInInterior;
    E(s"CanSpawnPolice - zone: \(zoneEnum) \(zone), is in interior: \(isInInterior) -> can spawn: \(result)");
    return result;
  }

  private func IsHumanityRestored() -> Bool {
    return this.currentHumanityExact >= Cast<Float>(this.psychosisThreshold);
  }

  private func IsPsychosisBlocked() -> Bool {
    if !this.IsEpisodeContextSafe() { return true; };
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



  private func Hash(str: String) -> Uint64 {
    return TDBID.ToNumber(TDBID.Create(str));
  }



  public func OnLaunchCycledPsychosisCheckCallback() -> Void {
    this.psychosisCheckDelayId = GetInvalidDelayID();
    if !Equals(this.phase, EdgerunningPhase.PrePsychosis) { return; };
    let random: Int32 = RandRange(0, 100);
    let threshold: Int32 = this.GetPsychosisChance();
    let triggered: Bool = random < threshold;
    let forcedRun: Bool = Equals(this.currentHumanityPool, 0) && this.config.alwaysRunAtZero;
    E(s"? Run psychosis trigger check: roll \(random) against \(threshold), triggered: \(triggered), forced run: \(forcedRun)");
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    if (triggered || forcedRun) && !this.IsPsychosisBlocked() {
      this.RunPsychosisFlow();
    } else {
      if !this.IsHumanityRestored() {
        E(s"? Rescheduled next psycho check after \(nextRun) seconds");
        this.psychosisCheckDelayId = this.delaySystem.DelayCallback(LaunchCycledPsychosisCheckCallback.Create(this), nextRun, true);
      };
    };
  }

  public func OnLaunchPostPsychosisCallback() -> Void {
    this.FinishEpisode();
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
    if !this.IsRecoveryActive() {
      E("Post-psychosis is not active, skip");
      return ;
    };

    let totalHealth: Float = this.statsSystem.GetStatValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatType.Health);
    let damageValue: Float = totalHealth * Cast<Float>(value) / 100.0;
    E(s"Damage health: total \(totalHealth), damage to \(damageValue)");
    this.statsPoolSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.player.GetEntityID()), gamedataStatPoolType.Health, -damageValue, null, false, false);
  }
}

public class LaunchCycledPsychosisCheckCallback extends EdgerunningEpisodeCallback {
  let system: wref<EdgerunningSystem>;

  public static func Create(system: ref<EdgerunningSystem>) -> ref<LaunchCycledPsychosisCheckCallback> {
    let self: ref<LaunchCycledPsychosisCheckCallback> = new LaunchCycledPsychosisCheckCallback();
    self.system = system;
    self.BindEpisode(system.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.system) {
      this.system.OnLaunchCycledPsychosisCheckCallback();
    };
  }
}

public class LaunchPostPsychosisEffectCallback extends EdgerunningEpisodeCallback {
  let system: wref<EdgerunningSystem>;

  public static func Create(system: ref<EdgerunningSystem>) -> ref<LaunchPostPsychosisEffectCallback> {
    let self: ref<LaunchPostPsychosisEffectCallback> = new LaunchPostPsychosisEffectCallback();
    self.system = system;
    self.BindEpisode(system.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.system) {
      this.system.OnLaunchPostPsychosisCallback();
    };
  }
}

public class LaunchPostPsychosisHumanityRestoreCallback extends EdgerunningEpisodeCallback {
  let system: wref<EdgerunningSystem>;

  public static func Create(system: ref<EdgerunningSystem>) -> ref<LaunchPostPsychosisHumanityRestoreCallback> {
    let self: ref<LaunchPostPsychosisHumanityRestoreCallback> = new LaunchPostPsychosisHumanityRestoreCallback();
    self.system = system;
    self.BindEpisode(system.GetPlayer());
    return self;
  }

  public func Call() -> Void {
    if !this.IsCurrentEpisode() { return; };
    if IsDefined(this.system) {
      this.system.FinishEpisode();
    };
  }
}
