import ReducedLootTypes.RL_LootSource
import ReducedLootUtils.*

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
        gamePuppet.ScaleDroppedItem(rightItem.GetItemData(), this);
        rightItem.GetItemData().SetShouldKeep_RL();
        RLog("#2 set weapon was held for " + RL_Utils.ToStr(rightItem.GetItemData()));
      };
      if IsDefined(leftItem) {
        gamePuppet.ScaleDroppedItem(leftItem.GetItemData(), this);
        leftItem.GetItemData().SetShouldKeep_RL();
        RLog("#2 set weapon was held for " + RL_Utils.ToStr(leftItem.GetItemData()));
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
    RLog("#3 set weapon was held for " + RL_Utils.ToStr(item.GetItemData()));
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
      RLog("#4 set weapon was held for " + RL_Utils.ToStr(item.GetItemData()));
      item.GetItemData().SetShouldKeep_RL();
      (obj as ScriptedPuppet).DropWeapons();
    };
  };
}

// hack to remove extra added ammo
@wrapMethod(ScriptedPuppet)
protected cb func OnItemAddedEvent(evt: ref<ItemAddedEvent>) -> Bool {
  let data: ref<gameItemData> = evt.itemData;
  let transactionSystem: ref<TransactionSystem>;

  if RL_Utils.IsAmmo(data) && !this.IsPlayer() && !this.IsVendor() {
    RLog("> Ammo check:");
    if RL_Checker.CanDropAmmo(RL_LootSource.Puppet) {
      RLog("+ ammo dropped: " + IntToString(data.GetQuantity()));
    } else {
      RLog("- ammo removed: " + IntToString(data.GetQuantity()));
      transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
      transactionSystem.RemoveItem(this, data.GetID(), data.GetQuantity());
    };
  };

  return wrappedMethod(evt);
}
