import VendorPreview.utils.*
import VendorPreview.constants.*
import VendorPreview.ItemPreviewManager.*

@addField(BackpackMainGameController)
private let m_previewItemPopupToken: ref<inkGameNotificationToken>;

@addField(BackpackMainGameController)
private let m_isPreviewMode: Bool;

@wrapMethod(BackpackMainGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);
  ItemPreviewManager.CreateInstance(playerPuppet as gamePuppet);
}

@addMethod(BackpackMainGameController)
private final func ShowItemPreview(opt inventoryItem: ref<UIInventoryItem>) -> Void {
  this.m_previewItemPopupToken = ItemPreviewManager.GetItemPreviewNotificationToken(this, inventoryItem);
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
  ItemPreviewManager.ToggleCraftableItemsPanel(this, false);
  this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
  this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText("UI-UserActions-DisableComparison"));
  this.m_buttonHintsController.HideCharacterRotateButtonHint();
}


@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData) -> Void {
  wrappedMethod(displayingData);

  let vendorPreviewButtonHint = VendorPreviewButtonHint.Get(this.GetPlayerControlledObject());
  this.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleNameBackpack, VirtualAtelierText.PreviewItem());
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOut() -> Void {
  wrappedMethod();
  this.m_buttonHintsController.RemoveButtonHint(VendorPreviewButtonHint.Get(this.GetPlayerControlledObject()).previewModeToggleNameBackpack);
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
    this.ShowItemPreview(evt.uiInventoryItem);
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
