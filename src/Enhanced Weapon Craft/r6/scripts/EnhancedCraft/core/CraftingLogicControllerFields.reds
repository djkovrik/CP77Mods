module EnhancedCraft.Core

// Save if crafting varians populated after recipe selection
@addField(CraftingLogicController)
private let variantsPopulated: Bool;

// Store loaded weapon variants from TweakXL
@addField(CraftingLogicController)
private let weaponVariants: array<TweakDBID>;

// Same variants but with excluded Iconics
@addField(CraftingLogicController)
private let weaponVariantsNoIconic: array<TweakDBID>;

// Store current weapon variant index
@addField(CraftingLogicController)
private let weaponIndex: Int32;

// Is currently selected variant not original
@addField(CraftingLogicController)
private let alternateSkinSelected: Bool;

// Is currently selected variant Iconic
@addField(CraftingLogicController)
private let iconicSelected: Bool;

// Store original recipe
@addField(CraftingLogicController)
private let originalRecipe: ref<RecipeData>;

// Store original recipe quality
@addField(CraftingLogicController)
private let originalRecipeQuality: CName;

// Store original recipe item data, 
// used to calculate ingredients for variants
@addField(CraftingLogicController)
private let originalItemData: ref<gameItemData>;
