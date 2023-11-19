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

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunHandicapCountMin: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunHandicapCountMax: Int32 = 60;

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
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunHandicapCountMin: Int32 = 30;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunHandicapCountMax: Int32 = 50;

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
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleHandicapCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleHandicapCountMax: Int32 = 100;

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
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let sniperHandicapCountMin: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let sniperHandicapCountMax: Int32 = 40;
}

public abstract class ReducedLootAmmoTweaker {

  public static func RefreshFlats(batch: ref<TweakDBBatch>) -> Void {
    let cfg: ref<ReducedLootAmmoConfig> = new ReducedLootAmmoConfig();
    if !cfg.enabled { return ; };

    // Handgun
    batch.SetFlat(t"Items.HandgunAmmoCustom.dropCountMin", cfg.handgunCountMin);
    batch.SetFlat(t"Items.HandgunAmmoCustom.dropCountMax", cfg.handgunCountMax);
    batch.UpdateRecord(t"Items.HandgunAmmoCustom");

    batch.SetFlat(t"Ammo.HandgunAmmoLoot.dropCountMin", cfg.handgunQueryCountMin);
    batch.SetFlat(t"Ammo.HandgunAmmoLoot.dropCountMax", cfg.handgunQueryCountMax);
    batch.UpdateRecord(t"Ammo.HandgunAmmoLoot");

    batch.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapMinQty", cfg.handgunHandicapCountMin);
    batch.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapMaxQty", cfg.handgunQueryCountMax);
    batch.UpdateRecord(t"Ammo.HandicapHandgunAmmoPreset");

    // Shotgun
    batch.SetFlat(t"Items.ShotgunAmmoCustom.dropCountMin", cfg.shotgunCountMin);
    batch.SetFlat(t"Items.ShotgunAmmoCustom.dropCountMax", cfg.shotgunCountMax);
    batch.UpdateRecord(t"Items.ShotgunAmmoCustom");

    batch.SetFlat(t"Ammo.ShotgunAmmoLoot.dropCountMin", cfg.shotgunQueryCountMin);
    batch.SetFlat(t"Ammo.ShotgunAmmoLoot.dropCountMax", cfg.shotgunQueryCountMax);
    batch.UpdateRecord(t"Ammo.ShotgunAmmoLoot");

    batch.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapMinQty", cfg.shotgunHandicapCountMin);
    batch.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapMaxQty", cfg.shotgunQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.HandicapShotgunAmmoPreset");

    // Riffle
    batch.SetFlat(t"Items.RifleAmmoCustom.dropCountMin", cfg.riffleCountMin);
    batch.SetFlat(t"Items.RifleAmmoCustom.dropCountMax", cfg.riffleCountMax);
    batch.UpdateRecord(t"Items.RifleAmmoCustom");

    batch.SetFlat(t"Ammo.RifleAmmoLoot.dropCountMin", cfg.riffleQueryCountMin);
    batch.SetFlat(t"Ammo.RifleAmmoLoot.dropCountMax", cfg.riffleQueryCountMax);
    batch.UpdateRecord(t"Ammo.RifleAmmoLoot");

    batch.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapMinQty", cfg.riffleHandicapCountMin);
    batch.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapMaxQty", cfg.riffleQueryCountMax);
    batch.UpdateRecord(t"Ammo.HandicapRifleAmmoPreset");

    // Sniper
    batch.SetFlat(t"Items.SniperRifleAmmoCustom.dropCountMin", cfg.sniperCountMin);
    batch.SetFlat(t"Items.SniperRifleAmmoCustom.dropCountMax", cfg.sniperCountMax);
    TweakDBManager.UpdateRecord(t"Items.SniperRifleAmmoCustom");

    batch.SetFlat(t"Ammo.SniperAmmoLoot.dropCountMin", cfg.sniperQueryCountMin);
    batch.SetFlat(t"Ammo.SniperAmmoLoot.dropCountMax", cfg.sniperQueryCountMax);
    batch.UpdateRecord(t"Ammo.SniperAmmoLoot");

    batch.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapMinQty", cfg.sniperHandicapCountMin);
    batch.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapMaxQty", cfg.sniperQueryCountMax);
    batch.UpdateRecord(t"Ammo.HandicapSniperRifleAmmoPreset");
  }
}
