module ReducedLoot

public func ReducedLootProtectsRecord(record: wref<Item_Record>) -> Bool {
  return record.TagsContains(n"Quest")
    || record.TagsContains(n"Iconic")
    || record.TagsContains(n"UnequipBlocked")
    || record.TagsContains(n"PermanentFood")
    || record.TagsContains(n"Readable")
    || record.TagsContains(n"Shard")
    || record.TagsContains(n"Keycard")
    || record.StatModifiersContains(TweakDBInterface.GetStatModifierRecord(t"Quality.IconicItem"))
    || Equals(record.ItemCategory().Type(), gamedataItemCategory.Weapon);
}
