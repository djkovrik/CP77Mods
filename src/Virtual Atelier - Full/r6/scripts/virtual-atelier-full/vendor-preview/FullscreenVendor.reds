import VendorPreview.Config.VirtualAtelierConfig
import VirtualAtelier.Systems.*
import VirtualAtelier.Helpers.*
import VirtualAtelier.Core.*

@addMethod(FullscreenVendorGameController)
private func InitialzieAtelierSystems() -> Void {
  this.previewManager = VirtualAtelierPreviewManager.GetInstance(this.GetPlayerControlledObject().GetGame());
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  AtelierButtonHintsHelper.AddInitialPreviewHint(this);
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
  this.InitialzieAtelierSystems();
  wrappedMethod(userData);
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnUninitialize() -> Bool {
  this.previewManager.SetPreviewState(false);
  this.previewManager.RemovePreviewGarment();

  wrappedMethod();

  if NotEquals(this.m_itemPreviewPopupToken, null) {
    this.m_itemPreviewPopupToken.TriggerCallback(null);
  };
}

@wrapMethod(FullscreenVendorGameController)
private final func RequestAutoSave(opt delay: Float) -> Void {
  if !this.GetIsVirtual() {
    wrappedMethod(delay);
  };
}

@addMethod(FullscreenVendorGameController)
protected cb func OnTogglePreviewMode(evt: ref<inkPointerEvent>) -> Bool {
  if this.isPreviewMode {
    this.m_itemPreviewPopupToken.TriggerCallback(null);
  } else {
    this.ShowGarmentPreview();
  };
}

@addMethod(FullscreenVendorGameController)
private final func ShowGarmentPreview() -> Void {
  let displayContext: ItemDisplayContext = ItemDisplayContext.Vendor;
  this.isPreviewMode = true;
  this.previewManager.SetPreviewState(true);
  this.m_itemPreviewPopupToken = AtelierNotificationTokensHelper.GetGarmentPreviewNotificationToken(this, displayContext) as inkGameNotificationToken;
  this.m_itemPreviewPopupToken.RegisterListener(this, n"OnEquipPreviewClosed");
  AtelierWidgetsHelper.OnToggleGarmentPreview(this, true);
}

@addMethod(FullscreenVendorGameController)
protected cb func OnEquipPreviewClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.isPreviewMode = false;
  this.previewManager.SetPreviewState(false);
  this.m_itemPreviewPopupToken = null;
  AtelierWidgetsHelper.OnToggleGarmentPreview(this, false);
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
  if this.isPreviewMode {
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

    let isEquipped: Bool = this.previewManager.GetIsEquipped(itemId);
    let isWeapon: Bool = RPGManager.IsItemWeapon(itemId);
    let isClothing: Bool = RPGManager.IsItemClothing(itemId);
    let hintLabel: String;

    if isClothing || isWeapon {
      this.previewManager.TogglePreviewItem(itemId);
      this.RefreshEquippedState();
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
protected cb func OnHandleGlobalInput(event: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(event);

  let atelierActions: ref<AtelierActions> = AtelierActions.Get(this.GetPlayerControlledObject());

  switch true {
    case event.IsAction(atelierActions.togglePreviewVendor):
      if (this.isPreviewMode) {
        this.m_lastVendorFilter = ItemFilterCategory.AllItems;
        this.m_itemPreviewPopupToken.TriggerCallback(null);
      } else {
        this.ShowGarmentPreview();
      };
      break;
    case event.IsAction(atelierActions.resetGarment):
      this.previewManager.ResetGarment();
      this.RefreshEquippedState();
      break;
    case event.IsAction(atelierActions.removeAllGarment):
      this.previewManager.RemoveAllGarment();
      this.RefreshEquippedState();
      break;
    case event.IsAction(atelierActions.removePreviewGarment):
      this.previewManager.RemovePreviewGarment();
      this.RefreshEquippedState();
      break;
    case (event.IsAction(n"back") && this.isPreviewMode):
    case (event.IsAction(n"cancel") && this.isPreviewMode):
      this.previewManager.RemovePreviewGarment();
      this.m_menuEventDispatcher.SpawnEvent(n"OnVendorClose");
      break;
  };
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  if this.isPreviewMode {
    let itemId: ItemID = InventoryItemData.GetID(evt.itemData);
    let isEquipped: Bool = this.previewManager.GetIsEquipped(itemId);
    let isWeapon: Bool = RPGManager.IsItemWeapon(itemId);
    let isClothing: Bool = RPGManager.IsItemClothing(itemId);

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

    if IsDefined(evt.uiInventoryItem) {
      this.ShowTooltipsForUIInventoryItem(evt.widget, evt.uiInventoryItem);
    } else {
      this.ShowTooltipsForItemData(evt.widget, evt.itemData, evt.display.DEBUG_GetIconErrorInfo());
    };
  } else {
    wrappedMethod(evt);
  };
}

@addMethod(FullscreenVendorGameController)
private func RefreshEquippedState() -> Void {
  GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(VendorItemStateRefreshEvent.Create());
}

@addMethod(FullscreenVendorGameController)
private final func GetIsVirtual() -> Bool {
  return Equals(this.m_vendorUserData.vendorData.data.vendorId, "VirtualVendor");
}

@addMethod(FullscreenVendorGameController)
private final func ShowTooltipsForUIInventoryItem(targetWidget: wref<inkWidget>, inspectedItem: wref<UIInventoryItem>) -> Void {
  let placement: gameuiETooltipPlacement = gameuiETooltipPlacement.RightTop;
  let data: ref<UIInventoryItemTooltipWrapper>;
  this.m_TooltipsManager.HideTooltips();
  if IsDefined(inspectedItem) {
    data = UIInventoryItemTooltipWrapper.Make(inspectedItem, this.m_vendorItemDisplayContext);
    if Equals(inspectedItem.GetItemType(), gamedataItemType.Prt_Program) {
      this.m_TooltipsManager.ShowTooltipAtWidget(n"programTooltip", targetWidget, data, placement);
    } else {
      if Equals(inspectedItem.GetEquipmentArea(), gamedataEquipmentArea.SystemReplacementCW) {
        this.m_TooltipsManager.ShowTooltipAtWidget(n"cyberdeckTooltip", targetWidget, data, placement);
      } else {
        this.m_TooltipsManager.ShowTooltipAtWidget(n"itemTooltip", targetWidget, data, placement);
      };
    };
  };
}

@addMethod(FullscreenVendorGameController)
private final func ShowTooltipsForItemData(targetWidget: wref<inkWidget>, inspectedItemData: InventoryItemData, iconErrorInfo: ref<DEBUG_IconErrorInfo>) -> Void {
  let placement: gameuiETooltipPlacement = gameuiETooltipPlacement.RightTop;
  let data: ref<InventoryTooltipData> = this.m_InventoryManager.GetTooltipDataForInventoryItem(inspectedItemData, InventoryItemData.IsEquipped(inspectedItemData), iconErrorInfo, InventoryItemData.IsVendorItem(inspectedItemData));
  data.displayContext = InventoryTooltipDisplayContext.Vendor;

  this.m_TooltipsManager.HideTooltips();
  if Equals(InventoryItemData.GetItemType(inspectedItemData), gamedataItemType.Prt_Program) {
    this.m_TooltipsManager.ShowTooltipAtWidget(n"programTooltip", targetWidget, data, placement);
  } else {
    if Equals(InventoryItemData.GetEquipmentArea(inspectedItemData), gamedataEquipmentArea.SystemReplacementCW) {
      this.m_TooltipsManager.ShowTooltipAtWidget(n"cyberdeckTooltip", targetWidget, data, placement);
    } else {
      this.m_TooltipsManager.ShowTooltipAtWidget(n"itemTooltip", targetWidget, data, placement);
    };
  };
}
