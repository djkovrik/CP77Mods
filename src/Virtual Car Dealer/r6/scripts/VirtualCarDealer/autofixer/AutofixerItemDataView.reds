module CarDealer
import CarDealer.Classes.AutofixerItemData

public class AutofixerItemDataView extends ScriptableDataView {
  public func UpdateView() {
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftEntry = left as AutofixerItemData;
    let rightEntry = right as AutofixerItemData;

    return StrCmp(leftEntry.title, rightEntry.title) < 0;
  }
}
