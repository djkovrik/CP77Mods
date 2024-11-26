module RevisedBackpack

public class RevisedBackpackSystem extends ScriptableSystem {

  private persistent let customJunk: array<ItemID>;

  private let categories: array<ref<RevisedBackpackCategory>>;
  
  public static func GetInstance(gi: GameInstance) -> ref<RevisedBackpackSystem> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"RevisedBackpack.RevisedBackpackSystem") as RevisedBackpackSystem;
  }

  public final func AddNewCategory(category: ref<RevisedBackpackCategory>) -> Void {
    let newCategories: array<ref<RevisedBackpackCategory>> = this.categories;
    ArrayPush(newCategories, category);
    RevisedBackpackCategory.Sort(newCategories);
    this.categories = newCategories;
    this.Log(s"Category added, total: \(ArraySize(this.categories))");
  }

  public final func AddNewCategories(categories: array<ref<RevisedBackpackCategory>>) -> Void {
    let newCategories: array<ref<RevisedBackpackCategory>> = this.categories;
    for category in categories {
      ArrayPush(newCategories, category);
    };
    RevisedBackpackCategory.Sort(newCategories);
    this.categories = newCategories;
    this.Log(s"Categories added, total: \(ArraySize(this.categories))");
  }

  public final func GetCategories() -> array<ref<RevisedBackpackCategory>> {
    this.Log(s"GetCategorues returns categories: \(ArraySize(this.categories))");
    return this.categories;
  }

  public final func IsAddedToJunk(itemId: ItemID) -> Bool {
    return ArrayContains(this.customJunk, itemId);
  }

  public final func AddToJunk(itemId: ItemID) -> Bool {
    if this.IsAddedToJunk(itemId) {
      return false;
    };

    ArrayPush(this.customJunk, itemId);
    return true;
  }

  public final func RemoveFromJunk(itemId: ItemID) -> Bool {
    if !this.IsAddedToJunk(itemId)  {
      return false;
    };

    ArrayRemove(this.customJunk, itemId);
    return true;
  }

  public final func HasCustomJunk() -> Bool {
    return ArraySize(this.customJunk) > 0;
  }

  public final func InvalidateCustomJunk(inventory: array<ref<IScriptable>>) -> Void {
    let updated: array<ItemID>;
    let itemId: ItemID;
    let wrapper: ref<RevisedItemWrapper>;
    for item in inventory {
      wrapper = item as RevisedItemWrapper;
      if IsDefined(wrapper) {
        itemId = wrapper.data.GetID();
        if this.IsAddedToJunk(itemId) {
          ArrayPush(updated, itemId);
        };
      }
    };

    this.customJunk = updated;
  }

  public final func ClearCustomJunk() -> Void {
    ArrayClear(this.customJunk);
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.Log("OnInitialize, can access game systems");
    if Equals(ArraySize(this.categories), 0) {
      this.FillDefaultCategories();
    };
  }

  private final func FillDefaultCategories() -> Void {
    let newCategories: array<ref<RevisedBackpackCategory>> = RevisedBackpackDefaultConfig.Categories();
    this.AddNewCategories(newCategories);
    this.Log(s"Default categories created: \(ArraySize(this.categories))");
    for category in this.categories {
      this.Log(s"- \(category.id): \(GetLocalizedTextByKey(category.titleLocKey))");
    };
  }

  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedService", str);
    };
  }
}
