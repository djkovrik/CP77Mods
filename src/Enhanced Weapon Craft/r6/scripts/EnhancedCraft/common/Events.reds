module EnhancedCraft.Events

public class EnhancedCraftRecipeClicked extends Event {
  public let isWeapon: Bool;
}

public class EnhancedCraftRecipeCrafted extends Event {
  public let isWeapon: Bool;
  public let itemId: ItemID;
}

public class EnhancedCraftTextInput extends Event {
  public let text: Bool;
}
