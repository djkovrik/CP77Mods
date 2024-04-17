module StashSearch
import Codeware.UI.*

// -- Displayed items filtering support

@addField(VendorDataView)
private let itemSearchQuery: String;

@addMethod(VendorDataView)
public func UpdateSearchQuery(query: String) -> Void {
  this.itemSearchQuery = query;
}

@wrapMethod(VendorDataView)
public func DerivedFilterItem(data: ref<IScriptable>) -> DerivedFilterResult {
  let result: DerivedFilterResult = wrappedMethod(data);
  let wrappedData: ref<VendorUIInventoryItemData> = data as VendorUIInventoryItemData;
  let query: String = StrLower(this.itemSearchQuery);

  if !IsDefined(wrappedData) || Equals(query, "") {
    return result;
  };

  let combined: String = "";
  let iteRecord: ref<Item_Record> = wrappedData.Item.GetItemRecord();
  let weaponRecord: ref<WeaponItem_Record>;

  // Name
  let itemName: String = StrLower(GetLocalizedTextByKey(iteRecord.DisplayName()));
  combined += itemName;

  // Type
  let itemTypeString: String = StrLower(GetLocalizedText(UIItemsHelper.GetItemTypeKey(iteRecord.ItemType().Type())));
  combined += itemTypeString;

  // Weapon evolution
  let evolution: String;
  if CraftingMainLogicController.IsWeapon(iteRecord.EquipArea().Type()) {
    weaponRecord = iteRecord as WeaponItem_Record;
    if IsDefined(weaponRecord) {
      evolution = UIItemsHelper.GetItemTypeKey(weaponRecord.ItemType().Type(), weaponRecord.Evolution().Type());
      combined += StrLower(GetLocalizedText(evolution));
    };
  };

  // Description
  let description: String = StrLower(GetLocalizedTextByKey(iteRecord.LocalizedDescription()));
  combined += description;

  if !StrContains(combined, query) {
    return DerivedFilterResult.False;
  };

  return result;
}


// -- New text inputs for vendor screen (for storage mode only)

@addField(FullscreenVendorGameController)
private let searchInputPlayer: wref<HubTextInput>;

@addField(FullscreenVendorGameController)
private let searchInputStorage: wref<HubTextInput>;

@wrapMethod(FullscreenVendorGameController)
protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
  wrappedMethod(userData);

  if IsDefined(this.m_storageUserData) {
    this.InitializeSearchInputs();
  };
}

@addMethod(FullscreenVendorGameController)
private final func InitializeSearchInputs() -> Void {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let containerPlayer: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"wrapper/wrapper/playerPanel/playerHeader") as inkCompoundWidget;
  let containerStorage: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"wrapper/wrapper/vendorPanel/vendorHeader") as inkCompoundWidget;

  let searchContainerPlayer: ref<inkCanvas> = new inkCanvas();
  searchContainerPlayer.SetName(n"searchContainerPlayer");
  searchContainerPlayer.SetMargin(0.0, 4.0, 0.0, 32.0);
  searchContainerPlayer.Reparent(containerPlayer);

  let searchInputPlayer: ref<HubTextInput> = HubTextInput.Create();
  searchInputPlayer.SetName(n"searchInputPlayer");
  searchInputPlayer.SetLetterCase(textLetterCase.OriginalCase);
  searchInputPlayer.SetMaxLength(32);
  searchInputPlayer.SetDefaultText(GetLocalizedText("LocKey#48662"));
  searchInputPlayer.RegisterToCallback(n"OnInput", this, n"OnSearchInputPlayer");
  searchInputPlayer.Reparent(searchContainerPlayer);
  this.searchInputPlayer = searchInputPlayer;

  let searchContainerStorage: ref<inkCanvas> = new inkCanvas();
  searchContainerStorage.SetName(n"searchContainerStorage");
  searchContainerStorage.SetMargin(0.0, 4.0, 0.0, 32.0);
  searchContainerStorage.Reparent(containerStorage);

  let searchInputStorage: ref<HubTextInput> = HubTextInput.Create();
  searchInputStorage.SetName(n"searchInputStorage");
  searchInputStorage.SetLetterCase(textLetterCase.OriginalCase);
  searchInputStorage.SetMaxLength(32);
  searchInputStorage.SetDefaultText(GetLocalizedText("LocKey#48662"));
  searchInputStorage.RegisterToCallback(n"OnInput", this, n"OnSearchInputStorage");
  searchInputStorage.Reparent(searchContainerStorage);
  this.searchInputStorage = searchInputStorage;
}


// -- Filter displayed items on search input

@addMethod(FullscreenVendorGameController)
protected cb func OnSearchInputPlayer(widget: wref<inkWidget>) {
  this.m_playerItemsDataView.UpdateSearchQuery(this.searchInputPlayer.GetText());
  this.m_playerItemsDataView.Filter();
  this.m_playerItemsDataView.EnableSorting();
  this.m_playerItemsDataView.SetFilterType(this.m_lastPlayerFilter);
  this.m_playerItemsDataView.SetSortMode(this.m_playerItemsDataView.GetSortMode());
  this.m_playerItemsDataView.DisableSorting();
}

@addMethod(FullscreenVendorGameController)
protected cb func OnSearchInputStorage(widget: wref<inkWidget>) {
  this.m_vendorItemsDataView.UpdateSearchQuery(this.searchInputStorage.GetText());
  this.m_vendorItemsDataView.Filter();
  this.m_vendorItemsDataView.EnableSorting();
  this.m_vendorItemsDataView.SetFilterType(this.m_lastVendorFilter);
  this.m_vendorItemsDataView.SetSortMode(this.m_vendorItemsDataView.GetSortMode());
  this.m_vendorItemsDataView.DisableSorting();
}


// -- Reset input focus on generic click

@wrapMethod(FullscreenVendorGameController)
protected cb func OnHandleGlobalPress(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);

  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    };
  };
}
