import EquipmentEx.OutfitSystem
import EquipmentEx.Codeware.UI.*

public class EquipmentExSlotsGameController extends inkPuppetPreviewGameController {

  private let m_player: wref<PlayerPuppet>;

  private let m_uiScriptableSystem: wref<UIScriptableSystem>;

  private let m_TooltipsManager: wref<gameuiTooltipsManager>;

  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_filtersContainer: ref<inkWidget>;

  private let m_filtersRadioGroup: ref<FilterRadioGroup>;

  private let m_filterManager: ref<ItemCategoryFliterManager>;

  private let m_InventoryManager: ref<InventoryDataManagerV2>;

  private let m_uiInventorySystem: wref<UIInventoryScriptableSystem>;

  private let m_outfitSystem: wref<OutfitSystem>;

  private let m_itemsClassifier: ref<CustomItemDisplayTemplateClassifier>;

  private let m_playerItemsDataView: ref<VendorDataView>;

  private let m_playerItemsDataSource: ref<ScriptableDataSource>;

  private let m_playerItemsVirtualListController: wref<inkVirtualGridController>;

  private let m_scrollController: wref<inkScrollController>;

  private let m_playerUIInventoryItems: array<ref<UIInventoryItem>>;

  private let m_lastVendorFilter: ItemFilterCategory;

  private let m_lastItemHoverOverEvent: ref<ItemDisplayHoverOverEvent>;

  private let m_itemDisplayContext: ref<ItemDisplayContextData>;

  private let m_textInput: ref<HubTextInput>;

  private let m_outfitsList: ref<inkVerticalPanel>;

  private let m_buttonCreate: ref<SimpleButton>;

  private let m_buttonDelete: ref<SimpleButton>;

  private let m_buttonEquip: ref<SimpleButton>;

  private let m_selectedOutfit: CName;

  private let m_equippedOutfit: CName;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.SpawnFromExternal(this.GetRootCompoundWidget(), r"base\\gameplay\\gui\\ex\\outfit.inkwidget", n"Root");

    this.m_player = this.GetPlayerControlledObject() as PlayerPuppet;
    this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_TooltipsManager = this.GetControllerByType(n"gameuiTooltipsManager", inkWidgetPath.Build(n"Root")) as gameuiTooltipsManager;
    this.m_TooltipsManager.Setup(ETooltipsStyle.Menus);
    this.m_buttonHintsController = this.SpawnFromExternal(this.GetRootCompoundWidget().GetWidget(n"Root/button_hints"), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
    this.m_InventoryManager = new InventoryDataManagerV2();
    this.m_InventoryManager.Initialize(this.m_player);
    this.m_uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_outfitSystem = OutfitSystem.GetInstance(this.m_player.GetGame());

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let scrollable: ref<inkWidget> = root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/inventoryContainer");
    let grid: ref<inkWidget> = root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/inventoryContainer/stash_scroll_area_cache/scrollArea/vendor_virtualgrid");
    this.m_playerItemsVirtualListController = grid.GetController() as inkVirtualGridController;
    this.m_scrollController = scrollable.GetController() as inkScrollController;
    this.m_filtersContainer = root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/filtersContainer");
    this.m_filterManager = ItemCategoryFliterManager.Make();
    this.m_filtersRadioGroup = this.m_filtersContainer.GetController() as FilterRadioGroup;
    this.m_lastVendorFilter = ItemFilterCategory.AllItems;
    this.m_itemDisplayContext = ItemDisplayContextData.Make(this.m_player, ItemDisplayContext.Backpack);

    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");

    // Hide some stuff
    root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/vendoHeaderWrapper/vendorBalanceWrapper").SetVisible(false);
    root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/vendoHeaderWrapper/filtersorting_txt").SetVisible(false);
    root.GetWidget(n"Root/wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/dropdownButton5").SetVisible(false);
    
    this.InitializeVirtualItemLists();
    this.InitializeOutfitsLayout();
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  protected cb func OnUninitialize() -> Bool {
    this.PlaySound(n"GameMenu", n"OnClose");
    this.m_InventoryManager.ClearInventoryItemDataCache();
    this.m_InventoryManager.UnInitialize();
    this.m_uiInventorySystem.FlushFullscreenCache();
    this.m_playerItemsDataView.SetSource(null);
    this.m_playerItemsVirtualListController.SetSource(null);
    this.m_playerItemsVirtualListController.SetClassifier(null);
    this.m_itemsClassifier = null;
    this.m_playerItemsDataView = null;
    this.m_playerItemsDataSource = null;

    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalInput");
    this.m_textInput.UnregisterFromCallback(n"OnInput", this, n"OnTextInput");
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

  protected cb func OnFilterRadioItemHoverOver(evt: ref<FilterRadioItemHoverOver>) -> Bool {
    let tooltipData: ref<MessageTooltipData> = new MessageTooltipData();
    tooltipData.Title = NameToString(ItemFilterCategories.GetLabelKey(evt.identifier));
    this.m_TooltipsManager.ShowTooltipAtWidget(n"descriptionTooltip", evt.target, tooltipData, gameuiETooltipPlacement.RightTop, true);
  }

  protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
    let isEquipped: Bool = this.m_outfitSystem.IsEquipped(evt.uiInventoryItem.ID);
    if !isEquipped && evt.actionName.IsAction(n"equip_item") {
      EX(s">> equip \(GetLocalizedTextByKey(evt.uiInventoryItem.m_itemRecord.DisplayName()))");
      this.EquipItem(evt.uiInventoryItem.ID, evt.uiInventoryItem.targetPlacementSlot);
    } else {
      if isEquipped && evt.actionName.IsAction(n"unequip_item") {
        EX(s"<< uneqip \(GetLocalizedTextByKey(evt.uiInventoryItem.m_itemRecord.DisplayName()))");
        this.UnequipItem(evt.uiInventoryItem.ID, evt.uiInventoryItem.targetPlacementSlot);
      };
    }
  }

  protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
    let isEquipped: Bool = this.m_outfitSystem.IsEquipped(evt.uiInventoryItem.ID);
    if isEquipped {
      this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
    } else {
      this.m_buttonHintsController.AddButtonHint(n"equip_item", GetLocalizedText("UI-UserActions-Equip"));
    };

    this.ShowTooltipForUIInventoryItem(evt.widget, evt.uiInventoryItem);
  }

