module VirtualAtelier.Systems
import VirtualAtelier.Core.VirtualAtelierCart
import VirtualAtelier.Helpers.AtelierItemsHelper

public class VirtualAtelierCartManager extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;
  private let transactionSystem: wref<TransactionSystem>;
  private let inventoryManager: wref<InventoryManager>;
  private let inventoryManagerV2: ref<InventoryDataManagerV2>;
  private let cart: ref<VirtualAtelierCart>;
  private let stock: array<ref<VirtualStockItem>>;
  private let currentPlayerMoney: Int32;
  private let currentGoodsPrice: Int32;

  private let ownedItems: array<TweakDBID>;
  private let ownedTagsToShow: array<CName>;

  public static func GetInstance(gi: GameInstance) -> ref<VirtualAtelierCartManager> {
    let system: ref<VirtualAtelierCartManager> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VirtualAtelier.Systems.VirtualAtelierCartManager") as VirtualAtelierCartManager;
    return system;
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
    this.player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
    this.inventoryManager = GameInstance.GetInventoryManager(this.player.GetGame());
    this.inventoryManagerV2 = new InventoryDataManagerV2();
    this.inventoryManagerV2.Initialize(this.player);
    this.cart = new VirtualAtelierCart();
    this.cart.Init();
    this.RefreshCurrentBalances();
    this.FillExcludeTags();
  }

  public final func StoreVirtualStock(stock: array<ref<VirtualStockItem>>) -> Void {
    this.stock = stock;
  }

  public final func PlayerHasEnoughMoneyFor(itemID: ItemID) -> Bool {
    let price: Int32;
    let availableMoney: Int32;
    for item in this.stock {
      if Equals(item.itemID, itemID) {
        price = Cast<Int32>(item.price);
        availableMoney = this.GetCurrentPlayerMoney() - this.GetCurrentGoodsPrice();
        return availableMoney >= price;
      };
    };

    return false;
  }

  public final func GetBuyableAmount(itemID: ItemID, quantity: Int32) -> Int32 {
    let price: Int32;
    let availableMoney: Int32;
    for item in this.stock {
      if Equals(item.itemID, itemID) {
        price = Cast<Int32>(item.price);
        availableMoney = this.GetCurrentPlayerMoney() - this.GetCurrentGoodsPrice();
        let amount: Int32 = availableMoney / price / quantity;
        return amount;
      };
    };

    return 0;
  }

  public final func AddToCart(stockItem: ref<VirtualStockItem>, purchaseAmount: Int32) -> Bool {
    let added: Bool = this.cart.Insert(stockItem, purchaseAmount);
    this.RefreshCurrentBalances();
    return added;
  }

  public final func RemoveFromCart(stockItem: ref<VirtualStockItem>) -> Bool {
    let removed: Bool = this.cart.Remove(stockItem);
    this.RefreshCurrentBalances();
    return removed;
  }

  public final func IsAddedToCart(itemID: ItemID, quantity: Int32) -> Bool {
    return this.cart.Exists(itemID, quantity);
  }

  public final func GetAddedQuantity(itemID: ItemID, quantity: Int32) -> Int32 {
    return this.cart.GetPurchaseAmount(itemID, quantity);
  }

  public final func GetCartSize() -> Int32 {
    return this.cart.GetSize();
  }

  public final func ClearCart() -> Void {
    this.cart.Clear();
    this.currentGoodsPrice = 0;
    this.RefreshCurrentBalances();
  }

  public final func PurchaseGoods() -> Void {
    let cartItems: array<ref<VirtualCartItem>> = this.cart.GetCart();
    let itemID: ItemID;
    let itemData: ref<gameItemData>;
    let stockItem: ref<VirtualStockItem>;

    // Add items
    for cartItem in cartItems {
      let i: Int32 = 0;
      while i < cartItem.purchaseAmount {
        stockItem = cartItem.stockItem;
        itemID = ItemID.FromTDBID(stockItem.itemTDBID);
        itemData = this.inventoryManager.CreateBasicItemData(itemID, this.player);
        itemData.isVirtualItem = true;
        AtelierItemsHelper.ScaleItem(this.player, itemData, stockItem.quality);
        this.transactionSystem.GiveItem(this.player, itemID, stockItem.quantity);
        this.SaveOwnedItem(stockItem);
        i += 1;
      };
    };

    // Remove money
    this.transactionSystem.RemoveItemByTDBID(this.player, t"Items.money", this.GetCurrentGoodsPrice());
    this.ClearCart();
  }

  public final func GetCurrentPlayerMoney() -> Int32 {
    return this.currentPlayerMoney;
  }

  public final func GetCurrentGoodsPrice() -> Int32 {
    return this.currentGoodsPrice;
  }

  public final func SaveOwnedItems(items: array<wref<gameItemData>>) -> Void {
    ArrayClear(this.ownedItems);

    let id: TweakDBID;
    for item in items {
      if this.ShouldControlOwnership(item) {
        id = ItemID.GetTDBID(item.GetID());
        ArrayPush(this.ownedItems, id);
      };
    };
  }

  public final func SaveOwnedItem(item: ref<VirtualStockItem>) -> Bool {
    let id: TweakDBID = item.itemTDBID;
    let data: ref<gameItemData> = item.itemData;
    if !this.IsItemOwned(id) && this.ShouldControlOwnership(data) {
      ArrayPush(this.ownedItems, id);
    };
    return false;
  }

  public final func IsItemOwned(id: TweakDBID) -> Bool {
    return ArrayContains(this.ownedItems, id);
  }

  public final func ShouldControlOwnership(data: wref<gameItemData>) -> Bool {
    return this.HasSupportedTag(data);
  }

  private final func RefreshCurrentBalances() -> Void {
    let values: array<ref<VirtualCartItem>> = this.cart.GetCart();
    let current: ref<VirtualCartItem>;
    let currentPrice: Float;
    let total: Float = 0.0;

    for value in values {
      current = value as VirtualCartItem;
      currentPrice = current.stockItem.price * Cast<Float>(current.purchaseAmount);
      total += currentPrice;
    };

    this.currentGoodsPrice = Cast<Int32>(total);
    this.currentPlayerMoney = this.transactionSystem.GetItemQuantity(this.player, MarketSystem.Money());
  }

  private final func FillExcludeTags() -> Void {
    ArrayClear(this.ownedTagsToShow);
    ArrayPush(this.ownedTagsToShow, n"Clothing");
    ArrayPush(this.ownedTagsToShow, n"Cyberware");
    ArrayPush(this.ownedTagsToShow, n"Weapon");
  }

  private final func HasSupportedTag(data: ref<gameItemData>) -> Bool {
    for tagToCheck in this.ownedTagsToShow {
      if data.HasTag(tagToCheck) { 
        return true; 
      };
    };

    return false;
  }
}
