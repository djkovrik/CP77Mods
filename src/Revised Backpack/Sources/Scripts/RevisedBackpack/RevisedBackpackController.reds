module RevisedBackpack

public class RevisedBackpackController extends gameuiMenuGameController {

  private let m_player: wref<PlayerPuppet>;
  private let m_system: wref<RevisedBackpackSystem>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_itemDisplayContext: ref<ItemDisplayContextData>;
  private let m_junkItems: array<ref<UIInventoryItem>>;
  private let m_customJunkItems: array<ref<RevisedItemWrapper>>;
  private let m_selectedItems: array<ref<RevisedItemWrapper>>;
  private let m_prevSelectedController: wref<RevisedBackpackItemController>;
  private let m_currSelectedController: wref<RevisedBackpackItemController>;
  private let m_fromToStartingController: wref<RevisedBackpackItemController>;
  private let m_itemDropQueueItems: array<ItemID>;
  private let m_itemDropQueue: array<ItemModParams>;
  private let m_isRefreshUIScheduled: Bool;

  private let m_EquippedCallback: ref<UI_EquipmentDef>;
  private let m_EquippedBlackboard: wref<IBlackboard>;
  private let m_EquippedBBID: ref<CallbackHandle>;
  private let m_InventoryCallback: ref<UI_InventoryDef>;
  private let m_InventoryBlackboard: wref<IBlackboard>;
  private let m_InventoryItemAddedBBID: ref<CallbackHandle>;
  private let m_InventoryItemRemvoedBBID: ref<CallbackHandle>;
  private let m_InventoryItemQuantityChangedBBID: ref<CallbackHandle>;
  private let m_comparisonResolver: ref<InventoryItemPreferredComparisonResolver>;
  private let m_comparedItemDisplayContext: ref<ItemDisplayContextData>;
  private let m_isComparisonDisabled: Bool;
  private let m_backpackInventoryListenerCallback: ref<RevisedBackpackInventoryListenerCallback>;
  private let m_immediateNotificationListener: ref<RevisedBakcpackImmediateNotificationListener>;
  private let m_backpackInventoryListener: ref<InventoryScriptListener>;
  private let m_equipSlotChooserPopupToken: ref<inkGameNotificationToken>;
  private let m_quantityPickerPopupToken: ref<inkGameNotificationToken>;
  private let m_disassembleJunkPopupToken: ref<inkGameNotificationToken>;
  private let m_confirmationPopupToken: ref<inkGameNotificationToken>;
  private let m_massActionPopupToken: ref<inkGameNotificationToken>;
  private let m_equipRequested: Bool;
  private let m_psmBlackboard: wref<IBlackboard>;
  private let playerState: gamePSMVehicle;

  private let itemsListController: wref<inkVirtualListController>;
  private let itemsListScrollController: wref<inkScrollController>;
  private let itemsListDataSource: ref<ScriptableDataSource>;
  private let itemsListDataView: ref<RevisedBackpackDataView>;
  private let itemsListTemplateClassifier: ref<RevisedBackpackTemplateClassifier>;

  private let m_virtualList: inkVirtualCompoundRef;
  private let m_scrollAreaContainer: inkWidgetRef;
  private let m_categoriesContainer: inkHorizontalPanelRef;
  private let m_categoryName: inkTextRef;
  private let m_categoryIndicator: inkWidgetRef;
  private let m_previewGarmentContainer: inkWidgetRef;
  private let m_previewItemContainer: inkWidgetRef;
  private let m_selectedItemsCount: inkTextRef;

  private let m_animTargetCategories: inkWidgetRef;
  private let m_animTargetFilters: inkWidgetRef;
  private let m_animTargetHeader: inkWidgetRef;
  private let m_animTargetList: inkWidgetRef;

  private let m_animProxyCategories: ref<inkAnimProxy>;
  private let m_animProxyFilters: ref<inkAnimProxy>;
  private let m_animProxyHeader: ref<inkAnimProxy>;
  private let m_animProxyList: ref<inkAnimProxy>;

  private let m_uiInventorySystem: wref<UIInventoryScriptableSystem>;
  private let m_inventoryManager: ref<InventoryDataManagerV2>;
  private let m_uiScriptableSystem: wref<UIScriptableSystem>;

  private let m_buttonHintsManagerRef: inkWidgetRef;
  private let m_buttonHintsController: wref<ButtonHints>;
  private let m_TooltipsManagerRef: inkWidgetRef;
  private let m_TooltipsManager: wref<gameuiTooltipsManager>;
  private let m_itemNotificationRoot: inkWidgetRef;

  private let m_afterCloseRequest: Bool;
  private let m_lastItemHoverOverEvent: ref<RevisedBackpackItemHoverOverEvent>;
  private let m_pressedItemDisplay: wref<RevisedBackpackItemController>;
  private let m_availableCategories: array<ref<RevisedBackpackCategory>>;
  private let m_cursorData: ref<MenuCursorUserData>;
  private let m_customJunkInvalidated: Bool;

  private let m_delayedOutfitCooldownResetCallbackId: DelayID;
  private let m_outfitInCooldown: Bool;
  private let m_outfitCooldownPeroid: Float;
  private let m_virtualWidgets: ref<inkWeakHashMap>;
  private let m_allWidgets: ref<inkWeakHashMap>;

  protected cb func OnInitialize() -> Bool {
    let playerPuppet: wref<GameObject>;
    this.m_backpackInventoryListenerCallback = new RevisedBackpackInventoryListenerCallback();
    this.m_backpackInventoryListenerCallback.Setup(this);
    this.m_buttonHintsController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
    this.m_TooltipsManager = inkWidgetRef.GetControllerByType(this.m_TooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
    this.m_TooltipsManager.Setup(ETooltipsStyle.Menus);
    this.RegisterToBB();
    this.AsyncSpawnFromExternal(inkWidgetRef.Get(this.m_itemNotificationRoot), r"base\\gameplay\\gui\\widgets\\activity_log\\activity_log_panels.inkwidget", n"RootVert");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnPostOnRelease");
    playerPuppet = this.GetOwnerEntity() as PlayerPuppet;
    this.m_psmBlackboard = this.GetPSMBlackboard(playerPuppet);
    this.playerState = IntEnum<gamePSMVehicle>(this.m_psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle));
    this.m_outfitCooldownPeroid = 0.4;
    this.m_customJunkInvalidated = false;

    this.itemsListController = inkWidgetRef.GetController(this.m_virtualList) as inkVirtualListController;
    this.itemsListScrollController = inkWidgetRef.GetControllerByType(this.m_scrollAreaContainer, n"inkScrollController") as inkScrollController;
    this.SpawnPreviews();
    super.OnInitialize();
  }

