public class OwnedLabelConfig {
  public static func Text() -> String = "Owned"
  public static func Size() -> Int32 = 32
  public static func LeftMargin() -> Int32 = 110
  public static func TopMargin() -> Int32 = 5
}

public class inkOwnedLabel {
  public static func AddOwnedLabel(parent: wref<inkCompoundWidget>) -> Void {
    let ownedText: ref<inkText> = parent.GetWidgetByPathName(n"ownedText") as inkText;

    if !IsDefined(ownedText) {
      ownedText = new inkText();
      ownedText.SetName(n"ownedText");
      ownedText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
      ownedText.SetFontStyle(n"Medium");
      ownedText.SetFontSize(OwnedLabelConfig.Size());
      ownedText.SetLetterCase(textLetterCase.OriginalCase);
      ownedText.SetTintColor(new Color(Cast(251), Cast(246), Cast(111), Cast(255)));
      ownedText.SetText(OwnedLabelConfig.Text());
      ownedText.SetMargin(Cast(OwnedLabelConfig.LeftMargin()), Cast(OwnedLabelConfig.TopMargin()), 0.0, 0.0);
      ownedText.SetSize(parent.GetWidth(), 50.0);
      ownedText.Reparent(parent);
      parent.ReorderChild(ownedText, 0);
    };
  }
}

@addMethod(PlayerPuppet)
public func IsRecipeKnown(itemData: wref<gameItemData>) -> Bool {
  let targetId: TweakDBID = TweakDBInterface.GetItemRecipeRecord(ItemID.GetTDBID(itemData.GetID())).CraftingResult().Item().GetID();
  let craftingSystem: ref<CraftingSystem> = CraftingSystem.GetInstance(this.GetGame());
  let recipes: array<ItemRecipe> = craftingSystem.m_playerCraftBook.m_knownRecipes;
  let i: Int32 = 0;

  while i < ArraySize(recipes) {
    if Equals(recipes[i].targetItem, targetId) {
      return true;
    };
    i += 1;
  };

  return false;
}

@addField(VendorInventoryItemData)
public let isKnownByPlayer: Bool;

@addField(InventoryItemDisplayController)
public let m_knownByPlayer: Bool;

