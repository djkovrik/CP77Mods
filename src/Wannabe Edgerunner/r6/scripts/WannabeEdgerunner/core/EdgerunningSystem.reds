module Edgerunning.System
import Edgerunning.Common.EdgerunningConfig
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
    let system: ref<EdgerunningSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"EdgerunningSystem") as EdgerunningSystem;
    return system;
  }

  public func TempDamage() -> Void {
    this.currentHumanityDamage += 10;
    this.InvalidateCurrentState();
  }

  public func RefreshConfig() -> Void {
    this.config = new EdgerunningConfig();
  }

  public func IsPsychosisActive() -> Bool {
    return this.HasStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff");
  }

  public func GetCyberwareCost(item: ref<Item_Record>) -> Int32 {
    let area: gamedataEquipmentArea = item.EquipArea().Type();
    let quality: gamedataQuality = item.Quality().Type();

    let baseCost: Int32;
    switch(area) {
      case gamedataEquipmentArea.FrontalCortexCW:
        baseCost = this.config.frontalCortexCost;
        break;
      case gamedataEquipmentArea.SystemReplacementCW:
        baseCost = this.config.systemReplacementCost;
        break;
      case gamedataEquipmentArea.EyesCW:
        baseCost = this.config.eyesCost;
        break;
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
        baseCost = this.config.musculoskeletalSystemCost;
        break;
      case gamedataEquipmentArea.NervousSystemCW :
        baseCost = this.config.nervousSystemCost;
        break;
      case gamedataEquipmentArea.CardiovascularSystemCW:
        baseCost = this.config.cardiovascularSystemCost;
        break;
      case gamedataEquipmentArea.ImmuneSystemCW:
        baseCost = this.config.immuneSystemCost;
        break;
      case gamedataEquipmentArea.IntegumentarySystemCW :
        baseCost = this.config.integumentarySystemCost;
        break;
      case gamedataEquipmentArea.HandsCW:
        baseCost = this.config.handsCost;
        break;
      case gamedataEquipmentArea.ArmsCW:
        baseCost = this.config.armsCost;
        break;
      case gamedataEquipmentArea.LegsCW:
        baseCost = this.config.legsCost;
        break;
    };

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

    return baseCost * Cast<Int32>(qualityMult);
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
    let enm1 = upper / this.config.enemiesKillCost;
    let cop1 = upper / this.config.copsKillCost;
    let civ1 = upper / this.config.civiliansKillCost;
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
    let enm2 = lower / this.config.enemiesKillCost;
    let cop2 = lower / this.config.copsKillCost;
    let civ2 = lower / this.config.civiliansKillCost;
    E(s"Glitches threshold: \(this.upperThreshold), cyberpsychosis threshold: \(this.lowerThreshold)");
    E(s"Berserk usages before glitches: Legendary \(bl1), Epic \(be1), Rare \(br1), Uncommon \(bu1), Common \(bc1)");
    E(s"Berserk usages before psycho: Legendary \(bl2), Epic \(be2), Rare \(br2), Uncommon \(bu2), Common \(bc2)");
    E(s"Sandevistan usages before glitches: Legendary \(sl1), Epic \(se1), Rare \(sr1), Uncommon \(su1), Common \(sc1)");
    E(s"Sandevistan usages before psycho: Legendary \(sl2), Epic \(se2), Rare \(sr2), Uncommon \(su2), Common \(sc2)");
    E(s"Available kills before glitches: \(enm1) enemies, \(cop1) cops, \(civ1) civs");
    E(s"Available kills before psycho: \(enm2) enemies, \(cop2) cops, \(civ2) civs");
    E("------------------------------------------------------------");
  }

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
    let cost: Int32 = 0;
    
    if Equals(affiliation, gamedataAffiliation.NCPD) {
      cost = this.config.copsKillCost;
      E(s"! Policeman killed, humanity -\(cost)");
    } else {
      if Equals(affiliation, gamedataAffiliation.Civilian) {
        cost = this.config.civiliansKillCost;
        E(s"! Civilian killed, humanity -\(cost)");
      } else {
        cost = this.config.enemiesKillCost;
        E(s"! Enemy killed, humanity -\(cost)");
      };
    };

    if !this.RipperdocBuffIsActive() {
      this.currentHumanityDamage += cost;
      this.InvalidateCurrentState();
    } else {
      E("! Ripperdoc buff is active, kill costs no humanity");
    };
  }

  public func OnBuff() -> Void {
    this.StopLowHumanityGlitch();
    this.StopPrePsychosislitch();
    this.StopPsychosisChecks();
    this.StopPsychosis();
    E("! Buff applied, all effects stopped");
  }

  public func OnBuffEnded() -> Void {
    this.InvalidateCurrentState();
  }

  public func OnSleep() -> Void {
    this.StopLowHumanityGlitch();
    this.StopPrePsychosislitch();
    this.StopPsychosisChecks();
    this.StopPsychosis();
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

    if !this.RipperdocBuffIsActive() {
      this.currentHumanityDamage += cost;
      E(s"! Berserk activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Ripperdoc buff is active, berserk costs no humanity");
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

    if !this.RipperdocBuffIsActive() {
      this.currentHumanityDamage += cost;
      E(s"! Sandevistan activated: \(quality) - costs \(cost) humanity");
      this.InvalidateCurrentState();
    } else {
      E("! Ripperdoc buff is active, sandevistan costs no humanity");
    };
  }

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
      this.RunLowHumanityGlitch();
    } else {
      if this.currentHumanityPool < this.lowerThreshold {
        this.RunPrePsychosisGlitch();
        this.RunPsychosisChecks();
      } else {
        if Equals(this.currentHumanityPool, 0) {
          this.RunPsychosis();
        };
      };
    };

    evt.current = this.GetHumanityCurrent();
    evt.total = this.GetHumanityTotal();
    evt.color = this.GetHumanityColor();
    GameInstance.GetUISystem(this.player.GetGame()).QueueEvent(evt);
    this.PrintRemainingPoolDetails();
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

  private func RipperdocBuffIsActive() -> Bool {
    return Equals(StatusEffectSystem.ObjectHasStatusEffect(this.player, t"BaseStatusEffect.RipperDocMedBuff"), true);
  }

  private func HasStatusEffect(id: TweakDBID) -> Bool {
    return Equals(StatusEffectSystem.ObjectHasStatusEffect(this.player, id), true);
  }

  public func RunLowHumanityGlitch() -> Void {
    if this.HasStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch") || this.RipperdocBuffIsActive() {
      return ;
    };

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

  public func StopLowHumanityGlitch() -> Void {
    E("!!! STOP STAGE 1");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
    this.StopVFX(n"hacking_glitch_low");
  };

  public func RunPrePsychosisGlitch() -> Void {
    if this.HasStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch") || this.RipperdocBuffIsActive() {
      return ;
    };

    E("!!! RUN STAGE 2 - MORE GLITCHES");
    this.StopVFX(n"hacking_glitch_low");
    this.StopVFX(n"reboot_glitch");
    this.PlaySFXDelayed(n"ono_v_pain_short", 0.5);
    this.PlayVFXDelayed(n"reboot_glitch", 0.5);
    this.PlayVFXDelayed(n"hacking_glitch_low", 2.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 3.0);
    this.ApplyStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch", 4.0);
  }

  public func StopPrePsychosislitch() -> Void {
    E("!!! STOP STAGE 2 - MORE GLITCHES");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActivePrePsychosisGlitch", 0.1);
    this.RemoveStatusEffect(t"BaseStatusEffect.ActiveLowHumanityGlitch", 0.1);
    this.StopVFX(n"hacking_glitch_low");
  };

  public func RunPsychosisChecks() -> Void {
    E("!!! RUN PRE STAGE 2 - CYBERPSYCHOSIS CHECKS");
    this.StopPsychosisChecks();
    //let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    let nextRun: Float = 5.0;
    E(s"? Scheduled next psycho check fromRunPsychosisChecks after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledPsychosisCheckRequest(), nextRun);
  }

  public func StopPsychosisChecks() -> Void {
    E("!!! STOP PRE STAGE 2");
    this.delaySystem.CancelCallback(this.psychosisCheckDelayId);
  }

  private func CanRunPsychosis() -> Bool {
    E("? Check if psychosis available...");
    if this.HasStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff") {
      E("- already active");
      return false;
    };

    if VehicleComponent.IsMountedToVehicle(this.player.GetGame(), this.player) {
      E("- mounted to vehicle");
      return false;
    };

    if this.player.GetHudManager().IsBraindanceActive() {
      E("- braindance is active");
      return false;
    };

    if this.RipperdocBuffIsActive() {
      E("- has active buff");
      return false;
    };

    let tier: Int32 = this.player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    if tier >= EnumInt(gamePSMHighLevel.SceneTier3) && tier <= EnumInt(gamePSMHighLevel.SceneTier5) {
      E("- has blocking scene active");
      return false;
    };

    return true;
  }

  private func RunPsychosis() -> Void {
    E("!!! RUN STAGE 2 - CYBERPSYCHOSIS");

    if !this.CanRunPsychosis() {
      E("? Skipped");
      let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
      this.StopPsychosisChecks();
      E(s"? Scheduled next psycho check from RunPsychosis - has active psycho - \(nextRun) seconds");
      this.psychosisCheckDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledPsychosisCheckRequest(), nextRun);
      return ;
    };

    let zone: Int32 = this.player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones);
    let zoneEnum: gamePSMZones = IntEnum(zone);
    let isInInterior: Bool = IsEntityInInteriorArea(this.player);
    E(s"Zone: \(zoneEnum) \(zone), is in interior: \(isInInterior)");
    
    this.ApplyStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff", 0.1);
    // this.PlayVFXDelayed(n"ono_v_pain_short", 0.1);
    // this.PlaySFXDelayed(n"ono_v_fear_panic_scream", 0.7);
    this.drawWeaponDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new TriggerDrawWeaponRequest(), 4.5);
    this.randomShotsDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new TriggerRandomShotRequest(), 6.5);

    if zone < 3 && !isInInterior {
      E("!!! Player not in danger zone or interior - call police");
      this.policeActivityDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchPoliceActivityRequest(), 6.0);
    } else {
      E("!!! Player is in interior or danger zone - police call aborted");
    };

    this.cycledSFXDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledSFXRequest(), 7.0);
  }

  private func StopPsychosis() -> Void {
    E("!!! STOP STAGE 2");
    this.RemoveStatusEffect(t"BaseStatusEffect.ActivePsychosisBuff", 0.1);
    this.delaySystem.CancelCallback(this.drawWeaponDelayId);
    this.delaySystem.CancelCallback(this.randomShotsDelayId);
    this.delaySystem.CancelCallback(this.policeActivityDelayId);
    this.delaySystem.CancelCallback(this.cycledSFXDelayId);
  };

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
    E(s"? Run psychosis trigger check: roll \(random) against \(threshold), triggered: \(triggered)");
    let nextRun: Float = Cast<Float>(this.config.pcychoCheckPeriod) * 60.0;
    if triggered {
      this.RunPsychosis();
    };

    E(s"? Rescheduled next psycho check after \(nextRun) seconds");
    this.psychosisCheckDelayId = this.delaySystem.DelayScriptableSystemRequest(this.GetClassName(), new LaunchCycledPsychosisCheckRequest(), nextRun);
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

