module EnhancedCraft.System
import EnhancedCraft.Config.ECraftConfig
import EnhancedCraft.Common.*

// -- Custom scriptable system which controls custom weapon names persistence

public class EnhancedCraftSystem extends ScriptableSystem {

  private persistent let m_nameRecords: array<ref<CustomCraftNameDataPS>>;

  private persistent let m_damageRecords: array<ref<DamageTypeStatsPS>>;

  private let m_inventoryManager: ref<InventoryDataManagerV2>;

  private let m_player: wref<PlayerPuppet>;

  private let m_config: ref<ECraftConfig>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    L(s"Persisted data loaded, stored names: \(ToString(ArraySize(this.m_nameRecords)))");
    L(s"Persisted data loaded, stored damage: \(ToString(ArraySize(this.m_damageRecords)))");
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.m_player = player;
      this.m_inventoryManager = new InventoryDataManagerV2();
      this.m_inventoryManager.Initialize(this.m_player);
      L("Inventory manager initialzied");
      this.RefreshPlayerInventory();
    };
    this.m_config = new ECraftConfig();
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

    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, playerItemsData);
    this.GetItemsIdsFromGameData(playerItemsData, playerItems);
   
    L(s"RefreshPlayerInventory: player weapons detected: \(ArraySize(playerItems))");
    this.RefreshNamesAndDamages(playerItemsData, false);
  }

  public func RefreshPlayerInventoryAndStash(storageItems: array<ref<gameItemData>>) -> Void {
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;

    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, playerItemsData);
    this.GetItemsIdsFromGameData(playerItemsData, playerItems);

    // Add storage items into gamedata array
    for item in storageItems {
      ArrayPush(playerItemsData, item);
    };

    L(s"RefreshPlayerInventoryAndStash: player weapons detected: \(ArraySize(playerItems))");
    this.RefreshNamesAndDamages(playerItemsData, true);
  }

  public func RefreshSingleItem(itemData: ref<gameItemData>) -> Void {
    let hasCustomName: Bool = this.HasCustomName(itemData.GetID());
    let hasCustomDamage: Bool = this.HasCustomDamageStats(itemData.GetID());
    let customDamage: ref<DamageTypeStats>;

    if hasCustomName {
      itemData.hasCustomName = this.HasCustomName(itemData.GetID());
      itemData.customName = this.GetCustomName(itemData.GetID());
    };

    if hasCustomDamage {
      customDamage = this.GetCustomDamageStats(itemData.GetID());
      this.m_player.RestorePersistedDamageType(itemData, customDamage);
    };

    L(s"RefreshSingleItem \(ItemID.GetCombinedHash(itemData.GetID())), name: \(hasCustomName), damage: \(hasCustomDamage)");
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

  private func GetConfig() -> ref<ECraftConfig> {
    return this.m_config;
  }

  // -- MISC

  // -- Refresh data in target items array
  private func RefreshNamesAndDamages(items: array<ref<gameItemData>>, shouldClean: Bool) -> Void {
    let playerItems: array<ItemID>;
    let playerItemsData: array<ref<gameItemData>>;

    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, playerItemsData);
    this.GetItemsIdsFromGameData(playerItemsData, playerItems);
    L(s"RefreshStoredNames: player weapons detected: \(ArraySize(playerItems))");

    // Iterate through player weapons and assign custom names
    for data in playerItemsData {
      data.hasCustomName = this.HasCustomName(data.GetID());
      data.customName = this.GetCustomName(data.GetID());
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

    if shouldClean {
      this.ClearUnusedRecords(items);
    };
  }

  // Iterate through persisted records and clean unsused
  private func ClearUnusedRecords(items: array<ref<gameItemData>>) -> Void {
    L("Cleaning unused records...");
    let persistedNameRecords: array<ref<CustomCraftNameDataPS>> = this.m_nameRecords;
    let persistedDamageRecords: array<ref<DamageTypeStatsPS>> = this.m_damageRecords;
    let commonItemIds: array<ItemID>;
    let commonItemHashes: array<Uint64>;

    this.m_inventoryManager.GetPlayerItemsDataByCategory(gamedataItemCategory.Weapon, items);
    // Check all
    this.GetItemsIdsFromGameData(items, commonItemIds);
    this.GetInventoryHashes(commonItemIds, commonItemHashes);

    if ArraySize(commonItemHashes) > 0 {
      for record in persistedNameRecords {
        if this.HasInInventory(commonItemHashes, record.id) {
          L(s"- name record \(record.id) detected as \(record.name), keep it");
        } else {
          L(s"- name record \(record.id) not detected, deleting persistent record...");
          this.DeleteStoredNameRecord(record.id);
        };
      };
      for record in persistedDamageRecords {
        if this.HasInInventory(commonItemHashes, record.id) {
          L(s"- damage record \(record.id) detected, keep it");
        } else {
          L(s"- damage record \(record.id) not detected, deleting persistent record...");
          this.DeleteStoredDamageRecord(record.id);
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

  // -- Deletes persisted damage record
  private func DeleteStoredDamageRecord(id: Uint64) -> Void {
    let persistedRecords: array<ref<DamageTypeStatsPS>> = this.m_damageRecords;
    let index: Int32 = 0;
    for record in this.m_damageRecords {
      if Equals(record.id, id) {
        ArrayErase(persistedRecords, index);
        L(s" - damage record deleted \(record.id)");
      };
      index += 1;
    };

    this.m_damageRecords = persistedRecords;
    L(s"Persisted damage record \(id) deleted, total persisted records: \(ArraySize(this.m_damageRecords))");
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
