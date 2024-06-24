import VendorPreview.StoresManager.VirtualAtelierStoresSystem
import VendorPreview.ItemPreviewManager.VirtualAtelierPreviewManager
import VendorPreview.Constants.VendorPreviewButtonHint

@addMethod(FullscreenVendorGameController)
private func InitialzieAtelierSystems() -> Void {
  this.m_storesManager = VirtualAtelierStoresSystem.GetInstance(this.GetPlayerControlledObject());
  this.m_previewManager = VirtualAtelierPreviewManager.GetInstance(this.GetPlayerControlledObject());
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if this.GetIsVirtual() {
    this.m_currentTutorialsFact = GameInstance.GetQuestsSystem(this.m_player.GetGame()).GetFact(n"disable_tutorials");
    GameInstance.GetQuestsSystem(this.m_player.GetGame()).SetFact(n"disable_tutorials", 1);
  } else {
    AtelierButtonHintsHelper.AddPreviewModeToggleButtonHint(this);
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
  this.InitialzieAtelierSystems();

  wrappedMethod(userData);

  if this.GetIsVirtual() {
    inkTextRef.SetText(this.m_vendorName, this.GetVirtualStoreName());
    this.m_lastVendorFilter = ItemFilterCategory.AllItems;
    inkWidgetRef.SetVisible(this.m_vendorBalance, false);
    this.ShowGarmentPreview();
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnUninitialize() -> Bool {
  this.SetPreviewStateActive(false);
  this.m_previewManager.RemovePreviewGarment();

  wrappedMethod();

  if NotEquals(this.m_itemPreviewPopupToken, null) {
    this.m_itemPreviewPopupToken.TriggerCallback(null);
  };

  if this.GetIsVirtual() {
    GameInstance.GetQuestsSystem(this.m_player.GetGame()).SetFact(n"disable_tutorials", this.m_currentTutorialsFact);
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnBeforeLeaveScenario(userData: ref<IScriptable>) -> Bool {
  if !this.GetIsVirtual() {
    wrappedMethod(userData);
  };
}

@addMethod(FullscreenVendorGameController)
protected cb func OnTogglePreviewMode(evt: ref<inkPointerEvent>) -> Bool {
  if this.m_isPreviewMode {
    this.m_itemPreviewPopupToken.TriggerCallback(null);
  } else {
    this.ShowGarmentPreview();
  };
}

@addMethod(FullscreenVendorGameController)
private final func ShowGarmentPreview() -> Void {
  let displayContext: ItemDisplayContext;
  this.m_isPreviewMode = true;
  this.SetPreviewStateActive(true);

  if (this.GetIsVirtual()) {
    displayContext = ItemDisplayContext.VendorPlayer; 
  } else {
    displayContext = ItemDisplayContext.Vendor;
  };

  this.m_itemPreviewPopupToken = AtelierNotificationHelper.GetGarmentPreviewNotificationToken(this, displayContext) as inkGameNotificationToken;
  this.m_itemPreviewPopupToken.RegisterListener(this, n"OnEquipPreviewClosed");

  AtelierWidgetsHelper.OnToggleGarmentPreview(this, true);
}

@addMethod(FullscreenVendorGameController)
protected cb func OnEquipPreviewClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.m_isPreviewMode = false;
  this.SetPreviewStateActive(false);
  this.m_itemPreviewPopupToken = null;
  
  AtelierWidgetsHelper.OnToggleGarmentPreview(this, false);
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  if this.m_isPreviewMode {
    this.HandleVirtualSlotClick(evt);
  } else {
    wrappedMethod(evt);
  };
}

@addMethod(FullscreenVendorGameController)
private final func HandleVirtualSlotClick(evt: ref<ItemDisplayClickEvent>) -> Void {
  let isVendorItem: Bool = InventoryItemData.IsVendorItem(evt.itemData);
  let isVendorContext: Bool = Equals(evt.displayContextData.GetDisplayContext(), ItemDisplayContext.Vendor);
  let showPreview: Bool = isVendorItem || isVendorContext;
  let itemId: ItemID;

  if evt.actionName.IsAction(n"click") && showPreview {
    if isVendorItem {
      itemId = InventoryItemData.GetID(evt.itemData);
    } else {
      itemId = evt.uiInventoryItem.m_itemData.GetID();
    };

    let isEquipped: Bool = this.m_previewManager.GetIsEquipped(itemId);
    let isWeapon: Bool = RPGManager.IsItemWeapon(itemId);
    let isClothing: Bool = RPGManager.IsItemClothing(itemId);
    let hintLabel: String;

    if isClothing || isWeapon {
      this.m_previewManager.TogglePreviewItem(itemId);

      if this.GetIsVirtual() {
        this.RefreshEquippedState();
      };

      if isEquipped {
        hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Equip");
      } else {
        hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Unequip");
      };

      this.m_buttonHintsController.RemoveButtonHint(n"select");
      this.m_buttonHintsController.AddButtonHint(n"select", hintLabel);
    } else {
      this.m_buttonHintsController.RemoveButtonHint(n"select");
    };
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnHandleGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);

  let vendorPreviewButtonHint: ref<VendorPreviewButtonHint> = VendorPreviewButtonHint.Get(this.GetPlayerControlledObject());
  let lastUsedPad: Bool = this.GetPlayerControlledObject().PlayerLastUsedPad();
  let lastUsedKBM: Bool = this.GetPlayerControlledObject().PlayerLastUsedKBM();
  let isVirtual: Bool = this.GetIsVirtual();

  if (isVirtual && evt.IsAction(VendorPreviewButtonHint.Get(this.GetPlayerControlledObject()).previewModeToggleName)) && this.m_lastItemHoverOverEvent != null {
    this.BuyItemFromVirtualVendor(this.m_lastItemHoverOverEvent.itemData);
    return false;
  };

  switch true {
    case evt.IsAction(vendorPreviewButtonHint.previewModeToggleName) && !isVirtual:
      if (this.m_isPreviewMode) {
        this.m_lastVendorFilter = ItemFilterCategory.AllItems;
        this.m_itemPreviewPopupToken.TriggerCallback(null);
      } else {
        this.ShowGarmentPreview();
      };
      break;
    case evt.IsAction(vendorPreviewButtonHint.resetGarmentName):
      this.m_previewManager.ResetGarment();
      this.RefreshEquippedState();
      break;
    case evt.IsAction(vendorPreviewButtonHint.removeAllGarmentName):
      this.m_previewManager.RemoveAllGarment();
      this.RefreshEquippedState();
      break;
    case evt.IsAction(vendorPreviewButtonHint.removePreviewGarmentName):
      this.m_previewManager.RemovePreviewGarment();
      this.RefreshEquippedState();
      break;
    case (evt.IsAction(n"back") && isVirtual && this.m_isPreviewMode):
    case (evt.IsAction(n"cancel") && isVirtual && this.m_isPreviewMode):
      this.m_previewManager.RemovePreviewGarment();
      this.m_menuEventDispatcher.SpawnEvent(n"OnVendorClose");
      break;

    // Since patch 1.5 right mouse click closes menus and for Atelier it just removes preview
    // without closing the shop so Consume just blocks it
    case (evt.IsAction(n"world_map_fake_rotate") && isVirtual):
      evt.Consume();
      break;

    // Force shop closing on C for keyboards to prevent preview screw up
    case (evt.IsAction(n"world_map_menu_toggle_custom_filter") && isVirtual && this.m_isPreviewMode && lastUsedKBM):
      this.m_previewManager.RemovePreviewGarment();
      this.m_menuEventDispatcher.SpawnEvent(n"OnVendorClose");
      break;

    // Consume SQUARE for Pad to prevent conflicts with Purchase action which also uses world_map_menu_toggle_custom_filter
    case (evt.IsAction(n"world_map_menu_toggle_custom_filter") && isVirtual && this.m_isPreviewMode && lastUsedPad):
      evt.Consume();
      break;
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  if this.m_isPreviewMode || this.GetIsVirtual() {
    let itemId: ItemID = InventoryItemData.GetID(evt.itemData);
    let isEquipped: Bool = this.m_previewManager.GetIsEquipped(itemId);
    let isWeapon: Bool = RPGManager.IsItemWeapon(itemId);
    let isClothing: Bool = RPGManager.IsItemClothing(itemId);

    if this.GetIsVirtual() {
      AtelierButtonHintsHelper.UpdatePurchaseHints(this, true);
    };

    let hintLabel: String;
    if (isWeapon || isClothing) {
      if isEquipped {
        hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Unequip");
      } else {
        hintLabel = GetLocalizedTextByKey(n"UI-UserActions-Equip");
      };

      this.m_buttonHintsController.RemoveButtonHint(n"select");
      this.m_buttonHintsController.AddButtonHint(n"select", hintLabel);
    } else {
      this.m_buttonHintsController.RemoveButtonHint(n"select");
    };

    this.m_lastItemHoverOverEvent = evt;
    this.RequestSetFocus(null);

    let noCompare: InventoryItemData;
    this.ShowTooltipsForItemController(evt.widget, noCompare, evt.itemData, evt.display.DEBUG_GetIconErrorInfo(), false);
  } else {
    wrappedMethod(evt);
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  wrappedMethod(evt);
  AtelierButtonHintsHelper.UpdatePurchaseHints(this, false);
}

@addMethod(FullscreenVendorGameController)
private func RefreshEquippedState() -> Void {
  let evt: ref<VendorInventoryEquipStateChanged> = new VendorInventoryEquipStateChanged();
  evt.system = this.m_previewManager;
  GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(evt);
}
