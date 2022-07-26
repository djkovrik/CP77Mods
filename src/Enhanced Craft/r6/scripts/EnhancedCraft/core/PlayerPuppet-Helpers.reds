module EnhancedCraft.Core
import EnhancedCraft.Common.DamageTypeStats
import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Common.L

// -- Helper function to scale custom variant data to player level and original recipe quality
//    Used for crafted item and for crafting panel item preview so stats will match
@addMethod(PlayerPuppet)
public func ScaleCraftedItemData(itemData: ref<gameItemData>, quality: CName) -> Void {
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
  let qualityMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.Quality, gameStatModifierType.Additive, RPGManager.ItemQualityNameToValue(quality));
  statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.Quality);
  statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), qualityMod);
  RPGManager.ForceItemQuality(this, itemData, quality);
}

// -- Creates DamageTypeStats helper class based on original damage type
@addMethod(PlayerPuppet)
private func GetDamageTypeStats(ss: ref<StatsSystem>, object: StatsObjectID, currentType: gamedataDamageType, newType: gamedataDamageType) -> ref<DamageTypeStats> {
  let result: ref<DamageTypeStats> = new DamageTypeStats();
  result.type = newType;

  switch currentType {
    case gamedataDamageType.Chemical:
      result.damage = ss.GetStatValue(object, gamedataStatType.ChemicalDamage);
      result.minDamage = ss.GetStatValue(object, gamedataStatType.ChemicalDamageMin);
      result.maxDamage = ss.GetStatValue(object, gamedataStatType.ChemicalDamageMax);
      result.percentDamage = ss.GetStatValue(object, gamedataStatType.ChemicalDamagePercent);
      break;
    case gamedataDamageType.Electric:
      result.damage = ss.GetStatValue(object, gamedataStatType.ElectricDamage);
      result.minDamage = ss.GetStatValue(object, gamedataStatType.ElectricDamageMin);
      result.maxDamage = ss.GetStatValue(object, gamedataStatType.ElectricDamageMax);
      result.percentDamage = ss.GetStatValue(object, gamedataStatType.ElectricDamagePercent);
      break;
    case gamedataDamageType.Physical:
      result.damage = ss.GetStatValue(object, gamedataStatType.PhysicalDamage);
      result.minDamage = ss.GetStatValue(object, gamedataStatType.PhysicalDamageMin);
      result.maxDamage = ss.GetStatValue(object, gamedataStatType.PhysicalDamageMax);
      result.percentDamage = ss.GetStatValue(object, gamedataStatType.PhysicalDamagePercent);
      break;
    case gamedataDamageType.Thermal:
      result.damage = ss.GetStatValue(object, gamedataStatType.ThermalDamage);
      result.minDamage = ss.GetStatValue(object, gamedataStatType.ThermalDamageMin);
      result.maxDamage = ss.GetStatValue(object, gamedataStatType.ThermalDamageMax);
      result.percentDamage = ss.GetStatValue(object, gamedataStatType.ThermalDamagePercent);
      break;
  };

  // Common
  result.critChance = ss.GetStatValue(object, gamedataStatType.CritChance);
  result.critChanceTimeCritDamage = ss.GetStatValue(object, gamedataStatType.CritChanceTimeCritDamage);
  result.critDamage = ss.GetStatValue(object, gamedataStatType.CritDamage);
  result.critDPSBonus = ss.GetStatValue(object, gamedataStatType.CritDPSBonus);
  result.headshotMultiplier = ss.GetStatValue(object, gamedataStatType.HeadshotDamageMultiplier);
  result.bonusRicochetDamage = ss.GetStatValue(object, gamedataStatType.BonusRicochetDamage);
  result.staminaCostReduction = ss.GetStatValue(object, gamedataStatType.StaminaCostReduction);
  result.chargeMultiplier = ss.GetStatValue(object, gamedataStatType.ChargeMultiplier);
  result.chargeTime = ss.GetStatValue(object, gamedataStatType.ChargeTime);
  return result;
}

// -- Builds new damage modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamage(value: Float, damageType: gamedataDamageType) -> ref<gameStatModifierData> {
  let modifier: ref<gameStatModifierData>;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier = RPGManager.CreateStatModifier(gamedataStatType.ChemicalDamage, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Electric:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ElectricDamage, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Physical:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.PhysicalDamage, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Thermal:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ThermalDamage, gameStatModifierType.Additive, value);
      break;
  };

  return modifier;
}

