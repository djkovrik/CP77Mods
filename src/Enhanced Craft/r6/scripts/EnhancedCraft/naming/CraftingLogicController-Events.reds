module EnhancedCraft.Naming
import EnhancedCraft.Common.*
import EnhancedCraft.Events.*

// -- Launches EnhancedCraftRecipeClicked event which triggers custom name input text visibility refresh
@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  wrappedMethod(craftableController);
  let recipe: ref<RecipeData> = FromVariant<ref<IScriptable>>(craftableController.GetData()) as RecipeData;
  let player: wref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let event: ref<EnhancedCraftRecipeClicked> = new EnhancedCraftRecipeClicked();
  event.isWeapon = Equals(recipe.inventoryItem.EquipmentArea, gamedataEquipmentArea.Weapon);
  GameInstance.GetUISystem(player.GetGame()).QueueEvent(event);
}
