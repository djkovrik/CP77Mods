import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import VirtualAtelier.UI.AtelierStoresListController
import VendorPreview.Utils.AtelierDebug

@addMethod(WebPage)
private func PopulateAtelierView() {
  let root: ref<inkCompoundWidget> = this.GetWidget(n"page/linkPanel/panel") as inkCompoundWidget;
  root.RemoveAllChildren();
  this.SpawnFromExternal(root, r"base\\gameplay\\gui\\virtual_atelier.inkwidget", n"AtelierStores:VirtualAtelier.UI.AtelierStoresListController");
}
