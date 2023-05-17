import VirtualAtelier.Systems.VirtualAtelierCartManager

@addMethod(InventoryItemDisplayController)
protected cb func OnAtelierMoneyRequirementChangedEvent(evt: ref<AtelierMoneyRequirementChangedEvent>) -> Bool {
  let itemID: ItemID = InventoryItemData.GetID(this.m_itemData);
  let cartManager: ref<VirtualAtelierCartManager> = evt.manager;
  let enoughMoney: Bool = cartManager.PlayerHasEnoughMoneyFor(itemID);
  let isAddedToCart: Bool = cartManager.IsAddedToCart(itemID);
  if !enoughMoney && !isAddedToCart {
    inkWidgetRef.SetState(this.m_requirementsWrapper, n"Money");
    this.m_requirementsMet = false;
  } else {
    this.UpdateRequirements();
  };
}