@addMethod(EquipmentSystemPlayerData)
public final const func GetCyberwareFromSlots() -> array<ref<Item_Record>> {
  let result: array<ref<Item_Record>>;
  let record: ref<Item_Record>;
  let equipSlots: array<SEquipSlot>;
  let i: Int32;

  for slot in [
      gamedataEquipmentArea.FrontalCortexCW,
      gamedataEquipmentArea.SystemReplacementCW,
      gamedataEquipmentArea.EyesCW,
      gamedataEquipmentArea.MusculoskeletalSystemCW,
      gamedataEquipmentArea.NervousSystemCW,
      gamedataEquipmentArea.CardiovascularSystemCW,
      gamedataEquipmentArea.ImmuneSystemCW,
      gamedataEquipmentArea.IntegumentarySystemCW,
      gamedataEquipmentArea.HandsCW,
      gamedataEquipmentArea.ArmsCW,
      gamedataEquipmentArea.LegsCW
    ] {
      equipSlots = this.m_equipment.equipAreas[this.GetEquipAreaIndex(slot)].equipSlots;
      i = 0;
      while i < ArraySize(equipSlots) {
        if ItemID.IsValid(equipSlots[i].itemID) {
          record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(equipSlots[i].itemID));
          ArrayPush(result, record);
        };
        i += 1;
      };
    };

  E(s"Detected cyberware: \(ArraySize(result))");
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  EdgerunningSystem.GetInstance(this.GetGame()).InvalidateCurrentState();
}

