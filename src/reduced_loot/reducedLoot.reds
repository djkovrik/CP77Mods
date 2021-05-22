// --- Reduced Loot --- 
public class ReducedLootConfig {

  // --- Here you can enable or disable the mod for global loot sources
  //     Replace true with false to prevent loot removal for category
  public static func EnableForContainers() -> Bool = true
  public static func EnableForNPCs() -> Bool = true
  public static func EnableForWorld() -> Bool = true

  // --- Enable or disable held weapon drop for NPCs
  public static func AllowHeldWeaponDrop() -> Bool = false

  // --- Category checks for containers, NPCs and world loot objects
  //     Replace false with true to enable loot category or vice versa
  // --- IMPORTANT: disallowing Shards may break some minor quests 
  //     like Assault in Progress so do it at your own risk!
  public static func AllowAmmo() -> Bool = false
  public static func AllowClothing() -> Bool = true
  public static func AllowCraftingMaterials() -> Bool = false
  public static func AllowCyberware() -> Bool = false
  public static func AllowEdibles() -> Bool = false
  public static func AllowGrenades() -> Bool = false
  public static func AllowHealings() -> Bool = false
  public static func AllowJunk() -> Bool = false
  public static func AllowMods() -> Bool = false
  public static func AllowMoney() -> Bool = false
  public static func AllowSchematics() -> Bool = false
  public static func AllowShards() -> Bool = true
  public static func AllowScripts() -> Bool = false
  public static func AllowSkillBooks() -> Bool = true
  public static func AllowWeapons() -> Bool = true

  // --- Quality checks
  //     Additionaly applied to all clothing and weapons checks
  public static func AllowLegendary() -> Bool = true
  public static func AllowIconic() -> Bool = true
  public static func AllowEpic() -> Bool = true
  public static func AllowRare() -> Bool = false
  public static func AllowUncommon() -> Bool = false
  public static func AllowCommon() -> Bool = false
}

//  --- Do not edit anything below!


// Checks
public static func IsQualityAllowed_L(data: ref<gameItemData>) -> Bool {
  if RPGManager.IsItemDataIconic(data) {
    return ReducedLootConfig.AllowIconic();
  };

  let quality: gamedataQuality = RPGManager.GetItemDataQuality(data);
  switch quality {
    case gamedataQuality.Legendary: return ReducedLootConfig.AllowLegendary();
    case gamedataQuality.Iconic: return ReducedLootConfig.AllowIconic();
    case gamedataQuality.Epic: return ReducedLootConfig.AllowEpic();
    case gamedataQuality.Rare: return ReducedLootConfig.AllowRare();
    case gamedataQuality.Uncommon: return ReducedLootConfig.AllowUncommon();
    case gamedataQuality.Common: return ReducedLootConfig.AllowCommon();
  };

  return true;
}

public static func IsMoney_L(data: ref<gameItemData>) -> Bool {
  return Equals(data.GetID(), ItemID.FromTDBID(t"Items.money"));
}

public static func IsClothing_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue >= 0 && typeValue <= 6;
}

public static func IsAmmo_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 7;
}

public static func IsEdible_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 8 || typeValue == 11;
}

public static func IsHealing_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 9 || typeValue == 10;
}

public static func IsSkillBook_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 12;
}

public static func IsCyberware_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue >= 13 && typeValue <= 17;
}

public static func IsGrenade_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 22;
}

public static func IsCraftingMat_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 23;
}

public static func IsJunk_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue >= 24 && typeValue <= 27 && !IsMoney_L(data);
}

public static func IsShard_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 28 && !data.HasTag(n"Quest");
}

public static func IsMod_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue >= 29 && typeValue <= 42 && typeValue != 37;
}

public static func IsSchematics_L(data: ref<gameItemData>) -> Bool {
  return data.HasTag(n"Recipe");
}

public static func IsScript_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue == 37;
}

