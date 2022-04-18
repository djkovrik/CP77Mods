module EnhancedCraft.Events

public class EnhancedCraftRecipeClicked extends Event {
  public let isWeapon: Bool;
}

public class EnhancedCraftRecipeCrafted extends EnhancedCraftRecipeClicked {
  public let itemId: ItemID;
}
