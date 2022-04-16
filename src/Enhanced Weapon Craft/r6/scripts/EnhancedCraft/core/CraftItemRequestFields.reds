module EnhancedCraft.Core

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
