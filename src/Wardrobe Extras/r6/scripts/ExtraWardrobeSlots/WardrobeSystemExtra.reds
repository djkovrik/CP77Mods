import ExtraWardrobeSlots.Utils.W

// -- Wrapper class which mostly replaces default WardrobeSystem system

public final class WardrobeSystemExtra extends ScriptableSystem {

  private let player: wref<PlayerPuppet>;

  private let originalSystem: ref<WardrobeSystem>;

  private persistent let activeSetIndex: gameWardrobeClothingSetIndexExtra = gameWardrobeClothingSetIndexExtra.INVALID;

  private persistent let clothingSets: array<ref<ClothingSetExtra>>;

  private persistent let blacklist: array<ItemID>;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      this.player = player;
      this.originalSystem = GameInstance.GetWardrobeSystem(this.player.GetGame());
      W(s"WardrobeSystemExtra initialized: current slot: \(this.activeSetIndex), current sets: \(ArraySize(this.clothingSets))");
    };
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<WardrobeSystemExtra> {
    let system: ref<WardrobeSystemExtra> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"WardrobeSystemExtra") as WardrobeSystemExtra;
    return system;
  }

  public final func GetStoredItemID(item: TweakDBID) -> ItemID {
    return this.originalSystem.GetStoredItemID(item);
  }

  public final func StoreUniqueItemID(itemID: ItemID) -> Bool {
    return this.originalSystem.StoreUniqueItemID(itemID);
  }

  public final func GetStoredItemIDs() -> array<ItemID> {
    return this.originalSystem.GetStoredItemIDs();
  }

  public final func GetFilteredStoredItemIDs(equipmentArea: gamedataEquipmentArea) -> array<ItemID> {
    let base: array<ItemID> = this.originalSystem.GetFilteredStoredItemIDs(equipmentArea);
    let result: array<ItemID>;

    for id in base {
      if !ArrayContains(this.blacklist, id) {
        ArrayPush(result, id);
      } else {
        W(s"Item \(ItemID.GetCombinedHash(id)) was blacklisted, skip");
      };
    };

    return result;
  }

  public final func GetFilteredInventoryItemsData(equipmentArea: gamedataEquipmentArea, inventoryItemDataV2: ref<IScriptable>) -> array<InventoryItemData> {
    let base: array<InventoryItemData> = this.originalSystem.GetFilteredInventoryItemsData(equipmentArea, inventoryItemDataV2);
    let result: array<InventoryItemData>;
    let itemId: ItemID;
    for item in base {
      itemId = InventoryItemData.GetID(item);
      if !ArrayContains(this.blacklist, itemId) {
        ArrayPush(result, item);
      } else {
        W(s"Item \(ItemID.GetCombinedHash(itemId)) was blacklisted, skip");
      };
    };

    return result;
  }

  public final func IsItemBlacklisted(itemID: ItemID) -> Bool {
    return this.originalSystem.IsItemBlacklisted(itemID);
  }

  public final func WasItemBlacklisted(itemID: ItemID) -> Bool {
    return ArrayContains(this.blacklist, itemID);
  }

  public final func AddToBlacklist(itemID: ItemID) -> Void {
    let current: array<ItemID> = this.blacklist;
    ArrayPush(current, itemID);
    this.blacklist = current;
  }

  public final func PushBackClothingSet(clothingSet: ref<ClothingSetExtra>) -> Void {
    let currentSets: array<ref<ClothingSetExtra>> = this.clothingSets;
    ArrayPush(currentSets, clothingSet);
    this.clothingSets = currentSets;
  }

  public final func DeleteClothingSet(setIndex: gameWardrobeClothingSetIndexExtra) -> Void {
    let currentSets: array<ref<ClothingSetExtra>> = this.clothingSets;
    let resultingSets: array<ref<ClothingSetExtra>>;
    
    for current in currentSets {
      if NotEquals(current.setID, setIndex) {
        ArrayPush(resultingSets, current);
      };
    };

    this.clothingSets = resultingSets;
  }

  public final func GetClothingSets() -> array<ref<ClothingSetExtra>> {
    return this.clothingSets;
  }

  public final func SetActiveClothingSetIndex(slotIndex: gameWardrobeClothingSetIndexExtra) -> Void {
    this.activeSetIndex = slotIndex;
  }

  public final func GetActiveClothingSetIndex() -> gameWardrobeClothingSetIndexExtra {
    return this.activeSetIndex;
  }

  public final func GetActiveClothingSet() -> ref<ClothingSetExtra> {
    let currentSets: array<ref<ClothingSetExtra>> = this.clothingSets;
    
    for current in currentSets {
      if Equals(current.setID, this.activeSetIndex) {
        return current;
      };
    };

    return null;
  }

  public final func StoreUniqueItemIDAndMarkNew(gameInstance: GameInstance, itemID: ItemID) -> Bool {
    let success: Bool = this.StoreUniqueItemID(itemID);
    if success {
      WardrobeSystem.SendWardrobeAddItemRequest(gameInstance, itemID);
    };
    return success;
  }

  public final static func WardrobeClothingSetIndexToNumber(slotIndex: gameWardrobeClothingSetIndexExtra) -> Int32 {
    switch slotIndex {
      case gameWardrobeClothingSetIndexExtra.Slot1: return 0;
      case gameWardrobeClothingSetIndexExtra.Slot2: return 1;
      case gameWardrobeClothingSetIndexExtra.Slot3: return 2;
      case gameWardrobeClothingSetIndexExtra.Slot4: return 3;
      case gameWardrobeClothingSetIndexExtra.Slot5: return 4;
      case gameWardrobeClothingSetIndexExtra.Slot6: return 5;
      case gameWardrobeClothingSetIndexExtra.Slot7: return 6;
      case gameWardrobeClothingSetIndexExtra.Slot8: return 7;
      case gameWardrobeClothingSetIndexExtra.Slot9: return 8;
      case gameWardrobeClothingSetIndexExtra.Slot10: return 9;
      case gameWardrobeClothingSetIndexExtra.Slot11: return 10;
      case gameWardrobeClothingSetIndexExtra.Slot12: return 11;
      case gameWardrobeClothingSetIndexExtra.Slot13: return 12;
      case gameWardrobeClothingSetIndexExtra.Slot14: return 13;
      default: return -1;
    };
    return -1;
  }

  public final static func NumberToWardrobeClothingSetIndex(number: Int32) -> gameWardrobeClothingSetIndexExtra {
    switch number {
      case 0: return gameWardrobeClothingSetIndexExtra.Slot1;
      case 1: return gameWardrobeClothingSetIndexExtra.Slot2;
      case 2: return gameWardrobeClothingSetIndexExtra.Slot3;
      case 3: return gameWardrobeClothingSetIndexExtra.Slot4;
      case 4: return gameWardrobeClothingSetIndexExtra.Slot5;
      case 5: return gameWardrobeClothingSetIndexExtra.Slot6;
      case 6: return gameWardrobeClothingSetIndexExtra.Slot7;
      case 7: return gameWardrobeClothingSetIndexExtra.Slot8;
      case 8: return gameWardrobeClothingSetIndexExtra.Slot9;
      case 9: return gameWardrobeClothingSetIndexExtra.Slot10;
      case 10: return gameWardrobeClothingSetIndexExtra.Slot11;
      case 11: return gameWardrobeClothingSetIndexExtra.Slot12;
      case 12: return gameWardrobeClothingSetIndexExtra.Slot13;
      case 13: return gameWardrobeClothingSetIndexExtra.Slot14;
      default: return gameWardrobeClothingSetIndexExtra.INVALID;
    };
    return gameWardrobeClothingSetIndexExtra.INVALID;
  }

  public final static func SendWardrobeAddItemRequest(gameInstance: GameInstance, itemID: ItemID) -> Void {
    let request: ref<UIScriptableSystemWardrobeAddItem> = new UIScriptableSystemWardrobeAddItem();
    request.itemID = itemID;
    UIScriptableSystem.GetInstance(gameInstance).QueueRequest(request);
  }

  public final static func SendWardrobeInspectItemRequest(gameInstance: GameInstance, itemID: ItemID) -> Void {
    let request: ref<UIScriptableSystemWardrobeInspectItem> = new UIScriptableSystemWardrobeInspectItem();
    request.itemID = itemID;
    UIScriptableSystem.GetInstance(gameInstance).QueueRequest(request);
  }

  public func MigrateOldWardrobe() -> Void {
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.player.GetGame());
    let factName: CName = n"ews_wardrobe_migrated";
    let oldSets: array<ref<ClothingSet>> = this.originalSystem.GetClothingSets();
    let lastActiveSlot: gameWardrobeClothingSetIndex = this.originalSystem.GetActiveClothingSetIndex();
    let wardrobeMigratedFact: Int32 = questsSystem.GetFact(factName);
    if ArraySize(oldSets) > 0 && NotEquals(lastActiveSlot, gameWardrobeClothingSetIndex.INVALID) && Equals(wardrobeMigratedFact, 0) {
      questsSystem.SetFact(factName, 1);
      this.MigrateOldSetIndex(lastActiveSlot);
      this.MigrateOldClothingSets(oldSets);
      EquipmentSystem.GetData(this.player).EquipWardrobeSetExtra(this.GetActiveClothingSetIndex());
      W(s"Migrated old sets: \(ArraySize(oldSets))");
    };
  }

  private func MigrateOldSetIndex(index: gameWardrobeClothingSetIndex) -> Void {
    let newIndex: gameWardrobeClothingSetIndexExtra = this.ToExtraIndex(index);
    this.SetActiveClothingSetIndex(newIndex);
  }

  private func MigrateOldClothingSets(sets: array<ref<ClothingSet>>) -> Void {
    let newSet: ref<ClothingSetExtra>;
    for set in sets {
      newSet = this.ToExtraSet(set);
      this.PushBackClothingSet(newSet);
    };
  }

  private func ToExtraIndex(index: gameWardrobeClothingSetIndex) -> gameWardrobeClothingSetIndexExtra {
    switch (index) {
      case gameWardrobeClothingSetIndex.Slot1: return gameWardrobeClothingSetIndexExtra.Slot1;
      case gameWardrobeClothingSetIndex.Slot2: return gameWardrobeClothingSetIndexExtra.Slot2;
      case gameWardrobeClothingSetIndex.Slot3: return gameWardrobeClothingSetIndexExtra.Slot3;
      case gameWardrobeClothingSetIndex.Slot4: return gameWardrobeClothingSetIndexExtra.Slot4;
      case gameWardrobeClothingSetIndex.Slot5: return gameWardrobeClothingSetIndexExtra.Slot5;
      case gameWardrobeClothingSetIndex.Slot6: return gameWardrobeClothingSetIndexExtra.Slot6;
      default: return gameWardrobeClothingSetIndexExtra.INVALID;
    };

    return gameWardrobeClothingSetIndexExtra.INVALID;
  }

  private func ToExtraSet(oldSet: ref<ClothingSet>) -> ref<ClothingSetExtra> {
    let set: ref<ClothingSetExtra> = new ClothingSetExtra();
    set.setID = this.ToExtraIndex(oldSet.setID);
    set.clothingList = oldSet.clothingList;
    set.iconID = oldSet.iconID;
    return set;
  }
}
