import VirtualAtelier.UI.VirtualStoreController
import VirtualAtelier.Logs.AtelierLog

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInitialize() -> Bool {
  let root: ref<inkCompoundWidget>;
  if this.GetIsVirtual() {
    root = this.GetRootCompoundWidget();
    root.RemoveAllChildren();
    this.SpawnFromExternal(
      root, 
      r"base\\gameplay\\gui\\virtual_atelier.inkwidget", 
      n"VirtualStore:VirtualAtelier.UI.VirtualStoreController"
    );
  } else {
    wrappedMethod();
  };
}
