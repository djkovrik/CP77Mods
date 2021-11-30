class ToggleQuestTagStrings {
  
  // Here you can change the hotkey, by default it's mouse right button and (Pad_Y_TRIANGLE for controller)
  
  // Some options which you can try:
  // - "activate_secondary" equals to RightMouse and Pad_Y_TRIANGLE
  // - "prior_sub_menu" equals to 8 and Pad_LeftTrigger   <- recommended for controller users
  // - "next_sub_menu" equals to 9 and Pad_RightTrigger

  public static func Hotkey() -> String = "activate_secondary"
  
  // Button hint label text
  public static func Toggle() -> String = "Toggle quest tag"
}

// DO NOT EDIT ANYTHING BELOW


// -- Backpack -- BackpackMainGameController --

// Handle new button hint visibility
@addMethod(BackpackMainGameController)
private func UpdateHintsVisibility(shouldShow: Bool, opt evt: ref<ItemDisplayHoverOverEvent>) {
  let text: String = ToggleQuestTagStrings.Toggle();
  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(StringToName(ToggleQuestTagStrings.Hotkey()), text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(StringToName(ToggleQuestTagStrings.Hotkey()));
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
  if evt.IsAction(StringToName(ToggleQuestTagStrings.Hotkey())) && IsDefined(this.m_lastItemHoverOverEvent) {
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
    this.m_buttonHintsController.AddButtonHint(StringToName(ToggleQuestTagStrings.Hotkey()), text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(StringToName(ToggleQuestTagStrings.Hotkey()));
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
  if evt.IsAction(StringToName(ToggleQuestTagStrings.Hotkey())) {
    this.ToggleQuestTag(evt);
    this.RefreshUI();
  };
}
