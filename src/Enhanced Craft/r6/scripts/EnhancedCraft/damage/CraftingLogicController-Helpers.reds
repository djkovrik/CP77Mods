module EnhancedCraft.Damage
import EnhancedCraft.Config.ECraftConfig
import EnhancedCraft.Common.*

// -- Check if weapon damage type selection available to player
@addMethod(CraftingLogicController)
public func CanSelectDamageType() -> Bool {
  if !this.ecraftConfig.customizedDamageEnabled {
    return false;
  };

  let player: ref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let canCraftRare: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftRareItems) > 0.0;
  let canCraftEpic: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftEpicItems) > 0.0;
  let canCraftLegendary: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftLegendaryItems) > 0.0;
  let configValue: Int32 = EnumInt(this.ecraftConfig.perkToUnlockDamageTypes);
  let canSelect: Bool = Equals(configValue, 1) || (canCraftRare && Equals(configValue, 2)) || (canCraftEpic && Equals(configValue, 3)) || (canCraftLegendary && Equals(configValue, 4));
  return canSelect;
}


// -- Pass custom damage selection availability from crafting panel down to ItemTooltipRecipeDataModule

@replaceMethod(CraftingLogicController)
protected cb func OnItemTooltipSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  this.m_itemTooltipController = widget.GetController() as AGenericTooltipController;
  let controller: ref<ItemTooltipCommonController> = this.m_itemTooltipController as ItemTooltipCommonController;
  if IsDefined(controller) {
    controller.m_damageSelectionAvailable = this.CanSelectDamageType();
  };
  this.m_itemTooltipController.SetData(this.m_tooltipData);
  if this.m_quickHackTooltipController != null {
    this.m_quickHackTooltipController.GetRootWidget().SetVisible(false);
  };
}

@replaceMethod(ItemTooltipCommonController)
protected cb func OnRecipeDataModuleSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
  this.m_itemRecipeDataController = widget.GetController() as ItemTooltipRecipeDataModule;
  this.m_itemRecipeDataController.m_damageSelectionAvailable = this.m_damageSelectionAvailable;
  this.HandleModuleSpawned(widget, userData as ItemTooltipModuleSpawnedCallbackData);
  this.UpdateRecipeDataModule();
}
