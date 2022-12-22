@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

@if(!ModuleExists("EquipmentEx"))
@addMethod(gameuiMenuGameController)
public func IsAtelierItemEquipped(puppet: ref<gamePuppet>, itemId: ItemID) -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetPlayerControlledObject().GetGame());
  let placementSlot: TweakDBID = EquipmentSystem.GetPlacementSlot(itemId);
  let currentItem: ItemID = transactionSystem.GetItemInSlot(puppet, placementSlot).GetItemID();
  return Equals(currentItem, itemId);
}

@if(ModuleExists("EquipmentEx"))
@addMethod(gameuiMenuGameController)
public func IsAtelierItemEquipped(puppet: ref<gamePuppet>, itemId: ItemID) -> Bool {
  let outfitSystem: ref<OutfitSystem> = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
  return outfitSystem.IsEquipped(itemId);
}

@if(!ModuleExists("EquipmentEx"))
@addMethod(gameuiMenuGameController)
public func GetAtelierPlacementSlot(itemId: ItemID) -> TweakDBID {
  return EquipmentSystem.GetPlacementSlot(itemId);
}

@if(ModuleExists("EquipmentEx"))
@addMethod(gameuiMenuGameController)
public func GetAtelierPlacementSlot(itemId: ItemID) -> TweakDBID {
  if RPGManager.IsItemWeapon(itemId) {
    return EquipmentSystem.GetPlacementSlot(itemId);
  };

  let outfitSystem: ref<OutfitSystem> = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
  return outfitSystem.GetItemSlot(itemId);
}
