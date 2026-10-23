import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Systems.VirtualAtelierStoresManager
import VirtualAtelier.Logs.AtelierDebug

public class VirtualShopRegistration extends Event {
  let system: wref<VirtualAtelierStoresManager>;

  public func SetSystemInstance(system: ref<VirtualAtelierStoresManager>) -> Void {
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
    store.isBookmarked = this.system.IsBookmarked(storeID);
    ArrayPush(stores, store);

    this.system.SetStores(stores);
    AtelierDebug(s"Store initialized: \(storeName)");
  }
}

public enum VirtualStoreCategory {
  AllItems = 0,
  Clothes = 1,
  Weapons = 2,
  Cyberware = 3,
  Consumables = 4,
  Other = 5,
}

public class VirtualShop {
  public let storeID: CName;
  public let storeName: String;
  public let items: array<String>;
  public let qualities: array<String>;
  public let quantities: array<Int32>;
  public let prices: array<Int32>;
  public let atlasResource: ResRef;
  public let texturePart: CName;
  public let isBookmarked: Bool;
  public let isNew: Bool;
  public let categories: array<VirtualStoreCategory>;
}

class VirtualStockItem {
  public let stockKey: Uint64;
  public let itemID: ItemID;
  public let itemTDBID: TweakDBID;
  public let sourceStoreID: CName;
  public let sourceStoreName: String;
  public let sourceStoreCounter: Int32;
  public let price: Float;
  public let weight: Float;
  public let quality: CName;
  public let quantity: Int32;
  public let name: String;
  public let searchName: String;
  public let equipmentArea: gamedataEquipmentArea;
  public let itemType: gamedataItemType;
  public let itemCategory: gamedataItemCategory;
  public let isClothing: Bool;
  public let isRangedWeapon: Bool;
  public let isMeleeWeapon: Bool;
  public let isCyberware: Bool;
  public let isConsumable: Bool;
  public let isGrenade: Bool;
  public let isAttachment: Bool;
  public let isProgram: Bool;
  public let isQuest: Bool;
  public let isJunk: Bool;
  public let isDLCAdded: Bool;
  public let isOwnable: Bool;
  public let notInWardrobe: Bool;
  public let qualityRank: Int32;
  public let itemTypeRank: Int32;
}

class VirtualCartItem {
  public let stockItem: ref<VirtualStockItem>;
  public let purchaseAmount: Int32;
}

public class StoreGoods {
  public let key: Uint64;
  public let item: String;
  public let stores: array<String>;

  public func StoreShopIfNotContains(store: String) {
    if !ArrayContains(this.stores, store) {
      ArrayPush(this.stores, store);
    };
  };
}

public class PreviewInventoryItemPreviewData extends InventoryItemPreviewData {
  public let displayContext: ItemDisplayContext;
}

public class AtelierStoresTemplateClassifier extends inkVirtualItemTemplateClassifier {}

public class AtelierRefreshStockEvent extends Event {}

public class AtelierCloseVirtualStore extends Event {}

public class VirtualStoreCategorySelectedEvent extends Event {
  public let category: VirtualStoreCategory;

  public final static func Create(category: VirtualStoreCategory) -> ref<VirtualStoreCategorySelectedEvent> {
    let evt: ref<VirtualStoreCategorySelectedEvent> = new VirtualStoreCategorySelectedEvent();
    evt.category = category;
    return evt;
  }
}

public class StoreItemCountWrapper {
  public persistent let storeID: CName;
  public persistent let itemCount: Int32;
}

public class VirtualStoreHeaderWrapper {
  public let label: String;
  public let counter: Int32;
}

public class VirtualStoreSearchCriteria {
  public let query: String;
  public let rangedWeapons: Bool;
  public let meleeWeapons: Bool;
  public let clothes: Bool;
  public let consumables: Bool;
  public let grenades: Bool;
  public let attachments: Bool;
  public let programs: Bool;
  public let cyberware: Bool;
  public let junk: Bool;
  public let face: Bool;
  public let feet: Bool;
  public let head: Bool;
  public let legs: Bool;
  public let innerChest: Bool;
  public let outerChest: Bool;
  public let outfit: Bool;
  public let newWardrobe: Bool;
}

public class VirtualStoreSearchResult {
  public let store: ref<VirtualShop>;
  public let itemIndexes: array<Int32>;
  public let counter: Int32;
}

public class inkBorderVA extends inkBorder {}

public class SearchComponentClearFocusEvent extends Event {}
