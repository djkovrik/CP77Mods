class ToggleQuestTagStrings {
  public static func Toggle() -> String = "Toggle quest tag"
}

// DO NOT EDIT ANYTHING BELOW


// -- Backpack -- BackpackMainGameController --

// Handle new button hint visibility
@addMethod(BackpackMainGameController)
private func UpdateToggleTagsHints(shouldShow: Bool, opt evt: ref<ItemDisplayHoverOverEvent>) {
  let text: String = ToggleQuestTagStrings.Toggle();
  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"toggle_quest_tag", text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"toggle_quest_tag");
  };
}

// Show new hint on item hover over
@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateToggleTagsHints(true, evt);
}

// Hide new hint on item hover out
@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  wrappedMethod(evt);
  this.UpdateToggleTagsHints(false);
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
  if evt.IsAction(n"toggle_quest_tag") && IsDefined(this.m_lastItemHoverOverEvent) {
    this.ToggleQuestTag();
    this.RefreshUI();
  };
  wrappedMethod(evt);
}


// -- Main inventory window -- InventoryItemModeLogicController --

// Handle new button hint visibility
@addMethod(InventoryItemModeLogicController)
private func UpdateToggleTagsHints(shouldShow: Bool) {
  let text: String = ToggleQuestTagStrings.Toggle();
  if shouldShow {
    this.m_buttonHintsController.AddButtonHint(n"toggle_quest_tag", text);
  } else {
    this.m_buttonHintsController.RemoveButtonHint(n"toggle_quest_tag");
  };
}

// Show new hint on item hover over
@replaceMethod(InventoryItemModeLogicController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData, opt display: ref<InventoryItemDisplayController>) -> Void {
  let cursorData: ref<MenuCursorUserData> = new MenuCursorUserData();
  let isEquipped: Bool = InventoryItemData.IsEquipped(displayingData) || this.itemChooser.IsAttachmentItem(displayingData);
  if IsDefined(display) {
    if !InventoryItemData.IsEmpty(displayingData) {
      if this.itemChooser.CanEquipVisuals(InventoryItemData.GetID(displayingData)) {
        this.m_buttonHintsController.AddButtonHint(n"equip_visuals", GetLocalizedText("UI-UserActions-EquipVisuals"));
      } else {
        this.m_buttonHintsController.RemoveButtonHint(n"equip_visuals");
      };
      if !isEquipped {
        if NotEquals(InventoryItemData.GetItemType(displayingData), gamedataItemType.Prt_Program) {
          this.m_buttonHintsController.AddButtonHint(n"drop_item", GetLocalizedText("UI-ScriptExports-Drop0"));
          this.UpdateToggleTagsHints(true);
        };
        if !InventoryItemData.IsPart(displayingData) {
          if NotEquals(InventoryItemData.GetEquipmentArea(displayingData), gamedataEquipmentArea.Invalid) {
            this.m_buttonHintsController.AddButtonHint(n"equip_item", GetLocalizedText("UI-UserActions-Equip"));
          };
        } else {
          this.m_buttonHintsController.AddButtonHint(n"equip_item", GetLocalizedText("UI-UserActions-Equip"));
        };
        if Equals(display.GetDisplayContext(), ItemDisplayContext.Attachment) {
          this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
          this.m_buttonHintsController.RemoveButtonHint(n"equip_item");
          if RPGManager.CanPartBeUnequipped(InventoryItemData.GetID(displayingData)) {
            this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
            this.UpdateToggleTagsHints(true);
          } else {
            this.m_buttonHintsController.RemoveButtonHint(n"unequip_item");
          };
        };
      } else {
        if !InventoryItemData.IsPart(displayingData) || RPGManager.CanPartBeUnequipped(InventoryItemData.GetID(displayingData)) || Equals(InventoryItemData.GetEquipmentArea(this.itemChooser.GetModifiedItemData()), gamedataEquipmentArea.SystemReplacementCW) {
          this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
          this.UpdateToggleTagsHints(true);
        };
      };
      if !this.m_isE3Demo {
        if RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), InventoryItemData.GetID(displayingData)) && !isEquipped {
          this.m_buttonHintsController.AddButtonHint(n"disassemble_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("UI-ScriptExports-Disassemble0"));
          cursorData.AddAction(n"disassemble_item");
        };
      };
      if Equals(InventoryItemData.GetEquipmentArea(displayingData), gamedataEquipmentArea.Consumable) {
        this.m_buttonHintsController.AddButtonHint(n"use_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("UI-UserActions-Use"));
        cursorData.AddAction(n"use_item");
      };
    };
    if cursorData.GetActionsListSize() >= 0 {
      this.SetCursorContext(n"HoldToComplete", cursorData);
    } else {
      this.SetCursorContext(n"Hover");
    };
  } else {
    this.SetCursorContext(n"Default");
  };
}

// Hide new hint on item hover out
@wrapMethod(InventoryItemModeLogicController)
private final func SetInventoryItemButtonHintsHoverOut() -> Void {
  wrappedMethod();
  this.UpdateToggleTagsHints(false);
}

// Toggle quest tag for item data
@addMethod(gameuiInventoryGameController)
private func ToggleQuestTag(evt: ref<ItemDisplayClickEvent>) -> Void {
  let controller: wref<InventoryItemDisplayController> = evt.display;
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
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.actionName.IsAction(n"toggle_quest_tag") {
    this.ToggleQuestTag(evt);
    this.RefreshUI();
  };
}



@wrapMethod(InventoryItemModeLogicController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.IsAction(n"toggle_quest_tag") {
    this.RefreshAvailableItems();
  };
}