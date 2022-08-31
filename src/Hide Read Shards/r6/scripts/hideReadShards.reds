// Delayed destroy for shard entity
public class HideShardCaseEvent extends Event {}

@addMethod(ShardCaseContainer)
private func DestroyShard() -> Void {
  GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, new HideShardCaseEvent(), 1.0);
}

@addMethod(ShardCaseContainer)
protected cb func OnHideShardCaseEvent(evt: ref<HideShardCaseEvent>) -> Bool {
  EntityGameInterface.Destroy(this.GetEntity());
}

// Checks if shard was read or taken already
@addMethod(ShardCaseContainer)
private func IsShardReadOrTaken(record: wref<JournalOnscreen>) -> Bool {
  let journal: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGame());
  let context: JournalRequestContext;
  let currentGroup: wref<JournalOnscreensStructuredGroup>;
  let currentShard: wref<JournalOnscreen>;
  let groups: array<ref<JournalOnscreensStructuredGroup>>;
  let shards: array<wref<JournalOnscreen>>;
  let i: Int32;
  let j: Int32;
  context.stateFilter.inactive = true;
  context.stateFilter.active = true;
  context.stateFilter.succeeded = true;
  context.stateFilter.failed = true;
  journal.GetOnscreens(context, groups);
  i = 0;
  while i < ArraySize(groups) {
    currentGroup = groups[i];
    shards = currentGroup.GetEntries();
    j = 0;
    while j < ArraySize(shards) {
      currentShard = shards[j];
      // if equals then return shard read state
      if Equals(currentShard, record) {
        // return journal.IsEntryVisited(currentShard);
        return true;
      };
      j += 1;
    };
    i += 1;
  };
  return false;
}

// Copy-pasted from LootingController
@addMethod(ShardCaseContainer)
private final func GetShardData(itemTDBID: TweakDBID) -> wref<JournalOnscreen> {
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(itemTDBID);
  let isShard: Bool;
  let journalPath: String;
  if !IsDefined(itemRecord) {
    return null;
  };
  isShard = itemRecord.TagsContains(n"Shard");
  if isShard {
    journalPath = TweakDBInterface.GetString(itemRecord.ItemSecondaryAction().GetID() + t".journalEntry", "");
    return GameInstance.GetJournalManager(this.GetGame()).GetEntryByString(journalPath, "gameJournalOnscreen") as JournalOnscreen;
  };
  return null;
}

// Check for empty shard case
@wrapMethod(gameLootContainerBase)
private final func EvaluateLootQuality() -> Bool {
  let wrapped: Bool = wrappedMethod();
  let container: ref<ShardCaseContainer>;
  let ts: ref<TransactionSystem>;
  let itemsToCheck: array<wref<gameItemData>>;

  if this.IsA(n"ShardCaseContainer") {
    container = this as ShardCaseContainer;
    ts = GameInstance.GetTransactionSystem(this.GetGame());
    if ts.GetItemList(this, itemsToCheck) {
      if Equals(ArraySize(itemsToCheck), 0) {
        container.DestroyShard();
      };
    };
  };

  return wrapped;
}

// Check for shard state when spawned
@addMethod(ShardCaseContainer)
protected cb func OnItemAddedEvent(evt: ref<ItemAddedEvent>) -> Bool {
  super.OnItemAddedEvent(evt);

  if this.m_hasQuestItems || this.HasTag(n"Quest") {
    return true;
  }

  let shardData: wref<JournalOnscreen> = this.GetShardData(ItemID.GetTDBID(evt.itemID));
  let alreadyRead: Bool = false;

  if IsDefined(shardData) {
    alreadyRead = this.IsShardReadOrTaken(shardData);
  };

  // destroy entity if shard was read
  if alreadyRead {
    this.DestroyShard();
  };
}

// Hide shard case on read/take
@wrapMethod(ShardCaseContainer)
protected cb func OnInteraction(choiceEvent: ref<InteractionChoiceEvent>) -> Bool {
  wrappedMethod(choiceEvent);
  this.DestroyShard();
}
