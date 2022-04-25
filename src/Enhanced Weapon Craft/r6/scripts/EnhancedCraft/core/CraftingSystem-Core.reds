module EnhancedCraft.Core
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*
import EnhancedCraft.Events.*
import EnhancedCraft.System.*

@wrapMethod(CraftingSystem)
private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
  wrappedMethod(request);
  this.m_playerPuppet = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
}

@wrapMethod(CraftingSystem)
private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
  this.m_playerPuppet = null;
  wrappedMethod(request);
}

// -- Redirect custom requests to CraftItemEnhanced
@replaceMethod(CraftingSystem)
private final func OnCraftItemRequest(request: ref<CraftItemRequest>) -> Void {
  let craftedItem: wref<gameItemData>;
  this.m_requestedDamageType = request.selectedDamageType;
  if request.custom {
    craftedItem = this.CraftItemEnhanced(request.target, request.itemRecord, request.amount, request.originalIngredients, request.quantityMultiplier, request.originalQuality);
  } else {
    craftedItem = this.CraftItem(request.target, request.itemRecord, request.amount, request.bulletAmount);
  };
  this.UpdateBlackboard(CraftingCommands.CraftingFinished, craftedItem.GetID());
}

@addMethod(CraftingSystem)
private func SwitchCraftedWeaponType(craftedItem: ref<gameItemData>) -> Void {
  if NotEquals(this.m_requestedDamageType, gamedataStatType.Invalid) {
    let stats: ref<DamageTypeStats> = this.m_playerPuppet.GetCraftedWeaponDamageStats(craftedItem, this.m_requestedDamageType);
    EnhancedCraftSystem.GetInstance(this.m_playerPuppet.GetGame()).AddCustomDamageType(craftedItem.GetID(), stats);
    this.m_playerPuppet.SwitchDamageTypeToChosen(craftedItem, this.m_requestedDamageType);
  };
}

// -- Log crafting result for normal requests and launch crafting completion event
@wrapMethod(CraftingSystem)
private final func CraftItem(target: wref<GameObject>, itemRecord: ref<Item_Record>, amount: Int32, opt ammoBulletAmount: Int32) -> wref<gameItemData> {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.m_playerPuppet.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let craftedItem: wref<gameItemData> = wrappedMethod(target, itemRecord, amount, ammoBulletAmount);
  L(s"CRAFTED NORMAL: \(craftedItem.GetID()) \(TDBID.ToStringDEBUG(ItemID.GetTDBID(craftedItem.GetID()))) \(RPGManager.GetItemDataQuality(craftedItem))");
  // Notify that item was crafted
  let event: ref<EnhancedCraftRecipeCrafted> = new EnhancedCraftRecipeCrafted();
  event.isWeapon = Equals(RPGManager.GetItemCategory(craftedItem.GetID()), gamedataItemCategory.Weapon);
  event.itemId = craftedItem.GetID();
  this.SwitchCraftedWeaponType(craftedItem);
  GameInstance.GetUISystem(player.GetGame()).QueueEvent(event);
  return craftedItem;
}