  private final func ShowTooltipForUIInventoryItem(widget: wref<inkWidget>, inspectedItem: wref<UIInventoryItem>) -> Void {
    let data: ref<UIInventoryItemTooltipWrapper>;
    let placement: gameuiETooltipPlacement = gameuiETooltipPlacement.LeftTop; // RightTop
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

  protected cb func OnGlobalInput(evt: ref<inkPointerEvent>) -> Void {
    if evt.IsAction(n"mouse_left") {
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        this.RequestSetFocus(null);
      };
    };
  }

  protected cb func OnTextInput(widget: wref<inkWidget>) -> Bool {
    this.RefreshOutfitControls();
  }

  protected cb func OnButtonClick(widget: wref<inkWidget>) -> Bool {
    let name: CName = widget.GetName();
    this.PlaySound(n"Button", n"OnPress");
    EX(s"BUTTON CLICKED: \(name)");

    switch name {
      case n"ButtonCreate":
        this.HandleCreateOutfitClick();
        break;
      case n"ButtonDelete":
        this.HandleDeleteOutfitClick();
        break;
      case n"ButtonEquip":
        this.HandleEquipOutfitClick();
        break;
    };
  }

  protected cb func OnOutfitItemClick(widget: wref<inkWidget>) -> Bool {
    let name: CName = widget.GetName();
    this.PlaySound(n"Button", n"OnPress");
    EX(s"OUTFIT CLICKED: \(name)");
    this.m_selectedOutfit = name;
    this.m_textInput.SetText("");
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  private final func SetFilters(data: array<Int32>, callback: CName) -> Void {
    this.m_filtersRadioGroup.SetData(data);
    this.m_filtersRadioGroup.RegisterToCallback(n"OnValueChanged", this, callback);
    if ArraySize(data) == 1 {
      this.m_filtersRadioGroup.Toggle(data[0]);
    };
  }

  private func InitializeVirtualItemLists() -> Void {
    this.m_itemsClassifier = new CustomItemDisplayTemplateClassifier();
    this.m_playerItemsDataView = new VendorDataView();
    this.m_playerItemsDataSource = new ScriptableDataSource();
    this.m_playerItemsDataView.BindUIScriptableSystem(this.m_uiScriptableSystem);
    this.m_playerItemsDataView.SetSource(this.m_playerItemsDataSource);
    this.m_playerItemsVirtualListController.SetClassifier(this.m_itemsClassifier);
    this.m_playerItemsVirtualListController.SetSource(this.m_playerItemsDataView);
    this.PopulateItemsList();
  }

  private func PopulateItemsList() -> Void {
    EX("PopulateItemsList");
    let items: array<ref<IScriptable>>;
    let playerItems: array<ref<gameItemData>>;
    this.m_filterManager.Clear();
    this.m_filterManager.AddFilter(ItemFilterCategory.AllItems);
    playerItems = this.m_InventoryManager.GetPlayerClothingItems();
    items = this.BuildCategorizedClothingList(playerItems);
    this.m_playerItemsDataSource.Reset(items);
    this.m_filterManager.SortFiltersList();
    this.m_filterManager.InsertFilter(0, ItemFilterCategory.AllItems);
    this.SetFilters(this.m_filterManager.GetIntFiltersList(), n"OnFilterChange");
    this.m_playerItemsDataView.SetFilterType(this.m_lastVendorFilter);
    this.ToggleFilter(EnumInt(this.m_lastVendorFilter));
    this.m_filtersContainer.SetVisible(ArraySize(items) > 0);
    this.PlayLibraryAnimation(n"vendor_grid_show");
  }

  private final func ToggleFilter(data: Int32) -> Void {
    this.m_filtersRadioGroup.ToggleData(data);
  }

  private func GetAllClothesForSlot(playerItems: array<ref<gameItemData>>, slot: TweakDBID) -> array<ref<gameItemData>> {
    let result: array<ref<gameItemData>>;
    for item in playerItems {
      if ArrayContains(item.supportedSlots, slot) && this.m_outfitSystem.IsEquippable(item.GetID(), slot) {
        ArrayPush(result, item);
      };
    };
    return result;
  }

  private func GetCurrentlyEquippedItemName(categoryItems: array<ref<gameItemData>>) -> String {
    let itemRecord: ref<Item_Record>;
    for item in categoryItems {
      if this.m_outfitSystem.IsEquipped(item.GetID()) {
        itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(item.GetID()));
        return GetLocalizedTextByKey(itemRecord.DisplayName());
      };
    };
    return GetLocalizedTextByKey(n"UI-CharacterCreation-None");
  }