@replaceMethod(FullscreenVendorGameController)
private final func PopulateVendorInventory() -> Void {
  let BuybackVendorInventoryData: ref<VendorInventoryItemData>;
  let cacheItem: ref<SoldItem>;
  let i: Int32;
  let items: array<ref<IScriptable>>;
  let j: Int32;
  let localQuantity: Int32;
  let playerMoney: Int32;
  let specialOffers: array<InventoryItemData>;
  let storageItems: array<ref<gameItemData>>;
  let vendorInventory: array<InventoryItemData>;
  let vendorInventoryData: ref<VendorInventoryItemData>;
  let vendorInventorySize: Int32;
  this.m_vendorFilterManager.Clear();
  this.m_vendorFilterManager.AddFilter(ItemFilterCategory.AllItems);
  if IsDefined(this.m_vendorUserData) {
    specialOffers = this.ConvertGameDataIntoInventoryData(this.m_VendorDataManager.GetVendorSpecialOffers(), this.m_VendorDataManager.GetVendorInstance(), true);
    vendorInventory = this.ConvertGameDataIntoInventoryData(this.m_VendorDataManager.GetVendorInventoryItems(), this.m_VendorDataManager.GetVendorInstance(), true);
    vendorInventorySize = ArraySize(vendorInventory);
    if ArraySize(specialOffers) <= 0 {
      inkWidgetRef.SetVisible(this.m_specialOffersWrapper, false);
    } else {
      inkWidgetRef.SetVisible(this.m_specialOffersWrapper, true);
    };
    playerMoney = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();
    i = 0;
    while i < vendorInventorySize {
      cacheItem = this.m_soldItems.GetItem(InventoryItemData.GetID(vendorInventory[i]));
      vendorInventoryData = new VendorInventoryItemData();
      vendorInventoryData.ItemData = vendorInventory[i];
      // +
      if vendorInventory[i].GameItemData.HasTag(n"Recipe") {
        vendorInventoryData.isKnownByPlayer = this.m_player.IsRecipeKnown(vendorInventory[i].GameItemData);
      };
      // +
      this.m_InventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.m_uiScriptableSystem);
      vendorInventoryData.IsVendorItem = true;
      vendorInventoryData.IsEnoughMoney = playerMoney >= Cast(InventoryItemData.GetBuyPrice(vendorInventory[i]));
      vendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);
      if cacheItem != null {
        localQuantity = InventoryItemData.GetQuantity(vendorInventory[i]);
        if cacheItem.quantity == localQuantity {
          vendorInventoryData.IsBuybackStack = true;
        } else {
          if localQuantity > cacheItem.quantity {
            InventoryItemData.SetQuantity(vendorInventoryData.ItemData, localQuantity - cacheItem.quantity);
            BuybackVendorInventoryData = new VendorInventoryItemData();
            BuybackVendorInventoryData.ItemData = vendorInventory[i];
            this.m_InventoryManager.GetOrCreateInventoryItemSortData(BuybackVendorInventoryData.ItemData, this.m_uiScriptableSystem);
            BuybackVendorInventoryData.IsVendorItem = true;
            BuybackVendorInventoryData.IsEnoughMoney = playerMoney >= Cast(InventoryItemData.GetBuyPrice(vendorInventory[i]));
            BuybackVendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);
            BuybackVendorInventoryData.IsBuybackStack = true;
            InventoryItemData.SetQuantity(BuybackVendorInventoryData.ItemData, cacheItem.quantity);
            ArrayPush(items, BuybackVendorInventoryData);
          } else {
            cacheItem;
          };
        };
      };
      if vendorInventoryData.IsBuybackStack {
        this.m_vendorFilterManager.AddFilter(ItemFilterCategory.Buyback);
      } else {
        this.m_vendorFilterManager.AddItem(InventoryItemData.GetGameItemData(vendorInventoryData.ItemData));
      };
      ArrayPush(items, vendorInventoryData);
      i += 1;
    };
  } else {
    if IsDefined(this.m_storageUserData) {
      storageItems = this.m_VendorDataManager.GetStorageItems();
      j = 0;
      while j < ArraySize(storageItems) {
        vendorInventoryData = new VendorInventoryItemData();
        this.m_InventoryManager.GetCachedInventoryItemData(storageItems[j], vendorInventoryData.ItemData);
        this.m_InventoryManager.GetOrCreateInventoryItemSortData(vendorInventoryData.ItemData, this.m_uiScriptableSystem);
        InventoryItemData.SetIsVendorItem(vendorInventoryData.ItemData, true);
        vendorInventoryData.IsVendorItem = true;
        vendorInventoryData.IsEnoughMoney = true;
        vendorInventoryData.ComparisonState = this.GetComparisonState(vendorInventoryData.ItemData);
        ArrayPush(items, vendorInventoryData);
        j += 1;
      };
    };
  };
  this.m_vendorDataSource.Reset(items);
  this.m_vendorFilterManager.SortFiltersList();
  this.m_vendorFilterManager.InsertFilter(0, ItemFilterCategory.AllItems);
  this.SetFilters(this.m_vendorFiltersContainer, this.m_vendorFilterManager.GetIntFiltersList(), n"OnVendorFilterChange");
  this.m_vendorItemsDataView.EnableSorting();
  this.m_vendorItemsDataView.SetFilterType(this.m_lastVendorFilter);
  this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
  this.m_vendorItemsDataView.DisableSorting();
  this.ToggleFilter(this.m_vendorFiltersContainer, EnumInt(this.m_lastVendorFilter));
  inkWidgetRef.SetVisible(this.m_vendorFiltersContainer, ArraySize(items) > 0);
  this.PlayLibraryAnimation(n"vendor_grid_show");
}

@replaceMethod(VendorItemVirtualController)
private final func UpdateControllerData() -> Void {
  if this.m_data.IsVendorItem {
    // this.m_itemViewController.Setup(this.m_data.ItemData, ItemDisplayContext.Vendor, this.m_data.IsEnoughMoney);
    if this.m_data.isKnownByPlayer {
      this.m_itemViewController.SetupHKS(this.m_data.ItemData, ItemDisplayContext.Vendor, this.m_data.IsEnoughMoney, true);
    } else {
      this.m_itemViewController.Setup(this.m_data.ItemData, ItemDisplayContext.Vendor, this.m_data.IsEnoughMoney);
    };
  } else {
    this.m_itemViewController.Setup(this.m_data.ItemData, ItemDisplayContext.VendorPlayer);
  };
  this.m_itemViewController.SetComparisonState(this.m_data.ComparisonState);
  this.m_itemViewController.SetBuybackStack(this.m_data.IsBuybackStack);
}

@addMethod(InventoryItemDisplayController)
public func SetupHKS(itemData: InventoryItemData, displayContext: ItemDisplayContext, enoughMoney: Bool, knownByPlayer: Bool) -> Void {
  this.SetDisplayContext(displayContext, null);
  this.m_enoughMoney = enoughMoney;
  this.m_knownByPlayer = knownByPlayer;
  this.Setup(itemData);
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() -> Void {
  wrappedMethod();
  if this.m_knownByPlayer {
    inkOwnedLabel.AddOwnedLabel(this.GetRootCompoundWidget());
  }
}
