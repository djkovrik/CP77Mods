module Edgerunning.System
import Edgerunning.Common.E

public class EdgerunningSystem extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;

  private let delaySystem: ref<DelaySystem>;

  private let cyberpsychosisSFX: array<ref<SFXBundle>>;

  private let cycledSFXDelayId: DelayID;

  private let policeActivityDelayId: DelayID;

  private let drawWeaponDelayId: DelayID;

  private let randomShotsDelayId: DelayID;

  private let psychosisCheckDelayId: DelayID;

  private let config: ref<EdgerunningConfig>;

  private let currentHumanityPool: Int32;

  private let cyberwareCost: Int32;

  private let upperThreshold: Int32;

  private let lowerThreshold: Int32;

  private persistent let currentHumanityDamage: Int32 = 0;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.player = player;
      this.delaySystem = GameInstance.GetDelaySystem(this.player.GetGame());

      this.RefreshConfig();

      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_breath_heavy", 3.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_pain_short", 7.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_exhale_02", 4.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_pain_long", 4.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ONO_V_LongPain", 7.0));
      ArrayPush(this.cyberpsychosisSFX, SFXBundle.Create(n"ono_v_fear_panic_scream", 6.0));

      E("Edgerunning System initialized");
    };
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<EdgerunningSystem> {
    let system: ref<EdgerunningSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"Edgerunning.System.EdgerunningSystem") as EdgerunningSystem;
    return system;
  }


  // -- INVALIDATE

  public func InvalidateCurrentState() -> Void {
    let evt: ref<UpdateHumanityCounterEvent> = new UpdateHumanityCounterEvent();
    let basePool: Int32 = this.config.baseHumanityPool;
    let installedCyberware: Int32 = this.GetCurrentCyberwareCost(true);
    this.cyberwareCost = installedCyberware;
    this.currentHumanityPool = basePool - installedCyberware - this.currentHumanityDamage;
    if this.currentHumanityPool < 0 { this.currentHumanityPool = 0; };
    this.upperThreshold = this.config.glitchesThreshold;
    this.lowerThreshold = this.config.psychosisThreshold;
    E("Current humanity points state:");
    E(s" - total: \(basePool) humanity, installed cyberware cost: \(installedCyberware), points left: \(this.currentHumanityPool), can be recovered: \(this.currentHumanityDamage)");
    E(s" - debuffs for \(this.upperThreshold) and lower, cyberpsychosis for \(this.lowerThreshold) and lower");
    if this.currentHumanityPool < this.upperThreshold && this.currentHumanityPool >= this.lowerThreshold {
      this.RunFirstStageIfNotActive();
    } else {
      if this.currentHumanityPool < this.lowerThreshold && this.currentHumanityPool > 0 {
        this.RunSecondStageIfNotActive();
      } else {
        if Equals(this.currentHumanityPool, 0) && this.config.alwaysRunAtZero {
          this.RunLastStageIfNotActive();
        };
      };
    };

    evt.current = this.GetHumanityCurrent();
    evt.total = this.GetHumanityTotal();
    evt.color = this.GetHumanityColor();
    GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(evt);
    this.PrintRemainingPoolDetails();
  }

  public func RunFirstStageIfNotActive() -> Void {
    if this.IsGlitchesActive() { return; };

    if this.IsPrePsychosisActive() {
      this.StopPrePsychosislitch();
      this.StopPsychoChecks();
      this.StopPsychosis();
    };

    this.RunLowHumanityGlitch();
  }

  public func RunSecondStageIfNotActive() -> Void {
    if this.IsPrePsychosisActive() { return; };
    if this.IsGlitchesActive() { this.StopLowHumanityGlitch(); }

    this.RunPrePsychosisGlitch();
    this.ScheduleNextPsychoCheck();
  }

  public func RunLastStageIfNotActive() -> Void {
    if this.IsPsychosisActive() { return; };
    
    this.RunPsychosis();
  }

  // -- CONTROL EFFECTS FLOW

  public func RunLowHumanityGlitch() -> Void {
    E("!!! RUN STAGE 1 - GLITCHES");
    this.StopVFX(n"hacking_glitch_low");
    this.PlayVFXDelayed(n"fx_damage_high", 0.5);
    this.PlaySFXDelayed(n"ono_v_pain_short", 0.5);
    this.PlayVFXDelayed(n"personal_link_glitch", 0.75);
    this.PlaySFXDelayed(n"ono_v_fear_panic_scream ", 1.7);
    this.PlayVFXDelayed(n"disabling_connectivity_glitch", 1.8);
    this.PlayVFXDelayed(n"hacking_glitch_low", 3.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
  }

  public func RunPrePsychosisGlitch() -> Void {
    E("!!! RUN STAGE 2 - PRE-PSYCHOSIS");
    this.StopVFX(n"hacking_glitch_low");
    this.StopVFX(n"reboot_glitch");
    this.PlaySFXDelayed(n"ono_v_pain_short", 0.5);
    this.PlayVFXDelayed(n"reboot_glitch", 0.5);
    this.PlayVFXDelayed(n"hacking_glitch_low", 2.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 3.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch", 4.0);
  }

  private func RunPsychosis() -> Void {
    E("!!! RUN STAGE 2 - PSYCHOSIS");

    this.ScheduleNextPsychoCheck();

    if this.IsPsychosisBlocked() {
      E("? Skipped");
      return ;
    };
    
    this.StopVFX(n"hacking_glitch_low");
    this.ApplyStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff", 0.1);
    this.PlayVFXDelayed(n"hacking_glitch_low", 7.0);
    this.drawWeaponDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new TriggerDrawWeaponRequest(), 4.5);
    this.randomShotsDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new TriggerRandomShotRequest(), 6.5);

    if this.CanSpawnPolice() {
      this.policeActivityDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchPoliceActivityRequest(), 6.0);
    };

    this.cycledSFXDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledSFXRequest(), 7.0);
  }

  public func ScheduleNextPsychoCheck() -> Void {
    E("!!! RUN STAGE 2 - CHECKS");
    this.StopPsychoChecks();
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    E(s"? Scheduled next psycho check from ScheduleNextPsychoCheck after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledPsychosisCheckRequest(), nextRun);
  }

  public func RemoveAllEffects() -> Void {
    this.StopLowHumanityGlitch();
    this.StopPrePsychosislitch();
    this.StopPsychosis();
    this.StopPsychoChecks();
  }

  public func StopLowHumanityGlitch() -> Void {
    E("!!! STOP STAGE 1 - GLITCHES");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
    this.StopVFX(n"hacking_glitch_low");
  };

  public func StopPrePsychosislitch() -> Void {
    E("!!! STOP STAGE 2 - PRE-PSYCHOSIS");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch", 0.1);
    this.StopVFX(n"hacking_glitch_low");
  };

  private func StopPsychosis() -> Void {
    E("!!! STOP STAGE 2 - PSYCHOSIS");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff", 0.1);
    this.delaySystem.CancelCallback(this.drawWeaponDelayId);
    this.delaySystem.CancelCallback(this.randomShotsDelayId);
    this.delaySystem.CancelCallback(this.policeActivityDelayId);
    this.delaySystem.CancelCallback(this.cycledSFXDelayId);
  };

  public func StopPsychoChecks() -> Void {
    E("!!! STOP PRE STAGE 2 - CHECKS");
    this.delaySystem.CancelCallback(this.psychosisCheckDelayId);
  }

  // -- CONTROL HUMANITY

  public func OnCyberwareInstalled(itemId: ItemID) -> Void {
    E(s"Call for OnCyberwareInstalled for \(TDBID.ToStringDEBUG(ItemID.GetTDBID(itemId))), current cost: \(this.cyberwareCost)");
    let record: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    let name: CName = record.DisplayName();
    let quality: gamedataQuality = record.Quality().Type();
    let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(this.player.GetGame());
    let cost: Int32 = system.GetCyberwareCost(record);
    E(s">>> Installed \(GetLocalizedTextByKey(name)) - \(quality) by \(cost) humanity");
    this.InvalidateCurrentState();
  }

  public func OnCyberwareUninstalled(itemId: ItemID) -> Void {
    let record: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    let name: CName = record.DisplayName();
    let quality: gamedataQuality = record.Quality().Type();
    let system: ref<EdgerunningSystem> = EdgerunningSystem.GetInstance(this.player.GetGame());
    let cost: Int32 = system.GetCyberwareCost(record);
    E(s"<<< Uninstalled \(GetLocalizedTextByKey(name)) - \(quality) by \(cost) humanity");
    this.InvalidateCurrentState();
  }

  public func OnEnemyKilled(affiliation: gamedataAffiliation) -> Void {
    let cost: Int32;
    if !this.IsHumanityChangeBlocked() {
      cost = this.GetEnemyCost(affiliation);
      this.currentHumanityDamage += cost;
      this.InvalidateCurrentState();
      E(s"! Killed \(affiliation), humanity -\(cost)");
    } else {
      E("! Humanity freezed, kill costs no humanity");
    };
  }

  public func OnBuff() -> Void {
    this.RemoveAllEffects();
    E("! Buff applied, all effects stopped");
  }

  public func OnBuffEnded() -> Void {
    this.InvalidateCurrentState();
  }

  public func OnSleep() -> Void {
    this.RemoveAllEffects();
    this.currentHumanityDamage = 0;
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

    if !this.IsHumanityChangeBlocked() {
      this.currentHumanityDamage += cost;
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

    if !this.IsHumanityChangeBlocked() {
      this.currentHumanityDamage += cost;
      E(s"! Sandevistan activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Humanity freezed, sandevistan costs no humanity");
    };
  }


  // -- CHECKERS

  private func CanSpawnPolice() -> Bool {
    let zone: Int32 = this.player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let zoneEnum: gamePSMZones = IntEnum(zone);
    let isInInterior: Bool = IsEntityInInteriorArea(this.player);
    let result: Bool = zone < 3 && !isInInterior;
    E(s"CanSpawnPolice - zone: \(zoneEnum) \(zone), is in interior: \(isInInterior) -> can spawn: \(result)");
    return result;
  }

  private func IsHumanityChangeBlocked() -> Bool {
    return this.IsPossessed() || this.IsRipperdocBuffActive();
  }

  private func IsPsychosisBlocked() -> Bool {
    let psmBlackboard: ref<IBlackboard> = this.player.GetPlayerStateMachineBlackboard();
    let tier: Int32 = this.player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    E("? Check if psychosis available...");
    
    if psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) {
      E("- carrying");
      return true;
    };

    if psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInLoreAnimationScene)  {
      E("- animation scene");
      return true;
    };

    if GameInstance.GetPhoneManager(this.player.GetGame()).IsPhoneCallActive() {
      E("- active phone call");
      return true;
    };

    if psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Swimming) == EnumInt(gamePSMSwimming.Diving) {
      E("- diving");
      return true;
    };

    if this.player.IsMovingVertically() {
      E("- moving vertically");
      return true;
    };
    
    if this.IsPsychosisActive() {
      E("- already active");
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

    if this.IsHumanityChangeBlocked() {
      E("- has buff or is Johnny");
      return true;
    };

    if tier >= EnumInt(gamePSMHighLevel.SceneTier3) && tier <= EnumInt(gamePSMHighLevel.SceneTier5) {
      E("- has blocking scene active");
      return true;
    };

    return false;
  }

  private func IsRipperdocBuffActive() -> Bool {
    return Equals(StatusEffectSystem.ObjectHasStatusEffect(this.player, t"BaseStatusEffect.RipperDocMedBuff"), true);
  }

  public func IsGlitchesActive() -> Bool {
    return this.HasStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch");
  }

  public func IsPrePsychosisActive() -> Bool {
    return this.HasStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch");
  }

  public func IsPsychosisActive() -> Bool {
    return this.HasStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff");
  }

  private func IsPossessed() -> Bool {
    return this.player.IsPossessedE();
  }

  private func HasStatusEffect(id: TweakDBID) -> Bool {
    return Equals(StatusEffectSystem.ObjectHasStatusEffect(this.player, id), true);
  }


  // -- REQUESTS

  private final func OnTriggerDrawWeaponRequest(request: ref<TriggerDrawWeaponRequest>) -> Void {
    E("!!! DRAW WEAPON");
    let equipmentSystem: wref<EquipmentSystem> = this.player.GetEquipmentSystem();
    let drawItemRequest: ref<DrawItemRequest> = new DrawItemRequest();
    drawItemRequest.itemID = EquipmentSystem.GetData(this.player).GetItemInEquipSlot(gamedataEquipmentArea.WeaponWheel, 0);
    drawItemRequest.owner = this.player;
    equipmentSystem.QueueRequest(drawItemRequest);
  }

  private final func OnTriggerRandomShotRequest(request: ref<TriggerRandomShotRequest>) -> Void {
    E("!!! SHOT");
    let weaponObject: ref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
    let simTime = EngineTime.ToFloat(GameInstance.GetSimTime(this.player.GetGame()));
    AIWeapon.Fire(this.player, weaponObject, simTime, 1.0, weaponObject.GetWeaponRecord().PrimaryTriggerMode().Type());
  }

  private final func OnLaunchPoliceActivityRequest(request: ref<LaunchPoliceActivityRequest>) -> Void {
    E("!!! LAUNCH POLICE FLOW");
    this.player.GetPreventionSystem().SpawnPoliceForPsychosis(this.config);
  }

  private final func OnLaunchCycledSFXRequest(request: ref<LaunchCycledSFXRequest>) -> Void {
    let random: Int32 = RandRange(0, ArraySize(this.cyberpsychosisSFX));
    let bundle: ref<SFXBundle> = this.cyberpsychosisSFX[random];
    this.PlaySFX(bundle.name);
    this.cycledSFXDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledSFXRequest(), bundle.duration);
  }

  private final func OnLaunchCycledPsychosisCheckRequest(request: ref<LaunchCycledPsychosisCheckRequest>) -> Void {
    let random: Int32 = RandRange(0, 100);
    let threshold: Int32 = this.config.psychoChance;
    let triggered: Bool = random <= threshold;
    let forcedRun: Bool = Equals(this.currentHumanityPool, 0) && this.config.alwaysRunAtZero;
    E(s"? Run psychosis trigger check: roll \(random) against \(threshold), triggered: \(triggered), forced run: \(forcedRun)");
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    if triggered || forcedRun {
      this.RunPsychosis();
    };

    E(s"? Rescheduled next psycho check after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledPsychosisCheckRequest(), nextRun);
  }

  // -------------------------------------


  public func TempDamage() -> Void {
    this.currentHumanityDamage += 10;
    this.InvalidateCurrentState();
  }

  public func RefreshConfig() -> Void {
    this.config = new EdgerunningConfig();
    this.InvalidateCurrentState();
  }

  public func GetCyberwareCost(item: ref<Item_Record>) -> Int32 {
    let area: gamedataEquipmentArea = item.EquipArea().Type();
    let quality: gamedataQuality = item.Quality().Type();

    let baseCost: Float = 1.0;
    switch(area) {
      case gamedataEquipmentArea.FrontalCortexCW:
        baseCost = Cast<Float>(this.config.frontalCortexCost);
        break;
      case gamedataEquipmentArea.SystemReplacementCW:
        baseCost = Cast<Float>(this.config.systemReplacementCost);
        break;
      case gamedataEquipmentArea.EyesCW:
        baseCost = Cast<Float>(this.config.eyesCost);
        break;
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
        baseCost = Cast<Float>(this.config.musculoskeletalSystemCost);
        break;
      case gamedataEquipmentArea.NervousSystemCW :
        baseCost = Cast<Float>(this.config.nervousSystemCost);
        break;
      case gamedataEquipmentArea.CardiovascularSystemCW:
        baseCost = Cast<Float>(this.config.cardiovascularSystemCost);
        break;
      case gamedataEquipmentArea.ImmuneSystemCW:
        baseCost = Cast<Float>(this.config.immuneSystemCost);
        break;
      case gamedataEquipmentArea.IntegumentarySystemCW:
        baseCost = Cast<Float>(this.config.integumentarySystemCost);
        break;
      case gamedataEquipmentArea.HandsCW:
        baseCost = Cast<Float>(this.config.handsCost);
        break;
      case gamedataEquipmentArea.ArmsCW:
        baseCost = Cast<Float>(this.config.armsCost);
        break;
      case gamedataEquipmentArea.LegsCW:
        baseCost = Cast<Float>(this.config.legsCost);
        break;
    };

    let qualityMult: Float = 1.0;
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

    let result: Float = baseCost * qualityMult;
    E(s"GetCyberwareCost: \(area) costs \(baseCost), \(quality) mult \(qualityMult) = \(result)");

    return RoundF(result);
  }

  public func GetHumanityCurrent() -> Int32 {
    return this.currentHumanityPool;
  }

  public func GetHumanityTotal() -> Int32 {
    let basePool: Int32 = this.config.baseHumanityPool;
    return basePool;
  }

  public func GetHumanityColor() -> CName {
    let color: CName = n"MainColors.White";
    if this.currentHumanityPool < this.upperThreshold && this.currentHumanityPool > this.lowerThreshold {
      color = n"MainColors.ActiveRed"; 
    } else {
      if this.currentHumanityPool <= this.lowerThreshold {
        color = n"MainColors.Orange"; 
      } else {
        color = n"MainColors.MildGreen"; 
      };
    };

    return color;
  }

  public func PrintRemainingPoolDetails() -> Void {
    let berserk: Int32 = this.config.berserkUsageCost;
    let sandevistan: Int32 = this.config.sandevistanUsageCost;
    let upper = this.currentHumanityPool - this.upperThreshold;
    let lower = this.currentHumanityPool - this.lowerThreshold;
    let bl1 = upper / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierLegendary);
    let be1 = upper / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierEpic);
    let br1 = upper / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierRare);
    let bu1 = upper / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierUncommon);
    let bc1 = upper / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierCommon);
    let sl1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierLegendary);
    let se1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierEpic);
    let sr1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierRare);
    let su1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierUncommon);
    let sc1 = upper / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierCommon);
    let enm1 = upper / this.config.killCostOther;
    let cop1 = upper / this.config.killCostNCPD;
    let civ1 = upper / this.config.killCostCivilian;
    E("------------------------------------------------------------");
    let bl2 = lower / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierLegendary);
    let be2 = lower / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierEpic);
    let br2 = lower / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierRare);
    let bu2 = lower / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierUncommon);
    let bc2 = lower / Cast<Int32>(Cast<Float>(berserk) * this.config.qualityMultiplierCommon);
    let sl2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierLegendary);
    let se2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierEpic);
    let sr2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierRare);
    let su2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierUncommon);
    let sc2 = lower / Cast<Int32>(Cast<Float>(sandevistan) * this.config.qualityMultiplierCommon);
    let enm2 = upper / this.config.killCostOther;
    let cop2 = upper / this.config.killCostNCPD;
    let civ2 = upper / this.config.killCostCivilian;
    E(s"Glitches threshold: \(this.upperThreshold), cyberpsychosis threshold: \(this.lowerThreshold)");
    E(s"Berserk usages before glitches: Legendary \(bl1), Epic \(be1), Rare \(br1), Uncommon \(bu1), Common \(bc1)");
    E(s"Berserk usages before psycho: Legendary \(bl2), Epic \(be2), Rare \(br2), Uncommon \(bu2), Common \(bc2)");
    E(s"Sandevistan usages before glitches: Legendary \(sl1), Epic \(se1), Rare \(sr1), Uncommon \(su1), Common \(sc1)");
    E(s"Sandevistan usages before psycho: Legendary \(sl2), Epic \(se2), Rare \(sr2), Uncommon \(su2), Common \(sc2)");
    E(s"Available kills before glitches: \(enm1) enemies, \(cop1) cops, \(civ1) civs");
    E(s"Available kills before psycho: \(enm2) enemies, \(cop2) cops, \(civ2) civs");
    E("------------------------------------------------------------");
  }

  public func GetEnemyCost(affiliation: gamedataAffiliation) -> Int32 {
    let cost: Int32 = 0;

    switch affiliation {
      case gamedataAffiliation.Arasaka:
        cost = this.config.killCostArasaka;
        break;
      case gamedataAffiliation.KangTao:
        cost = this.config.killCostKangTao;
        break;
      case gamedataAffiliation.Maelstrom:
        cost = this.config.killCostMaelstrom;
        break;
      case gamedataAffiliation.Militech:
        cost = this.config.killCostMilitech;
        break;
      case gamedataAffiliation.NCPD:
        cost = this.config.killCostNCPD;
        break;
      case gamedataAffiliation.NetWatch:
        cost = this.config.killCostNetWatch;
        break;
      case gamedataAffiliation.Animals:
        cost = this.config.killCostAnimals;
        break;
      case gamedataAffiliation.Scavengers:
        cost = this.config.killCostScavengers;
        break;
      case gamedataAffiliation.SixthStreet:
        cost = this.config.killCostSixthStreet;
        break;
      case gamedataAffiliation.TygerClaws:
        cost = this.config.killCostTygerClaws;
        break;
      case gamedataAffiliation.Valentinos:
        cost = this.config.killCostValentinos;
        break;
      case gamedataAffiliation.VoodooBoys:
        cost = this.config.killCostVoodooBoys;
        break;
      case gamedataAffiliation.Wraiths:
        cost = this.config.killCostWraiths;
        break;
      case gamedataAffiliation.Civilian:
        cost = this.config.killCostCivilian;
        break;
      default:
        cost = this.config.killCostOther;
        break;
    };

    return cost;
  }

  private func GetCurrentCyberwareCost(showLog: Bool) -> Int32 {
    let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this.player).GetCyberwareFromSlots();
    let installedCyberwarePool: Int32 = 0;

    let name: CName;
    let area: gamedataEquipmentArea;
    let quality: gamedataQuality;
    let cost: Int32;

    for record in cyberware {
      name = record.DisplayName();
      area = record.EquipArea().Type();
      quality = record.Quality().Type();
      cost = this.GetCyberwareCost(record);
      if showLog {
        E(s"\(GetLocalizedTextByKey(name)) - \(area) - \(quality): costs -\(cost) humanity");
      }
      installedCyberwarePool += cost;
    };
  
    return installedCyberwarePool;
  }

  private func PlaySFX(name: CName) -> Void {
    GameObject.PlaySoundEvent(this.player, name);
    E(s"+ Play \(name) sfx");
  }

  private func PlayVFX(name: CName) -> Void {
    GameObjectEffectHelper.StartEffectEvent(this.player, name, true);
    E(s"+ Play \(name) vfx");
  }

  private func PlaySFXDelayed(name: CName, delay: Float) -> Void {
    let callback: ref<PlaySFXCallback> = new PlaySFXCallback();
    callback.sfxName = name;
    callback.player = this.player;
    this.delaySystem.DelayCallback(callback, delay);
  }

  private func PlayVFXDelayed(name: CName, delay: Float) -> Void {
    let callback: ref<PlayVFXCallback> = new PlayVFXCallback();
    callback.vfxName = name;
    callback.player = this.player;
    this.delaySystem.DelayCallback(callback, delay);
  }

  private func StopSFX(name: CName) -> Void {
    GameObject.StopSoundEvent(this.player, name);
    E(s"+ Stop \(name) sfx");
  }

  private func StopVFX(name: CName) -> Void {
    GameObjectEffectHelper.StopEffectEvent(this.player, name);
    E(s"+ Stop \(name) vfx");
  }

  private func ApplyStatusEffect(id: TweakDBID, delay: Float) {
    let callback: ref<ApplyStatusEffectCallback> = new ApplyStatusEffectCallback();
    callback.id = id;
    callback.player = this.player;
    this.delaySystem.DelayCallback(callback, delay);
  }

  private func RemoveStatusEffect(id: TweakDBID, delay: Float) {
    let callback: ref<RemoveStatusEffectCallback> = new RemoveStatusEffectCallback();
    callback.id = id;
    callback.player = this.player;
    this.delaySystem.DelayCallback(callback, delay);
  }
}
