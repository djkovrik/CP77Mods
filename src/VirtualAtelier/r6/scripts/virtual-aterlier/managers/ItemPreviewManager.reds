module VendorPreview.ItemPreviewManager

import VendorPreview.utils.*
import VendorPreview.constants.*

@addField(PlayerPuppet)
public let itemPreviewManager: ref<ItemPreviewManager>;

@addField(AllBlackboardDefinitions)
public let itemPreviewManager: wref<ItemPreviewManager>;

public class PreviewInventoryItemPreviewData extends InventoryItemPreviewData {
  let displayContext: ItemDisplayContext;
}

public class ItemPreviewManager {
  public let gameInstance: GameInstance;
  public let puppetId: EntityID;
  public let garmentPreviewController: ref<GarmentItemPreviewGameController>;

  public let givenItems: array<ItemID>;
  public let initialItems: array<wref<gameItemData>>;

  public let screenWidthLimit: Float;

  private func Initialize(gameInstance: GameInstance, puppetId: EntityID, opt garmentPreviewController: ref<GarmentItemPreviewGameController>) {
    this.gameInstance = gameInstance;
    this.puppetId = puppetId;
    this.garmentPreviewController = garmentPreviewController;

    let transactionSystem: wref<TransactionSystem> = this.GetTransactionSystem();
    let gamePuppet: ref<gamePuppet> = this.GetGamePuppet();
    transactionSystem.GetItemList(gamePuppet, this.initialItems);
  }

  public static func CreateInstance(puppet: ref<gamePuppet>, opt garmentPreviewController: ref<GarmentItemPreviewGameController>) {
    let instance: ref<ItemPreviewManager> = new ItemPreviewManager();

    let gameInstance = puppet.GetGame();
    let puppetEntityId = puppet.GetEntityID();

    instance.Initialize(gameInstance, puppetEntityId, garmentPreviewController);

    let player = GetPlayer(gameInstance);
    player.itemPreviewManager = instance;
    GetAllBlackboardDefs().itemPreviewManager = instance;

    instance.screenWidthLimit = instance.CalculateScreenWidthLimit();
  }
  
  public static func GetInstance() -> wref<ItemPreviewManager> {
    return GetAllBlackboardDefs().itemPreviewManager;
  }

  public func GetGamePuppet() -> ref<gamePuppet> {
    return GameInstance.FindEntityByID(this.gameInstance, this.puppetId) as gamePuppet;
  }

  public func GetTransactionSystem() -> ref<TransactionSystem> {
    return GameInstance.GetTransactionSystem(this.gameInstance);
  }

  public func UpdateGivenItems(itemId: ItemID) -> Void {
    ArrayPush(this.givenItems, itemId);
  }

  public func RemoveGivenItem(itemId: ItemID) -> Void {
    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    let transactionSystem: ref<TransactionSystem> = this.GetTransactionSystem();
      
    let placementSlot: TweakDBID = EquipmentSystem.GetPlacementSlot(itemId);
    let currentItem: ItemID = transactionSystem.GetItemInSlot(puppet, placementSlot).GetItemID();

    let updatedGivenItems: array<ItemID>;
    let i: Int32 = 0;

    while i < ArraySize(this.givenItems) {
      if !Equals(currentItem, this.givenItems[i]) {
        ArrayPush(updatedGivenItems, this.givenItems[i]);
      }

      i += 1;
    }

    this.givenItems = updatedGivenItems;
  }

  public func GetIsEquipped(itemId: ItemID) -> Bool {
    let i = 0;
    let isEquipped = false;

    let puppet: ref<gamePuppet> = this.GetGamePuppet();
    let transactionSystem: ref<TransactionSystem> = this.GetTransactionSystem();
      
    let placementSlot: TweakDBID = EquipmentSystem.GetPlacementSlot(itemId);
    let currentItem: ItemID = transactionSystem.GetItemInSlot(puppet, placementSlot).GetItemID();

    return Equals(currentItem, itemId);
  }

