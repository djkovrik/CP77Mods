import EquipmentEx.OutfitSystem
import EquipmentEx.StashSystem
import EquipmentEx.Codeware.UI.*

public class EquipmentExSlotsGameController extends inkPuppetPreviewGameController {

  private let m_player: wref<PlayerPuppet>;

  private let m_inventoryBlackboard: wref<IBlackboard>;

  private let m_itemAddedCallback: ref<CallbackHandle>;

  private let m_itemRemovedCallback: ref<CallbackHandle>;

  private let m_uiScriptableSystem: wref<UIScriptableSystem>;

  private let m_TooltipsManager: wref<gameuiTooltipsManager>;

  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_filtersContainer: ref<inkWidget>;

  private let m_filtersRadioGroup: ref<FilterRadioGroup>;

  private let m_filterManager: ref<ItemCategoryFliterManager>;

  private let m_InventoryManager: ref<InventoryDataManagerV2>;

  private let m_uiInventorySystem: wref<UIInventoryScriptableSystem>;

  private let m_outfitSystem: wref<OutfitSystem>;

  private let m_itemsClassifier: ref<EquipmentExTemplateClassifier>;

  private let m_playerItemsDataView: ref<BackpackDataView>;

  private let m_playerItemsDataSource: ref<ScriptableDataSource>;

  private let m_playerItemsVirtualListController: wref<inkVirtualGridController>;

  private let m_scrollController: wref<inkScrollController>;

  private let m_playerUIInventoryItems: array<ref<UIInventoryItem>>;

  private let m_lastVendorFilter: ItemFilterCategory;

  private let m_lastItemHoverOverEvent: ref<ItemDisplayHoverOverEvent>;

  private let m_itemDisplayContext: ref<ItemDisplayContextData>;

  private let m_outfitNameInput: ref<HubTextInput>;

  private let m_searchFieldInput: ref<HubTextInput>;

  private let m_outfitsList: ref<inkVerticalPanel>;

  private let m_buttonCreate: ref<SimpleButton>;

  private let m_buttonDelete: ref<SimpleButton>;

  private let m_buttonEquip: ref<SimpleButton>;

  private let m_buttonUnequip: ref<SimpleButton>;

  private let m_preview: wref<inkWidget>;

  private let m_selectedOutfit: CName;

  private let m_equippedOutfit: CName;

  private let m_previewInputThreshold: Float;

  private let m_leftMouseButtonPressed: Bool;

  private let m_rightMouseButtonPressed: Bool;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.SpawnFromExternal(this.GetRootCompoundWidget(), r"base\\gameplay\\gui\\ex\\outfit.inkwidget", n"Root");

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let scrollable: ref<inkWidget> = root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/inventoryContainer");
    let grid: ref<inkWidget> = root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/inventoryContainer/stash_scroll_area_cache/scrollArea/vendor_virtualgrid");

