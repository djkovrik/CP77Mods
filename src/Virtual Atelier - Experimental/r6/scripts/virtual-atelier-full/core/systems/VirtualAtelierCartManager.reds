module VirtualAtelier.Systems

public class VirtualAtelierCartManager extends ScriptableSystem {

  private let cart: array<ItemID>;

  public static func GetInstance(gi: GameInstance) -> ref<VirtualAtelierCartManager> {
    let system: ref<VirtualAtelierCartManager> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"VirtualAtelier.Systems.VirtualAtelierCartManager") as VirtualAtelierCartManager;
    return system;
  }

  public final func AddToCart(itemID: ItemID) -> Bool {
    if !this.IsAddedToCart(itemID) {
      ArrayPush(this.cart, itemID);
      return true;
    };

    return false;
  }

  public final func RemoveFromCart(itemID: ItemID) -> Bool {
    if this.IsAddedToCart(itemID) {
      ArrayRemove(this.cart, itemID);
      return true;
    };
    
    return false;
  }

  public final func IsAddedToCart(itemID: ItemID) -> Bool {
    return ArrayContains(this.cart, itemID);
  }

  public final func ClearCart() -> Void {
    ArrayClear(this.cart);
  }
}
