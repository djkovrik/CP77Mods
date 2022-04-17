module EnhancedCraft.Naming
import EnhancedCraft.Codeware.UI.*
import EnhancedCraft.Events.*
import EnhancedCraft.System.*

@addMethod(CraftingMainGameController)
protected cb func OnEnhancedCraftRecipeClickedEvent(event: ref<EnhancedCraftRecipeClicked>) -> Bool {
  this.m_nameInput.SetText("");
	this.m_nameInputContainer.SetVisible(event.isWeapon);
}

@addMethod(CraftingMainGameController)
protected cb func OnEnhancedCraftRecipeCraftedEvent(event: ref<EnhancedCraftRecipeCrafted>) -> Bool {
  let name: String;
  let itemId: ItemID;
  let system: ref<EnhancedCraftSystem>;
  let inputText: String = this.m_nameInput.GetText();
  if event.isWeapon && NotEquals(inputText, "") {
    system = EnhancedCraftSystem.GetInstance(this.m_player.GetGame());
    itemId = event.itemId;
    name = this.m_nameInput.GetText();
    system.AddCustomName(itemId, name);
    system.RefreshStoredNames();
  };
  this.m_nameInput.SetText("");
  this.RestoreOriginalName();
}

@addMethod(CraftingMainGameController)
public func RestoreOriginalName() -> Bool {
  let text: String = this.m_nameInput.GetText();
  let originalName: String = this.m_craftingLogicController.originalRecipe.label;
	this.m_weaponName.SetText(originalName);
}
