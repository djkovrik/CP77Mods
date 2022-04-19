module EnhancedCraft.Common

// -- CraftingLogicController

// Stores loaded weapon variants from TweakXL
@addField(CraftingLogicController)
private let weaponVariants: array<TweakDBID>;

// Same variants but with excluded Iconics
@addField(CraftingLogicController)
private let weaponVariantsNoIconic: array<TweakDBID>;

// Stores current weapon variant index
@addField(CraftingLogicController)
private let weaponIndex: Int32;

// Is currently selected variant not original
@addField(CraftingLogicController)
private let alternateSkinSelected: Bool;

// Is currently selected variant Iconic
@addField(CraftingLogicController)
private let iconicSelected: Bool;

// Stores original recipe
@addField(CraftingLogicController)
private let originalRecipe: ref<RecipeData>;

// Stores original recipe quality
@addField(CraftingLogicController)
private let originalRecipeQuality: CName;

// Stores original recipe item data
// Used to calculate ingredients for variants
@addField(CraftingLogicController)
private let originalItemData: ref<gameItemData>;

// Stores original recipe
@addField(CraftingLogicController)
private let currentItemRecord: ref<Item_Record>;

// -- CraftItemRequest

// Custom crafting request flag
@addField(CraftItemRequest)
public let custom: Bool;

// Store ingredients from original recipe
@addField(CraftItemRequest)
public let originalIngredients: array<IngredientData>;

// Store quality from original recipe
@addField(CraftItemRequest)
public let originalQuality: CName;

// Store multiplier for ingredients quantity
@addField(CraftItemRequest)
public let quantityMultiplier: Int32;


// -- gameItemData

// Signals that item data has custom name
@addField(gameItemData)
public let hasCustomName: Bool;

// Custom item name
@addField(gameItemData)
public let customName: String;


// -- CraftingSystem

// Weak ref to player puppet
@addField(CraftingSystem)
private let m_playerPuppet: wref<PlayerPuppet>;
