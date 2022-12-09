@addField(VendorItemVirtualController)
public let customHeaderContainer: ref<inkWidget>;

@addField(VendorItemVirtualController)
public let customHeaderPrimary: ref<inkText>;

@addField(VendorItemVirtualController)
public let customHeaderSecondary: ref<inkText>;

@addMethod(WrappedInventoryItemData)
public func IsSlotHeader() -> Bool {
  return TDBID.IsValid(this.ItemData.SlotID) && NotEquals(this.ItemData.CategoryName, "");
}

@addMethod(InventoryDataManagerV2)
public func GetPlayerClothingItems() -> array<wref<gameItemData>> {
  let result: array<wref<gameItemData>>;
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let data: wref<gameItemData>;
  let itemId: ItemID;
  let limit: Int32 = ArraySize(unfilteredItems);
  let category: gamedataItemCategory;
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    itemId = data.GetID();
    category = RPGManager.GetItemCategory(itemId);
    if Equals(category, gamedataItemCategory.Clothing) {
      ArrayPush(result, data);
    };
    i += 1;
  };

  return result;
}

public class OutfitSlotHoverEvent extends Event {}
