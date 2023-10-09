import ReducedLootExclusions.RL_Exclusions
import ReducedLootTypes.RL_LootSource
import ReducedLootUtils.*

@addMethod(gameLootContainerBase)
private func EvaluateLootCustom() -> Void {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let items: array<wref<gameItemData>>;
  let item: wref<gameItemData>;
  let journalManager: wref<JournalManager>;
  let trackedObjective: wref<JournalQuestObjective>;
  let containerHash: Uint32 = EntityID.GetHash(this.GetEntityID());
  let shouldKeepForContainer: Bool = RL_Exclusions.KeepForContainer(containerHash);
  let shouldKeepForId: Bool = false;
  let shouldKeepForQuest: Bool = false;
  let i: Int32 = 0;
  let tweakDbId: TweakDBID;
  journalManager = GameInstance.GetJournalManager(this.GetGame());
  trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;

  if transactionSystem.GetItemList(this, items) {
    while i < ArraySize(items) {
      RLog(s"> Container \(containerHash) check:");
      item = items[i];
      tweakDbId = ItemID.GetTDBID(item.GetID());
      shouldKeepForId = RL_Exclusions.KeepForItemId(tweakDbId) || RL_Exclusions.KeepForQ(tweakDbId) || RL_Exclusions.KeepForSQ(tweakDbId) || RL_Exclusions.KeepForMQ(tweakDbId);
      shouldKeepForQuest = RL_Exclusions.KeepForQuestTarget(trackedObjective.GetId());
      RLog("? Item TDBID: " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item.GetID())));
      RLog("? Current quest objective: " + trackedObjective.GetId());
      RLog("? keep for id: " + BoolToString(shouldKeepForId) + ", keep for quest: " + BoolToString(shouldKeepForQuest));
      if RL_Checker.CanLootThis(item, RL_LootSource.Container) || this.IsQuest() || item.HasTag(n"Quest") || shouldKeepForId || shouldKeepForQuest || shouldKeepForContainer || Equals(item.GetItemType(), gamedataItemType.Gen_Keycard) {
        RLog(s"+ kept for container \(containerHash) " + ToStr(item));
      } else {
        RLog(s"- removed for container \(containerHash) " + ToStr(item));
        transactionSystem.RemoveItem(this, item.GetID(), item.GetQuantity());
      };
      i += 1;
    };
  };
}

@wrapMethod(gameLootContainerBase)
protected cb func OnEvaluateLootQuality(evt: ref<gameEvaluateLootQualityEvent>) -> Bool {
  wrappedMethod(evt);
  this.EvaluateLootCustom();
  this.RequestHUDRefresh();
}

@wrapMethod(gameLootContainerBase)
protected final func EvaluateLootQualityTask(data: ref<ScriptTaskData>) -> Void {
  wrappedMethod(data);
  this.EvaluateLootCustom();
  this.RequestHUDRefresh();
}