  public func UnequipItem(itemId: ItemID) -> Void {
    let puppet: ref<gamePuppet>;
    let transactionSystem: ref<TransactionSystem>;

    puppet = this.GetGamePuppet();

    if !IsDefined(puppet) { 
      return;
    }

    transactionSystem = this.GetTransactionSystem();

    let itemSlot = EquipmentSystem.GetPlacementSlot(itemId);

    transactionSystem.RemoveItemFromSlot(puppet, itemSlot, true);
    transactionSystem.RemoveItem(puppet, itemId, 1);

    this.RemoveGivenItem(itemId);
  }

  public func TogglePreviewItem(itemData: InventoryItemData) -> Void {
    let itemId = InventoryItemData.GetID(itemData);
    let puppet: ref<gamePuppet>;
    let transactionSystem: ref<TransactionSystem>;

    puppet = this.GetGamePuppet();

    if !IsDefined(puppet) { 
      return;
    }

    transactionSystem = this.GetTransactionSystem();
    let isEquipped = this.GetIsEquipped(itemId);
  
    if isEquipped {
      this.UnequipItem(itemId);
    } else {
      let placementSlot: TweakDBID;
      let initialItem: ItemID;
      
      placementSlot = EquipmentSystem.GetPlacementSlot(itemId);
      initialItem = transactionSystem.GetItemInSlot(puppet, placementSlot).GetItemID();
  
      transactionSystem.RemoveItemFromSlot(puppet, placementSlot, true);

      let board: wref<IBlackboard> = GameInstance.GetBlackboardSystem(puppet.GetGame()).Get(GetAllBlackboardDefs().VirtualShop);
      let atelierItems: array<ItemID> = FromVariant(board.GetVariant(GetAllBlackboardDefs().VirtualShop.AtelierItems));
      ArrayPush(atelierItems, itemId);
      board.SetVariant(GetAllBlackboardDefs().VirtualShop.AtelierItems, ToVariant(atelierItems));

      transactionSystem.GiveItem(puppet, itemId, 1);
      transactionSystem.AddItemToSlot(puppet, placementSlot, itemId);

      this.UpdateGivenItems(itemId);
    }
  }

  public func RemoveAllGarment() -> Void {
    let puppet: ref<gamePuppet>;
    let transactionSystem: ref<TransactionSystem>;

    let puppet = this.GetGamePuppet();

    if !IsDefined(puppet) { 
      return;
    }

    let transactionSystem = this.GetTransactionSystem();

    if ArraySize(this.initialItems) < 1 {
      return;
    }

    let j: Int32 = 0;

    while j < ArraySize(this.initialItems) {
      let currItemId: ItemID = this.initialItems[j].GetID();

      let isWeapon = IsItemWeapon(currItemId);
      let isClothing = IsItemClothing(currItemId);

      if (isWeapon || isClothing) {
        let currSlot = EquipmentSystem.GetPlacementSlot(currItemId);

        transactionSystem.RemoveItemFromSlot(puppet, currSlot, true);
      }
     
      j += 1;
    };

    this.RemovePreviewGarment();
  }

  public func RemovePreviewGarment() -> Void {
    let puppet: ref<gamePuppet>;
    let transactionSystem: ref<TransactionSystem>;

    let puppet = this.GetGamePuppet();

    if !IsDefined(puppet) { 
      return;
    }

    let transactionSystem = this.GetTransactionSystem();
    let equipmentData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(puppet);

    if ArraySize(this.givenItems) < 1 {
      return;
    }

    let i: Int32 = 0;

    while i < ArraySize(this.givenItems) {
      let currItemId: ItemID = this.givenItems[i];
      let currSlot = EquipmentSystem.GetPlacementSlot(currItemId);

      transactionSystem.RemoveItemFromSlot(puppet, currSlot, true);
      transactionSystem.RemoveItem(puppet, currItemId, 1);

      i += 1;
    };

    ArrayClear(this.givenItems);
  }

