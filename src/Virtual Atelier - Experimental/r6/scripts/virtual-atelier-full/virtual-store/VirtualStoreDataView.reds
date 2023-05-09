module VirtualAtelier.UI

public class VirtualStoreDataView extends BackpackDataView {

  protected let m_isVendorGrid: Bool;
  protected let m_openTime: GameTime;
  protected let m_searchQuery: String;
  
  public func SetSearchQuery(query: String) -> Void {
    this.m_searchQuery = query;
  }

  public final func SetVendorGrid(value: Bool) -> Void {
    this.m_isVendorGrid = value;
  }

  public final func SetOpenTime(time: GameTime) -> Void {
    this.m_openTime = time;
  }

  protected func PreSortingInjection(builder: ref<ItemCompareBuilder>) -> ref<ItemCompareBuilder> {
    return builder.QuestItem();
  }

  public func DerivedFilterItem(data: ref<IScriptable>) -> DerivedFilterResult {
    let default: DerivedFilterResult = this.DefaultSorting(data);
    let data: ref<VendorInventoryItemData> = data as VendorInventoryItemData;

    if !IsDefined(data) {
      return default;
    };

    let query: String = StrLower(this.m_searchQuery);
    let itemName: String = StrLower(GetLocalizedText(InventoryItemData.GetName(data.ItemData)));

    if !StrContains(itemName, query) && NotEquals(query, "") {
      return DerivedFilterResult.False;
    };

    return default;
  }

  private func DefaultSorting(data: ref<IScriptable>) -> DerivedFilterResult {
    let m_wrappedData: ref<VendorUIInventoryItemData> = data as VendorUIInventoryItemData;
    if !IsDefined(m_wrappedData) {
      return DerivedFilterResult.Pass;
    };
    if Equals(this.m_itemFilterType, ItemFilterCategory.Buyback) {
      return m_wrappedData.IsBuybackStack ? DerivedFilterResult.True : DerivedFilterResult.False;
    };
    if Equals(this.m_itemFilterType, ItemFilterCategory.NewWardrobeAppearances) {
      return m_wrappedData.IsNotInWardrobe ? DerivedFilterResult.True : DerivedFilterResult.False;
    };
    return m_wrappedData.IsBuybackStack ? DerivedFilterResult.False : DerivedFilterResult.Pass;
  }
}
