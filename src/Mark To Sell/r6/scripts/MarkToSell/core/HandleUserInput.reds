import MarkToSell.System.MarkToSellSystem
import MarkToSell.Text.Labels

// -- BACKPACK

@addMethod(BackpackMainGameController)
private func UpdateMarkForSaleHint(shouldShow: Bool, opt alreadyHasIt: Bool, opt evt: ref<ItemDisplayHoverOverEvent>) {
  let text1: String;
  let text2: String;

  if alreadyHasIt {
    text1 = Labels.Remove();
    text2 = Labels.RemoveSimilar();
  } else {
    text1 = Labels.Add();
    text2 = Labels.AddSimilar();
  };

  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"mark_to_sell", text1);
    this.m_buttonHintsController.AddButtonHint(n"mark_similar_to_sell", text2);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"mark_to_sell");
    this.m_buttonHintsController.RemoveButtonHint(n"mark_similar_to_sell");
  };
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  wrappedMethod(evt);

  let hasQuestTag: Bool = InventoryItemData.GetGameItemData(evt.itemData).HasTag(n"Quest");
  let alreadyMarked: Bool = InventoryItemData.GetGameItemData(evt.itemData).modMarkedForSale;
  let price: Int32 = RPGManager.CalculateSellPrice(this.m_player.GetGame(), this.m_player, evt.itemData.ID);
  if price > 0 && !hasQuestTag {
    this.UpdateMarkForSaleHint(true, alreadyMarked, evt);
  };
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateMarkForSaleHint(false);
}

@addMethod(BackpackMainGameController)
private func ToggleMarkForSale() -> Void {
  let system: ref<MarkToSellSystem> = MarkToSellSystem.GetInstance(this.m_player.GetGame());
  let data: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_lastItemHoverOverEvent.itemData);
  let itemId: ItemID = data.GetID();
  let newMark: Bool;

  if data.HasTag(n"Quest") {
    return ;
  };

  if data.modMarkedForSale {
    system.Remove(itemId);
    newMark = false;
  } else {
    system.Add(itemId);
    newMark = true;
  };
  data.modMarkedForSale = newMark;
  InventoryItemData.SetGameItemData(this.m_lastItemHoverOverEvent.itemData, data);
}

@addMethod(BackpackMainGameController)
private func ToggleMarkForSaleForSimilarItems() -> Void {
  let system: ref<MarkToSellSystem> = MarkToSellSystem.GetInstance(this.m_player.GetGame());
  let data: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_lastItemHoverOverEvent.itemData);
  system.MarkSimilarItems(data);
}

@wrapMethod(BackpackMainGameController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {

  if IsDefined(this.m_lastItemHoverOverEvent) {
    if evt.IsAction(n"mark_to_sell") {
      this.ToggleMarkForSale();
      this.RefreshUI();
    };
    if evt.IsAction(n"mark_similar_to_sell") {
      this.ToggleMarkForSaleForSimilarItems();
      this.RefreshUI();
    };
  };
  wrappedMethod(evt);
}


// -- INVENTORY

@addMethod(InventoryItemModeLogicController)
private func UpdateMarkForSaleHint(shouldShow: Bool, opt alreadyHasIt: Bool) {
  let text1: String;
  let text2: String;

  if alreadyHasIt {
    text1 = Labels.Remove();
    text2 = Labels.RemoveSimilar();
  } else {
    text1 = Labels.Add();
    text2 = Labels.AddSimilar();
  };

  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"mark_to_sell", text1);
    this.m_buttonHintsController.AddButtonHint(n"mark_similar_to_sell", text2);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"mark_to_sell");
    this.m_buttonHintsController.RemoveButtonHint(n"mark_similar_to_sell");
  };
}

@wrapMethod(InventoryItemModeLogicController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData, opt display: ref<InventoryItemDisplayController>) -> Void {
  wrappedMethod(displayingData, display);

  let price: Int32 = RPGManager.CalculateSellPrice(this.m_player.GetGame(), this.m_player, displayingData.ID);
  let hasQuestTag: Bool = InventoryItemData.GetGameItemData(displayingData).HasTag(n"Quest");
  let alreadyMarked: Bool = InventoryItemData.GetGameItemData(displayingData).modMarkedForSale;
  if IsDefined(display) && price > 0 && !hasQuestTag {
    this.UpdateMarkForSaleHint(true, alreadyMarked);
  };
}

@wrapMethod(InventoryItemModeLogicController)
private final func SetInventoryItemButtonHintsHoverOut() -> Void {
  wrappedMethod();
  this.UpdateMarkForSaleHint(false);
}

@addMethod(gameuiInventoryGameController)
private func UpdateMarkForSaleHint(shouldShow: Bool, opt alreadyHasIt: Bool) {
  let text: String;
  if alreadyHasIt {
    text = Labels.Remove();
  } else {
    text = Labels.Add();
  };

  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"mark_to_sell", text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"mark_to_sell");
  };
}

@addMethod(gameuiInventoryGameController)
private func ToggleMarkForSale(evt: ref<ItemDisplayClickEvent>) -> Void {
  let system: ref<MarkToSellSystem> = MarkToSellSystem.GetInstance(this.m_player.GetGame());
  let itemId: ItemID;
  let controller: wref<InventoryItemDisplayController> = evt.display;
  let itemData: InventoryItemData = controller.GetItemData();
  let data: ref<gameItemData>;

  if !InventoryItemData.IsEmpty(itemData) {
    data = InventoryItemData.GetGameItemData(itemData);
    itemId = data.GetID();
    let newMark: Bool;

    if data.HasTag(n"Quest") {
      return ;
    };
    
    if data.modMarkedForSale {
      system.Remove(itemId);
      newMark = false;
    } else {
      system.Add(itemId);
      newMark = true;
    };

    data.modMarkedForSale = newMark;
    InventoryItemData.SetGameItemData(itemData, data);
    controller.Setup(itemData);
    this.UpdateMarkForSaleHint(false);
    this.UpdateMarkForSaleHint(true, newMark);
  };
}

@addMethod(gameuiInventoryGameController)
private func ToggleMarkForSaleForSimilarItems(evt: ref<ItemDisplayClickEvent>) -> Void {
  let controller: wref<InventoryItemDisplayController> = evt.display;
  let itemData: InventoryItemData = controller.GetItemData();
  let system: ref<MarkToSellSystem>;
  let data: ref<gameItemData>;

  if !InventoryItemData.IsEmpty(itemData) {
    data = InventoryItemData.GetGameItemData(itemData);
    system = MarkToSellSystem.GetInstance(this.m_player.GetGame());
    system.MarkSimilarItems(data);
  };  
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.actionName.IsAction(n"mark_to_sell") {
    this.ToggleMarkForSale(evt);
    this.RefreshUI();
  };
  if evt.actionName.IsAction(n"mark_similar_to_sell") {
    this.ToggleMarkForSaleForSimilarItems(evt);
    this.RefreshUI();
  };
}

@wrapMethod(InventoryItemModeLogicController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"mark_to_sell") || evt.IsAction(n"mark_similar_to_sell") {
    this.RefreshAvailableItems();
  };
}