  public func RevertInitialGarment() -> Void {
    let puppet: ref<gamePuppet>;
    let transactionSystem: ref<TransactionSystem>;

    let puppet = this.GetGamePuppet();

    if !IsDefined(puppet) { 
      return;
    }

    let transactionSystem = this.GetTransactionSystem();

    if ArraySize(this.initialItems) < 1 {
      return;
    }

    let j: Int32 = 0;

    while j < ArraySize(this.initialItems) {
      let currItemId: ItemID = this.initialItems[j].GetID();
      let currSlot = EquipmentSystem.GetPlacementSlot(currItemId);

      transactionSystem.AddItemToSlot(puppet, currSlot, currItemId);
     
      j += 1;
    };
  }

  public func ResetGarment() {
    this.RemovePreviewGarment();
    this.RevertInitialGarment();
  }

  public static func GetItemPreviewNotificationToken(controller: ref<gameuiMenuGameController>, itemData: InventoryItemData) -> ref<inkGameNotificationToken> {
    let notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\item_preview.inkwidget";

    let previewData = ItemPreviewHelper.GetPreviewData(controller, itemData, false);
    
    return controller.ShowGameNotification(previewData);
  }

  public static func GetGarmentPreviewNotificationToken(controller: ref<gameuiMenuGameController>, displayContext: ItemDisplayContext) -> ref<inkGameNotificationToken> {
    let notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\garment_item_preview.inkwidget";

    let previewData: ref<PreviewInventoryItemPreviewData> = new PreviewInventoryItemPreviewData();

    previewData.queueName = n"modal_popup";
    previewData.notificationName = notificationName;
    previewData.isBlocking = false;
    previewData.useCursor = false;
    previewData.displayContext = displayContext;
    
    return controller.ShowGameNotification(previewData);
  }
  
  public static func GetGarmentPreviewNotificationToken(controller: ref<gameuiInGameMenuGameController>, displayContext: ItemDisplayContext) -> ref<inkGameNotificationToken> {
    let notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\garment_item_preview.inkwidget";

    let previewData: ref<PreviewInventoryItemPreviewData> = new PreviewInventoryItemPreviewData();

    previewData.queueName = n"modal_popup";
    previewData.notificationName = notificationName;
    previewData.isBlocking = false;
    previewData.useCursor = false;
    previewData.displayContext = displayContext;
    
    return controller.ShowGameNotification(previewData);
  }

  public static func ToggleCraftableItemsPanel(controller: ref<BackpackMainGameController>, isPreviewMode: Bool) {
    let i = 0;
    let count = ArraySize(controller.m_craftingMaterialsListItems);

    while i <= count {
      let currController = controller.m_craftingMaterialsListItems[i];

      currController.GetRootWidget().SetVisible(!isPreviewMode);

      i += 1;
    }
  }

  public static func TogglePlayerPanel(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) -> Void {
    // Toggle the left side of the vendor inventory, which holds the player's items
    // It's hidden when previewing garments on puppet
	  let playerPanelPath = inkWidgetPath.Build(n"wrapper", n"wrapper", n"playerPanel");

	  controller.GetRootCompoundWidget().GetWidgetByPath(playerPanelPath).SetVisible(!isPreviewMode);
  }

  public static func AddPreviewModeToggleButtonHint(controller: ref<FullscreenVendorGameController>) {
    if !controller.GetIsVirtual() {
      let vendorPreviewButtonHint = VendorPreviewButtonHint.Get();

      controller.m_buttonHintsController.AddButtonHint(
        vendorPreviewButtonHint.previewModeToggleName,
        vendorPreviewButtonHint.previewModeToggleEnableLabel
      );
    }
  }

