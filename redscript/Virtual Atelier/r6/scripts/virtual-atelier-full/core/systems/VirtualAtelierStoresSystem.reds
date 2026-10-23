module VirtualAtelier.Systems
import VirtualAtelier.Logs.AtelierLog
import VirtualAtelier.Core.*

public class VirtualAtelierStoresManager extends ScriptableSystem {

  private let stores: array<ref<VirtualShop>>;
  private let categories: array<VirtualStoreCategory>;
  private let current: ref<VirtualShop>;
  private let searchResults: array<ref<VirtualStoreSearchResult>>;
  private let searchResultsCounter: Int32;
  private let searchBatchCriteria: ref<VirtualStoreSearchCriteria>;
  private let searchBatchWardrobeAppearances: array<CName>;
  private let searchBatchResult: ref<VirtualStoreSearchResult>;
  private let searchBatchStoreIndex: Int32;
  private let searchBatchItemIndex: Int32;
  private let searchBatchToken: Int32;
  private let searchBatchPrepared: Bool;
  private let searchBatchActive: Bool;
  private persistent let bookmarked: array<CName>;
  private persistent let prevStores: array<CName>;
  private persistent let itemCounts: array<ref<StoreItemCountWrapper>>;

  public static func GetInstance(gi: GameInstance) -> ref<VirtualAtelierStoresManager> {
    let system: ref<VirtualAtelierStoresManager> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VirtualAtelier.Systems.VirtualAtelierStoresManager") as VirtualAtelierStoresManager;
    return system;
  }

  public func GetStores() -> array<ref<VirtualShop>> {
    return this.stores;
  }

