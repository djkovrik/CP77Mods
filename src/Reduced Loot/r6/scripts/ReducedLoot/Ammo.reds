module ReducedLoot.Ammo

public class ReducedLootAmmoConfig {
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Enable")
  @runtimeProperty("ModSettings.description", "Mod-RL-Enable-Desc")
  let enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Desc")
  let handicapEnabled: Bool = false;

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

@runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Limit")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let handgunHandicapLimit: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let handgunHandicapMin: Int32 = 90;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let handgunHandicapMax: Int32 = 150;

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

@runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Limit")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let shotgunHandicapLimit: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let shotgunHandicapMin: Int32 = 75;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let shotgunHandicapMax: Int32 = 125;

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

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Limit")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let riffleHandicapLimit: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let riffleHandicapMin: Int32 = 90;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let riffleHandicapMax: Int32 = 150;

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

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo") 
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Limit")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let sniperHandicapLimit: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let sniperHandicapMin: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.dependency", "handicapEnabled")
  let sniperHandicapMax: Int32 = 80;
}

public abstract class ReducedLootAmmoTweaker {

  public static func UpdateLootRecords(batch: ref<TweakDBBatch>, cfg: ref<ReducedLootAmmoConfig>, item: ref<LootItem_Record>) -> Void {
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

  public static func UpdateQueryRecords(batch: ref<TweakDBBatch>, cfg: ref<ReducedLootAmmoConfig>) -> Void {
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

  public static func UpdateHandicapRecords(batch: ref<TweakDBBatch>, cfg: ref<ReducedLootAmmoConfig>) -> Void {
    if !cfg.enabled || !cfg.handicapEnabled { return ; };

    // Handgun
    batch.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapLimit", cfg.handgunHandicapLimit);
    batch.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapMinQty", cfg.handgunHandicapMin);
    batch.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapMaxQty", cfg.handgunHandicapMax);
    batch.UpdateRecord(t"Ammo.HandicapHandgunAmmoPreset");

    // Shotgun
    batch.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapLimit", cfg.shotgunHandicapLimit);
    batch.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapMinQty", cfg.shotgunHandicapMin);
    batch.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapMaxQty", cfg.shotgunHandicapMax);
    batch.UpdateRecord(t"Ammo.HandicapShotgunAmmoPreset");

    // Riffle
    batch.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapLimit", cfg.riffleHandicapLimit);
    batch.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapMinQty", cfg.riffleHandicapMin);
    batch.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapMaxQty", cfg.riffleHandicapMax);
    batch.UpdateRecord(t"Ammo.HandicapRifleAmmoPreset");

    // Sniper
    batch.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapLimit", cfg.sniperHandicapLimit);
    batch.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapMinQty", cfg.sniperHandicapMin);
    batch.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapMaxQty", cfg.sniperHandicapMax);
    batch.UpdateRecord(t"Ammo.HandicapSniperRifleAmmoPreset");
  }
}

@wrapMethod(PlayerHandicapSystem)
public final const func CanDropAmmo() -> Bool {
  let cfg: ref<ReducedLootAmmoConfig> = new ReducedLootAmmoConfig();
  if cfg.enabled { return cfg.handicapEnabled; };

  return wrappedMethod();
}
