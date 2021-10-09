// Here you can change new button hint label, just replace text in quotes with your own
class ToggleQuestTagStrings {
  public static func Toggle() -> String = "Toggle quest tag"
}

// DO NOT EDIT ANYTHING BELOW


// -- Backpack -- BackpackMainGameController --

// Handle new button hint visibility
@addMethod(BackpackMainGameController)
private func UpdateHintsVisibility(shouldShow: Bool, opt evt: ref<ItemDisplayHoverOverEvent>) {
  let text: String = ToggleQuestTagStrings.Toggle();
  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"activate_secondary", text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"activate_secondary");
  };
}

// Show new hint on item hover over
@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateHintsVisibility(true, evt);
}

// Hide new hint on item hover out
@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateHintsVisibility(false);
}

// Toggle quest tag for item data
@addMethod(BackpackMainGameController)
private func ToggleQuestTag() -> Void {
  let data: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_lastItemHoverOverEvent.itemData);
  if data.HasTag(n"Quest") {
    data.RemoveDynamicTag(n"Quest");
  } else {
    data.SetDynamicTag(n"Quest");
  };
}

// Handle activate_secondary hotkey click
@wrapMethod(BackpackMainGameController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(n"activate_secondary") && IsDefined(this.m_lastItemHoverOverEvent) {
    this.ToggleQuestTag();
    this.RefreshUI();
  };
  wrappedMethod(evt);
}


// -- Main inventory window -- gameuiInventoryGameController --

// Handle new button hint visibility
@addMethod(gameuiInventoryGameController)
private func UpdateHintsVisibility(shouldShow: Bool, opt evt: ref<inkPointerEvent>) {
  let controller: ref<InventoryItemDisplayController> = this.GetEquipmentSlotControllerFromTarget(evt);
  let itemData: InventoryItemData = controller.GetItemData();
  let text: String = ToggleQuestTagStrings.Toggle();
  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"activate_secondary", text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"activate_secondary");
  };
}

// Show new hint on item hover over
@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentSlotHoverOver(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateHintsVisibility(true, evt);
}

// Hide new hint on item hover out
@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentSlotHoverOut(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateHintsVisibility(false);
}

// Toggle quest tag for item data
@addMethod(gameuiInventoryGameController)
private func ToggleQuestTag(evt: ref<inkPointerEvent>) -> Void {
  let controller: wref<InventoryItemDisplayController> = this.GetEquipmentSlotControllerFromTarget(evt);
  let itemData: InventoryItemData = controller.GetItemData();
  let data: ref<gameItemData>;
  if !InventoryItemData.IsEmpty(itemData) {
    data = InventoryItemData.GetGameItemData(itemData);
    if data.HasTag(n"Quest") {
      data.RemoveDynamicTag(n"Quest");
    } else {
      data.SetDynamicTag(n"Quest");
    };
  };
}

// Handle activate_secondary hotkey click
@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"activate_secondary") {
    this.ToggleQuestTag(evt);
    this.RefreshUI();
  };
}