  public func GetStoresCount() -> Int32 {
    return ArraySize(this.stores);
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

  public func GetSearchResults() -> array<ref<VirtualStoreSearchResult>> {
    return this.searchResults;
  }

  public func GetSearchResultsCounter() -> Int32 {
    return this.searchResultsCounter;
  }

  public func GetSearchResultsStoresCounter() -> Int32 {
    return ArraySize(this.searchResults);
  }

  public func HasSearchResults() -> Bool {
    return this.searchResultsCounter > 0;
  }

  public func ClearSearchResults() -> Void {
    this.CancelSearchStores();
    ArrayClear(this.searchResults);
    this.searchResultsCounter = 0;
  }

  public func CancelSearchStores() -> Void {
    this.searchBatchToken += 1;
    this.searchBatchActive = false;
    this.searchBatchPrepared = false;
    this.searchBatchCriteria = null;
    this.searchBatchResult = null;
    this.searchBatchStoreIndex = 0;
    this.searchBatchItemIndex = 0;
    ArrayClear(this.searchBatchWardrobeAppearances);
  }

  public func SearchStores(criteria: ref<VirtualStoreSearchCriteria>) -> Int32 {
    let wardrobeItemIDs: array<ItemID> = GameInstance.GetWardrobeSystem(this.GetGameInstance()).GetStoredItemIDs();
    let wardrobeAppearances: array<CName> = this.GetWardrobeAppearances(wardrobeItemIDs);
    let result: ref<VirtualStoreSearchResult>;
    let itemTDBID: TweakDBID;
    let itemID: ItemID;
    let itemRecord: ref<Item_Record>;
    let i: Int32;

    this.ClearSearchResults();

    if !IsDefined(criteria) {
      return 0;
    };

    for store in this.stores {
      result = new VirtualStoreSearchResult();
      result.store = store;
      i = 0;
      while i < ArraySize(store.items) {
        itemTDBID = TDBID.Create(store.items[i]);
        itemID = ItemID.FromTDBID(itemTDBID);
        if ItemID.IsValid(itemID) {
          itemRecord = TweakDBInterface.GetItemRecord(itemTDBID);
          if IsDefined(itemRecord) && this.MatchesSearchCriteria(itemRecord, criteria, wardrobeAppearances) {
            ArrayPush(result.itemIndexes, i);
            result.counter += 1;
            this.searchResultsCounter += 1;
          };
        };
        i += 1;
      };

      if result.counter > 0 {
        ArrayPush(this.searchResults, result);
      };
    };

    return this.searchResultsCounter;
  }

  public func BeginSearchStores(criteria: ref<VirtualStoreSearchCriteria>) -> Int32 {
    this.CancelSearchStores();
    ArrayClear(this.searchResults);
    this.searchResultsCounter = 0;

    if !IsDefined(criteria) {
      return this.searchBatchToken;
    };

    this.searchBatchCriteria = criteria;
    this.searchBatchStoreIndex = 0;
    this.searchBatchItemIndex = 0;
    this.searchBatchResult = null;
    this.searchBatchPrepared = false;
    this.searchBatchActive = true;

    return this.searchBatchToken;
  }

  public func ContinueSearchStores(token: Int32, batchSize: Int32) -> Bool {
    let processed: Int32 = 0;
    let store: ref<VirtualShop>;
    let itemTDBID: TweakDBID;
    let itemID: ItemID;
    let itemRecord: ref<Item_Record>;

    if !this.searchBatchActive || NotEquals(token, this.searchBatchToken) {
      return true;
    };

    if batchSize < 1 {
      batchSize = 1;
    };

    if !this.searchBatchPrepared {
      if IsDefined(this.searchBatchCriteria) && this.searchBatchCriteria.newWardrobe {
        this.searchBatchWardrobeAppearances = this.GetWardrobeAppearances(GameInstance.GetWardrobeSystem(this.GetGameInstance()).GetStoredItemIDs());
      };
      this.searchBatchPrepared = true;
    };

    while this.searchBatchStoreIndex < ArraySize(this.stores) && processed < batchSize {
      store = this.stores[this.searchBatchStoreIndex];
      if !IsDefined(this.searchBatchResult) {
        this.searchBatchResult = new VirtualStoreSearchResult();
        this.searchBatchResult.store = store;
      };

      while this.searchBatchItemIndex < ArraySize(store.items) && processed < batchSize {
        itemTDBID = TDBID.Create(store.items[this.searchBatchItemIndex]);
        itemID = ItemID.FromTDBID(itemTDBID);
        if ItemID.IsValid(itemID) {
          itemRecord = TweakDBInterface.GetItemRecord(itemTDBID);
          if IsDefined(itemRecord) && this.MatchesSearchCriteria(itemRecord, this.searchBatchCriteria, this.searchBatchWardrobeAppearances) {
            ArrayPush(this.searchBatchResult.itemIndexes, this.searchBatchItemIndex);
            this.searchBatchResult.counter += 1;
            this.searchResultsCounter += 1;
          };
        };

        this.searchBatchItemIndex += 1;
        processed += 1;
      };

      if this.searchBatchItemIndex >= ArraySize(store.items) {
        if this.searchBatchResult.counter > 0 {
          ArrayPush(this.searchResults, this.searchBatchResult);
        };
        this.searchBatchResult = null;
        this.searchBatchStoreIndex += 1;
        this.searchBatchItemIndex = 0;
      };
    };

    if this.searchBatchStoreIndex >= ArraySize(this.stores) {
      this.searchBatchActive = false;
      this.searchBatchCriteria = null;
      this.searchBatchResult = null;
      ArrayClear(this.searchBatchWardrobeAppearances);
      return true;
    };

    return false;
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
      if lastIndex >= 0 {
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
    let previousCounters: array<ref<StoreItemCountWrapper>> = this.itemCounts;
    let currentCounters: array<ref<StoreItemCountWrapper>> = this.GetStoresItemCounts();
    let previousCounter: Int32;
    let currentCounter: Int32;
    let storeID: CName;
    let newlyInstalledStore: Bool;
    let updatedStore: Bool;
    for store in current {
      storeID = store.storeID;
      newlyInstalledStore = NotEquals(ArraySize(previousIds), 0) && !ArrayContains(previousIds, storeID);
      previousCounter = this.GetCounterByStoreId(previousCounters, storeID);
      currentCounter = this.GetCounterByStoreId(currentCounters, storeID);
      updatedStore = NotEquals(previousCounter, -1) && NotEquals(previousCounter, currentCounter);
      store.isNew = newlyInstalledStore || updatedStore;
      ArrayPush(refreshed, store);
    };
    this.stores = refreshed;
    this.prevStores = this.GetStoresIds();
    this.itemCounts = currentCounters;
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

  private func MatchesSearchCriteria(record: ref<Item_Record>, criteria: ref<VirtualStoreSearchCriteria>, wardrobeAppearances: array<CName>) -> Bool {
    let itemType: gamedataItemType = record.ItemType().Type();
    let localizedName: String;
    let primarySelected: Bool = this.IsPrimarySearchFilterSelected(criteria);
    let secondarySelected: Bool = this.IsSecondarySearchFilterSelected(criteria);

    if NotEquals(criteria.query, "") {
      localizedName = UTF8StrLower(GetLocalizedText(LocKeyToString(record.DisplayName())));
      if !StrContains(localizedName, criteria.query) {
        return false;
      };
    };

    if primarySelected && !this.MatchesPrimarySearchFilters(itemType, record, criteria) {
      return false;
    };

    if secondarySelected && !this.MatchesSecondarySearchFilters(itemType, record, criteria, wardrobeAppearances) {
      return false;
    };

    return true;
  }

  private func IsPrimarySearchFilterSelected(criteria: ref<VirtualStoreSearchCriteria>) -> Bool {
    return criteria.rangedWeapons || criteria.meleeWeapons || criteria.clothes || criteria.consumables || criteria.grenades || criteria.attachments || criteria.programs || criteria.cyberware || criteria.junk;
  }

  private func IsSecondarySearchFilterSelected(criteria: ref<VirtualStoreSearchCriteria>) -> Bool {
    return criteria.face || criteria.feet || criteria.head || criteria.legs || criteria.innerChest || criteria.outerChest || criteria.outfit || criteria.newWardrobe;
  }

  private func MatchesPrimarySearchFilters(itemType: gamedataItemType, record: ref<Item_Record>, criteria: ref<VirtualStoreSearchCriteria>) -> Bool {
    if criteria.rangedWeapons && this.MatchesSearchRangedWeapons(itemType, record) {
      return true;
    };
    if criteria.meleeWeapons && this.MatchesSearchMeleeWeapons(itemType, record) {
      return true;
    };
    if criteria.clothes && this.MatchesSearchClothes(itemType, record) {
      return true;
    };
    if criteria.consumables && this.MatchesSearchConsumables(itemType, record) {
      return true;
    };
    if criteria.grenades && this.MatchesSearchGrenades(itemType, record) {
      return true;
    };
    if criteria.attachments && this.MatchesSearchAttachments(itemType, record) {
      return true;
    };
    if criteria.programs && this.MatchesSearchPrograms(itemType, record) {
      return true;
    };
    if criteria.cyberware && this.MatchesSearchCyberware(itemType, record) {
      return true;
    };
    if criteria.junk && this.MatchesSearchJunk(itemType, record) {
      return true;
    };
    return false;
  }

  private func MatchesSecondarySearchFilters(itemType: gamedataItemType, record: ref<Item_Record>, criteria: ref<VirtualStoreSearchCriteria>, wardrobeAppearances: array<CName>) -> Bool {
    if criteria.face && this.MatchesSearchFace(itemType, record) {
      return true;
    };
    if criteria.feet && this.MatchesSearchFeet(itemType, record) {
      return true;
    };
    if criteria.head && this.MatchesSearchHead(itemType, record) {
      return true;
    };
    if criteria.legs && this.MatchesSearchLegs(itemType, record) {
      return true;
    };
    if criteria.innerChest && this.MatchesSearchInnerChest(itemType, record) {
      return true;
    };
    if criteria.outerChest && this.MatchesSearchOuterChest(itemType, record) {
      return true;
    };
    if criteria.outfit && this.MatchesSearchOutfit(itemType, record) {
      return true;
    };
    if criteria.newWardrobe && this.MatchesSearchNewWardrobe(itemType, record, wardrobeAppearances) {
      return true;
    };
    return false;
  }

  private func MatchesSearchRangedWeapons(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"RangedWeapon");
  }

  private func MatchesSearchMeleeWeapons(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"MeleeWeapon");
  }

  private func MatchesSearchClothes(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return UIInventoryItemsManager.IsItemTypeCloting(itemType) || record.TagsContains(n"Clothing");
  }

  private func MatchesSearchConsumables(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"Consumable");
  }

