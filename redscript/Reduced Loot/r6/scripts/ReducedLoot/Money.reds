module ReducedLoot

public func ReducedLootIsMoneyPlacement(slot: ref<gameLootSlot>, path: ResRef) -> Bool {
  let table: ref<LootTable_Record>;
  let entry: wref<LootItem_Record>;
  if Equals(path, r"base\\gameplay\\loot\\tokens\\misc\\money_token.ent") && Equals(slot.GetClassName(), n"gameLootSlot") && ArraySize(slot.lootTables) == 1 && Equals(slot.lootTables[0], t"Items.MoneyLootTable") && (!TDBID.IsValid(slot.contentAssignment) || Equals(slot.contentAssignment, t"DeviceContentAssignment.sts_hey_rey_02")) {
    table = TweakDBInterface.GetLootTableRecord(slot.lootTables[0]);
    if IsDefined(table) && table.GetLootItemsCount() == 1 && table.GetQueriesCount() == 0 && table.GetLootTableInclusionsCount() == 0 {
      entry = table.GetLootItemsItem(0);
      if IsDefined(entry) && ReducedLootPolicy.Category(entry.ItemID()) == 0 { return true; };
    };
  };
  return false;
}
