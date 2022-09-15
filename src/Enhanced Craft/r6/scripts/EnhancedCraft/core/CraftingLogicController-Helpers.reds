module EnhancedCraft.Core
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

// -- Switch item variant to previous one
@addMethod(CraftingLogicController)
public func LoadPrevItemVariant() -> Void {
  L("LoadPrevItemVariant");
  let recipe: ref<RecipeData>;
  let tdbid: TweakDBID; 
  if ArraySize(this.m_selectedRecipeVariants) > 1 {
    this.selectedItemIndex = this.selectedItemIndex - 1;
    if this.selectedItemIndex < 0 {
      this.selectedItemIndex = ArraySize(this.m_selectedRecipeVariants) - 1;
    };
    recipe = this.m_selectedRecipeVariants[this.selectedItemIndex];
    tdbid = recipe.id.GetID();
    this.iconicSelected = ECraftUtils.IsPresetIconic(tdbid);
    this.UpdateRecipePreviewPanel(recipe);
    L(s"LoadPrevItemVariant for index \(this.selectedItemIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(recipe.id.Quality().Type()), iconic: \(this.iconicSelected)");
  };
}

// -- Switch item variant to next one
@addMethod(CraftingLogicController)
public func LoadNextItemVariant() -> Void {
  L("LoadNextItemVariant");
  let recipe: ref<RecipeData>;
  let tdbid: TweakDBID; 
  if ArraySize(this.m_selectedRecipeVariants) > 1 {
    this.selectedItemIndex = this.selectedItemIndex + 1;
    if this.selectedItemIndex > ArraySize(this.m_selectedRecipeVariants) - 1 {
      this.selectedItemIndex = 0;
    };
    recipe = this.m_selectedRecipeVariants[this.selectedItemIndex];
    tdbid = recipe.id.GetID();
    this.iconicSelected = ECraftUtils.IsPresetIconic(tdbid);
    this.UpdateRecipePreviewPanel(recipe);
    L(s"LoadNextItemVariant for index \(this.selectedItemIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(recipe.id.Quality().Type()), iconic: \(this.iconicSelected)");
  };
}

// -- Returns random item record (Iconics excluded)
@addMethod(CraftingLogicController)
public func GetRandomWeaponRecipe() -> ref<RecipeData> {
  let index: Int32 = RandRange(0, ArraySize(this.m_selectedRecipeVariantsNoIconics));
  let recipe: ref<RecipeData> = this.m_selectedRecipeVariantsNoIconics[index];
  L(s"GetRandomWeaponRecipe for index \(index) and id \(TDBID.ToStringDEBUG(recipe.id.GetID())) with quality \(recipe.id.Quality().Type())");
  return recipe;
}

// -- Refresh custom crafting panel HUD
@addMethod(CraftingLogicController)
private final func RefreshPanelWidgets() -> Void {  
  if ArraySize(this.m_selectedRecipeVariants) > 1 {
    L(s"RefreshPanelWidgets - show controls");
    this.ShowButtonHints();
  } else {
    L(s"RefreshPanelWidgets - hide controls");
    this.HideButtonHints();
  };
  this.RefreshSkinsCounter();
  this.RefreshClothesCounter();
  this.RefreshRandomizerLabel();
}
