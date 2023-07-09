@if(ModuleExists("EquipmentEx"))
import EquipmentEx.OutfitSystem

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
  if !outfitSystem.IsActive() {
    return EquipmentSystem.GetPlacementSlot(itemId);
  };

  return outfitSystem.GetItemSlot(itemId);
}

// Darkcopse itemParts fix
@wrapMethod(InventoryDataManagerV2)
private final func GetPartInventoryItemData(owner: wref<GameObject>, itemId: ItemID, innerItemData: InnerItemData, opt itemData: wref<gameItemData>, opt record: wref<Item_Record>) -> InventoryItemData {
  if !(ItemID.IsValid(itemId)) && itemData.isVirtualItem {
    itemId = itemData.GetID();
  };
  return wrappedMethod(owner, itemId, innerItemData, itemData);
}

// Spawn from local slots inkwidget to fix E3 Inventory compat
@addMethod(ItemDisplayUtils)
public final static func AsyncSpawnCommonSlotControllerVA(logicController: ref<inkLogicController>, parent: ref<inkWidget>, slotName: CName, callbackName: CName, opt userData: ref<IScriptable>) -> Void {
  if IsDefined(parent) {
    logicController.AsyncSpawnFromExternal(parent, r"base\\gameplay\\gui\\virtual_atelier_slots.inkwidget", slotName, logicController, callbackName, userData);
  };
}
