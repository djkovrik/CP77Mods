class ToggleQuestTagStrings {
  public static func Toggle() -> String = "Toggle quest tag"
}

// DO NOT EDIT ANYTHING BELOW


private abstract class ToggleTagsChecker {

  public static func IsToggleable(type: gamedataItemType) -> Bool {
    return 
      NotEquals(type, gamedataItemType.Gad_Grenade) &&
      NotEquals(type, gamedataItemType.Con_Ammo) &&
      NotEquals(type, gamedataItemType.Con_Edible) &&
      NotEquals(type, gamedataItemType.Con_Inhaler) &&
      NotEquals(type, gamedataItemType.Con_Injector) &&
      NotEquals(type, gamedataItemType.Con_LongLasting) &&
      NotEquals(type, gamedataItemType.Con_Skillbook) &&
      NotEquals(type, gamedataItemType.Gen_MoneyShard) &&
      NotEquals(type, gamedataItemType.Gen_CraftingMaterial) &&
      !InventoryDataManagerV2.IsAttachmentType(type) &&
    true;
  }
}

// // -- Backpack -- BackpackMainGameController --

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
  if ToggleTagsChecker.IsToggleable(evt.uiInventoryItem.GetItemType()) {
    this.UpdateToggleTagsHints(true, evt);
  };
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
  let data: ref<gameItemData> = this.m_lastItemHoverOverEvent.uiInventoryItem.GetItemData();
  if !ToggleTagsChecker.IsToggleable(data.GetItemType()) {
    return ;
  };

  if data.HasTag(n"Quest") {
    data.RemoveDynamicTag(n"Quest");
  } else {
    data.SetDynamicTag(n"Quest");
  };
}

// Handle toggle_quest_tag hotkey click
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
@wrapMethod(InventoryItemModeLogicController)
private final func SetInventoryItemButtonHintsHoverOver(const displayingData: script_ref<InventoryItemData>, opt display: ref<InventoryItemDisplayController>) -> Void {
  wrappedMethod(displayingData, display);

  let type: gamedataItemType = InventoryItemData.GetItemType(displayingData);
  if ToggleTagsChecker.IsToggleable(type) {
    this.UpdateToggleTagsHints(true);
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
    if !ToggleTagsChecker.IsToggleable(data.GetItemType()) {
      return ;
    };
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

@wrapMethod(InventoryItemDisplayController)
protected func NewUpdateIndicators(itemData: ref<UIInventoryItem>) -> Void {
  wrappedMethod(itemData);
  inkWidgetRef.SetVisible(this.m_questItemMaker, IsDefined(itemData) ? itemData.GetItemData().HasTag(n"Quest") : false);
}