public static func IsWeapon_L(data: ref<gameItemData>) -> Bool {
  let type: gamedataItemType = data.GetItemType();
  let typeValue: Int32 = GetItemTypeValue(type);
  return typeValue >= 43 && typeValue <= 62;
}

// Base checker here
public static func CanLootThis(data: ref<gameItemData>) -> Bool {
  LootLog("! checking " + UIItemsHelper.GetItemTypeKey(data.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(data)) + " " + IntToString(data.GetQuantity()));

  // Always enabled
  if data.HasTag(n"Quest") || data.HasTag(n"Cyberdeck") { 
    return true; 
  };

  // Config checks
  if IsClothing_L(data) { return ReducedLootConfig.AllowClothing() && IsQualityAllowed_L(data); }
  if IsWeapon_L(data) { return ReducedLootConfig.AllowWeapons() && IsQualityAllowed_L(data); }
  if IsSchematics_L(data) { return ReducedLootConfig.AllowSchematics(); }
  if IsAmmo_L(data) { return ReducedLootConfig.AllowAmmo(); }
  if IsEdible_L(data) { return ReducedLootConfig.AllowEdibles(); }
  if IsCyberware_L(data) { return ReducedLootConfig.AllowCyberware(); }
  if IsGrenade_L(data) { return ReducedLootConfig.AllowGrenades(); }
  if IsHealing_L(data) { return ReducedLootConfig.AllowHealings(); }
  if IsCraftingMat_L(data) { return ReducedLootConfig.AllowCraftingMaterials(); }
  if IsJunk_L(data) { return ReducedLootConfig.AllowJunk(); }
  if IsMod_L(data) { return ReducedLootConfig.AllowMods(); }
  if IsMoney_L(data) { return ReducedLootConfig.AllowMoney(); }
  if IsScript_L(data) { return ReducedLootConfig.AllowScripts(); }
  if IsSkillBook_L(data) { return ReducedLootConfig.AllowSkillBooks(); }
  if IsShard_L(data) { return ReducedLootConfig.AllowShards(); }
  
  // true for the rest to check what types are not covered yet
  return true;
}

// Exclusion list for quests when world objects should be kept
public static func KeepWorldPlacedForQuest_L(objectiveId: String) -> Bool {
  return 
    Equals(objectiveId, "01a_pick_weapon") ||
    Equals(objectiveId, "01c_pick_up_reanimator") ||
    Equals(objectiveId, "03_pick_up_katana") ||

  false;
}

// CONTAINERS

@addMethod(gameLootContainerBase)
private func EvaluateLoot() -> Void {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let items: array<wref<gameItemData>>;
  let item: wref<gameItemData>;
  let i: Int32 = 0;

  if transactionSystem.GetItemList(this, items) {
    while i < ArraySize(items) {
      item = items[i];

      if CanLootThis(item) {
        LootLog("+ kept for container " + UIItemsHelper.GetItemTypeKey(item.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(item)));
      } else {
        LootLog("- removed for container " + UIItemsHelper.GetItemTypeKey(item.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(item)));
        transactionSystem.RemoveItem(this, item.GetID(), item.GetQuantity());
      };
      i += 1;
    };
  };
}

@replaceMethod(gameLootContainerBase)
protected cb func OnEvaluateLootQuality(evt: ref<EvaluateLootQualityEvent>) -> Bool {
  if ReducedLootConfig.EnableForContainers() {
    this.EvaluateLoot();
  };
  this.EvaluateLootQuality();
  this.RequestHUDRefresh();
}


// NPCS
@addMethod(ScriptedPuppet)
private func EvaluateLoot() -> Void {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let items: array<wref<gameItemData>>;
  let item: wref<gameItemData>;
  let i: Int32 = 0;

  if transactionSystem.GetItemList(this, items) {
    while i < ArraySize(items) {
      item = items[i];
      if !CanLootThis(item) {
        LootLog("- removed for npc " + UIItemsHelper.GetItemTypeKey(item.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(item)));
        transactionSystem.RemoveItem(this, item.GetID(), item.GetQuantity());
      } else {
        LootLog("+ kept for npc " + UIItemsHelper.GetItemTypeKey(item.GetItemType()) + " " +UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(item)));
      };
      i += 1;
    };
  };
}

