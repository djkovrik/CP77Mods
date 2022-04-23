module EnhancedCraft.Events

public class EnhancedCraftRecipeClicked extends Event {
  public let isWeapon: Bool;
}

public class EnhancedCraftRecipeCrafted extends EnhancedCraftRecipeClicked {
  public let itemId: ItemID;
}

public class EnhancedCraftDamageTypeClicked extends Event {
  public let damageType: gamedataStatType;
}