  private func MatchesSearchGrenades(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"Grenade");
  }

  private func MatchesSearchAttachments(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"itemPart") && !record.TagsContains(n"Fragment") && !record.TagsContains(n"SoftwareShard");
  }

  private func MatchesSearchPrograms(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"SoftwareShard") || record.TagsContains(n"QuickhackCraftingPart");
  }

  private func MatchesSearchCyberware(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return UIInventoryItemsManager.IsItemTypeCyberware(itemType) || record.TagsContains(n"Cyberware") || record.TagsContains(n"Fragment");
  }

  private func MatchesSearchJunk(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return record.TagsContains(n"Junk");
  }

  private func MatchesSearchFace(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_Face);
  }

  private func MatchesSearchFeet(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_Feet);
  }

  private func MatchesSearchHead(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_Head);
  }

  private func MatchesSearchLegs(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_Legs);
  }

  private func MatchesSearchInnerChest(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_InnerChest);
  }

  private func MatchesSearchOuterChest(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_OuterChest);
  }

  private func MatchesSearchOutfit(itemType: gamedataItemType, record: ref<Item_Record>) -> Bool {
    return Equals(itemType, gamedataItemType.Clo_Outfit);
  }

  private func MatchesSearchNewWardrobe(itemType: gamedataItemType, record: ref<Item_Record>, wardrobeAppearances: array<CName>) -> Bool {
    return this.MatchesSearchClothes(itemType, record) && !ArrayContains(wardrobeAppearances, record.AppearanceName());
  }

  private func GetWardrobeAppearances(wardrobeItemIDs: array<ItemID>) -> array<CName> {
    let result: array<CName>;
    let itemRecord: wref<Item_Record>;
    let i: Int32 = 0;
    while i < ArraySize(wardrobeItemIDs) {
      itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(wardrobeItemIDs[i]));
      if IsDefined(itemRecord) {
        ArrayPush(result, itemRecord.AppearanceName());
      };
      i += 1;
    };
    return result;
  }

  private func GetStoresIds() -> array<CName> {
    let result: array<CName>;
    for store in this.stores {
      ArrayPush(result, store.storeID);
    };

    return result;
  }

  private func GetStoresItemCounts() -> array<ref<StoreItemCountWrapper>> {
    let result: array<ref<StoreItemCountWrapper>>;
    let item: ref<StoreItemCountWrapper>;
    let counter: Int32;
    let itemTDBID: TweakDBID;
    let itemID: ItemID;

    for store in this.stores {
      item = new StoreItemCountWrapper();
      counter = 0;
      for itemStr in store.items {
        itemTDBID = TDBID.Create(itemStr);
        itemID = ItemID.FromTDBID(itemTDBID);
        if ItemID.IsValid(itemID) {
          counter += 1;
        }
      };

      item.storeID = store.storeID;
      item.itemCount = counter;
      ArrayPush(result, item);
    };

    return result;
  }

  private func GetCounterByStoreId(source: array<ref<StoreItemCountWrapper>>, storeID: CName) -> Int32 {
    for item in source {
      if Equals(item.storeID, storeID) {
        return item.itemCount;
      };
    };

    return -1;
  }

  private func GetItemCategory(id: TweakDBID) -> VirtualStoreCategory {
    let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(id);
    if !IsDefined(record) {
      return VirtualStoreCategory.Other;
    };
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
