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

// Stores currently selected damage type
@addField(CraftingLogicController)
private let currentDamageType: gamedataStatType;


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

// Store multiplier for ingredients quantity
@addField(CraftItemRequest)
public let selectedDamageType: gamedataStatType;


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

// Stores damage type selected in crafting menu
@addField(CraftingSystem)
private let m_requestedDamageType: gamedataStatType;


// -- ItemTooltipCommonController

// Service flag for HUD init state
@addField(ItemTooltipCommonController)
private let m_damageSelectionAvailable: Bool;


// -- ItemTooltipStatController

// Stores damage type selected in crafting menu
@addField(ItemTooltipStatController)
public let m_damageType: gamedataStatType;


// -- ItemTooltipRecipeDataModule

// Stores selected damage type 
@addField(ItemTooltipRecipeDataModule)
public let m_selectedDamageType: gamedataStatType;

// Ref to crafting menu damage preview container title
@addField(ItemTooltipRecipeDataModule)
private let m_damagesTitle: ref<inkText>;

// Ref to chemical damage item
@addField(ItemTooltipRecipeDataModule)
private let m_chemicalDamageItem: ref<ItemTooltipStatController>;

// Ref to electrical damage item
@addField(ItemTooltipRecipeDataModule)
private let m_electricalDamageItem: ref<ItemTooltipStatController>;

// Ref to physical damage item
@addField(ItemTooltipRecipeDataModule)
private let m_physicalDamageItem: ref<ItemTooltipStatController>;

// Ref to thermal damage item
@addField(ItemTooltipRecipeDataModule)
private let m_thermalDamageItem: ref<ItemTooltipStatController>;

// Service flag for HUD init state
@addField(ItemTooltipRecipeDataModule)
private let m_shouldDisplayHud: Bool;

// Stores damage selection availability state
@addField(ItemTooltipRecipeDataModule)
private let m_damageSelectionAvailable: Bool;