// -- Builds new min damage modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamageMin(value: Float, damageType: gamedataDamageType) -> ref<gameStatModifierData> {
  let modifier: ref<gameStatModifierData>;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier = RPGManager.CreateStatModifier(gamedataStatType.ChemicalDamageMin, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Electric:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ElectricDamageMin, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Physical:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.PhysicalDamageMin, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Thermal:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ThermalDamageMin, gameStatModifierType.Additive, value);
      break;
  };

  return modifier;
}

// -- Builds new max damage modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamageMax(value: Float, damageType: gamedataDamageType) -> ref<gameStatModifierData> {
  let modifier: ref<gameStatModifierData>;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier = RPGManager.CreateStatModifier(gamedataStatType.ChemicalDamageMax, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Electric:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ElectricDamageMax, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Physical:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.PhysicalDamageMax, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Thermal:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ThermalDamageMax, gameStatModifierType.Additive, value);
      break;
  };

  return modifier;
}

// -- Builds new damage percent modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamagePercent(value: Float, damageType: gamedataDamageType) -> ref<gameStatModifierData> {
  let modifier: ref<gameStatModifierData>;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier = RPGManager.CreateStatModifier(gamedataStatType.ChemicalDamagePercent, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Electric:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ElectricDamagePercent, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Physical:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.PhysicalDamagePercent, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Thermal:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.ThermalDamagePercent, gameStatModifierType.Additive, value);
      break;
  };

  return modifier;
}

// -- Builds new damage percent modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamageDeals(value: Float, damageType: gamedataDamageType) -> ref<gameStatModifierData> {
  let modifier: ref<gameStatModifierData>;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier = RPGManager.CreateStatModifier(gamedataStatType.DealsChemicalDamage, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Electric:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.DealsElectricDamage, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Physical:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.DealsPhysicalDamage, gameStatModifierType.Additive, value);
      break;
    case gamedataDamageType.Thermal:
    modifier = RPGManager.CreateStatModifier(gamedataStatType.DealsThermalDamage, gameStatModifierType.Additive, value);
      break;
  };

  return modifier;
}

// -- Clears current elemental damage modifiers from StatsObject
@addMethod(PlayerPuppet)
private func RemoveCurrentDamageModifiers(ss: ref<StatsSystem>, object: StatsObjectID) -> Void {
  // Chemical
  ss.RemoveAllModifiers(object, gamedataStatType.DealsChemicalDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamageMin, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamageMax, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamagePercent, true);
  // Electric
  ss.RemoveAllModifiers(object, gamedataStatType.DealsElectricDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamageMin, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamageMax, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamagePercent, true);
  // Physical
  ss.RemoveAllModifiers(object, gamedataStatType.DealsPhysicalDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamageMin, true);
  ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamageMax, true);
  ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamagePercent, true);
  // Thermal
  ss.RemoveAllModifiers(object, gamedataStatType.DealsThermalDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamageMin, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamageMax, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamagePercent, true);
  // Crit
  ss.RemoveAllModifiers(object, gamedataStatType.CritChance, true);
  ss.RemoveAllModifiers(object, gamedataStatType.CritChanceTimeCritDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.CritDPSBonus, true);
  ss.RemoveAllModifiers(object, gamedataStatType.CritDamage, true);
  // Other
  ss.RemoveAllModifiers(object, gamedataStatType.HeadshotDamageMultiplier, true);
  ss.RemoveAllModifiers(object, gamedataStatType.BonusRicochetDamage, true);
  ss.RemoveAllModifiers(object, gamedataStatType.StaminaCostReduction, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ChargeMultiplier, true);
  ss.RemoveAllModifiers(object, gamedataStatType.ChargeTime, true);
}

