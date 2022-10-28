module EnhancedCraft.Events

public class EnhancedCraftRecipeClicked extends Event {
  public let isClothes: Bool;
  public let isWeapon: Bool;
}

public class EnhancedCraftRecipeCrafted extends EnhancedCraftRecipeClicked {
  public let itemId: ItemID;
}

public class EnhancedCraftDamageTypeClicked extends Event {
  public let damageType: gamedataStatType;
}

public class EnhancedCraftRecipeVariantChanged extends Event {}
