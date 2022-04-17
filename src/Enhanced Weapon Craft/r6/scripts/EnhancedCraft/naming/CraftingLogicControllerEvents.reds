module EnhancedCraft.Naming
import EnhancedCraft.Common.*
import EnhancedCraft.Events.*

@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  wrappedMethod(craftableController);
  let recipe: ref<RecipeData> = FromVariant<ref<IScriptable>>(craftableController.GetData()) as RecipeData;
  let player: wref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let event: ref<EnhancedCraftRecipeClicked> = new EnhancedCraftRecipeClicked();
  event.isWeapon = Equals(recipe.inventoryItem.EquipmentArea, gamedataEquipmentArea.Weapon);
  GameInstance.GetUISystem(player.GetGame()).QueueEvent(event);
  L("--- Event launched");
}
