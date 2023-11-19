import ReducedLootExclusions.RL_Exclusions
import ReducedLootTypes.RL_LootSource
import ReducedLootUtils.*

@addMethod(ScriptedPuppet)
private func EvaluateLoot() -> Void {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let items: array<wref<gameItemData>>;
  let item: wref<gameItemData>;
  let journalManager: wref<JournalManager>;
  let trackedObjective: wref<JournalQuestObjective>;
  let shouldKeepForId: Bool = false;
  let shouldKeepForQuest: Bool = false;
  let i: Int32 = 0;
  let tweakDbId: TweakDBID;
  journalManager = GameInstance.GetJournalManager(this.GetGame());
  trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
  
  if transactionSystem.GetItemList(this, items) {
    while i < ArraySize(items) {
      RLog("> NPC check:");
      item = items[i];
      tweakDbId = ItemID.GetTDBID(item.GetID());
      shouldKeepForId = RL_Exclusions.KeepForItemId(tweakDbId) || RL_Exclusions.KeepForQ(tweakDbId) || RL_Exclusions.KeepForSQ(tweakDbId) || RL_Exclusions.KeepForMQ(tweakDbId);
      shouldKeepForQuest = RL_Exclusions.KeepForQuestTarget(trackedObjective.GetId());
      RLog("? Item TDBID: " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item.GetID())));
      RLog("? Current quest objective: " + trackedObjective.GetId());
      RLog("? keep for id: " + BoolToString(shouldKeepForId) + ", keep for quest: " + BoolToString(shouldKeepForQuest));
      if RL_Checker.CanLootThis(item, RL_LootSource.Puppet) || this.IsQuest() || item.HasTag(n"Quest") || shouldKeepForId || shouldKeepForQuest || Equals(item.GetItemType(), gamedataItemType.Gen_Keycard) {
        RLog("+ kept for npc " + RL_Utils.ToStr(item));
      } else {
        RLog("- removed for npc " + RL_Utils.ToStr(item));
        transactionSystem.RemoveItem(this, item.GetID(), item.GetQuantity());
      };
      i += 1;
    };
  };
}

@wrapMethod(ScriptedPuppet)
protected cb func OnEvaluateLootQuality(evt: ref<gameEvaluateLootQualityEvent>) -> Bool {
  if wrappedMethod(evt) {
    this.EvaluateLoot();
    this.RequestHUDRefresh();
  };
}

@wrapMethod(ScriptedPuppet)
protected final func EvaluateLootQualityTask(data: ref<ScriptTaskData>) -> Void {
  wrappedMethod(data);
  this.EvaluateLoot();
  this.RequestHUDRefresh();
}

