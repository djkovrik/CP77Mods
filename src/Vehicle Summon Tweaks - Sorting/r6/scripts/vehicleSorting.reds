@replaceMethod(VehiclesManagerDataView)
public func SortItem(lhs: ref<IScriptable>, rhs: ref<IScriptable>) -> Bool {
  let lhsData: ref<VehicleListItemData> = lhs as VehicleListItemData;
  let rhsData: ref<VehicleListItemData> = rhs as VehicleListItemData;
  let lhsName: String = GetLocalizedTextByKey(lhsData.m_displayName);
  let rhsName: String = GetLocalizedTextByKey(rhsData.m_displayName);
  if lhsData.m_data.uiFavoriteIndex == rhsData.m_data.uiFavoriteIndex {
    return UnicodeStringLessThan(lhsName, rhsName);
  };
  if lhsData.m_data.uiFavoriteIndex == -1 {
    return false;
  };
  if rhsData.m_data.uiFavoriteIndex == -1 {
    return true;
  };
  return UnicodeStringLessThan(lhsName, rhsName);
}
