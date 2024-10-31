module RevisedBackpack

public class RevisedCompareBuilder extends IScriptable {
  private let m_sortData1: ref<RevisedItemSortData>;
  private let m_sortData2: ref<RevisedItemSortData>;
  private let m_compareBuilder: ref<CompareBuilder>;

  public final static func BuildRevisedItemSortData(item: ref<RevisedItemWrapper>, uiScriptableSystem: ref<UIScriptableSystem>) -> ref<RevisedItemSortData> {
    let sortData: ref<RevisedItemSortData> = new RevisedItemSortData();
    let itemID: ItemID = item.data.GetID();
    sortData.name = GetLocalizedTextByKey(item.displayNameKey);
    sortData.type = ItemCompareBuilder.GetItemTypeOrder(item.data, item.equipArea, item.type);
    sortData.tier = UIInventoryItemsManager.QualityToInt(item.inventoryItem.GetQuality());
    sortData.price = item.inventoryItem.GetSellPrice();
    sortData.weight = item.inventoryItem.GetWeight();
    sortData.dps = item.dps;
    sortData.isQuest = item.data.HasTag(n"Quest") || item.inventoryItem.IsQuestItem();
    sortData.isNew = uiScriptableSystem.IsInventoryItemNew(itemID);
    sortData.isFavourite = uiScriptableSystem.IsItemPlayerFavourite(itemID);
    sortData.isDlcAddedItem = item.data.HasTag(n"DLCAdded") && uiScriptableSystem.IsDLCAddedActiveItem(ItemID.GetTDBID(itemID));
    sortData.isWeapon = item.inventoryItem.IsWeapon();
    return sortData;
  }

  public final static func Make(sortData1: ref<RevisedItemSortData>, sortData2: ref<RevisedItemSortData>) -> ref<RevisedCompareBuilder> {
    let builder: ref<RevisedCompareBuilder> = new RevisedCompareBuilder();
    builder.m_compareBuilder = CompareBuilder.Make();
    builder.m_sortData1 = sortData1;
    builder.m_sortData2 = sortData2;
    return builder;
  }

  public final func Get() -> Int32 {
    return this.m_compareBuilder.Get();
  }

  public final func GetBool() -> Bool {
    return this.m_compareBuilder.GetBool();
  }

  public final func NameAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.StringAsc(this.m_sortData1.name, this.m_sortData2.name);
    return this;
  }

  public final func NameDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.StringDesc(this.m_sortData1.name, this.m_sortData2.name);
    return this;
  }

  public final func TypeAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.type, this.m_sortData2.type);
    return this;
  }

  public final func TypeDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.type, this.m_sortData2.type);
    return this;
  }

  public final func QualityAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.tier, this.m_sortData2.tier);
    return this;
  }

  public final func QualityDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.tier, this.m_sortData2.tier);
    return this;
  }

  public final func PriceAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.price, this.m_sortData2.price);
    return this;
  }

  public final func PriceDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.price, this.m_sortData2.price);
    return this;
  }

  public final func WeightAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.weight, this.m_sortData2.weight);
    return this;
  }

  public final func WeightDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.weight, this.m_sortData2.weight);
    return this;
  }

  public final func DpsAsc() -> ref<RevisedCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.dps;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.dps;
    };
    this.m_compareBuilder.FloatAsc(leftValue, rightValue);
    return this;
  }

  public final func DpsDesc() -> ref<RevisedCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.dps;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.dps;
    };
    this.m_compareBuilder.FloatDesc(leftValue, rightValue);
    return this;
  }

  public final func QuestAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isQuest, this.m_sortData2.isQuest);
    return this;
  }

  public final func QuestDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolFalse(this.m_sortData1.isQuest, this.m_sortData2.isQuest);
    return this;
  }

  public final func NewItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isNew, this.m_sortData2.isNew);
    return this;
  }

  public final func FavouriteItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isFavourite, this.m_sortData2.isFavourite);
    return this;
  }

  public final func DLCAddedItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isDlcAddedItem, this.m_sortData2.isDlcAddedItem);
    return this;
  }
}
