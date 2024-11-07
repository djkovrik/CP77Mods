module RevisedBackpack

@addMethod(InventoryDataManagerV2)
public final func GetItemSlotIndexRev(owner: ref<GameObject>, itemId: ItemID) -> Int32 {
  return this.m_EquipmentSystem.GetItemSlotIndex(owner, itemId);
}
