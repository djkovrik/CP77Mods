module VirtualAtelier.UI
import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import VendorPreview.Utils.AtelierDebug
import VendorPreview.Utils.AtelierLog

public class AtelierStoresListController extends inkGameController {
  private let system: wref<VirtualAtelierStoresSystem>;
  private let stores: array<ref<VirtualShop>>;
  private let storesList: ref<inkVirtualGridController>;
  private let storesListScrollController: wref<inkScrollController>;
  private let storesDataSource: ref<ScriptableDataSource>;
  private let storesDataView: ref<AtelierStoresDataView>;
  private let storesTemplateClassifier: ref<AtelierStoresTemplateClassifier>;

  protected cb func OnInitialize() {
    this.system = VirtualAtelierStoresSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
    this.stores = this.system.GetStores();
    AtelierLog(s"Detected stores: \(ArraySize(this.stores))");
    
    this.storesList = this.GetChildWidgetByPath(n"scrollWrapper/scrollArea/StoresList").GetController() as inkVirtualGridController;
    this.storesListScrollController = this.GetChildWidgetByPath(n"scrollWrapper").GetControllerByType(n"inkScrollController") as inkScrollController;
    this.storesDataSource = new ScriptableDataSource();
    this.storesDataView = new AtelierStoresDataView();
    this.storesDataView.SetSource(this.storesDataSource);
    this.storesTemplateClassifier = new AtelierStoresTemplateClassifier();
    this.storesList.SetClassifier(this.storesTemplateClassifier);
    this.storesList.SetSource(this.storesDataView);

    this.PopulateDataSource();
  }

  protected cb func OnUninitialize() {
    
  }

  protected cb func OnAtelierStoreSoundEvent(evt: ref<AtelierStoreSoundEvent>) -> Bool {
    GameObject.PlaySoundEvent(this.GetPlayerControlledObject(), evt.name);
  }

  protected cb func OnAtelierStoreClickEvent(evt: ref<AtelierStoreClickEvent>) -> Bool {
    let virtualStore: ref<VirtualShop>;
    let i: Int32 = 0;
    let count: Int32 = ArraySize(this.stores);
    while i < count {
      if Equals(this.stores[i].storeID, evt.storeID) {
        virtualStore = this.stores[i];
        break;
      } else {
        i += 1;
      };
    };

    if !IsDefined(virtualStore) {
      AtelierLog(s"Could not find requested store instance: \(evt.storeID)");
      return false;
    };

    let player: ref<GameObject> = this.GetPlayerControlledObject();
    let vendorData: ref<VendorPanelData> = new VendorPanelData();
    vendorData.data.vendorId = "VirtualVendor";
    vendorData.data.entityID = player.GetEntityID();
    vendorData.data.isActive = true;
    vendorData.virtualStore = virtualStore;
    GameInstance.GetUISystem(player.GetGame()).RequestVendorMenu(vendorData);
    return true;
  }

  private func PopulateDataSource() -> Void {
    let items: array<ref<IScriptable>>;
    for store in this.stores {
      ArrayPush(items, store);
    };

    this.storesDataSource.Reset(items);
    this.storesDataView.UpdateView();
  }
}
