import ReducedLoot.Ammo.*
import ReducedLoot.CraftingMats.*
import ReducedLoot.Money.*

public class ReducedLootSystem extends ScriptableSystem {
  private func OnAttach() {
    this.RefreshLootFlats();
  }

  private final func RefreshLootFlats() {
    let batch: ref<TweakDBBatch> = TweakDBManager.StartBatch();

    ReducedLootAmmoTweaker.RefreshFlats(batch);
    ReducedLootMaterialsTweaker.RefreshFlats(batch);
    ReducedLootMoneyTweaker.RefreshFlats(batch);

    batch.Commit();
  }
}