@replaceMethod(ScriptedPuppet)
protected cb func OnEvaluateLootQuality(evt: ref<EvaluateLootQualityEvent>) -> Bool {
  if ReducedLootConfig.EnableForNPCs() {
    this.EvaluateLoot();
  };
  this.EvaluateLootQuality();
  this.RequestHUDRefresh();
}

@replaceMethod(ScriptedPuppet)
public final static func ProcessLoot(self: wref<ScriptedPuppet>) -> Void {
  let ammoAmount: Int32;
  let ammoToDrop: array<TweakDBID>;
  let blockRequest: ref<BlockAmmoDrop>;
  let i: Int32;
  let inventory: array<wref<gameItemData>>;
  let isBroken: Bool;
  let itemTDBID: TweakDBID;
  let lootModifiers: array<ref<gameStatModifierData>>;
  let rand: Float;
  let tempStat: Float;
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(self.GetGame());
  let record: wref<Character_Record> = TweakDBInterface.GetCharacterRecord(self.GetRecordID());
  // let canDropWeapon: Bool = record.DropsWeaponOnDeath();
  // Check for weapon drop here
  let canDropWeapon: Bool = record.DropsWeaponOnDeath() && ReducedLootConfig.AllowHeldWeaponDrop();
  let canDropAmmo: Bool = record.DropsAmmoOnDeath();
  let dropMoney: Bool = record.DropsMoneyOnDeath();
  let foundEquipment: array<ref<gameItemData>> = ScriptedPuppet.GetEquipment(self);
  let heldMoney: Int32 = TS.GetItemQuantity(self, MarketSystem.Money());
  ScriptedPuppet.GenerateLootModifiers(self, lootModifiers);
  self.GenerateLootWithStats(lootModifiers);
  if self.IsLooted() {
    return ;
  };
  if self.IsCrowd() {
    return ;
  };
  if dropMoney {
    TS.GiveItem(self, MarketSystem.Money(), heldMoney);
  };
  if canDropWeapon {
    i = 0;
    while i < ArraySize(foundEquipment) {
      RPGManager.SetDroppedWeaponQuality(self, foundEquipment[i]);
      isBroken = RPGManager.BreakItem(self.GetGame(), self, foundEquipment[i].GetID());
      if !isBroken {
        ScriptedPuppet.ScaleDroppedItem(foundEquipment[i], self);
        TS.GiveItemByItemData(self, foundEquipment[i]);
      };
      i += 1;
    };
  };
  if canDropAmmo {
    ammoToDrop = PlayerHandicapSystem.GetInstance(self).GetHandicapAmmo();
    if ArraySize(ammoToDrop) > 0 {
      blockRequest = new BlockAmmoDrop();
      PlayerHandicapSystem.GetInstance(self).QueueRequest(blockRequest);
    };
    i = 0;
    while i < ArraySize(foundEquipment) {
      itemTDBID = RPGManager.GetWeaponAmmoTDBID(foundEquipment[i].GetID());
      if TDBID.IsValid(itemTDBID) {
        ArrayPush(ammoToDrop, itemTDBID);
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(ammoToDrop) {
      switch ammoToDrop[i] {
        case t"Ammo.SniperRifleAmmo":
          ammoAmount = RandRange(5, 20);
          break;
        case t"Ammo.HandgunAmmo":
          ammoAmount = RandRange(20, 40);
          break;
        case t"Ammo.RifleAmmo":
          ammoAmount = RandRange(30, 60);
          break;
        case t"Ammo.ShotgunAmmo":
          ammoAmount = RandRange(10, 25);
          break;
        default:
          ammoAmount = 0;
      };
      if ammoAmount > 0 {
        TS.GiveItemByTDBID(self, ammoToDrop[i], ammoAmount);
        if ReducedLootConfig.EnableForNPCs() {
          if ReducedLootConfig.AllowAmmo() {
            self.DropAmmo();
          };
        } else {
          self.DropAmmo();
        };
      };
      i += 1;
    };
  };
  if Equals(record.CharacterType().Type(), gamedataNPCType.Human) && self.IsHostile() {
    ScriptedPuppet.ProcessSupportiveItems(self);
  };
  if ScriptedPuppet.IsMechanical(self) {
    rand = RandF();
    tempStat = GameInstance.GetStatsSystem(self.GetGame()).GetStatValue(Cast(GetPlayer(self.GetGame()).GetEntityID()), gamedataStatType.ScrapItemChance);
    if tempStat >= rand {
      GameInstance.GetTransactionSystem(self.GetGame()).GiveItemByItemQuery(self, t"Query.GrenadeNoFaction", 1u, 1u);
    };
  };
  if ScriptedPuppet.HasLootableItems(self) {
    ScriptedPuppet.EvaluateLootQuality(self);
  };
  self.CacheLootForDroping();
}

@replaceMethod(ScriptedPuppet)
public final static func DropHeldItems(self: wref<ScriptedPuppet>) -> Bool {
  if !ReducedLootConfig.AllowHeldWeaponDrop() {
    return false;
  };

  let canDrop: Bool;
  let canLeftItemDrop: Bool;
  let canRightItemDrop: Bool;
  let isBroken: Bool;
  let leftItem: wref<ItemObject>;
  let result: Bool;
  let rightItem: wref<ItemObject>;
  let slot: TweakDBID;
  if !IsDefined(self) {
    return false;
  };
  canDrop = TweakDBInterface.GetCharacterRecord(self.GetRecordID()).DropsWeaponOnDeath();
  if canDrop {
    slot = t"AttachmentSlots.WeaponRight";
    rightItem = GameInstance.GetTransactionSystem(self.GetGame()).GetItemInSlot(self, slot);
    canRightItemDrop = IsDefined(rightItem) && IsNameValid(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(rightItem.GetItemID())).DropObject());
    slot = t"AttachmentSlots.WeaponLeft";
    leftItem = GameInstance.GetTransactionSystem(self.GetGame()).GetItemInSlot(self, slot);
    canLeftItemDrop = IsDefined(leftItem) && IsNameValid(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(leftItem.GetItemID())).DropObject());
    if canLeftItemDrop || canRightItemDrop {
      self.DropWeapons();
      if IsDefined(rightItem) {
        ScriptedPuppet.ScaleDroppedItem(rightItem.GetItemData(), self);
        result = true;
      };
      if IsDefined(leftItem) {
        ScriptedPuppet.ScaleDroppedItem(leftItem.GetItemData(), self);
        result = true;
      };
      return true;
    };
    return false;
  };
  return false;
}

