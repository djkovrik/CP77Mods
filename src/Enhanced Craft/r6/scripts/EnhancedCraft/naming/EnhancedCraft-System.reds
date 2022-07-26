module EnhancedCraft.System
import EnhancedCraft.Common.*

// -- Custom scriptable system which controls custom weapon names persistence

public class EnhancedCraftSystem extends ScriptableSystem {

  private persistent let m_nameRecords: array<ref<CustomCraftNameDataPS>>;

  private persistent let m_damageRecords: array<ref<DamageTypeStatsPS>>;

  private let m_inventoryManager: ref<InventoryDataManagerV2>;

  private let m_player: wref<PlayerPuppet>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    L(s"Persisted data loaded, stored names: \(ToString(ArraySize(this.m_nameRecords)))");
    L(s"Persisted data loaded, stored damage: \(ToString(ArraySize(this.m_damageRecords)))");
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.m_player = player;
      this.m_inventoryManager = new InventoryDataManagerV2();
      this.m_inventoryManager.Initialize(this.m_player);
      L("Inventory manager initialzied");
      this.RefreshData();
    };
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<EnhancedCraftSystem> {
    let system: ref<EnhancedCraftSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"EnhancedCraft.System.EnhancedCraftSystem") as EnhancedCraftSystem;
    return system;
  }

  public func RefreshData() -> Void {
    this.RefreshStoredNames();
    this.RefreshStoredDamages();
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

  // -- Saves custom damage type
  public func AddCustomDamageType(itemId: ItemID, stats: ref<DamageTypeStats>) -> Void {
    let persistedRecords: array<ref<DamageTypeStatsPS>> = this.m_damageRecords;
    let newRecord: ref<DamageTypeStatsPS> = DamageTypeStats.GetPS(itemId, stats);
    ArrayPush(persistedRecords, newRecord);
    this.m_damageRecords = persistedRecords;
    L(s"Damage type \(IntEnum<gamedataDamageType>(newRecord.type)) persisted for id \(newRecord.id), damage \(newRecord.damage) (\(newRecord.minDamage) - \(newRecord.maxDamage)) \(newRecord.percentDamage) %");
    L(s"Total persisted damage records: \(ArraySize(this.m_damageRecords))");
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

  // -- Checks if item has custom damageStats persisted
  public func HasCustomDamageStats(itemId: ItemID) -> Bool {
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    for record in this.m_damageRecords {
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

  // -- Returns custom damage stats by ItemID
  public func GetCustomDamageStats(itemId: ItemID) -> ref<DamageTypeStats> {
    let id: Uint64 = ItemID.GetCombinedHash(itemId);
    let newStats: ref<DamageTypeStats>;
    for record in this.m_damageRecords {
      if Equals(record.id, id) {
        newStats = DamageTypeStatsPS.GetNormal(record);
      };
    };
    return newStats;
  }

  // -- Deletes persisted name record
  private func DeleteStoredNameRecord(id: Uint64) -> Void {
    let persistedRecords: array<ref<CustomCraftNameDataPS>> = this.m_nameRecords;
    let index: Int32 = 0;
    for record in this.m_nameRecords {
      if Equals(record.id, id) {
        ArrayErase(persistedRecords, index);
        L(s" - deleted \(record.name)");
      };
      index += 1;
    };

    this.m_nameRecords = persistedRecords;
    L(s"Persisted name record \(id) deleted, total persisted records: \(ArraySize(this.m_nameRecords))");
  }

  // -- Deletes persisted damage record
  private func DeleteStoredDamageRecord(id: Uint64) -> Void {
    let persistedRecords: array<ref<DamageTypeStatsPS>> = this.m_damageRecords;
    let index: Int32 = 0;
    for record in this.m_damageRecords {
      if Equals(record.id, id) {
        ArrayErase(persistedRecords, index);
        L(s" - deleted \(record.id)");
      };
      index += 1;
    };

    this.m_damageRecords = persistedRecords;
    L(s"Persisted damage record \(id) deleted, total persisted records: \(ArraySize(this.m_damageRecords))");
  }

  // -- Iterates through player inventory, checks if custom named item still exists
  //    and then assigns custom names to gameItemData
  private func RefreshStoredNames() -> Void {
    let persistedRecords: array<ref<CustomCraftNameDataPS>> = this.m_nameRecords;
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;
    let inventoryHashes: array<Uint64>;

    this.m_inventoryManager.GetPlayerItemsIDsByCategory(gamedataItemCategory.Weapon, playerItems);
    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, playerItemsData);
    this.GetInventoryHashes(playerItems, inventoryHashes);
    L(s"RefreshStoredNames: player weapons detected: \(ArraySize(playerItems))");

    // Iterate through saved hashes and check if inventory has the same
    if ArraySize(inventoryHashes) > 0 {
      for record in persistedRecords {
        if this.HasInInventory(inventoryHashes, record.id) {
          L(s"- \(record.id) detected as \(record.name), keep it");
        } else {
          L(s"- \(record.id) not detected, deleting persistent record...");
          this.DeleteStoredNameRecord(record.id);
        };
      };
    };

    // Iterate through player weapons and assign custom names
    for data in playerItemsData {
      data.hasCustomName = this.HasCustomName(data.GetID());
      data.customName = this.GetCustomName(data.GetID());
    };
  }


  // -- Iterates through player inventory, checks if custom damage item still exists
  //    and then assigns custom damage to gameItemData
  private func RefreshStoredDamages() -> Void {
    let persistedRecords: array<ref<DamageTypeStatsPS>> = this.m_damageRecords;
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;
    let inventoryHashes: array<Uint64>;

    this.m_inventoryManager.GetPlayerItemsIDsByCategory(gamedataItemCategory.Weapon, playerItems);
    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, playerItemsData);
    this.GetInventoryHashes(playerItems, inventoryHashes);
    L(s"RefreshStoredDamages: player weapons detected: \(ArraySize(playerItems))");

    // Iterate through saved hashes and check if inventory has the same
    if ArraySize(inventoryHashes) > 0 {
      for record in persistedRecords {
        if this.HasInInventory(inventoryHashes, record.id) {
          L(s"- \(record.id) detected as \(record.id), keep it");
        } else {
          L(s"- \(record.id) not detected, deleting persistent record...");
          this.DeleteStoredDamageRecord(record.id);
        };
      };
    };

    // Iterate through player weapons and assign custom damage
    let hasCustomDamage: Bool;
    let customDamage: ref<DamageTypeStats>;
    for data in playerItemsData {
      hasCustomDamage = this.HasCustomDamageStats(data.GetID());
      if hasCustomDamage {
        customDamage = this.GetCustomDamageStats(data.GetID());
        this.m_player.RestorePersistedDamageType(data, customDamage);
      };
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
