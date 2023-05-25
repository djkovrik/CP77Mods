module VirtualAtelier.UI

public class VirtualStoreDataView extends BackpackDataView {

  private let searchQuery: String;
  
  public func SetSearchQuery(query: String) -> Void {
    this.searchQuery = query;
  }

  public func UpdateView() -> Void {
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }

  public func DerivedFilterItem(data: ref<IScriptable>) -> DerivedFilterResult {
    let default: DerivedFilterResult = this.DefaultSorting(data);
    let data: ref<VendorInventoryItemData> = data as VendorInventoryItemData;

    if !IsDefined(data) {
      return default;
    };

    let query: String = StrLower(this.searchQuery);
    let itemName: String = StrLower(GetLocalizedText(InventoryItemData.GetName(data.ItemData)));

    if !StrContains(itemName, query) && NotEquals(query, "") {
      return DerivedFilterResult.False;
    };

    return default;
  }

  protected func PreSortingInjection(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {
    return builder.QuestItem();
  }

  private func DefaultSorting(data: ref<IScriptable>) -> DerivedFilterResult {
    let wrappedData: ref<VendorUIInventoryItemData> = data as VendorUIInventoryItemData;
    if !IsDefined(wrappedData) {
      return DerivedFilterResult.Pass;
    };
    if Equals(this.m_itemFilterType, ItemFilterCategory.Buyback) {
      return wrappedData.IsBuybackStack ? DerivedFilterResult.True : DerivedFilterResult.False;
    };
    if Equals(this.m_itemFilterType, ItemFilterCategory.NewWardrobeAppearances) {
      return wrappedData.IsNotInWardrobe ? DerivedFilterResult.True : DerivedFilterResult.False;
    };
    return wrappedData.IsBuybackStack ? DerivedFilterResult.False : DerivedFilterResult.Pass;
  }
}