@replaceMethod(ScriptedPuppet)
public final static func DropItemFromSlot(obj: wref<GameObject>, slot: TweakDBID) -> Void {
  if !ReducedLootConfig.AllowHeldWeaponDrop() {
    return ;
  };

  let item: wref<ItemObject>;
  let itemInSlotID: ItemID;
  if !IsDefined(obj) {
    return ;
  };
  item = GameInstance.GetTransactionSystem(obj.GetGame()).GetItemInSlot(obj, slot);
  if IsDefined(item) {
    itemInSlotID = item.GetItemData().GetID();
  };
  if IsDefined(item) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Wea_Fists) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Cyb_StrongArms) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Cyb_MantisBlades) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Cyb_NanoWires) {
    (obj as ScriptedPuppet).DropWeapons();
  };
}

@replaceMethod(ScriptedPuppet)
public final static func DropWeaponFromSlot(obj: wref<GameObject>, slot: TweakDBID) -> Void {
  if !ReducedLootConfig.AllowHeldWeaponDrop() {
    return ;
  }

  let isBroken: Bool;
  let item: wref<ItemObject>;
  if !IsDefined(obj) {
    return ;
  };
  item = GameInstance.GetTransactionSystem(obj.GetGame()).GetItemInSlot(obj, slot);
  if IsDefined(item) {
    isBroken = RPGManager.BreakItem(obj.GetGame(), obj, item.GetItemID());
    if !isBroken {
      (obj as ScriptedPuppet).DropWeapons();
    };
  };
}

