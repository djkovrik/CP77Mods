public class EdgerunningConfig {

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
  @runtimeProperty("ModSettings.category", "Gameplay-Devices-Interactions-MadnessHack")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Trigger-Zero")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Trigger-Zero-Desc")
  let alwaysRunAtZero: Bool = false;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Gameplay-Devices-Interactions-MadnessHack")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Teleport-On-End")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Teleport-On-End-Desc")
  let teleportOnEnd: Bool = false;

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
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Cyberware-NervousSystem-DisplayName-Kerenzikov")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  let kerenzikovUsageCost: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Common")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierCommon: Float = 2.0;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierUncommon: Float = 1.8;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierRare: Float = 1.6;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Epic")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierEpic: Float = 1.4;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  let qualityMultiplierLegendary: Float = 1.2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#15716")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostArasaka: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20947")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostKangTao: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20937")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostMilitech: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#1184")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostNCPD: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20979")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostNetWatch: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20602")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostAnimals: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20953")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostMaelstrom: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#21009")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostScavengers: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20936")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostSixthStreet: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#21023")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostTygerClaws: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#19900")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostValentinos: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#21032")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostVoodooBoys: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#20994")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostWraiths: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#44337")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostCivilian: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.displayName", "LocKey#42782")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Other-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  let killCostOther: Int32 = 1;
}

// Replace false with true to show full debug logs in CET console
public static func ShowDebugLogsEdgerunner() -> Bool = true
