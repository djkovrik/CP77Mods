/* Quests menu sorting */
@replaceMethod(QuestListVirtualNestedDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData: ref<QuestListItemData>;
  let rightData: ref<QuestListItemData>;
  leftData = (left.m_data as QuestListItemData);
  rightData = (right.m_data as QuestListItemData);
  if NotEquals(leftData, null) && NotEquals(rightData, null) {
    if leftData.m_isResolved && rightData.m_isResolved {
      /* Sort completed by timestamp */
      compareBuilder
        .GameTimeDesc(leftData.m_timestamp, rightData.m_timestamp);
    } else {
      /* Sort active by level + alphabeticaly inside each level group */
      compareBuilder
        .IntAsc(leftData.m_recommendedLevel, rightData.m_recommendedLevel)
        .UnicodeStringAsc(GetQuestTitle(leftData), GetQuestTitle(rightData));
    };
  };
}

func GetQuestTitle(data: ref<QuestListItemData>) -> String {
  return GetLocalizedText(data.m_questData.GetTitle(data.m_journalManager));
}
