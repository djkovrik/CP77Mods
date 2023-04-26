module VirtualAtelier.UI

public class AtelierStoresDataView extends ScriptableDataView {

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
}
