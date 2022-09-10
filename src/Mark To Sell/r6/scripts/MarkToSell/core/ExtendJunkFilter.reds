@wrapMethod(ItemCategoryFliter)
public final static func IsOfCategoryType(filter: ItemFilterCategory, data: wref<gameItemData>) -> Bool {
  if !IsDefined(data) {
    return false;
  };

  if Equals(filter, ItemFilterCategory.Junk) {
    return data.HasTag(n"Junk") || data.modMarkedForSale;
  } else {
    return wrappedMethod(filter, data);
  };
}

@wrapMethod(UIInventoryItem)
public final func GetFilterCategory() -> ItemFilterCategory {
  let data: ref<gameItemData> = this.GetItemData();
  if data.modMarkedForSale {
    return ItemFilterCategory.Junk;
  };
  return wrappedMethod();
}
