/* Sort shards list by new flag + alphabeticaly inside each category */
@replaceMethod(ShardsNestedListDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData: ref<GenericCodexEntryData>;
  let rightData: ref<GenericCodexEntryData>;
  leftData = (left.m_data as GenericCodexEntryData);
  rightData = (right.m_data as GenericCodexEntryData);
  if NotEquals(leftData, null) && NotEquals(rightData, null) {
    compareBuilder
    .BoolTrue(leftData.m_isNew, rightData.m_isNew)
    .UnicodeStringAsc(GetLocalizedText(leftData.m_title), GetLocalizedText(rightData.m_title));
  };
}