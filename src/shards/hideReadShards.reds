@addMethod(ShardCaseContainer)
protected cb func OnItemAddedEvent(evt: ref<ItemAddedEvent>) -> Bool {
  super.OnItemAddedEvent(evt);

  if this.m_hasQuestItems || this.HasTag(n"Quest") {
    return true;
  }

  let shardData: wref<JournalOnscreen> = this.GetShardData(ItemID.GetTDBID(evt.itemID));
  let alreadyRead: Bool = false;

  if IsDefined(shardData) {
    alreadyRead = this.IsShardRead(shardData);
  };

  // Log("Title: " + GetLocalizedText(shardData.GetTitle()) + " was read: " + BoolToString(alreadyRead));

  // destroy entity if shard was read
  if alreadyRead {
    EntityGameInterface.Destroy(this.GetEntity());
  };
}

@addMethod(ShardCaseContainer)
private func IsShardRead(record: wref<JournalOnscreen>) -> Bool {
  let journal: ref<JournalManager> = GameInstance.GetJournalManager(this.GetGame());
  let context: JournalRequestContext;
  let currentGroup: wref<JournalOnscreensStructuredGroup>;
  let currentShard: wref<JournalOnscreen>;
  let groups: array<ref<JournalOnscreensStructuredGroup>>;
  let shards: array<wref<JournalOnscreen>>;
  let i: Int32;
  let j: Int32;
  let shardData: ref<ShardEntryData>;
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
        return journal.IsEntryVisited(currentShard);
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