    this.m_player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.m_inventoryBlackboard = GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).Get(GetAllBlackboardDefs().UI_Inventory);
    this.m_itemAddedCallback = this.m_inventoryBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this, n"OnInventoryItemsChanged");
    this.m_itemRemovedCallback = this.m_inventoryBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this, n"OnInventoryItemsChanged");
    this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_TooltipsManager = this.GetControllerByType(n"gameuiTooltipsManager", inkWidgetPath.Build(n"Root")) as gameuiTooltipsManager;
    this.m_TooltipsManager.Setup(ETooltipsStyle.Menus);
    this.m_buttonHintsController = this.SpawnFromExternal(this.GetRootCompoundWidget().GetWidget(n"Root/button_hints"), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
    this.m_buttonHintsController.AddButtonHint(n"world_map_fake_rotate", GetLocalizedTextByKey(n"Gameplay-Player-ButtonHelper-Move"));
    this.m_buttonHintsController.AddButtonHint(n"mouse_wheel", GetLocalizedTextByKey(n"Gameplay-Devices-DisplayNames-Scale"));
    this.m_buttonHintsController.AddButtonHint(n"mouse_left", GetLocalizedTextByKey(n"UI-ResourceExports-Rotate"));
    this.m_InventoryManager = new InventoryDataManagerV2();
    this.m_InventoryManager.Initialize(this.m_player);
    this.m_uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_outfitSystem = OutfitSystem.GetInstance(this.m_player.GetGame());
    this.m_playerItemsVirtualListController = grid.GetController() as inkVirtualGridController;
    this.m_scrollController = scrollable.GetController() as inkScrollController;
    this.m_filtersContainer = root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/filtersContainer");
    this.m_filterManager = ItemCategoryFliterManager.Make();
    this.m_filtersRadioGroup = this.m_filtersContainer.GetController() as FilterRadioGroup;
    this.m_lastVendorFilter = ItemFilterCategory.AllItems;
    this.m_itemDisplayContext = ItemDisplayContextData.Make(this.m_player, ItemDisplayContext.GearPanel);
    this.m_preview = root.GetWidget(n"Root/wrapper/wrapper/preview");
    this.m_previewInputThreshold = this.GetScreenWidthLimit();

    this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelative", this, n"OnRelativeInput");

    // Hide eddies label and sorting dropdown
    // TODO edit inkwidget maybe?
    root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/vendoHeaderWrapper/vendorBalanceWrapper").SetVisible(false);
    root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/vendoHeaderWrapper/filtersorting_txt").SetVisible(false);
    root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/dropdownButton5").SetVisible(false);
    
    this.InitializeVirtualItemLists();
    this.InitializeOutfitsLayout();
    this.InitializeSearchField();
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  protected cb func OnUninitialize() -> Bool {
    this.PlaySound(n"GameMenu", n"OnClose");
    this.m_buttonHintsController.RemoveButtonHint(n"back");
    this.m_buttonHintsController.RemoveButtonHint(n"world_map_fake_rotate");
    this.m_buttonHintsController.RemoveButtonHint(n"mouse_wheel");
    this.m_buttonHintsController.RemoveButtonHint(n"mouse_left");
    this.m_InventoryManager.ClearInventoryItemDataCache();
    this.m_InventoryManager.UnInitialize();
    this.m_uiInventorySystem.FlushFullscreenCache();
    this.m_playerItemsDataView.SetSource(null);
    this.m_playerItemsVirtualListController.SetSource(null);
    this.m_playerItemsVirtualListController.SetClassifier(null);
    this.m_itemsClassifier = null;
    this.m_playerItemsDataView = null;
    this.m_playerItemsDataSource = null;
    this.m_searchFieldInput.UnregisterFromCallback(n"OnInput", this, n"OnSearchFieldInput");
    this.m_outfitNameInput.UnregisterFromCallback(n"OnInput", this, n"OnOutfitNameInput");

    this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelative", this, n"OnRelativeInput");

    this.m_inventoryBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this.m_itemAddedCallback);
    this.m_inventoryBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved,this.m_itemRemovedCallback);
  }

  protected cb func OnFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
    let category: ItemFilterCategory = this.m_filterManager.GetAt(selectedIndex);
    this.m_playerItemsDataView.SetFilterType(category);
    this.m_lastVendorFilter = category;
    this.m_playerItemsDataView.SetSortMode(this.m_playerItemsDataView.GetSortMode());
    this.PlayLibraryAnimation(n"vendor_grid_show");
    this.PlaySound(n"Button", n"OnPress");
    this.m_scrollController.SetScrollPosition(0.0);
  }

  protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
    if evt.actionName.IsAction(n"equip_item") {
      if !evt.uiInventoryItem.IsEquipped() {
        this.EquipItem(evt.uiInventoryItem.ID);
      };
    } else {
      if evt.actionName.IsAction(n"unequip_item") {
        if evt.uiInventoryItem.IsEquipped() {
          this.UnequipItem(evt.uiInventoryItem.ID);
        };
      };
    };
  }

  protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
    if evt.uiInventoryItem.IsEquipped() {
      this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
    } else {
      this.m_buttonHintsController.AddButtonHint(n"equip_item", GetLocalizedText("UI-UserActions-Equip"));
    };

    this.ShowTooltipForUIInventoryItem(evt.widget, evt.uiInventoryItem);
  }

  private final func ShowTooltipForUIInventoryItem(widget: wref<inkWidget>, inspectedItem: wref<UIInventoryItem>) -> Void {
    let data: ref<UIInventoryItemTooltipWrapper>;
    let placement: gameuiETooltipPlacement = gameuiETooltipPlacement.RightTop;
    this.m_TooltipsManager.HideTooltips();
    if IsDefined(inspectedItem) {
      data = UIInventoryItemTooltipWrapper.Make(inspectedItem, this.m_itemDisplayContext);
      this.m_TooltipsManager.ShowTooltipAtWidget(n"itemTooltip", widget, data, placement);
    };
  }

  protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
    this.m_TooltipsManager.HideTooltips();
    this.m_buttonHintsController.RemoveButtonHint(n"equip_item");
    this.m_buttonHintsController.RemoveButtonHint(n"unequip_item");
    this.m_lastItemHoverOverEvent = null;
  }

  protected cb func OnGlobalPress(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"mouse_left") {
      this.m_leftMouseButtonPressed = true;
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        this.RequestSetFocus(null);
      };
    };
    if evt.IsAction(n"world_map_fake_rotate") {
      this.m_rightMouseButtonPressed = true;
    };
  }

  protected cb func OnGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
    if this.m_leftMouseButtonPressed && evt.IsAction(n"mouse_left") {
      this.m_leftMouseButtonPressed = false;
    };
    if this.m_rightMouseButtonPressed && evt.IsAction(n"world_map_fake_rotate") {
      this.m_rightMouseButtonPressed = false;
    };
  }

  protected cb func OnRelativeInput(evt: ref<inkPointerEvent>) -> Bool {
    let screenPosition: Vector2 = evt.GetScreenSpacePosition();
    let isPreviewInputAllowed: Bool = screenPosition.X < this.m_previewInputThreshold;
    let amount: Float = evt.GetAxisData();

    if this.m_rightMouseButtonPressed && isPreviewInputAllowed {
      if evt.IsAction(n"mouse_x") {
        this.m_preview.ChangeTranslation(new Vector2(amount, 0.0));      
      };
      if evt.IsAction(n"mouse_y") {
        this.m_preview.ChangeTranslation(new Vector2(0.0, -1.0 * amount));
      };
    };

    if this.m_leftMouseButtonPressed && isPreviewInputAllowed && evt.IsAction(n"mouse_x") {
      this.RotatePuppetOnInput(evt);
    };

    // disable items scroll for preview scaling
    this.m_scrollController.SetInputDisabled(isPreviewInputAllowed);

    let zoomRatio: Float = 0.1;
    if evt.IsAction(n"mouse_wheel") && isPreviewInputAllowed {
      let currentScale = this.m_preview.GetScale();
      let finalXScale = currentScale.X + (amount * zoomRatio);
      let finalYScale = currentScale.Y + (amount * zoomRatio);

      if (finalXScale < 0.5) {
        finalXScale = 0.5;
      };

      if (finalYScale > 3.0) {
        finalYScale = 3.0;
      };

      if (finalYScale < 0.5) {
        finalYScale = 0.5;
      };

      if (finalXScale > 3.0) {
        finalXScale = 3.0;
      };
          
      this.m_preview.SetScale(new Vector2(finalXScale, finalYScale));
    }; 

    return true;
  }

  // TODO fix dis
  private func RotatePuppetOnInput(evt: ref<inkPointerEvent>) -> Void {
    let ratio: Float;
    let velocity: Float;
    let offset: Float = evt.GetAxisData();
    if offset > 0.00 {
      ratio = ClampF(offset / 40.0, 0.50, 1.00);
    } else {
      ratio = ClampF(offset / 40.0, -1.00, -0.50);
    };
    velocity = ratio * 250.0;
    this.Rotate(velocity);
  }

  private func GetAnimFeature(out animFeature: ref<AnimFeature_Paperdoll>) -> Void {
    animFeature = new AnimFeature_Paperdoll();
    animFeature.inventoryScreen = true;
  }

  protected cb func OnOutfitNameInput(widget: wref<inkWidget>) -> Bool {
    this.RefreshOutfitControls();
  }

  protected cb func OnSearchFieldInput(widget: wref<inkWidget>) -> Bool {
    this.PopulateItemsList();
    this.m_scrollController.SetScrollPosition(0.0);
  }

  protected cb func OnOutfitItemClick(widget: wref<inkWidget>) -> Bool {
    let name: CName = widget.GetName();
    this.PlaySound(n"Button", n"OnPress");
    this.m_selectedOutfit = name;
    this.m_outfitNameInput.SetText("");
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  protected cb func OnCreateOutfitClick(widget: wref<inkWidget>) -> Bool {
    let name: CName = StringToName(this.m_outfitNameInput.GetText());
    this.PlaySound(n"Button", n"OnPress");
    this.m_outfitSystem.SaveOutfit(name, true);
    this.m_selectedOutfit = name;
    this.m_equippedOutfit = name;
    this.m_outfitNameInput.SetText("");
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  protected cb func OnDeleteOutfitClick(widget: wref<inkWidget>) -> Bool {
    this.PlaySound(n"Button", n"OnPress");
    this.m_outfitSystem.DeleteOutfit(this.m_selectedOutfit);
    if Equals(this.m_selectedOutfit, this.m_equippedOutfit) {
      this.m_equippedOutfit = n"";
    };
    this.m_selectedOutfit = n"";
    this.m_outfitNameInput.SetText("");
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  protected cb func OnEquipOutfitClick(widget: wref<inkWidget>) -> Bool {
    this.PlaySound(n"Button", n"OnPress");
    this.m_outfitSystem.LoadOutfit(this.m_selectedOutfit);
    this.m_equippedOutfit = this.m_selectedOutfit;
    this.RefreshOutfitList();
    this.PopulateItemsList();
    this.RefreshOutfitControls();
  }

  protected cb func OnUnequipOutfitClick(widget: wref<inkWidget>) -> Bool {
    this.PlaySound(n"Button", n"OnPress");
    this.m_outfitSystem.Deactivate();
    this.m_equippedOutfit = n"";
    this.RefreshOutfitList();
    this.PopulateItemsList();
    this.RefreshOutfitControls();
  }

  protected cb func OnInventoryItemsChanged(value: Variant) -> Bool {
    this.PopulateItemsList();
  }

  private final func SetFilters(data: array<Int32>, callback: CName) -> Void {
    this.m_filtersRadioGroup.SetData(data);
    this.m_filtersRadioGroup.RegisterToCallback(n"OnValueChanged", this, callback);
    if ArraySize(data) == 1 {
      this.m_filtersRadioGroup.Toggle(data[0]);
    };
  }

  private func InitializeVirtualItemLists() -> Void {
    this.m_itemsClassifier = new EquipmentExTemplateClassifier();
    this.m_playerItemsDataSource = new ScriptableDataSource();
    this.m_playerItemsDataView = new BackpackDataView(); // VendorDataView
    this.m_playerItemsDataView.BindUIScriptableSystem(this.m_uiScriptableSystem);
    this.m_playerItemsDataView.SetSource(this.m_playerItemsDataSource);
    this.m_playerItemsVirtualListController.SetClassifier(this.m_itemsClassifier);
    this.m_playerItemsVirtualListController.SetSource(this.m_playerItemsDataView);
    this.PopulateItemsList();
  }

  private func PopulateItemsList() -> Void {
    let playerItems: array<wref<gameItemData>> = this.m_InventoryManager.GetPlayerClothingItems();
    StashSystem.GetInstance(this.m_player.GetGame()).GetItemList(playerItems);
    let items: array<ref<IScriptable>> = this.BuildCategorizedClothingList(playerItems);

    this.m_filterManager.Clear();
    this.m_filterManager.AddFilter(ItemFilterCategory.AllItems);
    this.m_filterManager.SortFiltersList();
    // this.m_filterManager.InsertFilter(0, ItemFilterCategory.AllItems);
    // this.SetFilters(this.m_filterManager.GetIntFiltersList(), n"OnFilterChange");
    this.m_playerItemsDataView.SetFilterType(this.m_lastVendorFilter);
    // this.ToggleFilter(EnumInt(this.m_lastVendorFilter));
    // this.m_filtersContainer.SetVisible(ArraySize(items) > 0);

    this.m_playerItemsDataSource.Reset(items);

    this.PlayLibraryAnimation(n"vendor_grid_show");
  }

  private final func ToggleFilter(data: Int32) -> Void {
    this.m_filtersRadioGroup.ToggleData(data);
  }

  private func GetAllClothesForSlot(playerItems: array<wref<gameItemData>>, slot: TweakDBID, searchQuery: String) -> array<wref<gameItemData>> {
    let result: array<wref<gameItemData>>;
    for item in playerItems {
      if this.ShouldDisplayInCategory(item, slot, searchQuery) {
        ArrayPush(result, item);
      };
    };
    return result;
  }

  private func ShouldDisplayInCategory(item: ref<gameItemData>, slot: TweakDBID, searchQuery: String) -> Bool {
    let isEquippable: Bool = this.m_outfitSystem.IsEquippable(item.GetID(), slot);
    let isNameContainsQuery: Bool = this.IsNameContainsStr(item, searchQuery);
    return isEquippable && isNameContainsQuery;
  }

  private func IsNameContainsStr(item: ref<gameItemData>, searchQuery: String) -> Bool {
    if Equals(searchQuery, "") {
      return true;
    };

    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(item.GetID()));
    let localizedName: String = StrLower(GetLocalizedTextByKey(itemRecord.DisplayName()));
    return StrContains(localizedName, searchQuery);
  }

  private func BuildCategorizedClothingList(playerItems: array<wref<gameItemData>>) -> array<ref<IScriptable>> {
    let searchQuery: String = StrLower(this.m_searchFieldInput.GetText());
    let outfitSlots: array<TweakDBID> = this.m_outfitSystem.GetOutfitSlots();
    let result: array<ref<IScriptable>>;
    let slotItems: array<wref<gameItemData>>;
    let header: ref<VendorUIInventoryItemData>;
    let itemData: ref<VendorUIInventoryItemData>;
    let itemsCount: Int32;

    for outfitSlot in outfitSlots {
      slotItems = this.GetAllClothesForSlot(playerItems, outfitSlot, searchQuery);
      itemsCount = ArraySize(slotItems);
      if itemsCount > 0 {
        header = new VendorUIInventoryItemData();
        header.Item = new UIInventoryItem();
        header.ItemData.SlotID = outfitSlot;
        header.ItemData.CategoryName = this.m_outfitSystem.GetSlotName(outfitSlot);
        
        ArrayPush(result, header);

        for item in slotItems {
          itemData = new VendorUIInventoryItemData();
          itemData.Item = UIInventoryItem.Make(this.m_player, item, this.m_uiInventorySystem.GetInventoryItemsManager());
          itemData.DisplayContextData = this.m_itemDisplayContext;

          ArrayPush(result, itemData);

          if itemData.Item.IsEquipped() {
            header.ItemData.ID = item.GetID();
            header.ItemData.Name = this.m_outfitSystem.GetItemName(item.GetID());
          };
        }
      }
    }

    return result;
  }

  private func EquipItem(itemId: ItemID) -> Void {
    this.m_outfitSystem.EquipItem(itemId);
    this.PopulateItemsList();
    this.RefreshOutfitControls();
  }

  private func UnequipItem(itemId: ItemID) -> Void {
    this.m_outfitSystem.UnequipItem(itemId);
    this.PopulateItemsList();
    this.RefreshOutfitControls();
  }

  private func InitializeOutfitsLayout() -> Void {
    let outerContainer: ref<inkCanvas> = new inkCanvas();
    outerContainer.SetName(n"OuterContainer");
    outerContainer.SetMargin(new inkMargin(100.0, 180.0, 0.0, 0.0));
    outerContainer.Reparent(this.GetRootCompoundWidget());

    let verticalContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
    verticalContainer.SetName(n"Vertical");
    verticalContainer.SetChildMargin(new inkMargin(0.0, 0.0, 20.0, 0.0));
    verticalContainer.Reparent(outerContainer);

    let inputLabel: ref<inkText> = new inkText();
    inputLabel = new inkText();
    inputLabel.SetName(n"InputLabel");
    inputLabel.SetText("Manage outfits:");
    inputLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    inputLabel.SetFontSize(42);
    inputLabel.SetHAlign(inkEHorizontalAlign.Left);
    inputLabel.SetVAlign(inkEVerticalAlign.Top);
    inputLabel.SetAnchor(inkEAnchor.TopLeft);
    inputLabel.SetAnchorPoint(1.0, 1.0);
    inputLabel.SetLetterCase(textLetterCase.OriginalCase);
    inputLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 15.0));
    inputLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    inputLabel.BindProperty(n"tintColor", n"MainColors.Blue");
    inputLabel.Reparent(verticalContainer);

    this.m_outfitNameInput = HubTextInput.Create();
    this.m_outfitNameInput.SetName(n"OutfitNameTextInput");
    this.m_outfitNameInput.SetMaxLength(64);
    this.m_outfitNameInput.RegisterToCallback(n"OnInput", this, n"OnOutfitNameInput");
    this.m_outfitNameInput.Reparent(verticalContainer);

    let buttonsContainer1: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    buttonsContainer1.SetName(n"Horizontal1");
    buttonsContainer1.SetChildMargin(new inkMargin(10.0, 30.0, 10.0, 20.0));
    buttonsContainer1.Reparent(verticalContainer);

    // Buttons
    this.m_buttonCreate = SimpleButton.Create();
    this.m_buttonCreate.SetName(n"ButtonCreate");
    this.m_buttonCreate.SetText("Create");
    this.m_buttonCreate.SetFlipped(true);
    this.m_buttonCreate.RegisterToCallback(n"OnBtnClick", this, n"OnCreateOutfitClick");
    this.m_buttonCreate.Reparent(buttonsContainer1);

    this.m_buttonDelete = SimpleButton.Create();
    this.m_buttonDelete.SetName(n"ButtonDelete");
    this.m_buttonDelete.SetText("Delete");
    this.m_buttonDelete.RegisterToCallback(n"OnBtnClick", this, n"OnDeleteOutfitClick");
    this.m_buttonDelete.Reparent(buttonsContainer1);

    let buttonsContainer2: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    buttonsContainer2.SetName(n"Horizontal2");
    buttonsContainer2.SetChildMargin(new inkMargin(10.0, 30.0, 10.0, 20.0));
    buttonsContainer2.Reparent(verticalContainer);

    this.m_buttonEquip = SimpleButton.Create();
    this.m_buttonEquip.SetName(n"ButtonEquip");
    this.m_buttonEquip.SetText("Equip");
    this.m_buttonEquip.RegisterToCallback(n"OnBtnClick", this, n"OnEquipOutfitClick");
    this.m_buttonEquip.SetFlipped(true);
    this.m_buttonEquip.Reparent(buttonsContainer2);

    this.m_buttonUnequip = SimpleButton.Create();
    this.m_buttonUnequip.SetName(n"ButtonUnequip");
    this.m_buttonUnequip.SetText("Unequip");
    this.m_buttonUnequip.RegisterToCallback(n"OnBtnClick", this, n"OnUnequipOutfitClick");
    this.m_buttonUnequip.Reparent(buttonsContainer2);

    this.m_outfitsList = new inkVerticalPanel();
    this.m_outfitsList.SetName(n"OutfitsList");
    this.m_outfitsList.SetHAlign(inkEHorizontalAlign.Left);
    this.m_outfitsList.SetVAlign(inkEVerticalAlign.Fill);
    this.m_outfitsList.SetMargin(new inkMargin(0.0, 20.0, 0.0, 0.0));
    this.m_outfitsList.Reparent(verticalContainer);
  }

  private func InitializeSearchField() -> Void {
    let parentContainer: ref<inkCanvas> = this.GetRootCompoundWidget().GetWidget(n"Root/wrapper/wrapper") as inkCanvas;
    let searchContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
    searchContainer.SetName(n"SearchContainer");
    searchContainer.SetMargin(new inkMargin(0.0, 140.0, 440.0, 0.0));
    searchContainer.SetHAlign(inkEHorizontalAlign.Right);
    searchContainer.SetVAlign(inkEVerticalAlign.Top);
    searchContainer.SetAnchor(inkEAnchor.TopRight);
    searchContainer.SetFitToContent(true);
    searchContainer.SetAnchorPoint(1.0, 0.0);
    searchContainer.SetChildMargin(new inkMargin(0.0, 0.0, 20.0, 0.0));
    searchContainer.Reparent(parentContainer);

    let inputLabel: ref<inkText> = new inkText();
    inputLabel = new inkText();
    inputLabel.SetName(n"SearchLabel");
    inputLabel.SetText("Search:");
    inputLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    inputLabel.SetFontSize(42);
    inputLabel.SetHAlign(inkEHorizontalAlign.Left);
    inputLabel.SetVAlign(inkEVerticalAlign.Top);
    inputLabel.SetAnchor(inkEAnchor.TopLeft);
    inputLabel.SetAnchorPoint(1.0, 1.0);
    inputLabel.SetLetterCase(textLetterCase.OriginalCase);
    inputLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 15.0));
    inputLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    inputLabel.BindProperty(n"tintColor", n"MainColors.Blue");
    inputLabel.Reparent(searchContainer);

    this.m_searchFieldInput = HubTextInput.Create();
    this.m_searchFieldInput.SetName(n"SearchTextInput");
    this.m_searchFieldInput.SetMaxLength(64);
    this.m_searchFieldInput.RegisterToCallback(n"OnInput", this, n"OnSearchFieldInput");
    this.m_searchFieldInput.Reparent(searchContainer);
  }

  private func RefreshOutfitList() -> Void {
    let item: ref<OutfitButton>;
    let outfitNames: array<CName> = this.m_outfitSystem.GetOutfits();
    this.m_outfitsList.RemoveAllChildren();
    for name in outfitNames {
      item = OutfitButton.Create();
      item.SetName(name);
      item.SetText(NameToString(name));
      item.RegisterToCallback(n"OnBtnClick", this, n"OnOutfitItemClick");
      if Equals(name, this.m_equippedOutfit) {
        item.SetEquipped(true);
      };

      item.SetSelected(Equals(name, this.m_selectedOutfit));
      item.Reparent(this.m_outfitsList);
    };
  }

  private func RefreshOutfitControls() -> Void {
    let enableCreateButton: Bool = NotEquals(this.m_outfitNameInput.GetText(), "") && this.m_outfitSystem.IsActive();
    let enableDeleteButton: Bool = NotEquals(this.m_selectedOutfit, n"");
    let enableEquipButton: Bool = NotEquals(this.m_selectedOutfit, n"") && NotEquals(this.m_selectedOutfit, this.m_equippedOutfit);
    let enableUnequipButton: Bool = NotEquals(this.m_selectedOutfit, n"") && Equals(this.m_selectedOutfit, this.m_equippedOutfit);
    this.m_buttonCreate.SetDisabled(!enableCreateButton);
    this.m_buttonDelete.SetDisabled(!enableDeleteButton);
    this.m_buttonEquip.SetDisabled(!enableEquipButton);
    this.m_buttonUnequip.SetDisabled(!enableUnequipButton);
  }

  private func GetScreenWidthLimit() -> Float {
    let settings: ref<UserSettings> = GameInstance.GetSettingsSystem(this.GetPlayerControlledObject().GetGame());
    let config: ref<ConfigVarListString> = settings.GetVar(n"/video/display", n"Resolution") as ConfigVarListString;
    let resolution: String = config.GetValue();
    let dimensions: array<String> = StrSplit(resolution, "x");
    return StringToFloat(dimensions[0]) / 2.0;
  }
}

public class EquipmentExTemplateClassifier extends inkVirtualItemTemplateClassifier {
  public func ClassifyItem(data: Variant) -> Uint32 {
    let wrappedData: ref<WrappedInventoryItemData> = FromVariant<ref<IScriptable>>(data) as WrappedInventoryItemData;
    if IsDefined(wrappedData) && wrappedData.IsSlotHeader() {
      return 1u;
    }
    return 0u;
  }
}