// -- Handle custom variants crafting
//    Copy-Pasted from CraftItem with ingredients, multiplier and quality additions
//    Scaling replaced with our own ScaleCraftedItemData (which works the same way)
@addMethod(CraftingSystem)
private final func CraftItemEnhanced(target: wref<GameObject>, itemRecord: ref<Item_Record>, amount: Int32, ingredients: array<IngredientData>, multiplier: Int32, quality: CName) -> wref<gameItemData> {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.m_playerPuppet.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let craftedItemID: ItemID;
  let i: Int32;
  let ingredient: ItemID;
  let ingredientQuality: gamedataQuality;
  let ingredientRecords: array<wref<RecipeElement_Record>>;
  let itemData: wref<gameItemData>;
  let j: Int32;
  let recipeXP: Int32;
  let requiredIngredients: array<IngredientData>;
  let savedAmount: Int32;
  let savedAmountLocked: Bool;
  let tempStat: Float;
  let xpID: TweakDBID;
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
  itemRecord.CraftingData().CraftingRecipe(ingredientRecords);
  // Required ingredients replaced with original recipe ingredients from custom request
  requiredIngredients = ingredients;
  i = 0;
  while i < ArraySize(requiredIngredients) {
    ingredient = ItemID.CreateQuery(requiredIngredients[i].id.GetID());
    if RPGManager.IsItemWeapon(ingredient) || RPGManager.IsItemClothing(ingredient) {
      itemData = transactionSystem.GetItemData(target, ingredient);
      if IsDefined(itemData) && itemData.HasTag(n"Quest") {
        itemData.RemoveDynamicTag(n"Quest");
      };
      this.ClearNonIconicSlots(itemData);
    } else {
      i += 1;
    };
  };
  tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.CraftingMaterialRetrieveChance);
  savedAmount = 0;
  i = 0;
  while i < ArraySize(requiredIngredients) {
    ingredient = ItemID.CreateQuery(requiredIngredients[i].id.GetID());
    if RPGManager.IsItemWeapon(ingredient) || RPGManager.IsItemClothing(ingredient) {
    } else {
      if tempStat > 0.00 && !savedAmountLocked {
        j = 0;
        while j < amount {
          if RandF() < tempStat {
            savedAmount += 1;
          };
          j += 1;
        };
        savedAmountLocked = true;
      };
    };
    // Added multiplier to handle increased Iconics crafting cost
    transactionSystem.RemoveItem(target, ingredient, requiredIngredients[i].quantity * (amount - savedAmount) * multiplier);
    ingredientQuality = RPGManager.GetItemQualityFromRecord(TweakDBInterface.GetItemRecord(requiredIngredients[i].id.GetID()));
    switch ingredientQuality {
      case gamedataQuality.Common:
        xpID = t"Constants.CraftingSystem.commonIngredientXP";
        break;
      case gamedataQuality.Uncommon:
        xpID = t"Constants.CraftingSystem.uncommonIngredientXP";
        break;
      case gamedataQuality.Rare:
        xpID = t"Constants.CraftingSystem.rareIngredientXP";
        break;
      case gamedataQuality.Epic:
        xpID = t"Constants.CraftingSystem.epicIngredientXP";
        break;
      case gamedataQuality.Legendary:
        xpID = t"Constants.CraftingSystem.legendaryIngredientXP";
        break;
      default:
    };
    recipeXP += TweakDBInterface.GetInt(xpID, 0) * requiredIngredients[i].baseQuantity * amount;
    i += 1;
  };
  craftedItemID = ItemID.FromTDBID(itemRecord.GetID());
  transactionSystem.GiveItem(target, craftedItemID, amount);
  itemData = transactionSystem.GetItemData(target, craftedItemID);
  this.SetItemLevel(itemData);
  this.SetItemQualityBasedOnPlayerSkill(itemData);
  this.MarkItemAsCrafted(itemData);
  this.SendItemCraftedDataTrackingRequest(craftedItemID);
  this.ProcessCraftSkill(Cast<Float>(recipeXP));
  player.ScaleCraftedItemData(itemData, quality);
  L(s"CRAFTED CUSTOM: \(itemData.GetID()) \(TDBID.ToStringDEBUG(ItemID.GetTDBID(itemData.GetID()))) \(RPGManager.GetItemDataQuality(itemData))");
  // Notify that item was crafted
  let event: ref<EnhancedCraftRecipeCrafted> = new EnhancedCraftRecipeCrafted();
  event.isWeapon = Equals(RPGManager.GetItemCategory(itemData.GetID()), gamedataItemCategory.Weapon);
  event.itemId = itemData.GetID();
  this.SwitchCraftedWeaponType(itemData);
  GameInstance.GetUISystem(player.GetGame()).QueueEvent(event);
  return itemData;
}
