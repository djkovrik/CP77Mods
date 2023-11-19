module ReducedLoot.Ammo

public class ReducedLootAmmoConfig {
  // Handgun
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunCountMax: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunQueryCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunQueryCountMax: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunHandicapCountMin: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50354")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let handgunHandicapCountMax: Int32 = 60;

  // Shotgun
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunCountMin: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunCountMax: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunQueryCountMin: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunQueryCountMax: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunHandicapCountMin: Int32 = 30;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50356")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let shotgunHandicapCountMax: Int32 = 50;

  // Riffle
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleCountMax: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleQueryCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleQueryCountMax: Int32 = 120;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleHandicapCountMin: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50358")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let riffleHandicapCountMax: Int32 = 100;

  // Sniper
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperCountMin: Int32 = 12;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperCountMax: Int32 = 16;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperQueryCountMin: Int32 = 12;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Query-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Query-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  let sniperQueryCountMax: Int32 = 16;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let sniperHandicapCountMin: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Ammo")
  @runtimeProperty("ModSettings.category", "LocKey#50360")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Ammo-Handicap-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Ammo-Handicap-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "5")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let sniperHandicapCountMax: Int32 = 40;
}

public class ReducedLootAmmoSystem extends ScriptableSystem {
  private func OnAttach() {
    ModSettings.RegisterListenerToModifications(this);
    this.RefreshAmmoFlats();
  }

  private func OnDetach() {
    ModSettings.UnregisterListenerToModifications(this);
  }

  public func OnModSettingsChange() -> Void {
    this.RefreshAmmoFlats();
  }

  private func RefreshAmmoFlats() -> Void {
    let cfg: ref<ReducedLootAmmoConfig> = new ReducedLootAmmoConfig();
    // Handgun
    TweakDBManager.SetFlat(t"Items.HandgunAmmoCustom.dropCountMin", cfg.handgunCountMin);
    TweakDBManager.SetFlat(t"Items.HandgunAmmoCustom.dropCountMax", cfg.handgunCountMax);
    TweakDBManager.UpdateRecord(t"Items.HandgunAmmoCustom");

    TweakDBManager.SetFlat(t"Ammo.HandgunAmmoLoot.dropCountMin", cfg.handgunQueryCountMin);
    TweakDBManager.SetFlat(t"Ammo.HandgunAmmoLoot.dropCountMax", cfg.handgunQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.HandgunAmmoLoot");

    TweakDBManager.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapMinQty", cfg.handgunHandicapCountMin);
    TweakDBManager.SetFlat(t"Ammo.HandicapHandgunAmmoPreset.handicapMaxQty", cfg.handgunQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.HandicapHandgunAmmoPreset");

    // Shotgun
    TweakDBManager.SetFlat(t"Items.ShotgunAmmoCustom.dropCountMin", cfg.shotgunCountMin);
    TweakDBManager.SetFlat(t"Items.ShotgunAmmoCustom.dropCountMax", cfg.shotgunCountMax);
    TweakDBManager.UpdateRecord(t"Items.ShotgunAmmoCustom");

    TweakDBManager.SetFlat(t"Ammo.ShotgunAmmoLoot.dropCountMin", cfg.shotgunQueryCountMin);
    TweakDBManager.SetFlat(t"Ammo.ShotgunAmmoLoot.dropCountMax", cfg.shotgunQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.ShotgunAmmoLoot");

    TweakDBManager.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapMinQty", cfg.shotgunHandicapCountMin);
    TweakDBManager.SetFlat(t"Ammo.HandicapShotgunAmmoPreset.handicapMaxQty", cfg.shotgunQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.HandicapShotgunAmmoPreset");

    // Riffle
    TweakDBManager.SetFlat(t"Items.RifleAmmoCustom.dropCountMin", cfg.riffleCountMin);
    TweakDBManager.SetFlat(t"Items.RifleAmmoCustom.dropCountMax", cfg.riffleCountMax);
    TweakDBManager.UpdateRecord(t"Items.RifleAmmoCustom");

    TweakDBManager.SetFlat(t"Ammo.RifleAmmoLoot.dropCountMin", cfg.riffleQueryCountMin);
    TweakDBManager.SetFlat(t"Ammo.RifleAmmoLoot.dropCountMax", cfg.riffleQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.RifleAmmoLoot");

    TweakDBManager.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapMinQty", cfg.riffleHandicapCountMin);
    TweakDBManager.SetFlat(t"Ammo.HandicapRifleAmmoPreset.handicapMaxQty", cfg.riffleQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.HandicapRifleAmmoPreset");

    // Sniper
    TweakDBManager.SetFlat(t"Items.SniperRifleAmmoCustom.dropCountMin", cfg.sniperCountMin);
    TweakDBManager.SetFlat(t"Items.SniperRifleAmmoCustom.dropCountMax", cfg.sniperCountMax);
    TweakDBManager.UpdateRecord(t"Items.SniperRifleAmmoCustom");

    TweakDBManager.SetFlat(t"Ammo.SniperAmmoLoot.dropCountMin", cfg.sniperQueryCountMin);
    TweakDBManager.SetFlat(t"Ammo.SniperAmmoLoot.dropCountMax", cfg.sniperQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.SniperAmmoLoot");

    TweakDBManager.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapMinQty", cfg.sniperHandicapCountMin);
    TweakDBManager.SetFlat(t"Ammo.HandicapSniperRifleAmmoPreset.handicapMaxQty", cfg.sniperQueryCountMax);
    TweakDBManager.UpdateRecord(t"Ammo.HandicapSniperRifleAmmoPreset");
  }
}
