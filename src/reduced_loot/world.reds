import ReducedLootExclusions.RL_Exclusions
import ReducedLootTypes.RL_LootSource
import ReducedLootDeclarations.*
import ReducedLootUtils.*

@replaceMethod(VendingMachine)
protected func CreateDispenseRequest(shouldPay: Bool, item: ItemID) -> ref<DispenseRequest> {
  let dispenseRequest: ref<DispenseRequest> = new DispenseRequest();
  dispenseRequest.owner = this;
  dispenseRequest.position = this.RandomizePosition();
  dispenseRequest.shouldPay = shouldPay;
  if ItemID.IsValid(item) {
    dispenseRequest.itemID = item;
    // Always save spawned items
    GetPlayer(this.GetGame()).StoreItemId_RL(item);
  };
  return dispenseRequest;
}

@replaceMethod(gameItemDropObject)
protected final func OnItemEntitySpawned(entID: EntityID) -> Void {
  let playerPuppet: ref<PlayerPuppet>;
  let data: ref<gameItemData> = this.GetItemObject().GetItemData();
  let journalManager: wref<JournalManager>;
  let trackedObjective: wref<JournalQuestObjective>;
  let preventDestroying: Bool = false;
  let shouldKeepForId: Bool = false;
  let shouldKeepForQuest: Bool = false;
  let shouldKeepBecauseWasHeld: Bool = false;

  playerPuppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  if IsDefined(playerPuppet) {
    RLog("> World check:");
    journalManager = GameInstance.GetJournalManager(playerPuppet.GetGame());
    trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
    preventDestroying = Equals(this.GetItemObject().GetItemID(), playerPuppet.GetStoredId_RL());
    shouldKeepForId = RL_Exclusions.KeepForItemId(ItemID.GetTDBID(data.GetID()));
    shouldKeepForQuest = RL_Exclusions.KeepForQuestTarget(trackedObjective.GetId());
    shouldKeepBecauseWasHeld = data.GetShouldKeep_RL();
    RLog("? Item TDBID: " + TDBID.ToStringDEBUG(ItemID.GetTDBID(data.GetID())));
    RLog("? Current quest objective: " + trackedObjective.GetId());
    RLog("? keep for id: " + BoolToString(shouldKeepForId) + ", no destroy: " + BoolToString(preventDestroying) + ", keep for quest: " + BoolToString(shouldKeepForQuest) + ", was held: " + BoolToString(shouldKeepBecauseWasHeld));
  };
  if RL_Checker.CanLootThis(data, RL_LootSource.World) || preventDestroying || shouldKeepForId || shouldKeepForQuest || shouldKeepBecauseWasHeld {
    RLog("+ kept for world " + UIItemsHelper.GetItemTypeKey(data.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(data)));
  } else {
    RLog("- removed from world " + UIItemsHelper.GetItemTypeKey(data.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(data)));
    EntityGameInterface.Destroy(this.GetEntity());
    return ;
  };

  this.SetQualityRangeInteractionLayerState(true);
  this.EvaluateLootQualityEvent(entID);
  this.RequestHUDRefresh();
}