// -- Assigns new elemental damage modifiers to specified StatsObject
@addMethod(PlayerPuppet)
private func AssignNewDamageModifiers(ss: ref<StatsSystem>, object: StatsObjectID, stats: ref<DamageTypeStats>, damageType: gamedataDamageType) -> Void {
  let modifiderDamage: ref<gameStatModifierData> = this.BuildNewModifierDamage(stats.damage, damageType);
  let modifiderDamageMin: ref<gameStatModifierData> = this.BuildNewModifierDamageMin(stats.minDamage, damageType);
  let modifiderDamageMax: ref<gameStatModifierData> = this.BuildNewModifierDamageMax(stats.maxDamage, damageType);
  let modifiderDamagePercent: ref<gameStatModifierData> = this.BuildNewModifierDamagePercent(stats.percentDamage, damageType);
  let modifiderDamageDeals: ref<gameStatModifierData> = this.BuildNewModifierDamageDeals(1.0, damageType);

  ss.AddSavedModifier(object, modifiderDamage);
  ss.AddSavedModifier(object, modifiderDamageMin);
  ss.AddSavedModifier(object, modifiderDamageMax);
  ss.AddSavedModifier(object, modifiderDamagePercent);
  ss.AddSavedModifier(object, modifiderDamageDeals);

  // Common
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.CritChance, gameStatModifierType.Additive, stats.critChance));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.CritChanceTimeCritDamage, gameStatModifierType.Additive, stats.critChanceTimeCritDamage));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.CritDamage, gameStatModifierType.Additive, stats.critDamage));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.CritDPSBonus, gameStatModifierType.Additive, stats.critDPSBonus));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.HeadshotDamageMultiplier, gameStatModifierType.Additive, stats.headshotMultiplier));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.BonusRicochetDamage, gameStatModifierType.Additive, stats.bonusRicochetDamage));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.StaminaCostReduction, gameStatModifierType.Additive, stats.staminaCostReduction));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.ChargeMultiplier, gameStatModifierType.Additive, stats.chargeMultiplier));
  ss.AddSavedModifier(object, RPGManager.CreateStatModifier(gamedataStatType.ChargeTime, gameStatModifierType.Additive, stats.chargeTime));
}

@addMethod(PlayerPuppet)
public func GetCraftedWeaponDamageStats(itemData: ref<gameItemData>, damage: gamedataStatType) -> ref<DamageTypeStats> {
  let currentDamageType: gamedataDamageType = RPGManager.GetDominatingDamageType(this.GetGame(), itemData);
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
  let newDamageType: gamedataDamageType = statsSystem.GetDamageType(damage);
  let statsObject: StatsObjectID = itemData.GetStatsObjectID();
  let stats: ref<DamageTypeStats> = this.GetDamageTypeStats(statsSystem, statsObject, currentDamageType, newDamageType);
  return stats;
}

// -- Switch weapon damage type to new one
@addMethod(PlayerPuppet)
public func SwitchDamageTypeToChosen(itemData: ref<gameItemData>, damage: gamedataStatType) -> Void {
  let currentDamageType: gamedataDamageType = RPGManager.GetDominatingDamageType(this.GetGame(), itemData);

  if Equals(currentDamageType, gamedataDamageType.Count) || Equals(currentDamageType, gamedataDamageType.Invalid) {
    return ;
  };

  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
  let newDamageType: gamedataDamageType = statsSystem.GetDamageType(damage);
  let statsObject: StatsObjectID = itemData.GetStatsObjectID();
  let originalStats: ref<DamageTypeStats> = this.GetDamageTypeStats(statsSystem, statsObject, currentDamageType, newDamageType);

  this.RemoveCurrentDamageModifiers(statsSystem, statsObject);
  this.AssignNewDamageModifiers(statsSystem, statsObject, originalStats, newDamageType);
  L(s"Original damage type was \(currentDamageType) with \(originalStats.damage) (\(originalStats.minDamage) - \(originalStats.maxDamage))");
  L(s"New damage type \(newDamageType) with \(originalStats.damage) (\(originalStats.minDamage) - \(originalStats.maxDamage))");
}

@addMethod(PlayerPuppet)
public func RestorePersistedDamageType(itemData: ref<gameItemData>, originalStats: ref<DamageTypeStats>) -> Void {
  if Equals(originalStats.type, gamedataDamageType.Count) || Equals(originalStats.type, gamedataDamageType.Invalid) {
    return ;
  };

  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
  let newDamageType: gamedataDamageType = originalStats.type;
  let statsObject: StatsObjectID = itemData.GetStatsObjectID();

  this.RemoveCurrentDamageModifiers(statsSystem, statsObject);
  this.AssignNewDamageModifiers(statsSystem, statsObject, originalStats, newDamageType);
  L(s"Restored damage type \(newDamageType) with \(originalStats.damage) (\(originalStats.minDamage) - \(originalStats.maxDamage))");
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToInventory(evt: ref<ItemAddedEvent>) -> Bool {
  wrappedMethod(evt);
  EnhancedCraftSystem.GetInstance(this.GetGame()).RefreshData();
}
