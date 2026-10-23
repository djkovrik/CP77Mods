import ReducedLoot.Ammo.*
import ReducedLoot.CraftingMats.*
import ReducedLoot.Money.*

public class ReducedLootTweaks extends ScriptableTweak {
  protected func OnApply() {
    let batch: ref<TweakDBBatch> = TweakDBManager.StartBatch();
    let lootTableRecords: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"LootTable_Record");
    let controlledLootTableRecords: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"ControlledLootTable_Record");
    let lootItems: array<wref<LootItem_Record>>;
    let lootSets: array<wref<ControlledLootSet_Record>>;
    let record: ref<LootTable_Record>;
    let controlledRecord: ref<ControlledLootTable_Record>;


    // -- CONFIGS

    let ammoCfg: ref<ReducedLootAmmoConfig> = new ReducedLootAmmoConfig();
    let matsCfg: ref<ReducedLootMaterialsConfig> = new ReducedLootMaterialsConfig();


    // -- SEPARATE UPDATES

    ReducedLootAmmoTweaker.UpdateQueryRecords(batch, ammoCfg);
    ReducedLootAmmoTweaker.UpdateHandicapRecords(batch, ammoCfg);
    

    // -- LOOT TABLE UPDATES

    // LootTable_Record
    for lootTableRecord in lootTableRecords {
      record = lootTableRecord as LootTable_Record;
      if IsDefined(record) {
        ArrayClear(lootItems);
        record.LootItems(lootItems);
        for item in lootItems {
          ReducedLootAmmoTweaker.UpdateLootRecords(batch, ammoCfg, item);
          ReducedLootMaterialsTweaker.UpdateLootRecord(batch, matsCfg, item);
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
          // LootItems
          lootSet.LootItems(lootItems);
          for item in lootItems {
            ReducedLootAmmoTweaker.UpdateLootRecords(batch, ammoCfg, item);
            ReducedLootMaterialsTweaker.UpdateLootRecord(batch, matsCfg, item);
          };
          // ReplacementLootItems
          ArrayClear(lootItems);
          lootSet.ReplacementLootItems(lootItems);
          for item in lootItems {
            ReducedLootAmmoTweaker.UpdateLootRecords(batch, ammoCfg, item);
            ReducedLootMaterialsTweaker.UpdateLootRecord(batch, matsCfg, item);
          };
        };
      };
    };

    batch.Commit();
  }
}
