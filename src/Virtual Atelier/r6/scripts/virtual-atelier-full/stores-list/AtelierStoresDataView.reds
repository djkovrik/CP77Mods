module VirtualAtelier.UI
import VirtualAtelier.Logs.*

public class AtelierStoresDataView extends ScriptableDataView {

  private let activeCategory: VirtualStoreCategory;

  public func SetActiveCategory(category: VirtualStoreCategory) -> Void {
    this.activeCategory = category;
  }

  public func UpdateView() {
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftEntry: ref<VirtualShop> = left as VirtualShop;
    let rightEntry: ref<VirtualShop> = right as VirtualShop;

    if NotEquals(leftEntry.isBookmarked, rightEntry.isBookmarked) {
      return leftEntry.isBookmarked;
    };

    if NotEquals(leftEntry.isNew, rightEntry.isNew) {
      return leftEntry.isNew;
    };
    
    return StrCmp(leftEntry.storeName, rightEntry.storeName) < 0;
  }

  private func FilterItem(data: ref<IScriptable>) -> Bool {
    let shop: ref<VirtualShop> = data as VirtualShop;
    if !IsDefined(shop) || Equals(this.activeCategory, VirtualStoreCategory.AllItems) {
      return true;
    };

    return ArrayContains(shop.categories, this.activeCategory);
  }
}
