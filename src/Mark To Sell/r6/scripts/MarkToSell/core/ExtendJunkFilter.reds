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

@wrapMethod(UIInventoryItem)
public final func IsJunk() -> Bool {
  let data: ref<gameItemData> = this.GetItemData();
  return wrappedMethod() || data.modMarkedForSale;
}

@wrapMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  let wrapped: Bool = wrappedMethod(itemData);
  let modded: Bool = false;
  if IsDefined(itemData) {
    modded = itemData.modMarkedForSale;
  };
  return wrapped || modded;
}
