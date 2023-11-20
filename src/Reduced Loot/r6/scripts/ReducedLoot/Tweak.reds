import ReducedLoot.Ammo.*
import ReducedLoot.CraftingMats.*
import ReducedLoot.Money.*

public class ReducedLootTweaks extends ScriptableTweak {
  protected func OnApply() {
    let batch: ref<TweakDBBatch> = TweakDBManager.StartBatch();
    ReducedLootAmmoTweaker.RefreshFlats(batch);
    ReducedLootMaterialsTweaker.RefreshFlats(batch);
    ReducedLootMoneyTweaker.RefreshFlats(batch);
    batch.Commit();
  }
}