public class TriggerDrawWeaponRequest extends ScriptableSystemRequest {}
public class TriggerRandomShotRequest extends ScriptableSystemRequest {}
public class LaunchPoliceActivityRequest extends ScriptableSystemRequest {}
public class LaunchCycledSFXRequest extends ScriptableSystemRequest {}
public class LaunchCycledPsychosisCheckRequest extends ScriptableSystemRequest {}

public class SFXBundle {
  public let name: CName;
  public let duration: Float;

  public static func Create(name: CName, duration: Float) -> ref<SFXBundle> {
    let bundle: ref<SFXBundle> = new SFXBundle();
    bundle.name = name;
    bundle.duration = duration;
    return bundle;
  }
}

public class PlaySFXCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
	public let sfxName: CName;

	public func Call() -> Void {
    GameObject.PlaySoundEvent(this.player, this.sfxName);
    E(s"Run \(this.sfxName) sfx");
	}
}

public class PlayVFXCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
	public let vfxName: CName;

	public func Call() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this.player, this.vfxName, false);
    E(s"Run \(this.vfxName) vfx");
	}
}

public class ApplyStatusEffectCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

	public func Call() -> Void {
    GameInstance.GetStatusEffectSystem(this.player.GetGame()).ApplyStatusEffect(this.player.GetEntityID(), this.id, this.player.GetRecordID(), this.player.GetEntityID());
    E(s"Apply \(TDBID.ToStringDEBUG(this.id)) effect to player");
	}
}

