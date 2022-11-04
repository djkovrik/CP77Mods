@wrapMethod(ItemTooltipBottomModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  if (data.isVirtualItem) {
    inkTextRef.SetText(this.m_weightText, FloatToStringPrec(data.weight, 1));
    inkTextRef.SetText(this.m_priceText, IntToString(RoundF(data.price)));
  } else {
    wrappedMethod(data);
  }  
}

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
    result.quantity = InventoryItemData.GetQuantity(tooltipData.virtualInventoryItemData);
    result.price = InventoryItemData.GetBuyPrice(tooltipData.virtualInventoryItemData);
    result.quality = UIItemsHelper.QualityNameToEnum(tooltipData.virtualInventoryItemData.Quality);
  }

  return result;
}