// hack to remove extra added ammo
@replaceMethod(ScriptedPuppet)
protected cb func OnItemAddedEvent(evt: ref<ItemAddedEvent>) -> Bool {
  let data: ref<gameItemData> = evt.itemData;
  let transactionSystem: ref<TransactionSystem>;
  let quality: gamedataQuality;

  if ReducedLootConfig.EnableForNPCs() && !ReducedLootConfig.AllowAmmo() && IsAmmo_L(data) && !this.IsPlayer() {
    LootLog("Extra ammo detected! Removing...");
    transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
    transactionSystem.RemoveItem(this, data.GetID(), data.GetQuantity());
  };

  if this.HasValidLootQuality() {
    quality = this.m_lootQuality;
    this.EvaluateLootQuality();
    if NotEquals(quality, this.m_lootQuality) {
      this.RequestHUDRefresh();
    };
  };
}


// WORLD OBJECTS

@addField(PlayerPuppet)
public let m_preventDestroyingItemId_L: ItemID;

@addMethod(PlayerPuppet)
public func GetPreventedId_L() -> ItemID {
  return this.m_preventDestroyingItemId_L;
}

@addMethod(PlayerPuppet)
public func PreventDestroying_L(id: ItemID) -> Void {
  this.m_preventDestroyingItemId_L = id;
}

@replaceMethod(VendingMachine)
protected func CreateDispenseRequest(shouldPay: Bool, item: ItemID) -> ref<DispenseRequest> {
  let dispenseRequest: ref<DispenseRequest> = new DispenseRequest();
  dispenseRequest.owner = this;
  dispenseRequest.position = this.RandomizePosition();
  dispenseRequest.shouldPay = shouldPay;
  if ItemID.IsValid(item) {
    dispenseRequest.itemID = item;
    // Save vending item id to prevent removal
    GetPlayer(this.GetGame()).PreventDestroying_L(item);
  };
  return dispenseRequest;
}

@replaceMethod(gameItemDropObject)
protected final func OnItemEntitySpawned(entID: EntityID) -> Void {
  let playerPuppet: ref<PlayerPuppet>;
  let data: ref<gameItemData> = this.GetItemObject().GetItemData();
  let journalManager: wref<JournalManager>;
  let trackedObjective: wref<JournalQuestObjective>;
  let preventDestroying: Bool = false;
  let shouldKeepForQuest: Bool = false;

  if ReducedLootConfig.EnableForWorld() {
    playerPuppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(playerPuppet) {
      journalManager = GameInstance.GetJournalManager(playerPuppet.GetGame());
      trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
      preventDestroying = Equals(this.GetItemObject().GetItemID(), playerPuppet.GetPreventedId_L());
      shouldKeepForQuest = KeepWorldPlacedForQuest_L(trackedObjective.GetId());
      LootLog("!! Current quest objective: " + trackedObjective.GetId());
    };
    if CanLootThis(data) || preventDestroying || shouldKeepForQuest {
      LootLog("+ kept for world " + UIItemsHelper.GetItemTypeKey(data.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(data)));
    } else {
      LootLog("- removed from world " + UIItemsHelper.GetItemTypeKey(data.GetItemType()) + " " + UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(data)));
      EntityGameInterface.Destroy(this.GetEntity());
      return ;
    }
  };

  this.SetQualityRangeInteractionLayerState(true);
  this.EvaluateLootQualityEvent(entID);
  this.RequestHUDRefresh();
}


