module RevisedBackpack

@addMethod(InventoryDataManagerV2)
public final func GetItemSlotIndexRev(owner: ref<GameObject>, itemId: ItemID) -> Int32 {
  return this.m_EquipmentSystem.GetItemSlotIndex(owner, itemId);
}

@wrapMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  let wrapped: Bool = wrappedMethod(itemData);
  if wrapped || !IsDefined(itemData) {
    return wrapped;
  };
  if !itemData.HasTag(n"IconicWeapon") || itemData.HasTag(n"Quest") || itemData.HasTag(n"UnequipBlocked") {
    return false;
  };

  let settings: ref<RevisedBackpackSettings> = new RevisedBackpackSettings();
  return settings.allowIconicsDisassemble
    && IsDefined(ItemActionsHelper.GetDisassembleAction(itemData.GetID()));
}
