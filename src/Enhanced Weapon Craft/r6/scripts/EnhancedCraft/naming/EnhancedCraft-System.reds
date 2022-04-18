module EnhancedCraft.System
import EnhancedCraft.Common.L

// -- Persisted custom name data
public class CustomCraftNameData {
  public persistent let id: Uint64;
  public persistent let name: CName;
}

// -- Custom scriptable system which controls custom weapon names persistence

public class EnhancedCraftSystem extends ScriptableSystem {

  private persistent let m_records: array<ref<CustomCraftNameData>>;

  private let m_inventoryManager: ref<InventoryDataManagerV2>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    L(s"Persisted data loaded, stored names: \(ToString(ArraySize(this.m_records)))");
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.m_inventoryManager = new InventoryDataManagerV2();
      this.m_inventoryManager.Initialize(player);
      L("Inventory manager initialzied");
      this.RefreshStoredNames();
    };
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<EnhancedCraftSystem> {
    let system: ref<EnhancedCraftSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"EnhancedCraft.System.EnhancedCraftSystem") as EnhancedCraftSystem;
    return system;
  }

  // -- Saves custom name
  public func AddCustomName(itemId: ItemID, name: String) -> Void {
    let persistedRecords: array<ref<CustomCraftNameData>> = this.m_records;
    let newRecord: ref<CustomCraftNameData> = new CustomCraftNameData();
    let newId: Uint64 = ItemID.GetCombinedHash(itemId);
    newRecord.id = newId;
    newRecord.name = StringToName(name);
    ArrayPush(persistedRecords, newRecord);
    this.m_records = persistedRecords;
    L(s"New name \(name) persisted with id \(newId), total persisted names: \(ArraySize(this.m_records))");
  }

  // -- Checks if item has custom name persisted
  public func HasCustomName(itemId: ItemID) -> Bool {
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    for record in this.m_records {
      if Equals(record.id, id) {
        return true;
      };
    };
    return false;
  }

  // -- Returns custom name by ItemID
  public func GetCustomName(itemId: ItemID) -> String {
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    for record in this.m_records {
      if Equals(record.id, id) {
        return NameToString(record.name);
      };
    };
    return "";
  }

  // -- Deletes persisted record
  private func DeleteStoredRecord(id: Uint64) -> Void {
    let persistedRecords: array<ref<CustomCraftNameData>> = this.m_records;
    let index: Int32 = 0;
    for record in this.m_records {
      if Equals(record.id, id) {
        ArrayErase(persistedRecords, index);
        L(s" - deleted \(record.name)");
      };
      index += 1;
    };

    this.m_records = persistedRecords;
    L(s"Persisted record \(id) deleted, total persisted names: \(ArraySize(this.m_records))");
  }

  // -- Iterates through player inventory, checks if custom named item still exists
  //    and then assigns custom names to gameItemData
  public func RefreshStoredNames() -> Void {
    let persistedRecords: array<ref<CustomCraftNameData>> = this.m_records;
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;
    let inventoryHashes: array<Uint64>;

    this.m_inventoryManager.GetPlayerItemsIDsByCategory(gamedataItemCategory.Weapon, playerItems);
    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, playerItemsData);
    this.GetInventoryHashes(playerItems, inventoryHashes);
    L(s"Player weapons detected: \(ArraySize(playerItems)) + \(ArraySize(inventoryHashes)) + \(ArraySize(playerItemsData))");

    for id in playerItems {
      L(s"PLAYER ITEM: \(id)");
    };

    // Iterate through saved hashes and check if inventory has the same
    if ArraySize(inventoryHashes) > 0 {
      for record in persistedRecords {
        if this.HasInInventory(inventoryHashes, record.id) {
          L(s"- \(record.id) detected as \(record.name), keep it");
        } else {
          L(s"- \(record.id) not detected, deleting persistent record...");
          this.DeleteStoredRecord(record.id);
        };
      };
    };

    // Iterate through player weapons and assign custom names
    for data in playerItemsData {
      data.hasCustomName = this.HasCustomName(data.GetID());
      data.customName = this.GetCustomName(data.GetID());
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
