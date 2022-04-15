module EnhancedCraft.Craft
import EnhancedCraft.Common.L
import EnhancedCraft.Config.*


@replaceMethod(CraftingLogicController)
private final func CraftItem(selectedRecipe: ref<RecipeData>, amount: Int32) -> Void {
  let craftItemRequest: ref<CraftItemRequest>;
  if NotEquals(selectedRecipe.label, "") {
    craftItemRequest = new CraftItemRequest();
    craftItemRequest.target = this.m_craftingGameController.GetPlayer();
    if Config.RandomizerEnabled() && ArraySize(this.m_weaponVariants) > 1 {
      craftItemRequest.itemRecord = this.GetRandomVariant();
    } else {
      craftItemRequest.itemRecord = selectedRecipe.id;
    };
    craftItemRequest.amount = amount;
    if selectedRecipe.id.TagsContains(n"Ammo") {
      craftItemRequest.bulletAmount = selectedRecipe.amount;
    };
    this.m_craftingSystem.QueueRequest(craftItemRequest);
  };
}

@wrapMethod(CraftingSystem)
private final func CraftItem(target: wref<GameObject>, itemRecord: ref<Item_Record>, amount: Int32, opt ammoBulletAmount: Int32) -> wref<gameItemData> {
  let craftedItem: wref<gameItemData> = wrappedMethod(target, itemRecord, amount, ammoBulletAmount);
  L(s"TRYING TO CRAFT: \(TDBID.ToStringDEBUG(itemRecord.GetID())) with quality \(itemRecord.Quality().Type()), IS CUSTOM: \(itemRecord.m_isCustomVariant), base: \(itemRecord.m_originalQuality)");
  if itemRecord.m_isCustomVariant {
    this.ScaleItemData(craftedItem, itemRecord.m_originalQuality);
  };
  L(s"CRAFTED: \(TDBID.ToStringDEBUG(ItemID.GetTDBID(craftedItem.GetID()))) \(RPGManager.GetItemDataQuality(craftedItem))");
  return craftedItem;
}

@addMethod(CraftingSystem)
private final func ScaleItemData(itemData: ref<gameItemData>, quality: CName) -> Void {
  let player: ref<GameObject> = GetPlayer(this.GetGameInstance());
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let powerLevelPlayer: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PowerLevel);
  let powerLevelItem: Float = itemData.GetStatValueByType(gamedataStatType.PowerLevel);
  let powerLevelMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.PowerLevel, gameStatModifierType.Additive, powerLevelPlayer);
  let qualityMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.Quality, gameStatModifierType.Additive, RPGManager.ItemQualityNameToValue(quality));
  statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.Quality);
  statsSystem.AddModifier(itemData.GetStatsObjectID(), qualityMod);
  statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
  statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), powerLevelMod);
  RPGManager.ForceItemQuality(player, itemData, quality);
}
