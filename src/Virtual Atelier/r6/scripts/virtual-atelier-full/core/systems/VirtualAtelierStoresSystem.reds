module VirtualAtelier.Systems
import VirtualAtelier.Logs.AtelierLog
import VirtualAtelier.Core.*

public class VirtualAtelierStoresManager extends ScriptableSystem {

  private let stores: array<ref<VirtualShop>>;
  private let categories: array<VirtualStoreCategory>;
  private let current: ref<VirtualShop>;
  private persistent let bookmarked: array<CName>;
  private persistent let prevStores: array<CName>;

  public static func GetInstance(gi: GameInstance) -> ref<VirtualAtelierStoresManager> {
    let system: ref<VirtualAtelierStoresManager> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VirtualAtelier.Systems.VirtualAtelierStoresManager") as VirtualAtelierStoresManager;
    return system;
  }

  public func GetStores() -> array<ref<VirtualShop>> {
    return this.stores;
  }

  public func SetStores(stores: array<ref<VirtualShop>>) -> Void {
    this.stores = stores;
  }

  public func SetCurrentStore(store: ref<VirtualShop>) -> Void {
    this.current = store;
  }

  public func GetCurrentStore() -> ref<VirtualShop> {
    return this.current;
  }

  public func AddBookmark(storeID: CName) -> Void {
    let current: array<CName> = this.bookmarked;
    ArrayPush(current, storeID);
    this.bookmarked = current;
    this.RefreshBookmarks();
  }

  public func RemoveBookmark(storeID: CName) -> Void {
    let current: array<CName> = this.bookmarked;
    ArrayRemove(current, storeID);
    this.bookmarked = current;
    this.RefreshBookmarks();
  }

  public func IsBookmarked(storeID: CName) -> Bool {
    return ArrayContains(this.bookmarked, storeID);
  }

  public func BuildStoresList() -> Void {
    ArrayClear(this.stores);

    let event: ref<VirtualShopRegistration> = new VirtualShopRegistration();
    event.SetSystemInstance(this);
    GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(event);
  }

  public func BuildCategories() -> Void {
    let firstItem: TweakDBID;
    let firstItemCategory: VirtualStoreCategory;
    let lastItemCategory: VirtualStoreCategory;
    let lastItem: TweakDBID;
    let lastIndex: Int32;
    AtelierLog("Building store categories list...");
    for currentStore in this.stores {
      lastIndex = ArraySize(currentStore.items) - 1;
      if lastIndex < 0 { lastIndex = 0; };
      firstItem = TDBID.Create(currentStore.items[0]);
      lastItem = TDBID.Create(currentStore.items[lastIndex]);
      firstItemCategory = this.GetItemCategory(firstItem);
      lastItemCategory = this.GetItemCategory(lastItem);
      let storeCategories: array<VirtualStoreCategory>;
      ArrayPush(storeCategories, firstItemCategory);
      ArrayPush(storeCategories, lastItemCategory);
      currentStore.categories = storeCategories;
      if !ArrayContains(this.categories, firstItemCategory) { ArrayPush(this.categories, firstItemCategory); }
      if !ArrayContains(this.categories, lastItemCategory) { ArrayPush(this.categories, lastItemCategory); }
      AtelierLog(s"- store \(currentStore.storeName) categories: \(firstItemCategory) + \(lastItemCategory)");
    };
  }

  public func GetCategories() -> array<VirtualStoreCategory> {
    let result: array<VirtualStoreCategory>;
    ArrayPush(result, VirtualStoreCategory.AllItems);
    if ArrayContains(this.categories, VirtualStoreCategory.Clothes) { ArrayPush(result, VirtualStoreCategory.Clothes); }
    if ArrayContains(this.categories, VirtualStoreCategory.Weapons) { ArrayPush(result, VirtualStoreCategory.Weapons); }
    if ArrayContains(this.categories, VirtualStoreCategory.Cyberware) { ArrayPush(result, VirtualStoreCategory.Cyberware); }
    if ArrayContains(this.categories, VirtualStoreCategory.Consumables) { ArrayPush(result, VirtualStoreCategory.Consumables); }
    if ArrayContains(this.categories, VirtualStoreCategory.Other) { ArrayPush(result, VirtualStoreCategory.Other); }
    return result;
  }

  public func RefreshNewLabels() -> Void {
    let current: array<ref<VirtualShop>> = this.stores;
    let refreshed: array<ref<VirtualShop>>;
    let previousIds: array<CName> = this.prevStores;
    let id: CName;
    for store in current {
      id = store.storeID;
      store.isNew = !ArrayContains(previousIds, id) && ArraySize(previousIds) > 0 ;
      ArrayPush(refreshed, store);
    };
    this.stores = refreshed;
    this.prevStores = this.GetStoresIds();
  }

  public func RefreshBookmarks() -> Void {
    let newStores: array<ref<VirtualShop>>;
    let newStore: ref<VirtualShop>;
    for store in this.stores {
      newStore = store;
      newStore.isBookmarked = this.IsBookmarked(store.storeID);
      ArrayPush(newStores, newStore);
    };

    this.stores = newStores;
  }

  // For case when bookmarked stores uninstalled
  public func RefreshPersistedBookmarks() -> Void {
    let storeIds: array<CName>;
    for store in this.stores {
      ArrayPush(storeIds, store.storeID);
    };

    let actuallyBookmarked: array<CName>;
    for bookmark in this.bookmarked {
      if ArrayContains(storeIds, bookmark) {
        ArrayPush(actuallyBookmarked, bookmark);
      } else {
        AtelierLog(s"Installed store not found, persisted bookmark removed: \(bookmark)");
      };
    };

    this.bookmarked = actuallyBookmarked;
  }

  private func GetStoresIds() -> array<CName> {
    let result: array<CName>;
    for store in this.stores {
      ArrayPush(result, store.storeID);
    };

    return result;
  }

  private func GetItemCategory(id: TweakDBID) -> VirtualStoreCategory {
    let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(id);
    let itemType: gamedataItemType = record.ItemType().Type();

    if UIInventoryItemsManager.IsItemTypeCloting(itemType) {
      return VirtualStoreCategory.Clothes;
    };

    if UIInventoryItemsManager.IsItemTypeMeleeWeapon(itemType) || UIInventoryItemsManager.IsItemTypeRangedWeapon(itemType) || UIInventoryItemsManager.IsItemTypeGrenade(itemType) {
      return VirtualStoreCategory.Weapons;
    };

    if UIInventoryItemsManager.IsItemTypeCyberware(itemType) || UIInventoryItemsManager.IsItemTypeCyberwareWeapon(itemType) {
      return VirtualStoreCategory.Cyberware;
    };

    if Equals(itemType, gamedataItemType.Con_Edible) 
    || Equals(itemType, gamedataItemType.Con_Inhaler) 
    || Equals(itemType, gamedataItemType.Con_Injector) 
    || Equals(itemType, gamedataItemType.Con_LongLasting)
    || Equals(itemType, gamedataItemType.Con_Skillbook) {
      return VirtualStoreCategory.Consumables;
    };

    return VirtualStoreCategory.Other;
  }
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  VirtualAtelierStoresManager.GetInstance(this.GetPlayerControlledObject().GetGame()).BuildStoresList();
}