  private func BuildCategorizedClothingList(playerItems: array<ref<gameItemData>>) -> array<ref<IScriptable>> {
    let managedSlots: array<TweakDBID> = this.m_outfitSystem.GetManagedSlots();
    let result: array<ref<IScriptable>>;
    let slotItems: array<ref<gameItemData>>;
    let uiInventoryItem: ref<UIInventoryItem>;
    let header: ref<VendorUIInventoryItemData>;
    let itemData: ref<VendorUIInventoryItemData>;
    let itemsCount: Int32;
    let secondaryInfo: String;

    for supportedSlot in managedSlots {
      slotItems = this.GetAllClothesForSlot(playerItems, supportedSlot);
      itemsCount = ArraySize(slotItems);
      if itemsCount > 0 {
        secondaryInfo = s"\(GetLocalizedTextByKey(n"UI-ItemLabel-Equipped")): ";
        secondaryInfo += this.GetCurrentlyEquippedItemName(slotItems);
        secondaryInfo += s" | \(GetLocalizedTextByKey(n"Gameplay-Devices-Interactions-Total")): \(itemsCount)";
        header = this.BuildHeaderItem(this.m_outfitSystem.GetSlotName(supportedSlot), secondaryInfo);
        ArrayPush(result, header);
        for item in slotItems {
          uiInventoryItem = UIInventoryItem.Make(this.m_player, item, this.m_uiInventorySystem.GetInventoryItemsManager());
          uiInventoryItem.targetPlacementSlot = supportedSlot;
          itemData = new VendorUIInventoryItemData();
          itemData.Item = uiInventoryItem;
          itemData.DisplayContextData = this.m_itemDisplayContext;
          ArrayPush(result, itemData);
          // this.m_filterManager.AddItem(itemData.Item.GetFilterCategory());
        };
      };
    };

    return result;
  }

  private func BuildHeaderItem(title: String, subtitle: String) -> ref<VendorUIInventoryItemData> {
    let header: ref<VendorUIInventoryItemData> = new VendorUIInventoryItemData();
    header.Item = new UIInventoryItem();
    header.customHeaderPrimary = title;
    header.customHeaderSecondary = subtitle;
    return header;
  }

  private func EquipItem(itemId: ItemID, targetSlot: TweakDBID) -> Void {
    this.m_outfitSystem.EquipItem(itemId, targetSlot);
    this.PopulateItemsList();
  }

  private func UnequipItem(itemId: ItemID, targetSlot: TweakDBID) -> Void {
    this.m_outfitSystem.UnequipItem(itemId);
    this.PopulateItemsList();
  }

