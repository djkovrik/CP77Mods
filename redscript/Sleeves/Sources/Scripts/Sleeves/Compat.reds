@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

@if(!ModuleExists("EquipmentEx"))
public func GetSleevesInfo(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
  let system: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
  return system.GetBasicSlotsItems(player, false);
}

@if(ModuleExists("EquipmentEx"))
public func GetSleevesInfo(player: ref<GameObject>) -> ref<SleevesInfoBundle> {
  let sleevesSystem: ref<SleevesStateSystem> = SleevesStateSystem.Get(player.GetGame());
  let outfitSystem: ref<OutfitSystem> = OutfitSystem.GetInstance(player.GetGame());
  if outfitSystem.IsActive() {
    return sleevesSystem.GetEquipmentExSlotsItems(player);
  };
  return sleevesSystem.GetBasicSlotsItems(player, true);
}

@if(!ModuleExists("EquipmentEx"))
public func IsSlotOccupiedCustom(gi: GameInstance, slot: TweakDBID) -> Bool {
  return false;
}

@if(ModuleExists("EquipmentEx"))
public func IsSlotOccupiedCustom(gi: GameInstance, slot: TweakDBID) -> Bool {
  return OutfitSystem.GetInstance(gi).IsOccupied(slot);
}

@if(!ModuleExists("EquipmentEx"))
public func GetSleevesEquipmentExRecords(player: ref<GameObject>, out records: array<TweakDBID>) -> Bool {
  ArrayClear(records);
  return false;
}

@if(ModuleExists("EquipmentEx"))
public func GetSleevesEquipmentExRecords(player: ref<GameObject>, out records: array<TweakDBID>) -> Bool {
  ArrayClear(records);
  let system: ref<OutfitSystem> = OutfitSystem.GetInstance(player.GetGame());
  if !IsDefined(system) || !system.IsActive() {
    return false;
  };
  let transaction: ref<TransactionSystem> = GameInstance.GetTransactionSystem(player.GetGame());
  // One scan of the active outfit, including slots not supported by the Sleeves UI.
  // GetUsedSlots rebuilds a slot array; call it once, not once per tracked item.
  let slots: array<TweakDBID> = system.GetUsedSlots();
  for slot in slots {
    let item: ref<ItemObject> = transaction.GetItemInSlot(player, slot);
    if !IsDefined(item) {
      // A partially spawned outfit cannot prove that a garment is absent.
      return false;
    };
    ArrayPush(records, ItemID.GetTDBID(item.GetItemID()));
  };
  return true;
}