public class RemoveStatusEffectCallback extends DelayCallback {
	public let player: wref<PlayerPuppet>;
  public let id: TweakDBID;

	public func Call() -> Void {
    GameInstance.GetStatusEffectSystem(this.player.GetGame()).RemoveStatusEffect(this.player.GetEntityID(), this.id);
    E(s"Remove \(TDBID.ToStringDEBUG(this.id)) effect from player");
  }
}

@addMethod(PlayerPuppet)
public func GetNearbyEntities() -> array<ref<Entity>> {
  let hudManager: ref<HUDManager> = this.GetHudManager();
  let actors: array<ref<HUDActor>> = hudManager.GetAllActors();
  let entities: array<ref<Entity>>;
  E(s"Actors: \(ArraySize(actors))");
  let entity: ref<Entity>;
  for actor in actors {
    if Equals(actor.type, HUDActorType.PUPPET) && Equals(actor.status, HUDActorStatus.REGISTERED) {
      entity = GameInstance.FindEntityByID(this.GetGame(), actor.entityID);
      //E(s"Actor: type \(actor.type), \(actor.status), position: \(entity.GetWorldPosition())");
      ArrayPush(entities, entity);
    } else {
      //E(s"Actor: type \(actor.type), \(actor.status)");
    };
  };
  return entities;
}