  protected cb func OnUninitialize() -> Bool {
    GameInstance.GetDelaySystem(this.m_player.GetGame()).CancelCallback(this.m_delayedOutfitCooldownResetCallbackId);
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnCloseMenu", this, n"OnCloseMenu");
    this.m_inventoryManager.UnInitialize();
    this.m_uiInventorySystem.FlushFullscreenCache();
    this.UnregisterFromBB();
    GameInstance.GetTransactionSystem(this.m_player.GetGame()).UnregisterInventoryListener(this.m_player, this.m_backpackInventoryListener);
    this.m_backpackInventoryListener = null;
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnPostOnRelease");
    super.OnUninitialize();
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    if this.m_player != null {
      GameInstance.GetTransactionSystem(this.m_player.GetGame()).UnregisterInventoryListener(this.m_player, this.m_backpackInventoryListener);
    };
    this.m_player = playerPuppet as PlayerPuppet;
    this.m_system = RevisedBackpackSystem.GetInstance(this.m_player.GetGame());
    this.m_availableCategories = this.m_system.GetCategories();
    this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_itemDisplayContext = ItemDisplayContextData.Make(this.m_player, ItemDisplayContext.Backpack, true);
    this.m_comparedItemDisplayContext = this.m_itemDisplayContext.Copy().SetDisplayComparison(false);
    this.m_inventoryManager = new InventoryDataManagerV2();
    this.m_inventoryManager.Initialize(this.m_player);
    this.m_comparisonResolver = InventoryItemPreferredComparisonResolver.Make(this.m_uiInventorySystem);
    this.m_backpackInventoryListener = GameInstance.GetTransactionSystem(this.m_player.GetGame()).RegisterInventoryListener(this.m_player, this.m_backpackInventoryListenerCallback);
    this.m_isComparisonDisabled = this.m_uiScriptableSystem.IsComparisionTooltipDisabled();

    if this.m_player.PlayerLastUsedKBM() {
      this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(this.m_isComparisonDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
    };
    
    this.UpdateSelectedItemsCounter();
    this.SetupVirtualList();
    this.PopulateCategories();
    this.PopulateInventory();
    this.PlayIntroAnimation();

    this.Log(s"OnPlayerAttach: service \(IsDefined(this.m_system)), categories: \(ArraySize(this.m_availableCategories))");
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    this.ResetVirtualList();
    this.StopAnimations();
  }

  protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
    let setComparisionDisabledRequest: ref<UIScriptableSystemSetComparisionTooltipDisabled>;
    if evt.IsAction(n"toggle_comparison_tooltip") && this.m_player.PlayerLastUsedKBM() {
      this.m_isComparisonDisabled = !this.m_isComparisonDisabled;
      this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(this.m_isComparisonDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
      setComparisionDisabledRequest = new UIScriptableSystemSetComparisionTooltipDisabled();
      setComparisionDisabledRequest.value = this.m_isComparisonDisabled;
      this.m_uiScriptableSystem.QueueRequest(setComparisionDisabledRequest);
      this.InvalidateItemTooltipEvent();
    };

    if evt.IsAction(n"mouse_left") {
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        this.RequestSetFocus(null);
      };
    };

    // down_button called first, UI_MoveDown called second, then revised_nav_down
    // UI_MoveUp called first, up_button called second, then revised_nav_up
    if evt.IsAction(n"revised_nav_up") { 
      this.TryToSelectPreviousItem();
    };

    if evt.IsAction(n"revised_nav_down") { 
      this.TryToSelectNextItem();
    };
  }

  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    this.Log("OnSetMenuEventDispatcher");
    super.OnSetMenuEventDispatcher(menuEventDispatcher);
    this.m_menuEventDispatcher = menuEventDispatcher;
    this.m_menuEventDispatcher.RegisterToEvent(n"OnBack", this, n"OnBack");
    this.m_menuEventDispatcher.RegisterToEvent(n"OnCloseMenu", this, n"OnCloseMenu");
  }

  protected cb func OnCloseMenu(userData: ref<IScriptable>) -> Bool {
    if ArraySize(this.m_itemDropQueue) == 1 && this.m_itemDropQueue[0].quantity == 1 {
      ItemActionsHelper.DropItem(this.m_player, this.m_itemDropQueue[0].itemID);
      ArrayClear(this.m_itemDropQueue);
    } else {
      if ArraySize(this.m_itemDropQueue) > 0 {
        RPGManager.DropManyItems(this.m_player.GetGame(), this.m_player, this.m_itemDropQueue);
        ArrayClear(this.m_itemDropQueue);
      };
    };
  }

  protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    if !this.m_afterCloseRequest {
      super.OnBack(userData);
    } else {
      this.m_afterCloseRequest = false;
    };
  }

  private final func RegisterToBB() -> Void {
    this.m_EquippedCallback = GetAllBlackboardDefs().UI_Equipment;
    this.m_InventoryCallback = GetAllBlackboardDefs().UI_Inventory;
    this.m_EquippedBlackboard = this.GetBlackboardSystem().Get(this.m_EquippedCallback);
    this.m_InventoryBlackboard = this.GetBlackboardSystem().Get(this.m_InventoryCallback);
    if IsDefined(this.m_EquippedBlackboard) {
      this.m_EquippedBBID = this.m_EquippedBlackboard.RegisterDelayedListenerVariant(this.m_EquippedCallback.itemEquipped, this, n"OnItemEquipped", true);
    };
    if IsDefined(this.m_InventoryBlackboard) {
      this.m_InventoryItemAddedBBID = this.m_InventoryBlackboard.RegisterDelayedListenerVariant(this.m_InventoryCallback.itemRemoved, this, n"OnInventoryItemRemoved", false);
      this.m_InventoryItemRemvoedBBID = this.m_InventoryBlackboard.RegisterDelayedListenerVariant(this.m_InventoryCallback.itemAdded, this, n"OnInventoryItemAdded", false);
      this.m_InventoryItemQuantityChangedBBID = this.m_InventoryBlackboard.RegisterDelayedListenerVariant(this.m_InventoryCallback.itemQuantityChanged, this, n"OnInventoryItemQuantityChanged", false);
    };
  }

  private final func UnregisterFromBB() -> Void {
    if IsDefined(this.m_EquippedBlackboard) {
      this.m_EquippedBlackboard.UnregisterDelayedListener(this.m_EquippedCallback.itemEquipped, this.m_EquippedBBID);
    };
    if IsDefined(this.m_InventoryBlackboard) {
      this.m_InventoryBlackboard.UnregisterDelayedListener(this.m_InventoryCallback.itemRemoved, this.m_InventoryItemAddedBBID);
      this.m_InventoryBlackboard.UnregisterDelayedListener(this.m_InventoryCallback.itemAdded, this.m_InventoryItemRemvoedBBID);
      this.m_InventoryBlackboard.UnregisterDelayedListener(this.m_InventoryCallback.itemQuantityChanged, this.m_InventoryItemQuantityChangedBBID);
    };
  }

  private final func SetupVirtualList() -> Void {
    this.itemsListDataSource = new ScriptableDataSource();
    this.itemsListDataView = new RevisedBackpackDataView();
    this.itemsListDataView.Init();
    this.itemsListDataView.BindUIScriptableSystem(this.m_uiScriptableSystem);
    this.itemsListDataView.SetSource(this.itemsListDataSource);
    this.itemsListDataView.EnableSorting();
    this.itemsListTemplateClassifier = new RevisedBackpackTemplateClassifier();
    this.itemsListController.SetClassifier(this.itemsListTemplateClassifier);
    this.itemsListController.SetSource(this.itemsListDataView);
    this.Log(s"InitializeVirtualList: \(IsDefined(this.itemsListController)) \(IsDefined(this.itemsListScrollController))");
  }

  private final func ResetVirtualList() -> Void {
    this.itemsListController.SetSource(null);
    this.itemsListController.SetClassifier(null);
    this.itemsListDataView.SetSource(null);
    this.itemsListDataView = null;
    this.itemsListDataSource = null;
    this.itemsListTemplateClassifier = null;
  }

  private final func PlayIntroAnimation() -> Void {
    let duration: Float = 0.2;
    let categories: ref<inkAnimDef> = this.AnimateTranslationAndOpacity(new Vector2(0.0, -200.0), new Vector2(0.0, 0.0), duration, 0.0);
    let header: ref<inkAnimDef> = this.AnimateTranslationAndOpacity(new Vector2(0.0, -100.0), new Vector2(0.0, 0.0), duration, 0.0);
    let filters: ref<inkAnimDef> = this.AnimateTranslationAndOpacity(new Vector2(0.0, 100.0), new Vector2(0.0, 0.0), duration, 0.0);
    let list: ref<inkAnimDef> = this.AnimateOpacity(duration, duration);

    this.m_animProxyCategories = inkWidgetRef.PlayAnimation(this.m_animTargetCategories, categories);
    this.m_animProxyHeader = inkWidgetRef.PlayAnimation(this.m_animTargetHeader, header);
    this.m_animProxyFilters = inkWidgetRef.PlayAnimation(this.m_animTargetFilters, filters);
    this.m_animProxyList = inkWidgetRef.PlayAnimation(this.m_animTargetList, list);
  }

  private final func StopAnimations() -> Void {
    if IsDefined(this.m_animProxyCategories) {
      if this.m_animProxyCategories.IsPlaying() {
        this.m_animProxyCategories.Stop();
        this.m_animProxyCategories = null;
      };
    }

    if IsDefined(this.m_animProxyFilters) {
      if this.m_animProxyFilters.IsPlaying() {
        this.m_animProxyFilters.Stop();
        this.m_animProxyFilters = null;
      };
    }

    if IsDefined(this.m_animProxyHeader) {
      if this.m_animProxyHeader.IsPlaying() {
        this.m_animProxyHeader.Stop();
        this.m_animProxyHeader = null;
      };
    }

    if IsDefined(this.m_animProxyList) {
      if this.m_animProxyList.IsPlaying() {
        this.m_animProxyList.Stop();
        this.m_animProxyList = null;
      };
    }
  }

  public final func OnBakcpackItemDisplayNotification(message: ItemDisplayNotificationMessage, id: Uint64, opt data: wref<IScriptable>) -> Void {
    if Equals(message, ItemDisplayNotificationMessage.AddRef) {
      this.m_virtualWidgets.Remove(id);
      this.m_virtualWidgets.Insert(id, data);
    } else {
      if Equals(message, ItemDisplayNotificationMessage.RemoveRef) {
        this.m_virtualWidgets.Remove(id);
      };
    };
  }

  protected cb func OnItemEquipped(value: Variant) -> Bool {
    if this.m_equipRequested {
      this.RefreshUINextFrame();
      this.m_equipRequested = false;
      this.m_comparisonResolver.FlushCache();
    };
  }

  protected cb func OnInventoryItemRemoved(value: Variant) -> Bool {
    let itemAddedData: ItemAddedData = FromVariant<ItemAddedData>(value);
    this.HandleItemQuantityModified(itemAddedData.itemID, itemAddedData.isBackpackItem);
  }

  protected cb func OnInventoryItemAdded(value: Variant) -> Bool {
    let itemRemovedData: ItemRemovedData = FromVariant<ItemRemovedData>(value);
    this.HandleItemQuantityModified(itemRemovedData.itemID, itemRemovedData.isBackpackItem);
  }

  protected cb func OnInventoryItemQuantityChanged(value: Variant) -> Bool {
    let itemQuantityChangedData: ItemQuantityChangedData = FromVariant<ItemQuantityChangedData>(value);
    this.HandleItemQuantityModified(itemQuantityChangedData.itemID, itemQuantityChangedData.isBackpackItem);
  }

  private final func HandleItemQuantityModified(itemID: ItemID, backpackItem: Bool) -> Void {
    if backpackItem {
      if !this.m_uiInventorySystem.GetPlayerItem(itemID).GetItemData().HasTag(n"CraftingPart") {
        this.RefreshUINextFrame();
      };
    };
  }

  private final func TryToSelectNextItem() -> Void {
    this.Log("TryToSelectNextItem");
    let selectedItems: Int32 = ArraySize(this.m_selectedItems);
    if selectedItems > 1 {
      return ;
    };

    let dataViewItemCount: Int32 = Cast<Int32>(this.itemsListDataView.Size());
    let selectedItemIndex: Int32 = this.TryToFindSelectedItemIndex();
    let targetItemIndex: Int32;
    if selectedItemIndex <= -1 || selectedItemIndex >= dataViewItemCount - 1 {
      targetItemIndex = 0;
    } else {
      targetItemIndex = selectedItemIndex + 1;
    };

    this.Log(s"Selected index \(selectedItemIndex), next index \(targetItemIndex)");
    let controllers: array<ref<RevisedBackpackItemController>> = this.GetListControllers();
    let nextItem: ref<RevisedItemWrapper> = this.itemsListDataView.GetItem(Cast<Uint32>(targetItemIndex)) as RevisedItemWrapper;
    if targetItemIndex > ArraySize(controllers) - 1 {  return ; };
    let nextItemController: ref<RevisedBackpackItemController> = controllers[targetItemIndex];
    if IsDefined(nextItem) {
      this.QueueEvent(RevisedBackpackItemSelectEvent.Create(nextItemController, nextItem, false, false));
    };
  }

  private final func TryToSelectPreviousItem() -> Void {
    this.Log("TryToSelectPreviousItem");
    let selectedItems: Int32 = ArraySize(this.m_selectedItems);
    if selectedItems > 1 {
      return ;
    };

    let dataViewItemCount: Int32 = Cast<Int32>(this.itemsListDataView.Size());
    let selectedItemIndex: Int32 = this.TryToFindSelectedItemIndex();
    let targetItemIndex: Int32;
    if Equals(selectedItemIndex, -1) || Equals(selectedItemIndex, 0) {
      targetItemIndex = dataViewItemCount - 1;
    } else {
      targetItemIndex = selectedItemIndex - 1;
    };

    this.Log(s"Selected index \(selectedItemIndex), next index \(targetItemIndex)");
    let controllers: array<ref<RevisedBackpackItemController>> = this.GetListControllers();
    let nextItem: ref<RevisedItemWrapper> = this.itemsListDataView.GetItem(Cast<Uint32>(targetItemIndex)) as RevisedItemWrapper;
    if targetItemIndex > ArraySize(controllers) - 1 {  return ; };
    let nextItemController: ref<RevisedBackpackItemController> = controllers[targetItemIndex];
    if IsDefined(nextItem) {
      this.QueueEvent(RevisedBackpackItemSelectEvent.Create(nextItemController, nextItem, false, false));
    };
  }

  private final func TryToFindItemIndex(item: ref<RevisedItemWrapper>) -> Int32 {
    if !IsDefined(item) { return -1; };
    let items: array<ref<RevisedItemWrapper>> = this.GetDataViewItems();
    let count: Int32 = ArraySize(items);
    let index: Int32 = 0;
    let wrapper: ref<RevisedItemWrapper>;
    while index < count {
      wrapper = items[index] as RevisedItemWrapper;
      if IsDefined(wrapper) {
        if Equals(item, wrapper) {
          return index;
        };
      };
      index += 1;
    };

    return -1;
  }

  private final func TryToFindSelectedItemIndex() -> Int32 {
    let items: array<ref<RevisedItemWrapper>> = this.GetDataViewItems();
    let count: Int32 = ArraySize(items);
    let index: Int32 = 0;
    let wrapper: ref<RevisedItemWrapper>;
    while index < count {
      wrapper = items[index] as RevisedItemWrapper;
      if IsDefined(wrapper) {
        if wrapper.GetSelectedFlag() {
          return index;
        };
      };
      index += 1;
    };

    return -1;
  }

  private final func RefreshUI() -> Void {
    this.PopulateInventory();
  }

  private final func RefreshUINextFrame() -> Void {
    if this.m_isRefreshUIScheduled {
      return;
    };
    this.m_isRefreshUIScheduled = true;
    this.QueueEvent(new BackpackUpdateNextFrameEvent());
  }

  protected cb func OnRefreshUINextFrame(e: ref<BackpackUpdateNextFrameEvent>) -> Bool {
    this.m_isRefreshUIScheduled = false;
    this.RefreshUI();
  }

  protected final func AddToDropQueue(item: ItemModParams) -> Void {
    let evt: ref<DropQueueUpdatedEvent>;
    let merged: Bool;
    let i: Int32 = 0;
    while i < ArraySize(this.m_itemDropQueue) {
      if this.m_itemDropQueue[i].itemID == item.itemID {
        this.m_itemDropQueue[i].quantity += item.quantity;
        merged = true;
        break;
      };
      i += 1;
    };
    if !merged {
      ArrayPush(this.m_itemDropQueue, item);
      ArrayPush(this.m_itemDropQueueItems, item.itemID);
    };
    evt = new DropQueueUpdatedEvent();
    evt.m_dropQueue = this.m_itemDropQueue;
    this.QueueEvent(evt);
  }

  private final func GetDropQueueItem(itemID: ItemID) -> ItemModParams {
    let dummy: ItemModParams;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_itemDropQueue);
    while i < limit {
      if this.m_itemDropQueue[i].itemID == itemID {
        return this.m_itemDropQueue[i];
      };
      i += 1;
    };
    return dummy;
  }

  private final func PopulateInventory() -> Void {
    let i: Int32;
    let limit: Int32;
    let quantity: Int32;
    let playerItems: ref<inkHashMap>;
    let tagsToFilterOut: array<CName>;
    let uiInventoryItem: ref<UIInventoryItem>;
    let values: array<wref<IScriptable>>;
    let wrappedItem: ref<RevisedItemWrapper>;
    let wrappedItems: array<ref<IScriptable>>;
    let dropItem: ItemModParams;

    // ArrayPush(tagsToFilterOut, n"HideInBackpackUI");
    // ArrayPush(tagsToFilterOut, n"SoftwareShard");
    ArrayPush(tagsToFilterOut, n"Recipe");
    ArrayPush(tagsToFilterOut, n"CraftingPart");
    this.m_uiInventorySystem.FlushTempData();
    playerItems = this.m_uiInventorySystem.GetPlayerItemsMap();
    playerItems.GetValues(values);
    ArrayClear(this.m_junkItems);
    ArrayClear(this.m_customJunkItems);
    i = 0;
    limit = ArraySize(values);
    while i < limit {
      let shouldSkipItem: Bool = false;
      uiInventoryItem = values[i] as UIInventoryItem;

      if ItemID.HasFlag(uiInventoryItem.GetID(), gameEItemIDFlag.Preview) || uiInventoryItem.HasAnyTag(tagsToFilterOut)  {
        shouldSkipItem = true;
      };

      if ArrayContains(this.m_itemDropQueueItems, uiInventoryItem.ID) {
        quantity = uiInventoryItem.GetQuantity(true);
        dropItem = this.GetDropQueueItem(uiInventoryItem.ID);
        if dropItem.quantity >= quantity {
          shouldSkipItem = true;
        } else {
          uiInventoryItem.SetQuantity(quantity - dropItem.quantity);
        };
      };

      if uiInventoryItem.IsJunk() {
        ArrayPush(this.m_junkItems, uiInventoryItem);
      };

      if !shouldSkipItem {
        wrappedItem = this.BuildWrappedItem(uiInventoryItem);
        ArrayPush(wrappedItems, wrappedItem);
      };

      if wrappedItem.GetCustomJunkFlag() {
        ArrayPush(this.m_customJunkItems, wrappedItem);
      };

      i += 1;
    };

    this.itemsListDataSource.Reset(wrappedItems);
    this.itemsListDataView.UpdateView();
    this.Log(s"PopulateInventory \(ArraySize(wrappedItems))");

    if !this.m_customJunkInvalidated {
      this.m_customJunkInvalidated = true;
      this.m_system.InvalidateCustomJunk(wrappedItems);
    };
  }

  private final func RequestItemInspected(itemID: ItemID) -> Void {
    let request: ref<UIScriptableSystemInventoryInspectItem> = new UIScriptableSystemInventoryInspectItem();
    request.itemID = itemID;
    this.m_uiScriptableSystem.QueueRequest(request);
  }

  private final func GetBackpackItemQuantity(inventoryItem: wref<UIInventoryItem>) -> Int32 {
    let dropItem: ItemModParams;
    let result: Int32 = inventoryItem.GetQuantity(true);
    if ArrayContains(this.m_itemDropQueueItems, inventoryItem.GetID()) {
      dropItem = this.GetDropQueueItem(inventoryItem.GetID());
      if dropItem.quantity >= result {
        return 0;
      };
      result -= dropItem.quantity;
    };
    return result;
  }

  protected cb func OnRevisedFiltersActionEvent(evt: ref<RevisedFiltersActionEvent>) -> Bool {
    this.Log(s"Run mass action \(evt.type)");

    switch evt.type {
      case revisedFiltersAction.Select:
        this.SelectFilteredItems();
        break;
      case revisedFiltersAction.Junk:
        this.JunkCurrentSelection();
        break;
      case revisedFiltersAction.Disassemble:
        this.DisassembleCurrentSelection();
        break;
    }
  }

  private final func SelectFilteredItems() -> Void {
    ArrayClear(this.m_selectedItems);

    for item in this.GetDataViewItems() {
      item.SetSelectedFlag(true);
      ArrayPush(this.m_selectedItems, item);
    };

    this.HideItemPreview();
    this.RefreshVisibleDataViewItems();
    this.UpdateSelectedItemsCounter();
  }

  private final func JunkCurrentSelection() -> Void {
    if Equals(ArraySize(this.m_selectedItems), 0) {
      return;
    };

    this.m_massActionPopupToken = RevisedBackpackConfirmationPopup.Show(this, GetLocalizedTextByKey(n"Mod-Revised-Filter-Junk-Confirm"), GenericMessageNotificationType.YesNo);
    this.m_massActionPopupToken.RegisterListener(this, n"OnJunkConfirmationClosed");
  }

  protected cb func OnJunkConfirmationClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Yes)  {
      this.ConfirmSelectionCustomJunk();
    };
    this.m_massActionPopupToken = null;
  }

  private final func ConfirmSelectionCustomJunk() -> Void {
    let wasAddedToJunk: Bool;
    for selectedItem in this.m_selectedItems {
      if selectedItem.customJunkToggleable {
        wasAddedToJunk = this.m_system.AddToJunk(selectedItem.data.GetID());
        selectedItem.SetCustomJunkFlag(wasAddedToJunk);
      };
    };

    this.PlaySound(n"ui_menu_item_disassemble");
    this.DeselectEverything();
    this.RefreshVisibleDataViewItems();
    this.UpdateSelectedItemsCounter();
    this.RefreshUINextFrame();
  }

  private final func DisassembleCurrentSelection() -> Void {
    if Equals(ArraySize(this.m_selectedItems), 0) {
      return;
    };

    this.m_massActionPopupToken = RevisedBackpackConfirmationPopup.Show(this, GetLocalizedTextByKey(n"Mod-Revised-Filter-Disassemble-Confirm"), GenericMessageNotificationType.YesNo);
    this.m_massActionPopupToken.RegisterListener(this, n"OnDisassembleConfirmationClosed");
  }

  protected cb func OnDisassembleConfirmationClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Yes)  {
      this.ConfirmSelectionDisassemble();
    };
    this.m_massActionPopupToken = null;
  }

  private final func ConfirmSelectionDisassemble() -> Void {
    let item: ref<UIInventoryItem>;
    for selectedItem in this.m_selectedItems {
      item = selectedItem.inventoryItem;
      if RevisedBackpackUtils.CanDisassemble(this.m_player.GetGame(), item) {
        ItemActionsHelper.DisassembleItem(this.m_player, item.GetID(), item.GetQuantity());
      };
    };

    this.PlaySound(n"ui_menu_item_disassemble");
    this.DeselectEverything();
    this.RefreshVisibleDataViewItems();
    this.UpdateSelectedItemsCounter();
    this.RefreshUINextFrame();
  }

  protected cb func OnRevisedFilteringEvent(evt: ref<RevisedFilteringEvent>) -> Bool {
    this.itemsListDataView.SetFilters(evt);
  }

  protected cb func OnRevisedCategorySelectedEvent(evt: ref<RevisedCategorySelectedEvent>) -> Bool {
    let selectedIndex: Int32 = -1;
    let i: Int32 = 0;
    let count: Int32 = ArraySize(this.m_availableCategories);
    let category: ref<RevisedBackpackCategory>;
    let shouldBreak: Bool = false;
    while i < count && !shouldBreak {
      category = this.m_availableCategories[i];
      if Equals(category.id, evt.category.id) {
        shouldBreak = true;
        selectedIndex = i;
      };
      i += 1;
    };
    
    this.DeselectEverything();
    this.RefreshVisibleDataViewItems();
    this.UpdateSelectedItemsCounter();

    let category: ref<RevisedBackpackCategory>;
    if NotEquals(selectedIndex, -1) {
      this.AnimateIndicatorTranslation(selectedIndex);
      category = this.m_availableCategories[selectedIndex];
      inkTextRef.SetText(this.m_categoryName, GetLocalizedTextByKey(category.titleLocKey));
      this.itemsListDataView.SetCategory(category);
      this.itemsListDataView.RefreshList();
      this.m_TooltipsManager.HideTooltips();
      inkWidgetRef.SetVisible(this.m_previewGarmentContainer, false);
      inkWidgetRef.SetVisible(this.m_previewItemContainer, false);
    };
  }

  protected cb func OnRevisedBackpackSortingChanged(evt: ref<RevisedBackpackSortingChanged>) -> Bool {
    this.Log(s"Request sorting: \(evt.sorting) + \(evt.mode)");
    this.itemsListDataView.SetSortMode(evt.sorting, evt.mode);
    this.m_TooltipsManager.HideTooltips();
  }

  protected cb func OnRevisedBackpackColumnHoverOverEvent(evt: ref<RevisedBackpackColumnHoverOverEvent>) -> Bool {
    let label: String = "";
    switch evt.type {
      case revisedSorting.Name:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Name");
        break;
      case revisedSorting.Type:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Type");
        break;
      case revisedSorting.Tier:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Tier");
        break;
      case revisedSorting.Price:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Price");
        break;
      case revisedSorting.Weight:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Weight");
        break;
      case revisedSorting.Dps:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Dps");
        break;
      case revisedSorting.DamagePerShot:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Per-Shot-Damage");
        break;
      case revisedSorting.Range:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Range");
        break;
      case revisedSorting.Quest:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Quest");
        break;
      case revisedSorting.CustomJunk:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Junk");
        break;
    };

    if NotEquals(label, "") {
      this.ShowColumnNameTooltip(evt.target, label);
    }
  }

  protected cb func OnRevisedBackpackColumnHoverOutEvent(evt: ref<RevisedBackpackColumnHoverOutEvent>) -> Bool {
    this.m_TooltipsManager.HideTooltips();
  }

  protected cb func OnRevisedBackpackItemHoverOverEvent(evt: ref<RevisedBackpackItemHoverOverEvent>) -> Bool {
    let itemID: ItemID = evt.item.data.GetID();
    if ItemID.IsValid(itemID) {
      this.RequestItemInspected(itemID);
    };

    this.ShowButtonHints(evt.item);
    this.m_lastItemHoverOverEvent = evt;
    this.m_pressedItemDisplay = null;
    this.PlaySound(n"ui_menu_hover");
    if evt.isOverName {
      this.OnInventoryRequestTooltip(evt.item.inventoryItem, evt.widget);
    };
  }

  protected cb func OnRevisedBackpackItemHoverOutEvent(evt: ref<RevisedBackpackItemHoverOutEvent>) -> Bool {
    this.m_lastItemHoverOverEvent = null;
    this.m_pressedItemDisplay = null;
    this.HiteButtonHints();
    this.m_TooltipsManager.HideTooltips();
  }

  protected cb func OnRevisedBackpackItemSelectEvent(evt: ref<RevisedBackpackItemSelectEvent>) -> Bool {
    this.Log(s"Selected \(TDBID.ToStringDEBUG(evt.item.id)), ctrl: \(evt.ctrlPressed), shift: \(evt.shiftPressed)");
    this.m_prevSelectedController = this.m_currSelectedController;
    this.m_currSelectedController = evt.display;
    this.PlaySound(n"ui_menu_onpress");
    this.m_TooltipsManager.HideTooltips();

    if !evt.ctrlPressed && !evt.shiftPressed {
      // single click
        // has more than one item selected already
        if ArraySize(this.m_selectedItems) > 1 {
          this.DeselectEverything();
          this.RefreshVisibleDataViewItems();
        };
        if !evt.item.GetSelectedFlag() {
          // clicked item is not selected yet
          this.Log(s"[] was not selected - \(this.m_prevSelectedController.GetNameLabel()) deselected, \(this.m_currSelectedController.GetNameLabel()) selected");
          this.SelectSingleItem(evt.item);
        } else if evt.item.GetSelectedFlag() {
          // clicked item already selected
          this.Log(s"[] was selected - \(this.m_currSelectedController.GetNameLabel()) deselected");
          this.DeselectSingleItem(evt.item);
        };
    } else if evt.ctrlPressed && !evt.shiftPressed {
      // ctrl + click
        if !evt.item.GetSelectedFlag() {
          // clicked item is not selected yet
          this.Log(s"[ctrl] was not selected - \(this.m_prevSelectedController.GetNameLabel()) deselected, \(this.m_currSelectedController.GetNameLabel()) selected");
          this.SelectSingleItemCtrl(evt.item);
        } else if evt.item.GetSelectedFlag() {
          // clicked item already selected
          this.Log(s"[ctrl] was selected - \(this.m_currSelectedController.GetNameLabel()) deselected");
          this.DeselectSingleItemCtrl(evt.item);
        };
    } else if !evt.ctrlPressed && evt.shiftPressed {
      // shift + click
      this.Log(s"[shift] select from \(this.m_prevSelectedController.GetNameLabel()) to \(this.m_currSelectedController.GetNameLabel())");
      this.SelectItemsFromTo(evt.item);
    };

    this.UpdateSelectedItemsCounter();
  }

  private final func DeselectEverything() -> Void {
    for item in this.GetDataSourceItems() {
      item.SetSelectedFlag(false);
    };
    ArrayClear(this.m_selectedItems);
  }

  private final func RefreshVisibleDataViewItems() -> Void {
    for controller in this.GetListControllers() {
      controller.RefreshView();
    };
  }

  private final func SelectSingleItem(item: ref<RevisedItemWrapper>) -> Void {
    if IsDefined(this.m_prevSelectedController) { ArrayRemove(this.m_selectedItems, this.m_prevSelectedController.GetItem()); }
    if IsDefined(this.m_prevSelectedController) { this.m_prevSelectedController.SetSelected(false); };
    if IsDefined(this.m_currSelectedController) { this.m_currSelectedController.SetSelected(true); };
    this.m_fromToStartingController = this.m_currSelectedController;
    this.ShowItemPreview(item); 
    ArrayPush(this.m_selectedItems, item);
  }

  private final func SelectSingleItemCtrl(item: ref<RevisedItemWrapper>) -> Void {
    if IsDefined(this.m_currSelectedController) { this.m_currSelectedController.SetSelected(true); };
    this.m_fromToStartingController = this.m_currSelectedController;
    this.HideItemPreview();
    ArrayPush(this.m_selectedItems, item);
  }

  private final func DeselectSingleItem(item: ref<RevisedItemWrapper>) -> Void {
    if IsDefined(this.m_prevSelectedController) { this.m_prevSelectedController.SetSelected(false); };
    if IsDefined(this.m_currSelectedController) { this.m_currSelectedController.SetSelected(false); };
    this.m_fromToStartingController = this.m_prevSelectedController;
    this.m_prevSelectedController = null;
    this.m_currSelectedController = null;
    this.HideItemPreview();
    ArrayRemove(this.m_selectedItems, item);
  }

  private final func DeselectSingleItemCtrl(item: ref<RevisedItemWrapper>) -> Void {
    if IsDefined(this.m_currSelectedController) { this.m_currSelectedController.SetSelected(false); };
    this.m_fromToStartingController = this.m_prevSelectedController;
    this.m_currSelectedController = null;
    this.HideItemPreview();
    ArrayRemove(this.m_selectedItems, item);
  }

  private final func SelectItemsFromTo(item: ref<RevisedItemWrapper>) -> Void {
    if !IsDefined(this.m_fromToStartingController) || !IsDefined(this.m_currSelectedController) {
      return ;
    };

    this.HideItemPreview();

    let start: Int32 = this.TryToFindItemIndex(this.m_fromToStartingController.GetItem());
    let end: Int32 = this.TryToFindItemIndex(this.m_currSelectedController.GetItem());
    let items: array<ref<RevisedItemWrapper>> = this.GetDataViewItems();
    this.Log(s"Select items from to: \(start) -> \(end)");

    if start < 0 { start = 0; };
    if end < 0 || start > ArraySize(items) - 1 || end > ArraySize(items) - 1 {
      return ;
    };

    let startIndex: Int32;
    let endIndex: Int32;
    if start <= end {
      startIndex = start;
      endIndex = end;
    } else {
      startIndex = end;
      endIndex = start;
    };

    let wrapper: ref<RevisedItemWrapper>;
    while startIndex <= endIndex {
      wrapper = items[startIndex];
      wrapper.SetSelectedFlag(true);
      if !ArrayContains(this.m_selectedItems, wrapper) {
        ArrayPush(this.m_selectedItems, wrapper);
      };
      startIndex += 1;
    };

    this.RefreshVisibleDataViewItems();
  }

  protected cb func OnRevisedItemDisplayReleaseEvent(evt: ref<RevisedItemDisplayReleaseEvent>) -> Bool {
    let isUsable: Bool;
    let isHealing: Bool;
    let item: ItemModParams;
    if evt.actionName.IsAction(n"drop_item") {
      if Equals(this.playerState, gamePSMVehicle.Default) && RPGManager.CanItemBeDropped(this.m_player, evt.uiInventoryItem.GetItemData()) && InventoryGPRestrictionHelper.CanDrop(evt.uiInventoryItem, this.m_player) {
        if evt.display.GetIsPlayerFavourite() {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
          return false;
        };
        if this.GetBackpackItemQuantity(evt.uiInventoryItem) > 1 {
          this.OpenQuantityPicker(evt.uiInventoryItem, QuantityPickerActionType.Drop);
        } else {
          this.PlaySound(n"ui_menu_item_droped");
          this.PlayRumble(RumbleStrength.Light, RumbleType.Pulse, RumblePosition.Right);
          item.itemID = evt.uiInventoryItem.ID;
          item.quantity = 1;
          this.AddToDropQueue(item);
          this.RefreshUINextFrame();
        };
      } else {
        this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
      };
    } else {
      if evt.actionName.IsAction(n"revised_use_equip") {
        isUsable = IsDefined(ItemActionsHelper.GetConsumeAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetEatAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetDrinkAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetLearnAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetDownloadFunds(evt.uiInventoryItem.GetID()));
        isHealing = Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_Inhaler) || Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_Injector);
        if isUsable && !isHealing {
          if !InventoryGPRestrictionHelper.CanUse(evt.uiInventoryItem, this.m_player) {
            this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
            return false;
          };
          GameInstance.GetAudioSystem(this.m_player.GetGame()).Play(n"ui_loot_eat_ui");
          this.PlayRumble(RumbleStrength.Light, RumbleType.Pulse, RumblePosition.Right);
          if Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_Skillbook) {
            this.SetWarningMessage(GetLocalizedText("LocKey#46534") + "\\n" + GetLocalizedText(evt.uiInventoryItem.GetDescription()));
          };
          ItemActionsHelper.PerformItemAction(this.m_player, evt.uiInventoryItem.GetID());
          this.m_inventoryManager.MarkToRebuild();
        };
        if Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_LongLasting) {
          return false;
        };
        if Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Clo_Outfit) {
          if this.m_outfitInCooldown {
            return false;
          };
          if this.ScheduleOutfitCooldownReset() {
            this.SetOutfitCooldown(true);
          };
        };

        if evt.uiInventoryItem.IsEquipped() {
          this.UnequipItem(evt.uiInventoryItem);
        } else {
          this.EquipItem(evt.uiInventoryItem);
        };
      };
    };
  }

  protected cb func OnRevisedItemDisplayPressEvent(evt: ref<RevisedItemDisplayPressEvent>) -> Bool {
    this.m_pressedItemDisplay = evt.display;
  }

  protected cb func OnRevisedItemDisplayHoldEvent(evt: ref<RevisedItemDisplayHoldEvent>) -> Bool {
    let setPlayerFavouriteRequest: ref<UIScriptableSystemSetItemPlayerFavourite>;
    if evt.actionName.IsAction(n"disassemble_item") {
      if RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), evt.uiInventoryItem.GetItemData()) {
        if evt.display.GetIsPlayerFavourite() {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
          return false;
        };

        if this.GetBackpackItemQuantity(evt.uiInventoryItem) > 1 {
          this.OpenQuantityPicker(evt.uiInventoryItem, QuantityPickerActionType.Disassembly);
        } else {
          if evt.uiInventoryItem.IsIconic() && !evt.uiInventoryItem.IsEquipped() {
            this.OpenConfirmationPopup(evt.uiInventoryItem);
          } else {
            ItemActionsHelper.DisassembleItem(this.m_player, evt.uiInventoryItem.GetID());
            this.PlaySound(n"ui_menu_item_disassemble");
            this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
            this.m_TooltipsManager.HideTooltips();
          };
        };
      };
    } else {
      if evt.actionName.IsAction(n"favourite_item") && evt.uiInventoryItem.IsWeapon() && this.m_pressedItemDisplay != null {
        setPlayerFavouriteRequest = new UIScriptableSystemSetItemPlayerFavourite();
        setPlayerFavouriteRequest.itemID = evt.uiInventoryItem.ID;
        setPlayerFavouriteRequest.favourite = !evt.display.GetIsPlayerFavourite();
        this.m_uiScriptableSystem.QueueRequest(setPlayerFavouriteRequest);
        evt.display.SetIsPlayerFavourite(setPlayerFavouriteRequest.favourite);
        this.UpdateFavouriteHint(setPlayerFavouriteRequest.favourite);
        this.m_pressedItemDisplay = null;
        this.PlaySound(n"ui_menu_map_pin_on");
        this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
      };
    };
  }

  protected cb func OnRevisedToggleCustomJunkEvent(evt: ref<RevisedToggleCustomJunkEvent>) -> Bool {
    this.Log("RevisedToggleCustomJunkEvent");
    let data: ref<gameItemData> = evt.itemData;
    let itemId: ItemID = data.GetID();
    let newFlag: Bool = !evt.display.GetIsCustomJunkItem();
    let success: Bool;
    if this.m_system.IsAddedToJunk(itemId) {
      success = this.m_system.RemoveFromJunk(itemId);
    } else {
      success = this.m_system.AddToJunk(itemId);
    };

    if success {
      evt.display.SetIsCustomJunkItem(newFlag);
      this.PlaySound(n"ui_menu_onpress");
    };
  }

  protected cb func OnRevisedToggleQuestTagEvent(evt: ref<RevisedToggleQuestTagEvent>) -> Bool {
    this.Log("OnRevisedToggleQuestTagEvent");
    let data: ref<gameItemData> = evt.itemData;
    let newFlag: Bool = !evt.display.GetIsQuestItem();
    let success: Bool;
    if data.HasTag(n"Quest") {
      success = data.RemoveDynamicTag(n"Quest");
    } else {
      success = data.SetDynamicTag(n"Quest");
    };

    if success {
      evt.display.SetIsQuestItem(newFlag);
      this.PlaySound(n"ui_menu_onpress");
    };
  }

  private final func ShowItemPreview(item: ref<RevisedItemWrapper>) -> Void {
    let isGarment: Bool = item.inventoryItem.IsClothing();
    inkWidgetRef.SetVisible(this.m_previewGarmentContainer, isGarment);
    inkWidgetRef.SetVisible(this.m_previewItemContainer, !isGarment);
    this.QueueEvent(RevisedItemPreviewEvent.Create(item.data.GetID(), isGarment));
  }

  private final func HideItemPreview() -> Void {
    inkWidgetRef.SetVisible(this.m_previewGarmentContainer, false);
    inkWidgetRef.SetVisible(this.m_previewItemContainer, false);
  }

  private final func InvalidateItemTooltipEvent() -> Void {
    if this.m_lastItemHoverOverEvent != null {
      this.OnRevisedBackpackItemHoverOverEvent(this.m_lastItemHoverOverEvent);
    };
  }

  private final func DetermineUIMenuNotificationType() -> UIMenuNotificationType {
    let inCombat: Bool = false;
    let psmBlackboard: ref<IBlackboard> = this.m_player.GetPlayerStateMachineBlackboard();
    inCombat = psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == 1;
    if inCombat {
      return UIMenuNotificationType.InCombat;
    };
    return UIMenuNotificationType.InventoryActionBlocked;
  }

  private final func OpenConfirmationPopup(inventoryItem: wref<UIInventoryItem>) -> Void {
    let data: ref<VendorConfirmationPopupData> = new VendorConfirmationPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\vendor_confirmation.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.inventoryItem = inventoryItem;
    data.quantity = inventoryItem.GetQuantity();
    data.type = VendorConfirmationPopupType.DisassembeIconic;
    this.m_confirmationPopupToken = this.ShowGameNotification(data);
    this.m_confirmationPopupToken.RegisterListener(this, n"OnConfirmationPopupClosed");
    this.m_buttonHintsController.Hide();
  }

  protected cb func OnConfirmationPopupClosed(data: ref<inkGameNotificationData>) -> Bool {
    let itemID: ItemID;
    this.m_confirmationPopupToken = null;
    let resultData: ref<VendorConfirmationPopupCloseData> = data as VendorConfirmationPopupCloseData;
    if resultData.confirm {
      if IsDefined(resultData.inventoryItem) {
        itemID = resultData.inventoryItem.GetID();
      } else {
        itemID = InventoryItemData.GetID(resultData.itemData);
      };
      ItemActionsHelper.DisassembleItem(this.m_player, itemID);
      this.PlaySound(n"ui_menu_item_disassemble");
    };
    this.m_buttonHintsController.Show();
  }

  private final func OpenQuantityPicker(itemData: wref<UIInventoryItem>, actionType: QuantityPickerActionType) -> Void {
    let dropItem: ItemModParams = this.GetDropQueueItem(itemData.GetID());
    let data: ref<QuantityPickerPopupData> = new QuantityPickerPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\item_quantity_picker.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.maxValue = itemData.GetQuantity(true);
    if ItemID.IsValid(dropItem.itemID) {
      data.maxValue -= dropItem.quantity;
    };
    data.inventoryItem = itemData;
    data.actionType = actionType;
    this.m_quantityPickerPopupToken = this.ShowGameNotification(data);
    this.m_quantityPickerPopupToken.RegisterListener(this, n"OnQuantityPickerPopupClosed");
    this.m_buttonHintsController.Hide();
  }

  protected cb func OnQuantityPickerPopupClosed(data: ref<inkGameNotificationData>) -> Bool {
    this.m_quantityPickerPopupToken = null;
    let quantityData: ref<QuantityPickerPopupCloseData> = data as QuantityPickerPopupCloseData;
    if quantityData.choosenQuantity != -1 {
      switch quantityData.actionType {
        case QuantityPickerActionType.Drop:
          this.OnQuantityPickerDrop(quantityData);
          break;
        case QuantityPickerActionType.Disassembly:
          this.OnQuantityPickerDisassembly(quantityData);
      };
    };
    this.m_buttonHintsController.Show();
  }

  public final func OnQuantityPickerDrop(data: ref<QuantityPickerPopupCloseData>) -> Void {
    let item: ItemModParams;
    this.PlaySound(n"ui_menu_item_droped");
    this.PlayRumble(RumbleStrength.Light, RumbleType.Pulse, RumblePosition.Right);
    if IsDefined(data.inventoryItem) {
      item.itemID = data.inventoryItem.GetID();
    } else {
      item.itemID = InventoryItemData.GetID(data.itemData);
    };
    item.quantity = data.choosenQuantity;
    this.AddToDropQueue(item);
    this.RefreshUINextFrame();
  }

  public final func OnQuantityPickerDisassembly(data: ref<QuantityPickerPopupCloseData>) -> Void {
    let itemID: ItemID = IsDefined(data.inventoryItem) ? data.inventoryItem.GetID() : InventoryItemData.GetID(data.itemData);
    ItemActionsHelper.DisassembleItem(this.m_player, itemID, data.choosenQuantity);
    this.PlaySound(n"ui_menu_item_disassemble");
    this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
    this.m_TooltipsManager.HideTooltips();
  }

  public final func IsEquippable(itemData: ref<gameItemData>) -> Bool {
    return EquipmentSystem.GetInstance(this.m_player).GetPlayerData(this.m_player).IsEquippable(itemData);
  }

  private final func ScheduleOutfitCooldownReset() -> Bool {
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.m_player.GetGame());
    let callback: ref<RevisedBackpackOutfitCooldownResetCallback> = new RevisedBackpackOutfitCooldownResetCallback();
    callback.m_controller = this;
    if IsDefined(delaySystem) && !this.m_outfitInCooldown {
      delaySystem.CancelCallback(this.m_delayedOutfitCooldownResetCallbackId);
      this.m_delayedOutfitCooldownResetCallbackId = delaySystem.DelayCallback(callback, this.m_outfitCooldownPeroid, false);
      return GetInvalidDelayID() != this.m_delayedOutfitCooldownResetCallbackId;
    };
    return false;
  }

  public final func SetOutfitCooldown(inCooldown: Bool) -> Void {
    this.m_outfitInCooldown = inCooldown;
  }

  public final func EquipItem(itemData: wref<UIInventoryItem>) -> Void {
    let data: ref<gameItemData> = itemData.GetItemData();
    if this.IsEquippable(data) && !data.HasTag(n"Cyberware") {
      if !InventoryGPRestrictionHelper.CanUse(itemData, this.m_player) {
        this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
        return;
      };
      if Equals(itemData.GetEquipmentArea(), gamedataEquipmentArea.Weapon) {
        this.OpenBackpackEquipSlotChooser(itemData);
        return;
      };
      this.m_equipRequested = true;
      this.m_inventoryManager.EquipItem(itemData.ID, 0);
    };
    this.RefreshUINextFrame();
  }


  public final func UnequipItem(itemData: wref<UIInventoryItem>) -> Void {
    let data: ref<gameItemData> = itemData.GetItemData();
    let unequipBlocked: Bool = data.HasTag(n"UnequipBlocked");
    if unequipBlocked || data.HasTag(n"Cyberware") {
      return ;
    };

    let area: gamedataEquipmentArea = itemData.GetEquipmentArea();
    let slotIndex: Int32 = this.m_inventoryManager.GetItemSlotIndexRev(this.m_player, data.GetID());
    this.m_inventoryManager.UnequipItem(area, slotIndex);
    this.RefreshUINextFrame();
  }

  private final func ShowNotification(gameInstance: GameInstance, type: UIMenuNotificationType) -> Void {
    let inventoryNotification: ref<UIMenuNotificationEvent> = new UIMenuNotificationEvent();
    inventoryNotification.m_notificationType = type;
    GameInstance.GetUISystem(gameInstance).QueueEvent(inventoryNotification);
  }

  public final func OpenBackpackEquipSlotChooser(itemData: wref<UIInventoryItem>) -> Void {
    let data: ref<BackpackEquipSlotChooserData> = new BackpackEquipSlotChooserData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\backpack_equip_notification.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.item = itemData;
    data.inventoryScriptableSystem = this.m_uiInventorySystem;
    this.m_equipSlotChooserPopupToken = this.ShowGameNotification(data);
    this.m_equipSlotChooserPopupToken.RegisterListener(this, n"OnBackpacEquipSlotChooserClosed");
    this.m_buttonHintsController.Hide();
  }

  protected cb func OnBackpacEquipSlotChooserClosed(data: ref<inkGameNotificationData>) -> Bool {
    let i: Int32;
    this.m_equipSlotChooserPopupToken = null;
    let slotChooserData: ref<BackpackEquipSlotChooserCloseData> = data as BackpackEquipSlotChooserCloseData;
    if slotChooserData.confirm {
      this.m_equipRequested = true;
      if Equals(slotChooserData.itemData.GetEquipmentArea(), gamedataEquipmentArea.Weapon) {
        i = 0;
        while i < 3 {
          if slotChooserData.itemData.ID == this.m_inventoryManager.GetEquippedItemIdInArea(gamedataEquipmentArea.Weapon, i) {
            this.m_inventoryManager.UnequipItem(gamedataEquipmentArea.Weapon, i, true);
          };
          i += 1;
        };
      };
      this.m_inventoryManager.EquipItem(slotChooserData.itemData.ID, slotChooserData.slotIndex);
      this.PlaySound(n"ui_menu_onpress");
    };
    this.m_buttonHintsController.Show();
  }

  private final func OnInventoryRequestTooltip(itemData: wref<UIInventoryItem>, widget: wref<inkWidget>) -> Void {
    let placement: gameuiETooltipPlacement = gameuiETooltipPlacement.RightTop;
    let margin: inkMargin = new inkMargin(0.0, 0.0, 0.0, 0.0);
    let itemToCompare: wref<UIInventoryItem>;
    let itemTooltipData: ref<UIInventoryItemTooltipWrapper>;
    let itemTooltips: [CName; 2];
    let tooltipsData: array<ref<ATooltipData>>;
    if itemData.IsWeapon() {
      itemTooltips[0] = n"newItemTooltip";
      itemTooltips[1] = n"newItemTooltipComparision";
    } else {
      itemTooltips[0] = n"itemTooltip";
      itemTooltips[1] = n"itemTooltipComparision";
    };
    if IsDefined(itemData) {
      if Equals(itemData.GetItemType(), gamedataItemType.Prt_Program) {
        itemTooltipData = UIInventoryItemTooltipWrapper.Make(itemData, this.m_itemDisplayContext);
        this.m_TooltipsManager.ShowTooltipAtWidget(n"programTooltip", widget, itemTooltipData, placement, true, margin);
        return;
      };
      if !itemData.IsEquipped() && !this.m_isComparisonDisabled {
        itemToCompare = this.m_comparisonResolver.GetPreferredComparisonItem(itemData);
      };
      if !this.m_isComparisonDisabled && itemToCompare != null {
        this.m_inventoryManager.PushIdentifiedComparisonTooltipsData(tooltipsData, itemTooltips[0], itemTooltips[1], itemData, itemToCompare, this.m_itemDisplayContext, this.m_comparedItemDisplayContext);
        this.m_TooltipsManager.ShowTooltipsAtWidget(tooltipsData, widget);
      } else {
        itemData.GetStatsManager().FlushComparedBars();
        itemTooltipData = UIInventoryItemTooltipWrapper.Make(itemData, this.m_itemDisplayContext);
        this.m_TooltipsManager.ShowTooltipAtWidget(itemTooltips[0], widget, itemTooltipData, placement, true, margin);
      };
    };
  }

  private final func SetWarningMessage(const message: script_ref<String>) -> Void {
    let warningMsg: SimpleScreenMessage;
    warningMsg.isShown = true;
    warningMsg.duration = 5.0;
    warningMsg.message = Deref(message);
    GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(warningMsg), true);
  }

  private final func ShowButtonHints(item: ref<RevisedItemWrapper>) -> Void {
    let data: ref<gameItemData> = item.data;
    let unequipBlocked: Bool = data.HasTag(n"UnequipBlocked");
    let itemID: ItemID = data.GetID();
    let isLearnble: Bool = IsDefined(ItemActionsHelper.GetLearnAction(itemID));
    let isUsable: Bool = IsDefined(ItemActionsHelper.GetConsumeAction(itemID)) || IsDefined(ItemActionsHelper.GetEatAction(itemID)) || IsDefined(ItemActionsHelper.GetDrinkAction(itemID));
    let isGrenade: Bool = Equals(item.type, gamedataItemType.Gad_Grenade);
    let isHealing: Bool = Equals(item.type, gamedataItemType.Con_Inhaler) || Equals(item.type, gamedataItemType.Con_Injector);
    let isEquipable: Bool = RevisedBackpackUtils.IsEquippable(item, this.m_player);
    this.m_cursorData = new MenuCursorUserData();
    this.m_cursorData.SetAnimationOverride(n"hoverOnHoldToComplete");
    
    // Select
    this.m_buttonHintsController.AddButtonHint(n"select", GetLocalizedText("UI-UserActions-ItemPreview"));

    // use - equip - consume - learn
    if isUsable {
      this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Use"));
    } else {
      if isLearnble {
        this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("Gameplay-Devices-Interactions-Learn"));
      } else {
        if RPGManager.HasDownloadFundsAction(itemID) && RPGManager.CanDownloadFunds(this.m_player.GetGame(), itemID) {
          this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("LocKey#23401"));
        } else {
          if isEquipable || isGrenade {
            if item.inventoryItem.IsEquipped() && !item.inventoryItem.IsQuestItem() {
              if !unequipBlocked && !isGrenade && !isHealing {
                this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Unequip"));
              };
            } else {
              this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Equip"));
            };
          } else {
            this.m_buttonHintsController.RemoveButtonHint(n"revised_use_equip");
          };
        };
      };
    };
    if Equals(item.type, gamedataItemType.Con_Inhaler) || Equals(item.type, gamedataItemType.Con_Injector) {
      this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Equip"));
    };

    // Disassemble
    if RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), data.GetID()) && !item.inventoryItem.IsEquipped() && !data.HasTag(n"UnequipBlocked") {
      this.m_buttonHintsController.AddButtonHint(n"disassemble_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("Gameplay-Devices-DisplayNames-DisassemblableItem"));
      this.m_cursorData.AddAction(n"disassemble_item");
    } else {
      this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
    };

    // Drop
    if !item.inventoryItem.IsEquipped() && RPGManager.CanItemBeDropped(this.m_player, data) && IsDefined(ItemActionsHelper.GetDropAction(data.GetID())) && !data.HasTag(n"UnequipBlocked") && !data.HasTag(n"Quest") {
      if Equals(this.playerState, gamePSMVehicle.Default) {
        this.m_buttonHintsController.AddButtonHint(n"drop_item", GetLocalizedText("UI-ScriptExports-Drop0"));
      } else {
        this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
      };
    };

    // Favorite
    if item.inventoryItem.IsWeapon() {
      this.UpdateFavouriteHint(this.m_uiScriptableSystem.IsItemPlayerFavourite(data.GetID()));
    };

    if this.m_cursorData.GetActionsListSize() >= 0 {
      this.SetCursorContext(n"Hover", this.m_cursorData);
    } else {
      this.SetCursorContext(n"Hover");
    };
  }

  private final func UpdateFavouriteHint(state: Bool) -> Void {
    if state {
      this.m_buttonHintsController.AddButtonHint(n"favourite_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("UI-UserActions-ItemRemoveFavourite"));
      this.m_cursorData.AddUniqueAction(n"favourite_item");
    } else {
      this.m_buttonHintsController.AddButtonHint(n"favourite_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("UI-UserActions-ItemAddFavourite"));
      this.m_cursorData.AddUniqueAction(n"favourite_item");
    };
    if this.m_cursorData.GetActionsListSize() >= 0 {
      this.SetCursorContext(n"Hover", this.m_cursorData);
    } else {
      this.SetCursorContext(n"Hover");
    };
  }

  private final func HiteButtonHints() -> Void {
    this.m_buttonHintsController.RemoveButtonHint(n"select");
    this.m_buttonHintsController.RemoveButtonHint(n"revised_use_equip");
    this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
    this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
    this.m_buttonHintsController.RemoveButtonHint(n"favourite_item");
    this.SetCursorContext(n"Default");
  }

  private final func SpawnPreviews() -> Void {
    this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_previewGarmentContainer), 
      r"base\\gameplay\\gui\\fullscreen\\previews\\revised_garment_item_preview.inkwidget", 
      n"Root:RevisedBackpack.RevisedPreviewGarmentController"
    );

    this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_previewItemContainer), 
      r"base\\gameplay\\gui\\fullscreen\\previews\\revised_item_preview.inkwidget", 
      n"Root:RevisedBackpack.RevisedPreviewItemController"
    );
    
    this.Log(s"SpawnPreviews");
  }

  private final func PopulateCategories() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_categoriesContainer) as inkCompoundWidget;
    this.Log(s"Categories container defined: \(IsDefined(container)), categories: \(ArraySize(this.m_availableCategories))");

    for category in this.m_availableCategories {
      let component: ref<RevisedCategoryComponent> = new RevisedCategoryComponent();
      component.Reparent(container);
      component.SetData(category);
    };

    if NotEquals(ArraySize(this.m_availableCategories), 0) {
      this.QueueEvent(RevisedCategorySelectedEvent.Create(this.m_availableCategories[0]));
    };
  }

  private final func BuildWrappedItem(uiInventoryItem: ref<UIInventoryItem>) -> ref<RevisedItemWrapper> {
    let statsManager: ref<UIInventoryItemStatsManager> = uiInventoryItem.GetStatsManager();
    let data: ref<gameItemData> = uiInventoryItem.GetRealItemData();
    let equipArea: gamedataEquipmentArea = uiInventoryItem.GetEquipmentArea();
    let itemRecord: ref<Item_Record> = uiInventoryItem.GetItemRecord();
    let itemType: gamedataItemType = itemRecord.ItemType().Type();
    let itemEvolution: gamedataWeaponEvolution = gamedataWeaponEvolution.Invalid;
    if uiInventoryItem.IsWeapon() {
      itemEvolution = uiInventoryItem.GetWeaponEvolution();
    };

    
    let dps: Float = 0.0;
    let dpsStat: wref<UIInventoryItemStat> = uiInventoryItem.GetPrimaryStat();
    if uiInventoryItem.IsWeapon() && Equals(dpsStat.Type, gamedataStatType.EffectiveDPS) {
      dps = dpsStat.Value;
    };

    let damagePerShotStat: ref<UIInventoryItemStat>;
    let damagePerShot: Float = 0.0;
    if uiInventoryItem.IsWeapon() {
      damagePerShotStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
      damagePerShot = damagePerShotStat.Value;
    };

    let effectiveRangeStat: ref<UIInventoryItemStat>;
    let effectiveRange: Int32 = 0;
    if uiInventoryItem.IsWeapon() {
      effectiveRangeStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveRange);
      effectiveRange = Cast<Int32>(effectiveRangeStat.Value);
    };

    let itemId: ItemID = data.GetID();
    let itemTdbid: TweakDBID = itemRecord.GetID();
    let tier: gamedataQuality = uiInventoryItem.GetQuality();
    let price: Float = uiInventoryItem.GetSellPrice();
    let weight: Float = uiInventoryItem.GetWeight();

    let wrappedItem: ref<RevisedItemWrapper> = new RevisedItemWrapper();
    wrappedItem.id = itemTdbid;
    wrappedItem.data = data;
    wrappedItem.inventoryItem = uiInventoryItem;
    wrappedItem.equipArea = equipArea;
    wrappedItem.type = itemType;
    wrappedItem.typeLabel = this.BuildTypeLabel(data, equipArea, itemTdbid, itemType, itemEvolution);
    wrappedItem.typeValue = ItemCompareBuilder.GetItemTypeOrder(data, equipArea, itemType);
    wrappedItem.tier = tier;
    wrappedItem.tierLabel = this.BuildTierLabel(uiInventoryItem);
    wrappedItem.tierValue = this.BuildTierValue(uiInventoryItem);
    wrappedItem.evolution = itemEvolution;
    wrappedItem.nameLabel = GetLocalizedTextByKey(itemRecord.DisplayName());
    wrappedItem.price = price;
    wrappedItem.priceLabel = IntToString(RoundF(price));
    wrappedItem.weight = weight;
    wrappedItem.weightLabel = FloatToStringPrec(weight, 1);
    wrappedItem.dps = dps;
    wrappedItem.dpsLabel = FloatToStringPrec(dps, 1);
    wrappedItem.damagePerShot = damagePerShot;
    wrappedItem.damagePerShotLabel = FloatToStringPrec(damagePerShot, 1);
    wrappedItem.range = effectiveRange;
    wrappedItem.rangeLabel = IntToString(effectiveRange);
    wrappedItem.isQuest = uiInventoryItem.IsQuestItem() || data.HasTag(n"Quest");
    wrappedItem.isNew = uiInventoryItem.IsNew();
    wrappedItem.isFavorite = uiInventoryItem.IsPlayerFavourite();
    wrappedItem.isDlcAddedItem = data.HasTag(n"DLCAdded") && this.m_uiScriptableSystem.IsDLCAddedActiveItem(itemTdbid);
    wrappedItem.isWeapon = uiInventoryItem.IsWeapon();
    wrappedItem.selected = false;
    wrappedItem.customJunk = this.m_system.IsAddedToJunk(itemId);
    wrappedItem.questTagToggleable = RevisedBackpackUtils.CanToggleQuestTag(data);
    wrappedItem.customJunkToggleable = RevisedBackpackUtils.CanToggleCustomJunk(uiInventoryItem);
    
    return wrappedItem;
  }

  private final func BuildTypeLabel(data: ref<gameItemData>, equipArea: gamedataEquipmentArea, id: TweakDBID, type: gamedataItemType, evolution: gamedataWeaponEvolution) -> String {
    let typeLabel: String = GetLocalizedText(UIItemsHelper.GetItemTypeKey(data, equipArea, id, type, evolution));
    let currentLength: Int32 = StrLen(typeLabel);
    let maxLength: Int32 = 22;

    if currentLength <= maxLength {
      return typeLabel;
    }

    let shortened: String = UTF8StrLeft(typeLabel, maxLength);
    let suffix: String = "(...)";
    return s"\(shortened)\(suffix)";
  }

  private final func BuildTierLabel(inventoryItem: ref<UIInventoryItem>) -> String {
    let quality: gamedataQuality = inventoryItem.GetQuality();
    let qualityText: String;

    switch quality {
      case gamedataQuality.Common:
      case gamedataQuality.CommonPlus:
        qualityText = "1";
        break;
      case gamedataQuality.Uncommon:
      case gamedataQuality.UncommonPlus:
        qualityText = "2";
        break;
      case gamedataQuality.Rare:
      case gamedataQuality.RarePlus:
        qualityText = "3";
        break;
      case gamedataQuality.Epic:
      case gamedataQuality.EpicPlus:
        qualityText = "4";
        break;
      case gamedataQuality.Legendary:
      case gamedataQuality.LegendaryPlus:
      case gamedataQuality.LegendaryPlusPlus:
        qualityText = "5";
        break;
    };

    let plus: Int32 = Cast<Int32>(inventoryItem.GetItemPlus());
    if !inventoryItem.IsProgram() {
      if plus >= 2 {
        qualityText += "++";
      } else {
        if plus >= 1 {
          qualityText += "+";
        };
      };
    };

    return qualityText;
  }

  private final func BuildTierValue(inventoryItem: ref<UIInventoryItem>) -> Int32 {
    let quality: gamedataQuality = inventoryItem.GetQuality();
    let qualityValue: Int32;

    switch quality {
      case gamedataQuality.Common:
      case gamedataQuality.CommonPlus:
        qualityValue = 10;
        break;
      case gamedataQuality.Uncommon:
      case gamedataQuality.UncommonPlus:
        qualityValue = 20;
        break;
      case gamedataQuality.Rare:
      case gamedataQuality.RarePlus:
        qualityValue = 30;
        break;
      case gamedataQuality.Epic:
      case gamedataQuality.EpicPlus:
        qualityValue = 40;
        break;
      case gamedataQuality.Legendary:
      case gamedataQuality.LegendaryPlus:
      case gamedataQuality.LegendaryPlusPlus:
        qualityValue = 50;
        break;
    };

    let plus: Int32 = Cast<Int32>(inventoryItem.GetItemPlus());
    if !inventoryItem.IsProgram() {
      if plus >= 2 {
        qualityValue += 2;
      } else {
        if plus >= 1 {
          qualityValue += 1;
        };
      };
    };

    return qualityValue;
  }

  private final func AnimateIndicatorTranslation(index: Int32) -> Void {
    let newTranslation: Float = Cast<Float>(index) * 100.0;
    let translationsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(0.25);
    translationInterpolator.SetStartDelay(0.0);
    translationInterpolator.SetType(inkanimInterpolationType.Quartic);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(inkWidgetRef.GetTranslation(this.m_categoryIndicator));
    translationInterpolator.SetEndTranslation(new Vector2(newTranslation, 0.0));
    translationsAnimDef.AddInterpolator(translationInterpolator);
    inkWidgetRef.PlayAnimation(this.m_categoryIndicator, translationsAnimDef);
  }

  private final func ShowColumnNameTooltip(target: ref<inkWidget>, message: String) -> Void {
    let tooltipData: ref<MessageTooltipData> = new MessageTooltipData();
    tooltipData.Title = message;
    this.m_TooltipsManager.ShowTooltipAtWidget(0, target, tooltipData, gameuiETooltipPlacement.LeftTop, true, new inkMargin(64.0, -80.0, 0.0, 0.0));
  }

  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(this.m_player, evt);
  }

  private final func UpdateSelectedItemsCounter() -> Void {
    let count: Int32 = ArraySize(this.m_selectedItems);
    for item in this.m_selectedItems {
      this.Log(s" -> selected: \(item.nameLabel)");
    }
    inkTextRef.SetText(this.m_selectedItemsCount, s"\(GetLocalizedTextByKey(n"Mod-Revised-Select-Label")) \(count)");
    this.QueueEvent(RevisedBackpackSelectedItemsCountChangedEvent.Create(count));
  }

  private final func AnimateTranslationAndOpacity(start: Vector2, end: Vector2, duration: Float, delay: Float) -> ref<inkAnimDef> {
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Quintic);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);

    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(start);
    translationInterpolator.SetEndTranslation(end);

    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    moveElementsAnimDef.AddInterpolator(translationInterpolator);
    
    return moveElementsAnimDef;
  }

  private final func AnimateOpacity(duration: Float, delay: Float) -> ref<inkAnimDef> {
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();

    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);
    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);

    return moveElementsAnimDef;
  }

  private final func GetDataSourceItems() -> array<ref<RevisedItemWrapper>> {
    let allItems: array<ref<IScriptable>> = this.itemsListDataSource.GetArray();
    let result: array<ref<RevisedItemWrapper>>;
    let wrapper: ref<RevisedItemWrapper>;
    for item in allItems {
      wrapper = item as RevisedItemWrapper;
      if IsDefined(wrapper) {
        ArrayPush(result, wrapper);
      };
    };

    return result;
  }

  private final func GetDataViewItems() -> array<ref<RevisedItemWrapper>> {
    let dataViewItemsCount: Uint32 = this.itemsListDataView.Size();
    let index: Uint32 = 0u;
    let result: array<ref<RevisedItemWrapper>>;
    let wrapper: ref<RevisedItemWrapper>;
    while index < dataViewItemsCount {
      wrapper = this.itemsListDataView.GetItem(index) as RevisedItemWrapper;
      if IsDefined(wrapper) {
        ArrayPush(result, wrapper);
      };
      index += 1u;
    };

    return result;
  }

  private final func GetListControllers() -> array<ref<RevisedBackpackItemController>> {
    let result: array<ref<RevisedBackpackItemController>>;
    let listRoot: ref<inkCompoundWidget> = this.itemsListController.GetRootCompoundWidget();
    let itemsCount: Int32 = listRoot.GetNumChildren();
    let controller: ref<RevisedBackpackItemController>;
    let childIndex: Int32 = 0;
    while childIndex < itemsCount {
      controller = listRoot.GetWidgetByIndex(childIndex).GetController() as RevisedBackpackItemController;
      if IsDefined(controller) {
        ArrayPush(result, controller);
      };
      childIndex += 1;
    };
    
    return result;
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedController", str);
    };
  }
}
