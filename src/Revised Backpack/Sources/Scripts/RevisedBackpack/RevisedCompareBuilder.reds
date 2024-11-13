module RevisedBackpack

public class RevisedCompareBuilder extends IScriptable {
  private let m_sortData1: ref<RevisedItemWrapper>;
  private let m_sortData2: ref<RevisedItemWrapper>;
  private let m_compareBuilder: ref<CompareBuilder>;

  public final static func Make(sortData1: ref<RevisedItemWrapper>, sortData2: ref<RevisedItemWrapper>) -> ref<RevisedCompareBuilder> {
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
    this.m_compareBuilder.StringAsc(this.m_sortData1.nameLabel, this.m_sortData2.nameLabel);
    return this;
  }

  public final func NameDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.StringDesc(this.m_sortData1.nameLabel, this.m_sortData2.nameLabel);
    return this;
  }

  public final func TypeAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.typeValue, this.m_sortData2.typeValue);
    return this;
  }

  public final func TypeDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.typeValue, this.m_sortData2.typeValue);
    return this;
  }

  public final func QualityAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.tierValue, this.m_sortData2.tierValue);
    return this;
  }

  public final func QualityDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.tierValue, this.m_sortData2.tierValue);
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

  public final func DamagePerShotAsc() -> ref<RevisedCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.damagePerShot;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.damagePerShot;
    };
    this.m_compareBuilder.FloatAsc(leftValue, rightValue);
    return this;
  }

  public final func DamagePerShotDesc() -> ref<RevisedCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.damagePerShot;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.damagePerShot;
    };
    this.m_compareBuilder.FloatDesc(leftValue, rightValue);
    return this;
  }

  public final func RangeAsc() -> ref<RevisedCompareBuilder> {
    let leftValue: Int32;
    let rightValue: Int32;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.range;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.range;
    };
    this.m_compareBuilder.IntAsc(leftValue, rightValue);
    return this;
  }

  public final func RangeDesc() -> ref<RevisedCompareBuilder> {
    let leftValue: Int32;
    let rightValue: Int32;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.range;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.range;
    };
    this.m_compareBuilder.IntDesc(leftValue, rightValue);
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

  public final func CustomJunkAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.customJunk, this.m_sortData2.customJunk);
    return this;
  }

  public final func CustomJunkDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolFalse(this.m_sortData1.customJunk, this.m_sortData2.customJunk);
    return this;
  }

  public final func NewItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isNew, this.m_sortData2.isNew);
    return this;
  }

  public final func FavouriteItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isFavorite, this.m_sortData2.isFavorite);
    return this;
  }

  public final func DLCAddedItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isDlcAddedItem, this.m_sortData2.isDlcAddedItem);
    return this;
  }
}
