module EnhancedCraft.Common

// -- Basic class for newly crafted weapon stats
public class DamageTypeStats {
  public let type: gamedataDamageType;
  public let damage: Float;
  public let minDamage: Float;
  public let maxDamage: Float;
  public let percentDamage: Float;
  public let critChance: Float;
  public let critChanceTimeCritDamage: Float;
  public let critDamage: Float;
  public let critDPSBonus: Float;
  public let headshotMultiplier: Float;
  public let bonusRicochetDamage: Float;
  public let staminaCostReduction: Float;
  public let chargeMultiplier: Float;
  public let chargeTime: Float;

  public static func GetPS(itemId: ItemID, self: ref<DamageTypeStats>) -> ref<DamageTypeStatsPS> {
    let result: ref<DamageTypeStatsPS> = new DamageTypeStatsPS();
    result.id = ItemID.GetCombinedHash(itemId);
    result.type = EnumInt(self.type);
    result.damage = self.damage;
    result.minDamage = self.minDamage;
    result.maxDamage = self.maxDamage;
    result.percentDamage = self.percentDamage;
    result.critChance = self.critChance;
    result.critChanceTimeCritDamage = self.critChanceTimeCritDamage;
    result.critDamage = self.critDamage;
    result.critDPSBonus = self.critDPSBonus;
    result.headshotMultiplier = self.headshotMultiplier;
    result.bonusRicochetDamage = self.bonusRicochetDamage;
    result.staminaCostReduction = self.staminaCostReduction;
    result.chargeMultiplier = self.chargeMultiplier;
    result.chargeTime = self.chargeTime;
    return result;
  }
}

// -- Basic class for persisting newly crafted weapon stats
public class DamageTypeStatsPS {
  public persistent let id: Uint64;
  public persistent let type: Int32;
  public persistent let damage: Float;
  public persistent let minDamage: Float;
  public persistent let maxDamage: Float;
  public persistent let percentDamage: Float;
  public persistent let critChance: Float;
  public persistent let critChanceTimeCritDamage: Float;
  public persistent let critDamage: Float;
  public persistent let critDPSBonus: Float;
  public persistent let headshotMultiplier: Float;
  public persistent let bonusRicochetDamage: Float;
  public persistent let staminaCostReduction: Float;
  public persistent let chargeMultiplier: Float;
  public persistent let chargeTime: Float;

  public static func GetNormal(self: ref<DamageTypeStatsPS>) -> ref<DamageTypeStats> {
    let result: ref<DamageTypeStats> = new DamageTypeStats();
    result.type = IntEnum<gamedataDamageType>(self.type);
    result.damage = self.damage;
    result.minDamage = self.minDamage;
    result.minDamage = self.minDamage;
    result.maxDamage = self.maxDamage;
    result.percentDamage = self.percentDamage;
    result.critChance = self.critChance;
    result.critChanceTimeCritDamage = self.critChanceTimeCritDamage;
    result.critDamage = self.critDamage;
    result.critDPSBonus = self.critDPSBonus;
    result.headshotMultiplier = self.headshotMultiplier;
    result.bonusRicochetDamage = self.bonusRicochetDamage;
    result.staminaCostReduction = self.staminaCostReduction;
    result.chargeMultiplier = self.chargeMultiplier;
    result.chargeTime = self.chargeTime;
    return result;
  }
}

// -- Persisted custom name data
public class CustomCraftNameDataPS {
  public persistent let id: Uint64;
  public persistent let name: CName;
}

enum ECraftPerkToUnlockDamageTypes {
  Undefined = 0,
  NoPerk = 1,
  TrueCraftsman = 2,
  GreaseMonkey = 3,
  EdgerunnerArtisan = 4
}

enum ECraftPerkToUnlockStandard {
  Undefined = 0,
  NoPerk = 1,
  TrueCraftsman = 2,
  GreaseMonkey = 3,
  EdgerunnerArtisan = 4
}

enum ECraftPerkToUnlockIconics {
  Undefined = 0,
  NoPerk = 1,
  DisableIconics = 2,
  TrueCraftsman = 3,
  GreaseMonkey = 4,
  EdgerunnerArtisan = 5
}

enum ECraftIconicRecipeCondition {
  Undefined = 0,
  Rare = 1,
  Epic = 2,
  Legendary = 3
}

enum ECraftPerkToUnlockClothes {
  Undefined = 0,
  NoPerk = 1,
  TrueCraftsman = 2,
  GreaseMonkey = 3,
  EdgerunnerArtisan = 4
}
