import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager
import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import VendorPreview.Utils.AtelierDebug

class VirtualStockItem {
  public let itemID: ItemID;
  public let itemTDBID: TweakDBID;
  public let price: Float;
  public let quality: CName;
  public let quantity: Int32;
  public let itemData: ref<gameItemData>;
}

public class StoreGoods {
  let key: Uint64;
  let item: String;
  let stores: array<String>;

  public func StoreShopIfNotContains(store: String) {
    if !ArrayContains(this.stores, store) {
      ArrayPush(this.stores, store);
    };
  };
}

public class VirtualShop {
  let storeID: CName;
  let storeName: String;
  let items: array<String>;
  let qualities: array<String>;
  let quantities: array<Int32>;
  let prices: array<Int32>;
  let atlasResource: ResRef;
  let texturePart: CName;
  let bookmarked: Bool;
}

public class VirtualShopRegistration extends Event {
  let system: wref<VirtualAtelierStoresSystem>;

  public func SetSystemInstance(system: ref<VirtualAtelierStoresSystem>) -> Void {
    this.system = system;
  }

  public func AddStore(storeID: CName, storeName: String, items: array<String>, prices: array<Int32>, atlasResource: ResRef, texturePart: CName, opt qualities: array<String>, opt quantities: array<Int32>) -> Void {
    let stores: array<ref<VirtualShop>> = this.system.GetStores();
    let store: ref<VirtualShop> = new VirtualShop();
    store.storeID = storeID;
    store.storeName = storeName;
    store.items = items;
    store.prices = prices;
    store.atlasResource = atlasResource;
    store.texturePart = texturePart;
    store.qualities = qualities;
    store.quantities = quantities;
    store.bookmarked = this.system.IsBookmarked(storeID);
    ArrayPush(stores, store);

    this.system.SetStores(stores);
    AtelierDebug(s"Store initialized: \(storeName)");
  }
}

public class PreviewInventoryItemPreviewData extends InventoryItemPreviewData {
  let displayContext: ItemDisplayContext;
}

public class VendorInventoryEquipStateChanged extends Event {
  public let system: wref<VirtualAtelierPreviewManager>;
}
