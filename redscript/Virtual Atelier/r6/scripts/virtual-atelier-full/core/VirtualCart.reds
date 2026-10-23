module VirtualAtelier.Core

public class VirtualAtelierCart {
  private let keys: array<Uint64>;
  private let map: ref<inkHashMap>;

  public final func Init() -> Void {
    ArrayClear(this.keys);
    this.map = new inkHashMap();
  }

  public final func Exists(itemID: ItemID, quantity: Int32) -> Bool {
    return IsDefined(this.Get(itemID, quantity));
  }

  public final func ExistsStock(stockItem: ref<VirtualStockItem>) -> Bool {
    if !IsDefined(stockItem) {
      return false;
    };

    let key: Uint64 = this.HashStock(stockItem);
    return ArrayContains(this.keys, key);
  }

  public final func Insert(stockItem: ref<VirtualStockItem>, purchaseAmount: Int32) -> Bool {
    let key: Uint64;
    let cartItem: ref<VirtualCartItem>;
    if IsDefined(stockItem) {
      key = this.HashStock(stockItem);
      cartItem = this.GetOrCreateCartItem(stockItem);
      cartItem.purchaseAmount = purchaseAmount;
      if this.ExistsStock(stockItem) {
        this.map.Set(key, cartItem);
      } else {
        this.map.Insert(key, cartItem);
        ArrayPush(this.keys, key);
      };
      return true;
    };

    return false;
  }

  public final func Remove(stockItem: ref<VirtualStockItem>) -> Bool {
    let key: Uint64;
    if IsDefined(stockItem) {
      key = this.HashStock(stockItem);
      if this.ExistsStock(stockItem) {
        this.map.Remove(key);
        ArrayRemove(this.keys, key);
        return true;
      };
    };

    return false;
  }

  public final func Get(itemID: ItemID, quantity: Int32) -> ref<VirtualCartItem> {
    let current: ref<VirtualCartItem>;
    for key in this.keys {
      current = this.map.Get(key) as VirtualCartItem;
      if IsDefined(current) && IsDefined(current.stockItem) && Equals(current.stockItem.itemID, itemID) && Equals(current.stockItem.quantity, quantity) {
        return current;
      };
    };

    return null;
  }

  public final func GetStock(stockItem: ref<VirtualStockItem>) -> ref<VirtualCartItem> {
    let key: Uint64;
    let current: ref<VirtualCartItem>;
    if this.ExistsStock(stockItem) {
      key = this.HashStock(stockItem);
      current = this.map.Get(key) as VirtualCartItem;
      return current;
    };

    return null;
  }

  public final func GetPurchaseAmount(itemID: ItemID, quantity: Int32) -> Int32 {
    let current: ref<VirtualCartItem>;
    if this.Exists(itemID, quantity) {
      current = this.Get(itemID, quantity);
      return current.purchaseAmount;
    };

    return -1;
  }

  public final func GetStockPurchaseAmount(stockItem: ref<VirtualStockItem>) -> Int32 {
    let current: ref<VirtualCartItem>;
    if this.ExistsStock(stockItem) {
      current = this.GetStock(stockItem);
      return current.purchaseAmount;
    };

    return -1;
  }

  public final func GetCart() -> array<ref<VirtualCartItem>> {
    let items: array<ref<VirtualCartItem>>;
    let current: ref<VirtualCartItem>;
    for key in this.keys {
      current = this.map.Get(key) as VirtualCartItem;
      ArrayPush(items, current);
    };

    return items;
  }

  public final func GetSize() -> Int32 {
    return ArraySize(this.keys);
  }

  public final func Clear() -> Void {
    this.map.Clear();
    ArrayClear(this.keys);
  }

  private final func GetOrCreateCartItem(stockItem: ref<VirtualStockItem>) -> ref<VirtualCartItem> {
    let key: Uint64 = this.HashStock(stockItem);
    let cartItem: ref<VirtualCartItem>;

    if this.ExistsStock(stockItem) {
      cartItem = this.map.Get(key) as VirtualCartItem;
    } else {
      cartItem = new VirtualCartItem();
      cartItem.stockItem = stockItem;
      cartItem.purchaseAmount = 0;
    };

    return cartItem;
  }

  private final func HashStock(stockItem: ref<VirtualStockItem>) -> Uint64 {
    if NotEquals(stockItem.stockKey, Cast<Uint64>(0u)) {
      return stockItem.stockKey;
    };

    return this.Hash(stockItem.itemID, stockItem.quantity);
  }

  private final func Hash(itemID: ItemID, quantity: Int32) -> Uint64 {
    let hash: Uint64 = ItemID.GetCombinedHash(itemID);
    let quantity: Uint64 = Cast<Uint64>(quantity);
    let result: Uint64 = hash + quantity;
    return result;
  }
}