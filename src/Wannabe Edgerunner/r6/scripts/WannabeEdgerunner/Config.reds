public class EdgerunningConfig {

  public static func Get() -> ref<EdgerunningConfig> {
    let self: ref<EdgerunningConfig> = new EdgerunningConfig();
    return self;
  }

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Pool")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Pool-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "50")
  @runtimeProperty("ModSettings.max", "500")
  let baseHumanityPool: Int32 = 180;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Glitches-Threshold")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Glitches-Threshold-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "500")
  let glitchesThreshold: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Psychosis-Threshold")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Psychosis-Threshold-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "500")
  let psychosisThreshold: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Gameplay-Devices-Interactions-MadnessHack")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Check-Period")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Check-Period-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let pcychoCheckPeriod: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Gameplay-Devices-Interactions-MadnessHack")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Check-Probability")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Check-Probability-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  let psychoChance: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Gameplay-Devices-Interactions-MadnessHack")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Wanted-Level")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Wanted-Level-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "4")
  let psychoHeatLevel: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-FrontalCortexCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let frontalCortexCost: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-SystemReplacementCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let systemReplacementCost: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-EyesCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let eyesCost: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-MusculoskeletalSystemCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let musculoskeletalSystemCost: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-NervousSystemCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let nervousSystemCost: Int32 = 4;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-CardiovascularSystemCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let cardiovascularSystemCost: Int32 = 4;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-ImmuneSystemCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let immuneSystemCost: Int32 = 4;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-IntegumentarySystemCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let integumentarySystemCost: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-HandsCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let handsCost: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-ArmsCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let armsCost: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-EquipmentAreas-LegsCW")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let legsCost: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-StatusEffects-UIData-DisplayName-Berserk")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let berserkUsageCost: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-StatusEffects-UIData-DisplayName-Sandevistan")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let sandevistanUsageCost: Int32 = 7;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Common")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierCommon: Float = 2.0;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierUncommon: Float = 1.75;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierRare: Float = 1.5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Epic")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierEpic: Float = 1.25;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "1.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierLegendary: Float = 1.0;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#36886")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let enemiesKillCost: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#37213")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let copsKillCost: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#44337")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let civiliansKillCost: Int32 = 20;

  public func GetHeatStage() -> EPreventionHeatStage {
    switch this.psychoHeatLevel {
      case 1: return EPreventionHeatStage.Heat_1;
      case 2: return EPreventionHeatStage.Heat_2;
      case 3: return EPreventionHeatStage.Heat_3;
    };

    return EPreventionHeatStage.Heat_4;
  }
}

// Replace false with true to show full debug logs in CET console
public static func ShowDebugLogsEdgerunner() -> Bool = true
