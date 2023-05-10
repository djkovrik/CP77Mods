import VirtualAtelier.Systems.VirtualAtelierPreviewManager
import VirtualAtelier.Helpers.*
import VirtualAtelier.Core.*

@wrapMethod(BackpackMainGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  let system: ref<VirtualAtelierPreviewManager> = VirtualAtelierPreviewManager.GetInstance(playerPuppet.GetGame());
  system.InitializePuppet(playerPuppet as gamePuppet);
  system.InitializeCompatibilityHelper(this);
}

@addMethod(BackpackMainGameController)
private final func ShowItemPreview(opt inventoryItem: ref<UIInventoryItem>) -> Void {
  this.previewItemPopupToken = AtelierNotificationTokensHelper.GetItemPreviewNotificationToken(this, inventoryItem);
  this.previewItemPopupToken.RegisterListener(this, n"OnPreviewItemClosed");
  this.isPreviewMode = true;
  this.SetInventoryItemButtonHintsHoverOut();
  this.m_buttonHintsController.RemoveButtonHint(n"toggle_comparison_tooltip");
  this.m_buttonHintsController.RemoveButtonHint(n"back");
}

@addMethod(BackpackMainGameController)
protected cb func OnPreviewItemClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.previewItemPopupToken = null;
  this.isPreviewMode = false;
  AtelierWidgetsHelper.ToggleCraftableItemsPanel(this, false);
  this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
  this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText("UI-UserActions-DisableComparison"));
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  wrappedMethod(evt);

  let atelierActions: ref<AtelierActions>;
  if this.IsItemPreviewAvailable(evt.uiInventoryItem.ID) {
    atelierActions = AtelierActions.Get(this.GetPlayerControlledObject());
    this.m_buttonHintsController.AddButtonHint(atelierActions.togglePreviewBackpack, AtelierTexts.PreviewItem());
  };
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOut() -> Void {
  wrappedMethod();

  if this.IsItemPreviewAvailable(this.m_lastItemHoverOverEvent.uiInventoryItem.ID) {
    this.m_buttonHintsController.RemoveButtonHint(AtelierActions.Get(this.GetPlayerControlledObject()).togglePreviewBackpack);
  };
}

@wrapMethod(BackpackMainGameController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if (this.isPreviewMode) {
    return true;
  } else {
    wrappedMethod(evt);
  };
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.GetPlayerControlledObject());
  if evt.actionName.IsAction(atelierActions.togglePreviewBackpack) {
    if this.IsItemPreviewAvailable(evt.uiInventoryItem.ID) {
      this.ShowItemPreview(evt.uiInventoryItem);
    };
  } else {
    if (this.isPreviewMode) {
      return true;
    } else {
      wrappedMethod(evt);
    };
  };
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData) -> Void {
  wrappedMethod(displayingData);

  if this.isPreviewMode {
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
