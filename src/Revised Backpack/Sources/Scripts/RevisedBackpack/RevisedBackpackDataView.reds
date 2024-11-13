module RevisedBackpack

public class RevisedBackpackDataView extends ScriptableDataView {
  private let m_uiScriptableSystem: wref<UIScriptableSystem>;
  private let m_selectedCategory: ref<RevisedBackpackCategory>;
  private let m_sorting: revisedSorting;
  private let m_sortingMode: revisedSortingMode;
  private let m_filtering: ref<RevisedFilteringEvent>;
  private let m_newItemsOnTop: Bool;
  private let m_favoriteItemsOnTop: Bool;
  private let m_skipCustomFilters: Bool;

  public final func Init() -> Void {
    let settings: ref<RevisedBackpackSettings> = new RevisedBackpackSettings();
    this.m_newItemsOnTop = settings.newOnTop;
    this.m_favoriteItemsOnTop = settings.favoriteOnTop;
    this.m_skipCustomFilters = true;
  }

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

  protected func PreSortingInjection(builder: ref<RevisedCompareBuilder>) -> ref<RevisedCompareBuilder> {
    return builder;
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftItem: ref<RevisedItemWrapper> = left as RevisedItemWrapper;
    let rightItem: ref<RevisedItemWrapper> = right as RevisedItemWrapper;

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

      case revisedSorting.DamagePerShot:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().DamagePerShotAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().DamagePerShotAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().DamagePerShotAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).DamagePerShotAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().DamagePerShotDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().DamagePerShotDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().DamagePerShotDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).DamagePerShotDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;

      case revisedSorting.Range:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().RangeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().RangeAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().RangeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).RangeAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().RangeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().RangeDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().RangeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).RangeDesc().NameAsc().QualityDesc().GetBool();
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

      case revisedSorting.CustomJunk:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
    };

    // By default
    if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
      return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QualityDesc().TypeAsc().NameAsc().GetBool();
    } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
      return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityDesc().TypeAsc().NameAsc().GetBool();
    } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
      return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QualityDesc().TypeAsc().NameAsc().GetBool();
    };

    // Nothing on top
    return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QualityDesc().TypeAsc().NameAsc().GetBool();
  }

  public final func SetCategory(category: ref<RevisedBackpackCategory>) -> Void {
    if NotEquals(this.m_selectedCategory, category) {
      this.m_selectedCategory = category;
      this.Filter();
    };
  }
  
  public final func SetFilters(event: ref<RevisedFilteringEvent>) -> Void {
    this.m_skipCustomFilters = event.filtersReset;
    this.m_filtering = event;
    this.Log(s"SetFilters with [\(event.nameQuery)] and [\(event.typeQuery)]");
    this.Filter();
  }

  public func FilterItem(data: ref<IScriptable>) -> Bool {
    let itemWrapper: ref<RevisedItemWrapper> = data as RevisedItemWrapper;
    let name: String = itemWrapper.nameLabel;
    let nameNotEmpty: Bool = NotEquals(name, "");
    let predicate: Bool = this.m_selectedCategory.predicate.Check(itemWrapper);
    if this.m_skipCustomFilters {
      return nameNotEmpty && predicate;
    };

    let nameSearchMatched: Bool = true;
    if NotEquals(this.m_filtering.nameQuery, "") {
      nameSearchMatched = this.ItemTextsContainQuery(itemWrapper, this.m_filtering.nameQuery);
    };

    let typeSearchMatched: Bool = true;
    if NotEquals(this.m_filtering.typeQuery, "") {
      typeSearchMatched = this.ItemTypeContainsQuery(itemWrapper, this.m_filtering.typeQuery);
    };

    let tierMatched: Bool = ArrayContains(this.m_filtering.tiers, itemWrapper.tier);

    return nameNotEmpty && predicate && nameSearchMatched && typeSearchMatched && tierMatched;
  }

  private final func RefreshList() -> Void {
    let wasSortingEnabled: Bool = this.IsSortingEnabled();
    if !wasSortingEnabled {
      this.UpdateView();
    } else {
      this.Sort();
    };
  }

  private final func ItemTextsContainQuery(item: ref<RevisedItemWrapper>, query: String) -> Bool {
    let combined: String = "";
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(item.id);
    let weaponRecord: ref<WeaponItem_Record>;

    // Name
    let itemName: String = UTF8StrLower(GetLocalizedTextByKey(itemRecord.DisplayName()));
    combined += itemName;

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

    return StrContains(combined, UTF8StrLower(query));
  }

  private final func ItemTypeContainsQuery(item: ref<RevisedItemWrapper>, query: String) -> Bool {
    let itemTypeString: String = UTF8StrLower(item.typeLabel);
    let substring: String = UTF8StrLower(query);
    this.Log(s"ItemTypeContainsQuery search \(substring) inside \(itemTypeString)");
    return StrContains(itemTypeString, substring);
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedView", str);
    };
  }
}
