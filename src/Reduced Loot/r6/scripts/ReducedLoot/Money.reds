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
}

public abstract class ReducedLootMoneyDrop {

  public static func ShouldDelete(data: ref<gameItemData>, cfg: ref<ReducedLootMoneyConfig>) -> Bool {
    if !cfg.enabled { return false; };

    let tweakDbID: TweakDBID = ItemID.GetTDBID(data.GetID());
    if Equals(tweakDbID, t"Items.money") {
      return cfg.removeWorldPlaced;
    };

    return false;
  }

  public static func TweakEvaluated(owner: ref<GameObject>, ts: ref<TransactionSystem>, data: wref<gameItemData>, cfg: ref<ReducedLootMoneyConfig>) -> Void {
     if !cfg.enabled { return ; };
    
    let tweakDbID: TweakDBID = ItemID.GetTDBID(data.GetID());
    if Equals(tweakDbID, t"Items.money") {
      ReducedLootMoneyDrop.HandleDrop(owner, ts, data, cfg);
    };
  }

  private static func HandleDrop(owner: ref<GameObject>, ts: ref<TransactionSystem>, data: wref<gameItemData>, cfg: ref<ReducedLootMoneyConfig>) -> Void {
    let oldQuantity: Int32 = data.GetQuantity();
    let min: Int32;
    let max: Int32;
    if cfg.dropCountMin > cfg.dropCountMax {
      min = cfg.dropCountMax;
      max = cfg.dropCountMin;
    } else if cfg.dropCountMin == cfg.dropCountMax {
      min = cfg.dropCountMin;
      max = cfg.dropCountMax + 1;
    } else {
      min = cfg.dropCountMin;
      max = cfg.dropCountMax;
    };

    let diff: Int32;
    if oldQuantity < min {
      // add more
      diff = min - oldQuantity;
      ts.GiveItemByTDBID(owner, t"Items.money", diff);
    } else if oldQuantity > max {
      // remove extra
      diff = oldQuantity - max;
      ts.RemoveItemByTDBID(owner, t"Items.money", diff);
    };
  }
}
