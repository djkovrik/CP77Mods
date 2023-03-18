module EnhancedCraft.Common
import EnhancedCraft.Config.ECraftConfig

// -- CraftingMainLogicController
@addField(CraftingMainLogicController)
public let m_selectedRecipeVariants: array<ref<RecipeData>>;

@addField(CraftingMainLogicController)
public let m_selectedRecipeVariantsNoIconics: array<ref<RecipeData>>;

@addField(CraftingMainLogicController)
public let m_isClothesSelected: Bool;

@addField(CraftingMainLogicController)
public let m_isWeaponSelected: Bool;


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


// -- CraftingLogicController

// Stores current weapon variant index
@addField(CraftingLogicController)
private let selectedItemIndex: Int32;

// // Stores current clothes variant index
// @addField(CraftingLogicController)
// private let clothesIndex: Int32;

// // Is currently selected variant not original
// @addField(CraftingLogicController)
// private let alternateSkinSelected: Bool;

// Is currently selected variant Iconic
@addField(CraftingLogicController)
private let iconicSelected: Bool;

// Stores currently selected damage type
@addField(CraftingLogicController)
private let currentDamageType: gamedataStatType;

@addField(CraftingLogicController)
private let ecraftConfig: ref<ECraftConfig>;


// -- CraftItemRequest

// Store multiplier for ingredients quantity
@addField(CraftItemRequest)
public let selectedDamageType: gamedataStatType;


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
private let m_chemicalDamageItem: wref<ItemTooltipStatController>;

// Ref to electrical damage item
@addField(ItemTooltipRecipeDataModule)
private let m_electricalDamageItem: wref<ItemTooltipStatController>;

// Ref to physical damage item
@addField(ItemTooltipRecipeDataModule)
private let m_physicalDamageItem: wref<ItemTooltipStatController>;

// Ref to thermal damage item
@addField(ItemTooltipRecipeDataModule)
private let m_thermalDamageItem: wref<ItemTooltipStatController>;

// Service flag for HUD init state
@addField(ItemTooltipRecipeDataModule)
private let m_shouldDisplayHud: Bool;

// Stores damage selection availability state
@addField(ItemTooltipRecipeDataModule)
private let m_damageSelectionAvailable: Bool;

// Stores settings flag
@addField(ItemTooltipRecipeDataModule)
private let m_settingsDamageEnabled: Bool;

// -- CraftingGarmentItemPreviewGameController

@addField(CraftingGarmentItemPreviewGameController)
private let m_preview: wref<inkWidget>;

@addField(CraftingGarmentItemPreviewGameController)
private let m_isHoveredByCursor: Bool;


// -- WardrobeSetPreviewGameController

@addField(WardrobeSetPreviewGameController)
private let m_isMouseDownECraft: Bool;
