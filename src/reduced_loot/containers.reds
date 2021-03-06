import ReducedLootExclusions.RL_Exclusions
import ReducedLootTypes.RL_LootSource
import ReducedLootUtils.*

@addMethod(gameLootContainerBase)
private func EvaluateLoot() -> Void {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let items: array<wref<gameItemData>>;
  let item: wref<gameItemData>;
  let journalManager: wref<JournalManager>;
  let trackedObjective: wref<JournalQuestObjective>;
  let shouldKeepForId: Bool = false;
  let shouldKeepForQuest: Bool = false;
  let i: Int32 = 0;
  journalManager = GameInstance.GetJournalManager(this.GetGame());
  trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;

  if transactionSystem.GetItemList(this, items) {
    while i < ArraySize(items) {
      RLog("> Container check:");
      item = items[i];
      shouldKeepForId = RL_Exclusions.KeepForItemId(ItemID.GetTDBID(item.GetID()));
      shouldKeepForQuest = RL_Exclusions.KeepForQuestTarget(trackedObjective.GetId());
      RLog("? Item TDBID: " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item.GetID())));
      RLog("? Current quest objective: " + trackedObjective.GetId());
      RLog("? keep for id: " + BoolToString(shouldKeepForId) + ", keep for quest: " + BoolToString(shouldKeepForQuest));
      if RL_Checker.CanLootThis(item, RL_LootSource.Container) || this.IsQuest()  || shouldKeepForId || shouldKeepForQuest {
        RLog("+ kept for container " + ToStr(item));
      } else {
        RLog("- removed for container " + ToStr(item));
        transactionSystem.RemoveItem(this, item.GetID(), item.GetQuantity());
      };
      i += 1;
    };
  };
}

@replaceMethod(gameLootContainerBase)
protected cb func OnEvaluateLootQuality(evt: ref<EvaluateLootQualityEvent>) -> Bool {
  this.EvaluateLootQuality();
  this.EvaluateLoot();
  this.RequestHUDRefresh();
}
