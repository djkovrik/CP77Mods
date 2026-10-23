module StashSearch
import Codeware.UI.*

// -- Displayed items filtering support

@addField(BackpackDataView)
private let customSearchQuery: String;

@addMethod(BackpackDataView)
public func UpdateSearchQuery(query: String) -> Void {
  this.customSearchQuery = query;
}

@wrapMethod(BackpackDataView)
public func DerivedFilterItem(data: ref<IScriptable>) -> DerivedFilterResult {
  let result: DerivedFilterResult = wrappedMethod(data);
  let wrappedData: ref<WrappedInventoryItemData> = data as WrappedInventoryItemData;
  let query: String = UTF8StrLower(this.customSearchQuery);

  if !IsDefined(wrappedData) || Equals(query, "") {
    return DerivedFilterResult.Pass;
  };

  let combined: String = "";
  let iteRecord: ref<Item_Record> = wrappedData.Item.GetItemRecord();
  let weaponRecord: ref<WeaponItem_Record>;

  // Name
  let itemName: String = UTF8StrLower(GetLocalizedTextByKey(iteRecord.DisplayName()));
  combined += itemName;

  // Type
  let itemTypeString: String = UTF8StrLower(GetLocalizedText(UIItemsHelper.GetItemTypeKey(iteRecord.ItemType().Type())));
  combined += itemTypeString;

  // Weapon evolution
  let evolution: String;
  if CraftingMainLogicController.IsWeapon(iteRecord.EquipArea().Type()) {
    weaponRecord = iteRecord as WeaponItem_Record;
    if IsDefined(weaponRecord) {
      evolution = UIItemsHelper.GetItemTypeKey(weaponRecord.ItemType().Type(), weaponRecord.Evolution().Type());
      combined += UTF8StrLower(GetLocalizedText(evolution));
    };
  };

  // Description
  let description: String = UTF8StrLower(GetLocalizedTextByKey(iteRecord.LocalizedDescription()));
  combined += description;

  if !StrContains(combined, query) {
    return DerivedFilterResult.False;
  };

  return result;
}


// -- New text input for backpack

@addField(BackpackMainGameController)
private let searchInput: wref<HubTextInput>;


@wrapMethod(BackpackMainGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.InitializeSearchInput();
}

@addMethod(BackpackMainGameController)
private final func InitializeSearchInput() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"wrapper/inkCanvasWidget21/inkVerticalPanelWidget25") as inkCompoundWidget;

  let searchContainer: ref<inkCanvas> = new inkCanvas();
  searchContainer.SetName(n"searchContainer");
  searchContainer.SetMargin(0.0, 8.0, 0.0, 0.0);
  searchContainer.Reparent(container);

  let searchInputPlayer: ref<HubTextInput> = HubTextInput.Create();
  searchInputPlayer.SetName(n"searchInputPlayer");
  searchInputPlayer.SetLetterCase(textLetterCase.OriginalCase);
  searchInputPlayer.SetMaxLength(32);
  searchInputPlayer.SetDefaultText(GetLocalizedText("LocKey#48662"));
  searchInputPlayer.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
  searchInputPlayer.Reparent(searchContainer);
  this.searchInput = searchInputPlayer;
}


// -- Filter displayed items on search input

@addMethod(BackpackMainGameController)
protected cb func OnSearchInput(widget: wref<inkWidget>) {
  this.m_backpackItemsDataView.UpdateSearchQuery(this.searchInput.GetText());
  this.m_backpackItemsDataView.Filter();
}

// -- Reset input focus on generic click

@wrapMethod(BackpackMainGameController)
protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  wrappedMethod(evt);

  if evt.IsAction(n"mouse_left") {
    if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
      this.RequestSetFocus(null);
    };
  };
}
