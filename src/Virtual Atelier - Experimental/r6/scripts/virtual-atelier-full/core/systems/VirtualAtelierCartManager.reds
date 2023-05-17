module VirtualAtelier.Systems

public class VirtualAtelierCartManager extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;
  private let transactionSystem: wref<TransactionSystem>;
  private let cart: ref<inkHashMap>;

  public static func GetInstance(gi: GameInstance) -> ref<VirtualAtelierCartManager> {
    let system: ref<VirtualAtelierCartManager> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VirtualAtelier.Systems.VirtualAtelierCartManager") as VirtualAtelierCartManager;
    return system;
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
    this.player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
    this.cart = new inkHashMap();
  }

  public final func AddToCart(stockItem: ref<VirtualStockItem>) -> Bool {
    let itemID: ItemID;
    let cartItem: ref<VirtualCartItem>;
    if IsDefined(stockItem) {
      itemID = stockItem.itemID;
      cartItem = this.GetOrCreateCartItem(stockItem);
      cartItem.purchaseAmount = cartItem.purchaseAmount + 1;
      if this.IsAddedToCart(itemID) {
        this.cart.Set(this.Hash(itemID), cartItem);
      } else {
        this.cart.Insert(this.Hash(itemID), cartItem);
      };
      return true;
    } else {
      return false;
    };

    return false;
  }

  public final func RemoveFromCart(stockItem: ref<VirtualStockItem>) -> Bool {
    let itemID: ItemID;
    if IsDefined(stockItem) {
      itemID = stockItem.itemID;
      if this.IsAddedToCart(itemID) {
        this.cart.Remove(this.Hash(itemID));
        return true;
      } else {
        return false;
      };
    };

    return false;
  }

  public final func IsAddedToCart(itemID: ItemID) -> Bool {
    return this.cart.KeyExist(this.Hash(itemID));
  }

  public final func GetCartSize() -> Int32 {
    let values: array<wref<IScriptable>>;
    this.cart.GetValues(values);
    return ArraySize(values);
  }

  public final func ClearCart() -> Void {
    this.cart.Clear();
  }

  public final func GetPlayerMoney() -> Int32 {
    return this.transactionSystem.GetItemQuantity(this.player, MarketSystem.Money());
  }

  public final func GetCurrentCartPrice() -> Int32 {
    let values: array<wref<IScriptable>>;
    let current: ref<VirtualCartItem>;
    let currentPrice: Float;
    let total: Float = 0.0;

    this.cart.GetValues(values);

    for value in values {
      current = value as VirtualCartItem;
      currentPrice = current.stockItem.price * Cast<Float>(current.purchaseAmount);
      total += currentPrice;
    };


    return Cast<Int32>(total);
  }

  private func GetOrCreateCartItem(stockItem: ref<VirtualStockItem>) -> ref<VirtualCartItem> {
    let hash: Uint64 = this.Hash(stockItem.itemID);
    let cartItem: ref<VirtualCartItem>;
    if this.cart.KeyExist(hash) {
      cartItem = this.cart.Get(hash) as VirtualCartItem;
    } else {
      cartItem = new VirtualCartItem();
      cartItem.stockItem = stockItem;
      cartItem.purchaseAmount = 0;
    }

    return cartItem;
  }

  private final func Hash(itemID: ItemID) -> Uint64 {
    return ItemID.GetCombinedHash(itemID);
  }
}
