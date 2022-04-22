module EnhancedCraft.Core
import EnhancedCraft.Common.DamageTypeStats
import EnhancedCraft.Common.L

// -- Helper function to scale custom variant data to player level and original recipe quality
//    Used for crafted item and for crafting panel item preview so stats will match
@addMethod(PlayerPuppet)
public func ScaleCraftedItemData(itemData: ref<gameItemData>, quality: CName) -> Void {
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
  let qualityMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.Quality, gameStatModifierType.Additive, RPGManager.ItemQualityNameToValue(quality));
  statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.Quality);
  statsSystem.AddModifier(itemData.GetStatsObjectID(), qualityMod);
  RPGManager.ForceItemQuality(this, itemData, quality);
}

// -- Creates DamageTypeStats helper class based on original damage type
@addMethod(PlayerPuppet)
private func GetDamageTypeStats(ss: ref<StatsSystem>, object: StatsObjectID, damageType: gamedataDamageType) -> ref<DamageTypeStats> {
  let result: ref<DamageTypeStats> = new DamageTypeStats();
  result.type = damageType;

  switch damageType {
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

  return result;
}

// -- Builds new damage modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamage(value: Float, damageType: gamedataDamageType) -> ref<gameConstantStatModifierData> {
  let modifier: ref<gameConstantStatModifierData> = new gameConstantStatModifierData();
  modifier.modifierType = gameStatModifierType.Additive;
  modifier.value = value;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier.statType = gamedataStatType.ChemicalDamage;
      break;
    case gamedataDamageType.Electric:
      modifier.statType = gamedataStatType.ElectricDamage;
      break;
    case gamedataDamageType.Physical:
      modifier.statType = gamedataStatType.PhysicalDamage;
      break;
    case gamedataDamageType.Thermal:
      modifier.statType = gamedataStatType.ThermalDamage;
      break;
  };

  return modifier;
}

// -- Builds new min damage modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamageMin(value: Float, damageType: gamedataDamageType) -> ref<gameConstantStatModifierData> {
  let modifier: ref<gameConstantStatModifierData> = new gameConstantStatModifierData();
  modifier.modifierType = gameStatModifierType.Additive;
  modifier.value = value;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier.statType = gamedataStatType.ChemicalDamageMin;
      break;
    case gamedataDamageType.Electric:
      modifier.statType = gamedataStatType.ElectricDamageMin;
      break;
    case gamedataDamageType.Physical:
      modifier.statType = gamedataStatType.PhysicalDamageMin;
      break;
    case gamedataDamageType.Thermal:
      modifier.statType = gamedataStatType.ThermalDamageMin;
      break;
  };

  return modifier;
}

// -- Builds new max damage modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamageMax(value: Float, damageType: gamedataDamageType) -> ref<gameConstantStatModifierData> {
  let modifier: ref<gameConstantStatModifierData> = new gameConstantStatModifierData();
  modifier.modifierType = gameStatModifierType.Additive;
  modifier.value = value;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier.statType = gamedataStatType.ChemicalDamageMax;
      break;
    case gamedataDamageType.Electric:
      modifier.statType = gamedataStatType.ElectricDamageMax;
      break;
    case gamedataDamageType.Physical:
      modifier.statType = gamedataStatType.PhysicalDamageMax;
      break;
    case gamedataDamageType.Thermal:
      modifier.statType = gamedataStatType.ThermalDamageMax;
      break;
  };

  return modifier;
}

// -- Builds new damage percent modifier for specified type
@addMethod(PlayerPuppet)
private func BuildNewModifierDamagePercent(value: Float, damageType: gamedataDamageType) -> ref<gameConstantStatModifierData> {
  let modifier: ref<gameConstantStatModifierData> = new gameConstantStatModifierData();
  modifier.modifierType = gameStatModifierType.Additive;
  modifier.value = value;

  switch damageType {
    case gamedataDamageType.Chemical:
      modifier.statType = gamedataStatType.ChemicalDamagePercent;
      break;
    case gamedataDamageType.Electric:
      modifier.statType = gamedataStatType.ElectricDamagePercent;
      break;
    case gamedataDamageType.Physical:
      modifier.statType = gamedataStatType.PhysicalDamagePercent;
      break;
    case gamedataDamageType.Thermal:
      modifier.statType = gamedataStatType.ThermalDamagePercent;
      break;
  };

  return modifier;
}

// -- Clears current elemental damage modifiers from StatsObject
@addMethod(PlayerPuppet)
private func RemoveCurrentDamageModifiers(ss: ref<StatsSystem>, object: StatsObjectID, damageType: gamedataDamageType) -> Void {
  switch damageType {
    case gamedataDamageType.Chemical:
      ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamage, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamageMin, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamageMax, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ChemicalDamagePercent, true);
      break;
    case gamedataDamageType.Electric:
      ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamage, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamageMin, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamageMax, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ElectricDamagePercent, true);
      break;
    case gamedataDamageType.Physical:
      ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamage, true);
      ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamageMin, true);
      ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamageMax, true);
      ss.RemoveAllModifiers(object, gamedataStatType.PhysicalDamagePercent, true);
      break;
    case gamedataDamageType.Thermal:
      ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamage, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamageMin, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamageMax, true);
      ss.RemoveAllModifiers(object, gamedataStatType.ThermalDamagePercent, true);
      break;
  };
}

// -- Assigns new elemental damage modifiers to specified StatsObject
@addMethod(PlayerPuppet)
private func AssignNewDamageModifiers(ss: ref<StatsSystem>, object: StatsObjectID, stats: ref<DamageTypeStats>, damageType: gamedataDamageType) -> Void {
  let modifiderDamage: ref<gameConstantStatModifierData> = this.BuildNewModifierDamage(stats.damage, damageType);
  let modifiderDamageMin: ref<gameConstantStatModifierData> = this.BuildNewModifierDamageMin(stats.minDamage, damageType);
  let modifiderDamageMax: ref<gameConstantStatModifierData> = this.BuildNewModifierDamageMax(stats.maxDamage, damageType);
  let modifiderDamagePercent: ref<gameConstantStatModifierData> = this.BuildNewModifierDamagePercent(stats.percentDamage, damageType);

  ss.AddSavedModifier(object, modifiderDamage);
  ss.AddSavedModifier(object, modifiderDamageMin);
  ss.AddSavedModifier(object, modifiderDamageMax);
  ss.AddSavedModifier(object, modifiderDamagePercent);
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
  let originalStats: ref<DamageTypeStats> = this.GetDamageTypeStats(statsSystem, statsObject, currentDamageType);

  this.RemoveCurrentDamageModifiers(statsSystem, statsObject, currentDamageType);
  this.AssignNewDamageModifiers(statsSystem, statsObject, originalStats, newDamageType);
  L(s"Original damage type was \(currentDamageType) with \(originalStats.damage) (\(originalStats.minDamage) - \(originalStats.maxDamage))");
  L(s"New damage type \(newDamageType) with \(originalStats.damage) (\(originalStats.minDamage) - \(originalStats.maxDamage))");
}
