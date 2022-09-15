module EnhancedCraft.Common

// -- Basic class for newly crafted weapon stats
public class DamageTypeStats {
  public let type: gamedataDamageType;
  public let damage: Float;
  public let minDamage: Float;
  public let maxDamage: Float;
  public let percentDamage: Float;

  public static func GetPS(itemId: ItemID, self: ref<DamageTypeStats>) -> ref<DamageTypeStatsPS> {
    let result: ref<DamageTypeStatsPS> = new DamageTypeStatsPS();
    result.id = ItemID.GetCombinedHash(itemId);
    result.type = EnumInt(self.type);
    result.damage = self.damage;
    result.minDamage = self.minDamage;
    result.maxDamage = self.maxDamage;
    result.percentDamage = self.percentDamage;
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

  public static func GetNormal(self: ref<DamageTypeStatsPS>) -> ref<DamageTypeStats> {
    let result: ref<DamageTypeStats> = new DamageTypeStats();
    result.type = IntEnum<gamedataDamageType>(self.type);
    result.damage = self.damage;
    result.minDamage = self.minDamage;
    result.minDamage = self.minDamage;
    result.maxDamage = self.maxDamage;
    result.percentDamage = self.percentDamage;
    return result;
  }
}

// -- Persisted custom name data
public class CustomCraftNameDataPS {
  public persistent let id: Uint64;
  public persistent let name: CName;
}
