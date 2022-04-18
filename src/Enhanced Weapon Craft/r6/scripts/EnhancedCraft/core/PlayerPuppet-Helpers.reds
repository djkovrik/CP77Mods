module EnhancedCraft.Core

// -- Helper function to scale custom variant data to player level and original recipe quality
//    Used for crafted item and for crafting panel item preview so stats will match
@addMethod(PlayerPuppet)
private final func ScaleCraftedItemData(itemData: ref<gameItemData>, quality: CName) -> Void {
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
  let qualityMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.Quality, gameStatModifierType.Additive, RPGManager.ItemQualityNameToValue(quality));
  statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.Quality);
  statsSystem.AddModifier(itemData.GetStatsObjectID(), qualityMod);
  RPGManager.ForceItemQuality(this, itemData, quality);
}
