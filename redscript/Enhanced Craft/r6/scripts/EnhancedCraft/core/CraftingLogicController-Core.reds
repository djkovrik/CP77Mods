module EnhancedCraft.Core
import EnhancedCraft.Events.*
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

@wrapMethod(CraftingMainLogicController)
private final func OnPressSelectedItem(evt: ref<inkPointerEvent>) -> Void {
  let wasPreservingRecipePreview: Bool = this.preserveRecipePreview;
  let recipe: ref<RecipeData>;
  let isCraftPress: Bool = evt.IsAction(n"craft_item") || evt.IsAction(n"mouse_left");
  if !isCraftPress && evt.IsAction(n"click") && IsDefined(this.m_Player) {
    isCraftPress = this.m_Player.PlayerLastUsedKBM();
  };
  this.preserveRecipePreview = false;
  if IsDefined(this as CraftingLogicController) && isCraftPress && this.isWeaponSelected && IsDefined(this.m_selectedRecipe) && IsDefined(this.m_currentSelected) {
    recipe = FromVariant<ref<IScriptable>>(this.m_currentSelected.GetData()) as RecipeData;
    this.preserveRecipePreview = IsDefined(recipe) && recipe == this.previewedRecipe;
  };
  wrappedMethod(evt);
  this.preserveRecipePreview = wasPreservingRecipePreview;
}

@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  if this.preserveRecipePreview {
    return ;
  };
  let recipe: ref<RecipeData> = FromVariant<ref<IScriptable>>(craftableController.GetData()) as RecipeData;
  this.previewedRecipe = recipe;
  if !IsDefined(recipe) {
    wrappedMethod(craftableController);
    return ;
  };

  this.SetItemButtonHintsHoverOut(null);
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
