module ReducedLoot.Ammo

public class ReducedLootAmmoConfig {
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Enable")
  @runtimeProperty("ModSettings.description", "Mod-RL-Enable-Desc")
  let enabled: Bool = true;

  // Handgun
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunCountMax: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunQueryCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunQueryCountMax: Int32 = 120;

  // Shotgun
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunCountMin: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunCountMax: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunQueryCountMin: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunQueryCountMax: Int32 = 40;

  // Riffle
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleCountMax: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleQueryCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleQueryCountMax: Int32 = 120;

  // Sniper
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperCountMin: Int32 = 12;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperCountMax: Int32 = 16;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperQueryCountMin: Int32 = 12;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperQueryCountMax: Int32 = 16;
}

public abstract class ReducedLootAmmoTweaker {

  public static func UpdateLootRecord(batch: ref<TweakDBBatch>, cfg: ref<ReducedLootAmmoConfig>, item: ref<LootItem_Record>) -> Void {
    if !cfg.enabled { return ; };

    let itemID: TweakDBID = item.GetID();
    let targetItemId: TweakDBID = item.ItemID().GetID();

    switch targetItemId {
      case t"Ammo.HandgunAmmo":
        batch.SetFlat(itemID + t".dropCountMin", cfg.handgunCountMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.handgunCountMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Ammo.ShotgunAmmo":
        batch.SetFlat(itemID + t".dropCountMin", cfg.shotgunCountMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.shotgunCountMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Ammo.RifleAmmo":
        batch.SetFlat(itemID + t".dropCountMin", cfg.riffleCountMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.riffleCountMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Ammo.SniperRifleAmmo":
        batch.SetFlat(itemID + t".dropCountMin", cfg.sniperCountMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.sniperCountMax);
        batch.UpdateRecord(itemID);
        break;
      default:
        break;
    };
  }

  public static func UpdateQueryRecords(batch: ref<TweakDBBatch>) -> Void {
    let cfg: ref<ReducedLootAmmoConfig> = new ReducedLootAmmoConfig();
    if !cfg.enabled { return ; };

    // Handgun
    batch.SetFlat(t"Ammo.HandgunAmmoLoot.dropCountMin", cfg.handgunQueryCountMin);
    batch.SetFlat(t"Ammo.HandgunAmmoLoot.dropCountMax", cfg.handgunQueryCountMax);
    batch.UpdateRecord(t"Ammo.HandgunAmmoLoot");

    // Shotgun
    batch.SetFlat(t"Ammo.ShotgunAmmoLoot.dropCountMin", cfg.shotgunQueryCountMin);
    batch.SetFlat(t"Ammo.ShotgunAmmoLoot.dropCountMax", cfg.shotgunQueryCountMax);
    batch.UpdateRecord(t"Ammo.ShotgunAmmoLoot");

    // Riffle
    batch.SetFlat(t"Ammo.RifleAmmoLoot.dropCountMin", cfg.riffleQueryCountMin);
    batch.SetFlat(t"Ammo.RifleAmmoLoot.dropCountMax", cfg.riffleQueryCountMax);
    batch.UpdateRecord(t"Ammo.RifleAmmoLoot");

    // Sniper
    batch.SetFlat(t"Ammo.SniperAmmoLoot.dropCountMin", cfg.sniperQueryCountMin);
    batch.SetFlat(t"Ammo.SniperAmmoLoot.dropCountMax", cfg.sniperQueryCountMax);
    batch.UpdateRecord(t"Ammo.SniperAmmoLoot");
  }
}

@wrapMethod(PlayerHandicapSystem)
public final const func CanDropAmmo() -> Bool {
  let cfg: ref<ReducedLootAmmoConfig> = new ReducedLootAmmoConfig();
  if cfg.enabled { return false; };

  return wrappedMethod();
}
