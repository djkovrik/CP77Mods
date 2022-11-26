@addField(gameItemData)
public let supportedSlots: array<TweakDBID>;

@addField(VendorItemVirtualController)
public let customHeaderContainer: ref<inkWidget>;

@addField(VendorItemVirtualController)
public let customHeaderPrimary: ref<inkText>;

@addField(VendorItemVirtualController)
public let customHeaderSecondary: ref<inkText>;

@addField(WrappedInventoryItemData)
public let customHeaderPrimary: String = "";

@addField(WrappedInventoryItemData)
public let customHeaderSecondary: String = "";

@addField(UIInventoryItem)
public let targetPlacementSlot: TweakDBID;

@addMethod(WrappedInventoryItemData)
public func IsCustomHeader() -> Bool {
  return NotEquals(this.customHeaderPrimary, "");
}

public class CustomItemDisplayTemplateClassifier extends inkVirtualItemTemplateClassifier {

  public func ClassifyItem(data: Variant) -> Uint32 {
    let wrappedData: ref<WrappedInventoryItemData> = FromVariant<ref<IScriptable>>(data) as WrappedInventoryItemData;
    if !IsDefined(wrappedData) {
      return 0u;
    };
    if wrappedData.IsCustomHeader() {
      return 1u;
    };

    return 0u;
  }
}

@addMethod(InventoryDataManagerV2)
public func GetPlayerClothingItems() -> array<ref<gameItemData>> {
  let result: array<ref<gameItemData>>;
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let itemRecord: ref<Item_Record>;
  let data: ref<gameItemData>;
  let itemId: ItemID;
  let limit: Int32 = ArraySize(unfilteredItems);
  let category: gamedataItemCategory;
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    itemId = data.GetID();
    category = RPGManager.GetItemCategory(itemId);
    if Equals(category, gamedataItemCategory.Clothing) {
      itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemId));
      data.supportedSlots = TweakDBInterface.GetForeignKeyArray(itemRecord.GetID() + t".placementSlots");
      ArrayPush(result, data);
    };
    i += 1;
  };

  return result;
}
