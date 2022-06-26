module MarkToSell.System

public class MarkToSellSystem extends ScriptableSystem {
  
  private persistent let markers: array<Uint64>;

  private let m_inventoryManager: ref<InventoryDataManagerV2>;

  public final static func GetInstance(gameInstance: GameInstance) -> ref<MarkToSellSystem> {
    let system: ref<MarkToSellSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"MarkToSell.System.MarkToSellSystem") as MarkToSellSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.m_inventoryManager = new InventoryDataManagerV2();
      this.m_inventoryManager.Initialize(player);
      this.RefreshMarksForSale();
    };
  }

  public func Add(itemId: ItemID) -> Void {
    let current: array<Uint64> = this.markers;
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    ArrayPush(current, id);
    this.markers = current;
  }

  public func Remove(itemId: ItemID) -> Void {
    let current: array<Uint64> = this.markers;
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    let index: Int32 = 0;
    for item in current {
      if Equals(id, item) {
        ArrayErase(current, index);
      }
      index = index + 1;
    };
    this.markers = current;
  }

  public func HasAnythingMarked() -> Bool {
    return ArraySize(this.markers) > 0;
  }

  public func ClearAll() -> Void {
    let marked: array<wref<gameItemData>>;
    this.m_inventoryManager.GetPlayerItemsMarkedToSell(marked);

    for item in marked {
      item.modMarkedForSale = false;
    };

    let current: array<Uint64> = this.markers;
    ArrayClear(current);
    this.markers = current;
  }

  private func Contains(itemId: ItemID) -> Bool {
    let current: array<Uint64> = this.markers;
    let id: Uint64 = ItemID.GetCombinedHash(itemId);

    for currentId in current {
      if Equals(currentId, id) {
        return true;
      };
    };

    return false;
  }

  private func RefreshMarksForSale() -> Void {
    let itemsForSale: array<wref<gameItemData>>;
    this.m_inventoryManager.GetSellablePlayerItems(itemsForSale);
    for item in itemsForSale {
      item.modMarkedForSale = this.Contains(item.GetID());
    };
  }
}