  public static func UpdateButtonHints(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) {
    let vendorPreviewButtonHint = VendorPreviewButtonHint.Get();
    let isVirtual: Bool = controller.GetIsVirtual();

    if (isPreviewMode) {
      controller.m_buttonHintsController.RemoveButtonHint(n"back");
      controller.m_buttonHintsController.RemoveButtonHint(n"sell_junk");
      controller.m_buttonHintsController.RemoveButtonHint(n"toggle_comparison_tooltip");

      if (!isVirtual) {
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName,vendorPreviewButtonHint.previewModeToggleDisableLabel);
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.zoomName, vendorPreviewButtonHint.zoomLabel);
      } else {
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.zoomName, vendorPreviewButtonHint.zoomLabel + " (+ Ctrl)");
      }

      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.resetGarmentName, vendorPreviewButtonHint.resetGarmentLabel);
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.removeAllGarmentName, vendorPreviewButtonHint.removeAllGarmentLabel);
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.removePreviewGarmentName, vendorPreviewButtonHint.removePreviewGarmentLabel);
      controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.moveName, vendorPreviewButtonHint.moveLabel);
      controller.m_buttonHintsController.AddCharacterRoatateButtonHint();
    } else {
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.previewModeToggleName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.resetGarmentName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.removeAllGarmentName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.zoomName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.moveName);
      controller.m_buttonHintsController.RemoveButtonHint(vendorPreviewButtonHint.removePreviewGarmentName);
      controller.m_buttonHintsController.HideCharacterRotateButtonHint();

      if (!isVirtual) {
        controller.m_buttonHintsController.AddButtonHint(vendorPreviewButtonHint.previewModeToggleName, vendorPreviewButtonHint.previewModeToggleEnableLabel);
      }
      
      controller.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
      controller.m_buttonHintsController.AddButtonHint(n"sell_junk", GetLocalizedText("UI-UserActions-SellJunk"));
      controller.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(controller.m_isComparisionDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
    }
  }

  public static func ToggleVendorFilters(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) {
    if (controller.GetIsVirtual()) {
      return;
    } else {
      if (isPreviewMode) {
        inkWidgetRef.SetVisible(controller.m_vendorFiltersContainer, false);
        controller.m_vendorItemsDataView.SetFilterType(ItemFilterCategory.Clothes);
        controller.ToggleFilter(controller.m_vendorFiltersContainer, EnumInt(ItemFilterCategory.Clothes));
      } else {
        inkWidgetRef.SetVisible(controller.m_vendorFiltersContainer, true);

        controller.PopulateVendorInventory();
      }
    }
  }

  public static func OnToggleGarmentPreview(controller: ref<FullscreenVendorGameController>, isPreviewMode: Bool) {
    ItemPreviewManager.TogglePlayerPanel(controller, isPreviewMode);
    ItemPreviewManager.UpdateButtonHints(controller, isPreviewMode);
    ItemPreviewManager.ToggleVendorFilters(controller, isPreviewMode);
  }

  public static func RegisterGlobalInputListeners(controller: ref<GarmentItemPreviewGameController>) {

    controller.RegisterToGlobalInputCallback(n"OnPostOnPress", controller, n"OnGlobalPress");
    controller.RegisterToGlobalInputCallback(n"OnPostOnPress", controller, n"OnReleaseButton");
    controller.RegisterToGlobalInputCallback(n"OnPostOnRelative", controller, n"OnRelativeInput");
    controller.RegisterToGlobalInputCallback(n"OnPostOnHold", controller, n"OnPostOnHold");
  }

  public static func AdjustGarmentPreviewWidgets(controller: ref<GarmentItemPreviewGameController>) {
    ItemPreviewManager.RegisterGlobalInputListeners(controller);

    let rootCompoundWidget = controller.GetRootCompoundWidget();
    let backgroundWidget: wref<inkWidget> = rootCompoundWidget.GetWidget(n"bg");
    let previewWidget = rootCompoundWidget.GetWidget(n"wrapper/preview") as inkImage;
    let windowWidget = rootCompoundWidget.GetWidget(n"wrapper/window") as inkWidget;

    previewWidget.SetMargin(0, 0, 960, 0);
    backgroundWidget.SetVisible(false);
    windowWidget.SetVisible(false);

    let transparencyInterpolator: ref<inkAnimTransparency>;
    let translationAnimation: ref<inkAnimDef> = new inkAnimDef();

    transparencyInterpolator = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(0.25);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetStartTransparency(0);
    transparencyInterpolator.SetEndTransparency(1);

    translationAnimation.AddInterpolator(transparencyInterpolator);
    previewWidget.PlayAnimation(translationAnimation);
  }

  public static func OnGarmentPreviewAxisInput(controller: ref<GarmentItemPreviewGameController>, event: ref<inkPointerEvent>) -> Bool {
    let amount: Float = event.GetAxisData();

    if event.IsAction(n"character_preview_rotate") {
      controller.Rotate(amount * -60.0);
    } else {
      if event.IsAction(n"left_trigger") {
        controller.Rotate(amount * -60.0);
      } else {
        if event.IsAction(n"right_trigger") {
          controller.Rotate(amount * 60.0);
        };
      };
    }
  }      

  public static func OnGarmentPreviewRelativeInput(controller: ref<GarmentItemPreviewGameController>, event: ref<inkPointerEvent>) -> Bool {
    let previewWidget = controller.GetRootCompoundWidget().GetWidgetByPath(inkWidgetPath.Build(n"wrapper", n"preview")) as inkImage;

    let widget: ref<inkWidget> = event.GetTarget();
    let parent = controller.GetRootCompoundWidget();

    // Allow player puppet dragging and scrolling only for left side of the screen
    let screenPosition: Vector2 = event.GetScreenSpacePosition();
    let limit: Float = ItemPreviewManager.GetInstance().GetScreenWidthLimit();
    let isScaleAllowed: Bool = screenPosition.X < limit;

    if !Equals(NameToString(widget.GetName()), "None") {
      return true;
    } else {
      let amount: Float = event.GetAxisData();
      let zoomRatio: Float = 0.1;

      if controller.m_isLeftMouseDown {
        if event.IsAction(n"mouse_x") && isScaleAllowed {
          previewWidget.ChangeTranslation(new Vector2(amount, 0.0));      
        };
        if event.IsAction(n"mouse_y") && isScaleAllowed {
          previewWidget.ChangeTranslation(new Vector2(0.0, -1.0 * amount));
        };
      };

      if event.IsAction(n"mouse_wheel") && isScaleAllowed {
        let currentScale = previewWidget.GetScale();

        let finalXScale = currentScale.X + (amount * zoomRatio);
        let finalYScale = currentScale.Y + (amount * zoomRatio);

        if (finalXScale < 0.5) {
          finalXScale = 0.5;
        }

        if (finalYScale > 3.0) {
          finalYScale = 3.0;
        }

        if (finalYScale < 0.5) {
          finalYScale = 0.5;
        }

        if (finalXScale > 3.0) {
          finalXScale = 3.0;
        }
            
        previewWidget.SetScale(new Vector2(finalXScale, finalYScale));
      }; 
    }
  }

  public func GetScreenWidthLimit() -> Float {
    return this.screenWidthLimit;
  }

  private func CalculateScreenWidthLimit() -> Float {
    let settings: ref<UserSettings> = GameInstance.GetSettingsSystem(this.gameInstance);
    let config: ref<ConfigVarListString> = settings.GetVar(n"/video/display", n"Resolution") as ConfigVarListString;
    let resolution: String = config.GetValue();
    let dimensions: array<String> = StrSplit(resolution, "x");
    return StringToFloat(dimensions[0]) / 2.0;
  }
}
