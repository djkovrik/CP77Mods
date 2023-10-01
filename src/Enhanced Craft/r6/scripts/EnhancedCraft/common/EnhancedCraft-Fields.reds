module EnhancedCraft.Common
import EnhancedCraft.Config.ECraftConfig

// -- CraftingMainLogicController
@addField(CraftingMainLogicController)
public let m_selectedRecipeVariants: array<ref<RecipeData>>;

@addField(CraftingMainLogicController)
public let m_selectedRecipeVariantsNoIconics: array<ref<RecipeData>>;

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


// -- CraftingLogicController

// Stores current weapon variant index
@addField(CraftingLogicController)
private let selectedItemIndex: Int32;

// Is currently selected variant Iconic
@addField(CraftingLogicController)
private let iconicSelected: Bool;

@addField(CraftingLogicController)
private let ecraftConfig: ref<ECraftConfig>;


// -- CraftingGarmentItemPreviewGameController

@addField(CraftingGarmentItemPreviewGameController)
private let m_preview: wref<inkWidget>;

@addField(CraftingGarmentItemPreviewGameController)
private let m_isHoveredByCursor: Bool;


// -- WardrobeSetPreviewGameController

@addField(WardrobeSetPreviewGameController)
private let m_isMouseDownECraft: Bool;