  private func InitializeOutfitsLayout() -> Void {
    let outerContainer: ref<inkCanvas> = new inkCanvas();
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
    inputLabel.SetFontSize(48);
    inputLabel.SetHAlign(inkEHorizontalAlign.Left);
    inputLabel.SetVAlign(inkEVerticalAlign.Top);
    inputLabel.SetAnchor(inkEAnchor.TopLeft);
    inputLabel.SetAnchorPoint(1.0, 1.0);
    inputLabel.SetLetterCase(textLetterCase.OriginalCase);
    inputLabel.SetMargin(new inkMargin(0.0, 0.0, 0.0, 15.0));
    inputLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    inputLabel.BindProperty(n"tintColor", n"MainColors.Blue");
    inputLabel.Reparent(verticalContainer);

    this.m_textInput = HubTextInput.Create();
    this.m_textInput.SetName(n"TextInput");
    this.m_textInput.SetMaxLength(64);
    this.m_textInput.RegisterToCallback(n"OnInput", this, n"OnTextInput");
    this.m_textInput.Reparent(verticalContainer);

    let buttonsContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    buttonsContainer.SetName(n"Horizontal");
    buttonsContainer.SetChildMargin(new inkMargin(10.0, 30.0, 10.0, 20.0));
    buttonsContainer.Reparent(verticalContainer);

    // Buttons
    this.m_buttonCreate = SimpleButton.Create();
    this.m_buttonCreate.SetName(n"ButtonCreate");
    this.m_buttonCreate.SetText("Create");
    this.m_buttonCreate.RegisterToCallback(n"OnBtnClick", this, n"OnButtonClick");
    this.m_buttonCreate.Reparent(buttonsContainer);

    this.m_buttonDelete = SimpleButton.Create();
    this.m_buttonDelete.SetName(n"ButtonDelete");
    this.m_buttonDelete.SetText("Delete");
    this.m_buttonDelete.RegisterToCallback(n"OnBtnClick", this, n"OnButtonClick");
    this.m_buttonDelete.Reparent(buttonsContainer);

    let bottomButtonContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
    bottomButtonContainer.SetName(n"Vertical2");
    bottomButtonContainer.SetChildMargin(new inkMargin(10.0, 0.0, 10.0, 0.0));
    bottomButtonContainer.SetHAlign(inkEHorizontalAlign.Center);
    bottomButtonContainer.SetVAlign(inkEVerticalAlign.Top);
    bottomButtonContainer.Reparent(verticalContainer);

    this.m_buttonEquip = SimpleButton.Create();
    this.m_buttonEquip.SetName(n"ButtonEquip");
    this.m_buttonEquip.SetText("Equip");
    this.m_buttonEquip.RegisterToCallback(n"OnBtnClick", this, n"OnButtonClick");
    this.m_buttonEquip.SetFlipped(true);
    this.m_buttonEquip.Reparent(bottomButtonContainer);

    this.m_outfitsList = new inkVerticalPanel();
    this.m_outfitsList.SetName(n"OutfitsList");
    this.m_outfitsList.SetHAlign(inkEHorizontalAlign.Left);
    this.m_outfitsList.SetVAlign(inkEVerticalAlign.Fill);
    this.m_outfitsList.SetMargin(new inkMargin(0.0, 20.0, 0.0, 0.0));
    this.m_outfitsList.Reparent(verticalContainer);

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
    let enableCreateButton: Bool = NotEquals(this.m_textInput.GetText(), "");
    let enableDeleteButton: Bool = NotEquals(this.m_selectedOutfit, n"");
    let enableEquipButton: Bool = NotEquals(this.m_selectedOutfit, n"") && NotEquals(this.m_selectedOutfit, this.m_equippedOutfit);
    this.m_buttonCreate.SetDisabled(!enableCreateButton);
    this.m_buttonDelete.SetDisabled(!enableDeleteButton);
    this.m_buttonEquip.SetDisabled(!enableEquipButton);
  }

  private func HandleCreateOutfitClick() -> Void {
    let name: CName = StringToName(this.m_textInput.GetText());
    this.m_outfitSystem.SaveOutfit(name, true);
    this.m_selectedOutfit = name;
    this.m_equippedOutfit = name;
    this.m_textInput.SetText("");
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  private func HandleDeleteOutfitClick() -> Void {
    this.m_outfitSystem.DeleteOutfit(this.m_selectedOutfit);
    if Equals(this.m_selectedOutfit, this.m_equippedOutfit) {
      this.m_equippedOutfit = n"";
    };
    this.m_selectedOutfit = n"";
    this.m_textInput.SetText("");
    this.RefreshOutfitList();
    this.RefreshOutfitControls();
  }

  private func HandleEquipOutfitClick() -> Void {
    this.m_outfitSystem.LoadOutfit(this.m_selectedOutfit);
    this.m_equippedOutfit = this.m_selectedOutfit;
    this.RefreshOutfitList();
    this.PopulateItemsList();
    this.RefreshOutfitControls();
  }
}
