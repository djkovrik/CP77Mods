@wrapMethod(ItemTooltipBottomModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  if (data.isVirtualItem) {
    inkTextRef.SetText(this.m_priceText, IntToString(RoundF(data.price)));
  } else {
    wrappedMethod(data);
  }  
}

// @wrapMethod(ItemTooltipIconModule)
// public func Update(data: ref<MinimalItemTooltipData>) -> Void {
//    if data.isVirtualItem {
//      let craftingResult: wref<CraftingResult_Record>;
//      let itemRecord: wref<Item_Record>;
//      let recipeRecord: wref<ItemRecipe_Record>;

//      inkWidgetRef.SetVisible(this.m_iconicLines, data.isIconic);

//      if IsDefined(data.itemData) && data.itemData.HasTag(n"Recipe") {
//        recipeRecord = TweakDBInterface.GetItemRecipeRecord(data.itemTweakID);
//        craftingResult = recipeRecord.CraftingResult();
      
//        if IsDefined(craftingResult) {
//         itemRecord = craftingResult.Item();
//        };
//      };
    
//     inkWidgetRef.SetScale(this.m_icon, this.GetIconScale(data, itemRecord.EquipArea().Type()));
//     // TODO: Update tooltip images here from `data` [add whatever needed in MinimalItemTooltipData > FromInventoryTooltipData]
//     // inkImageRef.SetAtlasResource(this.m_icon, r"");
//     // inkImageRef.SetTexturePart(this.m_icon, n"");
//    } else {
//        wrappedMethod(data);
//    }
// }

@addField(MinimalItemTooltipData)
let isVirtualItem: Bool;

@addField(InventoryTooltipData)
let isVirtualItem: Bool;

@addField(InventoryTooltipData)
let virtualInventoryItemData: InventoryItemData;

@wrapMethod(MinimalItemTooltipData)
public final static func FromInventoryTooltipData(tooltipData: ref<InventoryTooltipData>) -> ref<MinimalItemTooltipData> {
  let result = wrappedMethod(tooltipData);

  if (tooltipData.isVirtualItem) {
    result.isVirtualItem = true;

    // Add more custom stuff here: description, quality, name, icon, whatever
    result.price = InventoryItemData.GetBuyPrice(tooltipData.virtualInventoryItemData);
    result.quality = UIItemsHelper.QualityNameToEnum(tooltipData.virtualInventoryItemData.Quality);
    // result.iconPath = "UIIcon.clothing_player_feet_item_s1_formal_02_basic_02__Female_";
  }

  return result;
}

// To change specific item tooltip stuff -> ItemTooltipBottomModule/ItemTooltipTopModule/...