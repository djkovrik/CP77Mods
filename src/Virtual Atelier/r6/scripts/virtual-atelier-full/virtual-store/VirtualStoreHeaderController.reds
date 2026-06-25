module VirtualAtelier.UI

public class VirtualStoreHeaderController extends inkVirtualCompoundItemController {

  public let data: ref<VirtualStoreHeaderWrapper>;

  protected cb func OnInitialize() -> Bool {}

  public final func OnDataChanged(value: Variant) -> Void {
    this.data = FromVariant<ref<IScriptable>>(value) as VirtualStoreHeaderWrapper;
    this.UpdateView();
  }

  private final func UpdateView() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let title: ref<inkText> = root.GetWidgetByPathName(n"info/storeName") as inkText;
    let counter: ref<inkText> = root.GetWidgetByPathName(n"info/storeItems") as inkText;

    if IsDefined(title) {
      title.SetText(this.data.label);
    };

    if IsDefined(counter) {
      counter.SetText(s"\(GetLocalizedTextByKey(n"VA-Search-Items-Count")) \(this.data.counter)");
    };
  }
}
