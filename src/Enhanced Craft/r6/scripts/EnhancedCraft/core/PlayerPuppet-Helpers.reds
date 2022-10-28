module EnhancedCraft.Core
import EnhancedCraft.Common.DamageTypeStats
import EnhancedCraft.System.EnhancedCraftSystem
import EnhancedCraft.Common.ECraftUtils
import EnhancedCraft.Common.L

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
  let itemData: ref<gameItemData> = evt.itemData;
  if ECraftUtils.IsWeapon(itemData.GetItemType()) || ECraftUtils.IsClothes(itemData.GetItemType()) {
    EnhancedCraftSystem.GetInstance(this.GetGame()).RefreshSingleItem(itemData);
  };
}
