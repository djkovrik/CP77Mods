@addField(FullscreenVendorGameController)
let m_lastStashFilter: ItemFilterCategory = ItemFilterCategory.AllItems;

@addField(FullscreenVendorGameController)
let m_currentScrollPos: Float;

@wrapMethod(FullscreenVendorGameController)
private final func HandleStorageSlotClick(evt: ref<ItemDisplayClickEvent>) -> Void {
  wrappedMethod(evt);

  let selectedItem: wref<UIInventoryItem> = evt.uiInventoryItem;
  if evt.actionName.IsAction(n"click") && IsDefined(selectedItem) && this.NotGrenadeOrHealingItem(selectedItem) {
    if NotEquals(this.m_lastStashFilter, ItemFilterCategory.AllItems) {
      this.m_currentScrollPos = (inkWidgetRef.GetController(this.m_vendorInventoryGridScroll) as inkScrollController).GetScrollPosition();
    };
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnVendorFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  wrappedMethod(controller, selectedIndex);
  let filter: ItemFilterCategory = this.m_vendorFilterManager.GetAt(selectedIndex);
  if !IsDefined(this.m_vendorUserData) && IsDefined(this.m_storageUserData) && NotEquals(filter, ItemFilterCategory.AllItems) && NotEquals(filter, ItemFilterCategory.Invalid)  {
    this.m_lastStashFilter = filter;
  };
}

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
  let filtersList: array<Int32> = this.m_vendorFilterManager.GetIntFiltersList();
  this.SetFilters(this.m_vendorFiltersContainer, filtersList, n"OnVendorFilterChange");
  this.m_vendorItemsDataView.EnableSorting();
  this.m_vendorItemsDataView.SetFilterType(targetFilter);
  this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
  this.m_vendorItemsDataView.DisableSorting();
  this.ToggleFilter(this.m_vendorFiltersContainer, EnumInt(targetFilter));

  if NotEquals(this.m_lastStashFilter, ItemFilterCategory.AllItems) {
    (inkWidgetRef.GetController(this.m_vendorInventoryGridScroll) as inkScrollController).SetScrollPosition(this.m_currentScrollPos);
    this.m_currentScrollPos = 0.0;
  };
}
