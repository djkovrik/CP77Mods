module RevisedBackpack

@addMethod(InventoryDataManagerV2)
public final func GetItemSlotIndexRev(owner: ref<GameObject>, itemId: ItemID) -> Int32 {
  return this.m_EquipmentSystem.GetItemSlotIndex(owner, itemId);
}

@wrapMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  let wrapped: Bool = wrappedMethod(itemData);
  let settings: ref<RevisedBackpackSettings> = new RevisedBackpackSettings();
  let modded: Bool = settings.allowIconicsDisassemble;
  return wrapped || modded;
}
