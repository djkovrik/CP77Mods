module EnhancedCraft.System
import EnhancedCraft.Config.ECraftConfig
import EnhancedCraft.Common.*

// -- Custom scriptable system which controls custom weapon names persistence

public class EnhancedCraftSystem extends ScriptableSystem {

  private persistent let m_nameRecords: array<ref<CustomCraftNameDataPS>>;

  private let inventoryManager: ref<InventoryDataManagerV2>;

  private let player: wref<PlayerPuppet>;

  private let config: ref<ECraftConfig>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    L(s"Persisted data loaded, stored names: \(ToString(ArraySize(this.m_nameRecords)))");
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.player = player;
      this.inventoryManager = new InventoryDataManagerV2();
      this.inventoryManager.Initialize(this.player);
      this.RefreshPlayerInventory();
    };
    this.config = new ECraftConfig();
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<EnhancedCraftSystem> {
    let system: ref<EnhancedCraftSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"EnhancedCraft.System.EnhancedCraftSystem") as EnhancedCraftSystem;
    return system;
  }

  public final static func GetConfig(gameInstance: GameInstance) -> ref<ECraftConfig> {
    let config: ref<ECraftConfig> = EnhancedCraftSystem.GetInstance(gameInstance).GetConfig();
    return config;
  }

  public func RefreshPlayerInventory() -> Void {
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;

    this.inventoryManager.GetPlayerItemsDataByCategory(playerItemsData);
    this.GetItemsIdsFromGameData(playerItemsData, playerItems);
   
    L(s"RefreshPlayerInventory: player items detected: \(ArraySize(playerItems))");
    this.RefreshNames(playerItemsData, false);
  }

  public func RefreshPlayerInventoryAndStash(storageItems: array<ref<gameItemData>>) -> Void {
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;

    this.inventoryManager.GetPlayerItemsDataByCategory(playerItemsData);
    this.GetItemsIdsFromGameData(playerItemsData, playerItems);

    // Add storage items into gamedata array
    for item in storageItems {
      ArrayPush(playerItemsData, item);
    };

    L(s"RefreshPlayerInventoryAndStash: player items detected: \(ArraySize(playerItems))");
    this.RefreshNames(playerItemsData, true);
  }

  public func RefreshSingleItem(itemData: ref<gameItemData>) -> Void {
    let hasCustomName: Bool = this.HasCustomName(itemData.GetID());

    if hasCustomName {
      itemData.hasCustomName = this.HasCustomName(itemData.GetID());
      itemData.customName = this.GetCustomName(itemData.GetID());
    };

    L(s"RefreshSingleItem \(ItemID.GetCombinedHash(itemData.GetID())), name: \(hasCustomName)");
  }

  // -- Saves custom name
  public func AddCustomName(itemId: ItemID, name: String) -> Void {
    let persistedRecords: array<ref<CustomCraftNameDataPS>> = this.m_nameRecords;
    let newRecord: ref<CustomCraftNameDataPS> = new CustomCraftNameDataPS();
    let newId: Uint64 = ItemID.GetCombinedHash(itemId);
    newRecord.id = newId;
    newRecord.name = StringToName(name);
    ArrayPush(persistedRecords, newRecord);
    this.m_nameRecords = persistedRecords;
    L(s"New name \(name) persisted with id \(newId), total persisted names: \(ArraySize(this.m_nameRecords))");
  }

  // -- Checks if item has custom name persisted
  public func HasCustomName(itemId: ItemID) -> Bool {
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    for record in this.m_nameRecords {
      if Equals(record.id, id) {
        return true;
      };
    };
    return false;
  }

  // -- Returns custom name by ItemID
  public func GetCustomName(itemId: ItemID) -> String {
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    for record in this.m_nameRecords {
      if Equals(record.id, id) {
        return NameToString(record.name);
      };
    };
    return "";
  }

  private func GetConfig() -> ref<ECraftConfig> {
    return this.config;
  }

  // -- MISC

  // -- Refresh data in target items array
  private func RefreshNames(items: array<ref<gameItemData>>, shouldClean: Bool) -> Void {
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;

    this.inventoryManager.GetPlayerItemsDataByCategory(playerItemsData);
    this.GetItemsIdsFromGameData(playerItemsData, playerItems);
    L(s"RefreshStoredNames: player items detected: \(ArraySize(playerItems))");

    // Iterate through player items and assign custom names
    for data in playerItemsData {
      data.hasCustomName = this.HasCustomName(data.GetID());
      data.customName = this.GetCustomName(data.GetID());
    };

    if shouldClean {
      this.ClearUnusedRecords(items);
    };
  }

  // Iterate through persisted records and clean unsused
  private func ClearUnusedRecords(items: array<ref<gameItemData>>) -> Void {
    L("Cleaning unused records...");
    let persistedm_nameRecords: array<ref<CustomCraftNameDataPS>> = this.m_nameRecords;
    let commonItemIds: array<ItemID>;
    let commonItemHashes: array<Uint64>;

    this.inventoryManager.GetPlayerItemsDataByCategory(items);
    // Check all
    this.GetItemsIdsFromGameData(items, commonItemIds);
    this.GetInventoryHashes(commonItemIds, commonItemHashes);

    if ArraySize(commonItemHashes) > 0 {
      for record in persistedm_nameRecords {
        if this.HasInInventory(commonItemHashes, record.id) {
          L(s"- name record \(record.id) detected as \(record.name), keep it");
        } else {
          L(s"- name record \(record.id) not detected, deleting persistent record...");
          this.DeleteStoredNameRecord(record.id);
        };
      };
    };
  }

  // -- Deletes persisted name record
  private func DeleteStoredNameRecord(id: Uint64) -> Void {
    let persistedRecords: array<ref<CustomCraftNameDataPS>> = this.m_nameRecords;
    let index: Int32 = 0;
    for record in this.m_nameRecords {
      if Equals(record.id, id) {
        ArrayErase(persistedRecords, index);
        L(s" - name record deleted \(record.name)");
      };
      index += 1;
    };

    this.m_nameRecords = persistedRecords;
    L(s"Persisted name record \(id) deleted, total persisted records: \(ArraySize(this.m_nameRecords))");
  }

  // -- Get IDs from game data array
  private func GetItemsIdsFromGameData(targetItems: array<ref<gameItemData>>, out items: array<ItemID>) -> Void {
    let itemId: ItemID;
    let limit: Int32 = ArraySize(targetItems);
    let i: Int32 = 0;
    while i < limit {
      itemId = targetItems[i].GetID();
      ArrayPush(items, itemId);
      i += 1;
    };
  }

  // -- Converts array<ItemID> to array<Uint64>
  private func GetInventoryHashes(items: array<ItemID>, out hashes: array<Uint64>) -> Void {
    for item in items {
      ArrayPush(hashes, ItemID.GetCombinedHash(item));
    };
  }

  // -- Checks if target hash exists in hashes array
  private func HasInInventory(hashes: array<Uint64>, target: Uint64) -> Bool {
    for hash in hashes {
      if Equals(hash, target) {
        return true;
      };
    };
    return false;
  }
}
