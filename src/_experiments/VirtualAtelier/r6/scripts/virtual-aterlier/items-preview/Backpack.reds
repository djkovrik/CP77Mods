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
private final func ShowItemPreview(opt itemData: InventoryItemData) -> Void {
  let itemId = InventoryItemData.GetID(itemData);

  this.m_previewItemPopupToken = ItemPreviewManager.GetItemPreviewNotificationToken(this, itemData);

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

  let vendorPreviewButtonHint = VendorPreviewButtonHint.Get();
  let itemId = InventoryItemData.GetID(displayingData);

  this.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName, "Preview Item");
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOut() -> Void {
  wrappedMethod();

  this.m_buttonHintsController.RemoveButtonHint(VendorPreviewButtonHint.Get().previewModeToggleName);
}

@wrapMethod(BackpackMainGameController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if (this.m_isPreviewMode) {
    return true;
  } else {
    wrappedMethod(evt);
  }
}

@replaceMethod(BackpackMainGameController)
 protected cb func OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
   if evt.actionName.IsAction(VendorPreviewButtonHint.Get().previewModeToggleName) {
    this.ShowItemPreview(evt.itemData);
  } else {
    if (this.m_isPreviewMode) {
      return true;
    } else {
      let item: ItemModParams;
      let isUsable: Bool = IsDefined(ItemActionsHelper.GetConsumeAction(InventoryItemData.GetGameItemData(evt.itemData).GetID())) || IsDefined(ItemActionsHelper.GetEatAction(InventoryItemData.GetGameItemData(evt.itemData).GetID())) || IsDefined(ItemActionsHelper.GetDrinkAction(InventoryItemData.GetGameItemData(evt.itemData).GetID())) || IsDefined(ItemActionsHelper.GetLearnAction(InventoryItemData.GetGameItemData(evt.itemData).GetID())) || IsDefined(ItemActionsHelper.GetDownloadFunds(InventoryItemData.GetGameItemData(evt.itemData).GetID()));
      if evt.actionName.IsAction(n"drop_item") {
        if Equals(this.playerState, gamePSMVehicle.Default) && RPGManager.CanItemBeDropped(this.m_player, InventoryItemData.GetGameItemData(evt.itemData)) && InventoryGPRestrictionHelper.CanDrop(evt.itemData, this.m_player) {
          if InventoryItemData.GetQuantity(evt.itemData) > 1 {
            this.OpenQuantityPicker(evt.itemData, QuantityPickerActionType.Drop);
          } else {
            this.PlaySound(n"ItemGeneric", n"OnDrop");
            item.itemID = InventoryItemData.GetID(evt.itemData);
            item.quantity = 1;
            this.AddToDropQueue(item);
            this.RefreshUI();
          };
        } else {
          this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
        };
      } else {
        if evt.actionName.IsAction(n"equip_item") {
          this.EquipItem(evt.itemData);
        } else {
          if evt.actionName.IsAction(n"use_item") && isUsable {
            if !InventoryGPRestrictionHelper.CanUse(evt.itemData, this.m_player) {
              this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
              return false;
            };
            this.PlaySound(n"ItemConsumableFood", n"OnUse");
            if Equals(InventoryItemData.GetItemType(evt.itemData), gamedataItemType.Con_Skillbook) {
              this.SetWarningMessage(GetLocalizedText("LocKey#46534") + "\\n" + GetLocalizedText(InventoryItemData.GetDescription(evt.itemData)));
            };
            ItemActionsHelper.PerformItemAction(this.m_player, InventoryItemData.GetID(evt.itemData));
            this.m_InventoryManager.MarkToRebuild();
            this.RefreshUI();
          };
        };
      };
    }
  }
}

@wrapMethod(BackpackMainGameController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData) -> Void {
  wrappedMethod(displayingData);

  if this.m_isPreviewMode {
    this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
    this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
  }
}