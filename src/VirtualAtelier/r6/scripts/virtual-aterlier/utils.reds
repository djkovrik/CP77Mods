module VendorPreview.utils

public func IsItemClothing(itemID: ItemID) -> Bool {
  return Equals(RPGManager.GetItemCategory(itemID), gamedataItemCategory.Clothing);
}

public func IsItemWeapon(itemID: ItemID) -> Bool {
  return Equals(RPGManager.GetItemCategory(itemID), gamedataItemCategory.Weapon);
}

public func GetZoomArea(equipmentArea: gamedataEquipmentArea) -> InventoryPaperdollZoomArea {
  switch equipmentArea {
    case gamedataEquipmentArea.Weapon:
      return InventoryPaperdollZoomArea.Weapon;
    case gamedataEquipmentArea.Legs:
      return InventoryPaperdollZoomArea.Legs;
    case gamedataEquipmentArea.Feet:
      return InventoryPaperdollZoomArea.Feet;
    case gamedataEquipmentArea.ArmsCW:
    case gamedataEquipmentArea.HandsCW:
    case gamedataEquipmentArea.SystemReplacementCW:
      return InventoryPaperdollZoomArea.Cyberware;
    case gamedataEquipmentArea.QuickSlot:
      return InventoryPaperdollZoomArea.QuickSlot;
    case gamedataEquipmentArea.Consumable:
      return InventoryPaperdollZoomArea.Consumable;
    case gamedataEquipmentArea.Outfit:
      return InventoryPaperdollZoomArea.Outfit;
    case gamedataEquipmentArea.Head:
      return InventoryPaperdollZoomArea.Head;
    case gamedataEquipmentArea.Face:
      return InventoryPaperdollZoomArea.Face;
    case gamedataEquipmentArea.InnerChest:
     return InventoryPaperdollZoomArea.InnerChest;
    case gamedataEquipmentArea.OuterChest:
      return InventoryPaperdollZoomArea.OuterChest;
  };

  return InventoryPaperdollZoomArea.Default;
}

public func CheckDuplicates(stores: array<ref<VirtualShop>>, controller: ref<WebPage>) -> Void {
  let itemsToStoresMap: array<ref<ItemToStoresMap>>;
  let duplicateItemIDs: array<String>;

  let storeIndex = 0;

  while storeIndex < ArraySize(stores) {
    let store = stores[storeIndex];
    let storeID: CName = store.storeID;
    let storeName: String = store.storeName;
    let items: array<String> = store.items;

    let itemIndex = 0;

    while itemIndex < ArraySize(items) {
      let item: String = items[itemIndex];

      let isExists = false;

      let itemsToStoreIndex = 0;

      while itemsToStoreIndex < ArraySize(itemsToStoresMap) {
        let itemToStoresMap = itemsToStoresMap[itemsToStoreIndex];

        if Equals(itemToStoresMap.itemID, item) {
          ArrayPush(itemToStoresMap.stores, storeName);
          ArrayPush(duplicateItemIDs, item);

          isExists = true;
          
          itemsToStoreIndex = ArraySize(itemsToStoresMap);
        }

        itemsToStoreIndex += 1;
      }

      if !isExists {
        let newItemToStoresMap = new ItemToStoresMap();
        newItemToStoresMap.itemID = item;

        let storesList: array<String>;
        newItemToStoresMap.stores = storesList;

        ArrayPush(newItemToStoresMap.stores, storeName);
        ArrayPush(itemsToStoresMap, newItemToStoresMap);
      }

      itemIndex += 1;
    }

    storeIndex += 1;  
  }

  if ArraySize(duplicateItemIDs) > 0 {
    let finalMessage: String = "";

    let duplicateItemIndex = 0;

    while duplicateItemIndex < ArraySize(duplicateItemIDs) {
      let duplicateItemID = duplicateItemIDs[duplicateItemIndex];

      let storeNames: String = "[ATELIER DUPLICATE ITEM: " + duplicateItemID + "]" + ": ";

      let currentItemToStoresMap: ref<ItemToStoresMap>;

      let mapIndex = 0;

      while mapIndex < ArraySize(itemsToStoresMap) {
        let currMap = itemsToStoresMap[mapIndex];
        
        if Equals(currMap.itemID, duplicateItemID) {
          let storeIndex = 0;

          while storeIndex < ArraySize(currMap.stores) {
            let isLast = Equals(storeIndex, ArraySize(currMap.stores) - 1);
            let currStore = currMap.stores[storeIndex];

            if isLast {
              storeNames += currStore;
            } else {
              storeNames += currStore + ", ";
            }

            storeIndex += 1;
          }

          mapIndex = ArraySize(itemsToStoresMap);
        } else {
          mapIndex += 1;
        }
      }

      finalMessage += storeNames + "\n";

      duplicateItemIndex += 1;
    }

    controller.DisplayWarning("DUPLICATE ATELIER ITEMS\nCHECK CONSOLE FOR DETAILS");
    Log(finalMessage);
  }
}