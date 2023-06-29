import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager
import VendorPreview.Constants.VendorPreviewButtonHint

@wrapMethod(BackpackMainGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  let system: ref<VirtualAtelierPreviewManager> = VirtualAtelierPreviewManager.GetInstance(playerPuppet);
  system.InitializePuppet(playerPuppet as gamePuppet);
  system.InitializeCompatibilityHelper(this);
}

@addMethod(BackpackMainGameController)
private final func ShowItemPreview(opt inventoryItem: ref<UIInventoryItem>) -> Void {
  this.m_previewItemPopupToken = AtelierNotificationHelper.GetItemPreviewNotificationToken(this, inventoryItem);
  this.m_previewItemPopupToken.RegisterListener(this, n"OnPreviewItemClosed");
  this.m_isPreviewMode = true;
  this.SetInventoryItemButtonHintsHoverOut();
  this.m_buttonHintsController.RemoveButtonHint(n"toggle_comparison_tooltip");
  this.m_buttonHintsController.RemoveButtonHint(n"back");
}

@addMethod(BackpackMainGameController)
protected cb func OnPreviewItemClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.m_previewItemPopupToken = null;
  this.m_isPreviewMode = false;
  AtelierWidgetsHelper.ToggleCraftableItemsPanel(this, false);
  this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
  this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText("UI-UserActions-DisableComparison"));
  this.m_buttonHintsController.HideCharacterRotateButtonHint();
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  wrappedMethod(evt);

  let vendorPreviewButtonHint: ref<VendorPreviewButtonHint>;
  if this.IsItemPreviewAvailable(evt.uiInventoryItem.ID) {
    vendorPreviewButtonHint = VendorPreviewButtonHint.Get(this.GetPlayerControlledObject());
    this.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleNameBackpack, VirtualAtelierText.PreviewItem());
  };
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOut() -> Void {
  wrappedMethod();

  if this.IsItemPreviewAvailable(this.m_lastItemHoverOverEvent.uiInventoryItem.ID) {
    this.m_buttonHintsController.RemoveButtonHint(VendorPreviewButtonHint.Get(this.GetPlayerControlledObject()).previewModeToggleNameBackpack);
  };
}

@wrapMethod(BackpackMainGameController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if (this.m_isPreviewMode) {
    return true;
  } else {
    wrappedMethod(evt);
  };
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  if evt.actionName.IsAction(VendorPreviewButtonHint.Get(this.GetPlayerControlledObject()).previewModeToggleNameBackpack) {
    if this.IsItemPreviewAvailable(evt.uiInventoryItem.ID) {
      this.ShowItemPreview(evt.uiInventoryItem);
    };
  } else {
    if (this.m_isPreviewMode) {
      return true;
    } else {
      wrappedMethod(evt);
    };
  };
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData) -> Void {
  wrappedMethod(displayingData);

  if this.m_isPreviewMode {
    this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
    this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
  }
}

// Enable preview for weapons, inhalers and injectors only
// as most of other item types have no preview data
@addMethod(BackpackMainGameController)
private func IsItemPreviewAvailable(id: ItemID) -> Bool {
  return RPGManager.IsItemWeapon(id) 
    || Equals(RPGManager.GetItemData(this.m_player.GetGame(), this.m_player, id).GetItemType(), gamedataItemType.Con_Inhaler) 
    || Equals(RPGManager.GetItemData(this.m_player.GetGame(), this.m_player, id).GetItemType(), gamedataItemType.Con_Injector);
}
