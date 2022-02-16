import ReducedLootTypes.RL_LootSource
import ReducedLootUtils.*

@replaceMethod(ScriptedPuppet)
protected final func ProcessLoot() -> Void {
  let ammoAmount: Int32;
  let ammoToDrop: array<TweakDBID>;
  let blockRequest: ref<BlockAmmoDrop>;
  let equipmentItem: ref<gameItemData>;
  let i: Int32;
  let itemTDBID: TweakDBID;
  let lootModifiers: array<ref<gameStatModifierData>>;
  let rand: Float;
  let randQuery: Float;
  let tempPlayerLevel: Float;
  let tempStat: Float;
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let record: wref<Character_Record> = TweakDBInterface.GetCharacterRecord(this.GetRecordID());
  let canDropWeapon: Bool = record.DropsWeaponOnDeath();
  let canDropAmmo: Bool = record.DropsAmmoOnDeath();
  let dropMoney: Bool = record.DropsMoneyOnDeath();
  let foundEquipment: array<ItemID> = this.CreateEquipmentDataList(this);
  let heldMoney: Int32 = TS.GetItemQuantity(this, MarketSystem.Money());
  let itemData: ref<gameItemData>;
  ScriptedPuppet.GenerateLootModifiers(this, lootModifiers);
  this.GenerateLootWithStats(lootModifiers);
  if this.IsLooted() {
    return;
  };
  if this.IsCrowd() {
    return;
  };
  if dropMoney {
    TS.GiveItem(this, MarketSystem.Money(), heldMoney);
  };
  if canDropWeapon {
    i = 0;
    while i < ArraySize(foundEquipment) {
      TS.GiveItem(this, foundEquipment[i], 1);
      if RPGManager.BreakItem(this.GetGame(), this, foundEquipment[i]) {
        TS.RemoveItem(this, foundEquipment[i], 1);
      } else {
        itemData = TS.GetItemData(this, foundEquipment[i]);
        itemData.SetShouldKeep_RL();
        RLog("#1 set weapon was held for " + ToStr(itemData));
        equipmentItem = TS.GetItemData(this, foundEquipment[i]);
        RPGManager.SetDroppedWeaponQuality(this, equipmentItem);
        ScriptedPuppet.ScaleDroppedItem(equipmentItem, this);
      };
      i += 1;
    };
  };
  if canDropAmmo {
    ammoToDrop = PlayerHandicapSystem.GetInstance(this).GetHandicapAmmo();
    if ArraySize(ammoToDrop) > 0 {
      blockRequest = new BlockAmmoDrop();
      PlayerHandicapSystem.GetInstance(this).QueueRequest(blockRequest);
    };
    i = 0;
    while i < ArraySize(foundEquipment) {
      itemTDBID = RPGManager.GetWeaponAmmoTDBID(foundEquipment[i]);
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
        RLog("> Ammo check #1:");
        if RL_Checker.CanDropAmmo(RL_LootSource.Puppet) {
          RLog("+ ammo dropped: " + IntToString(ammoAmount));
          TS.GiveItemByTDBID(this, ammoToDrop[i], ammoAmount);
          this.DropAmmo();
        } else {
          RLog("- ammo removed: " + IntToString(ammoAmount));
        };
      };
      i += 1;
    };
  };
  if Equals(record.CharacterType().Type(), gamedataNPCType.Human) && this.IsHostile() {
    ScriptedPuppet.ProcessSupportiveItems(this);
  };
  if ScriptedPuppet.IsMechanical(this) {
    rand = RandF();
    randQuery = RandF();
    tempStat = GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.GetGame()).GetEntityID()), gamedataStatType.ScrapItemChance);
    tempPlayerLevel = GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.GetGame()).GetEntityID()), gamedataStatType.Level);
    if tempStat >= rand {
      if tempPlayerLevel < 20.00 {
        if randQuery <= 0.33 {
          GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.EarlyGameWeaponMods", 1u, 1u);
        } else {
          if randQuery > 0.33 && randQuery <= 0.66 {
            GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.EarlyGameWeaponScopes", 1u, 1u);
          } else {
            if randQuery > 0.66 {
              GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.EarlyGameWeaponSilencers", 1u, 1u);
            };
          };
        };
      } else {
        if tempPlayerLevel >= 20.00 && tempPlayerLevel < 35.00 {
          if randQuery <= 0.33 {
            GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.MidGameWeaponMods", 1u, 1u);
          } else {
            if randQuery > 0.33 && randQuery <= 0.66 {
              GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.MidGameWeaponScopes", 1u, 1u);
            } else {
              if randQuery > 0.66 {
                GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.MidGameWeaponSilencers", 1u, 1u);
              };
            };
          };
        } else {
          if tempPlayerLevel >= 35.00 {
            if randQuery <= 0.33 {
              GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.EndGameWeaponMods", 1u, 1u);
            } else {
              if randQuery > 0.33 && randQuery <= 0.66 {
                GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.EndGameWeaponScopes", 1u, 1u);
              } else {
                if randQuery > 0.66 {
                  GameInstance.GetTransactionSystem(this.GetGame()).GiveItemByItemQuery(this, t"Query.EndGameWeaponSilencers", 1u, 1u);
                };
              };
            };
          };
        };
      };
    };
  };
  if ScriptedPuppet.HasLootableItems(this) {
    ScriptedPuppet.EvaluateLootQuality(this);
  };
  this.CacheLootForDroping();
}

