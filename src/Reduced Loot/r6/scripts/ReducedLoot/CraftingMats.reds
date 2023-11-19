module ReducedLoot.CraftingMats

public class ReducedLootMaterialsConfig {
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Enable")
  @runtimeProperty("ModSettings.description", "Mod-RL-Enable-Desc")
  let enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4933")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let CommonMaterial1dropMin: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4933")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let CommonMaterial1dropMax: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4934")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let UncommonMaterial1dropMin: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4934")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let UncommonMaterial1dropMax: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4935")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let RareMaterial1dropMin: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4935")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let RareMaterial1dropMax: Int32 = 18;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4936")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let EpicMaterial1dropMin: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4936")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let EpicMaterial1dropMax: Int32 = 18;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4937")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let LegendaryMaterial1dropMin: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#4937")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let LegendaryMaterial1dropMax: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#34881")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackUncommonMaterial1dropMin: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#34881")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackUncommonMaterial1dropMax: Int32 = 8;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#54086")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackRareMaterial1dropMin: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#54086")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackRareMaterial1dropMax: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#34882")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackEpicMaterial1dropMin: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#34882")
  @runtimeProperty("ModSettings.category.order", "9")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackEpicMaterial1dropMax: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#54087")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackLegendaryMaterial1dropMin: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Materials")
  @runtimeProperty("ModSettings.category", "LocKey#54087")
  @runtimeProperty("ModSettings.category.order", "10")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "50")
  public let QuickHackLegendaryMaterial1dropMax: Int32 = 2;
}

public abstract class ReducedLootMaterialsTweaker {

  public static func RefreshFlats(batch: ref<TweakDBBatch>) -> Void {
    let cfg: ref<ReducedLootMaterialsConfig> = new ReducedLootMaterialsConfig();
    if !cfg.enabled { return ; };

    let lootTableRecords: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"LootTable_Record");
    let controlledLootTableRecords: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"ControlledLootTable_Record");
    let lootItems: array<wref<LootItem_Record>>;
    let lootSets: array<wref<ControlledLootSet_Record>>;
    let record: ref<LootTable_Record>;
    let controlledRecord: ref<ControlledLootTable_Record>;

    // LootTable_Record
    for lootTableRecord in lootTableRecords {
      record = lootTableRecord as LootTable_Record;
      if IsDefined(record) {
        ArrayClear(lootItems);
        record.LootItems(lootItems);
        for item in lootItems {
          ReducedLootMaterialsTweaker.UpdateRecords(cfg, batch, item);
        };
      };
    };

    // ControlledLootTable_Record
    for controlledLootTableRecord in controlledLootTableRecords {
      controlledRecord = controlledLootTableRecord as ControlledLootTable_Record;
      if IsDefined(controlledRecord) {
        controlledRecord.ControlledLootSets(lootSets);
        for lootSet in lootSets {
          ArrayClear(lootItems);
          // Loot
          lootSet.LootItems(lootItems);
          for item in lootItems {
            ReducedLootMaterialsTweaker.UpdateRecords(cfg, batch, item);
          };
          // Replacement loot
          ArrayClear(lootItems);
          lootSet.ReplacementLootItems(lootItems);
          for item in lootItems {
            ReducedLootMaterialsTweaker.UpdateRecords(cfg, batch, item);
          };
        };
      };
    };
  }

  public static func UpdateRecords(cfg: ref<ReducedLootMaterialsConfig>, batch: ref<TweakDBBatch>, item: ref<LootItem_Record>) -> Void {
    let itemID: TweakDBID = item.GetID();
    let targetItemId: TweakDBID = item.ItemID().GetID();
    switch (targetItemId) {
      case t"Items.CommonMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.CommonMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.CommonMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.UncommonMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.UncommonMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.UncommonMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.RareMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.RareMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.RareMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.EpicMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.EpicMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.EpicMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.LegendaryMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.LegendaryMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.LegendaryMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.QuickHackUncommonMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.QuickHackUncommonMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.QuickHackUncommonMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.QuickHackRareMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.QuickHackRareMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.QuickHackRareMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.QuickHackEpicMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.QuickHackEpicMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.QuickHackEpicMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      case t"Items.QuickHackLegendaryMaterial1": 
        batch.SetFlat(itemID + t".dropCountMin", cfg.QuickHackLegendaryMaterial1dropMin);
        batch.SetFlat(itemID + t".dropCountMax", cfg.QuickHackLegendaryMaterial1dropMax);
        batch.UpdateRecord(itemID);
        break;
      default:
        break;
    };
  }
}