// UTILS
private final static func GetItemTypeValue(itemType: gamedataItemType) -> Int32 {
  switch itemType {
    case gamedataItemType.Clo_Face: return 0;
    case gamedataItemType.Clo_Feet: return 1;
    case gamedataItemType.Clo_Head: return 2;
    case gamedataItemType.Clo_InnerChest: return 3;
    case gamedataItemType.Clo_Legs: return 4;
    case gamedataItemType.Clo_OuterChest: return 5;
    case gamedataItemType.Clo_Outfit: return 6;
    case gamedataItemType.Con_Ammo: return 7;
    case gamedataItemType.Con_Edible: return 8;
    case gamedataItemType.Con_Inhaler: return 9;
    case gamedataItemType.Con_Injector: return 10;
    case gamedataItemType.Con_LongLasting: return 11;
    case gamedataItemType.Con_Skillbook: return 12;
    case gamedataItemType.Cyb_Ability: return 13;
    case gamedataItemType.Cyb_Launcher: return 14;
    case gamedataItemType.Cyb_MantisBlades: return 15;
    case gamedataItemType.Cyb_NanoWires: return 16;
    case gamedataItemType.Cyb_StrongArms: return 17;
    case gamedataItemType.Fla_Launcher: return 18;
    case gamedataItemType.Fla_Rifle: return 19;
    case gamedataItemType.Fla_Shock: return 20;
    case gamedataItemType.Fla_Support: return 21;
    case gamedataItemType.Gad_Grenade: return 22;
    case gamedataItemType.Gen_CraftingMaterial: return 23;
    case gamedataItemType.Gen_DataBank: return 24;
    case gamedataItemType.Gen_Junk: return 25;
    case gamedataItemType.Gen_Keycard: return 26;
    case gamedataItemType.Gen_Misc: return 27;
    case gamedataItemType.Gen_Readable: return 28;
    case gamedataItemType.GrenadeDelivery: return 29;
    case gamedataItemType.Grenade_Core: return 30;
    case gamedataItemType.Prt_Capacitor: return 31;
    case gamedataItemType.Prt_FabricEnhancer: return 32;
    case gamedataItemType.Prt_Fragment: return 33;
    case gamedataItemType.Prt_Magazine: return 34;
    case gamedataItemType.Prt_Mod: return 35;
    case gamedataItemType.Prt_Muzzle: return 36;
    case gamedataItemType.Prt_Program: return 37;
    case gamedataItemType.Prt_Receiver: return 38;
    case gamedataItemType.Prt_Scope: return 39;
    case gamedataItemType.Prt_ScopeRail: return 40;
    case gamedataItemType.Prt_Stock: return 41;
    case gamedataItemType.Prt_TargetingSystem: return 42;
    case gamedataItemType.Wea_AssaultRifle: return 43;
    case gamedataItemType.Wea_Fists: return 44;
    case gamedataItemType.Wea_Hammer: return 45;
    case gamedataItemType.Wea_Handgun: return 46;
    case gamedataItemType.Wea_HeavyMachineGun: return 47;
    case gamedataItemType.Wea_Katana: return 48;
    case gamedataItemType.Wea_Knife: return 49;
    case gamedataItemType.Wea_LightMachineGun: return 50;
    case gamedataItemType.Wea_LongBlade: return 51;
    case gamedataItemType.Wea_Melee: return 52;
    case gamedataItemType.Wea_OneHandedClub: return 53;
    case gamedataItemType.Wea_PrecisionRifle: return 54;
    case gamedataItemType.Wea_Revolver: return 55;
    case gamedataItemType.Wea_Rifle: return 56;
    case gamedataItemType.Wea_ShortBlade: return 57;
    case gamedataItemType.Wea_Shotgun: return 58;
    case gamedataItemType.Wea_ShotgunDual: return 59;
    case gamedataItemType.Wea_SniperRifle: return 60;
    case gamedataItemType.Wea_SubmachineGun: return 61;
    case gamedataItemType.Wea_TwoHandedClub: return 62;
    case gamedataItemType.Count: return 63;
    case gamedataItemType.Invalid: return 64;
  };
  return 0;
}

private static func LootLog(str: String) -> Void {
  // Log(str);
}
