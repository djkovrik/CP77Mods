public class EdgerunningConfig {

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Pool")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Pool-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "50")
  @runtimeProperty("ModSettings.max", "200")
  public let baseHumanityPool: Int32 = 100;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Bonus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Bonus-Desc")
  @runtimeProperty("ModSettings.step", "0.1")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "20.0")
  public let humanityBonusPerLevel: Float = 0.5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Psychosis-Threshold")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Psychosis-Threshold-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "10")
  @runtimeProperty("ModSettings.max", "200")
  public let psychosisThreshold: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Check-Period")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Check-Period-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  public let pcychoCheckPeriod: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Check-Probability")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Check-Probability-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  public let psychoChance: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-MaxDuration")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "1.0")
  @runtimeProperty("ModSettings.min", "20.0")
  @runtimeProperty("ModSettings.max", "120.0")
  public let psychoDuration: Float = 66.0;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Wanted-Level")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Wanted-Level-Desc")
  @runtimeProperty("ModSettings.displayValues.One", "1")
  @runtimeProperty("ModSettings.displayValues.Two", "2")
  @runtimeProperty("ModSettings.displayValues.Three", "3")
  @runtimeProperty("ModSettings.displayValues.Four", "4")
  @runtimeProperty("ModSettings.displayValues.Five", "5")
  @runtimeProperty("ModSettings.displayValues.MaxTac", "LocKey#20959")
  public let psychoHeatLevel: WannabeHeatLevel = WannabeHeatLevel.Three;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Teleport-On-End")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Teleport-On-End-Desc")
  public let teleportOnEnd: Bool = true;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Trigger-Zero")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Trigger-Zero-Desc")
  public let alwaysRunAtZero: Bool = false;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "LocKey#20638")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Light-Visuals")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Light-Visuals-Desc")
  public let lightVisuals: Bool = false;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Sleep-Choice")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Sleep-Choice-Desc")
  public let fullHumanityRestoreOnSleep: Bool = false;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Lover")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10")
  public let restoreOnLover: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Social")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10")
  public let restoreOnSocial: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Pet")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10")
  public let restoreOnPet: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Shower")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10")
  public let restoreOnShower: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Homeless")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10")
  public let restoreOnDonation: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Humanity-Restoration")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Humanity-Restoration-Apartment")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Humanity-Restoration-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10")
  public let restoreOnApartment: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-CharDev-New_Perks-Names-Intelligence-Intelligence_Central_Milestone_3")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let overclockUsageDamage: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-StatusEffects-UIData-DisplayName-Berserk")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let berserkUsageDamage: Int32 = 75;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-StatusEffects-UIData-DisplayName-Sandevistan")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let sandevistanUsageDamage: Int32 = 75;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Cyberware-NervousSystem-DisplayName-Kerenzikov")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let kerenzikovUsageDamage: Int32 = 25;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_Launcher")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let launcherUsageDamage: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_MantisBlades")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let mantisBladesUsageDamage: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_NanoWires")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let monowireUsageDamage: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Damage")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Cyberware-IntegumentarySystem-DisplayName-OpticalCamo")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Damage-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "5")
  @runtimeProperty("ModSettings.max", "95")
  public let opticalCamoUsageDamage: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-CharDev-New_Perks-Names-Intelligence-Intelligence_Central_Milestone_3")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  public let overclockUsageCost: Int32 = 8;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Cyberware-DisplayName-BloodPump")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  public let bloodPumpUsageCost: Int32 = 7;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-StatusEffects-UIData-DisplayName-Berserk")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  public let berserkUsageCost: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-StatusEffects-UIData-DisplayName-Sandevistan")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  public let sandevistanUsageCost: Int32 = 7;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Cyberware-NervousSystem-DisplayName-Kerenzikov")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "20")
  public let kerenzikovUsageCost: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_Launcher")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "20")
  public let launcherUsageCost: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_MantisBlades")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "20")
  public let mantisBladesUsageCost: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Items-Item Type-Cyb_NanoWires")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "20")
  public let monowireUsageCost: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Implants-Usage-Cost")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Gameplay-Cyberware-IntegumentarySystem-DisplayName-OpticalCamo")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Implants-Usage-Cost-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "20")
  public let opticalCamoUsageCost: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier1")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierCommon: Float = 2.0;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier1plus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierCommonPlus: Float = 1.9;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier2")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierUncommon: Float = 1.8;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier2plus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierUncommonPlus: Float = 1.7;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier3")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierRare: Float = 1.6;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier3plus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierRarePlus: Float = 1.5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier4")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierEpic: Float = 1.4;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier4plus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierEpicPlus: Float = 1.3;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier5")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierLegendary: Float = 1.2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier5plus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierLegendaryPlus: Float = 1.1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Quality")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Stats-Tiers-Tier5plusplus")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Quality-Desc")
  @runtimeProperty("ModSettings.step", "0.2")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0") 
  public let qualityMultiplierLegendaryPlusPlus: Float = 1.1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#15716")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostArasaka: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20947")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostKangTao: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20937")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostMilitech: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#1184")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostNCPD: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20979")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostNetWatch: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20602")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostAnimals: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20953")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostMaelstrom: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#21009")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostScavengers: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20936")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostSixthStreet: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#21023")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostTygerClaws: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#19900")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostValentinos: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#21032")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostVoodooBoys: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#20994")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostWraiths: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#44337")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostCivilian: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#86254")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostBarghest: Int32 = 2;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#91191")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostNUSA: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "LocKey#42782")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Other-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50") 
  public let killCostOther: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Murders")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-Edg-Murders-Cruelty")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Murders-Cruelty-Desc")
  public let cruelty: Bool = false;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Neuro-Price")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Common")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "200")
  @runtimeProperty("ModSettings.min", "200")
  @runtimeProperty("ModSettings.max", "20000")
  public let neuroblockersPriceCommon: Int32 = 3800;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Neuro-Price")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "200")
  @runtimeProperty("ModSettings.min", "200")
  @runtimeProperty("ModSettings.max", "20000")
  public let neuroblockersPriceUncommon: Int32 = 4600;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Neuro-Price")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "200")
  @runtimeProperty("ModSettings.min", "200")
  @runtimeProperty("ModSettings.max", "20000")
  public let neuroblockersPriceRare: Int32 = 5400;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Neuro-Recipe-Price")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Common")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "200")
  @runtimeProperty("ModSettings.min", "200")
  @runtimeProperty("ModSettings.max", "20000")
  public let neuroblockersRecipePriceCommon: Int32 = 6000;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Neuro-Recipe-Price")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "200")
  @runtimeProperty("ModSettings.min", "200")
  @runtimeProperty("ModSettings.max", "20000")
  public let neuroblockersRecipePriceUncommon: Int32 = 9000;

  @runtimeProperty("ModSettings.mod", "Edgerunner")
  @runtimeProperty("ModSettings.category", "Mod-Edg-Neuro-Recipe-Price")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Gameplay-RPG-Items-Quality-Rare")
  @runtimeProperty("ModSettings.description", "Mod-Edg-Restart")
  @runtimeProperty("ModSettings.step", "200")
  @runtimeProperty("ModSettings.min", "200")
  @runtimeProperty("ModSettings.max", "20000")
  public let neuroblockersRecipePriceRare: Int32 = 12000;
}
