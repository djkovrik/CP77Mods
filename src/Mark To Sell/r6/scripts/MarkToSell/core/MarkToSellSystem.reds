module MarkToSell.System

public class MarkToSellSystem extends ScriptableSystem {
  
  private persistent let markers: array<Uint64>;

  private let inventoryManager: ref<InventoryDataManagerV2>;

  private let equipmentSystem: ref<EquipmentSystem>;

  private let uiScriptableSystem: ref<UIScriptableSystem>;

  private let player: wref<PlayerPuppet>;

  public final static func GetInstance(gameInstance: GameInstance) -> ref<MarkToSellSystem> {
    let system: ref<MarkToSellSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"MarkToSell.System.MarkToSellSystem") as MarkToSellSystem;
    return system;
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.inventoryManager = new InventoryDataManagerV2();
      this.inventoryManager.Initialize(player);
      this.equipmentSystem = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
      this.uiScriptableSystem = UIScriptableSystem.GetInstance(player.GetGame());
      this.player = player;
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

  public func MarkSimilarItems(data: ref<gameItemData>) -> Void {
    let sellable: array<wref<gameItemData>>;
    this.inventoryManager.GetSellablePlayerItems(sellable);
    let type: gamedataItemType = data.GetItemType();
    let quality: gamedataQuality = RPGManager.GetItemDataQuality(data);
    let currentlyMarked: Bool = data.modMarkedForSale;
    let isEquipped: Bool;
    let isIconic: Bool;
    let isFavorite: Bool;

    for itemData in sellable {
      isEquipped = this.equipmentSystem.IsEquipped(this.player, itemData.GetID());
      isIconic = RPGManager.IsItemDataIconic(itemData);
      isFavorite = this.uiScriptableSystem.IsItemPlayerFavourite(itemData.GetID());
      if !itemData.HasTag(n"Quest") && Equals(itemData.GetItemType(), type) && Equals(RPGManager.GetItemDataQuality(itemData), quality) && !isEquipped && !isIconic && !isFavorite {
        if currentlyMarked {
          itemData.modMarkedForSale = false;
          this.Remove(itemData.GetID());
        } else {
          itemData.modMarkedForSale = true;
          this.Add(itemData.GetID());
        };
      };
    };
  }

  public func ClearAll() -> Void {
    let marked: array<wref<gameItemData>>;
    this.inventoryManager.GetPlayerItemsMarkedToSell(marked);

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
    this.inventoryManager.GetSellablePlayerItems(itemsForSale);
    for item in itemsForSale {
      item.modMarkedForSale = this.Contains(item.GetID());
    };
  }
}