@replaceMethod(ScriptedPuppet)
private final func DropHeldItems() -> Bool {
  let canLeftItemDrop: Bool;
  let canRightItemDrop: Bool;
  let leftItem: wref<ItemObject>;
  let rightItem: wref<ItemObject>;
  let slot: TweakDBID;
  let canDrop: Bool = TweakDBInterface.GetCharacterRecord(this.GetRecordID()).DropsWeaponOnDeath();

  if canDrop {
    slot = t"AttachmentSlots.WeaponRight";
    rightItem = GameInstance.GetTransactionSystem(this.GetGame()).GetItemInSlot(this, slot);
    canRightItemDrop = IsDefined(rightItem) && IsNameValid(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(rightItem.GetItemID())).DropObject());
    slot = t"AttachmentSlots.WeaponLeft";
    leftItem = GameInstance.GetTransactionSystem(this.GetGame()).GetItemInSlot(this, slot);
    canLeftItemDrop = IsDefined(leftItem) && IsNameValid(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(leftItem.GetItemID())).DropObject());
    if canLeftItemDrop || canRightItemDrop {
      this.DropWeapons();
      if IsDefined(rightItem) {
        ScriptedPuppet.ScaleDroppedItem(rightItem.GetItemData(), this);
        rightItem.GetItemData().SetShouldKeep_RL();
        RLog("#2 set weapon was held for " + ToStr(rightItem.GetItemData()));
      };
      if IsDefined(leftItem) {
        ScriptedPuppet.ScaleDroppedItem(leftItem.GetItemData(), this);
        leftItem.GetItemData().SetShouldKeep_RL();
        RLog("#2 set weapon was held for " + ToStr(leftItem.GetItemData()));
      };
      if RPGManager.IsItemWeapon(rightItem.GetItemID()) || RPGManager.IsItemWeapon(leftItem.GetItemID()) {
        this.m_droppedWeapons = true;
      };
    };
  };
  return this.m_droppedWeapons;
}

@replaceMethod(ScriptedPuppet)
public final static func DropItemFromSlot(obj: wref<GameObject>, slot: TweakDBID) -> Void {
  let item: wref<ItemObject>;
  let itemInSlotID: ItemID;
  if !IsDefined(obj) {
    return;
  };
  item = GameInstance.GetTransactionSystem(obj.GetGame()).GetItemInSlot(obj, slot);
  if IsDefined(item) {
    itemInSlotID = item.GetItemData().GetID();
  };
  if IsDefined(item) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Wea_Fists) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Cyb_StrongArms) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Cyb_MantisBlades) && NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Cyb_NanoWires) {
    item.GetItemData().SetShouldKeep_RL();
    RLog("#3 set weapon was held for " + ToStr(item.GetItemData()));
    (obj as ScriptedPuppet).DropWeapons();
  };
}

@replaceMethod(ScriptedPuppet)
public final static func DropWeaponFromSlot(obj: wref<GameObject>, slot: TweakDBID) -> Void {
  let isBroken: Bool;
  let item: wref<ItemObject>;
  if !IsDefined(obj) {
    return;
  };
  item = GameInstance.GetTransactionSystem(obj.GetGame()).GetItemInSlot(obj, slot);
  if IsDefined(item) {
    isBroken = RPGManager.BreakItem(obj.GetGame(), obj, item.GetItemID());
    if !isBroken {
      RLog("#4 set weapon was held for " + ToStr(item.GetItemData()));
      item.GetItemData().SetShouldKeep_RL();
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

  if RL_Utils.IsAmmo(data) && !this.IsPlayer() && !this.IsVendor() {
    RLog("> Ammo check #2:");
    if RL_Checker.CanDropAmmo(RL_LootSource.Puppet) {
      RLog("+ ammo dropped: " + IntToString(data.GetQuantity()));
    } else {
      RLog("- ammo removed: " + IntToString(data.GetQuantity()));
      transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
      transactionSystem.RemoveItem(this, data.GetID(), data.GetQuantity());
    };
  };

  if this.HasValidLootQuality() {
    quality = this.m_lootQuality;
    this.EvaluateLootQuality();
    if NotEquals(quality, this.m_lootQuality) {
      this.RequestHUDRefresh();
    };
  };
}
