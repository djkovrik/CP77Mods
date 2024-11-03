module RevisedBackpack

public class RevisedBackpackService extends ScriptableService {

  private let categories: array<ref<RevisedBackpackCategory>>;
  
  public static func GetInstance() -> ref<RevisedBackpackService> {
    return GameInstance.GetScriptableServiceContainer().GetService(n"RevisedBackpack.RevisedBackpackService") as RevisedBackpackService;
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

  private cb func OnInitialize() -> Void {
    this.Log("OnInitialize, can access game systems");
    this.FillDefaultCategories();
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
