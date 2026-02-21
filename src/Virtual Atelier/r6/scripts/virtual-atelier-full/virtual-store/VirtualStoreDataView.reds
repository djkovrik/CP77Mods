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
    let data: ref<VendorInventoryItemData> = data as VendorInventoryItemData;

    if !IsDefined(data) {
      return DerivedFilterResult.Pass;
    };

    let query: String = "";
    let itemName: String = "";

    if NotEquals(this.searchQuery, "") {
      query = UTF8StrLower(this.searchQuery);
      itemName = UTF8StrLower(GetLocalizedText(InventoryItemData.GetName(data.ItemData)));
    };

    if !StrContains(itemName, query) && NotEquals(query, "") {
      return DerivedFilterResult.False;
    };

    if Equals(this.m_itemFilterType, ItemFilterCategory.NewWardrobeAppearances) {
      return data.NotInWardrobe ? DerivedFilterResult.True : DerivedFilterResult.False;
    };

    return DerivedFilterResult.Pass;
  }

  public func PreSortingInjection(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {
    return builder.QuestItem();
  }
}
