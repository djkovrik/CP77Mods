module ReducedLoot.Money

public class ReducedLootMoneyConfig {
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Enable")
  @runtimeProperty("ModSettings.description", "Mod-RL-Enable-Desc")
  let enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Base-Values")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let dropCountMin: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Base-Values")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let dropCountMax: Int32 = 100;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Trash-Tier")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let dropCountMinTrashTier: Int32 = 10;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Trash-Tier")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let dropCountMaxTrashTier: Int32 = 30;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Weak-Tier")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let dropCountMinWeakTier: Int32 = 30;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Weak-Tier")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "200")
  let dropCountMaxWeakTier: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Normal-Tier")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "300")
  let dropCountMinNormalTier: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Normal-Tier")
  @runtimeProperty("ModSettings.category.order", "5")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "300")
  let dropCountMaxNormalTier: Int32 = 100;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Rare-Tier")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "400")
  let dropCountMinRareTier: Int32 = 100;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Rare-Tier")
  @runtimeProperty("ModSettings.category.order", "6")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "400")
  let dropCountMaxRareTier: Int32 = 200;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Elite-Tier")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Min-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "500")
  let dropCountMinEliteTier: Int32 = 200;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Elite-Tier")
  @runtimeProperty("ModSettings.category.order", "7")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Max-Drop-Count")
  @runtimeProperty("ModSettings.description", "Mod-RL-Drop-Count-Desc")
  @runtimeProperty("ModSettings.step", "10")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "500")
  let dropCountMaxEliteTier: Int32 = 400;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Uncommon")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardUncommon: Int32 = 500;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Rare")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardRare: Int32 = 2500;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Epic")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardEpic: Int32 = 4000;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "8")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Legendary")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardLegendary: Int32 = 9000;
}

public abstract class ReducedLootMoneyTweaker {

  public static func RefreshFlats(batch: ref<TweakDBBatch>) -> Void {
    let cfg: ref<ReducedLootMoneyConfig> = new ReducedLootMoneyConfig();
    if !cfg.enabled { return ; };
    // Money shards
    batch.SetFlat(t"Price.MoneyShardUncommon.value", cfg.priceMoneyShardUncommon);
    batch.SetFlat(t"Price.MoneyShardRare.value", cfg.priceMoneyShardRare);
    batch.SetFlat(t"Price.MoneyShardEpic.value", cfg.priceMoneyShardEpic);
    batch.SetFlat(t"Price.MoneyShardLegendary.value", cfg.priceMoneyShardLegendary);
    batch.UpdateRecord(t"Price.MoneyShardUncommon");
    batch.UpdateRecord(t"Price.MoneyShardRare");
    batch.UpdateRecord(t"Price.MoneyShardEpic");
    batch.UpdateRecord(t"Price.MoneyShardLegendary");
    // Tables
    let lootTableRecords: array<ref<TweakDBRecord>> = TweakDBInterface.GetRecords(n"LootTable_Record");
    let lootItems: array<wref<LootItem_Record>>;
    let record: ref<LootTable_Record>;
    let shouldUpdate: Bool;

    for lootTableRecord in lootTableRecords {
      record = lootTableRecord as LootTable_Record;
      shouldUpdate = TweakDBInterface.GetBool(record.GetID() + t".shouldTweakMoney", false);
      if IsDefined(record) && shouldUpdate {
        ArrayClear(lootItems);
        record.LootItems(lootItems);
        for item in lootItems {
          ReducedLootMoneyTweaker.UpdateRecords(cfg, batch, item);
        };
      };
    };
  }

  public static func UpdateRecords(cfg: ref<ReducedLootMoneyConfig>, batch: ref<TweakDBBatch>, item: ref<LootItem_Record>) -> Void {
    let dropMin: Int32 = cfg.dropCountMin;
    let dropMax: Int32 = cfg.dropCountMax;
    let prereq: ref<IPrereq_Record> = item.PlayerPrereqID();
    let itemID: TweakDBID = item.GetID();

    switch prereq.GetID() {
      case t"LootPrereqs.PlayerLevelTrashTierPrereq":
        dropMin = cfg.dropCountMinTrashTier;
        dropMax = cfg.dropCountMaxTrashTier;
        break;
      case t"LootPrereqs.PlayerLevelWeakTierPrereq":
        dropMin = cfg.dropCountMinWeakTier;
        dropMax = cfg.dropCountMaxWeakTier;
        break;
      case t"LootPrereqs.PlayerLevelNormalTierPrereq":
        dropMin = cfg.dropCountMinNormalTier;
        dropMax = cfg.dropCountMaxNormalTier;
        break;
      case t"LootPrereqs.PlayerLevelRareTierPrereq":
        dropMin = cfg.dropCountMinRareTier;
        dropMax = cfg.dropCountMaxRareTier;
        break;
      case t"LootPrereqs.PlayerLevelEliteTierPrereq":
        dropMin = cfg.dropCountMinEliteTier;
        dropMax = cfg.dropCountMaxEliteTier;
        break;
      default:
        break;
    };

    batch.SetFlat(itemID + t".dropCountMin", dropMin);
    batch.SetFlat(itemID + t".dropCountMax", dropMax);
  }
}
