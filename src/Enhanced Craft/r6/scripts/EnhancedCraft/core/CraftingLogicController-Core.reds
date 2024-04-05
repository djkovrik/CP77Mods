module EnhancedCraft.Core
import EnhancedCraft.Events.*
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  let recipe: ref<RecipeData>;
  this.SetItemButtonHintsHoverOut(null);
  recipe = FromVariant<ref<IScriptable>>(craftableController.GetData()) as RecipeData;
  let multiplier: Int32 = this.ecraftConfig.iconicIngredientsMultiplier;
  this.selectedRecipeVariants = this.m_craftingSystem.GetRecipesData(recipe.id, multiplier, false);
  this.selectedRecipeVariantsNoIconics = this.m_craftingSystem.GetRecipesData(recipe.id, multiplier, true);
  this.isWeaponSelected = ECraftUtils.IsWeapon(recipe.id.ItemType().Type());
  this.selectedItemIndex = 0;
  L(s"UpdateItemPreview for \(recipe.label) \(TDBID.ToStringDEBUG(recipe.id.GetID())) \(recipe.id.ItemType().Type()): weapon: \(this.isWeaponSelected), variants: \(ArraySize(this.selectedRecipeVariants))");
  this.RefreshPanelWidgets();
  if ArraySize(this.selectedRecipeVariants) > 0 && this.isWeaponSelected {
    recipe = this.selectedRecipeVariants[0];
    this.UpdateRecipePreviewPanel(recipe);
  } else {
    wrappedMethod(craftableController);
  };
}

@wrapMethod(CraftingLogicController)
private final func UpdateRecipePreviewPanel(selectedRecipe: ref<RecipeData>) -> Void {
  wrappedMethod(selectedRecipe);
  if IsDefined(selectedRecipe) {
    L(s"UpdateRecipePreviewPanel for \(selectedRecipe.label) \(TDBID.ToStringDEBUG(selectedRecipe.id.GetID()))");
  };
}

// -- Inject with custom and random crafts
@wrapMethod(CraftingLogicController)
private final func CraftItem(selectedRecipe: ref<RecipeData>, amount: Int32) -> Void {
  let request: ref<CraftItemRequest>;
  let hasVariantsToRandomize: Bool = ArraySize(this.selectedRecipeVariantsNoIconics) > 1;
  let randomRecipe: ref<RecipeData>;
  if this.isWeaponSelected {
    if NotEquals(selectedRecipe.label, "") {
      request = new CraftItemRequest();
      request.target = this.m_craftingGameController.GetPlayer();
      if this.ecraftConfig.randomizerEnabled && hasVariantsToRandomize {
        randomRecipe = this.GetRandomWeaponRecipe();
        request.itemRecord = randomRecipe.id;
      } else {
        request.itemRecord = selectedRecipe.id;
      };
      request.amount = amount;
      this.m_craftingSystem.QueueRequest(request);
    };
  } else {
    wrappedMethod(selectedRecipe, amount);
  };
}

// -- Hide hints on tab changed
@addMethod(CraftingLogicController)
protected cb func OnFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  super.OnFilterChange(controller, selectedIndex);
  this.HideButtonHints();
}
