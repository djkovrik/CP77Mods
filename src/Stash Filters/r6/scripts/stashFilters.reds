@addField(FullscreenVendorGameController)
public let m_lastStashFilter: ItemFilterCategory = ItemFilterCategory.AllItems;

@wrapMethod(FullscreenVendorGameController)
private final func PopulateVendorInventory() -> Void {
  wrappedMethod();

  let item: ref<UIInventoryItem>;
  let j: Int32 = 0;

  if IsDefined(this.m_vendorUserData) || !IsDefined(this.m_storageUserData) {
    return ;
  };

  this.m_vendorFilterManager.Clear();
  this.m_vendorFilterManager.AddFilter(ItemFilterCategory.AllItems);

  while j < ArraySize(this.m_vendorUIInventoryItems) {
    item = this.m_vendorUIInventoryItems[j];
    this.m_vendorFilterManager.AddItem(ItemCategoryFliter.GetItemCategoryType(item.GetItemData()));
    j += 1;
  };

  let targetFilter: ItemFilterCategory;
  if NotEquals(this.m_lastStashFilter, ItemFilterCategory.AllItems) {
    targetFilter = this.m_lastStashFilter;
  } else {
    targetFilter = this.m_lastVendorFilter;
  };

  this.m_vendorFilterManager.SortFiltersList();
  this.m_vendorFilterManager.InsertFilter(0, ItemFilterCategory.AllItems);
  this.SetFilters(this.m_vendorFiltersContainer, this.m_vendorFilterManager.GetIntFiltersList(), n"OnVendorFilterChange");
  this.m_vendorItemsDataView.EnableSorting();
  this.m_vendorItemsDataView.SetFilterType(targetFilter);
  this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
  this.m_vendorItemsDataView.DisableSorting();
  this.ToggleFilter(this.m_vendorFiltersContainer, EnumInt(targetFilter));
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  wrappedMethod(controller, selectedIndex);
  let filter: ItemFilterCategory = this.m_vendorFilterManager.GetAt(selectedIndex);
  if !IsDefined(this.m_vendorUserData) && IsDefined(this.m_storageUserData) && NotEquals(filter, ItemFilterCategory.AllItems) && NotEquals(filter, ItemFilterCategory.Invalid)  {
    LogChannel(n"DEBUG", s"save filter to \(filter)");
    this.m_lastStashFilter = filter;
  };
}
