module ReducedLoot.Money

public class ReducedLootMoneyConfig {
  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Enable")
  @runtimeProperty("ModSettings.description", "Mod-RL-Enable-Desc")
  let enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-World-Placed")
  @runtimeProperty("ModSettings.description", "Mod-RL-Money-World-Placed-Desc")
  let removeWorldPlaced: Bool = false;

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
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Uncommon")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardUncommon: Int32 = 500;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Rare")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardRare: Int32 = 2500;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Epic")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardEpic: Int32 = 4000;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Money-Shards")
  @runtimeProperty("ModSettings.category.order", "3")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Money-Shard-Legendary")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "100")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "10000")
  let priceMoneyShardLegendary: Int32 = 9000;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "UI-MappinTypes-GangWatch")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierGangWatch: Int32 = 900;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "UI-MappinTypes-HiddenStash")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierHiddenStash: Int32 = 500;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "LocKey#31788")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierCyberPsycho: Int32 = 1600;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "UI-MappinTypes-Outpost")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierOutpost: Int32 = 1300;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "UI-MappinTypes-Resource")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierResource: Int32 = 400;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "UI-MappinTypes-FailedCrossing")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierFailedCrossing: Int32 = 400;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Mini-Story")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierMiniStory: Int32 = 250;

  @runtimeProperty("ModSettings.mod", "Reduced Loot - Money")
  @runtimeProperty("ModSettings.category", "Mod-RL-Price-Modifiers")
  @runtimeProperty("ModSettings.category.order", "4")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-Street-Story")
  @runtimeProperty("ModSettings.description", "Mod-RL-Restart")
  @runtimeProperty("ModSettings.step", "50")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5000")
  let modifierStreetStory: Int32 = 250;
}

public abstract class ReducedLootMoneyTweaker {

  public static func UpdateShards(batch: ref<TweakDBBatch>) -> Void {
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
  }

  public static func UpdatePriceModifiers(batch: ref<TweakDBBatch>) -> Void {
    let cfg: ref<ReducedLootMoneyConfig> = new ReducedLootMoneyConfig();
    if !cfg.enabled { return ; };

    // Price modifiers
    batch.SetFlat(t"Price.GangWatch_BaseMoney.value", cfg.modifierGangWatch);
    batch.UpdateRecord(t"Price.GangWatch_BaseMoney");
    batch.SetFlat(t"Price.HiddenStash_BaseMoney.value", cfg.modifierHiddenStash);
    batch.UpdateRecord(t"Price.HiddenStash_BaseMoney");
    batch.SetFlat(t"Price.CyberPsycho_BaseMoney.value", cfg.modifierCyberPsycho);
    batch.UpdateRecord(t"Price.CyberPsycho_BaseMoney");
    batch.SetFlat(t"Price.Outpost_BaseMoney.value", cfg.modifierOutpost);
    batch.UpdateRecord(t"Price.Outpost_BaseMoney");
    batch.SetFlat(t"Price.EndlessOutpost_BaseMoney_Big.min", cfg.modifierOutpost);
    batch.SetFlat(t"Price.EndlessOutpost_BaseMoney_Big.max", cfg.modifierOutpost);
    batch.UpdateRecord(t"Price.EndlessOutpost_BaseMoney_Big");
    batch.SetFlat(t"Price.EndlessOutpost_BaseMoney_Small.min", cfg.modifierOutpost);
    batch.SetFlat(t"Price.EndlessOutpost_BaseMoney_Small.max", cfg.modifierOutpost);
    batch.UpdateRecord(t"Price.EndlessOutpost_BaseMoney_Small");
    batch.SetFlat(t"Price.Resource_BaseMoney.value", cfg.modifierResource);
    batch.UpdateRecord(t"Price.Resource_BaseMoney");
    batch.SetFlat(t"Price.FailedCrossing_BaseMoney.value", cfg.modifierFailedCrossing);
    batch.UpdateRecord(t"Price.FailedCrossing_BaseMoney");
    batch.SetFlat(t"Price.BaseMiniStory_BaseMoney.value", cfg.modifierMiniStory);
    batch.UpdateRecord(t"Price.BaseMiniStory_BaseMoney");
    batch.SetFlat(t"Price.StreetStory_BaseMoney.value", cfg.modifierStreetStory);
    batch.UpdateRecord(t"Price.StreetStory_BaseMoney");
  }
}

public abstract class ReducedLootMoneyDrop {

  public static func ShouldDelete(data: ref<gameItemData>, cfg: ref<ReducedLootMoneyConfig>) -> Bool {
    let tweakDbID: TweakDBID = ItemID.GetTDBID(data.GetID());
    if Equals(tweakDbID, t"Items.money") {
      return cfg.removeWorldPlaced;
    };

    return false;
  }

  public static func TweakEvaluated(owner: ref<GameObject>, ts: ref<TransactionSystem>, data: wref<gameItemData>, cfg: ref<ReducedLootMoneyConfig>) -> Void {
    let tweakDbID: TweakDBID = ItemID.GetTDBID(data.GetID());
    if Equals(tweakDbID, t"Items.money") {
      ReducedLootMoneyDrop.HandleDrop(owner, ts, data, cfg);
    };
  }

  private static func HandleDrop(owner: ref<GameObject>, ts: ref<TransactionSystem>, data: wref<gameItemData>, cfg: ref<ReducedLootMoneyConfig>) -> Void {
    ts.RemoveItem(owner, data.GetID(), data.GetQuantity());
    let newQuantity: Int32;
    if cfg.dropCountMax > cfg.dropCountMin {
      newQuantity = RandRange(cfg.dropCountMin, cfg.dropCountMax);
      ts.GiveItem(owner, data.GetID(), newQuantity);
    };
  }
}
