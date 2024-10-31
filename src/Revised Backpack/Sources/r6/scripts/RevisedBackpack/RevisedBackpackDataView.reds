module RevisedBackpack

public class RevisedBackpackDataView extends ScriptableDataView {
  private let m_uiScriptableSystem: wref<UIScriptableSystem>;
  private let m_selectedCategory: ref<RevisedBackpackCategory>;
  private let m_sorting: revisedSorting;
  private let m_sortingMode: revisedSortingMode;
  private let m_searchQuery: String;
  private let m_newItemsOnTop: Bool;
  private let m_favoriteItemsOnTop: Bool;

  public final func BindUIScriptableSystem(uiScriptableSystem: wref<UIScriptableSystem>) -> Void {
    this.m_uiScriptableSystem = uiScriptableSystem;
    this.m_sorting = revisedSorting.None;
    this.m_sortingMode = revisedSortingMode.None;
  }

  public final func UpdateView() {
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }

  public final func SetSortMode(sorting: revisedSorting, mode: revisedSortingMode) -> Void {
    this.m_sorting = sorting;
    this.m_sortingMode = mode;
    this.RefreshList();
  }

  public final func SetNewOnTop(active: Bool) -> Void {
    this.m_newItemsOnTop = active;
    this.RefreshList();
  };

  public final func SetFavoriteOnTop(active: Bool) -> Void {
    this.m_favoriteItemsOnTop = active;
    this.RefreshList();
  };

  protected func PreSortingInjection(builder: ref<RevisedCompareBuilder>) -> ref<RevisedCompareBuilder> {
    return builder;
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftEntry: ref<RevisedItemWrapper> = left as RevisedItemWrapper;
    let rightEntry: ref<RevisedItemWrapper> = right as RevisedItemWrapper;
    let leftItem: ref<RevisedItemSortData> = RevisedCompareBuilder.BuildRevisedItemSortData(leftEntry, this.m_uiScriptableSystem);
    let rightItem: ref<RevisedItemSortData> = RevisedCompareBuilder.BuildRevisedItemSortData(rightEntry, this.m_uiScriptableSystem);

    switch this.m_sorting {
      case revisedSorting.Name:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().NameDesc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NameDesc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().NameDesc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NameDesc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Type:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().TypeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().TypeAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().TypeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).TypeAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().TypeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().TypeDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().TypeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).TypeDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Tier:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QualityAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QualityAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QualityAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QualityDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QualityDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QualityDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Price:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().PriceAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().PriceAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().PriceAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).PriceAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().PriceDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().PriceDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().PriceDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).PriceDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Weight:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().WeightAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().WeightAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().WeightAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).WeightAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().WeightDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().WeightDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().WeightDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).WeightDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Dps:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().DpsAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().DpsAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().DpsAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).DpsAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().DpsDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().DpsDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().DpsDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).DpsDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Quest:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QuestAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QuestAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QuestAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QuestAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QuestDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QuestDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QuestDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QuestDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

    };

    return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityDesc().TypeAsc().NameAsc().GetBool();
  }

  public final func SetCategory(category: ref<RevisedBackpackCategory>) -> Void {
    if NotEquals(this.m_selectedCategory, category) {
      this.m_selectedCategory = category;
      this.Filter();
    };
  }
  
  public final func SetSearchQuery(query: String) -> Void {
    this.m_searchQuery = query;
    this.Filter();
  }

  public func FilterItem(data: ref<IScriptable>) -> Bool {
    let itemWrapper: ref<RevisedItemWrapper> = data as RevisedItemWrapper;
    let name: String = itemWrapper.GetNameLabel();
    let nameNotEmpty: Bool = NotEquals(name, "");
    let predicate: Bool = this.m_selectedCategory.predicate.Check(itemWrapper);
    let searchMatched: Bool = this.ItemTextsContainQuery(itemWrapper);
    return nameNotEmpty && predicate && searchMatched;
  }

  private final func RefreshList() -> Void {
    let wasSortingEnabled: Bool = this.IsSortingEnabled();
    if !wasSortingEnabled {
      this.UpdateView();
      this.Sort();
    } else {
      this.Sort();
    };
  }

  private final func ItemTextsContainQuery(item: ref<RevisedItemWrapper>) -> Bool {
    if Equals(this.m_searchQuery, "") {
      return true;
    };

    let combined: String = "";
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(item.id);
    let weaponRecord: ref<WeaponItem_Record>;

    // Name
    let itemName: String = UTF8StrLower(GetLocalizedTextByKey(itemRecord.DisplayName()));
    combined += itemName;

    // Type
    let itemTypeString: String = UTF8StrLower(GetLocalizedText(UIItemsHelper.GetItemTypeKey(itemRecord.ItemType().Type())));
    combined += itemTypeString;

    // Weapon evolution
    let evolution: String;
    if CraftingMainLogicController.IsWeapon(itemRecord.EquipArea().Type()) {
      weaponRecord = itemRecord as WeaponItem_Record;
      if IsDefined(weaponRecord) {
        evolution = UIItemsHelper.GetItemTypeKey(weaponRecord.ItemType().Type(), weaponRecord.Evolution().Type());
        combined += UTF8StrLower(GetLocalizedText(evolution));
      };
    };

    // Description
    let description: String = UTF8StrLower(GetLocalizedTextByKey(itemRecord.LocalizedDescription()));
    combined += description;

    return StrContains(combined, this.m_searchQuery);
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedView", str);
    };
  }
}
