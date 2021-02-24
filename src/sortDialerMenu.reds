/* Fixes alphabetical sorting for dialer contacts list */
@replaceMethod(DialerContactDataView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
  let leftData: ref<ContactData>;
  let rightData: ref<ContactData>;
  leftData = (left as ContactData);
  rightData = (right as ContactData);
  this.m_compareBuilder.Reset();

  return this.m_compareBuilder
    .BoolTrue(ArraySize(leftData.unreadMessages) > 0, ArraySize(rightData.unreadMessages) > 0)
    .UnicodeStringAsc(GetLocalizedText(leftData.localizedName), GetLocalizedText(rightData.localizedName))
    .GetBool();
}