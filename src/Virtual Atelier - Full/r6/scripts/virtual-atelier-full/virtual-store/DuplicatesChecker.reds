import VirtualAtelier.Config.VirtualAtelierConfig
import VirtualAtelier.Logs.AtelierLog

// Compares items through all installed stores and check if item exists for more than a single store
public abstract class AtelierDuplicatesChecker {
  public static func Check(stores: array<ref<VirtualShop>>, controller: wref<WebPage>) -> Void {
    let config: ref<VirtualAtelierConfig> = VirtualAtelierConfig.Get();
    if !config.enableDuplicatesChecker {
      return ;
    };
    
    let itemsHashMap: ref<inkHashMap> = new inkHashMap();
    let storeIndex: Int32 = 0;
    let store: ref<VirtualShop>;
    let storeGoodie: ref<StoreGoods>;
    let items: array<String>;
    let item: String;
    let key: Uint64;
    let itemIndex: Int32;

    // Populate items map
    while storeIndex < ArraySize(stores) {
      store = stores[storeIndex];
      items = store.items;
      itemIndex = 0;
      while itemIndex < ArraySize(items) {
        item = items[itemIndex];
        key = TDBID.ToNumber(TDBID.Create(item));

        if itemsHashMap.KeyExist(key) {
          // Extract, add store and save
          storeGoodie = itemsHashMap.Get(key) as StoreGoods;
          storeGoodie.StoreShopIfNotContains(store.storeName);
          itemsHashMap.Set(key, storeGoodie);
        } else {
          // Insert new
          storeGoodie = new StoreGoods();
          storeGoodie.key = key;
          storeGoodie.item = item;
          storeGoodie.StoreShopIfNotContains(store.storeName);
          itemsHashMap.Insert(key, storeGoodie);
        };

        itemIndex += 1;
      };
      storeIndex += 1;
    };

    // Find items with more than single store
    let mapValues: array<wref<IScriptable>>;
    let storedItem: ref<StoreGoods>;
    let duplicatesInfo: String = "";
    let mapItemIndex: Int32 = 0;
    let isLast: Bool = false;
    let storeIndex: Int32;
    
    itemsHashMap.GetValues(mapValues);
    while mapItemIndex < ArraySize(mapValues) {
      storedItem = mapValues[mapItemIndex] as StoreGoods;
      if IsDefined(storedItem) && ArraySize(storedItem.stores) > 1 {
        AtelierLog("DUPLICATED ITEMS DETECTED!");
        duplicatesInfo = s"[DUPLICATED ITEM: \(storedItem.item)]" + ": ";
        storeIndex = 0;
        while storeIndex < ArraySize(storedItem.stores) {
          isLast = Equals(storeIndex, ArraySize(storedItem.stores) - 1);
          if isLast {
            duplicatesInfo += s"\(storedItem.stores[storeIndex])";
          } else {
            duplicatesInfo += s"\(storedItem.stores[storeIndex]), ";
          };
          storeIndex += 1;
        };

        duplicatesInfo += " ]";
        AtelierLog(duplicatesInfo);
      };

      mapItemIndex += 1;
    };
  }
}
